import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';
import '../i18n/messages.dart';
import '../mail/mail_service.dart';
import 'forecast_service.dart';

/// Overdraft alert (roadbook phase 3, issue #53): when the forecast of an
/// account goes below its alert threshold, every member who can see the
/// account gets one notification and one email per expected date.
abstract final class AlertService {
  static const overdraftType = 'overdraft_forecast';

  /// After a change that moves the forecast (import, planned or manual
  /// operation): checks at once rather than at the next hourly run. A failure
  /// is logged, never returned to the caller whose change is already saved.
  static Future<void> checkAfterChange(Session session, Account account) async {
    try {
      await checkAccount(
        session,
        account,
        core.LocalDate.fromDateTime(DateTime.now().toUtc()),
      );
    } on Object catch (e) {
      session.log(
        '[alert] after change: ${e.runtimeType}',
        level: LogLevel.error,
      );
    }
  }

  /// Checks one account; returns the number of new notifications.
  static Future<int> checkAccount(
    Session session,
    Account account,
    core.LocalDate today,
  ) async {
    if (account.deletedAt != null) return 0;
    final f = await ForecastService.compute(session, account, today);
    final first = f.firstBelowThresholdDate;
    if (first == null) return 0;

    final firstDay = first.toLocalDate();
    final balanceThatDay = f.days
        .firstWhere((d) => d.date.toLocalDate() == firstDay)
        .balanceCents;
    final key = 'overdraft:${account.id}:$firstDay';
    final data = jsonEncode({
      'accountName': account.name,
      'date': '$firstDay',
      'balanceCents': balanceThatDay,
      'thresholdCents': account.alertThresholdCents,
      'lowestDate': '${f.lowestDate.toLocalDate()}',
      'lowestCents': f.lowestBalanceCents,
    });

    var created = 0;
    for (final user in await _recipients(session, account)) {
      final exists = await AppNotification.db.count(
        session,
        where: (n) => n.authUserId.equals(user) & n.dedupKey.equals(key),
      );
      if (exists > 0) continue;
      final n = await AppNotification.db.insertRow(
        session,
        AppNotification(
          authUserId: user,
          groupId: account.groupId,
          accountId: account.id,
          type: overdraftType,
          data: data,
          dedupKey: key,
        ),
      );
      created++;
      await _email(session, n, account, f, firstDay);
    }
    return created;
  }

  /// Members who can see the account (restricted accounts: admins and
  /// users given access).
  static Future<List<UuidValue>> _recipients(
    Session session,
    Account account,
  ) async {
    final members = await GroupMember.db.find(
      session,
      where: (m) => m.groupId.equals(account.groupId),
    );
    if (account.visibility == AccountVisibility.shared) {
      return [for (final m in members) m.authUserId];
    }
    final allowed = {
      for (final a in await AccountAccess.db.find(
        session,
        where: (a) => a.accountId.equals(account.id!),
      ))
        a.authUserId,
    };
    return [
      for (final m in members)
        if (m.role == MemberRole.admin || allowed.contains(m.authUserId))
          m.authUserId,
    ];
  }

  static Future<void> _email(
    Session session,
    AppNotification n,
    Account account,
    ForecastResult f,
    core.LocalDate firstDay,
  ) async {
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(n.authUserId),
    );
    final to = profile?.email;
    if (to == null) return;
    String money(int cents) =>
        '${core.formatCents(cents, thousandsSeparator: ' ')} ${account.currency}';
    final mail = Messages.bilingual('overdraft', {
      'account': account.name,
      'threshold': money(account.alertThresholdCents),
      'date': '$firstDay',
      'lowest': money(f.lowestBalanceCents),
      'lowestDate': '${f.lowestDate.toLocalDate()}',
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

  /// Checks every account of the server (hourly job).
  static Future<int> checkAll(Session session, core.LocalDate today) async {
    var total = 0;
    for (final account in await Account.db.find(
      session,
      where: (a) => a.deletedAt.equals(null),
    )) {
      try {
        total += await checkAccount(session, account, today);
      } on Object catch (e) {
        session.log(
          '[alert] account ${account.id} failed: ${e.runtimeType}',
          level: LogLevel.error,
        );
      }
    }
    return total;
  }

  static Timer? _timer;

  /// Starts the hourly check (first run one minute after start-up).
  static void start(Serverpod pod) {
    Future<void> run() async {
      final session = await pod.createSession(enableLogging: false);
      try {
        final n = await checkAll(
          session,
          core.LocalDate.fromDateTime(DateTime.now().toUtc()),
        );
        if (n > 0) session.log('[alert] $n overdraft notification(s)');
      } finally {
        await session.close();
      }
    }

    _timer?.cancel();
    Timer(const Duration(minutes: 1), run);
    _timer = Timer.periodic(const Duration(hours: 1), (_) => run());
  }
}
