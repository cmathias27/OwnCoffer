import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../finance/plan_inputs.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Expenses shared between the members of a group and the common pot split
/// by income (decision 0050). Who owes whom is computed by the engine.
class SharedEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<SharedOverview> overview(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    final expenses = await SharedExpense.db.find(
      session,
      where: (e) => e.groupId.equals(groupId),
      orderByList: (e) => [e.date.desc(), e.id.desc()],
    );
    final balances = core.sharedBalances([
      for (final e in expenses)
        core.SharedEntry(e.paidBy.uuid, e.amountCents, [
          for (final p in e.participants) p.uuid,
        ]),
    ]);
    final emails = await _emails(session, groupId);
    return SharedOverview(
      expenses: expenses,
      balances: [
        for (final e in balances.entries)
          MemberBalance(
            userId: UuidValue.fromString(e.key),
            email: emails[e.key],
            balanceCents: e.value,
          ),
      ]..sort((a, b) => b.balanceCents.compareTo(a.balanceCents)),
      settlements: [
        for (final s in core.settle(balances))
          SettlementInfo(
            fromUserId: UuidValue.fromString(s.from),
            toUserId: UuidValue.fromString(s.to),
            amountCents: s.amountCents,
          ),
      ],
    );
  }

  /// Records an expense paid by a member for some members, or a repayment
  /// ([SharedExpense.repayment], one participant other than the payer).
  Future<SharedExpense> add(
    Session session,
    int groupId,
    SharedExpense expense,
  ) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final members = await _memberIds(session, groupId);
    final participants = {for (final p in expense.participants) p.uuid};
    if (!members.contains(expense.paidBy.uuid) ||
        participants.isEmpty ||
        !members.containsAll(participants)) {
      throw InvalidInputException(code: 'shared_not_member');
    }
    if (expense.repayment &&
        (participants.length != 1 ||
            participants.first == expense.paidBy.uuid)) {
      throw InvalidInputException(code: 'shared_repayment_invalid');
    }
    final saved = await SharedExpense.db.insertRow(
      session,
      SharedExpense(
        groupId: groupId,
        label: PlanInputs.text(expense.label, field: 'label'),
        date: PlanInputs.day(expense.date),
        amountCents: PlanInputs.cents(expense.amountCents),
        paidBy: expense.paidBy,
        participants: [
          for (final p in participants.toList()..sort())
            UuidValue.fromString(p),
        ],
        repayment: expense.repayment,
        createdBy: Access.userId(session),
      ),
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'create',
      entity: 'shared_expense',
      rowId: saved.id,
      after: saved,
    );
    return saved;
  }

  Future<void> remove(Session session, int expenseId) async {
    final current = await SharedExpense.db.findById(session, expenseId);
    if (current == null) {
      throw AccessDeniedException(code: 'shared_access_denied');
    }
    await Access.requireMember(
      session,
      current.groupId,
      min: MemberRole.user,
    );
    await SharedExpense.db.deleteRow(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'delete',
      entity: 'shared_expense',
      rowId: expenseId,
      before: current,
    );
  }

  /// The common pot of each month split in proportion to the incomes the
  /// members declared (equally while none is known).
  Future<PotOverview> pot(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    final group = (await FinanceGroup.db.findById(session, groupId))!;
    final members = await GroupMember.db.find(
      session,
      where: (m) => m.groupId.equals(groupId),
      orderBy: (m) => m.createdAt,
    );
    final declared = {
      for (final s in await PotShare.db.find(
        session,
        where: (s) => s.groupId.equals(groupId),
      ))
        s.authUserId.uuid: s.incomeCents,
    };
    final incomes = {
      for (final m in members)
        m.authUserId.uuid: declared[m.authUserId.uuid] ?? 0,
    };
    final shares = core.prorata(group.potMonthlyCents, incomes);
    final emails = await _emails(session, groupId);
    return PotOverview(
      totalCents: group.potMonthlyCents,
      shares: [
        for (final m in members)
          PotShareInfo(
            userId: m.authUserId,
            email: emails[m.authUserId.uuid],
            incomeCents: incomes[m.authUserId.uuid] ?? 0,
            shareCents: shares[m.authUserId.uuid] ?? 0,
          ),
      ],
    );
  }

  /// The monthly pot (0 = none).
  Future<PotOverview> setPot(
    Session session,
    int groupId,
    int totalCents,
  ) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final group = (await FinanceGroup.db.findById(session, groupId))!;
    final updated = await FinanceGroup.db.updateRow(
      session,
      group.copyWith(
        potMonthlyCents: PlanInputs.cents(totalCents, allowZero: true),
      ),
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'update',
      entity: 'group',
      rowId: groupId,
      before: group,
      after: updated,
    );
    return pot(session, groupId);
  }

  /// The monthly income of a member, for their share of the pot.
  Future<PotOverview> setIncome(
    Session session,
    int groupId,
    UuidValue userId,
    int incomeCents,
  ) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    if (!(await _memberIds(session, groupId)).contains(userId.uuid)) {
      throw InvalidInputException(code: 'shared_not_member');
    }
    final cents = PlanInputs.cents(incomeCents, allowZero: true);
    final current = await PotShare.db.findFirstRow(
      session,
      where: (s) => s.groupId.equals(groupId) & s.authUserId.equals(userId),
    );
    final saved = current == null
        ? await PotShare.db.insertRow(
            session,
            PotShare(groupId: groupId, authUserId: userId, incomeCents: cents),
          )
        : await PotShare.db.updateRow(
            session,
            current.copyWith(incomeCents: cents),
          );
    await Audit.log(
      session,
      groupId: groupId,
      action: current == null ? 'create' : 'update',
      entity: 'pot_share',
      rowId: saved.id,
      before: current,
      after: saved,
    );
    return pot(session, groupId);
  }

  static Future<Set<String>> _memberIds(Session session, int groupId) async => {
    for (final m in await GroupMember.db.find(
      session,
      where: (m) => m.groupId.equals(groupId),
    ))
      m.authUserId.uuid,
  };

  /// Addresses of the members, by user id.
  static Future<Map<String, String?>> _emails(
    Session session,
    int groupId,
  ) async {
    final Set<UuidValue> ids = {
      for (final m in await GroupMember.db.find(
        session,
        where: (m) => m.groupId.equals(groupId),
      ))
        m.authUserId,
    };
    if (ids.isEmpty) return {};
    return {
      for (final p in await UserProfile.db.find(
        session,
        where: (p) => p.authUserId.inSet(ids),
      ))
        p.authUserId.uuid: p.email,
    };
  }
}
