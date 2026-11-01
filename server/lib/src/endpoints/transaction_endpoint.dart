import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/alert_service.dart';
import '../finance/classification_service.dart';
import '../finance/goal_alert_service.dart';
import '../finance/spending_service.dart';
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
    String? sameLabel,
    int? categoryId,
    bool? includeSubcategories,
    bool? toClassify,
    bool? uncleared,
    bool? subscriptions,
    int? limit,
    int? offset,
  }) async {
    final account = await Access.requireAccount(session, accountId);
    final pattern = _likePattern(search);
    // Same provider: same cleaned label (e.g. every `EDF` debit).
    final provider = sameLabel == null || sameLabel.trim().isEmpty
        ? null
        : sameLabel.trim();
    final Set<int> categoryIds = {};
    if (categoryId != null) {
      categoryIds.add(categoryId);
      if (includeSubcategories == true) {
        categoryIds.addAll(
          descendantsOf(
            categoryId,
            await Category.db.find(
              session,
              where: (c) => c.groupId.equals(account.groupId),
            ),
          ),
        );
      }
    }
    final subs = await ScheduledTransaction.db.find(
      session,
      where: (s) =>
          s.accountId.equals(accountId) &
          s.deletedAt.equals(null) &
          s.subscription.equals(true),
      orderBy: (s) => s.label,
    );
    final Set<int> subIds = {for (final s in subs) s.id!};
    if (subscriptions == true && subIds.isEmpty) {
      return TransactionPage(
        items: [],
        total: 0,
        subscriptions: subs,
        withInvoices: [],
      );
    }
    final Set<int> splitIds = await SpendingService.splitTransactionsIn(
      session,
      categoryIds,
    );
    Expression where(BankTransactionTable t) {
      Expression e = t.accountId.equals(accountId) & t.deletedAt.equals(null);
      if (from != null) e = e & (t.date >= _day(from));
      if (to != null) e = e & (t.date <= _day(to));
      if (categoryIds.isNotEmpty) {
        e =
            e &
            (splitIds.isEmpty
                ? t.categoryId.inSet(categoryIds)
                : (t.categoryId.inSet(categoryIds) | t.id.inSet(splitIds)));
      }
      if (provider != null) e = e & t.cleanLabel.equals(provider);
      if (toClassify == true) e = e & t.categoryId.equals(null);
      if (uncleared == true) e = e & t.cleared.equals(false);
      if (subscriptions == true) e = e & t.scheduledId.inSet(subIds);
      if (pattern != null) {
        e =
            e &
            (t.rawLabel.ilike(pattern) |
                t.cleanLabel.ilike(pattern) |
                t.memo.ilike(pattern) |
                t.note.ilike(pattern));
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
    int? sum;
    if (provider != null) {
      final all = await BankTransaction.db.find(session, where: where);
      sum = all.fold<int>(0, (a, t) => a + t.amountCents);
    }
    final Set<int> itemIds = {for (final t in items) t.id!};
    final withInvoices = itemIds.isEmpty
        ? <int>{}
        : {
            for (final i in await Invoice.db.find(
              session,
              where: (i) => i.transactionId.inSet(itemIds),
            ))
              i.transactionId!,
          };
    return TransactionPage(
      items: items,
      total: total,
      amountSumCents: sum,
      subscriptions: subs,
      withInvoices: withInvoices.toList(),
    );
  }

  /// Manual entry (cash, a cheque not yet on the statement…). Classified by
  /// the rules unless a category is given.
  Future<BankTransaction> create(
    Session session,
    int accountId,
    DateTime date,
    int amountCents,
    String label, {
    String? note,
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
        note: note?.trim().isEmpty ?? true ? null : note!.trim(),
        cleanLabel: cleaned.display,
        operationKind: cleaned.kind.name,
        categoryId: category,
        categorySource: source,
        categoryRuleRef: ruleRef,
        createdBy: Access.userId(session),
      ),
    );
    await _audit(session, account, 'create', saved.id, after: saved);
    await AlertService.checkAfterChange(session, account);
    return saved;
  }

  /// Date, amount and label can only be changed on manual entries: imported
  /// operations keep what the bank wrote. The note can always be changed.
  Future<BankTransaction> update(
    Session session,
    int transactionId, {
    DateTime? date,
    int? amountCents,
    String? label,
    String? note,
  }) async {
    final (t, account) = await _find(session, transactionId);
    final imported = t.importId != null;
    if (imported && (date != null || amountCents != null || label != null)) {
      throw InvalidInputException(code: 'imported_operation_locked');
    }
    if (amountCents != null) {
      _amount(amountCents);
      if (amountCents != t.amountCents) await _dropSplits(session, t.id!);
    }
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
        note: note == null
            ? t.note
            : (note.trim().isEmpty ? null : note.trim()),
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
    // One category for the whole operation: no more split.
    await _dropSplits(session, t.id!);
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
    await GoalAlertService.checkAfterChange(session, account.groupId);
    return updated;
  }

  /// Undo of a classification change: puts back the category, its source
  /// and the split the operation had before (as the app saw it).
  Future<BankTransaction> restoreClassification(
    Session session,
    int transactionId,
    int? categoryId,
    CategorySource source,
    String? ruleRef,
    List<TransactionSplit> splits,
  ) async {
    final (t, account) = await _find(session, transactionId);
    if (categoryId != null) {
      await _ownCategory(session, account.groupId, categoryId);
    }
    if (ruleRef != null && ruleRef.length > 64) {
      throw InvalidInputException(code: 'invalid_name', field: 'ruleRef');
    }
    if (splits.isNotEmpty) {
      if (!core.isValidSplit(t.amountCents, [
        for (final p in splits) p.amountCents,
      ])) {
        throw InvalidInputException(code: 'split_invalid');
      }
      for (final p in splits) {
        if (p.categoryId != null) {
          await _ownCategory(session, account.groupId, p.categoryId!);
        }
      }
    }
    final updated = await session.db.transaction((tx) async {
      await TransactionSplit.db.deleteWhere(
        session,
        where: (s) => s.transactionId.equals(t.id!),
        transaction: tx,
      );
      if (splits.isNotEmpty) {
        await TransactionSplit.db.insert(session, [
          for (final p in splits)
            TransactionSplit(
              transactionId: t.id!,
              categoryId: p.categoryId,
              amountCents: p.amountCents,
              note: p.note,
            ),
        ], transaction: tx);
      }
      return BankTransaction.db.updateRow(
        session,
        t.copyWith(
          categoryId: categoryId,
          categorySource: categoryId == null ? CategorySource.none : source,
          categoryRuleRef: ruleRef,
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
    });
    await _audit(
      session,
      account,
      'restore_classification',
      t.id,
      before: t,
      after: updated,
    );
    await GoalAlertService.checkAfterChange(session, account.groupId);
    return updated;
  }

  /// Parts of a split operation (empty when not split).
  Future<List<TransactionSplit>> splits(
    Session session,
    int transactionId,
  ) async {
    final t = await BankTransaction.db.findById(session, transactionId);
    if (t == null || t.deletedAt != null) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    await _account(session, t, write: false);
    return TransactionSplit.db.find(
      session,
      where: (s) => s.transactionId.equals(transactionId),
      orderBy: (s) => s.id,
    );
  }

  /// The other operations of the same provider (same cleaned label) on the
  /// accounts of the group the user may see: the [limit] most recent (10
  /// by default, at most 50), and how many there are in all, with their
  /// total and average.
  Future<ProviderHistory> sameProvider(
    Session session,
    int transactionId, {
    int? limit,
  }) async {
    final t = await BankTransaction.db.findById(session, transactionId);
    if (t == null || t.deletedAt != null) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    final account = await _account(session, t, write: false);
    final Set<int> visible = {
      for (final a in await Access.visibleAccounts(session, account.groupId))
        a.id!,
    };
    final label = t.cleanLabel;
    final all = label.trim().isEmpty
        ? [t]
        : await BankTransaction.db.find(
            session,
            where: (x) =>
                x.accountId.inSet(visible) &
                x.deletedAt.equals(null) &
                x.cleanLabel.equals(label),
            orderByList: (x) => [x.date.desc(), x.id.desc()],
          );
    final total = all.fold<int>(0, (a, x) => a + x.amountCents);
    return ProviderHistory(
      items: [
        for (final x in all)
          if (x.id != t.id) x,
      ].take((limit ?? 10).clamp(1, 50)).toList(),
      count: all.length,
      totalCents: total,
      averageCents: all.isEmpty ? 0 : total ~/ all.length,
      since: all.isEmpty ? null : all.last.date,
    );
  }

  /// Splits the operation between categories (a receipt: groceries,
  /// household…): at least two parts of its sign adding up to its amount.
  /// The operation shows the category of its largest part and counts as
  /// classified by hand. An empty list removes the split.
  Future<BankTransaction> setSplits(
    Session session,
    int transactionId,
    List<TransactionSplit> parts,
  ) async {
    final (t, account) = await _find(session, transactionId);
    if (parts.isEmpty) {
      await _dropSplits(session, t.id!);
      await _audit(session, account, 'unsplit', t.id, before: t, after: t);
      return t;
    }
    if (parts.length > 20 ||
        !core.isValidSplit(t.amountCents, [
          for (final p in parts) p.amountCents,
        ])) {
      throw InvalidInputException(code: 'split_invalid');
    }
    for (final p in parts) {
      if (p.categoryId != null) {
        await _ownCategory(session, account.groupId, p.categoryId!);
      }
      final note = p.note?.trim();
      if (note != null && note.length > 200) {
        throw InvalidInputException(code: 'invalid_name', field: 'note');
      }
    }
    final largest = parts.reduce(
      (a, b) => a.amountCents.abs() >= b.amountCents.abs() ? a : b,
    );
    final updated = await session.db.transaction((tx) async {
      await TransactionSplit.db.deleteWhere(
        session,
        where: (s) => s.transactionId.equals(t.id!),
        transaction: tx,
      );
      await TransactionSplit.db.insert(session, [
        for (final p in parts)
          TransactionSplit(
            transactionId: t.id!,
            categoryId: p.categoryId,
            amountCents: p.amountCents,
            note: p.note == null || p.note!.trim().isEmpty
                ? null
                : p.note!.trim(),
          ),
      ], transaction: tx);
      return BankTransaction.db.updateRow(
        session,
        t.copyWith(
          categoryId: largest.categoryId,
          categorySource: CategorySource.manual,
          categoryRuleRef: null,
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
    });
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'split',
      entity: 'transaction',
      rowId: t.id,
      before: t,
      after: updated,
    );
    await GoalAlertService.checkAfterChange(session, account.groupId);
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

  static const _maxBatch = 500;

  /// Checks or unchecks several operations at once (up to 500), all or
  /// none: each must exist and be writable by the user. Returns the
  /// operations as they were before, so that the change can be undone.
  Future<List<BankTransaction>> setClearedMany(
    Session session,
    List<int> transactionIds,
    bool cleared,
  ) async {
    final Set<int> ids = transactionIds.toSet();
    if (ids.isEmpty) return [];
    if (ids.length > _maxBatch) {
      throw InvalidInputException(code: 'too_many', field: 'transactionIds');
    }
    final rows = await BankTransaction.db.find(
      session,
      where: (t) => t.id.inSet(ids) & t.deletedAt.equals(null),
    );
    if (rows.length != ids.length) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    final accounts = <int, Account>{};
    for (final t in rows) {
      accounts[t.accountId] ??= await _account(session, t, write: true);
    }
    final now = DateTime.now().toUtc();
    await session.db.transaction((tx) async {
      await BankTransaction.db.update(session, [
        for (final t in rows) t.copyWith(cleared: cleared, updatedAt: now),
      ], transaction: tx);
    });
    for (final a in accounts.values) {
      await _audit(session, a, 'set_cleared_many', null);
    }
    return rows;
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
    final visible = await Access.visibleAccounts(session, account.groupId);
    final changed = await ClassificationService.applyRule(session, rule, {
      for (final a in visible) a.id!,
    });
    // The corrected operation itself is the user's explicit choice.
    await BankTransaction.db.updateRow(
      session,
      t.copyWith(
        categoryId: categoryId,
        categorySource: CategorySource.manual,
        categoryRuleRef: null,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    final others = changed.where((x) => x.id != t.id).length;
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'create_from_correction',
      entity: 'rule',
      rowId: rule.id,
      after: rule,
    );
    return RuleApplication(rule: rule, reclassifiedCount: others);
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

  static Future<void> _dropSplits(Session session, int transactionId) =>
      TransactionSplit.db.deleteWhere(
        session,
        where: (s) => s.transactionId.equals(transactionId),
      );

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
