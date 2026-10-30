import '../local_date.dart';

enum Frequency { once, weekly, monthly, yearly }

/// When a scheduled operation happens.
///
/// Monthly and yearly occurrences are always computed from [start], never
/// from the previous occurrence, so the day does not drift: the 31st gives
/// 31 Jan, 28 (or 29) Feb, 31 Mar…
class Recurrence {
  final Frequency frequency;

  /// Every [interval] weeks / months / years (3 months = quarterly).
  final int interval;
  final LocalDate start;

  /// Last possible date, inclusive.
  final LocalDate? end;

  /// Maximum number of occurrences, counted from [start].
  final int? count;

  Recurrence({
    required this.frequency,
    required this.start,
    this.interval = 1,
    this.end,
    this.count,
  }) {
    if (interval < 1) throw ArgumentError('Interval must be at least 1');
    if (count != null && count! < 1) throw ArgumentError('Count must be ≥ 1');
    if (end != null && end! < start) throw ArgumentError('End before start');
  }

  factory Recurrence.once(LocalDate date) =>
      Recurrence(frequency: Frequency.once, start: date);

  /// The n-th occurrence (0-based), or null after the end.
  LocalDate? occurrence(int n) {
    if (n < 0) return null;
    if (count != null && n >= count!) return null;
    if (frequency == Frequency.once && n > 0) return null;
    final LocalDate date = switch (frequency) {
      Frequency.once => start,
      Frequency.weekly => start.addDays(7 * interval * n),
      Frequency.monthly => start.addMonths(interval * n),
      Frequency.yearly => start.addMonths(12 * interval * n),
    };
    if (end != null && date > end!) return null;
    return date;
  }

  /// Occurrences in [from, to], both inclusive, in order.
  List<LocalDate> between(LocalDate from, LocalDate to) {
    final result = <LocalDate>[];
    if (to < from) return result;
    var n = _firstIndexOnOrAfter(from);
    while (true) {
      final d = occurrence(n);
      if (d == null || d > to) break;
      if (d >= from) result.add(d);
      n++;
    }
    return result;
  }

  /// Skips directly near [from] instead of iterating from [start].
  int _firstIndexOnOrAfter(LocalDate from) {
    if (from <= start) return 0;
    final n = switch (frequency) {
      Frequency.once => 0,
      Frequency.weekly => start.daysUntil(from) ~/ (7 * interval),
      Frequency.monthly =>
        ((from.year - start.year) * 12 + from.month - start.month) ~/ interval,
      Frequency.yearly => (from.year - start.year) ~/ interval,
    };
    // Step back one to be safe with day clamping, never below zero.
    return n > 0 ? n - 1 : 0;
  }

  /// First occurrence strictly after [date], or null.
  LocalDate? nextAfter(LocalDate date) {
    var n = _firstIndexOnOrAfter(date);
    while (true) {
      final d = occurrence(n);
      if (d == null) return null;
      if (d > date) return d;
      n++;
    }
  }
}
