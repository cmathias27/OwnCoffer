import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../core/portable_sql.dart';
import '../generated/protocol.dart';
import '../host/host_state.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/ip_guard.dart';
import '../security/scopes.dart';
import 'admin_endpoint.dart';
import 'pepite_endpoint.dart';

/// Pépite's advice on the app (decision 0028, point 12): « Bien démarrer »
/// and the « Le savais-tu ? » tips already seen. About the setup of the app,
/// never about money; everything is a count, never a list of operations.
class PepiteAdviceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// Tips kept per user (the catalogue of the app is much smaller).
  static const maxTips = 500;

  static final _tipCode = RegExp(r'^[a-z0-9_]{1,40}$');

  /// A successful backup older than this is not « set up » any more.
  static const backupAge = Duration(days: 2);

  /// The setup steps of [groupId] and of the user, and those of the server
  /// for its administrator. Only counts, on the accounts the user may see.
  Future<PepiteStart> start(Session session, int groupId) async {
    final member = await Access.requireMember(session, groupId);
    final user = member.authUserId;
    final standalone = session.onSqlite;
    final accounts = await Access.visibleAccountsOf(session, member);
    final Set<int> ids = {for (final a in accounts) a.id!};

    Future<bool> any(Future<int> count) async => await count > 0;
    final steps = <String>[];
    final done = <String>[];
    Future<void> step(String code, Future<bool> Function() isDone) async {
      steps.add(code);
      if (await isDone()) done.add(code);
    }

    await step(
      'account',
      () async =>
          ids.isNotEmpty &&
          await any(
            StatementImport.db.count(
              session,
              where: (i) => i.accountId.inSet(ids) & i.cancelledAt.equals(null),
            ),
          ),
    );
    await step(
      'rules',
      () => any(
        Rule.db.count(
          session,
          where: (r) => r.groupId.equals(groupId) & r.enabled.equals(true),
        ),
      ),
    );
    await step(
      'scheduled',
      () async =>
          ids.isNotEmpty &&
          await any(
            ScheduledTransaction.db.count(
              session,
              where: (s) => s.accountId.inSet(ids) & s.deletedAt.equals(null),
            ),
          ),
    );
    await step(
      'goal',
      () =>
          any(Goal.db.count(session, where: (g) => g.groupId.equals(groupId))),
    );
    // The standalone app has no password, hence no second factor.
    if (!standalone) {
      await step(
        'two_factor',
        () => any(
          TotpSecret.db.count(
            session,
            where: (s) => s.authUserId.equals(user) & s.enabled.equals(true),
          ),
        ),
      );
    }
    await step('app', () => PepiteEndpoint.usedAnApp(session, user));
    // Inviting is for the group's administrators, on a server.
    if (!standalone && member.role == MemberRole.admin) {
      await step(
        'members',
        () async =>
            await any(
              GroupMember.db.count(
                session,
                where: (m) =>
                    m.groupId.equals(groupId) & m.authUserId.notEquals(user),
              ),
            ) ||
            await any(
              Invitation.db.count(
                session,
                where: (i) =>
                    i.groupId.equals(groupId) & i.revokedAt.equals(null),
              ),
            ),
      );
    }

    final adminSteps = <String>[];
    final adminDone = <String>[];
    if (!standalone && await Onboarding.isServerAdmin(session, user)) {
      Future<void> admin(String code, Future<bool> Function() isDone) async {
        adminSteps.add(code);
        if (await isDone()) adminDone.add(code);
      }

      final host = HostState.instance;
      final backups = host.backups();
      final now = DateTime.now().toUtc();
      await admin(
        'backups',
        () async =>
            backups.lastOk == true &&
            backups.lastAt != null &&
            now.difference(backups.lastAt!) <= backupAge,
      );
      await admin('restore_test', () async => backups.restoreTest?.ok == true);
      await admin('auto_update', () async {
        final u = host.updates(AdminEndpoint.serverVersion());
        return u.available && u.auto;
      });
      await admin(
        'invitations',
        () async =>
            await any(Invitation.db.count(session)) ||
            await AuthUser.db.count(session) > 1,
      );
      await admin(
        'ai',
        () => any(
          AiProvider.db.count(session, where: (p) => p.enabled.equals(true)),
        ),
      );
      await admin('proxy', () async => IpGuard.instance.viaProxy(session));
    }
    return PepiteStart(
      steps: steps,
      done: done,
      adminSteps: adminSteps,
      adminDone: adminDone,
    );
  }

  /// The tips the user has seen, on any device.
  Future<PepiteTips> tips(Session session) async {
    final user = Access.userId(session);
    final seen = await PepiteTipSeen.db.find(
      session,
      where: (s) => s.authUserId.equals(user),
      orderByList: (s) => [s.seenAt.desc(), s.id.desc()],
      limit: maxTips,
    );
    return PepiteTips(
      seen: [for (final s in seen) s.code],
      lastSeenAt: seen.firstOrNull?.seenAt,
    );
  }

  /// « Compris » or « En savoir plus »: [code] is not shown again. Seen
  /// twice: nothing more.
  Future<PepiteTips> tipSeen(Session session, String code) async {
    final user = Access.userId(session);
    if (!_tipCode.hasMatch(code)) {
      throw InvalidInputException(code: 'invalid_tip', field: 'code');
    }
    await session.db.transaction((t) async {
      final known = await PepiteTipSeen.db.count(
        session,
        where: (s) => s.authUserId.equals(user) & s.code.equals(code),
        transaction: t,
      );
      final total = await PepiteTipSeen.db.count(
        session,
        where: (s) => s.authUserId.equals(user),
        transaction: t,
      );
      if (known > 0 || total >= maxTips) return;
      await PepiteTipSeen.db.insertRow(
        session,
        PepiteTipSeen(
          authUserId: user,
          code: code,
          seenAt: DateTime.now().toUtc(),
        ),
        transaction: t,
      );
    });
    return tips(session);
  }
}
