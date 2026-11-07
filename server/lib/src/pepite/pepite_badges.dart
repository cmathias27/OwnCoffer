import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/spending_service.dart';
import '../generated/protocol.dart';
import '../host/host_state.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';

/// The badges of decision 0028 (point 1), each from data that already
/// exists, by count queries, never by loading a history
/// (`performance_test.dart`). Only what the user did themselves, where the
/// data says who did it (author of a rule, of an invoice, of a change in
/// the audit log). None depends on an amount (point 2): goals are measured
/// in percent of the goal.
abstract final class PepiteBadges {
  static const tidyRules = 10;
  static const archivedInvoices = 10;
  static const declaredSubscriptions = 3;
  static const monthReviews = 3;

  /// Recorded in `pepite_marks`: what leaves no other trace.
  static const monthReview = 'month_review';
  static const sessionAlert = 'session_alert';
  static const deviceUnlock = 'device_unlock';
  static const backup = 'backup';

  /// What only the app knows and vouches for: unlock by fingerprint, face
  /// or Windows Hello; a backup of the standalone app.
  static const deviceMarks = {deviceUnlock, backup};

  /// Every new badge, by family (decision 0028, point 1).
  static const codes = [
    // Découverte.
    'tidy',
    'seer',
    'archivist',
    'loan_master',
    'subscription_hunter',
    // Sécurité (with « Pépite nomade », decision 0027).
    'vault',
    'velvet',
    'provident',
    'vigilant',
    // Rapprochement.
    'to_the_cent',
    'month_reviews',
    // Objectifs.
    'first_goal',
    'goal_half',
    'goal_kept',
    'scissors',
    // Foyer.
    'team',
  ];

  /// A month review looked at, by its first day: three months earn
  /// « Bilan du mois ». Never fails the review.
  static Future<void> reviewed(
    Session session,
    UuidValue user,
    core.LocalDate monthStart,
  ) async {
    try {
      await mark(session, user, monthReview, '$monthStart');
    } on Object catch (e) {
      session.log(
        'Pépite: month review not recorded: ${e.runtimeType}',
        level: LogLevel.warning,
      );
    }
  }

  /// Records [code] once per [key] for [user], at most [_maxKeys] keys.
  static Future<void> mark(
    Session session,
    UuidValue user,
    String code,
    String key, {
    Transaction? transaction,
  }) async {
    final t = transaction;
    final keys = await PepiteMark.db.count(
      session,
      where: (m) => m.authUserId.equals(user) & m.code.equals(code),
      transaction: t,
    );
    if (keys >= _maxKeys) return;
    final exists = await PepiteMark.db.count(
      session,
      where: (m) =>
          m.authUserId.equals(user) & m.code.equals(code) & m.key.equals(key),
      transaction: t,
    );
    if (exists > 0) return;
    await PepiteMark.db.insertRow(
      session,
      PepiteMark(
        authUserId: user,
        code: code,
        key: key,
        markedAt: DateTime.now().toUtc(),
      ),
      transaction: t,
    );
  }

  static const _maxKeys = 100;

