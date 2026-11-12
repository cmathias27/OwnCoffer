import '../local_date.dart';
import 'amortization.dart';

/// A real debit of the loan's account that belongs to the loan: linked to
/// one of its planned instalments ([dueDate]) or classified by its rule.
/// [amountCents] is positive.
typedef LoanDebit = ({
  int id,
  LocalDate date,
  int amountCents,
  LocalDate? dueDate,
});

enum LoanCheckStatus {
  /// One debit, of the expected amount.
  paid,

  /// Due inside the imported history, no debit found.
  missing,

  /// Two debits or more for the same instalment.
  duplicate,

  /// One debit, of another amount.
  differentAmount,

  /// A debit far from every instalment.
  unexpected,
}

class LoanCheckRow {
  final LoanCheckStatus status;

  /// The instalment, null for [LoanCheckStatus.unexpected].
  final Installment? instalment;
  final List<LoanDebit> debits;

  /// Debited minus expected, for [LoanCheckStatus.differentAmount].
  final int gapCents;

  const LoanCheckRow({
    required this.status,
    required this.instalment,
    required this.debits,
    this.gapCents = 0,
  });
}

class LoanCheck {
  /// Instalments compared with the debits, in date order; debits far from
  /// every instalment at the end.
  final List<LoanCheckRow> rows;

  const LoanCheck(this.rows);

  int count(LoanCheckStatus s) => rows.where((r) => r.status == s).length;

  /// The rows that need a look (everything but [LoanCheckStatus.paid]).
  List<LoanCheckRow> get problems =>
      rows.where((r) => r.status != LoanCheckStatus.paid).toList();
}

/// Days around an instalment within which a debit is counted for it: half a
/// month, so that each debit has one instalment at most.
const loanCheckWindowDays = 15;

/// Compares the instalments of [schedule] with the real [debits]
/// (decision 0040). Only instalments of the imported history are checked:
/// due on or after [historyFrom], and at least [toleranceDays] before
/// [historyTo] (the bank may debit a few days late). An instalment matched
/// with a debit is always shown, even outside these dates.
///
/// A debit goes to the instalment it was linked to, otherwise to the
/// nearest one within [loanCheckWindowDays] (the earlier on a tie). The
/// amount is right when it is within [amountToleranceCents] of the
/// instalment with insurance, or without (insurance debited apart).
LoanCheck checkLoan(
  List<Installment> schedule,
  List<LoanDebit> debits, {
  required LocalDate historyFrom,
  required LocalDate historyTo,
  int toleranceDays = 5,
  int amountToleranceCents = 100,
}) {
  final byDate = {for (final (i, s) in schedule.indexed) s.date: i};
  final found = [for (final _ in schedule) <LoanDebit>[]];
  final unexpected = <LoanDebit>[];
  final ordered = [...debits]
    ..sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
  for (final d in ordered) {
    var best = d.dueDate == null ? null : byDate[d.dueDate];
    if (best == null) {
      var gap = loanCheckWindowDays + 1;
      for (final (i, s) in schedule.indexed) {
        final g = s.date.daysUntil(d.date).abs();
        if (g < gap) (best, gap) = (i, g);
      }
    }
    if (best == null) {
      unexpected.add(d);
    } else {
      found[best].add(d);
    }
  }

  int gapOf(Installment s, int amount) {
    final withInsurance = amount - s.totalCents;
    final without = amount - s.paymentCents;
    return s.insuranceCents != 0 && without.abs() < withInsurance.abs()
        ? without
        : withInsurance;
  }

  final rows = <LoanCheckRow>[];
  for (final (i, s) in schedule.indexed) {
    final ds = found[i];
    if (ds.isEmpty) {
      if (s.date >= historyFrom && s.date.addDays(toleranceDays) <= historyTo) {
        rows.add(
          LoanCheckRow(
            status: LoanCheckStatus.missing,
            instalment: s,
            debits: const [],
          ),
        );
      }
    } else if (ds.length > 1) {
      rows.add(
        LoanCheckRow(
          status: LoanCheckStatus.duplicate,
          instalment: s,
          debits: ds,
        ),
      );
    } else {
      final gap = gapOf(s, ds.single.amountCents);
      rows.add(
        LoanCheckRow(
          status: gap.abs() > amountToleranceCents
              ? LoanCheckStatus.differentAmount
              : LoanCheckStatus.paid,
          instalment: s,
          debits: ds,
          gapCents: gap.abs() > amountToleranceCents ? gap : 0,
        ),
      );
    }
  }
  for (final d in unexpected) {
    rows.add(
      LoanCheckRow(
        status: LoanCheckStatus.unexpected,
        instalment: null,
        debits: [d],
      ),
    );
  }
  return LoanCheck(rows);
}
