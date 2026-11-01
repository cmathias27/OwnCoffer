import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../export/import_service.dart';
import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/scopes.dart';

/// Import of an export into a new group (decision 0022): moving from the
/// standalone app to a server, back, or between servers. Only the server
/// administrator, who alone creates groups; the export is sent in parts
/// (an export of 100 000 operations is about 40 MB).
class TransferEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// 2 MB of text per part, well under the request limit.
  static const maxPart = 2 * 1024 * 1024;

  /// 300 MB in all.
  static const maxTotal = 300 * 1024 * 1024;

  static final _uploads = <String, _Upload>{};

  static Future<UuidValue> _admin(Session session) async {
    final user = Access.userId(session);
    if (!await Onboarding.isServerAdmin(session, user)) {
      throw AccessDeniedException(code: 'server_admin_only');
    }
    return user;
  }

  /// Starts an upload; returns its token.
  Future<String> begin(Session session) async {
    final user = await _admin(session);
    final now = DateTime.now();
    _uploads.removeWhere(
      (_, u) => now.difference(u.startedAt) > const Duration(hours: 1),
    );
    final random = Random.secure();
    final token = List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    _uploads[token] = _Upload(user, now);
    return token;
  }

  /// One part of the export, in order.
  Future<void> part(Session session, String token, String text) async {
    final upload = _find(token, await _admin(session));
    if (text.length > maxPart || upload.length + text.length > maxTotal) {
      _uploads.remove(token);
      throw InvalidInputException(code: 'import_too_big');
    }
    upload.parts.add(text);
    upload.length += text.length;
  }

  /// Creates the group from the parts sent. [name]: another name for it.
  Future<ImportResult> finish(
    Session session,
    String token,
    String? name,
  ) async {
    final user = await _admin(session);
    final upload = _find(token, user);
    _uploads.remove(token);
    return ImportService.importGroup(
      session,
      upload.parts.join(),
      user,
      name: name,
    );
  }

  /// The file of one imported document ([ImportResult.documents]).
  Future<void> document(
    Session session,
    int groupId,
    String kind,
    int id,
    ByteData content,
  ) async {
    await _admin(session);
    await Access.requireMember(session, groupId, min: MemberRole.admin);
    await ImportService.importDocument(session, groupId, kind, id, content);
  }

  static _Upload _find(String token, UuidValue user) {
    final upload = _uploads[token];
    if (upload == null || upload.user != user) {
      throw InvalidInputException(code: 'import_unknown_upload');
    }
    return upload;
  }
}

class _Upload {
  final UuidValue user;
  final DateTime startedAt;
  final parts = <String>[];
  int length = 0;

  _Upload(this.user, this.startedAt);
}
