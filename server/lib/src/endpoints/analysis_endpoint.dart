import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/forecast_service.dart';
import '../finance/spending_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/scopes.dart';
import '../finance/insights_service.dart';

/// Income and expenses by category over a week, a month, a quarter or a
/// year, computed
/// by the shared engine on the accounts the user may see.
class AnalysisEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// Periods of history by default, and at most.
  static const _history = 6;
  static const _maxHistory = 24;

  /// [periods]: how many periods the history holds, the current one
  /// included (4 to 24, 6 by default).
  Future<SpendingReport> report(
    Session session,
    int groupId,
    BudgetPeriod period,
    DateTime date, {
    int? accountId,
    int? periods,
  }) async {
    final count = (periods ?? _history).clamp(4, _maxHistory);
    final ids = await SpendingService.accounts(session, groupId, accountId);
    final current = await SpendingService.period(
      session,
      groupId,
      _kind(period),
      _local(date),
    );
    final first = current.shift(1 - count);
    final categories = await SpendingService.categories(session, groupId);
    final ops = await SpendingService.operations(
      session,
      ids,
      first.start,
      current.end,
    );

    core.SpendingSummary summary(core.Period p) => core.summarizeSpending(
      categories,
      ops.where((o) => p.contains(o.date)),
    );

    final history = [
      for (var i = 1 - count; i <= 0; i++)
        (current.shift(i), summary(current.shift(i))),
    ];
    final now = history.last.$2;
    final previous = history[history.length - 2].$2;
    final earlier = history.sublist(history.length - 4, history.length - 1);
    final goalRows = period == BudgetPeriod.month
        ? await Goal.db.find(session, where: (g) => g.groupId.equals(groupId))
        : const <Goal>[];
    final goals = {for (final g in goalRows) g.categoryId: g.amountCents};
    final projections = await SpendingService.projections(
      session,
      goalRows,
      categories,
      ids,
      ops,
      current,
      core.LocalDate.fromDateTime(DateTime.now().toUtc()),
    );

    final shown = {
      for (final (_, s) in history) ...s.totals.keys,
      ...goals.keys,
    };
    return SpendingReport(
      period: period,
      start: current.start.toDb(),
      last: current.last.toDb(),
      incomeCents: now.incomeCents,
      expenseCents: now.expenseCents,
      savingsCents: now.savingsCents,
      netCents: now.netCents,
      unclassifiedCount: now.unclassifiedCount,
      unclassifiedInCents: now.unclassifiedInCents,
      unclassifiedOutCents: now.unclassifiedOutCents,
      categories: [
        for (final id in shown)
          CategoryFlow(
            categoryId: id,
            amountCents: now.totals[id] ?? 0,
            count: now.counts[id] ?? 0,
            previousCents: previous.totals[id] ?? 0,
            averageCents:
                earlier.fold(0, (a, s) => a + (s.$2.totals[id] ?? 0)) ~/
                earlier.length,
            history: [for (final (_, s) in history) s.totals[id] ?? 0],
            goalCents: goals[id],
            projectedCents: projections[id]?.projectedCents,
            projectedOverDate: projections[id]?.overDate?.toDb(),
          ),
      ],
      history: [
        for (final (p, s) in history)
          PeriodTotals(
            start: p.start.toDb(),
            incomeCents: s.incomeCents,
            expenseCents: s.expenseCents,
            savingsCents: s.savingsCents,
          ),
      ],
    );
  }

  /// The operations behind a figure of the report: one category (its
  /// sub-categories included) or the unclassified ones, largest first.
  Future<List<BankTransaction>> operations(
    Session session,
    int groupId,
    BudgetPeriod period,
    DateTime date, {
    int? categoryId,
    bool? unclassified,
    int? accountId,
  }) async {
    final ids = await SpendingService.accounts(session, groupId, accountId);
    final p = await SpendingService.period(
      session,
      groupId,
      _kind(period),
      _local(date),
    );
    final Set<int> categoryIds = {};
    if (categoryId != null) {
      final all = await Category.db.find(
        session,
        where: (c) => c.groupId.equals(groupId),
      );
      if (!all.any((c) => c.id == categoryId)) {
        throw AccessDeniedException(code: 'category_access_denied');
      }
      categoryIds.addAll(descendantsOf(categoryId, all));
    }
    final Set<int> splitIds = await SpendingService.splitTransactionsIn(
      session,
      categoryIds,
    );
    final rows = await BankTransaction.db.find(
      session,
      where: (t) {
        Expression e =
            t.accountId.inSet(ids) &
            t.deletedAt.equals(null) &
            (t.date >= p.start.toDb()) &
            (t.date < p.end.toDb());
        if (categoryIds.isNotEmpty) {
          e =
              e &
              (splitIds.isEmpty
                  ? t.categoryId.inSet(categoryIds)
                  : (t.categoryId.inSet(categoryIds) | t.id.inSet(splitIds)));
        }
        if (unclassified == true) e = e & t.categoryId.equals(null);
        return e;
      },
      orderByList: (t) => [t.date.desc(), t.id.desc()],
      limit: 1000,
    );
    if (unclassified == true) {
      rows.removeWhere((t) => t.transferPairId != null);
    }
    rows.sort(
      (a, b) => a.amountCents.abs().compareTo(b.amountCents.abs()) * -1,
    );
    return rows;
  }

  /// What is left to spend until the end of the budget month (the next pay
  /// day), planned operations counted: checking accounts the user may see,
  /// or the one asked for.
  Future<LeftToLiveReport> leftToLive(
    Session session,
    int groupId, {
    int? accountId,
  }) async {
    final List<Account> accounts;
    if (accountId != null) {
      final a = await Access.requireAccount(session, accountId);
      if (a.groupId != groupId) {
        throw AccessDeniedException(code: 'account_access_denied');
      }
      accounts = [a];
    } else {
      accounts = [
        for (final a in await Access.visibleAccounts(session, groupId))
          if (a.kind == AccountKind.checking) a,
      ];
    }
    final today = core.LocalDate.fromDateTime(DateTime.now().toUtc());
    final month = await SpendingService.period(
      session,
      groupId,
      core.PeriodKind.month,
      today,
    );
    final horizon = today.daysUntil(month.last).clamp(1, 366);
    var balance = 0, debits = 0, credits = 0;
    for (final a in accounts) {
      final f = await ForecastService.compute(
        session,
        a,
        today,
        horizonDays: horizon,
      );
      balance += f.currentBalanceCents;
      for (final e in f.events) {
        if (e.date.toLocalDate() > month.last) continue;
        if (e.amountCents < 0) {
          debits += e.amountCents;
        } else {
          credits += e.amountCents;
        }
      }
      // Late planned debits are still expected.
      for (final m in f.missed) {
        if (m.amountCents < 0) debits += m.amountCents;
      }
    }
    final r = core.LeftToLive(
      today: today,
      last: month.last,
      balanceCents: balance,
      plannedDebitsCents: debits,
      plannedCreditsCents: credits,
    );
    return LeftToLiveReport(
      today: today.toDb(),
      last: month.last.toDb(),
      balanceCents: r.balanceCents,
      plannedDebitsCents: r.plannedDebitsCents,
      plannedCreditsCents: r.plannedCreditsCents,
      leftCents: r.leftCents,
      daysLeft: r.daysLeft,
      perDayCents: r.perDayCents,
      accountIds: [for (final a in accounts) a.id!],
    );
  }

  /// Bank fees, unusual debits and how reliable the forecasts were, on the
  /// accounts the user may see (computed without AI).
  Future<Insights> insights(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    final n = DateTime.now();
    return InsightsService.compute(
      session,
      groupId,
      core.LocalDate(n.year, n.month, n.day),
    );
  }

  static const _feeCodes = {'banking.bank_fees', 'banking.overdraft_interest'};

  /// Month-end review of the budget month containing [date]: rises and drops
  /// against the three previous months, goals exceeded, bank fees, biggest
  /// expenses, subscriptions charged another amount or new.
  Future<MonthReview> review(
    Session session,
    int groupId,
    DateTime date, {
    int? accountId,
  }) async {
    final ids = await SpendingService.accounts(session, groupId, accountId);
    final month = await SpendingService.period(
      session,
      groupId,
      core.PeriodKind.month,
      _local(date),
    );
    final first = month.shift(-3);
    final categories = await SpendingService.categories(session, groupId);
    final ops = await SpendingService.operations(
      session,
      ids,
      first.start,
      month.end,
    );
    core.SpendingSummary summary(core.Period p) => core.summarizeSpending(
      categories,
      ops.where((o) => p.contains(o.date)),
    );
    final now = summary(month);
    final earlier = [for (var i = -3; i < 0; i++) summary(month.shift(i))];
    final previous = earlier.last;
    final average = <int, int>{};
    for (final s in earlier) {
      for (final e in s.totals.entries) {
        average[e.key] = (average[e.key] ?? 0) + e.value;
      }
    }
    average.updateAll((_, v) => v ~/ 3);

    final parents = {for (final c in categories) ?c.parentId};
    final leaves = [
      for (final c in categories)
        if (c.kind == core.StandardKind.expense && !parents.contains(c.id))
          c.id,
    ];
    List<CategoryChangeInfo> info(List<core.CategoryChange> changes) => [
      for (final c in changes)
        CategoryChangeInfo(
          categoryId: c.categoryId,
          amountCents: c.amountCents,
          averageCents: c.referenceCents,
        ),
    ];

    final goals = await Goal.db.find(
      session,
      where: (g) => g.groupId.equals(groupId),
    );
    final goalsOver = [
      for (final g in goals)
        if ((now.totals[g.categoryId] ?? 0) > g.amountCents)
          CategoryFlow(
            categoryId: g.categoryId,
            amountCents: now.totals[g.categoryId] ?? 0,
            count: now.counts[g.categoryId] ?? 0,
            previousCents: previous.totals[g.categoryId] ?? 0,
            averageCents: average[g.categoryId] ?? 0,
            history: const [],
            goalCents: g.amountCents,
          ),
    ];

    final rows = ids.isEmpty
        ? <BankTransaction>[]
        : await BankTransaction.db.find(
            session,
            where: (t) =>
                t.accountId.inSet(ids) &
                t.deletedAt.equals(null) &
                (t.date >= month.start.toDb()) &
                (t.date < month.end.toDb()),
          );
    final groupCategories = await Category.db.find(
      session,
      where: (c) => c.groupId.equals(groupId),
    );
    final feeIds = <int>{
      for (final c in groupCategories)
        if (_feeCodes.contains(c.standardCode))
          ...descendantsOf(c.id!, groupCategories),
    };
    final kinds = {for (final c in groupCategories) c.id!: c.kind};
    final fees = [
      for (final t in rows)
        if (feeIds.contains(t.categoryId)) t,
    ]..sort((a, b) => a.date.compareTo(b.date));
    final biggest = [
      for (final t in rows)
        if (t.amountCents < 0 &&
            t.transferPairId == null &&
            (t.categoryId == null ||
                kinds[t.categoryId] == CategoryKind.expense))
          t,
    ]..sort((a, b) => a.amountCents.compareTo(b.amountCents));

    final subscriptions = ids.isEmpty
        ? <ScheduledTransaction>[]
        : await ScheduledTransaction.db.find(
            session,
            where: (s) =>
                s.accountId.inSet(ids) &
                s.deletedAt.equals(null) &
                s.subscription.equals(true),
          );
    final byId = {for (final s in subscriptions) s.id!: s};
    final changes = [
      for (final t in rows)
        if (byId[t.scheduledId] case final s?)
          if (t.amountCents != s.amountCents)
            SubscriptionChange(
              scheduledId: s.id!,
              label: s.label,
              plannedCents: s.amountCents,
              actualCents: t.amountCents,
              transactionId: t.id!,
            ),
    ];
    final start = month.start.toDb(), end = month.end.toDb();
    final added = [
      for (final s in subscriptions)
        if (!s.createdAt.isBefore(start) && s.createdAt.isBefore(end)) s,
    ];

    return MonthReview(
      start: month.start.toDb(),
      last: month.last.toDb(),
      incomeCents: now.incomeCents,
      expenseCents: now.expenseCents,
      savingsCents: now.savingsCents,
      netCents: now.netCents,
      previousNetCents: previous.netCents,
      rises: info(core.notableChanges(now.totals, average, leaves)),
      drops: info(
        core.notableChanges(now.totals, average, leaves, rises: false),
      ),
      goalsOver: goalsOver,
      bankFeesCents: fees.fold(0, (a, t) => a - t.amountCents),
      bankFees: fees,
      biggestExpenses: biggest.take(5).toList(),
      subscriptionChanges: changes,
      newSubscriptions: added,
      unclassifiedCount: now.unclassifiedCount,
    );
  }

  static core.PeriodKind _kind(BudgetPeriod p) =>
      core.PeriodKind.values.byName(p.name);

  static core.LocalDate _local(DateTime d) {
    final u = d.toUtc();
    return core.LocalDate(u.year, u.month, u.day);
  }
}
