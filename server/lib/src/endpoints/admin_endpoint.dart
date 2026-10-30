import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/scopes.dart';
import '../security/ip_guard.dart';

/// Server administration (server administrator only).
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Password-only sessions of users with two-factor authentication lack
  /// this scope until they type their code.
  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<void> _requireServerAdmin(Session session) async {
    if (!await Onboarding.isServerAdmin(session, Access.userId(session))) {
      throw AccessDeniedException(code: 'server_admin_only');
    }
  }

  Future<List<IpBanInfo>> bannedIps(Session session) async {
    await _requireServerAdmin(session);
    return IpGuard.instance.activeBans(session);
  }

  Future<void> unbanIp(Session session, String ip) async {
    await _requireServerAdmin(session);
    await IpGuard.instance.unban(session, ip);
    await AuditEntry.db.insertRow(
      session,
      AuditEntry(
        authUserId: Access.userId(session),
        action: 'unban_ip',
        entity: 'ip_ban',
        rowId: ip,
      ),
    );
  }
}
