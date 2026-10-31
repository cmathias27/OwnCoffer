import 'dart:convert';
import 'dart:io';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';
import '../i18n/messages.dart';
import '../mail/mail_service.dart';
import 'alert_service.dart';

/// Reminder a month before the end of an invoice's warranty: one
/// notification and one email per member who can see the invoice and per
/// end date (a new date set by hand gives a new reminder).
abstract final class WarrantyAlertService {
  static const type = 'warranty_ending';
  static const notice = Duration(days: 30);

  /// Returns the number of new notifications.
  static Future<int> checkAll(Session session, core.LocalDate today) async {
    final from = today.toDb();
    final to = from.add(notice);
    final invoices = await Invoice.db.find(
      session,
      where: (i) => (i.warrantyUntil >= from) & (i.warrantyUntil <= to),
    );
    var created = 0;
    for (final invoice in invoices) {
      try {
        created += await _remind(session, invoice);
      } on Object catch (e) {
        session.log(
          '[warranty] invoice ${invoice.id} failed: ${e.runtimeType}',
          level: LogLevel.error,
        );
      }
    }
    return created;
  }

  static Future<int> _remind(Session session, Invoice invoice) async {
    final until = invoice.warrantyUntil!.toLocalDate();
    final List<UuidValue> recipients;
    BankTransaction? t;
    Account? account;
    if (invoice.transactionId == null) {
      recipients = [
        for (final m in await GroupMember.db.find(
          session,
          where: (m) => m.groupId.equals(invoice.groupId),
        ))
          m.authUserId,
      ];
    } else {
      t = await BankTransaction.db.findById(session, invoice.transactionId!);
      if (t == null || t.deletedAt != null) return 0;
      account = await Account.db.findById(session, t.accountId);
      if (account == null || account.deletedAt != null) return 0;
      recipients = await AlertService.recipients(session, account);
    }
    final name = core.invoiceFileName(
      originalName: invoice.fileName,
      date: t?.date.toLocalDate(),
      operationLabel: t?.cleanLabel,
      amountCents: t?.amountCents,
      currency: account?.currency,
      label: invoice.label,
    );
    // The name without extension reads better in a sentence.
    final ext = core.fileExtension(name);
    final title =
        invoice.label ??
        (ext.isEmpty ? name : name.substring(0, name.length - ext.length - 1));
    final key = 'warranty:${invoice.id}:$until';
    var created = 0;
    for (final user in recipients) {
      final exists = await AppNotification.db.count(
        session,
        where: (n) => n.authUserId.equals(user) & n.dedupKey.equals(key),
      );
      if (exists > 0) continue;
      final n = await AppNotification.db.insertRow(
        session,
        AppNotification(
          authUserId: user,
          groupId: invoice.groupId,
          accountId: account?.id,
          type: type,
          data: jsonEncode({
            'invoiceId': invoice.id,
            'name': title,
            'until': '$until',
          }),
          dedupKey: key,
        ),
      );
      created++;
      await _email(session, n, title, until);
    }
    return created;
  }

  static Future<void> _email(
    Session session,
    AppNotification n,
    String name,
    core.LocalDate until,
  ) async {
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(n.authUserId),
    );
    final to = profile?.email;
    if (to == null) return;
    final mail = Messages.bilingual('warranty', {
      'name': name,
      'date': '$until',
      'link': Platform.environment['OWNCOFFER_PUBLIC_URL'] ?? '',
    });
    try {
      await MailService.instance.send(
        session,
        to: to,
        subject: mail.subject,
        body: mail.body,
      );
      await AppNotification.db.updateRow(
        session,
        n.copyWith(emailedAt: DateTime.now().toUtc()),
      );
    } on Object {
      // The in-app notification stays; the failure is already logged.
    }
  }
}
