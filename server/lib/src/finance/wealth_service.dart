import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../endpoints/loan_endpoint.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import 'forecast_service.dart';
import 'plan_inputs.dart';
import 'spending_service.dart';

/// Net worth, regulated savings and financial health (decision 0050), on
/// the accounts the user may see. Every figure comes from the engine.
abstract final class WealthService {
  static Future<WealthOverview> overview(Session session, int groupId) async {
    final accounts = await Access.visibleAccounts(session, groupId);
    final today = PlanInputs.today();
    final lines = [
      for (final a in accounts)
        WealthAccount(
          accountId: a.id!,
          name: a.name,
          kind: a.kind,
          balanceCents: (await ForecastService.balancesOf(
            session,
            a,
            today,
          )).currentCents,
        ),
    ];
    final assets = await Asset.db.find(
      session,
      where: (x) => x.groupId.equals(groupId),
      orderBy: (x) => x.name,
    );
    final loans = await LoanEndpoint().overview(session, groupId);
    final accountsCents = core.sumCents([
      for (final l in lines) l.balanceCents,
    ]);
    final assetsCents = core.sumCents([for (final x in assets) x.valueCents]);
    return WealthOverview(
      accounts: lines,
      assets: assets,
      accountsCents: accountsCents,
      assetsCents: assetsCents,
      loansCents: loans.totalRemainingCents,
      netWorthCents: core.sumCents([
        accountsCents,
        assetsCents,
        -loans.totalRemainingCents,
      ]),
    );
  }

  /// The regulated savings accounts among the visible ones.
  static Future<List<RegulatedSavingsInfo>> savings(
    Session session,
    int groupId,
  ) async {
    final today = PlanInputs.today();
    final result = <RegulatedSavingsInfo>[];
    for (final a in await Access.visibleAccounts(session, groupId)) {
      final kind = a.regulatedKind;
      if (kind == null) continue;
      final balance = (await ForecastService.balancesOf(
        session,
        a,
        today,
      )).currentCents;
      final ceiling = core.regulatedCeilingCents(
        core.RegulatedSavings.values.byName(kind.name),
      );
      final rate = a.interestRateBp;
      final (soFar, year) = rate == null
          ? (null, null)
          : await _interest(session, a, today.year, today, balance, rate);
      result.add(
        RegulatedSavingsInfo(
          accountId: a.id!,
          name: a.name,
          kind: kind,
          balanceCents: balance,
          ceilingCents: ceiling,
          roomCents: ceiling - balance > 0 ? ceiling - balance : 0,
          rateBp: rate,
          interestSoFarCents: soFar,
          interestYearCents: year,
        ),
      );
    }
    return result;
  }

  /// Interest of [year] on [account] under the fortnight rule: over the
  /// fortnights already gone, and over the whole year if nothing moves any
  /// more. [balance] is its balance on [today].
  static Future<(int, int)> _interest(
    Session session,
    Account account,
    int year,
    core.LocalDate today,
    int balance,
    int rateBp,
  ) async {
    final rows = await BankTransaction.db.find(
      session,
      where: (t) =>
          t.accountId.equals(account.id!) &
          t.deletedAt.equals(null) &
          (t.date >= core.LocalDate(year, 1, 1).toDb()) &
          (t.date <= today.toDb()),
    );
    final opening = core.sumCents([
      balance,
      for (final t in rows) -t.amountCents,
    ]);
    final movements = [
      for (final t in rows)
        if (t.date.year == year) (t.date.toLocalDate(), t.amountCents),
    ];
    int over(int fortnights) => core.fortnightInterest(
      openingCents: opening,
      movements: movements,
      year: year,
      rateBp: rateBp,
      fortnights: fortnights,
    );
    return (over(core.fortnightsOver(year, today)), over(24));
  }

  /// Estimated interest of [year] on the regulated accounts with a rate.
  static Future<int> yearInterest(
    Session session,
    List<Account> accounts,
    int year,
  ) async {
    final today = PlanInputs.today();
    var total = 0;
    for (final a in accounts) {
      if (a.regulatedKind == null || a.interestRateBp == null) continue;
      final balance = (await ForecastService.balancesOf(
        session,
        a,
        today,
      )).currentCents;
      final (soFar, _) = await _interest(
        session,
        a,
        year,
        today,
        balance,
        a.interestRateBp!,
      );
      total += soFar;
    }
    return total;
  }

