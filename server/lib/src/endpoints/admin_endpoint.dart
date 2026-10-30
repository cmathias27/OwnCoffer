import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/ip_guard.dart';

/// Server administration (server administrator only).
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

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
