import 'dart:math' as math;

import '../local_date.dart';

/// Limits that keep every product below 2^53 (the app also runs these
/// computations on the web, where integers are doubles).
const int maxLoanPrincipalCents = 10000000000; // 100 million
const int maxLoanRateMilli = 50000; // 50 %
const int maxLoanMonths = 600; // 50 years

/// A fixed-rate loan with constant monthly instalments.
class LoanTerms {
  final int principalCents;

  /// Nominal annual rate in thousandths of a percent: 3.45 % = 3450.
  final int annualRateMilli;
  final int months;
  final LocalDate firstDue;

  /// Borrower insurance per instalment, fixed.
  final int insuranceMonthlyCents;

  /// The instalment actually debited (capital + interest, insurance
  /// excluded), when known: the only figure that is certain. The schedule
  /// then follows it until the capital is repaid, and the number of
  /// instalments is an estimate; without it the instalment is computed from
  /// the principal, the rate and [months].
  final int? paymentCents;

  LoanTerms({
    required this.principalCents,
    required this.annualRateMilli,
    required this.months,
    required this.firstDue,
    this.insuranceMonthlyCents = 0,
    this.paymentCents,
  }) {
    if (principalCents <= 0 || principalCents > maxLoanPrincipalCents) {
      throw ArgumentError.value(principalCents, 'principalCents');
    }
    if (annualRateMilli < 0 || annualRateMilli > maxLoanRateMilli) {
      throw ArgumentError.value(annualRateMilli, 'annualRateMilli');
    }
    if (months < 1 || months > maxLoanMonths) {
      throw ArgumentError.value(months, 'months');
    }
    if (insuranceMonthlyCents < 0 ||
        insuranceMonthlyCents > maxLoanPrincipalCents) {
      throw ArgumentError.value(insuranceMonthlyCents, 'insuranceMonthlyCents');
    }
    final p = paymentCents;
    // The instalment must at least cover the first month's interest, or the
    // loan would never be repaid.
    if (p != null &&
        (p <= 0 ||
            p > maxLoanPrincipalCents ||
            p <= _monthInterest(principalCents, annualRateMilli))) {
      throw ArgumentError.value(p, 'paymentCents');
    }
  }

  /// The instalment: the actual one, or the one computed.
  int get payment =>
      paymentCents ?? loanPaymentCents(principalCents, annualRateMilli, months);

  /// Last instalment number allowed: the contract's duration, or (with the
  /// actual instalment) as long as it takes, within the supported limit.
  int get _lastNumber => paymentCents == null ? months : maxLoanMonths;
}

/// Something that changes a loan from a date on, applied before the first
/// instalment due on or after [date] (cahier des charges, Crédits):
/// - a new rate (variable rate, renegotiation): [annualRateMilli];
/// - a new instalment (renegotiation, revolving credit): [paymentCents];
/// - a new remaining duration (renegotiation): [remainingMonths];
/// - money drawn ([drawCents] > 0, revolving credit) or repaid early
///   ([drawCents] < 0).
/// Without a new instalment or duration, a loan computed from its duration
/// keeps its end date (the instalment is computed again), and a loan that
/// follows its actual instalment keeps it (the end date moves).
class LoanChange {
  final LocalDate date;
  final int? annualRateMilli;
  final int? paymentCents;
  final int? remainingMonths;
  final int drawCents;

  LoanChange({
    required this.date,
    this.annualRateMilli,
    this.paymentCents,
    this.remainingMonths,
    this.drawCents = 0,
  }) {
    final r = annualRateMilli;
    if (r != null && (r < 0 || r > maxLoanRateMilli)) {
      throw ArgumentError.value(r, 'annualRateMilli');
    }
    final p = paymentCents;
    if (p != null && (p <= 0 || p > maxLoanPrincipalCents)) {
      throw ArgumentError.value(p, 'paymentCents');
    }
    final m = remainingMonths;
    if (m != null && (m < 1 || m > maxLoanMonths)) {
      throw ArgumentError.value(m, 'remainingMonths');
    }
    if (drawCents.abs() > maxLoanPrincipalCents) {
      throw ArgumentError.value(drawCents, 'drawCents');
    }
    if (r == null && p == null && m == null && drawCents == 0) {
      throw ArgumentError('A change must change something');
    }
  }
}

class Installment {
  /// 1-based.
  final int number;
  final LocalDate date;

  /// Capital + interest (without insurance).
  final int paymentCents;
  final int principalCents;
  final int interestCents;
  final int insuranceCents;

  /// Capital still owed after this instalment.
  final int remainingCents;

  const Installment({
    required this.number,
    required this.date,
    required this.paymentCents,
    required this.principalCents,
    required this.interestCents,
    required this.insuranceCents,
    required this.remainingCents,
  });

