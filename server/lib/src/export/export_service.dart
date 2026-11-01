import 'dart:convert';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/access.dart';

/// Export of everything a member may see in a group (roadbook phase 5):
/// a complete JSON document, and the operations as CSV for a spreadsheet.
///
/// Only the accounts visible to the member are exported, with what belongs
/// to them; secrets (two-factor keys, backup codes, AI keys, access tokens)
/// never are. Amounts stay in cents in the JSON.
abstract final class ExportService {
  /// Version of the JSON layout, raised on any incompatible change.
  static const formatVersion = 1;

  /// Rows fetched per query for the big tables (100 000 operations).
  static const _batch = 5000;

  static Future<String> json(
    Session session,
    GroupMember member, {
    required String serverVersion,
    DateTime? now,
  }) async {
    final groupId = member.groupId;
    final group = await FinanceGroup.db.findById(session, groupId);
    final accounts = await Access.visibleAccountsOf(session, member);
    final Set<int> accountIds = {for (final a in accounts) a.id!};

    final transactions = await _transactions(session, accountIds);
    final splits = <TransactionSplit>[];
    final ids = [for (final t in transactions) t.id!];
    for (var i = 0; i < ids.length; i += _batch) {
      final Set<int> part = ids
          .sublist(i, (i + _batch).clamp(0, ids.length))
          .toSet();
      splits.addAll(
        await TransactionSplit.db.find(
          session,
          where: (s) => s.transactionId.inSet(part),
          orderBy: (s) => s.id,
        ),
      );
    }
    final Set<int> transactionIds = ids.toSet();

    Future<List<T>> byAccount<T>(
      Future<List<T>> Function(Set<int> ids) find,
    ) async => accountIds.isEmpty ? <T>[] : find(accountIds);

    final loans = [
      for (final l in await Loan.db.find(
        session,
        where: (l) => l.groupId.equals(groupId),
        orderBy: (l) => l.id,
      ))
        if (l.accountId == null || accountIds.contains(l.accountId)) l,
    ];
    final Set<int> loanIds = {for (final l in loans) l.id!};
    final invoices = [
      for (final i in await Invoice.db.find(
        session,
        where: (i) => i.groupId.equals(groupId),
        orderBy: (i) => i.id,
      ))
        if (i.transactionId == null || transactionIds.contains(i.transactionId))
          i,
    ];
    final user = member.authUserId;

    List<Map<String, dynamic>> rows(List<SerializableModel> list) => [
      for (final r in list) r.toJson(),
    ];

    final doc = <String, dynamic>{
      'format': 'owncoffer-export',
      'formatVersion': formatVersion,
      'exportedAt': (now ?? DateTime.now()).toUtc().toIso8601String(),
      'serverVersion': serverVersion,
      'amounts': 'cents',
      'group': group?.toJson(),
      'member': member.toJson(),
      'members': rows(
        await GroupMember.db.find(
          session,
          where: (m) => m.groupId.equals(groupId),
          orderBy: (m) => m.id,
        ),
      ),
      // The keyed fingerprint of the account number means nothing elsewhere.
      'accounts': [
        for (final a in accounts) a.toJson()..remove('bankAccountKey'),
      ],
      'categories': rows(
        await Category.db.find(
          session,
          where: (c) => c.groupId.equals(groupId),
          orderBy: (c) => c.id,
        ),
      ),
      'rules': rows(
        await Rule.db.find(
          session,
          where: (r) => r.groupId.equals(groupId),
          orderBy: (r) => r.id,
        ),
      ),
      'goals': rows(
        await Goal.db.find(
          session,
          where: (g) => g.groupId.equals(groupId),
          orderBy: (g) => g.id,
        ),
      ),
      'scheduledTransactions': rows(
        await byAccount(
          (ids) => ScheduledTransaction.db.find(
            session,
            where: (s) => s.accountId.inSet(ids),
            orderBy: (s) => s.id,
          ),
        ),
      ),
      'transactions': rows(transactions),
      'transactionSplits': rows(splits),
      'balanceChecks': rows(
        await byAccount(
          (ids) => BalanceCheck.db.find(
            session,
            where: (b) => b.accountId.inSet(ids),
            orderBy: (b) => b.id,
          ),
        ),
      ),
      'imports': rows(
        await byAccount(
          (ids) => StatementImport.db.find(
            session,
            where: (i) => i.accountId.inSet(ids),
            orderBy: (i) => i.id,
          ),
        ),
      ),
      'loans': rows(loans),
      // File contents stay on the server: names, sizes and dates only.
      'loanDocuments': rows(
        loanIds.isEmpty
            ? <LoanDocument>[]
            : await LoanDocument.db.find(
                session,
                where: (d) => d.loanId.inSet(loanIds),
                orderBy: (d) => d.id,
              ),
      ),
      'invoices': rows(invoices),
      // The member's own assistant data in this group.
      'aiMemories': rows(
        await AiMemory.db.find(
          session,
          where: (m) => m.groupId.equals(groupId) & m.authUserId.equals(user),
          orderBy: (m) => m.id,
        ),
      ),
      'aiConversations': rows(
        await AiConversation.db.find(
          session,
          where: (c) => c.groupId.equals(groupId) & c.authUserId.equals(user),
          orderBy: (c) => c.id,
        ),
      ),
    };
    return jsonEncode(doc);
  }

