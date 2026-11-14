import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Month closing (decision 0050): once a group has checked its months up to
/// a day, the operations up to that day can no longer be changed by hand
/// (date, amount, label, category, splits, trash). Bank imports still go
/// in, and pointing stays possible.
abstract final class Closing {
  /// The last closed day of [groupId], or null.
  static Future<DateTime?> closedUntil(
    Session session,
    int groupId, {
    Transaction? transaction,
  }) async => (await FinanceGroup.db.findById(
    session,
    groupId,
    transaction: transaction,
  ))?.closedUntil;

  static bool isClosed(DateTime? closedUntil, DateTime date) =>
      closedUntil != null && !date.toUtc().isAfter(closedUntil.toUtc());

  /// Refuses a change of an operation dated [dates] in a closed month.
  static Future<void> check(
    Session session,
    int groupId,
    Iterable<DateTime> dates, {
    Transaction? transaction,
  }) async {
    final until = await closedUntil(
      session,
      groupId,
      transaction: transaction,
    );
    if (until == null) return;
    for (final d in dates) {
      if (isClosed(until, d)) {
        throw InvalidInputException(code: 'month_closed', field: 'date');
      }
    }
  }
}