  /// What leaves the account.
  int get totalCents => paymentCents + insuranceCents;
}

/// Constant instalment M = C × t / (1 − (1 + t)^−n), t = annual rate / 12,
/// rounded to the cent. The power needs floating point; the schedule itself
/// is then computed in integer cents, and the last instalment settles the
/// rounding. Indicative: the bank's own table prevails.
int loanPaymentCents(int principalCents, int annualRateMilli, int months) {
  if (annualRateMilli == 0) return (principalCents + months - 1) ~/ months;
  final t = annualRateMilli / 1200000;
  return (principalCents * t / (1 - math.pow(1 + t, -months))).round();
}

/// Inverse of [loanPaymentCents]: the principal whose instalment is
/// [paymentCents] (rounded down to the cent, then nudged so that
/// `loanPaymentCents` gives back [paymentCents] when some principal does).
/// Used when a loan is declared from an observed debit and the borrowed (or
/// remaining) capital is unknown. Null when out of the supported limits.
int? loanPrincipalForPaymentCents(
  int paymentCents,
  int annualRateMilli,
  int months,
) {
  if (paymentCents <= 0 || months < 1 || months > maxLoanMonths) return null;
  if (annualRateMilli < 0 || annualRateMilli > maxLoanRateMilli) return null;
  final int estimate;
  if (annualRateMilli == 0) {
    estimate = paymentCents * months;
  } else {
    final t = annualRateMilli / 1200000;
    estimate = (paymentCents * (1 - math.pow(1 + t, -months)) / t).floor();
  }
  if (estimate <= 0 || estimate > maxLoanPrincipalCents) return null;
  // Largest principal within a few cents whose instalment is still the one
  // observed.
  var best = estimate;
  for (var p = estimate + months; p >= math.max(1, estimate - months); p--) {
    if (p <= maxLoanPrincipalCents &&
        loanPaymentCents(p, annualRateMilli, months) == paymentCents) {
      best = p;
      break;
    }
  }
  return best;
}

/// Interest of one month on [remainingCents], rounded half up.
int _monthInterest(int remainingCents, int annualRateMilli) =>
    (remainingCents * annualRateMilli + 600000) ~/ 1200000;

List<Installment> amortize(
  LoanTerms t, {
  List<LoanChange> changes = const [],
}) {
  var payment = t.payment;
  var last = t._lastNumber;
  var rate = t.annualRateMilli;
  // Whether the instalment is the given one (the end date follows it).
  var paymentDriven = t.paymentCents != null;
  final pending = [...changes]..sort((a, b) => a.date.compareTo(b.date));
  final result = <Installment>[];
  var remaining = t.principalCents;
  for (var k = 1; k <= last && (remaining > 0 || pending.isNotEmpty); k++) {
    final date = t.firstDue.addMonths(k - 1);
    while (pending.isNotEmpty && pending.first.date <= date) {
      final c = pending.removeAt(0);
      remaining = math.max(0, remaining + c.drawCents);
      rate = c.annualRateMilli ?? rate;
      if (c.paymentCents != null) {
        payment = c.paymentCents!;
        paymentDriven = true;
        last = maxLoanMonths;
      } else if (c.remainingMonths != null) {
        payment = loanPaymentCents(
          math.max(remaining, 1),
          rate,
          c.remainingMonths!,
        );
        paymentDriven = false;
        last = math.min(k - 1 + c.remainingMonths!, maxLoanMonths);
      } else if (!paymentDriven) {
        payment = loanPaymentCents(math.max(remaining, 1), rate, last - k + 1);
      }
    }
    if (remaining <= 0) {
      if (pending.isEmpty) break;
      continue;
    }
    final interest = _monthInterest(remaining, rate);
    var capital = payment - interest;
    if (k == last || capital > remaining) capital = remaining;
    // An instalment below the interest would never repay: the loan is then
    // shown as paid off by its last allowed instalment.
    if (capital < 0) capital = 0;
    remaining -= capital;
    result.add(
      Installment(
        number: k,
        date: date,
        paymentCents: capital + interest,
        principalCents: capital,
        interestCents: interest,
        insuranceCents: t.insuranceMonthlyCents,
        remainingCents: remaining,
      ),
    );
  }
  return result;
}

/// Where a loan stands on a given day: instalments due on or before it are
/// counted as paid.
class LoanStatus {
  final int paidCount;
  final int totalCount;
  final int remainingCents;
  final int principalPaidCents;
  final int interestPaidCents;
  final int interestRemainingCents;
  final int insurancePaidCents;
  final int insuranceRemainingCents;
  final Installment? next;
  final LocalDate endDate;

