import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../generated/protocol.dart';

/// Checks shared by the planning endpoints of decision 0050 (projects,
/// assets, refunds, events, shared expenses, reminders).
abstract final class PlanInputs {
  static const maxCents = 100000000000;

  /// A name or label: trimmed, 1 to [max] characters.
  static String text(String value, {String field = 'name', int max = 80}) {
    final t = value.trim();
    if (t.isEmpty || t.length > max) {
      throw InvalidInputException(code: 'invalid_name', field: field);
    }
    return t;
  }

  /// A positive amount (zero when [allowZero]).
  static int cents(int value, {bool allowZero = false}) {
    if (value < (allowZero ? 0 : 1) || value > maxCents) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    return value;
  }

  /// A calendar day stored as UTC midnight.
  static DateTime day(DateTime d) {
    final u = d.toUtc();
    return DateTime.utc(u.year, u.month, u.day);
  }

  /// Today in UTC, as every other endpoint (the standalone app runs this
  /// server in the device's time zone).
  static core.LocalDate today() =>
      core.LocalDate.fromDateTime(DateTime.now().toUtc());
}
