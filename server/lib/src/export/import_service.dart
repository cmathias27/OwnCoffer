import 'dart:convert';
import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/audit.dart';
import 'export_service.dart';

/// Recreates an export (ExportService.json, format 1) in a new group whose
/// administrator is [owner]: the move from the standalone app to a server,
/// back, or from one server to another (decision 0022).
///
/// Every id is renumbered and every link follows (categories, accounts,
/// operations, rules, loans, invoices…). Members, account access and
/// secrets are not part of an export: the new group has [owner] only.
/// Files (invoices, loan documents) come afterwards, one by one: the
/// result lists which.
abstract final class ImportService {
  static const _batch = 1000;

  static Future<ImportResult> importGroup(
    Session session,
    String json,
    UuidValue owner, {
    String? name,
  }) async {
    final Map<String, dynamic> doc;
    try {
      doc = jsonDecode(json) as Map<String, dynamic>;
    } on Object {
      throw InvalidInputException(code: 'import_not_an_export');
    }
    if (doc['format'] != 'owncoffer-export') {
      throw InvalidInputException(code: 'import_not_an_export');
    }
    final version = doc['formatVersion'];
    if (version is! int || version > ExportService.formatVersion) {
      throw InvalidInputException(code: 'import_newer_format');
    }
    List<Map<String, dynamic>> rows(String key) => [
      for (final r in (doc[key] as List?) ?? const [])
        Map<String, dynamic>.from(r as Map),
    ];
    final source = doc['group'] is Map
        ? FinanceGroup.fromJson(Map<String, dynamic>.from(doc['group'] as Map))
        : null;
    final groupName = (name?.trim().isNotEmpty ?? false)
        ? name!.trim()
        : (source?.name ?? 'OwnCoffer');

    return session.db.transaction((tx) async {
      Future<List<T>> insertAll<T extends TableRow>(
        List<T> items,
        Future<List<T>> Function(List<T> part) insert,
      ) async {
        final out = <T>[];
        for (var i = 0; i < items.length; i += _batch) {
          out.addAll(
            await insert(items.sublist(i, (i + _batch).clamp(0, items.length))),
          );
        }
        return out;
      }

      Map<int, int> ids(List<int?> old, List<TableRow> created) => {
        for (var i = 0; i < old.length; i++) old[i]!: created[i].id as int,
      };

      final group = await FinanceGroup.db.insertRow(
        session,
        FinanceGroup(
          name: groupName.length > 80 ? groupName.substring(0, 80) : groupName,
          createdBy: owner,
          aiEnabled: source?.aiEnabled ?? false,
          monthStartDay: source?.monthStartDay ?? 1,
          standardCatalogVersion:
              source?.standardCatalogVersion ?? core.standardCatalogVersion,
        ),
        transaction: tx,
      );
      final g = group.id!;
      await GroupMember.db.insertRow(
        session,
        GroupMember(groupId: g, authUserId: owner, role: MemberRole.admin),
        transaction: tx,
      );

      // Categories: parents first, so that each child finds its parent.
      final categories =
          [for (final r in rows('categories')) Category.fromJson(r)]..sort(
            (a, b) => (a.parentId == null ? 0 : 1).compareTo(
              b.parentId == null ? 0 : 1,
            ),
          );
      final cat = <int, int>{};
      for (final c in categories) {
        final created = await Category.db.insertRow(
          session,
          c.copyWith(id: null, groupId: g, parentId: null),
          transaction: tx,
        );
        cat[c.id!] = created.id!;
      }
      for (final c in categories.where((c) => c.parentId != null)) {
        final parent = cat[c.parentId];
        if (parent == null) continue;
        final mine = (await Category.db.findById(
          session,
          cat[c.id]!,
          transaction: tx,
        ))!;
        await Category.db.updateRow(
          session,
          mine.copyWith(parentId: parent),
          transaction: tx,
        );
      }
      int? c(int? old) => old == null ? null : cat[old];

      final accounts = [for (final r in rows('accounts')) Account.fromJson(r)];
      final acc = ids(
        [for (final a in accounts) a.id],
        await insertAll<Account>(
          [for (final a in accounts) a.copyWith(id: null, groupId: g)],
          (p) => Account.db.insert(session, p, transaction: tx),
        ),
      );

      final rules = [
        for (final r in rows('rules')) Rule.fromJson(r),
      ].where((r) => cat.containsKey(r.categoryId)).toList();
      final rule = ids(
        [for (final r in rules) r.id],
        await insertAll<Rule>(
          [
            for (final r in rules)
              r.copyWith(
                id: null,
                groupId: g,
                categoryId: cat[r.categoryId]!,
                createdBy: owner,
              ),
          ],
          (p) => Rule.db.insert(session, p, transaction: tx),
        ),
      );

      final goals = [
        for (final r in rows('goals')) Goal.fromJson(r),
      ].where((x) => cat.containsKey(x.categoryId)).toList();
      await insertAll<Goal>(
        [
          for (final x in goals)
            x.copyWith(id: null, groupId: g, categoryId: cat[x.categoryId]!),
        ],
        (p) => Goal.db.insert(session, p, transaction: tx),
      );

      final scheduled = [
        for (final r in rows('scheduledTransactions'))
          ScheduledTransaction.fromJson(r),
      ].where((s) => acc.containsKey(s.accountId)).toList();
      final sch = ids(
        [for (final s in scheduled) s.id],
        await insertAll<ScheduledTransaction>(
          [
            for (final s in scheduled)
              s.copyWith(
                id: null,
                accountId: acc[s.accountId]!,
                categoryId: c(s.categoryId),
              ),
          ],
          (p) => ScheduledTransaction.db.insert(session, p, transaction: tx),
        ),
      );

      final imports = [
        for (final r in rows('imports')) StatementImport.fromJson(r),
      ].where((i) => acc.containsKey(i.accountId)).toList();
      final imp = ids(
        [for (final i in imports) i.id],
        await insertAll<StatementImport>(
          [
            for (final i in imports)
              i.copyWith(
                id: null,
                accountId: acc[i.accountId]!,
                authorId: owner,
              ),
          ],
          (p) => StatementImport.db.insert(session, p, transaction: tx),
        ),
      );

      final transactions = [
        for (final r in rows('transactions')) BankTransaction.fromJson(r),
      ].where((t) => acc.containsKey(t.accountId)).toList();
      String? ruleRef(BankTransaction t) {
        if (t.categorySource != CategorySource.groupRule) {
          return t.categoryRuleRef;
        }
        final old = int.tryParse(t.categoryRuleRef ?? '');
        return old == null ? null : rule[old]?.toString();
      }

      final txs = ids(
        [for (final t in transactions) t.id],
        await insertAll<BankTransaction>(
          [
            for (final t in transactions)
              t.copyWith(
                id: null,
                accountId: acc[t.accountId]!,
                importId: t.importId == null ? null : imp[t.importId],
                categoryId: c(t.categoryId),
                categoryRuleRef: ruleRef(t),
                scheduledId: t.scheduledId == null ? null : sch[t.scheduledId],
                transferPairId: null,
                createdBy: t.createdBy == null ? null : owner,
              ),
          ],
          (p) => BankTransaction.db.insert(session, p, transaction: tx),
        ),
      );
      // Transfers between two accounts: both sides exist now.
      for (final t in transactions.where((t) => t.transferPairId != null)) {
        final pair = txs[t.transferPairId];
        if (pair == null) continue;
        final mine = (await BankTransaction.db.findById(
          session,
          txs[t.id]!,
          transaction: tx,
        ))!;
        await BankTransaction.db.updateRow(
          session,
          mine.copyWith(transferPairId: pair),
          transaction: tx,
        );
      }

      final splits = [
        for (final r in rows('transactionSplits')) TransactionSplit.fromJson(r),
      ].where((s) => txs.containsKey(s.transactionId)).toList();
      await insertAll<TransactionSplit>(
        [
          for (final s in splits)
            s.copyWith(
              id: null,
              transactionId: txs[s.transactionId]!,
              categoryId: c(s.categoryId),
            ),
        ],
        (p) => TransactionSplit.db.insert(session, p, transaction: tx),
      );

      final checks = [
        for (final r in rows('balanceChecks')) BalanceCheck.fromJson(r),
      ].where((b) => acc.containsKey(b.accountId)).toList();
      await insertAll<BalanceCheck>(
        [
          for (final b in checks)
            b.copyWith(
              id: null,
              accountId: acc[b.accountId]!,
              createdBy: b.createdBy == null ? null : owner,
            ),
        ],
        (p) => BalanceCheck.db.insert(session, p, transaction: tx),
      );

      final loans = [for (final r in rows('loans')) Loan.fromJson(r)];
      final loan = ids(
        [for (final l in loans) l.id],
        await insertAll<Loan>(
          [
            for (final l in loans)
              l.copyWith(
                id: null,
                groupId: g,
                accountId: l.accountId == null ? null : acc[l.accountId],
                categoryId: c(l.categoryId),
                scheduledId: l.scheduledId == null ? null : sch[l.scheduledId],
                ruleId: l.ruleId == null ? null : rule[l.ruleId],
              ),
          ],
          (p) => Loan.db.insert(session, p, transaction: tx),
        ),
      );

      final documents = <ImportedDocument>[];
      final loanDocs = [
        for (final r in rows('loanDocuments')) LoanDocument.fromJson(r),
      ].where((d) => loan.containsKey(d.loanId)).toList();
      final createdDocs = await insertAll<LoanDocument>(
        [
          for (final d in loanDocs)
            d.copyWith(
              id: null,
              loanId: loan[d.loanId]!,
              uploadedBy: d.uploadedBy == null ? null : owner,
            ),
        ],
        (p) => LoanDocument.db.insert(session, p, transaction: tx),
      );
      for (var i = 0; i < loanDocs.length; i++) {
        documents.add(
          ImportedDocument(
            kind: 'loanDocument',
            oldId: loanDocs[i].id!,
            newId: createdDocs[i].id!,
            sizeBytes: loanDocs[i].sizeBytes,
          ),
        );
      }

      final invoices =
          [
                for (final r in rows('invoices')) Invoice.fromJson(r),
              ]
              .where(
                (x) =>
                    x.transactionId == null || txs.containsKey(x.transactionId),
              )
              .toList();
      final createdInvoices = await insertAll<Invoice>(
        [
          for (final x in invoices)
            x.copyWith(
              id: null,
              groupId: g,
              transactionId: x.transactionId == null
                  ? null
                  : txs[x.transactionId],
              uploadedBy: x.uploadedBy == null ? null : owner,
            ),
        ],
        (p) => Invoice.db.insert(session, p, transaction: tx),
      );
      for (var i = 0; i < invoices.length; i++) {
        documents.add(
          ImportedDocument(
            kind: 'invoice',
            oldId: invoices[i].id!,
            newId: createdInvoices[i].id!,
            sizeBytes: invoices[i].sizeBytes,
          ),
        );
      }

      await insertAll<AiMemory>(
        [
          for (final r in rows('aiMemories'))
            AiMemory.fromJson(
              r,
            ).copyWith(id: null, groupId: g, authUserId: owner),
        ],
        (p) => AiMemory.db.insert(session, p, transaction: tx),
      );
      await insertAll<AiConversation>(
        [
          for (final r in rows('aiConversations'))
            AiConversation.fromJson(
              r,
            ).copyWith(id: null, groupId: g, authUserId: owner),
        ],
        (p) => AiConversation.db.insert(session, p, transaction: tx),
      );

      await Audit.log(
        session,
        groupId: g,
        action: 'import',
        entity: 'group',
        rowId: g,
        after: group,
        transaction: tx,
      );
      return ImportResult(
        groupId: g,
        groupName: group.name,
        accounts: acc.length,
        transactions: txs.length,
        documents: documents,
      );
    });
  }

