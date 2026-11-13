import 'dart:math' as math;

import '../local_date.dart';

/// Limits that keep every product below 2^53 (the app also runs these
/// computations on the web, where integers are doubles).
const int maxLoanPrincipalCents = 10000000000; // 100 million
const int maxLoanRateMilli = 50000; // 50 %
const int maxLoanMonths = 600; // 50 years

/// Longest pause of instalments one change may ask for (a student loan
/// may be deferred for years).
const int maxLoanPauseMonths = 120;

/// Largest amount owed once interest is added to it during a pause: past
/// it, only the interest is paid (every product stays below 2^53).
const int _maxOwedCents = 5 * maxLoanPrincipalCents;

/// A fixed-rate loan with constant monthly instalments.
class LoanTerms {
  final int principalCents;

  /// Nominal annual rate in thousandths of a percent: 3.45 % = 3450.
  final int annualRateMilli;
  final int months;
  final LocalDate firstDue;

  /// Borrower insurance per instalment, fixed.
  final int insuranceMonthlyCents;

  /// Optional date when the loan was disbursed (funds released), before
  /// [firstDue]. When it is not exactly a month before [firstDue], the
  /// first instalment's interest is computed on the days elapsed (actual
  /// days / 365): a longer period adds intercalary interest, a shorter one
  /// takes some off. The instalment's capital stays the regular one.
  final LocalDate? disbursementDate;

  /// Optional interest of the first instalment in cents, as written in the
  /// lender's contract (intercalary or broken period); it prevails over
  /// [disbursementDate].
  final int? firstInterestCents;

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
    this.disbursementDate,
    this.firstInterestCents,
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
    final d = disbursementDate;
    // Funds released before the first instalment, within a year.
    if (d != null && (d >= firstDue || d.daysUntil(firstDue) > 366)) {
      throw ArgumentError.value(d, 'disbursementDate');
    }
    final f = firstInterestCents;
    if (f != null && (f < 0 || f > maxLoanPrincipalCents)) {
      throw ArgumentError.value(f, 'firstInterestCents');
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

  /// Interest of the first instalment on [remainingCents] at [rate]: the
  /// contract's figure (in proportion, if the capital owed then is not the
  /// principal: money repaid or drawn before it), the days since the
  /// disbursement, or a regular month.
  int _firstInterest(int remainingCents, int rate) {
    final f = firstInterestCents;
    if (f != null) {
      return remainingCents == principalCents
          ? f
          : (f * (remainingCents / principalCents)).round();
    }
    final d = disbursementDate;
    if (d != null && d != firstDue.addMonths(-1)) {
      // remainingCents × rate < 2^53; the days in floating point, as the
      // web computes it.
      return (remainingCents * rate * d.daysUntil(firstDue) / 36500000).round();
    }
    return _monthInterest(remainingCents, rate);
  }
}

/// Something that changes a loan from a date on, applied before the first
/// instalment due on or after [date] (cahier des charges, Crédits):
/// - a new rate (variable rate, renegotiation): [annualRateMilli];
/// - a new instalment (renegotiation, revolving credit): [paymentCents];
/// - a new remaining duration (renegotiation): [remainingMonths];
/// - money drawn ([drawCents] > 0, revolving credit) or repaid early
///   ([drawCents] < 0);
/// - a pause of [pauseMonths] instalments (report d'échéances): only the
///   interest is paid (partial pause), or nothing and the interest is
///   added to what is owed ([pauseCapitalized], total pause). The loan
///   lasts as many months longer; insurance stays due.
/// Without a new instalment or duration, a loan computed from its duration
/// keeps its end date (the instalment is computed again), and a loan that
/// follows its actual instalment keeps it (the end date moves).
class LoanChange {
  final LocalDate date;
  final int? annualRateMilli;
  final int? paymentCents;
  final int? remainingMonths;
  final int drawCents;
  final int? pauseMonths;
  final bool pauseCapitalized;

