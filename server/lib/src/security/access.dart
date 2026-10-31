import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Server-side permission checks. Every endpoint touching group data goes
/// through these functions; nothing trusts ids or roles sent by the client.
///
/// Missing and forbidden resources raise the same [AccessDeniedException], so
/// a user cannot probe which ids exist in other groups.
abstract final class Access {
  static const _rank = {
    MemberRole.reader: 0,
    MemberRole.user: 1,
    MemberRole.admin: 2,
  };

  static bool roleAtLeast(MemberRole role, MemberRole min) =>
      _rank[role]! >= _rank[min]!;

  /// The authenticated user. Endpoints use `requireLogin`, so this only fails
  /// if one forgets it.
  static UuidValue userId(Session session) {
    final auth = session.authenticated;
    if (auth == null) throw AccessDeniedException(code: 'not_authenticated');
    return auth.authUserId;
  }

  /// Membership of the current user in [groupId], with at least [min].
  static Future<GroupMember> requireMember(
    Session session,
    int groupId, {
    MemberRole min = MemberRole.reader,
    Transaction? transaction,
  }) async {
    final user = userId(session);
    final member = await GroupMember.db.findFirstRow(
      session,
      where: (m) => m.groupId.equals(groupId) & m.authUserId.equals(user),
      transaction: transaction,
    );
    if (member == null || !roleAtLeast(member.role, min)) {
      throw AccessDeniedException(code: 'group_access_denied');
    }
    return member;
  }

  /// Whether [member] may see [account] (restricted accounts: admins and
  /// users listed in AccountAccess only).
  static Future<bool> canSeeAccount(
    Session session,
    Account account,
    GroupMember member, {
    Transaction? transaction,
  }) async {
    if (account.groupId != member.groupId || account.deletedAt != null) {
      return false;
    }
    if (account.visibility == AccountVisibility.shared ||
        member.role == MemberRole.admin) {
      return true;
    }
    final access = await AccountAccess.db.findFirstRow(
      session,
      where: (a) =>
          a.accountId.equals(account.id!) &
          a.authUserId.equals(member.authUserId),
      transaction: transaction,
    );
    return access != null;
  }

  /// The account, if the current user may see it ([write]: and change its
  /// operations, which needs at least the `user` role).
  static Future<Account> requireAccount(
    Session session,
    int accountId, {
    bool write = false,
    Transaction? transaction,
  }) async {
    final account = await Account.db.findById(
      session,
      accountId,
      transaction: transaction,
    );
    if (account == null || account.deletedAt != null) {
      throw AccessDeniedException(code: 'account_access_denied');
    }
    final GroupMember member;
    try {
      member = await requireMember(
        session,
        account.groupId,
        min: write ? MemberRole.user : MemberRole.reader,
        transaction: transaction,
      );
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'account_access_denied');
    }
    if (!await canSeeAccount(
      session,
      account,
      member,
      transaction: transaction,
    )) {
      throw AccessDeniedException(code: 'account_access_denied');
    }
    return account;
  }

  /// Accounts of [groupId] visible to the current user.
  static Future<List<Account>> visibleAccounts(
    Session session,
    int groupId,
  ) async {
    final member = await requireMember(session, groupId);
    return visibleAccountsOf(session, member);
  }

  /// Accounts [member] may see (jobs acting for a member, e.g. alerts).
  static Future<List<Account>> visibleAccountsOf(
    Session session,
    GroupMember member,
  ) async {
    final accounts = await Account.db.find(
      session,
      where: (a) => a.groupId.equals(member.groupId) & a.deletedAt.equals(null),
      orderBy: (a) => a.name,
    );
    if (member.role == MemberRole.admin) return accounts;
    final allowed = {
      for (final a in await AccountAccess.db.find(
        session,
        where: (a) => a.authUserId.equals(member.authUserId),
      ))
        a.accountId,
    };
    return [
      for (final a in accounts)
        if (a.visibility == AccountVisibility.shared || allowed.contains(a.id))
          a,
    ];
  }
}
