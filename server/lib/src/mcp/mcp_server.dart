import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../ai/ai_context.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// OwnCoffer as an MCP server (Model Context Protocol, JSON-RPC 2.0 over
/// HTTP, décision 0018): an assistant chosen by the user calls the same
/// functions as the built-in one — read-only views of the accounts the
/// user may see, and proposals the user accepts in "Mon conseiller".
abstract final class McpServer {
  static const protocolVersion = '2025-06-18';
  static const _prefix = 'ocmcp_';

  static String hash(String secret) =>
      sha256.convert(utf8.encode(secret)).toString();

  /// A new random secret (shown once).
  static String newSecret() {
    final r = Random.secure();
    final bytes = List.generate(32, (_) => r.nextInt(256));
    return '$_prefix${base64Url.encode(bytes).replaceAll('=', '')}';
  }

  /// The token of [authorization] ("Bearer …"), still valid, its user still
  /// a member of its group and not blocked; null otherwise.
  static Future<McpToken?> _token(
    Session session,
    String? authorization,
  ) async {
    if (authorization == null || !authorization.startsWith('Bearer ')) {
      return null;
    }
    final secret = authorization.substring(7).trim();
    if (!secret.startsWith(_prefix) || secret.length > 100) return null;
    final t = await McpToken.db.findFirstRow(
      session,
      where: (t) => t.tokenHash.equals(hash(secret)),
    );
    if (t == null || t.revokedAt != null) return null;
    final user = await AuthUser.db.findById(session, t.authUserId);
    if (user == null || user.blocked) return null;
    final member = await GroupMember.db.findFirstRow(
      session,
      where: (m) =>
          m.groupId.equals(t.groupId) & m.authUserId.equals(t.authUserId),
    );
    return member == null ? null : t;
  }

  static Map<String, Object?> _error(Object? id, int code, String message) => {
    'jsonrpc': '2.0',
    'id': id,
    'error': {'code': code, 'message': message},
  };

  static Map<String, Object?> _result(Object? id, Object? result) => {
    'jsonrpc': '2.0',
    'id': id,
    'result': result,
  };

  /// Handles one JSON-RPC message; null for a notification (no answer).
  /// [status] is set to 401 when the token is missing or invalid.
  static Future<({int status, Map<String, Object?>? body})> handle(
    Session session,
    String? authorization,
    Object? message,
  ) async {
    final token = await _token(session, authorization);
    if (token == null) {
      return (
        status: 401,
        body: _error(null, -32001, 'A valid OwnCoffer MCP token is needed.'),
      );
    }
    if (message is! Map<String, Object?> || message['jsonrpc'] != '2.0') {
      return (status: 400, body: _error(null, -32600, 'Invalid request'));
    }
    final id = message['id'];
    final method = message['method'];
    // From here on, the session acts as the token's user.
    session.updateAuthenticated(
      AuthenticationInfo(
        token.authUserId.toString(),
        {accessScope},
        authId: 'mcp:${token.id}',
      ),
    );
    await McpToken.db.updateRow(
      session,
      token.copyWith(lastUsedAt: DateTime.now().toUtc()),
    );
    if (id == null) return (status: 202, body: null);
    switch (method) {
      case 'initialize':
        return (
          status: 200,
          body: _result(id, {
            'protocolVersion': protocolVersion,
            'capabilities': {
              'tools': {'listChanged': false},
            },
            'serverInfo': {'name': 'OwnCoffer', 'version': '1'},
            'instructions':
                'Personal finance data of one household, read-only. Every '
                'figure comes from these tools (amounts in cents); never '
                'compute or invent one. Changes are only proposed '
                '(propose_*): the user accepts them in OwnCoffer.',
          }),
        );
      case 'ping':
        return (status: 200, body: _result(id, {}));
      case 'tools/list':
        return (
          status: 200,
          body: _result(id, {
            'tools': [
              for (final t in AiContext.tools)
                {
                  'name': (t['function'] as Map)['name'],
                  'description': (t['function'] as Map)['description'],
                  'inputSchema': (t['function'] as Map)['parameters'],
                },
            ],
          }),
        );
      case 'tools/call':
        final params = message['params'];
        final name = params is Map ? params['name'] : null;
        final args = params is Map ? params['arguments'] : null;
        if (name is! String || !AiContext.names.contains(name)) {
          return (status: 200, body: _error(id, -32602, 'Unknown tool'));
        }
        await Audit.log(
          session,
          groupId: token.groupId,
          action: 'mcp_call',
          entity: 'mcp',
          rowId: token.id,
        );
        final context = AiContext(
          session,
          token.groupId,
          origin: 'mcp',
          provider: 'MCP',
          model: token.name,
        );
        final text = await context.call(
          name,
          args is Map<String, Object?> ? args : const {},
        );
        return (
          status: 200,
          body: _result(id, {
            'content': [
              {'type': 'text', 'text': text},
            ],
            'isError': text.startsWith('{"error"'),
          }),
        );
      default:
        return (status: 200, body: _error(id, -32601, 'Method not found'));
    }
  }

  /// Creates a token for the signed-in user and [groupId].
  static Future<McpTokenCreated> create(
    Session session,
    int groupId,
    String name,
  ) async {
    await Access.requireMember(session, groupId);
    final clean = name.trim();
    if (clean.isEmpty || clean.length > 60) {
      throw InvalidInputException(code: 'invalid_name', field: 'name');
    }
    final user = Access.userId(session);
    final open = await McpToken.db.count(
      session,
      where: (t) => t.authUserId.equals(user) & t.revokedAt.equals(null),
    );
    if (open >= 10) throw InvalidInputException(code: 'too_many');
    final secret = newSecret();
    final row = await McpToken.db.insertRow(
      session,
      McpToken(
        authUserId: user,
        groupId: groupId,
        name: clean,
        tokenHash: hash(secret),
        prefix: secret.substring(0, 12),
      ),
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'create',
      entity: 'mcp_token',
      rowId: row.id,
    );
    return McpTokenCreated(
      token: row.copyWith(tokenHash: null),
      secret: secret,
    );
  }
}
