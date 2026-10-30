import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/audit.dart';

/// Groups of the current user and their members.
class GroupEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<GroupMembership>> myGroups(Session session) async {
    final user = Access.userId(session);
    final memberships = await GroupMember.db.find(
      session,
      where: (m) => m.authUserId.equals(user),
    );
    if (memberships.isEmpty) return [];
    final Set<int> ids = {for (final m in memberships) m.groupId};
    final groups = await FinanceGroup.db.find(
      session,
      where: (g) => g.id.inSet(ids),
      orderBy: (g) => g.name,
    );
    final roleOf = {for (final m in memberships) m.groupId: m.role};
    return [
      for (final g in groups) GroupMembership(group: g, role: roleOf[g.id]!),
    ];
  }

  /// Creates a group whose administrator is the current user. Only the
  /// server administrator creates groups; others join by invitation.
  Future<GroupMembership> create(Session session, String name) async {
    final user = Access.userId(session);
    if (!await Onboarding.isServerAdmin(session, user)) {
      throw AccessDeniedException(code: 'server_admin_only');
    }
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 80) {
      throw InvalidInputException(code: 'invalid_name', field: 'name');
    }
    return session.db.transaction((tx) async {
      final group = await FinanceGroup.db.insertRow(
        session,
        FinanceGroup(name: trimmed, createdBy: user),
        transaction: tx,
      );
      await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: group.id!,
          authUserId: user,
          role: MemberRole.admin,
        ),
        transaction: tx,
      );
      await Audit.log(
        session,
        groupId: group.id,
        action: 'create',
        entity: 'group',
        rowId: group.id,
        after: group,
        transaction: tx,
      );
      return GroupMembership(group: group, role: MemberRole.admin);
    });
  }

  Future<FinanceGroup> rename(Session session, int groupId, String name) async {
    await Access.requireMember(session, groupId, min: MemberRole.admin);
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 80) {
      throw InvalidInputException(code: 'invalid_name', field: 'name');
    }
    final group = (await FinanceGroup.db.findById(session, groupId))!;
    final updated = await FinanceGroup.db.updateRow(
      session,
      group.copyWith(name: trimmed),
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
    return updated;
  }

  /// Members of the group (any member may see who else is in it).
  Future<List<GroupMember>> members(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    return GroupMember.db.find(
      session,
      where: (m) => m.groupId.equals(groupId),
      orderBy: (m) => m.createdAt,
    );
  }

  /// Changes a member's role. The group always keeps at least one admin.
  Future<GroupMember> setRole(
    Session session,
    int groupId,
    UuidValue memberUserId,
    MemberRole role,
  ) async {
    return session.db.transaction((tx) async {
      await Access.requireMember(
        session,
        groupId,
        min: MemberRole.admin,
        transaction: tx,
      );
      final member = await _member(session, groupId, memberUserId, tx);
      if (member.role == MemberRole.admin && role != MemberRole.admin) {
        await _ensureAnotherAdmin(session, groupId, tx);
      }
      final updated = await GroupMember.db.updateRow(
        session,
        member.copyWith(role: role),
        transaction: tx,
      );
      await Audit.log(
        session,
        groupId: groupId,
        action: 'set_role',
        entity: 'group_member',
        rowId: member.id,
        before: member,
        after: updated,
        transaction: tx,
      );
      return updated;
    });
  }

  /// Removes a member (admins), or leaves the group (any member, oneself).
  Future<void> removeMember(
    Session session,
    int groupId,
    UuidValue memberUserId,
  ) async {
    await session.db.transaction((tx) async {
      final self = Access.userId(session) == memberUserId;
      await Access.requireMember(
        session,
        groupId,
        min: self ? MemberRole.reader : MemberRole.admin,
        transaction: tx,
      );
      final member = await _member(session, groupId, memberUserId, tx);
      if (member.role == MemberRole.admin) {
        await _ensureAnotherAdmin(session, groupId, tx);
      }
      final groupAccountIds = (await Account.db.find(
        session,
        where: (x) => x.groupId.equals(groupId),
        transaction: tx,
      )).map((x) => x.id!).toSet();
      if (groupAccountIds.isNotEmpty) {
        await AccountAccess.db.deleteWhere(
          session,
          where: (a) =>
              a.authUserId.equals(memberUserId) &
              a.accountId.inSet(groupAccountIds),
          transaction: tx,
        );
      }
      await GroupMember.db.deleteRow(session, member, transaction: tx);
      await Audit.log(
        session,
        groupId: groupId,
        action: 'remove_member',
        entity: 'group_member',
        rowId: member.id,
        before: member,
        transaction: tx,
      );
    });
  }

  Future<GroupMember> _member(
    Session session,
    int groupId,
    UuidValue userId,
    Transaction tx,
  ) async {
    final member = await GroupMember.db.findFirstRow(
      session,
      where: (m) => m.groupId.equals(groupId) & m.authUserId.equals(userId),
      transaction: tx,
    );
    if (member == null) {
      throw AccessDeniedException(code: 'group_access_denied');
    }
    return member;
  }

  Future<void> _ensureAnotherAdmin(
    Session session,
    int groupId,
    Transaction tx,
  ) async {
    final admins = await GroupMember.db.count(
      session,
      where: (m) => m.groupId.equals(groupId) & m.role.equals(MemberRole.admin),
      transaction: tx,
    );
    if (admins < 2) {
      throw InvalidInputException(code: 'last_admin');
    }
  }
}
