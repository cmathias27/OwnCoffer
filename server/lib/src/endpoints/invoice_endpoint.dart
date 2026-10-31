import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../core/dates.dart';
import '../core/documents.dart';
import '../generated/protocol.dart';
import '../i18n/messages.dart';
import '../mail/mail_service.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Invoices and receipts (PDF or photo) attached to operations: kept,
/// listed under a name built from their operation, opened, emailed, with
/// an optional end of warranty (reminder a month before).
///
/// An invoice of an operation is seen by those who see its account; one
/// without operation by every member of the group.
class InvoiceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  static const maxPerTransaction = 20;

  /// Emails a member may send per 24 hours (the server's SMTP account is
  /// not a relay).
  static const maxSentPerDay = 20;
  static const _allowed = {'pdf', 'png', 'jpg', 'jpeg', 'webp'};
  static const _maxListed = 2000;

  /// Invoices the user may see, newest operation first. [year] filters on
  /// the operation's date (the sending date without operation); [search]
  /// on names and labels; [warranty]: only those with a running warranty.
  Future<List<InvoiceInfo>> list(
    Session session,
    int groupId, {
    int? year,
    String? search,
    bool? warranty,
  }) async {
    final member = await Access.requireMember(session, groupId);
    final accounts = {
      for (final a in await Access.visibleAccountsOf(session, member)) a.id!: a,
    };
    final invoices = await Invoice.db.find(
      session,
      where: (i) => i.groupId.equals(groupId),
      orderByList: (i) => [i.createdAt.desc(), i.id.desc()],
      limit: _maxListed,
    );
    var infos = await _infos(session, invoices, accounts);
    if (year != null) {
      infos = [
        for (final i in infos)
          if ((i.transactionDate ?? i.invoice.createdAt).year == year) i,
      ];
    }
    if (warranty == true) {
      final today = _today().toDb();
      infos = [
        for (final i in infos)
          if (i.invoice.warrantyUntil != null &&
              !i.invoice.warrantyUntil!.isBefore(today))
            i,
      ];
    }
    final q = search == null ? '' : core.normalizeForMatch(search);
    if (q.isNotEmpty) {
      infos = [
        for (final i in infos)
          if (core
              .normalizeForMatch(
                [
                  i.name,
                  i.invoice.fileName,
                  ?i.invoice.label,
                  ?i.transactionLabel,
                  ?i.accountName,
                ].join(' '),
              )
              .contains(q))
            i,
      ];
    }
    DateTime when(InvoiceInfo i) => i.transactionDate ?? i.invoice.createdAt;
    infos.sort((a, b) {
      final c = when(b).compareTo(when(a));
      return c != 0 ? c : b.invoice.id!.compareTo(a.invoice.id!);
    });
    return infos;
  }

  /// Invoices of one operation, in the order they were added.
  Future<List<InvoiceInfo>> forTransaction(
    Session session,
    int transactionId,
  ) async {
    final (t, account) = await _transaction(session, transactionId);
    final invoices = await Invoice.db.find(
      session,
      where: (i) => i.transactionId.equals(t.id!),
      orderBy: (i) => i.id,
    );
    return _infos(session, invoices, {account.id!: account});
  }

  /// Keeps an invoice of the operation (PDF or image, 10 MB at most).
  Future<InvoiceInfo> upload(
    Session session,
    int transactionId,
    String fileName,
    ByteData file,
  ) async {
    final (t, account) = await _transaction(
      session,
      transactionId,
      write: true,
    );
    final (:name, :mime) = Documents.check(
      fileName,
      file,
      allowed: _allowed,
    );
    final count = await Invoice.db.count(
      session,
      where: (i) => i.transactionId.equals(t.id!),
    );
    if (count >= maxPerTransaction) {
      throw InvalidInputException(code: 'document_limit');
    }
    final saved = await session.db.transaction((tx) async {
      final invoice = await Invoice.db.insertRow(
        session,
        Invoice(
          groupId: account.groupId,
          transactionId: t.id,
          fileName: name,
          mimeType: mime,
          sizeBytes: file.lengthInBytes,
          uploadedBy: Access.userId(session),
        ),
        transaction: tx,
      );
      await InvoiceBlob.db.insertRow(
        session,
        InvoiceBlob(invoiceId: invoice.id!, content: file),
        transaction: tx,
      );
      return invoice;
    });
    await _audit(session, 'upload_invoice', saved, after: saved);
    return (await _infos(session, [saved], {account.id!: account})).single;
  }

  /// The content, for the user to open or save it.
  Future<ByteData> download(Session session, int invoiceId) async {
    final invoice = await _find(session, invoiceId);
    return _content(session, invoice);
  }

  /// What it is for and the end of its warranty (null clears them).
  Future<InvoiceInfo> update(
    Session session,
    int invoiceId,
    String? label,
    DateTime? warrantyUntil,
  ) async {
    final before = await _find(session, invoiceId, write: true);
    final text = label?.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (text != null && text.length > 80) {
      throw InvalidInputException(code: 'invalid_name', field: 'label');
    }
    DateTime? until;
    if (warrantyUntil != null) {
      final u = warrantyUntil.toUtc();
      if (u.year < 2000 || u.year > 2100) {
        throw InvalidInputException(code: 'invalid_date', field: 'warranty');
      }
      until = core.LocalDate(u.year, u.month, u.day).toDb();
    }
    final saved = await Invoice.db.updateRow(
      session,
      before.copyWith(
        label: text == null || text.isEmpty ? null : text,
        warrantyUntil: until,
      ),
    );
    await _audit(session, 'update_invoice', saved, before: before);
    return (await _infos(
      session,
      [saved],
      await _accountsOf(session, saved),
    )).single;
  }

  Future<void> delete(Session session, int invoiceId) async {
    final invoice = await _find(session, invoiceId, write: true);
    await Invoice.db.deleteRow(session, invoice);
    await _audit(session, 'delete_invoice', invoice, before: invoice);
  }

  /// Emails the invoice to [to] (an accountant, a shop's after-sales
  /// service…), with an optional [message]. Needs the server's SMTP
  /// settings; at most [maxSentPerDay] per member and 24 hours.
  Future<void> send(
    Session session,
    int invoiceId,
    String to,
    String? message,
  ) async {
    final invoice = await _find(session, invoiceId);
    if (!MailService.instance.isConfigured) {
      throw InvalidInputException(code: 'mail_not_configured');
    }
    final address = Onboarding.checkEmail(to);
    final note = message?.trim() ?? '';
    if (note.length > 1000) {
      throw InvalidInputException(code: 'invalid_name', field: 'message');
    }
    final user = Access.userId(session);
    final sent = await AuditEntry.db.count(
      session,
      where: (a) =>
          a.authUserId.equals(user) &
          a.action.equals('send_invoice') &
          (a.createdAt >
              DateTime.now().toUtc().subtract(const Duration(days: 1))),
    );
    if (sent >= maxSentPerDay) {
      throw InvalidInputException(code: 'send_limit');
    }
    final info = (await _infos(
      session,
      [invoice],
      await _accountsOf(session, invoice),
    )).single;
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(user),
    );
    final mail = Messages.bilingual('invoice', {
      'name': info.name,
      'sender': profile?.fullName ?? profile?.email ?? 'OwnCoffer',
    });
    final content = await _content(session, invoice);
    try {
      await MailService.instance.send(
        session,
        to: address,
        subject: mail.subject,
        body: note.isEmpty ? mail.body : '$note\n\n---\n\n${mail.body}',
        attachments: [
          (
            name: info.name,
            mimeType: invoice.mimeType,
            bytes: content.buffer.asUint8List(
              content.offsetInBytes,
              content.lengthInBytes,
            ),
          ),
        ],
      );
    } on Object {
      throw InvalidInputException(code: 'mail_failed');
    }
    await _audit(session, 'send_invoice', invoice);
  }

  // --- helpers --------------------------------------------------------------

  /// Infos of [invoices] whose operation is in [accounts]; those of other
  /// accounts (or of an operation in the trash) are left out, those
  /// without operation kept.
  static Future<List<InvoiceInfo>> _infos(
    Session session,
    List<Invoice> invoices,
    Map<int, Account> accounts,
  ) async {
    final Set<int> ids = {
      for (final i in invoices)
        if (i.transactionId != null) i.transactionId!,
    };
    final ops = ids.isEmpty
        ? <int, BankTransaction>{}
        : {
            for (final t in await BankTransaction.db.find(
              session,
              where: (t) => t.id.inSet(ids),
            ))
              t.id!: t,
          };
    // Rank of each invoice within its operation, for distinct names.
    final siblings = ids.isEmpty
        ? <Invoice>[]
        : await Invoice.db.find(
            session,
            where: (i) => i.transactionId.inSet(ids),
            orderBy: (i) => i.id,
          );
    final rank = <int, int>{};
    final seen = <int, int>{};
    for (final s in siblings) {
      rank[s.id!] = seen[s.transactionId!] = (seen[s.transactionId!] ?? 0) + 1;
    }
    return [
      for (final i in invoices)
        if (i.transactionId == null)
          InvoiceInfo(
            invoice: i,
            name: core.invoiceFileName(
              originalName: i.fileName,
              label: i.label,
            ),
          )
        else if (ops[i.transactionId] case final t?
            when t.deletedAt == null && accounts.containsKey(t.accountId))
          InvoiceInfo(
            invoice: i,
            name: core.invoiceFileName(
              originalName: i.fileName,
              date: t.date.toLocalDate(),
              operationLabel: t.cleanLabel,
              amountCents: t.amountCents,
              currency: accounts[t.accountId]!.currency,
              label: i.label,
              index: rank[i.id] ?? 1,
            ),
            transactionDate: t.date,
            transactionLabel: t.cleanLabel,
            amountCents: t.amountCents,
            currency: accounts[t.accountId]!.currency,
            accountName: accounts[t.accountId]!.name,
          ),
    ];
  }

  /// The account of the invoice's operation (access already checked).
  static Future<Map<int, Account>> _accountsOf(
    Session session,
    Invoice invoice,
  ) async {
    final id = invoice.transactionId;
    if (id == null) return const {};
    final t = await BankTransaction.db.findById(session, id);
    final a = t == null
        ? null
        : await Account.db.findById(session, t.accountId);
    return a == null ? const {} : {a.id!: a};
  }

  /// The operation, if the user may see it ([write]: and change it).
  static Future<(BankTransaction, Account)> _transaction(
    Session session,
    int transactionId, {
    bool write = false,
  }) async {
    final t = await BankTransaction.db.findById(session, transactionId);
    if (t == null || t.deletedAt != null) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    try {
      return (
        t,
        await Access.requireAccount(session, t.accountId, write: write),
      );
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
  }

  /// The invoice, if the user may see it: through its operation's account,
  /// or as a member of its group when it has no operation.
  static Future<Invoice> _find(
    Session session,
    int invoiceId, {
    bool write = false,
  }) async {
    final invoice = await Invoice.db.findById(session, invoiceId);
    if (invoice == null) {
      throw AccessDeniedException(code: 'invoice_access_denied');
    }
    try {
      if (invoice.transactionId == null) {
        await Access.requireMember(
          session,
          invoice.groupId,
          min: write ? MemberRole.user : MemberRole.reader,
        );
      } else {
        await _transaction(session, invoice.transactionId!, write: write);
      }
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'invoice_access_denied');
    }
    return invoice;
  }

  static Future<ByteData> _content(Session session, Invoice invoice) async {
    final blob = await InvoiceBlob.db.findFirstRow(
      session,
      where: (b) => b.invoiceId.equals(invoice.id!),
    );
    if (blob == null) {
      throw AccessDeniedException(code: 'invoice_access_denied');
    }
    return blob.content;
  }

  static Future<void> _audit(
    Session session,
    String action,
    Invoice invoice, {
    Invoice? before,
    Invoice? after,
  }) => Audit.log(
    session,
    groupId: invoice.groupId,
    action: action,
    entity: 'invoice',
    rowId: invoice.id,
    before: before,
    after: after,
  );

  static core.LocalDate _today() =>
      core.LocalDate.fromDateTime(DateTime.now().toUtc());
}
