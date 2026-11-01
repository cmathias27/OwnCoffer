import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../core/portable_sql.dart';
import '../generated/protocol.dart';
import 'spending_service.dart';

/// Balances, reconciliation and forecast of one account, computed by the
/// shared engine (cahier des charges : solde réel, actuel, prévisionnel).
abstract final class ForecastService {
  static core.Recurrence recurrenceOf(ScheduledTransaction s) =>
      core.Recurrence(
        frequency: core.Frequency.values.byName(s.frequency.name),
        interval: s.interval,
        start: s.startDate.toLocalDate(),
        end: s.endDate?.toLocalDate(),
        count: s.occurrenceCount,
      );

  static core.ScheduledOperation operationOf(ScheduledTransaction s) =>
      core.ScheduledOperation(
        id: s.id!,
        amountCents: s.amountCents,
        label: s.label,
        recurrence: recurrenceOf(s),
        nextDue: s.nextDue?.toLocalDate(),
        matchPattern: s.matchPattern,
        dateToleranceDays: s.dateToleranceDays,
        amountTolerancePercent: s.amountTolerancePercent,
      );

  static core.RealOperation realOf(BankTransaction t) => core.RealOperation(
    id: t.id!,
    date: t.date.toLocalDate(),
    amountCents: t.amountCents,
    label: core.CleanedLabel(
      t.cleanLabel,
      core.normalizeForMatch('${t.rawLabel} ${t.memo ?? ''}'),
      core.OperationKind.values.asNameMap()[t.operationKind] ??
          core.OperationKind.other,
    ),
  );

