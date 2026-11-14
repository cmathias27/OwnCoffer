import 'dart:convert';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import 'alert_service.dart';
import 'refund_service.dart';

/// In-app notifications of the follow-up page (decision 0050): a refund
/// still awaited after its day, a contract whose last day to cancel comes
/// within a month, a reminder on its day. Each one once per user and date.
abstract final class FollowUpAlertService {
  static const refundLate = 'refund_late';
  static const contractNotice = 'contract_notice';
  static const reminderDue = 'reminder_due';

  /// Days before the last day to cancel a contract.
  static const contractDays = 30;

  static Future<int> checkAll(Session session, core.LocalDate today) async {
    var created = 0;
    for (final step in [_refunds, _contracts, _reminders]) {
      try {
        created += await step(session, today);
      } on Object catch (e) {
        session.log(
          '[follow-up] check failed: ${e.runtimeType}',
          level: LogLevel.error,
        );
      }
    }
    return created;
  }

  /// Settles the refunds received (with the accounts their author sees),
  /// then reminds the author of those late.
  static Future<int> _refunds(Session session, core.LocalDate today) async {
    final open = await ExpectedRefund.db.find(
      session,
      where: (r) => r.receivedAt.equals(null),
    );
    final byAuthor = <(int, UuidValue)>{
      for (final r in open) (r.groupId, r.createdBy),
    };
    for (final (groupId, user) in byAuthor) {
      final member = await GroupMember.db.findFirstRow(
        session,
        where: (m) => m.groupId.equals(groupId) & m.authUserId.equals(user),
      );
      if (member == null) continue;
      final accounts = await Access.visibleAccountsOf(session, member);
      await RefundService.match(session, groupId, {
        for (final a in accounts) a.id!,
      });
    }
    final late = await ExpectedRefund.db.find(
      session,
      where: (r) => r.receivedAt.equals(null) & (r.dueBy < today.toDb()),
    );
    var created = 0;
    for (final r in late) {
      if (!await _isMember(session, r.groupId, r.createdBy)) continue;
      created += await _notify(
        session,
        user: r.createdBy,
        groupId: r.groupId,
        accountId: r.accountId,
        type: refundLate,
        data: {
          'refundId': r.id,
          'label': r.label,
          'amountCents': r.amountCents,
          'dueBy': '${r.dueBy!.toLocalDate()}',
        },
        key: 'refund_late:${r.id}:${r.dueBy!.toLocalDate()}',
      );
    }
    return created;
  }

  static Future<int> _contracts(Session session, core.LocalDate today) async {
    final rows = await ScheduledTransaction.db.find(
      session,
      where: (s) => s.deletedAt.equals(null) & s.renewalDate.notEquals(null),
    );
    var created = 0;
    for (final s in rows) {
      final c = core.contractDates(
        renewal: s.renewalDate!.toLocalDate(),
        noticeDays: s.noticeDays ?? 0,
        today: today,
      );
      if (c.daysToDeadline < 0 || c.daysToDeadline > contractDays) continue;
      final account = await Account.db.findById(session, s.accountId);
      if (account == null || account.deletedAt != null) continue;
      for (final user in await AlertService.recipients(session, account)) {
        created += await _notify(
          session,
          user: user,
          groupId: account.groupId,
          accountId: account.id,
          type: contractNotice,
          data: {
            'scheduledId': s.id,
            'label': s.label,
            'deadline': '${c.deadline}',
            'renewal': '${c.renewal}',
          },
          key: 'contract:${s.id}:${c.renewal}',
        );
      }
    }
    return created;
  }

  static Future<int> _reminders(Session session, core.LocalDate today) async {
    final rows = await Reminder.db.find(
      session,
      where: (r) => r.doneAt.equals(null) & (r.dueDate <= today.toDb()),
    );
    var created = 0;
    for (final r in rows) {
      if (!await _isMember(session, r.groupId, r.authUserId)) continue;
      created += await _notify(
        session,
        user: r.authUserId,
        groupId: r.groupId,
        accountId: null,
        type: reminderDue,
        data: {
          'reminderId': r.id,
          'text': r.text,
          'date': '${r.dueDate.toLocalDate()}',
        },
        key: 'reminder:${r.id}:${r.dueDate.toLocalDate()}',
      );
    }
    return created;
  }

  static Future<bool> _isMember(
    Session session,
    int groupId,
    UuidValue user,
  ) async =>
      await GroupMember.db.count(
        session,
        where: (m) => m.groupId.equals(groupId) & m.authUserId.equals(user),
      ) >
      0;

  static Future<int> _notify(
    Session session, {
    required UuidValue user,
    required int groupId,
    required int? accountId,
    required String type,
    required Map<String, Object?> data,
    required String key,
  }) async {
    final exists = await AppNotification.db.count(
      session,
      where: (n) => n.authUserId.equals(user) & n.dedupKey.equals(key),
    );
    if (exists > 0) return 0;
    await AppNotification.db.insertRow(
      session,
      AppNotification(
        authUserId: user,
        groupId: groupId,
        accountId: accountId,
        type: type,
        data: jsonEncode(data),
        dedupKey: key,
      ),
    );
    return 1;
  }
}
