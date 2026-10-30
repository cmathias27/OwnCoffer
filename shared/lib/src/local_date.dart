/// A calendar date without time or time zone (operation dates).
library;

/// Order of day, month and year in numeric dates.
enum DateOrder { dayMonthYear, monthDayYear, yearMonthDay }

class LocalDate implements Comparable<LocalDate> {
  final int year;
  final int month;
  final int day;

  LocalDate(this.year, this.month, this.day) {
    if (year < 1900 || year > 2999) {
      throw ArgumentError('Year out of range: $year');
    }
    if (month < 1 || month > 12) {
      throw ArgumentError('Month out of range: $month');
    }
    if (day < 1 || day > daysInMonth(year, month)) {
      throw ArgumentError('Day out of range: $year-$month-$day');
    }
  }

  /// Builds a date from the calendar fields of [dateTime], ignoring its zone.
  factory LocalDate.fromDateTime(DateTime dateTime) =>
      LocalDate(dateTime.year, dateTime.month, dateTime.day);

  /// Today in the local zone of the machine running the code.
  factory LocalDate.today() => LocalDate.fromDateTime(DateTime.now());

  /// Days since 1970-01-01, computed in UTC so daylight saving never matters.
  int get epochDay =>
      DateTime.utc(year, month, day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  factory LocalDate.fromEpochDay(int epochDay) {
    final d = DateTime.fromMillisecondsSinceEpoch(
      epochDay * Duration.millisecondsPerDay,
      isUtc: true,
    );
    return LocalDate(d.year, d.month, d.day);
  }

  LocalDate addDays(int days) => LocalDate.fromEpochDay(epochDay + days);

  /// Adds months, clamping the day to the end of the target month
  /// (31 January + 1 month = 28 or 29 February).
  LocalDate addMonths(int months, {int? preferredDay}) {
    final total = year * 12 + (month - 1) + months;
    final y = total ~/ 12;
    final m = total % 12 + 1;
    final wanted = preferredDay ?? day;
    final last = daysInMonth(y, m);
    return LocalDate(y, m, wanted > last ? last : wanted);
  }

  int daysUntil(LocalDate other) => other.epochDay - epochDay;

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  bool operator <(LocalDate other) => compareTo(other) < 0;
  bool operator <=(LocalDate other) => compareTo(other) <= 0;
  bool operator >(LocalDate other) => compareTo(other) > 0;
  bool operator >=(LocalDate other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  /// ISO 8601: `2026-10-30`.
  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  static bool isLeapYear(int year) =>
      (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  static int daysInMonth(int year, int month) {
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && isLeapYear(year)) return 29;
    return days[month - 1];
  }

  static final RegExp _compact = RegExp(r'^(\d{4})(\d{2})(\d{2})');
  static final RegExp _separated = RegExp(
    r"^(\d{1,4})\s*[/\-.' ]\s*(\d{1,2})\s*[/\-.' ]\s*(\d{1,4})$",
  );

  /// Parses `30/10/2026`, `30/10/26`, `30-10-2026`, `30.10.2026`,
  /// `2026-10-30`, and the compact OFX form `20261030[hhmmss…]`.
  ///
  /// Two-digit years: 00–69 → 2000s, 70–99 → 1900s. Throws [FormatException]
  /// on anything else or on an impossible date.
  static LocalDate parse(
    String input, {
    DateOrder order = DateOrder.dayMonthYear,
  }) {
    final s = input.trim();
    final compact = _compact.firstMatch(s);
    if (compact != null) {
      return _build(
        input,
        int.parse(compact[1]!),
        int.parse(compact[2]!),
        int.parse(compact[3]!),
      );
    }
    final m = _separated.firstMatch(s);
    if (m == null) throw FormatException('Unrecognised date', input);
    final a = m[1]!, b = m[2]!, c = m[3]!;

    if (a.length == 4) {
      return _build(input, int.parse(a), int.parse(b), int.parse(c));
    }
    if (c.length != 2 && c.length != 4) {
      throw FormatException('Unrecognised year', input);
    }
    final year = _expandYear(int.parse(c), c.length);
    return switch (order) {
      DateOrder.monthDayYear => _build(input, year, int.parse(a), int.parse(b)),
      _ => _build(input, year, int.parse(b), int.parse(a)),
    };
  }

  static LocalDate? tryParse(
    String input, {
    DateOrder order = DateOrder.dayMonthYear,
  }) {
    try {
      return parse(input, order: order);
    } on FormatException {
      return null;
    }
  }

  static int _expandYear(int y, int digits) {
    if (digits == 4) return y;
    return y < 70 ? 2000 + y : 1900 + y;
  }

  static LocalDate _build(String input, int y, int m, int d) {
    try {
      return LocalDate(y, m, d);
    } on ArgumentError {
      throw FormatException('Impossible date', input);
    }
  }
}
