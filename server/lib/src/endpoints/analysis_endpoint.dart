import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/spending_service.dart';
import '../generated/protocol.dart';
import '../security/scopes.dart';

/// Income and expenses by category over a week, a month or a year, computed
/// by the shared engine on the accounts the user may see.
class AnalysisEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  static const _history = 6;

  Future<SpendingReport> report(
    Session session,
    int groupId,
    BudgetPeriod period,
    DateTime date, {
    int? accountId,
  }) async {
    final ids = await SpendingService.accounts(session, groupId, accountId);
    final current = await SpendingService.period(
      session,
      groupId,
      _kind(period),
      _local(date),
    );
    final first = current.shift(1 - _history);
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
      for (var i = 1 - _history; i <= 0; i++)
        (current.shift(i), summary(current.shift(i))),
    ];
    final now = history.last.$2;
    final previous = history[history.length - 2].$2;
    final earlier = history.sublist(history.length - 4, history.length - 1);
    final goals = period == BudgetPeriod.month
        ? {
            for (final g in await Goal.db.find(
              session,
              where: (g) => g.groupId.equals(groupId),
            ))
              g.categoryId: g.amountCents,
          }
        : const <int, int>{};

    final shown = {...now.totals.keys, ...previous.totals.keys, ...goals.keys};
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
            goalCents: goals[id],
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
    final rows = await BankTransaction.db.find(
      session,
      where: (t) {
        Expression e =
            t.accountId.inSet(ids) &
            t.deletedAt.equals(null) &
            (t.date >= p.start.toDb()) &
            (t.date < p.end.toDb());
        if (categoryIds.isNotEmpty) e = e & t.categoryId.inSet(categoryIds);
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

  static core.PeriodKind _kind(BudgetPeriod p) =>
      core.PeriodKind.values.byName(p.name);

  static core.LocalDate _local(DateTime d) {
    final u = d.toUtc();
    return core.LocalDate(u.year, u.month, u.day);
  }
}