  LoanChange({
    required this.date,
    this.annualRateMilli,
    this.paymentCents,
    this.remainingMonths,
    this.drawCents = 0,
    this.pauseMonths,
    this.pauseCapitalized = false,
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
    final pause = pauseMonths;
    if (pause != null && (pause < 1 || pause > maxLoanPauseMonths)) {
      throw ArgumentError.value(pause, 'pauseMonths');
    }
    if (r == null &&
        p == null &&
        m == null &&
        drawCents == 0 &&
        pause == null) {
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

  /// Interest beyond a regular month (first instalment after an
  /// intercalary period; negative for a shorter one): the regular
  /// instalment is [paymentCents] minus it.
  final int extraInterestCents;

  /// Paused instalment (report d'échéances): no capital repaid; with a total
  /// pause nothing is paid and [principalCents] is negative, the interest
  /// being added to what is owed.
  final bool paused;

  const Installment({
    required this.number,
    required this.date,
    required this.paymentCents,
    required this.principalCents,
    required this.interestCents,
    required this.insuranceCents,
    required this.remainingCents,
    this.extraInterestCents = 0,
    this.paused = false,
  });

  /// The instalment without the intercalary interest.
  int get regularPaymentCents => paymentCents - extraInterestCents;

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

/// The number of monthly instalments needed to repay [principalCents] at
/// [annualRateMilli] with [paymentCents] per instalment (capital + interest).
/// Null when the payment does not cover the first month's interest, or exceeds
/// [maxLoanMonths].
int? loanMonthsForPaymentCents(
  int principalCents,
  int annualRateMilli,
  int paymentCents,
) {
  if (principalCents <= 0 || principalCents > maxLoanPrincipalCents) {
    return null;
  }
  if (annualRateMilli < 0 || annualRateMilli > maxLoanRateMilli) {
    return null;
  }
  if (paymentCents <= 0) {
    return null;
  }
  if (annualRateMilli == 0) {
    final m = (principalCents + paymentCents - 1) ~/ paymentCents;
    return (m >= 1 && m <= maxLoanMonths) ? m : null;
  }
  final firstMonthInterest = _monthInterest(principalCents, annualRateMilli);
  if (paymentCents <= firstMonthInterest) {
    return null;
  }
  final t = annualRateMilli / 1200000;
  final ratio = principalCents * t / paymentCents;
  if (ratio >= 1.0) {
    return null;
  }
  final est = (-math.log(1 - ratio) / math.log(1 + t)).round();
  if (est <= 0 || est > maxLoanMonths) {
    return null;
  }
  try {
    final schedule = amortize(
      LoanTerms(
        principalCents: principalCents,
        annualRateMilli: annualRateMilli,
        months: est.clamp(1, maxLoanMonths),
        firstDue: LocalDate(2000, 1, 1),
        paymentCents: paymentCents,
      ),
    );
    if (schedule.isEmpty || schedule.length > maxLoanMonths) {
      return null;
    }
    return schedule.length;
  } on ArgumentError {
    return null;
  }
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
  // Paused instalments still to come, and whether their interest is added
  // to what is owed.
  var pauseLeft = 0;
  var capitalize = false;
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
      final pause = c.pauseMonths;
      if (pause != null) {
        // A pause pushes the end back by its length; a new one replaces
        // what is left of an earlier one.
        last = math.min(last + pause - pauseLeft, maxLoanMonths);
        pauseLeft = pause;
        capitalize = c.pauseCapitalized;
      }
    }
    if (remaining <= 0) {
      if (pending.isEmpty) break;
      continue;
    }
    if (pauseLeft > 0) {
      final i = _paused(t, k, date, remaining, rate, capitalize);
      remaining = i.remainingCents;
      result.add(i);
      pauseLeft--;
      // After the pause, a loan computed from its duration spreads what is
      // owed over the instalments left; one that follows its actual
      // instalment keeps it.
      if (pauseLeft == 0 && !paymentDriven && last > k) {
        payment = loanPaymentCents(math.max(remaining, 1), rate, last - k);
      }
      continue;
    }
    final i = _instalment(t, k, date, remaining, rate, payment, last);
    remaining = i.remainingCents;
    result.add(i);
  }
  return result;
}

/// Paused instalment [k] on [remaining] owed: the interest only, or
/// nothing paid and the interest added to what is owed ([capitalize]).
Installment _paused(
  LoanTerms t,
  int k,
  LocalDate date,
  int remaining,
  int rate,
  bool capitalize,
) {
  final month = _monthInterest(remaining, rate);
  final interest = k == 1 ? t._firstInterest(remaining, rate) : month;
  final added = capitalize && remaining + interest <= _maxOwedCents
      ? interest
      : 0;
  return Installment(
    number: k,
    date: date,
    paymentCents: interest - added,
    principalCents: -added,
    interestCents: interest,
    insuranceCents: t.insuranceMonthlyCents,
    remainingCents: remaining + added,
    extraInterestCents: interest - month,
    paused: true,
  );
}

/// Instalment [k] on [remaining] owed: the interest of the month (of the
/// intercalary period for the first one), the capital the rest of the
/// regular instalment [payment]; the last one, or a larger capital,
/// settles what is owed.
Installment _instalment(
  LoanTerms t,
  int k,
  LocalDate date,
  int remaining,
  int rate,
  int payment,
  int last,
) {
  final month = _monthInterest(remaining, rate);
  final interest = k == 1 ? t._firstInterest(remaining, rate) : month;
  var capital = payment - month;
  if (k == last || capital > remaining) capital = remaining;
  // An instalment below the interest would never repay: the loan is then
  // shown as paid off by its last allowed instalment.
  if (capital < 0) capital = 0;
  return Installment(
    number: k,
    date: date,
    paymentCents: capital + interest,
    principalCents: capital,
    interestCents: interest,
    insuranceCents: t.insuranceMonthlyCents,
    remainingCents: remaining - capital,
    extraInterestCents: interest - month,
  );
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
    final i = _instalment(
      terms,
      k,
      terms.firstDue.addMonths(k - 1),
      remaining,
      terms.annualRateMilli,
      payment,
      last,
    );
    remaining = i.remainingCents;
    interestTotal += i.interestCents;
    result.add(i);
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
        // The regular instalment: not the intercalary interest of a first
        // one.
        paymentCents: next.regularPaymentCents,
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

/// A loan with and without a change (renegotiation, new rate): what is
/// left to pay from [today] either way, the fees of the change, and when
/// it pays off.
class LoanChangeComparison {
  /// The instalment from the change on, before and after it.
  final int paymentBeforeCents;
  final int paymentAfterCents;

  /// Interest still to pay after [today], before and after.
  final int interestBeforeCents;
  final int interestAfterCents;

  /// Instalments still to pay after [today], and the end dates.
  final int instalmentsBefore;
  final int instalmentsAfter;
  final LocalDate endBefore;
  final LocalDate endAfter;
  final int feesCents;

  /// Months after the change by the end of which the change has cost no
  /// more than not changing (instalments and fees); null if never.
  final int? breakEvenMonth;

  const LoanChangeComparison({
    required this.paymentBeforeCents,
    required this.paymentAfterCents,
    required this.interestBeforeCents,
    required this.interestAfterCents,
    required this.instalmentsBefore,
    required this.instalmentsAfter,
    required this.endBefore,
    required this.endAfter,
    required this.feesCents,
    required this.breakEvenMonth,
  });

  /// Interest saved, fees taken off (negative: the change costs more).
  int get savingCents => interestBeforeCents - interestAfterCents - feesCents;
}

LoanChangeComparison compareLoanChange(
  LoanTerms terms, {
  List<LoanChange> changes = const [],
  required LocalDate today,
  required LoanChange proposed,
  int feesCents = 0,
}) {
  if (feesCents < 0 || feesCents > maxLoanPrincipalCents) {
    throw ArgumentError.value(feesCents, 'feesCents');
  }
  final before = [
    for (final i in amortize(terms, changes: changes))
      if (i.date > today) i,
  ];
  final after = [
    for (final i in amortize(terms, changes: [...changes, proposed]))
      if (i.date > today) i,
  ];
  int interest(List<Installment> s) => s.fold(0, (a, i) => a + i.interestCents);
  int paymentFrom(List<Installment> s) =>
      s.where((i) => i.date >= proposed.date).firstOrNull?.paymentCents ??
      (s.isEmpty ? 0 : s.first.paymentCents);
  // Month by month from the change: what has left the account either way.
  final b = [
    for (final i in before)
      if (i.date >= proposed.date) i.totalCents,
  ];
  final a = [
    for (final i in after)
      if (i.date >= proposed.date) i.totalCents,
  ];
  int? even;
  var sumB = 0, sumA = feesCents;
  for (var k = 0; k < (b.length > a.length ? b.length : a.length); k++) {
    sumB += k < b.length ? b[k] : 0;
    sumA += k < a.length ? a[k] : 0;
    if (sumA <= sumB) {
      even = k + 1;
      break;
    }
  }
  return LoanChangeComparison(
    paymentBeforeCents: paymentFrom(before),
    paymentAfterCents: paymentFrom(after),
    interestBeforeCents: interest(before),
    interestAfterCents: interest(after),
    instalmentsBefore: before.length,
    instalmentsAfter: after.length,
    endBefore: before.isEmpty ? today : before.last.date,
    endAfter: after.isEmpty ? today : after.last.date,
    feesCents: feesCents,
    breakEvenMonth: even,
  );
}
