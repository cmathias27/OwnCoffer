import '../local_date.dart';

/// A deferred debit card billing cycle.
class DeferredCardCycle {
  /// Start of the active cycle (inclusive).
  final LocalDate start;

  /// End of the active cycle / cutoff date (inclusive).
  final LocalDate end;

  /// Date when the active cycle will be debited on the checking account.
  final LocalDate debitDate;

  /// Start of the previous cycle if between cutoff and debit (inclusive).
  final LocalDate? pendingDebitStart;

  /// End of the previous cycle if between cutoff and debit (inclusive).
  final LocalDate? pendingDebitEnd;

  /// Date when the previous cycle will be debited on the checking account.
  final LocalDate? pendingDebitDate;

  const DeferredCardCycle({
    required this.start,
    required this.end,
    required this.debitDate,
    this.pendingDebitStart,
    this.pendingDebitEnd,
    this.pendingDebitDate,
  });

  bool get hasPendingDebit => pendingDebitDate != null;

  bool contains(LocalDate d) => d >= start && d <= end;

  bool containsPending(LocalDate d) =>
      pendingDebitStart != null &&
      pendingDebitEnd != null &&
      d >= pendingDebitStart! &&
      d <= pendingDebitEnd!;

  @override
  bool operator ==(Object other) =>
      other is DeferredCardCycle &&
      other.start == start &&
      other.end == end &&
      other.debitDate == debitDate &&
      other.pendingDebitStart == pendingDebitStart &&
      other.pendingDebitEnd == pendingDebitEnd &&
      other.pendingDebitDate == pendingDebitDate;

  @override
  int get hashCode => Object.hash(
    start,
    end,
    debitDate,
    pendingDebitStart,
    pendingDebitEnd,
    pendingDebitDate,
  );

  @override
  String toString() =>
      'DeferredCardCycle(active: $start..$end -> $debitDate'
      '${hasPendingDebit ? ', pending: $pendingDebitStart..$pendingDebitEnd -> $pendingDebitDate' : ''})';
}

/// Computes the deferred card cycle for [today] given [cutoffDay] and [debitDay].
DeferredCardCycle deferredCardCycle(
  LocalDate today, {
  required int cutoffDay,
  int? debitDay,
}) {
  final clampedCutoff = cutoffDay.clamp(1, 31);
  final effDebitDay = (debitDay ?? clampedCutoff).clamp(1, 31);

  // Helper to compute (start, end, debitDate) for a cycle ending in month (y, m)
  (LocalDate, LocalDate, LocalDate) cycleEndingIn(int y, int m) {
    final lastDay = LocalDate.daysInMonth(y, m);
    final effCutoff = clampedCutoff > lastDay ? lastDay : clampedCutoff;
    final end = LocalDate(y, m, effCutoff);

    // Starts day after previous month's cutoff
    final prevMonth = end.addMonths(-1);
    final prevLastDay = LocalDate.daysInMonth(prevMonth.year, prevMonth.month);
    final prevCutoff = clampedCutoff > prevLastDay
        ? prevLastDay
        : clampedCutoff;
    final start = LocalDate(
      prevMonth.year,
      prevMonth.month,
      prevCutoff,
    ).addDays(1);

    final LocalDate debit;
    if (effDebitDay > clampedCutoff) {
      // Debited in the same month as cutoff
      final debLast = LocalDate.daysInMonth(y, m);
      final effDeb = effDebitDay > debLast ? debLast : effDebitDay;
      debit = LocalDate(y, m, effDeb);
    } else {
      // Debited in the next month
      final nextMonth = end.addMonths(1);
      final debLast = LocalDate.daysInMonth(nextMonth.year, nextMonth.month);
      final effDeb = effDebitDay > debLast ? debLast : effDebitDay;
      debit = LocalDate(nextMonth.year, nextMonth.month, effDeb);
    }
    return (start, end, debit);
  }

  final curMonthLast = LocalDate.daysInMonth(today.year, today.month);
  final thisMonthCutoff = clampedCutoff > curMonthLast
      ? curMonthLast
      : clampedCutoff;

  final LocalDate start;
  final LocalDate end;
  final LocalDate debitDate;
  LocalDate? pendingStart;
  LocalDate? pendingEnd;
  LocalDate? pendingDebit;

  if (today.day <= thisMonthCutoff) {
    // Current cycle ends this month
    final (s, e, d) = cycleEndingIn(today.year, today.month);
    start = s;
    end = e;
    debitDate = d;

    // Is previous cycle (ended last month) still pending debit?
    if (effDebitDay <= clampedCutoff) {
      final prev = today.addMonths(-1);
      final (ps, pe, pd) = cycleEndingIn(prev.year, prev.month);
      if (!today.isAfter(pd)) {
        pendingStart = ps;
        pendingEnd = pe;
        pendingDebit = pd;
      }
    }
  } else {
    // Today is after cutoff -> active cycle ends next month
    final next = today.addMonths(1);
    final (s, e, d) = cycleEndingIn(next.year, next.month);
    start = s;
    end = e;
    debitDate = d;

    // Cycle that just ended this month is pending debit if today <= its debit date
    final (ps, pe, pd) = cycleEndingIn(today.year, today.month);
    if (!today.isAfter(pd)) {
      pendingStart = ps;
      pendingEnd = pe;
      pendingDebit = pd;
    }
  }

  return DeferredCardCycle(
    start: start,
    end: end,
    debitDate: debitDate,
    pendingDebitStart: pendingStart,
    pendingDebitEnd: pendingEnd,
    pendingDebitDate: pendingDebit,
  );
}
