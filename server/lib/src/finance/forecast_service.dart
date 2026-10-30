import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';

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
  }) async {
    return session.db.transaction((tx) async {
      final scheduledRows = await ScheduledTransaction.db.find(
        session,
        where: (s) =>
            s.accountId.equals(account.id!) & s.deletedAt.equals(null),
        transaction: tx,
      );
      final ops = await BankTransaction.db.find(
        session,
        where: (t) =>
            t.accountId.equals(account.id!) & t.deletedAt.equals(null),
        transaction: tx,
      );

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
      final balances = core.computeBalances(
        initialBalanceCents: account.initialBalanceCents,
        operations: [
          for (final t in ops)
            core.BalanceInput(
              t.date.toLocalDate(),
              t.amountCents,
              cleared: t.cleared,
            ),
        ],
        today: today,
      );

      // 3. Forecast (proposals not yet confirmed still count as expected).
      final f = core.computeForecast(
        currentBalanceCents: balances.currentCents,
        today: today,
        horizonDays: horizonDays,
        alertThresholdCents: account.alertThresholdCents,
        scheduled: [for (final s in byId.values) operationOf(s)],
        futureOperations: [
          for (final t in ops)
            if (t.date.toLocalDate() > today) realOf(t),
        ],
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
      );
    });
  }
}
