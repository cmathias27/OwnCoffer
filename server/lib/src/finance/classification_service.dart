import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../generated/protocol.dart';

/// Builds the deterministic classifier of a group: group rules, then
/// community rules (through the group's categories linked to the standard
/// catalogue), then history of the user's own choices.
abstract final class ClassificationService {
  /// History only learns from categories the user set or confirmed.
  static const historySources = {CategorySource.manual};

  static Future<core.Classifier<int>> forGroup(
    Session session,
    int groupId, {
    Transaction? transaction,
  }) async {
    final rules = await Rule.db.find(
      session,
      where: (r) => r.groupId.equals(groupId) & r.enabled.equals(true),
      transaction: transaction,
    );
    final categories = await Category.db.find(
      session,
      where: (c) => c.groupId.equals(groupId) & c.deletedAt.equals(null),
      orderBy: (c) => c.id,
      transaction: transaction,
    );
    final standardToGroup = <String, int>{};
    for (final c in categories) {
      final code = c.standardCode;
      if (code != null) standardToGroup.putIfAbsent(code, () => c.id!);
    }
    final accounts = await Account.db.find(
      session,
      where: (a) => a.groupId.equals(groupId),
      transaction: transaction,
    );
    final Set<int> accountIds = {for (final a in accounts) a.id!};
    final since = DateTime.now().toUtc().subtract(const Duration(days: 730));
    final history = accountIds.isEmpty
        ? <BankTransaction>[]
        : await BankTransaction.db.find(
            session,
            where: (t) =>
                t.accountId.inSet(accountIds) &
                t.deletedAt.equals(null) &
                t.categoryId.notEquals(null) &
                t.categorySource.inSet(historySources) &
                (t.date > since),
            transaction: transaction,
          );

    return core.Classifier<int>(
      groupRules: [
        for (final r in rules)
          core.GroupRule<int>(
            id: r.id!,
            categoryId: r.categoryId,
            pattern: r.pattern,
            matchType: core.MatchType.values.byName(r.matchType.name),
            direction: core.Direction.values.byName(r.direction.name),
            minAbsCents: r.minAbsCents,
            maxAbsCents: r.maxAbsCents,
            priority: r.priority,
          ),
      ],
      communityRules: core.communityRules,
      standardToGroup: standardToGroup,
      history: [
        for (final t in history)
          core.HistoryEntry<int>(
            labelKey: t.cleanLabel,
            amountCents: t.amountCents,
            categoryId: t.categoryId!,
            date: t.date.toLocalDate(),
          ),
      ],
    );
  }

  static CategorySource toDb(core.CategorySource s) =>
      CategorySource.values.byName(s.name);
}