  const LoanStatus({
    required this.paidCount,
    required this.totalCount,
    required this.remainingCents,
    required this.principalPaidCents,
    required this.interestPaidCents,
    required this.interestRemainingCents,
    required this.insurancePaidCents,
    required this.insuranceRemainingCents,
    required this.next,
    required this.endDate,
  });

  bool get finished => next == null;

  /// Total interest and insurance over the whole loan.
  int get costCents =>
      interestPaidCents +
      interestRemainingCents +
      insurancePaidCents +
      insuranceRemainingCents;

  /// Share of the capital repaid, in per mille (integer).
  int repaidPerMille(int principalCents) =>
      principalCents <= 0 ? 0 : principalPaidCents * 1000 ~/ principalCents;
}

LoanStatus loanStatus(
  LoanTerms terms,
  List<Installment> schedule,
  LocalDate today,
) {
  var paid = 0, principal = 0, interestPaid = 0, interestLeft = 0;
  var insPaid = 0, insLeft = 0;
  Installment? next;
  for (final i in schedule) {
    if (i.date <= today) {
      paid++;
      principal += i.principalCents;
      interestPaid += i.interestCents;
      insPaid += i.insuranceCents;
    } else {
      next ??= i;
      interestLeft += i.interestCents;
      insLeft += i.insuranceCents;
    }
  }
  return LoanStatus(
    paidCount: paid,
    totalCount: schedule.length,
    // What the unpaid instalments still repay: the same as the principal
    // minus what is paid, plus any money drawn since.
    remainingCents: schedule.fold(
      0,
      (a, i) => i.date <= today ? a : a + i.principalCents,
    ),
    principalPaidCents: principal,
    interestPaidCents: interestPaid,
    interestRemainingCents: interestLeft,
    insurancePaidCents: insPaid,
    insuranceRemainingCents: insLeft,
    next: next,
    endDate: schedule.isEmpty ? terms.firstDue : schedule.last.date,
  );
}

/// Early repayment of [amountCents] right after the last instalment paid on
/// [today], keeping the monthly payment (the loan ends earlier). Returns the
/// new remaining schedule and the interest saved.
({List<Installment> schedule, int interestSavedCents}) simulateEarlyRepayment(
  LoanTerms terms,
  LocalDate today,
  int amountCents, {
  List<LoanChange> changes = const [],
}) {
  if (changes.isNotEmpty) {
    return _earlyRepaymentWithChanges(terms, today, amountCents, changes);
  }
  final schedule = amortize(terms);
  final status = loanStatus(terms, schedule, today);
  final left = status.remainingCents - amountCents;
  if (amountCents <= 0 || status.finished) {
    return (schedule: const [], interestSavedCents: 0);
  }
  if (left <= 0) {
    return (
      schedule: const [],
      interestSavedCents: status.interestRemainingCents,
    );
  }
  final payment = terms.payment;
  final last = terms._lastNumber;
  final result = <Installment>[];
  var remaining = left;
  var k = status.paidCount;
  var interestTotal = 0;
  while (remaining > 0 && k < last) {
    k++;
    final interest = _monthInterest(remaining, terms.annualRateMilli);
    var capital = payment - interest;
    if (capital > remaining || k == last) capital = remaining;
    remaining -= capital;
    interestTotal += interest;
    result.add(
      Installment(
        number: k,
        date: terms.firstDue.addMonths(k - 1),
        paymentCents: capital + interest,
        principalCents: capital,
        interestCents: interest,
        insuranceCents: terms.insuranceMonthlyCents,
        remainingCents: remaining,
      ),
    );
  }
  return (
    schedule: result,
    interestSavedCents: status.interestRemainingCents - interestTotal,
  );
}

/// The same, on a loan with changes: the repayment is one more change, at
/// the next instalment, keeping the instalment it would have had.
({List<Installment> schedule, int interestSavedCents})
_earlyRepaymentWithChanges(
  LoanTerms terms,
  LocalDate today,
  int amountCents,
  List<LoanChange> changes,
) {
  final schedule = amortize(terms, changes: changes);
  final status = loanStatus(terms, schedule, today);
  final next = status.next;
  if (amountCents <= 0 || next == null) {
    return (schedule: const [], interestSavedCents: 0);
  }
  if (amountCents >= status.remainingCents) {
    return (
      schedule: const [],
      interestSavedCents: status.interestRemainingCents,
    );
  }
  final after = amortize(
    terms,
    changes: [
      ...changes,
      LoanChange(
        date: next.date,
        drawCents: -amountCents,
        paymentCents: next.paymentCents,
      ),
    ],
  );
  final left = [
    for (final i in after)
      if (i.date > today) i,
  ];
  final interest = left.fold(0, (a, i) => a + i.interestCents);
  return (
    schedule: left,
    interestSavedCents: status.interestRemainingCents - interest,
  );
}
