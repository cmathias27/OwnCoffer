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

List<Installment> amortize(LoanTerms t) {
  final payment = t.payment;
  final last = t._lastNumber;
  final result = <Installment>[];
  var remaining = t.principalCents;
  for (var k = 1; k <= last && remaining > 0; k++) {
    final interest = _monthInterest(remaining, t.annualRateMilli);
    var capital = payment - interest;
    if (k == last || capital > remaining) capital = remaining;
    remaining -= capital;
    result.add(
      Installment(
        number: k,
        date: t.firstDue.addMonths(k - 1),
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
    remainingCents: terms.principalCents - principal,
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
  int amountCents,
) {
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
