import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../endpoints/goal_endpoint.dart';
import '../endpoints/loan_endpoint.dart';
import '../endpoints/rule_endpoint.dart';
import '../endpoints/transaction_endpoint.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import 'classification_service.dart';
import 'spending_service.dart';

/// The circuit of décision 0009: proposals are stored here, checked again
/// when the user accepts them, and applied only by [_execute] through the
/// same endpoints the app uses (same rights, same checks, same audit).
abstract final class ProposalService {
  static const kinds = {
    'set_goal',
    'set_category',
    'create_loan',
    'create_rule',
  };

  /// What [kind] on [targetId] rests on now: a proposal made on other data
  /// is not applied.
  static Future<String> dataVersion(
    Session session,
    String kind,
    int targetId, [
    String? proposedData,
  ]) async {
    switch (kind) {
      case 'set_goal':
        final g = await Goal.db.findFirstRow(
          session,
          where: (g) => g.categoryId.equals(targetId),
        );
        return 'goal:$targetId:${g?.amountCents ?? 'none'}';
      case 'set_category':
        final t = await BankTransaction.db.findById(session, targetId);
        return 'tx:$targetId:${t?.categoryId ?? 'none'}:'
            '${t?.updatedAt.millisecondsSinceEpoch ?? 0}:${t?.deletedAt != null}';
      case 'create_loan':
        // A new loan rests on nothing that can change.
        return 'loan:new';
      case 'create_rule':
        // The example operation (target) may be classified in the meantime;
        // what matters is that the same rule was not created since.
        final f = _fields(proposedData);
        final t = await BankTransaction.db.findById(session, targetId);
        final a = t == null
            ? null
            : await Account.db.findById(session, t.accountId);
        final same = a == null
            ? 0
            : await Rule.db.count(
                session,
                where: (r) =>
                    r.groupId.equals(a.groupId) &
                    r.pattern.equals('${f['pattern']}') &
                    r.matchType.equals(_matchType(f)) &
                    r.direction.equals(_direction(f)),
              );
        return 'rule:${f['pattern']}:${f['match_type']}:${f['direction']}:'
            '${a?.groupId ?? 'none'}:$same';
    }
    throw ArgumentError.value(kind, 'kind');
  }

  /// Stores a proposal unless the same change is already open. Returns it,
  /// or null when it was already there.
  static Future<ActionProposal?> propose(
    Session session, {
    required int groupId,
    required String kind,
    required int targetId,
    required int? currentValue,
    required int? proposedValue,
    required String reason,
    required Map<String, Object?> data,
    String? proposedData,
    UuidValue? forUser,
    String origin = 'engine',
    String? provider,
    String? model,
  }) async {
    if (!kinds.contains(kind)) throw ArgumentError.value(kind, 'kind');
    final user = forUser ?? Access.userId(session);
    final version = await dataVersion(session, kind, targetId, proposedData);
    final key =
        '$kind:$targetId:$proposedValue:$version:'
        '${proposedData == null ? '' : sha256.convert(utf8.encode(proposedData))}';
    final existing = await ActionProposal.db.findFirstRow(
      session,
      where: (p) =>
          p.authUserId.equals(user) &
          p.groupId.equals(groupId) &
          p.dedupKey.equals(key),
    );
    if (existing != null) return null;
    final row = await ActionProposal.db.insertRow(
      session,
      ActionProposal(
        groupId: groupId,
        authUserId: user,
        origin: origin,
        provider: provider,
        model: model,
        kind: kind,
        targetId: targetId,
        currentValue: currentValue,
        proposedValue: proposedValue,
        proposedData: proposedData,
        reason: reason,
        data: jsonEncode(data),
        dataVersion: version,
        status: 'pending',
        dedupKey: key,
      ),
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'propose',
      entity: 'action_proposal',
      rowId: row.id,
      after: row,
    );
    return row;
  }

  /// Accepts and applies [id], once: a second call returns the proposal as
  /// it is. Refused when the data changed (then expired) or when the user
  /// may not make the change.
  static Future<ActionProposal> accept(Session session, int id) async {
    final p = await _find(session, id);
    if (p.status == 'executed') return p;
    if (p.status != 'pending') {
      throw InvalidInputException(code: 'proposal_closed');
    }
    if (await dataVersion(session, p.kind, p.targetId, p.proposedData) !=
        p.dataVersion) {
      final expired = await ActionProposal.db.updateRow(
        session,
        p.copyWith(status: 'expired', decidedAt: DateTime.now().toUtc()),
      );
      await _audit(session, expired, 'expire');
      throw InvalidInputException(code: 'proposal_stale');
    }
    // Claimed atomically: two clicks, or two tabs, apply it once.
    final claimed = await session.db.unsafeQuery(
      "UPDATE action_proposals SET status = 'executing' "
      "WHERE id = ${p.id} AND status = 'pending' RETURNING id",
    );
    if (claimed.isEmpty) return _find(session, id);
    int? result;
    try {
      result = await _execute(session, p, p.proposedValue);
    } on Object {
      await ActionProposal.db.updateRow(session, p.copyWith(status: 'pending'));
      rethrow;
    }
    final now = DateTime.now().toUtc();
    final done = await ActionProposal.db.updateRow(
      session,
      p.copyWith(
        status: 'executed',
        decidedAt: now,
        executedAt: now,
        resultId: result,
        decidedBy: Access.userId(session),
      ),
    );
    await _audit(session, done, 'execute');
    if (p.kind == 'create_rule') await _closeCovered(session, p);
    return done;
  }