  /// Whether [user] deserves [code] now; null: not one of these badges.
  /// The goals' badges read a month of operations: only at the ritual
  /// ([ritual], once a week), not at each look at the home page.
  static Future<bool?> deserved(
    Session session,
    Transaction t,
    UuidValue user,
    String code, {
    required core.LocalDate today,
    required bool ritual,
  }) async {
    Future<int> audited(
      String entity,
      Set<String> actions, [
      Expression Function(AuditEntryTable a)? more,
    ]) => AuditEntry.db.count(
      session,
      where: (a) {
        final e =
            a.authUserId.equals(user) &
            a.entity.equals(entity) &
            a.action.inSet(actions);
        return more == null ? e : e & more(a);
      },
      transaction: t,
    );
    Future<int> marks(String code) => PepiteMark.db.count(
      session,
      where: (m) => m.authUserId.equals(user) & m.code.equals(code),
      transaction: t,
    );
    // JSON snapshots of the audit log (no spaces, null fields left out).
    const subscribed = '%"subscription":true%';
    const ends = '%"endDate"%';
    switch (code) {
      case 'tidy':
        return await Rule.db.count(
              session,
              where: (r) => r.createdBy.equals(user),
              transaction: t,
            ) >=
            tidyRules;
      case 'seer':
        return await audited('scheduled', {'create', 'subscribe_from'}) > 0;
      case 'archivist':
        return await Invoice.db.count(
              session,
              where: (i) =>
                  i.uploadedBy.equals(user) & i.transactionId.notEquals(null),
              transaction: t,
            ) >=
            archivedInvoices;
      case 'loan_master':
        // A loan always has its amortization schedule (computed from it).
        return await audited('loan', {'create', 'create_from_transaction'}) > 0;
      case 'subscription_hunter':
        return await audited(
              'scheduled',
              {'create', 'subscribe_from', 'update'},
              (a) =>
                  a.after.like(subscribed) &
                  (a.before.equals(null) |
                      a.before.like('%"subscription":false%')),
            ) >=
            declaredSubscriptions;
      case 'vault':
        return await TotpSecret.db.count(
              session,
              where: (s) => s.authUserId.equals(user) & s.enabled.equals(true),
              transaction: t,
            ) >
            0;
      case 'velvet':
        return await marks(deviceUnlock) > 0;
      case 'provident':
        if (await marks(backup) > 0) return true;
        // Server: the administrator who set up its backups.
        final host = HostState.instance.backups();
        return host.available &&
            host.backups.isNotEmpty &&
            await Onboarding.isServerAdmin(session, user);
      case 'vigilant':
        return await marks(sessionAlert) > 0;
      case 'to_the_cent':
        return await BalanceCheck.db.count(
              session,
              where: (c) =>
                  c.createdBy.equals(user) & c.differenceCents.equals(0),
              transaction: t,
            ) >
            0;
      case 'month_reviews':
        return await marks(monthReview) >= monthReviews;
      case 'first_goal':
        return await audited('goal', {'create'}) > 0;
      case 'goal_half':
        return ritual && await _goals(session, t, user, today, half: true);
      case 'goal_kept':
        return ritual && await _goals(session, t, user, today, half: false);
      case 'scissors':
        // A subscription deleted, or given an end.
        return await audited(
                  'scheduled',
                  {'delete'},
                  (a) => a.before.like(subscribed),
                ) +
                await audited(
                  'scheduled',
                  {'update'},
                  (a) =>
                      a.before.like(subscribed) &
                      a.before.notLike(ends) &
                      a.after.like(ends),
                ) >
            0;
      case 'team':
        return await Invitation.db.count(
              session,
              where: (i) =>
                  i.createdBy.equals(user) &
                  i.groupId.notEquals(null) &
                  i.acceptedBy.notEquals(null) &
                  i.acceptedBy.notEquals(user),
              transaction: t,
            ) >
            0;
    }
    return null;
  }

  /// « À mi-chemin » ([half]): half of this budget month gone, at most half
  /// of a goal spent. « Objectif atteint »: last budget month ended within a
  /// goal. Only goals set before that month began, spending on the accounts
  /// the user may see; in percent of the goal, never shown in euros.
  static Future<bool> _goals(
    Session session,
    Transaction t,
    UuidValue user,
    core.LocalDate today, {
    required bool half,
  }) async {
    for (final member in await GroupMember.db.find(
      session,
      where: (m) => m.authUserId.equals(user),
      transaction: t,
    )) {
      final groupId = member.groupId;
      final current = await SpendingService.period(
        session,
        groupId,
        core.PeriodKind.month,
        today,
      );
      if (half && (current.start.daysUntil(today) + 1) * 2 < current.days) {
        continue;
      }
      final month = half ? current : current.shift(-1);
      final begun = month.start.toDb();
      final goals = await Goal.db.find(
        session,
        where: (g) =>
            g.groupId.equals(groupId) &
            g.amountCents.notEquals(0) &
            (g.createdAt < begun),
        transaction: t,
      );
      if (goals.isEmpty) continue;
      final Set<int> ids = {
        for (final a in await Access.visibleAccountsOf(session, member)) a.id!,
      };
      if (ids.isEmpty) continue;
      final summary = core.summarizeSpending(
        await SpendingService.categories(session, groupId),
        await SpendingService.operations(
          session,
          ids,
          month.start,
          half ? today.addDays(1) : month.end,
        ),
      );
      for (final g in goals) {
        final spent = summary.totals[g.categoryId] ?? 0;
        if (spent * 100 <= g.amountCents * (half ? 50 : 100)) return true;
      }
    }
    return false;
  }
}