  /// Health score over the six last complete budget months.
  static Future<HealthReport> health(Session session, int groupId) async {
    final accounts = await Access.visibleAccounts(session, groupId);
    final today = PlanInputs.today();
    var savings = 0;
    for (final a in accounts) {
      if (a.kind != AccountKind.savings) continue;
      savings += (await ForecastService.balancesOf(
        session,
        a,
        today,
      )).currentCents;
    }
    final month = await SpendingService.period(
      session,
      groupId,
      core.PeriodKind.month,
      today,
    );
    const months = 6;
    final first = month.shift(-months);
    final categories = await SpendingService.categories(session, groupId);
    final ops = await SpendingService.operations(
      session,
      {for (final a in accounts) a.id!},
      first.start,
      month.start,
    );
    final summaries = [
      for (var i = -months; i < 0; i++)
        core.summarizeSpending(
          categories,
          ops.where((o) => month.shift(i).contains(o.date)),
        ),
    ];
    // Months with no operation at all are before the history: left out.
    final known = [
      for (final s in summaries)
        if (s.incomeCents != 0 || s.expenseCents != 0) s,
    ];
    final recent = known.length > 3 ? known.sublist(known.length - 3) : known;
    final income = recent.isEmpty
        ? 0
        : recent.fold(0, (a, s) => a + s.incomeCents) ~/ recent.length;
    final expense = recent.isEmpty
        ? 0
        : recent.fold(0, (a, s) => a + s.expenseCents) ~/ recent.length;
    final loans = await LoanEndpoint().overview(session, groupId);
    final indicators = [
      core.emergencyIndicator(savings, expense),
      core.savingsRateIndicator(income, expense),
      core.debtIndicator(loans.totalMonthlyCents, income),
      core.regularityIndicator([
        for (final s in known) s.incomeCents - s.expenseCents,
      ]),
    ];
    return HealthReport(
      score: core.healthScore(indicators),
      indicators: [
        for (final i in indicators)
          HealthIndicatorInfo(
            key: i.key,
            grade: HealthGrade.values.byName(i.level.name),
            value: i.value,
          ),
      ],
      savingsCents: savings,
      monthlyIncomeCents: income,
      monthlyExpenseCents: expense,
      monthlyLoanCents: loans.totalMonthlyCents,
      months: known.length,
    );
  }

  /// Review of the calendar [year]: totals, biggest expenses and what the
  /// tax return needs.
  static Future<YearReview> year(Session session, int groupId, int year) async {
    final accounts = await Access.visibleAccounts(session, groupId);
    final Set<int> ids = {for (final a in accounts) a.id!};
    final from = core.LocalDate(year, 1, 1);
    final to = core.LocalDate(year + 1, 1, 1);
    final categories = await SpendingService.categories(session, groupId);
    final ops = await SpendingService.operations(session, ids, from, to);
    final summary = core.summarizeSpending(categories, ops);
    final all = await Category.db.find(
      session,
      where: (c) => c.groupId.equals(groupId),
    );
    YearCategoryLine line(int id) => YearCategoryLine(
      categoryId: id,
      amountCents: summary.totals[id] ?? 0,
      count: summary.counts[id] ?? 0,
    );
    final top = [
      for (final c in all)
        if (c.kind == CategoryKind.expense &&
            c.parentId == null &&
            (summary.totals[c.id] ?? 0) > 0)
          line(c.id!),
    ]..sort((a, b) => b.amountCents.compareTo(a.amountCents));
    final taxed = [
      for (final c in all)
        if (c.taxRelevant) c,
    ];
    final Set<int> taxIds = {
      for (final c in taxed) ...descendantsOf(c.id!, all),
    };
    final taxOps = taxIds.isEmpty || ids.isEmpty
        ? <BankTransaction>[]
        : await BankTransaction.db.find(
            session,
            where: (t) =>
                t.accountId.inSet(ids) &
                t.deletedAt.equals(null) &
                t.categoryId.inSet(taxIds) &
                (t.date >= from.toDb()) &
                (t.date < to.toDb()),
            orderBy: (t) => t.date,
          );
    return YearReview(
      year: year,
      incomeCents: summary.incomeCents,
      expenseCents: summary.expenseCents,
      savingsCents: summary.savingsCents,
      topExpenses: top.take(10).toList(),
      taxCategories: [for (final c in taxed) line(c.id!)],
      taxOperations: taxOps,
      interestCents: await yearInterest(session, accounts, year),
    );
  }
}
