import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';

/// Expected refunds settled by the first matching credit (decision 0050).
abstract final class RefundService {
  /// Links the open refunds of [groupId] to a credit of the same amount on
  /// [accountIds] (or on their own account, if one of them), received on or
  /// after their day and not settling another refund. Returns how many were
  /// settled.
  static Future<int> match(
    Session session,
    int groupId,
    Set<int> accountIds,
  ) async {
    if (accountIds.isEmpty) return 0;
    final open = await ExpectedRefund.db.find(
      session,
      where: (r) => r.groupId.equals(groupId) & r.receivedAt.equals(null),
      orderBy: (r) => r.since,
    );
    if (open.isEmpty) return 0;
    final taken = <int>{
      for (final r in await ExpectedRefund.db.find(
        session,
        where: (r) =>
            r.groupId.equals(groupId) & r.transactionId.notEquals(null),
      ))
        r.transactionId!,
    };
    var settled = 0;
    for (final r in open) {
      final Set<int> where = r.accountId == null
          ? accountIds
          : (accountIds.contains(r.accountId) ? {r.accountId!} : <int>{});
      if (where.isEmpty) continue;
      final credits = [
        for (final t in await BankTransaction.db.find(
          session,
          where: (t) =>
              t.accountId.inSet(where) &
              t.deletedAt.equals(null) &
              t.amountCents.equals(r.amountCents) &
              (t.date >= r.since),
          orderBy: (t) => t.date,
          limit: 20,
        ))
          if (!taken.contains(t.id)) t,
      ];
      final i = core.matchRefund(
        amountCents: r.amountCents,
        since: r.since.toLocalDate(),
        credits: [
          for (final t in credits) (t.date.toLocalDate(), t.amountCents),
        ],
      );
      if (i == null) continue;
      final t = credits[i];
      taken.add(t.id!);
      await ExpectedRefund.db.updateRow(
        session,
        r.copyWith(transactionId: t.id, receivedAt: t.date),
      );
      settled++;
    }
    return settled;
  }
}