  /// The content of one imported document, once (its size must match).
  static Future<void> importDocument(
    Session session,
    int groupId,
    String kind,
    int id,
    ByteData content,
  ) async {
    final size = content.lengthInBytes;
    switch (kind) {
      case 'invoice':
        final invoice = await Invoice.db.findById(session, id);
        if (invoice == null || invoice.groupId != groupId) {
          throw AccessDeniedException(code: 'group_access_denied');
        }
        if (invoice.sizeBytes != size ||
            await InvoiceBlob.db.count(
                  session,
                  where: (b) => b.invoiceId.equals(id),
                ) >
                0) {
          throw InvalidInputException(code: 'import_document_mismatch');
        }
        await InvoiceBlob.db.insertRow(
          session,
          InvoiceBlob(invoiceId: id, content: content),
        );
      case 'loanDocument':
        final doc = await LoanDocument.db.findById(session, id);
        final loan = doc == null
            ? null
            : await Loan.db.findById(session, doc.loanId);
        if (doc == null || loan == null || loan.groupId != groupId) {
          throw AccessDeniedException(code: 'group_access_denied');
        }
        if (doc.sizeBytes != size ||
            await LoanDocumentBlob.db.count(
                  session,
                  where: (b) => b.documentId.equals(id),
                ) >
                0) {
          throw InvalidInputException(code: 'import_document_mismatch');
        }
        await LoanDocumentBlob.db.insertRow(
          session,
          LoanDocumentBlob(documentId: id, content: content),
        );
      default:
        throw InvalidInputException(code: 'import_document_mismatch');
    }
  }
}