  static Future<ActionProposal> refuse(Session session, int id) async {
    final p = await _find(session, id);
    if (p.status == 'refused') return p;
    if (p.status != 'pending') {
      throw InvalidInputException(code: 'proposal_closed');
    }
    await Access.requireMember(session, p.groupId, min: MemberRole.user);
    final done = await ActionProposal.db.updateRow(
      session,
      p.copyWith(
        status: 'refused',
        decidedAt: DateTime.now().toUtc(),
        decidedBy: Access.userId(session),
      ),
    );
    await _audit(session, done, 'refuse');
    return done;
  }

  /// Puts back what the change replaced, when nothing changed since.
  static Future<ActionProposal> undo(Session session, int id) async {
    final p = await _find(session, id);
    if (p.status == 'undone') return p;
    if (p.status != 'executed') {
      throw InvalidInputException(code: 'proposal_closed');
    }
    if (p.kind == 'create_loan') {
      if (p.resultId != null) {
        await LoanEndpoint().delete(session, p.resultId!);
      }
    } else if (p.kind == 'create_rule') {
      // The rule is deleted and its operations classified again without it;
      // a rule the user already deleted leaves nothing to undo.
      final rule = p.resultId == null
          ? null
          : await Rule.db.findById(session, p.resultId!);
      if (rule != null && rule.groupId == p.groupId) {
        await RuleEndpoint().undoCreate(session, rule.id!);
      }
    } else {
      await _execute(session, p, p.currentValue);
    }
    final done = await ActionProposal.db.updateRow(
      session,
      p.copyWith(status: 'undone', decidedAt: DateTime.now().toUtc()),
    );
    await _audit(session, done, 'undo');
    return done;
  }

  /// The financial commands: the only place a proposal changes data, by
  /// the endpoints of the app (rights and checks of the user who accepts).
  /// Returns the id of what was created, if anything.
  static Future<int?> _execute(
    Session session,
    ActionProposal p,
    int? value,
  ) async {
    switch (p.kind) {
      case 'set_goal':
        if (value == null) {
          await GoalEndpoint().remove(session, p.groupId, p.targetId);
        } else {
          await GoalEndpoint().set(session, p.groupId, p.targetId, value);
        }
        return null;
      case 'set_category':
        await TransactionEndpoint().setCategory(session, p.targetId, value);
        return null;
      case 'create_loan':
        final f = jsonDecode(p.proposedData ?? '{}') as Map<String, Object?>;
        int? n(String k) => (f[k] as num?)?.toInt();
        final first = DateTime.tryParse(f['first_due_date'] as String? ?? '');
        final kind = LoanKind.values
            .where((k) => k.name == f['kind'])
            .firstOrNull;
        if (first == null || kind == null) {
          throw InvalidInputException(code: 'proposal_unknown');
        }
        final label = (f['label'] as String?)?.trim();
        // The loan page's own checks apply (amounts, rate, duration).
        final info = await LoanEndpoint().create(
          session,
          p.groupId,
          Loan(
            groupId: p.groupId,
            kind: kind,
            lender: f['lender'] as String? ?? '',
            label: label == null || label.isEmpty ? null : label,
            principalCents: n('principal_cents') ?? 0,
            annualRateMilli: n('annual_rate_milli') ?? 0,
            durationMonths: n('duration_months') ?? 0,
            paymentCents: n('payment_cents'),
            firstDueDate: DateTime.utc(first.year, first.month, first.day),
            insuranceMonthlyCents: n('insurance_monthly_cents') ?? 0,
          ),
        );
        return info.loan.id;
      case 'create_rule':
        final f = _fields(p.proposedData);
        if (value == null || f['pattern'] is! String) {
          throw InvalidInputException(code: 'proposal_unknown');
        }
        // The rule page's own checks apply (rights, category, pattern).
        final rule = await RuleEndpoint().create(
          session,
          p.groupId,
          value,
          f['pattern'] as String,
          _matchType(f),
          direction: _direction(f),
        );
        final visible = await Access.visibleAccounts(session, p.groupId);
        await ClassificationService.applyRule(session, rule, {
          for (final a in visible) a.id!,
        });
        return rule.id;
      default:
        throw InvalidInputException(code: 'proposal_unknown');
    }
  }

