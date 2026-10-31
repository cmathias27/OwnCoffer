import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';
import '../security/access.dart';

/// Data of the spending engine, read on the accounts the user may see.
abstract final class SpendingService {
  /// The visible accounts of the group, or the one asked for.
  static Future<Set<int>> accounts(
    Session session,
    int groupId,
    int? accountId,
  ) async {
    if (accountId != null) {
      final a = await Access.requireAccount(session, accountId);
      if (a.groupId != groupId) {
        throw AccessDeniedException(code: 'account_access_denied');
      }
      return {accountId};
    }
    final visible = await Access.visibleAccounts(session, groupId);
    return {for (final a in visible) a.id!};
  }

  static Future<List<core.SpendingCategory>> categories(
    Session session,
    int groupId,
  ) async => [
    // Archived categories too: their operations still count.
    for (final c in await Category.db.find(
      session,
      where: (c) => c.groupId.equals(groupId),
    ))
      core.SpendingCategory(
        c.id!,
        core.StandardKind.values.byName(c.kind.name),
        parentId: c.parentId,
      ),
  ];

  static Future<List<core.SpendingOperation>> operations(
    Session session,
    Set<int> accountIds,
    core.LocalDate from,
    core.LocalDate to,
  ) async {
    if (accountIds.isEmpty) return const [];
    final rows = await BankTransaction.db.find(
      session,
      where: (t) =>
          t.accountId.inSet(accountIds) &
          t.deletedAt.equals(null) &
          (t.date >= from.toDb()) &
          (t.date < to.toDb()),
    );
    return [
      for (final t in rows)
        core.SpendingOperation(
          t.date.toLocalDate(),
          t.amountCents,
          categoryId: t.categoryId,
          internalTransfer: t.transferPairId != null,
        ),
    ];
  }

  /// The period containing [date], months starting on the group's day.
  static Future<core.Period> period(
    Session session,
    int groupId,
    core.PeriodKind kind,
    core.LocalDate date,
  ) async {
    final group = await FinanceGroup.db.findById(session, groupId);
    return core.Period.containing(
      kind,
      date,
      monthStartDay: (group?.monthStartDay ?? 1).clamp(1, 28),
    );
  }

  /// Average monthly income of the three last complete months.
  static Future<int> averageMonthlyIncome(
    Session session,
    int groupId,
    core.LocalDate today,
  ) async {
    final ids = await accounts(session, groupId, null);
    final month = await period(session, groupId, core.PeriodKind.month, today);
    final from = month.shift(-3);
    final cats = await categories(session, groupId);
    final ops = await operations(session, ids, from.start, month.start);
    return core.summarizeSpending(cats, ops).incomeCents ~/ 3;
  }
}

/// [id] and every category below it.
Set<int> descendantsOf(int id, List<Category> all) {
  final result = <int>{id};
  var added = true;
  while (added) {
    added = false;
    for (final c in all) {
      if (c.parentId != null &&
          result.contains(c.parentId) &&
          result.add(c.id!)) {
        added = true;
      }
    }
  }
  return result;
}
