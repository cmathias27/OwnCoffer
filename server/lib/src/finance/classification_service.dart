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

  /// Applies a new group [rule] at once to the operations of [accountIds]
  /// not classified by hand; returns the operations it reclassified.
  static Future<List<BankTransaction>> applyRule(
    Session session,
    Rule rule,
    Set<int> accountIds, {
    Transaction? transaction,
  }) async {
    if (accountIds.isEmpty) return [];
    final matcher = core.GroupRule<int>(
      id: rule.id!,
      categoryId: rule.categoryId,
      pattern: rule.pattern,
      matchType: core.MatchType.values.byName(rule.matchType.name),
      direction: core.Direction.values.byName(rule.direction.name),
      minAbsCents: rule.minAbsCents,
      maxAbsCents: rule.maxAbsCents,
    );
    final candidates = await BankTransaction.db.find(
      session,
      where: (x) =>
          x.accountId.inSet(accountIds) &
          x.deletedAt.equals(null) &
          x.categorySource.notEquals(CategorySource.manual),
      transaction: transaction,
    );
    final now = DateTime.now().toUtc();
    final changed = [
      for (final x in candidates)
        if (matcher.matches(
          core.CleanedLabel(
            x.cleanLabel,
            core.normalizeForMatch('${x.rawLabel} ${x.memo ?? ''}'),
            core.OperationKind.other,
          ),
          x.amountCents,
        ))
          x.copyWith(
            categoryId: rule.categoryId,
            categorySource: CategorySource.groupRule,
            categoryRuleRef: '${rule.id}',
            updatedAt: now,
          ),
    ];
    if (changed.isNotEmpty) {
      await BankTransaction.db.update(
        session,
        changed,
        transaction: transaction,
      );
    }
    return changed;
  }

  /// Undoes a group rule: deletes it, then classifies again (without it) the
  /// operations it had classified. Manual choices are left alone. Returns
  /// how many operations were classified again.
  static Future<int> revertRule(
    Session session,
    int groupId,
    int ruleId, {
    Transaction? transaction,
  }) async {
    final accounts = await Account.db.find(
      session,
      where: (a) => a.groupId.equals(groupId),
      transaction: transaction,
    );
    final Set<int> ids = {for (final a in accounts) a.id!};
    final classified = ids.isEmpty
        ? <BankTransaction>[]
        : await BankTransaction.db.find(
            session,
            where: (t) =>
                t.accountId.inSet(ids) &
                t.categorySource.equals(CategorySource.groupRule) &
                t.categoryRuleRef.equals('$ruleId'),
            transaction: transaction,
          );
    await Rule.db.deleteWhere(
      session,
      where: (r) => r.id.equals(ruleId) & r.groupId.equals(groupId),
      transaction: transaction,
    );
    if (classified.isEmpty) return 0;
    final classifier = await forGroup(
      session,
      groupId,
      transaction: transaction,
    );
    final now = DateTime.now().toUtc();
    final updated = [
      for (final t in classified)
        () {
          final c = classifier.classify(
            core.CleanedLabel(
              t.cleanLabel,
              core.normalizeForMatch('${t.rawLabel} ${t.memo ?? ''}'),
              core.OperationKind.values.asNameMap()[t.operationKind] ??
                  core.OperationKind.other,
            ),
            t.amountCents,
          );
          return t.copyWith(
            categoryId: c.categoryId,
            categorySource: toDb(c.source),
            categoryRuleRef: c.ruleId?.toString(),
            updatedAt: now,
          );
        }(),
    ];
    await BankTransaction.db.update(
      session,
      updated,
      transaction: transaction,
    );
    return updated.length;
  }
}
