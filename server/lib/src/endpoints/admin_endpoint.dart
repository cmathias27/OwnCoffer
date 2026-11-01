import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../finance/alert_service.dart';
import '../generated/protocol.dart';
import '../host/host_state.dart';
import '../mail/mail_service.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/ip_guard.dart';
import '../security/scopes.dart';

/// Server administration (server administrator only): accounts, health,
/// figures, audit log, banned IPs. Nothing here shows a group's financial
/// data: figures are counts, never amounts.
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Password-only sessions of users with two-factor authentication lack
  /// this scope until they type their code.
  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// When the server started: set by `run` at start-up. A static field
  /// alone would be initialised at its first read, the first time the
  /// page is opened, and the uptime would always look like zero.
  static DateTime startedAt = DateTime.now().toUtc();

  Future<void> _requireServerAdmin(Session session) async {
    if (!await Onboarding.isServerAdmin(session, Access.userId(session))) {
      throw AccessDeniedException(code: 'server_admin_only');
    }
  }

  /// Whether the signed-in user may open the administration page.
  Future<bool> isServerAdmin(Session session) =>
      Onboarding.isServerAdmin(session, Access.userId(session));

  Future<List<IpBanInfo>> bannedIps(Session session) async {
    await _requireServerAdmin(session);
    return IpGuard.instance.activeBans(session);
  }

  Future<void> unbanIp(Session session, String ip) async {
    await _requireServerAdmin(session);
    await IpGuard.instance.unban(session, ip);
    await _audit(session, 'unban_ip', 'ip_ban', ip);
  }

  /// Every account of the server, oldest first.
  Future<List<AdminUserInfo>> users(Session session) async {
    await _requireServerAdmin(session);
    final users = await AuthUser.db.find(session, orderBy: (u) => u.createdAt);
    final emails = {
      for (final p in await UserProfile.db.find(session)) p.authUserId: p.email,
    };
    final lastActive = <UuidValue, DateTime>{};
    for (final t in await RefreshToken.db.find(session)) {
      final at = t.lastUpdatedAt;
      final known = lastActive[t.authUserId];
      if (known == null || at.isAfter(known)) lastActive[t.authUserId] = at;
    }
    final twoFactor = {
      for (final t in await TotpSecret.db.find(
        session,
        where: (t) => t.enabled.equals(true),
      ))
        t.authUserId,
    };
    final groups = {
      for (final g in await FinanceGroup.db.find(session)) g.id!: g.name,
    };
    final memberships = <UuidValue, List<GroupMember>>{};
    for (final m in await GroupMember.db.find(
      session,
      orderBy: (m) => m.groupId,
    )) {
      memberships.putIfAbsent(m.authUserId, () => []).add(m);
    }
    return [
      for (final u in users)
        AdminUserInfo(
          authUserId: u.id!,
          email: emails[u.id],
          createdAt: u.createdAt,
          lastActiveAt: lastActive[u.id],
          twoFactor: twoFactor.contains(u.id),
          blocked: u.blocked,
          serverAdmin: u.scopeNames.contains(serverAdminScope),
          groupNames: [
            for (final m in memberships[u.id] ?? const <GroupMember>[])
              groups[m.groupId] ?? '?',
          ],
          roles: [
            for (final m in memberships[u.id] ?? const <GroupMember>[]) m.role,
          ],
        ),
    ];
  }

  /// Blocks (or unblocks) an account. A blocked account is signed out
  /// everywhere and cannot sign in. The administrator cannot block himself.
  Future<void> setBlocked(
    Session session,
    UuidValue authUserId,
    bool blocked,
  ) async {
    await _requireServerAdmin(session);
    if (authUserId == Access.userId(session)) {
      throw InvalidInputException(code: 'cannot_block_self');
    }
    final user = await AuthUser.db.findById(session, authUserId);
    if (user == null) {
      throw InvalidInputException(code: 'user_not_found');
    }
    await AuthUser.db.updateRow(session, user.copyWith(blocked: blocked));
    // Sessions are JWT only: without refresh tokens the account is signed
    // out when its access token expires (minutes), and a refresh is refused
    // for a blocked account anyway.
    if (blocked) {
      await RefreshToken.db.deleteWhere(
        session,
        where: (t) => t.authUserId.equals(authUserId),
      );
    }
    await _audit(
      session,
      blocked ? 'block_user' : 'unblock_user',
      'auth_user',
      '$authUserId',
    );
  }

  Future<AdminHealth> health(Session session) async {
    await _requireServerAdmin(session);
    var dbOk = true;
    int? dbBytes;
    try {
      final r = await session.db.unsafeQuery(
        'SELECT pg_database_size(current_database())',
      );
      dbBytes = r.first.first as int;
    } on Object {
      dbOk = false;
    }
    var documents = 0;
    if (dbOk) {
      for (final d in await LoanDocument.db.find(session)) {
        documents += d.sizeBytes;
      }
      for (final i in await Invoice.db.find(session)) {
        documents += i.sizeBytes;
      }
    }
    final disk = HostState.instance.disk();
    return AdminHealth(
      version: _version(),
      startedAt: startedAt,
      serverTime: DateTime.now().toUtc(),
      databaseOk: dbOk,
      databaseBytes: dbBytes,
      documentsBytes: documents,
      smtpConfigured: MailService.instance.isConfigured,
      publicUrl: Platform.environment['OWNCOFFER_PUBLIC_URL'] ?? '',
      alertsRunAt: AlertService.lastRunAt,
      alertsRunOk: AlertService.lastRunOk,
      diskTotalBytes: disk.total,
      diskFreeBytes: disk.free,
      diskAt: disk.at,
    );
  }

  Future<AdminStats> stats(Session session) async {
    await _requireServerAdmin(session);
    final now = DateTime.now().toUtc();
    final d30 = now.subtract(const Duration(days: 30));
    final d90 = now.subtract(const Duration(days: 90));
    Future<int> imported(Expression Function(BankTransactionTable) w) =>
        BankTransaction.db.count(
          session,
          where: (t) =>
              t.deletedAt.equals(null) &
              t.importId.notEquals(null) &
              (t.createdAt >= d90) &
              w(t),
        );
    final users = await AuthUser.db.find(session);
    return AdminStats(
      users: users.length,
      blockedUsers: users.where((u) => u.blocked).length,
      twoFactorUsers: await TotpSecret.db.count(
        session,
        where: (t) => t.enabled.equals(true),
      ),
      groups: await FinanceGroup.db.count(session),
      accounts: await Account.db.count(
        session,
        where: (a) => a.deletedAt.equals(null),
      ),
      operations: await BankTransaction.db.count(
        session,
        where: (t) => t.deletedAt.equals(null),
      ),
      operationsLast30Days: await BankTransaction.db.count(
        session,
        where: (t) => t.deletedAt.equals(null) & (t.createdAt >= d30),
      ),
      importsLast30Days: await StatementImport.db.count(
        session,
        where: (i) => i.createdAt >= d30,
      ),
      rules: await Rule.db.count(session),
      pendingInvitations: await Invitation.db.count(
        session,
        where: (i) =>
            i.acceptedAt.equals(null) &
            i.revokedAt.equals(null) &
            (i.expiresAt > now),
      ),
      classifiedAutomatically: await imported(
        (t) => t.categorySource.inSet({
          CategorySource.groupRule,
          CategorySource.communityRule,
          CategorySource.history,
          CategorySource.ai,
        }),
      ),
      classifiedManually: await imported(
        (t) => t.categorySource.equals(CategorySource.manual),
      ),
      unclassified: await imported((t) => t.categoryId.equals(null)),
    );
  }

  /// The audit log, newest first: who did what and when, without the data.
  Future<List<AdminAuditInfo>> audit(
    Session session, {
    int? limit,
    int? offset,
  }) async {
    await _requireServerAdmin(session);
    final rows = await AuditEntry.db.find(
      session,
      orderByList: (a) => [a.createdAt.desc(), a.id.desc()],
      limit: (limit ?? 100).clamp(1, 500),
      offset: (offset ?? 0).clamp(0, 1 << 30),
    );
    final emails = {
      for (final p in await UserProfile.db.find(session)) p.authUserId: p.email,
    };
    return [
      for (final a in rows)
        AdminAuditInfo(
          createdAt: a.createdAt,
          action: a.action,
          entity: a.entity,
          email: emails[a.authUserId],
          groupId: a.groupId,
        ),
    ];
  }

  /// Groups of the server, by name, with their size.
  Future<List<AdminGroupInfo>> groups(Session session) async {
    await _requireServerAdmin(session);
    final members = <int, int>{};
    for (final m in await GroupMember.db.find(session)) {
      members[m.groupId] = (members[m.groupId] ?? 0) + 1;
    }
    final accounts = <int, int>{};
    for (final a in await Account.db.find(
      session,
      where: (a) => a.deletedAt.equals(null),
    )) {
      accounts[a.groupId] = (accounts[a.groupId] ?? 0) + 1;
    }
    return [
      for (final g in await FinanceGroup.db.find(
        session,
        orderBy: (g) => g.name,
      ))
        AdminGroupInfo(
          id: g.id!,
          name: g.name,
          members: members[g.id] ?? 0,
          accounts: accounts[g.id] ?? 0,
        ),
    ];
  }

  /// Pending invitations of every group, oldest first.
  Future<List<AdminInvitationInfo>> invitations(Session session) async {
    await _requireServerAdmin(session);
    final groups = {
      for (final g in await FinanceGroup.db.find(session)) g.id!: g.name,
    };
    final emails = {
      for (final p in await UserProfile.db.find(session)) p.authUserId: p.email,
    };
    return [
      for (final i in await Invitation.db.find(
        session,
        where: (i) =>
            i.acceptedAt.equals(null) &
            i.revokedAt.equals(null) &
            (i.expiresAt > DateTime.now().toUtc()),
        orderBy: (i) => i.createdAt,
      ))
        AdminInvitationInfo(
          id: i.id!,
          groupId: i.groupId,
          groupName: groups[i.groupId],
          email: i.email,
          role: i.role,
          serverAdmin: i.serverAdmin,
          createdAt: i.createdAt,
          expiresAt: i.expiresAt,
          invitedBy: emails[i.createdBy],
        ),
    ];
  }

  /// Invites [email] into any group of the server (the link is emailed).
  Future<AdminInvitationInfo> invite(
    Session session,
    int groupId,
    String email,
    MemberRole role,
  ) async {
    await _requireServerAdmin(session);
    final group = await FinanceGroup.db.findById(session, groupId);
    if (group == null) {
      throw AccessDeniedException(code: 'group_access_denied');
    }
    final i = await Onboarding.invite(
      session,
      groupId: groupId,
      email: email,
      role: role,
      invitedBy: Access.userId(session),
      publicUrl:
          Platform.environment['OWNCOFFER_PUBLIC_URL'] ??
          'http://localhost:8080',
    );
    await AuditEntry.db.insertRow(
      session,
      AuditEntry(
        groupId: groupId,
        authUserId: Access.userId(session),
        action: 'invite',
        entity: 'invitation',
        rowId: '${i.id}',
      ),
    );
    return AdminInvitationInfo(
      id: i.id!,
      groupId: groupId,
      groupName: group.name,
      email: i.email,
      role: i.role,
      serverAdmin: i.serverAdmin,
      createdAt: i.createdAt,
      expiresAt: i.expiresAt,
      invitedBy: null,
    );
  }

  /// Revokes a pending invitation of any group: its link stops working.
  Future<void> revokeInvitation(Session session, int invitationId) async {
    await _requireServerAdmin(session);
    final i = await Invitation.db.findById(session, invitationId);
    if (i == null || i.acceptedAt != null || i.revokedAt != null) {
      throw InvalidInputException(code: 'invitation_not_pending');
    }
    await Invitation.db.updateRow(
      session,
      i.copyWith(revokedAt: DateTime.now().toUtc()),
    );
    await AuditEntry.db.insertRow(
      session,
      AuditEntry(
        groupId: i.groupId,
        authUserId: Access.userId(session),
        action: 'revoke',
        entity: 'invitation',
        rowId: '$invitationId',
      ),
    );
  }

  /// Backups kept on the host, as reported by its scripts.
  Future<BackupOverview> backups(Session session) async {
    await _requireServerAdmin(session);
    return HostState.instance.backups();
  }

  /// Asks the host for a backup now (carried out within seconds by
  /// docker/handle-requests.sh; at most one every 10 minutes).
  Future<void> requestBackup(Session session) async {
    await _requireServerAdmin(session);
    _request('backup');
    await _audit(session, 'request_backup', 'host', 'backup');
  }

  /// Versions, automatic updates, history and release notes.
  Future<UpdateOverview> updates(Session session) async {
    await _requireServerAdmin(session);
    return HostState.instance.updates(_version());
  }

  /// Turns automatic updates on or off (read by the host at each run).
  Future<void> setAutoUpdate(Session session, bool on) async {
    await _requireServerAdmin(session);
    try {
      HostState.instance.setAutoUpdate(on);
    } on FileSystemException {
      throw InvalidInputException(code: 'host_bridge_missing');
    }
    await _audit(
      session,
      on ? 'auto_update_on' : 'auto_update_off',
      'host',
      '',
    );
  }

  /// Asks the host to look for a new version now.
  Future<void> requestUpdateCheck(Session session) async {
    await _requireServerAdmin(session);
    _request('check');
    await _audit(session, 'request_update_check', 'host', '');
  }

  /// Asks the host to install [version] (a published vX.Y.Z newer than the
  /// installed one; the host checks it again, backs up first and rolls back
  /// if the new version does not start).
  Future<void> requestInstall(Session session, String version) async {
    await _requireServerAdmin(session);
    final o = HostState.instance.updates(_version());
    if (!RegExp(r'^v\d+\.\d+\.\d+$').hasMatch(version) ||
        o.current == null ||
        !_newer(version, o.current!)) {
      throw InvalidInputException(code: 'invalid_version', field: 'version');
    }
    _request('update', content: version);
    await _audit(session, 'request_install', 'host', version);
  }

  static void _request(String name, {String? content}) {
    try {
      HostState.instance.request(name, content: content);
    } on FileSystemException {
      throw InvalidInputException(code: 'host_bridge_missing');
    }
  }

  /// Whether vA.B.C [a] comes after [b].
  static bool _newer(String a, String b) {
    List<int> parts(String v) =>
        v.substring(1).split('.').map(int.parse).toList();
    final x = parts(a), y = parts(b);
    for (var i = 0; i < 3; i++) {
      if (x[i] != y[i]) return x[i] > y[i];
    }
    return false;
  }

  /// Sends a test email to the administrator; returns the address. Without
  /// SMTP configuration it is written to the server log.
  Future<String> sendTestEmail(Session session) async {
    await _requireServerAdmin(session);
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(Access.userId(session)),
    );
    final to = profile?.email;
    if (to == null) throw InvalidInputException(code: 'invalid_email');
    try {
      await MailService.instance.send(
        session,
        to: to,
        subject: 'OwnCoffer : courriel de test / test email',
        body:
            "Ce courriel confirme que l'envoi fonctionne.\n\n"
            'This email confirms that sending works.',
      );
    } on Object {
      throw InvalidInputException(code: 'mail_failed');
    }
    return to;
  }

  /// Version of the web app bundled in the image (Flutter's version.json).
  static String _version() {
    try {
      final f = File('web/app/version.json');
      if (!f.existsSync()) return 'dev';
      final v = (jsonDecode(f.readAsStringSync()) as Map)['version'];
      return v is String && v.isNotEmpty ? v : 'dev';
    } on Object {
      return 'dev';
    }
  }

  static Future<void> _audit(
    Session session,
    String action,
    String entity,
    String rowId,
  ) => AuditEntry.db.insertRow(
    session,
    AuditEntry(
      authUserId: Access.userId(session),
      action: action,
      entity: entity,
      rowId: rowId,
    ),
  );
}
