import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../finance/alert_service.dart';
import '../generated/protocol.dart';
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

  static final _startedAt = DateTime.now().toUtc();

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
    }
    return AdminHealth(
      version: _version(),
      startedAt: _startedAt,
      serverTime: DateTime.now().toUtc(),
      databaseOk: dbOk,
      databaseBytes: dbBytes,
      documentsBytes: documents,
      smtpConfigured: MailService.instance.isConfigured,
      publicUrl: Platform.environment['OWNCOFFER_PUBLIC_URL'] ?? '',
      alertsRunAt: AlertService.lastRunAt,
      alertsRunOk: AlertService.lastRunOk,
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
