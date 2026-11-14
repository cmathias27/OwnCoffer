/// Savings projects and expenses spread over the year (decision 0050):
/// what to put aside each month, computed by the engine, never by the AI.
library;

import '../forecast/recurrence.dart';
import '../local_date.dart';

/// Months from the month of [from] to the month of [to] (0 = same month).
int monthsBetween(LocalDate from, LocalDate to) =>
    (to.year * 12 + to.month) - (from.year * 12 + from.month);

/// Where a savings project stands.
class ProjectPlan {
  /// Still to save, never negative.
  final int remainingCents;

  /// Monthly instalments left until the target month, this one included;
  /// null without a target date.
  final int? monthsLeft;

  /// To put aside each month to reach the target on time (rounded up);
  /// null without a target date or once reached.
  final int? monthlyCents;

  /// Saved over target, in thousandths, at most 1000.
  final int progressPerMille;
  final bool reached;

  /// The target date is over and the target not reached.
  final bool overdue;

  const ProjectPlan({
    required this.remainingCents,
    required this.monthsLeft,
    required this.monthlyCents,
    required this.progressPerMille,
    required this.reached,
    required this.overdue,
  });
}

ProjectPlan projectPlan({
  required int targetCents,
  required int savedCents,
  required LocalDate today,
  LocalDate? targetDate,
}) {
  final remaining = targetCents - savedCents > 0 ? targetCents - savedCents : 0;
  final reached = targetCents > 0 && remaining == 0;
  final progress = targetCents <= 0
      ? 0
      : (savedCents <= 0
            ? 0
            : (savedCents * 1000 ~/ targetCents).clamp(0, 1000));
  if (targetDate == null) {
    return ProjectPlan(
      remainingCents: remaining,
      monthsLeft: null,
      monthlyCents: null,
      progressPerMille: progress,
      reached: reached,
      overdue: false,
    );
  }
  final overdue = !reached && targetDate < today;
  final months = monthsBetween(today, targetDate);
  // This month counts: a target next month leaves two instalments.
  final left = overdue ? 0 : (months < 0 ? 0 : months) + 1;
  return ProjectPlan(
    remainingCents: remaining,
    monthsLeft: left,
    monthlyCents: reached || overdue ? null : (remaining + left - 1) ~/ left,
    progressPerMille: progress,
    reached: reached,
    overdue: overdue,
  );
}

/// A planned expense that does not come every month (insurance, property
/// tax…), spread into a monthly provision.
class SmoothedExpense {
  /// Months between two occurrences (12 for a yearly one).
  final int periodMonths;

  /// To put aside each month (rounded up).
  final int monthlyCents;

  /// What should be put aside already for the next occurrence, at a
  /// constant monthly pace since the last one.
  final int setAsideCents;

  /// Months before the next occurrence (0 = this month).
  final int monthsUntil;

  const SmoothedExpense({
    required this.periodMonths,
    required this.monthlyCents,
    required this.setAsideCents,
    required this.monthsUntil,
  });
}

/// Months between two occurrences of a recurrence when it is less often
/// than monthly; null otherwise (weekly, monthly, once).
int? smoothingPeriod(Frequency frequency, int interval) {
  final n = interval < 1 ? 1 : interval;
  return switch (frequency) {
    Frequency.yearly => 12 * n,
    Frequency.monthly when n >= 2 => n,
    _ => null,
  };
}

/// [amountCents] is the size of one occurrence (positive); null when the
/// expense needs no smoothing.
SmoothedExpense? smoothExpense({
  required int amountCents,
  required Frequency frequency,
  required int interval,
  required LocalDate nextDue,
  required LocalDate today,
}) {
  final period = smoothingPeriod(frequency, interval);
  if (period == null || amountCents <= 0) return null;
  final until = monthsBetween(today, nextDue).clamp(0, period);
  final elapsed = period - until;
  return SmoothedExpense(
    periodMonths: period,
    monthlyCents: (amountCents + period - 1) ~/ period,
    setAsideCents: amountCents * elapsed ~/ period,
    monthsUntil: until,
  );
}

/// The renewal of a contract renewed every year, and the last day to
/// cancel it.
class ContractDates {
  /// The next renewal on or after today.
  final LocalDate renewal;

  /// Last day to send the cancellation ([renewal] minus the notice).
  final LocalDate deadline;

  /// Days from today to [deadline]; negative once it is too late for
  /// [renewal].
  final int daysToDeadline;

  const ContractDates(this.renewal, this.deadline, this.daysToDeadline);
}

ContractDates contractDates({
  required LocalDate renewal,
  required int noticeDays,
  required LocalDate today,
}) {
  var next = renewal;
  var years = 0;
  while (next < today) {
    years++;
    next = renewal.addMonths(12 * years);
  }
  final deadline = next.addDays(-(noticeDays < 0 ? 0 : noticeDays));
  return ContractDates(next, deadline, deadline.epochDay - today.epochDay);
}

/// The credit that settles an expected refund: the same amount, received on
/// or after [since], the earliest first. Returns its index in [credits].
int? matchRefund({
  required int amountCents,
  required LocalDate since,
  required List<(LocalDate date, int amountCents)> credits,
}) {
  int? best;
  for (var i = 0; i < credits.length; i++) {
    final (date, cents) = credits[i];
    if (cents != amountCents || date < since) continue;
    if (best == null || date < credits[best].$1) best = i;
  }
  return best;
}
