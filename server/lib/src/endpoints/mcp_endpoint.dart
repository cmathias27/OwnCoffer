import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../mcp/mcp_server.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// The user's MCP tokens (décision 0018): listed, created (the secret is
/// shown once), revoked.
class McpEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<List<McpToken>> tokens(Session session) async {
    final user = Access.userId(session);
    return McpToken.db.find(
      session,
      where: (t) => t.authUserId.equals(user),
      orderByList: (t) => [t.createdAt.desc()],
    );
  }

  Future<McpTokenCreated> create(Session session, int groupId, String name) =>
      McpServer.create(session, groupId, name);

  Future<void> revoke(Session session, int tokenId) async {
    final t = await McpToken.db.findById(session, tokenId);
    if (t == null || t.authUserId != Access.userId(session)) {
      throw AccessDeniedException(code: 'mcp_token_access_denied');
    }
    if (t.revokedAt != null) return;
    await McpToken.db.updateRow(
      session,
      t.copyWith(revokedAt: DateTime.now().toUtc()),
    );
    await Audit.log(
      session,
      groupId: t.groupId,
      action: 'revoke',
      entity: 'mcp_token',
      rowId: t.id,
    );
  }
}