  static Map<String, Object?> _fields(String? json) {
    final f = jsonDecode(json ?? '{}');
    return f is Map<String, Object?> ? f : const {};
  }

  static RuleMatchType _matchType(Map<String, Object?> f) =>
      RuleMatchType.values
          .where((m) => m.name == f['match_type'])
          .firstOrNull ??
      RuleMatchType.startsWith;

  static RuleDirection _direction(Map<String, Object?> f) =>
      RuleDirection.values.where((d) => d.name == f['direction']).firstOrNull ??
      RuleDirection.any;

  /// Once a rule is accepted, the user's open category proposals it already
  /// fulfilled (the operation now has the proposed category) are closed: they
  /// would only be refused as stale.
  static Future<void> _closeCovered(
    Session session,
    ActionProposal rule,
  ) async {
    final open = await ActionProposal.db.find(
      session,
      where: (x) =>
          x.authUserId.equals(rule.authUserId) &
          x.groupId.equals(rule.groupId) &
          x.kind.equals('set_category') &
          x.status.equals('pending'),
    );
    for (final x in open) {
      final t = await BankTransaction.db.findById(session, x.targetId);
      if (t == null || t.categoryId != x.proposedValue) continue;
      final closed = await ActionProposal.db.updateRow(
        session,
        x.copyWith(status: 'expired', decidedAt: DateTime.now().toUtc()),
      );
      await _audit(session, closed, 'expire');
    }
  }

  static Future<ActionProposal> _find(Session session, int id) async {
    final p = await ActionProposal.db.findById(session, id);
    if (p == null) {
      throw AccessDeniedException(code: 'proposal_access_denied');
    }
    // Only its user sees it, and only while still a member of the group.
    if (p.authUserId != Access.userId(session)) {
      throw AccessDeniedException(code: 'proposal_access_denied');
    }
    try {
      await Access.requireMember(session, p.groupId);
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'proposal_access_denied');
    }
    return p;
  }

  static Future<void> _audit(
    Session session,
    ActionProposal p,
    String action,
  ) => Audit.log(
    session,
    groupId: p.groupId,
    action: action,
    entity: 'action_proposal',
    rowId: p.id,
    after: p,
  );

  /// The advisor's pass for the user: proposals on the monthly goals from
  /// the last three complete budget months of the accounts they may see
  /// (core.adviseGoals). Their open ones whose data changed are expired.
  static Future<void> refreshAdvice(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    final user = Access.userId(session);
    final open = await ActionProposal.db.find(
      session,
      where: (p) =>
          p.authUserId.equals(user) &
          p.groupId.equals(groupId) &
          p.status.equals('pending'),
    );
    for (final p in open) {
      if (await dataVersion(session, p.kind, p.targetId, p.proposedData) !=
          p.dataVersion) {
        await ActionProposal.db.updateRow(
          session,
          p.copyWith(status: 'expired', decidedAt: DateTime.now().toUtc()),
        );
      }
    }
    final today = core.LocalDate.fromDateTime(DateTime.now().toUtc());
    final month = await SpendingService.period(
      session,
      groupId,
      core.PeriodKind.month,
      today,
    );
    final first = month.shift(-3);
    final ids = await SpendingService.accounts(session, groupId, null);
    final categories = await SpendingService.categories(session, groupId);
    final ops = await SpendingService.operations(
      session,
      ids,
      first.start,
      month.start,
    );
    final tops = await Category.db.find(
      session,
      where: (c) =>
          c.groupId.equals(groupId) &
          c.parentId.equals(null) &
          c.deletedAt.equals(null) &
          c.kind.equals(CategoryKind.expense),
    );
    final months = <int, List<int>>{for (final c in tops) c.id!: []};
    for (var i = -3; i < 0; i++) {
      final p = month.shift(i);
      final s = core.summarizeSpending(
        categories,
        ops.where((o) => p.contains(o.date)),
      );
      for (final c in tops) {
        months[c.id!]!.add(s.totals[c.id] ?? 0);
      }
    }
    final goals = {
      for (final g in await Goal.db.find(
        session,
        where: (g) => g.groupId.equals(groupId),
      ))
        g.categoryId: g.amountCents,
    };
    for (final a in core.adviseGoals(months, goals)) {
      await propose(
        session,
        groupId: groupId,
        kind: 'set_goal',
        targetId: a.categoryId,
        currentValue: a.currentCents,
        proposedValue: a.proposedCents,
        reason: '${a.kind.name}_goal',
        data: {
          'months': a.monthsCents,
          'from': first.start.toDb().toIso8601String(),
        },
      );
    }
  }
}
