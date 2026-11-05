import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';

/// A stored loan as the engine sees it (shared/loans).
abstract final class LoanTermsOf {
  static core.LoanTerms terms(Loan l) => core.LoanTerms(
    principalCents: l.principalCents,
    annualRateMilli: l.annualRateMilli,
    months: l.durationMonths,
    firstDue: l.firstDueDate.toLocalDate(),
    insuranceMonthlyCents: l.insuranceMonthlyCents,
    paymentCents: l.paymentCents,
    disbursementDate: l.disbursementDate?.toLocalDate(),
    firstInterestCents: l.firstInterestCents,
  );

  /// The loan's events for the engine (oldest first).
  static List<core.LoanChange> changes(Loan l) => [
    for (final e in l.events ?? const <LoanEvent>[])
      core.LoanChange(
        date: e.date.toLocalDate(),
        annualRateMilli: e.annualRateMilli,
        paymentCents: e.paymentCents,
        remainingMonths: e.remainingMonths,
        drawCents: e.drawCents ?? 0,
      ),
  ];

  /// What each instalment of the loans planned in [scheduled] takes from
  /// the account (instalment + insurance, negative), by planned operation
  /// and due date, when it differs from the planned amount: the first one
  /// with its intercalary interest, the last one, those after a change of
  /// rate. The forecast, reconciliation and calendar use it.
  static Future<Map<int, Map<core.LocalDate, int>>> debits(
    Session session,
    Iterable<ScheduledTransaction> scheduled, {
    Transaction? transaction,
  }) async {
    final amounts = {for (final s in scheduled) s.id!: s.amountCents};
    if (amounts.isEmpty) return const {};
    final Set<int> ids = amounts.keys.toSet();
    final loans = await Loan.db.find(
      session,
      where: (l) => l.scheduledId.inSet(ids) & l.deletedAt.equals(null),
      transaction: transaction,
    );
    final result = <int, Map<core.LocalDate, int>>{};
    for (final l in loans) {
      final planned = amounts[l.scheduledId]!;
      final List<core.Installment> schedule;
      try {
        schedule = core.amortize(terms(l), changes: changes(l));
      } on ArgumentError {
        continue;
      }
      final byDue = <core.LocalDate, int>{
        for (final i in schedule)
          if (-(i.paymentCents + i.insuranceCents) != planned)
            i.date: -(i.paymentCents + i.insuranceCents),
      };
      if (byDue.isNotEmpty) result[l.scheduledId!] = byDue;
    }
    return result;
  }
}
