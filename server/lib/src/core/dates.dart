import 'package:owncoffer_shared/owncoffer_shared.dart';

/// Operation dates are calendar dates ([LocalDate]); the database stores them
/// as UTC midnight. These are the only two conversion points.
extension LocalDateDb on LocalDate {
  DateTime toDb() => DateTime.utc(year, month, day);
}

extension DbLocalDate on DateTime {
  LocalDate toLocalDate() {
    final utc = toUtc();
    if (utc.hour != 0 || utc.minute != 0 || utc.second != 0) {
      throw StateError('Stored operation date is not UTC midnight: $this');
    }
    return LocalDate(utc.year, utc.month, utc.day);
  }
}
