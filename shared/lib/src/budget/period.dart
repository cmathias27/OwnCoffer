import '../local_date.dart';

enum PeriodKind { week, month, year }

/// A calendar period: a week (Monday to Sunday), a month or a year.
class Period {
  final PeriodKind kind;

  /// First day, inclusive.
  final LocalDate start;

  const Period._(this.kind, this.start);

  /// The period of [kind] that contains [date].
  factory Period.containing(PeriodKind kind, LocalDate date) => switch (kind) {
    // epochDay 0 (1 January 1970) is a Thursday: Monday is 3 days before.
    PeriodKind.week => Period._(
      kind,
      date.addDays(-((date.epochDay + 3) % 7)),
    ),
    PeriodKind.month => Period._(kind, LocalDate(date.year, date.month, 1)),
    PeriodKind.year => Period._(kind, LocalDate(date.year, 1, 1)),
  };

  /// First day of the next period (exclusive end).
  LocalDate get end => switch (kind) {
    PeriodKind.week => start.addDays(7),
    PeriodKind.month => start.addMonths(1),
    PeriodKind.year => start.addMonths(12),
  };

  /// Last day, inclusive.
  LocalDate get last => end.addDays(-1);

  int get days => start.daysUntil(end);

  Period shift(int periods) => switch (kind) {
    PeriodKind.week => Period._(kind, start.addDays(7 * periods)),
    PeriodKind.month => Period._(kind, start.addMonths(periods)),
    PeriodKind.year => Period._(kind, start.addMonths(12 * periods)),
  };

  bool contains(LocalDate d) => d >= start && d < end;

  @override
  bool operator ==(Object other) =>
      other is Period && other.kind == kind && other.start == start;

  @override
  int get hashCode => Object.hash(kind, start);

  @override
  String toString() => 'Period(${kind.name}, $start)';
}
