import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../endpoints/scheduled_endpoint.dart';
import '../generated/protocol.dart';
import 'spending_service.dart';

/// Analyses without AI over the accounts the user may see: bank fees,
/// unusual debits, reliability of the forecasts (core.insights).
abstract final class InsightsService {
  static const feeCodes = {'banking.bank_fees', 'banking.overdraft_interest'};

  static Future<Insights> compute(
    Session session,
    int groupId,
    core.LocalDate today,
  ) async {
    final Set<int> ids = await SpendingService.accounts(session, groupId, null);
    final month = await SpendingService.period(
      session,
      groupId,
      core.PeriodKind.month,
      today,
    );
    final yearStart = month.shift(-11).start;
    final rows = ids.isEmpty
        ? <BankTransaction>[]
        : await BankTransaction.db.find(
            session,
            where: (t) =>
                t.accountId.inSet(ids) &
                t.deletedAt.equals(null) &
                (t.date >= yearStart.toDb()) &
                (t.date < month.end.toDb()),
          );
    final categories = await Category.db.find(
      session,
      where: (c) => c.groupId.equals(groupId),
    );
    final feeRoots = {
      for (final c in categories)
        if (feeCodes.contains(c.standardCode)) c.id!,
    };
    final feeIds = {
      ...feeRoots,
      for (final c in categories)
        if (feeRoots.contains(c.parentId)) c.id!,
    };
    final byId = {for (final t in rows) t.id!: t};
    final ops = [
      for (final t in rows)
        core.InsightOperation(
          id: t.id!,
          date: t.date.toLocalDate(),
          amountCents: t.amountCents,
          label: t.cleanLabel,
          feeCategory: feeIds.contains(t.categoryId),
        ),
    ];
    final fees = core.bankFees(ops, month);
    final unusual = core.unusualOperations(
      ops,
      from: month.shift(-1).start,
    );

    // Planned operations of the three last complete months.
    var due = 0, paid = 0, late = 0;
    for (var i = -3; i < 0; i++) {
      final c = await ScheduledEndpoint().calendar(
        session,
        groupId,
        month.shift(i).start.toDb(),
      );
      for (final item in c.items) {
        if (item.status == OccurrenceStatus.skipped) continue;
        due++;
        if (item.status == OccurrenceStatus.paid) paid++;
        if (item.status == OccurrenceStatus.late) late++;
      }
    }

    // Variable spending of the last complete month: estimated from the
    // three before it, against what was spent.
    final last = month.shift(-1);
    final first = ids.isEmpty
        ? null
        : await BankTransaction.db.findFirstRow(
            session,
            where: (t) => t.accountId.inSet(ids) & t.deletedAt.equals(null),
            orderBy: (t) => t.date,
          );
    final estimate = core.estimateVariableSpending(
      categories: await SpendingService.categories(session, groupId),
      operations: await SpendingService.operations(
        session,
        ids,
        last.shift(-3).start,
        last.end,
      ),
      current: last,
      today: last.end.addDays(-1),
      historyStart: first?.date.toLocalDate(),
    );
    final known = estimate.months.isNotEmpty;

    return Insights(
      feeMonths: [for (final p in fees.months) p.start.toDb()],
      feePerMonthCents: fees.perMonthCents,
      feeTotalCents: fees.totalCents,
      feeLines: [
        for (final l in fees.byLabel.take(10))
          FeeLine(label: l.label, cents: l.cents, count: l.count),
      ],
      feeOperations: [
        for (final o in fees.operations.take(20)) byId[o.id]!,
      ],
      unusual: [
        for (final u in unusual.take(10))
          UnusualInfo(
            kind: u.kind.name,
            transaction: byId[u.operation.id]!,
            usualCents: u.usualCents,
            basis: u.basis,
          ),
      ],
      plannedDue: due,
      plannedPaid: paid,
      plannedLate: late,
      variableMonth: known ? last.start.toDb() : null,
      variableEstimateCents: known ? estimate.monthlyCents : null,
      variableActualCents: known ? estimate.spentThisMonthCents : null,
    );
  }
}
