import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../finance/classification_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Classification rules of a group (cahier des charges, Classement).
class RuleEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<List<Rule>> list(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    return Rule.db.find(
      session,
      where: (r) => r.groupId.equals(groupId),
      orderBy: (r) => r.priority,
    );
  }

  Future<Rule> create(
    Session session,
    int groupId,
    int categoryId,
    String pattern,
    RuleMatchType matchType, {
    RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    int? priority,
  }) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    await _ownCategory(session, groupId, categoryId);
    final draft = Rule(
      groupId: groupId,
      categoryId: categoryId,
      matchType: matchType,
      pattern: _pattern(pattern),
      direction: direction ?? RuleDirection.any,
      minAbsCents: _bound(minAbsCents),
      maxAbsCents: _bound(maxAbsCents),
      priority: priority ?? 100,
      createdBy: Access.userId(session),
    );
    _checkBounds(draft);
    final rule = await Rule.db.insertRow(session, draft);
    await Audit.log(
      session,
      groupId: groupId,
      action: 'create',
      entity: 'rule',
      rowId: rule.id,
      after: rule,
    );
    return rule;
  }

  Future<Rule> update(
    Session session,
    int ruleId, {
    int? categoryId,
    String? pattern,
    RuleMatchType? matchType,
    RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    bool? clearAmounts,
    int? priority,
    bool? enabled,
  }) async {
    final current = await _find(session, ruleId);
    if (categoryId != null) {
      await _ownCategory(session, current.groupId, categoryId);
    }
    final next = current.copyWith(
      categoryId: categoryId,
      pattern: pattern == null ? null : _pattern(pattern),
      matchType: matchType,
      direction: direction,
      minAbsCents: clearAmounts == true
          ? null
          : (minAbsCents ?? current.minAbsCents),
      maxAbsCents: clearAmounts == true
          ? null
          : (maxAbsCents ?? current.maxAbsCents),
      priority: priority,
      enabled: enabled,
    );
    _checkBounds(next);
    final updated = await Rule.db.updateRow(session, next);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'update',
      entity: 'rule',
      rowId: ruleId,
      before: current,
      after: updated,
    );
    return updated;
  }

  Future<void> delete(Session session, int ruleId) async {
    final current = await _find(session, ruleId);
    await Rule.db.deleteRow(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'delete',
      entity: 'rule',
      rowId: ruleId,
      before: current,
    );
  }

  /// Rule tester: how a bank label would be cleaned and classified now
  /// (group rules → community rules → history). Writes nothing.
  Future<RuleTestResult> tryLabel(
    Session session,
    int groupId,
    String label,
    int amountCents,
  ) async {
    await Access.requireMember(session, groupId);
    final text = label.trim();
    if (text.isEmpty || text.length > 200) {
      throw InvalidInputException(code: 'invalid_name', field: 'label');
    }
    if (amountCents == 0 || amountCents.abs() > 100000000000000) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    final cleaned = core.cleanCaisseEpargneLabel(text);
    final c = (await ClassificationService.forGroup(
      session,
      groupId,
    )).classify(cleaned, amountCents);
    return RuleTestResult(
      cleanLabel: cleaned.display,
      operationKind: cleaned.kind.name,
      categoryId: c.categoryId,
      source: ClassificationService.toDb(c.source),
      ruleRef: c.ruleId?.toString(),
    );
  }

  static Future<Rule> _find(Session session, int id) async {
    final r = await Rule.db.findById(session, id);
    if (r == null) throw AccessDeniedException(code: 'rule_access_denied');
    try {
      await Access.requireMember(session, r.groupId, min: MemberRole.user);
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'rule_access_denied');
    }
    return r;
  }

  static Future<void> _ownCategory(
    Session session,
    int groupId,
    int categoryId,
  ) async {
    final c = await Category.db.findById(session, categoryId);
    if (c == null || c.groupId != groupId || c.deletedAt != null) {
      throw AccessDeniedException(code: 'category_access_denied');
    }
  }

  static String _pattern(String pattern) {
    final p = core.normalizeForMatch(pattern);
    if (p.isEmpty || p.length > 100) {
      throw InvalidInputException(code: 'invalid_pattern', field: 'pattern');
    }
    return p;
  }

  static int? _bound(int? cents) {
    if (cents == null) return null;
    if (cents < 0 || cents > 100000000000000) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    return cents;
  }

  static void _checkBounds(Rule r) {
    if (r.minAbsCents != null &&
        r.maxAbsCents != null &&
        r.minAbsCents! > r.maxAbsCents!) {
      throw InvalidInputException(code: 'invalid_amount_range');
    }
  }
}
