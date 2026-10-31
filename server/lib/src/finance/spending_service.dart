import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import 'forecast_service.dart';

/// Data of the spending engine, read on the accounts the user may see.
abstract final class SpendingService {
  /// The visible accounts of the group, or the one asked for.
  static Future<Set<int>> accounts(
    Session session,
    int groupId,
    int? accountId,
  ) async {
    if (accountId != null) {
      final a = await Access.requireAccount(session, accountId);
      if (a.groupId != groupId) {
        throw AccessDeniedException(code: 'account_access_denied');
      }
      return {accountId};
    }
    final visible = await Access.visibleAccounts(session, groupId);
    return {for (final a in visible) a.id!};
  }

  static Future<List<core.SpendingCategory>> categories(
    Session session,
    int groupId,
  ) async => [
    // Archived categories too: their operations still count.
    for (final c in await Category.db.find(
      session,
      where: (c) => c.groupId.equals(groupId),
    ))
      core.SpendingCategory(
        c.id!,
        core.StandardKind.values.byName(c.kind.name),
        parentId: c.parentId,
      ),
  ];

  static Future<List<core.SpendingOperation>> operations(
    Session session,
    Set<int> accountIds,
    core.LocalDate from,
    core.LocalDate to,
  ) async {
    if (accountIds.isEmpty) return const [];
    final rows = await BankTransaction.db.find(
      session,
      where: (t) =>
          t.accountId.inSet(accountIds) &
          t.deletedAt.equals(null) &
          (t.date >= from.toDb()) &
          (t.date < to.toDb()),
    );
    final parts = await splitsOf(session, {for (final t in rows) t.id!});
    return [
      for (final t in rows)
        if (parts[t.id] case final split?)
          for (final p in split)
            core.SpendingOperation(
              t.date.toLocalDate(),
              p.amountCents,
              categoryId: p.categoryId,
              planned: t.scheduledId != null,
            )
        else
          core.SpendingOperation(
            t.date.toLocalDate(),
            t.amountCents,
            categoryId: t.categoryId,
            internalTransfer: t.transferPairId != null,
            planned: t.scheduledId != null,
          ),
    ];
  }

  /// Parts of the split operations among [transactionIds].
  static Future<Map<int, List<TransactionSplit>>> splitsOf(
    Session session,
    Set<int> transactionIds,
  ) async {
    if (transactionIds.isEmpty) return const {};
    final result = <int, List<TransactionSplit>>{};
    for (final s in await TransactionSplit.db.find(
      session,
      where: (s) => s.transactionId.inSet(transactionIds),
      orderBy: (s) => s.id,
    )) {
      result.putIfAbsent(s.transactionId, () => []).add(s);
    }
    return result;
  }

  /// Operations with a part in one of [categoryIds] (category filters).
  static Future<Set<int>> splitTransactionsIn(
    Session session,
    Set<int> categoryIds,
  ) async {
    if (categoryIds.isEmpty) return {};
    return {
      for (final s in await TransactionSplit.db.find(
        session,
        where: (s) => s.categoryId.inSet(categoryIds),
      ))
        s.transactionId,
    };
  }

  /// The period containing [date], months starting on the group's day.
  static Future<core.Period> period(
    Session session,
    int groupId,
    core.PeriodKind kind,
    core.LocalDate date,
  ) async {
    final group = await FinanceGroup.db.findById(session, groupId);
    return core.Period.containing(
      kind,
      date,
      monthStartDay: (group?.monthStartDay ?? 1).clamp(1, 28),
    );
  }

  /// Projection of each goal of the group to the end of [month], on the
  /// operations [ops] of [accountIds] (the month's, already read): spending,
  /// planned operations of the category still expected, and the pace of the
  /// rest (cahier des charges : « à ce rythme, dépassement de 45 € vers le
  /// 26 »).
  static Future<Map<int, core.GoalProjection>> projections(
    Session session,
    List<Goal> goals,
    List<core.SpendingCategory> categories,
    Set<int> accountIds,
    List<core.SpendingOperation> ops,
    core.Period month,
    core.LocalDate today,
  ) async {
    if (goals.isEmpty || !month.contains(today)) return const {};
    final inMonth = [
      for (final o in ops)
        if (month.contains(o.date)) o,
    ];
    final all = core.summarizeSpending(categories, inMonth);
    final variable = core.summarizeSpending(categories, [
      for (final o in inMonth)
        if (!o.planned) o,
    ]);
    final scheduled = accountIds.isEmpty
        ? const <ScheduledTransaction>[]
        : await ScheduledTransaction.db.find(
            session,
            where: (s) =>
                s.accountId.inSet(accountIds) &
                s.deletedAt.equals(null) &
                s.categoryId.notEquals(null) &
                (s.amountCents < 0),
          );
    final parents = {for (final c in categories) c.id: c.parentId};
    bool under(int? id, int goalCategory) {
      final seen = <int>{};
      while (id != null && seen.add(id)) {
        if (id == goalCategory) return true;
        id = parents[id];
      }
      return false;
    }

    Map<core.LocalDate, int> planned(int goalCategory) {
      final byDay = <core.LocalDate, int>{};
      for (final s in scheduled) {
        if (!under(s.categoryId, goalCategory)) continue;
        for (final due in ForecastService.operationOf(
          s,
        ).pendingUntil(month.last)) {
          if (due < month.start) continue;
          byDay[due] = (byDay[due] ?? 0) - s.amountCents;
        }
      }
      return byDay;
    }

    return {
      for (final g in goals)
        g.categoryId: core.projectGoal(
          spentCents: all.totals[g.categoryId] ?? 0,
          variableSpentCents: variable.totals[g.categoryId] ?? 0,
          goalCents: g.amountCents,
          start: month.start,
          end: month.end,
          today: today,
          plannedCents: planned(g.categoryId),
        ),
    };
  }

  /// Average monthly income of the three last complete months.
  static Future<int> averageMonthlyIncome(
    Session session,
    int groupId,
    core.LocalDate today,
  ) async {
    final ids = await accounts(session, groupId, null);
    final month = await period(session, groupId, core.PeriodKind.month, today);
    final from = month.shift(-3);
    final cats = await categories(session, groupId);
    final ops = await operations(session, ids, from.start, month.start);
    return core.summarizeSpending(cats, ops).incomeCents ~/ 3;
  }
}

/// [id] and every category below it.
Set<int> descendantsOf(int id, List<Category> all) {
  final result = <int>{id};
  var added = true;
  while (added) {
    added = false;
    for (final c in all) {
      if (c.parentId != null &&
          result.contains(c.parentId) &&
          result.add(c.id!)) {
        added = true;
      }
    }
  }
  return result;
}