  /// Links [transaction] to the occurrence [due] of [scheduled] and moves
  /// the next due date after it.
  static Future<void> link(
    Session session,
    ScheduledTransaction scheduled,
    core.LocalDate due,
    BankTransaction transaction, {
    Transaction? tx,
  }) async {
    await BankTransaction.db.updateRow(
      session,
      transaction.copyWith(
        scheduledId: scheduled.id,
        scheduledDueDate: due.toDb(),
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: tx,
    );
    final current = scheduled.nextDue?.toLocalDate();
    if (current == null || current <= due) {
      final next = recurrenceOf(scheduled).nextAfter(due);
      await ScheduledTransaction.db.updateRow(
        session,
        scheduled.copyWith(
          nextDue: (next ?? due.addDays(1)).toDb(),
          // A finished one-off keeps a nextDue after its only date: nothing
          // pending any more.
        ),
        transaction: tx,
      );
    }
  }

  static Future<ForecastResult> compute(
    Session session,
    Account account,
    core.LocalDate today, {
    int horizonDays = 30,
    bool variable = false,
  }) async {
    final estimate = variable
        ? await _variableEstimate(session, account, today)
        : null;
    return session.db.transaction((tx) async {
      final scheduledRows = await ScheduledTransaction.db.find(
        session,
        where: (s) =>
            s.accountId.equals(account.id!) & s.deletedAt.equals(null),
        transaction: tx,
      );
      // Only the recent and future operations are needed one by one; the
      // balances are summed by the database (100 000 operations).
      final ops = await recentOperations(session, account, today, tx: tx);

      // 1. Reconcile first, so a realised occurrence is never counted twice.
      final byId = {for (final s in scheduledRows) s.id!: s};
      final unlinked = [
        for (final t in ops)
          if (t.scheduledId == null &&
              t.date.toLocalDate() > today.addDays(-60))
            t,
      ];
      final matches = core.reconcile(
        scheduled: [for (final s in scheduledRows) operationOf(s)],
        unlinkedOperations: [for (final t in unlinked) realOf(t)],
        today: today,
      );
      final opById = {for (final t in unlinked) t.id!: t};
      var auto = 0;
      final proposals = <ReconciliationProposal>[];
      for (final m in matches) {
        final t = opById[m.operationId]!;
        final s = byId[m.scheduledId]!;
        if (m.exact) {
          await link(session, s, m.dueDate, t, tx: tx);
          byId[s.id!] = (await ScheduledTransaction.db.findById(
            session,
            s.id!,
            transaction: tx,
          ))!;
          auto++;
        } else {
          proposals.add(
            ReconciliationProposal(
              scheduledId: s.id!,
              dueDate: m.dueDate.toDb(),
              transactionId: t.id!,
              label: t.cleanLabel,
              amountCents: t.amountCents,
              date: t.date,
            ),
          );
        }
      }

      // 2. Balances.
      final balances = await balancesOf(session, account, today, tx: tx);

      // 3. Forecast (proposals not yet confirmed still count as expected).
      final f = _engine(
        account,
        today,
        horizonDays,
        balances.currentCents,
        byId.values,
        ops,
        estimate,
      );
      final lowest = f.lowest;
      return ForecastResult(
        accountId: account.id!,
        today: today.toDb(),
        until: f.until.toDb(),
        currentBalanceCents: balances.currentCents,
        clearedBalanceCents: balances.clearedCents,
        alertThresholdCents: account.alertThresholdCents,
        days: [
          for (final d in f.days)
            ForecastDay(date: d.date.toDb(), balanceCents: d.balanceCents),
        ],
        events: [
          for (final e in f.events)
            ForecastEventInfo(
              date: e.date.toDb(),
              amountCents: e.amountCents,
              label: e.label,
              scheduledId: e.scheduledId as int?,
              dueDate: e.dueDate?.toDb(),
            ),
        ],
        lowestDate: lowest.date.toDb(),
        lowestBalanceCents: lowest.balanceCents,
        firstBelowThresholdDate: f.firstBelowThreshold?.date.toDb(),
        missed: [
          for (final m in f.missed)
            MissedOccurrenceInfo(
              scheduledId: m.scheduledId as int,
              label: byId[m.scheduledId]!.label,
              dueDate: m.dueDate.toDb(),
              amountCents: m.amountCents,
            ),
        ],
        proposals: proposals,
        autoReconciledCount: auto,
        variable: estimate == null
            ? null
            : VariableEstimateInfo(
                monthlyCents: estimate.$1.monthlyCents,
                spentThisMonthCents: estimate.$1.spentThisMonthCents,
                leftThisMonthCents: estimate.$1.leftThisMonthCents,
                horizonCents: f.variableCents,
                months: [for (final m in estimate.$1.months) m.start.toDb()],
                categories: [
                  for (final c in estimate.$1.categories)
                    VariableCategoryInfo(
                      categoryId: c.categoryId,
                      monthsCents: c.monthsCents,
                      monthlyCents: c.monthlyCents,
                    ),
                ],
              ),
      );
    });
  }

  /// Days before today whose operations may still realise a scheduled
  /// occurrence (reconciliation looks 60 days back).
  static const _reconcileDays = 60;

  /// Operations of [account] from 60 days before [today] on, future ones
  /// included: what reconciliation and the forecast look at one by one.
  static Future<List<BankTransaction>> recentOperations(
    Session session,
    Account account,
    core.LocalDate today, {
    Transaction? tx,
  }) => BankTransaction.db.find(
    session,
    where: (t) =>
        t.accountId.equals(account.id!) &
        t.deletedAt.equals(null) &
        (t.date > today.addDays(-_reconcileDays).toDb()),
    transaction: tx,
  );

  /// The balances of [account], summed by the database: the same as
  /// [core.computeBalances] over all its operations, without loading them.
  static Future<core.AccountBalances> balancesOf(
    Session session,
    Account account,
    core.LocalDate today, {
    Transaction? tx,
  }) async {
    final rows = await session.db.unsafeQuery(
      // Standard SQL, the same on PostgreSQL and SQLite.
      'SELECT '
      'CAST(COALESCE(SUM(CASE WHEN "cleared" THEN "amountCents" END), 0) '
      'AS BIGINT), '
      'CAST(COALESCE(SUM(CASE WHEN "date" <= @today THEN "amountCents" END), '
      '0) AS BIGINT), '
      'CAST(COALESCE(SUM("amountCents"), 0) AS BIGINT) '
      'FROM "transactions" '
      'WHERE "accountId" = @account AND "deletedAt" IS NULL',
      parameters: QueryParameters.named({
        'account': account.id!,
        'today': session.sqlTimestamp(today.toDb()),
      }),
      transaction: tx,
    );
    final r = rows.first;
    final initial = account.initialBalanceCents;
    return core.AccountBalances(
      core.sumCents([initial, r[0] as int]),
      core.sumCents([initial, r[1] as int]),
      core.sumCents([initial, r[2] as int]),
    );
  }

  /// The shared engine on the account's data, with [extra] planned
  /// operations (purchase simulator).
  static core.Forecast _engine(
    Account account,
    core.LocalDate today,
    int horizonDays,
    int currentBalanceCents,
    Iterable<ScheduledTransaction> scheduled,
    List<BankTransaction> ops,
    (core.VariableEstimate, core.Period)? estimate, {
    List<core.ScheduledOperation> extra = const [],
  }) => core.computeForecast(
    variableSpending: estimate == null
        ? const {}
        : core.spreadVariableSpending(
            estimate.$1,
            current: estimate.$2,
            today: today,
            until: today.addDays(horizonDays),
          ),
    currentBalanceCents: currentBalanceCents,
    today: today,
    horizonDays: horizonDays,
    alertThresholdCents: account.alertThresholdCents,
    scheduled: [for (final s in scheduled) operationOf(s), ...extra],
    futureOperations: [
      for (final t in ops)
        if (t.date.toLocalDate() > today) realOf(t),
    ],
  );

  /// The purchase simulator: the account's forecast once per payment option
  /// (after the usual reconciliation, as when the forecast is opened).
  /// Nothing is saved.
  static Future<List<core.PurchaseScenario>> simulatePurchase(
    Session session,
    Account account,
    core.LocalDate today, {
    required int amountCents,
    required core.LocalDate date,
    required core.LocalDate target,
    bool variable = true,
  }) async {
    final until = core.purchaseHorizon(amountCents, date, target);
    final horizon = today.daysUntil(until);
    // Links the occurrences that arrived, as opening the forecast does.
    await compute(session, account, today, horizonDays: horizon);
    final estimate = variable
        ? await _variableEstimate(session, account, today)
        : null;
    final scheduled = await ScheduledTransaction.db.find(
      session,
      where: (s) => s.accountId.equals(account.id!) & s.deletedAt.equals(null),
    );
    final ops = await recentOperations(session, account, today);
    final balance = (await balancesOf(session, account, today)).currentCents;
    return core.simulatePurchase(
      amountCents: amountCents,
      date: date,
      target: target,
      until: until,
      forecast: (extra) => _engine(
        account,
        today,
        horizon,
        balance,
        scheduled,
        ops,
        estimate,
        extra: extra,
      ),
    );
  }

  /// Variable spending of [account] over the three last complete budget
  /// months, and the current budget month.
  static Future<(core.VariableEstimate, core.Period)> _variableEstimate(
    Session session,
    Account account,
    core.LocalDate today,
  ) async {
    final current = await SpendingService.period(
      session,
      account.groupId,
      core.PeriodKind.month,
      today,
    );
    final first = await BankTransaction.db.findFirstRow(
      session,
      where: (t) => t.accountId.equals(account.id!) & t.deletedAt.equals(null),
      orderBy: (t) => t.date,
    );
    final ids = {account.id!};
    final estimate = core.estimateVariableSpending(
      categories: await SpendingService.categories(session, account.groupId),
      operations: await SpendingService.operations(
        session,
        ids,
        current.shift(-3).start,
        current.end,
      ),
      current: current,
      today: today,
      historyStart: first?.date.toLocalDate(),
    );
    return (estimate, current);
  }
}
