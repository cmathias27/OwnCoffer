import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/scopes.dart';
import '../security/audit.dart';
import '../security/ip_guard.dart';

/// Invitations to join a group (group admins), and acceptance by users who
/// already have an account.
class InvitationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Password-only sessions of users with two-factor authentication lack
  /// this scope until they type their code.
  @override
  Set<Scope> get requiredScopes => {accessScope};

  static String get _publicUrl =>
      Platform.environment['OWNCOFFER_PUBLIC_URL'] ?? 'http://localhost:8080';

  Future<InvitationInfo> create(
    Session session,
    int groupId,
    String email,
    MemberRole role,
  ) async {
    await Access.requireMember(session, groupId, min: MemberRole.admin);
    final invitation = await Onboarding.invite(
      session,
      groupId: groupId,
      email: email,
      role: role,
      invitedBy: Access.userId(session),
      publicUrl: _publicUrl,
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'invite',
      entity: 'invitation',
      rowId: invitation.id,
    );
    return _info(invitation);
  }

  /// Pending invitations of the group.
  Future<List<InvitationInfo>> list(Session session, int groupId) async {
    await Access.requireMember(session, groupId, min: MemberRole.admin);
    final rows = await Invitation.db.find(
      session,
      where: (i) =>
          i.groupId.equals(groupId) &
          i.acceptedAt.equals(null) &
          i.revokedAt.equals(null) &
          (i.expiresAt > DateTime.now().toUtc()),
      orderBy: (i) => i.createdAt,
    );
    return rows.map(_info).toList();
  }

  Future<void> revoke(Session session, int invitationId) async {
    final invitation = await Invitation.db.findById(session, invitationId);
    if (invitation == null || invitation.groupId == null) {
      throw AccessDeniedException(code: 'group_access_denied');
    }
    await Access.requireMember(
      session,
      invitation.groupId!,
      min: MemberRole.admin,
    );
    await Invitation.db.updateRow(
      session,
      invitation.copyWith(revokedAt: DateTime.now().toUtc()),
    );
    await Audit.log(
      session,
      groupId: invitation.groupId,
      action: 'revoke',
      entity: 'invitation',
      rowId: invitationId,
    );
  }

  /// Accepts an invitation link while signed in. The invitation must have
  /// been sent to the email of the signed-in account.
  Future<GroupMembership> accept(Session session, String token) async {
    final userId = Access.userId(session);
    final invitation = await Invitation.db.findFirstRow(
      session,
      where: (i) => i.tokenHash.equals(Onboarding.hashToken(token.trim())),
    );
    final now = DateTime.now().toUtc();
    if (invitation == null ||
        invitation.groupId == null ||
        invitation.acceptedAt != null ||
        invitation.revokedAt != null ||
        invitation.expiresAt.isBefore(now)) {
      await IpGuard.instance.recordFailure(session, 'invitation');
      throw InvalidInputException(code: 'invitation_invalid');
    }
    final emails = await _emailsOf(session, userId);
    if (!emails.contains(invitation.email)) {
      throw InvalidInputException(code: 'invitation_other_email');
    }
    await session.db.transaction(
      (tx) => Onboarding.applyInvitations(
        session,
        email: invitation.email,
        userId: userId,
        transaction: tx,
        onlyInvitationId: invitation.id,
      ),
    );
    final group = (await FinanceGroup.db.findById(
      session,
      invitation.groupId!,
    ))!;
    final member = await Access.requireMember(session, group.id!);
    return GroupMembership(group: group, role: member.role);
  }

  static Future<Set<String>> _emailsOf(
    Session session,
    UuidValue userId,
  ) async {
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(userId),
    );
    return {
      if (profile?.email != null) Onboarding.normalizeEmail(profile!.email!),
    };
  }

  static InvitationInfo _info(Invitation i) => InvitationInfo(
    id: i.id!,
    groupId: i.groupId!,
    email: i.email,
    role: i.role,
    expiresAt: i.expiresAt,
    createdAt: i.createdAt,
  );
}
