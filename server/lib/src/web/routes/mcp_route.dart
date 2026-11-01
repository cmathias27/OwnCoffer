import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../mcp/mcp_server.dart';

/// POST /mcp: the MCP endpoint (JSON-RPC 2.0, one JSON answer per request,
/// "Streamable HTTP" without streaming). Never cached.
class McpRoute extends Route {
  McpRoute() : super(methods: {Method.post, Method.get, Method.delete});

  static const _maxBody = 512 * 1024;

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final headers = Headers.build((h) {
      h['Cache-Control'] = ['no-store'];
    });
    if (request.method != Method.post) {
      // No server-to-client stream and no session to end.
      return Response(405, headers: headers);
    }
    Object? message;
    try {
      final text = await request.readAsString(maxLength: _maxBody);
      message = jsonDecode(text);
    } on Object {
      return Response.badRequest(headers: headers);
    }
    final r = await McpServer.handle(
      session,
      request.headers['authorization']?.firstOrNull,
      message,
    );
    if (r.body == null) return Response(r.status, headers: headers);
    return Response(
      r.status,
      headers: headers,
      body: Body.fromString(jsonEncode(r.body), mimeType: MimeType.json),
    );
  }
}