  /// Operations of the visible accounts, trash excluded, oldest first.
  /// French: `;` and decimal comma (what a French spreadsheet expects);
  /// English: `,` and decimal point. A UTF-8 byte order mark lets
  /// spreadsheets read accents.
  static Future<String> csv(
    Session session,
    GroupMember member, {
    required String language,
  }) async {
    final fr = language != 'en';
    final sep = fr ? ';' : ',';
    final accounts = {
      for (final a in await Access.visibleAccountsOf(session, member)) a.id!: a,
    };
    final categories = {
      for (final c in await Category.db.find(
        session,
        where: (c) => c.groupId.equals(member.groupId),
      ))
        c.id!: c,
    };
    String name(Category c) =>
        c.name ??
        core.standardCategoriesById[c.standardCode]?.name(fr ? 'fr' : 'en') ??
        c.standardCode ??
        '';
    String path(int? id) {
      final c = categories[id];
      if (c == null) return '';
      final parent = categories[c.parentId];
      return parent == null ? name(c) : '${name(parent)} > ${name(c)}';
    }

    final out = StringBuffer('\uFEFF');
    void line(List<String> cells) {
      out
        ..write(cells.map((c) => csvCell(c, sep)).join(sep))
        ..write('\r\n');
    }

    line(
      fr
          ? [
              'date',
              'compte',
              'libellé',
              'libellé banque',
              'détails',
              'note',
              'montant',
              'montant en centimes',
              'catégorie',
              'pointée',
              'référence',
              'id',
            ]
          : [
              'date',
              'account',
              'label',
              'bank label',
              'details',
              'note',
              'amount',
              'amount in cents',
              'category',
              'cleared',
              'reference',
              'id',
            ],
    );
    final transactions = await _transactions(
      session,
      accounts.keys.toSet(),
      withTrash: false,
    );
    for (final t in transactions) {
      line([
        _day(t.date),
        accounts[t.accountId]?.name ?? '',
        t.cleanLabel,
        t.rawLabel,
        t.memo ?? '',
        t.note ?? '',
        _amount(t.amountCents, fr ? ',' : '.'),
        '${t.amountCents}',
        path(t.categoryId),
        t.cleared ? (fr ? 'oui' : 'yes') : (fr ? 'non' : 'no'),
        t.reference ?? '',
        '${t.id}',
      ]);
    }
    return out.toString();
  }

  static Future<List<BankTransaction>> _transactions(
    Session session,
    Set<int> accountIds, {
    bool withTrash = true,
  }) async {
    if (accountIds.isEmpty) return [];
    final all = <BankTransaction>[];
    // Keyset pagination on the id: constant cost per batch.
    var after = 0;
    while (true) {
      final batch = await BankTransaction.db.find(
        session,
        where: (t) {
          Expression e = t.accountId.inSet(accountIds) & (t.id > after);
          if (!withTrash) e = e & t.deletedAt.equals(null);
          return e;
        },
        orderBy: (t) => t.id,
        limit: _batch,
      );
      all.addAll(batch);
      if (batch.length < _batch) break;
      after = batch.last.id!;
    }
    all.sort((a, b) {
      final d = a.date.compareTo(b.date);
      return d != 0 ? d : a.id!.compareTo(b.id!);
    });
    return all;
  }

  /// One CSV cell: quoted when needed. A text starting with `=`, `+`, `-`
  /// or `@` gets a leading apostrophe so a spreadsheet never runs it as a
  /// formula (CSV injection); amounts are written by [_amount] and never
  /// go through this guard.
  static String csvCell(String value, String sep) {
    var v = value;
    if (v.isNotEmpty &&
        '=+-@\t\r'.contains(v[0]) &&
        !RegExp(r'^-?\d+([.,]\d+)?$').hasMatch(v)) {
      v = "'$v";
    }
    if (v.contains(sep) ||
        v.contains('"') ||
        v.contains('\n') ||
        v.contains('\r')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }

  static String _day(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static String _amount(int cents, String decimal) {
    final sign = cents < 0 ? '-' : '';
    final abs = cents.abs();
    return '$sign${abs ~/ 100}$decimal${(abs % 100).toString().padLeft(2, '0')}';
  }
}
