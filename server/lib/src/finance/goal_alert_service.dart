import 'dart:convert';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import 'spending_service.dart';
import 'notification_settings_service.dart';

/// Goal alerts: when the spending of a category reaches 80 % then 100 % of
/// its monthly goal, every member gets one in-app notification per level and
/// budget month. Before that, an early alert says when the goal should be
/// exceeded at this pace (once per goal and month). Spending is computed on
/// the accounts each member may see.
abstract final class GoalAlertService {
  static const warningType = 'goal_warning';
  static const overType = 'goal_over';
  static const forecastType = 'goal_forecast';

  /// After a change that moves spending (import, category, split). A failure
  /// is logged, never returned to the caller whose change is already saved.
  static Future<void> checkAfterChange(Session session, int groupId) async {
    try {
      await checkGroup(
        session,
        groupId,
        core.LocalDate.fromDateTime(DateTime.now().toUtc()),
      );
    } on Object catch (e) {
      session.log(
        '[goal-alert] after change: ${e.runtimeType}',
        level: LogLevel.error,
      );
    }
  }

  /// Returns the number of new notifications.
  static Future<int> checkGroup(
    Session session,
    int groupId,
    core.LocalDate today,
  ) async {
    final goals = await Goal.db.find(
      session,
      where: (g) => g.groupId.equals(groupId),
    );
    if (goals.isEmpty) return 0;
    final month = await SpendingService.period(
      session,
      groupId,
      core.PeriodKind.month,
      today,
    );
    final categories = await SpendingService.categories(session, groupId);
    final rows = {
      for (final c in await Category.db.find(
        session,
        where: (c) => c.groupId.equals(groupId),
      ))
        c.id!: c,
    };
    final cache =
        <String, (core.SpendingSummary, Map<int, core.GoalProjection>)>{};
    var created = 0;
    for (final member in await GroupMember.db.find(
      session,
      where: (m) => m.groupId.equals(groupId),
    )) {
      final settings = await NotificationSettingsService.of(
        session,
        member.authUserId,
      );
      final Set<int> ids = {
        for (final a in await Access.visibleAccountsOf(session, member)) a.id!,
      };
      final cacheKey = (ids.toList()..sort()).join(',');
      final (summary, projections) = cache[cacheKey] ??= await () async {
        final ops = await SpendingService.operations(
          session,
          ids,
          month.start,
          month.end,
        );
        return (
          core.summarizeSpending(categories, ops),
          await SpendingService.projections(
            session,
            goals,
            categories,
            ids,
            ops,
            month,
            today,
          ),
        );
      }();
      for (final goal in goals) {
        final spent = summary.totals[goal.categoryId] ?? 0;
        final level = core.goalLevel(spent, goal.amountCents);
        final projection = projections[goal.categoryId];
        // Not once the goal is exceeded: the "over" alert says it.
        final overDate = level == core.GoalLevel.over
            ? null
            : projection?.overDate;
        final c = rows[goal.categoryId];
        for (final (type, suffix) in [
          if (overDate != null && settings.goalForecast)
            (forecastType, 'forecast'),
          if (level == core.GoalLevel.warning && settings.goalWarning)
            (warningType, level.name),
          if (level == core.GoalLevel.over && settings.goalOver)
            (overType, level.name),
        ]) {
          final key = 'goal:${goal.id}:${month.start}:$suffix';
          final exists = await AppNotification.db.count(
            session,
            where: (n) =>
                n.authUserId.equals(member.authUserId) & n.dedupKey.equals(key),
          );
          if (exists > 0) continue;
          await AppNotification.db.insertRow(
            session,
            AppNotification(
              authUserId: member.authUserId,
              groupId: groupId,
              type: type,
              data: jsonEncode({
                'categoryId': goal.categoryId,
                'name': c?.name,
                'standardCode': c?.standardCode,
                'spentCents': spent,
                'goalCents': goal.amountCents,
                'periodStart': '${month.start}',
                if (type == forecastType) ...{
                  'projectedCents': projection!.projectedCents,
                  'overDate': '$overDate',
                },
              }),
              dedupKey: key,
            ),
          );
          created++;
        }
      }
    }
    return created;
  }

  /// Every group with goals (hourly job).
  static Future<int> checkAll(Session session, core.LocalDate today) async {
    final groupIds = {
      for (final g in await Goal.db.find(session)) g.groupId,
    };
    var total = 0;
    for (final id in groupIds) {
      try {
        total += await checkGroup(session, id, today);
      } on Object catch (e) {
        session.log(
          '[goal-alert] group $id failed: ${e.runtimeType}',
          level: LogLevel.error,
        );
      }
    }
    return total;
  }
}
