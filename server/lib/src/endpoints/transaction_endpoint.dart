import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/classification_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Operations of an account: list, manual entry, corrections, checking,
/// trash, and rules created from a correction.
class TransactionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  static const _maxPage = 500;

  Future<TransactionPage> list(
    Session session,
    int accountId, {
    DateTime? from,
    DateTime? to,
    String? search,
    int? categoryId,
    bool? toClassify,
    bool? uncleared,
    int? limit,
    int? offset,
  }) async {
    await Access.requireAccount(session, accountId);
    final pattern = _likePattern(search);
    Expression where(BankTransactionTable t) {
      Expression e = t.accountId.equals(accountId) & t.deletedAt.equals(null);
      if (from != null) e = e & (t.date >= _day(from));
      if (to != null) e = e & (t.date <= _day(to));
      if (categoryId != null) e = e & t.categoryId.equals(categoryId);
      if (toClassify == true) e = e & t.categoryId.equals(null);
      if (uncleared == true) e = e & t.cleared.equals(false);
      if (pattern != null) {
        e =
            e &
            (t.rawLabel.ilike(pattern) |
                t.cleanLabel.ilike(pattern) |
                t.memo.ilike(pattern));
      }
      return e;
    }

    final total = await BankTransaction.db.count(session, where: where);
    final items = await BankTransaction.db.find(
      session,
      where: where,
      orderByList: (t) => [t.date.desc(), t.id.desc()],
      limit: (limit ?? 100).clamp(1, _maxPage),
      offset: (offset ?? 0).clamp(0, 1 << 30),
    );
    return TransactionPage(items: items, total: total);
  }

  /// Manual entry (cash, a cheque not yet on the statement…). Classified by
  /// the rules unless a category is given.
  Future<BankTransaction> create(
    Session session,
    int accountId,
    DateTime date,
    int amountCents,
    String label, {
    String? memo,
    int? categoryId,
  }) async {
    final account = await Access.requireAccount(
      session,
      accountId,
      write: true,
    );
    final text = _label(label);
    _amount(amountCents);
    if (categoryId != null) {
      await _ownCategory(session, account.groupId, categoryId);
    }
    final cleaned = core.cleanCaisseEpargneLabel(text);
    var source = CategorySource.manual;
    String? ruleRef;
    var category = categoryId;
    if (category == null) {
      final c = (await ClassificationService.forGroup(
        session,
        account.groupId,
      )).classify(cleaned, amountCents);
      category = c.categoryId;
      source = ClassificationService.toDb(c.source);
      ruleRef = c.ruleId?.toString();
    }
    final saved = await BankTransaction.db.insertRow(
      session,
      BankTransaction(
        accountId: accountId,
        date: _day(date),
        amountCents: amountCents,
        rawLabel: text,
        memo: memo?.trim().isEmpty ?? true ? null : memo!.trim(),
        cleanLabel: cleaned.display,
        operationKind: cleaned.kind.name,
        categoryId: category,
        categorySource: source,
        categoryRuleRef: ruleRef,
        createdBy: Access.userId(session),
      ),
    );
    await _audit(session, account, 'create', saved.id, after: saved);
    return saved;
  }

  /// Date, amount and label can only be changed on manual entries: imported
  /// operations keep what the bank wrote. The memo can always be changed.
  Future<BankTransaction> update(
    Session session,
    int transactionId, {
    DateTime? date,
    int? amountCents,
    String? label,
    String? memo,
  }) async {
    final (t, account) = await _find(session, transactionId);
    final imported = t.importId != null;
    if (imported && (date != null || amountCents != null || label != null)) {
      throw InvalidInputException(code: 'imported_operation_locked');
    }
    if (amountCents != null) _amount(amountCents);
    final text = label == null ? null : _label(label);
    final cleaned = text == null ? null : core.cleanCaisseEpargneLabel(text);
    final updated = await BankTransaction.db.updateRow(
      session,
      t.copyWith(
        date: date == null ? null : _day(date),
        amountCents: amountCents,
        rawLabel: text,
        cleanLabel: cleaned?.display,
        operationKind: cleaned?.kind.name,
        memo: memo == null
            ? t.memo
            : (memo.trim().isEmpty ? null : memo.trim()),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, account, 'update', t.id, before: t, after: updated);
    return updated;
  }

  /// The user's choice; `null` puts the operation back to "to classify".
  Future<BankTransaction> setCategory(
    Session session,
    int transactionId,
    int? categoryId,
  ) async {
    final (t, account) = await _find(session, transactionId);
    if (categoryId != null) {
      await _ownCategory(session, account.groupId, categoryId);
    }
    final updated = await BankTransaction.db.updateRow(
      session,
      t.copyWith(
        categoryId: categoryId,
        categorySource: categoryId == null
            ? CategorySource.none
            : CategorySource.manual,
        categoryRuleRef: null,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(
      session,
      account,
      'set_category',
      t.id,
      before: t,
      after: updated,
    );
    return updated;
  }

  Future<BankTransaction> setCleared(
    Session session,
    int transactionId,
    bool cleared,
  ) async {
    final (t, account) = await _find(session, transactionId);
    final updated = await BankTransaction.db.updateRow(
      session,
      t.copyWith(cleared: cleared, updatedAt: DateTime.now().toUtc()),
    );
    await _audit(session, account, 'set_cleared', t.id);
    return updated;
  }

  /// Moves the operation to the trash (kept 30 days).
  Future<void> trash(Session session, int transactionId) async {
    final (t, account) = await _find(session, transactionId);
    final now = DateTime.now().toUtc();
    await BankTransaction.db.updateRow(
      session,
      t.copyWith(
        deletedAt: now,
        fingerprint: null,
        trashedFingerprint: t.fingerprint,
        updatedAt: now,
      ),
    );
    await _audit(session, account, 'trash', t.id, before: t);
  }

  Future<BankTransaction> restore(Session session, int transactionId) async {
    final t = await BankTransaction.db.findById(session, transactionId);
    if (t == null || t.deletedAt == null) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    final account = await _account(session, t, write: true);
    final fp = t.trashedFingerprint;
    if (fp != null &&
        await BankTransaction.db.count(
              session,
              where: (x) =>
                  x.accountId.equals(t.accountId) & x.fingerprint.equals(fp),
            ) >
            0) {
      // The same operation was imported again in the meantime.
      throw InvalidInputException(code: 'already_imported_again');
    }
    final restored = await BankTransaction.db.updateRow(
      session,
      t.copyWith(
        deletedAt: null,
        fingerprint: fp,
        trashedFingerprint: null,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, account, 'restore', t.id, after: restored);
    return restored;
  }

  /// "Always classify like this": a group rule on the cleaned label, in the
  /// direction of the operation, applied at once to the operations of the
  /// group not classified by hand.
  Future<RuleApplication> createRuleFrom(
    Session session,
    int transactionId,
    int categoryId, {
    RuleMatchType? matchType,
  }) async {
    final (t, account) = await _find(session, transactionId);
    await _ownCategory(session, account.groupId, categoryId);
    final pattern = core.normalizeForMatch(t.cleanLabel);
    if (pattern.isEmpty) {
      throw InvalidInputException(code: 'invalid_pattern', field: 'pattern');
    }
    final type = matchType ?? RuleMatchType.startsWith;
    final rule = await Rule.db.insertRow(
      session,
      Rule(
        groupId: account.groupId,
        categoryId: categoryId,
        matchType: type,
        pattern: pattern,
        direction: t.amountCents < 0
            ? RuleDirection.debit
            : RuleDirection.credit,
        createdBy: Access.userId(session),
      ),
    );
    final matcher = core.GroupRule<int>(
      id: rule.id!,
      categoryId: categoryId,
      pattern: pattern,
      matchType: core.MatchType.values.byName(type.name),
      direction: core.Direction.values.byName(rule.direction.name),
    );
    final visible = await Access.visibleAccounts(session, account.groupId);
    final Set<int> ids = {for (final a in visible) a.id!};
    final candidates = await BankTransaction.db.find(
      session,
      where: (x) =>
          x.accountId.inSet(ids) &
          x.deletedAt.equals(null) &
          x.categorySource.notEquals(CategorySource.manual),
    );
    final now = DateTime.now().toUtc();
    final changed = [
      for (final x in candidates)
        if (matcher.matches(
          core.CleanedLabel(
            x.cleanLabel,
            core.normalizeForMatch('${x.rawLabel} ${x.memo ?? ''}'),
            core.OperationKind.other,
          ),
          x.amountCents,
        ))
          x.copyWith(
            categoryId: categoryId,
            categorySource: CategorySource.groupRule,
            categoryRuleRef: '${rule.id}',
            updatedAt: now,
          ),
    ];
    // The corrected operation itself is the user's explicit choice.
    await BankTransaction.db.updateRow(
      session,
      t.copyWith(
        categoryId: categoryId,
        categorySource: CategorySource.manual,
        categoryRuleRef: null,
        updatedAt: now,
      ),
    );
    final others = [
      for (final x in changed)
        if (x.id != t.id) x,
    ];
    if (others.isNotEmpty) await BankTransaction.db.update(session, others);
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'create_from_correction',
      entity: 'rule',
      rowId: rule.id,
      after: rule,
    );
    return RuleApplication(rule: rule, reclassifiedCount: others.length);
  }

  // --- helpers --------------------------------------------------------------

  static Future<(BankTransaction, Account)> _find(
    Session session,
    int id,
  ) async {
    final t = await BankTransaction.db.findById(session, id);
    if (t == null || t.deletedAt != null) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    return (t, await _account(session, t, write: true));
  }

  static Future<Account> _account(
    Session session,
    BankTransaction t, {
    required bool write,
  }) async {
    try {
      return await Access.requireAccount(session, t.accountId, write: write);
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
  }

  static Future<void> _ownCategory(
    Session session,
    int groupId,
    int categoryId,
  ) async {
    final c = await Category.db.findById(session, categoryId);
    if (c == null || c.groupId != groupId || c.deletedAt != null) {
      throw AccessDeniedException(code: 'category_access_denied');
    }
  }

  static Future<void> _audit(
    Session session,
    Account account,
    String action,
    int? id, {
    BankTransaction? before,
    BankTransaction? after,
  }) => Audit.log(
    session,
    groupId: account.groupId,
    action: action,
    entity: 'transaction',
    rowId: id,
    before: before,
    after: after,
  );

  static DateTime _day(DateTime d) {
    final u = d.toUtc();
    return core.LocalDate(u.year, u.month, u.day).toDb();
  }

  static String _label(String label) {
    final t = label.trim();
    if (t.isEmpty || t.length > 200) {
      throw InvalidInputException(code: 'invalid_name', field: 'label');
    }
    return t;
  }

  static void _amount(int cents) {
    if (cents == 0 || cents.abs() > 100000000000000) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
  }

  /// `%text%` with LIKE wildcards escaped, or null for an empty search.
  static String? _likePattern(String? search) {
    final s = search?.trim() ?? '';
    if (s.isEmpty) return null;
    final escaped = s
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
    return '%$escaped%';
  }
}
