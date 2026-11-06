import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Refuses the calls of a closed session (decision 0027): a JWT access token
/// stays valid until it expires, even once its session (refresh token) is
/// deleted. Every authenticated call checks that the session still exists;
/// the answer is kept [ttl] so that this costs at most one query per session
/// every 30 seconds. [forget] drops the kept answers when this server closes
/// a session itself, so it is refused at once.
class SessionGuard {
  static const ttl = Duration(seconds: 30);

  /// Above this many kept answers, they are all dropped (memory bound).
  static const _maxKept = 10000;

  /// Whether the session [id] is still open; Serverpod's refresh tokens by
  /// default, replaced in tests.
  final Future<bool> Function(Session session, UuidValue id) isOpen;
  final DateTime Function() _now;

  SessionGuard({
    Future<bool> Function(Session session, UuidValue id)? isOpen,
    DateTime Function()? now,
  }) : isOpen = isOpen ?? _refreshTokenExists,
       _now = now ?? (() => DateTime.now().toUtc());

  static SessionGuard instance = SessionGuard();

  final _checkedUntil = <String, DateTime>{};

  static Future<bool> _refreshTokenExists(
    Session session,
    UuidValue id,
  ) async => await RefreshToken.db.findById(session, id) != null;

  /// [inner] (Serverpod's own check of the token), then this one.
  AuthenticationHandler wrap(AuthenticationHandler inner) =>
      (Session session, String token) async {
        final info = await inner(session, token);
        if (info == null) return null;
        return await allows(session, info.authId) ? info : null;
      };

  /// Whether the session [authId] may still call. Ids that are not
  /// sessions of refresh tokens (none today) are left to their own check.
  Future<bool> allows(Session session, String authId) async {
    final UuidValue uuid;
    try {
      uuid = UuidValue.withValidation(authId);
    } on Object {
      return true;
    }
    final now = _now();
    final until = _checkedUntil[authId];
    if (until != null && until.isAfter(now)) return true;
    if (!await isOpen(session, uuid)) {
      _checkedUntil.remove(authId);
      return false;
    }
    if (_checkedUntil.length >= _maxKept) _checkedUntil.clear();
    _checkedUntil[authId] = now.add(ttl);
    return true;
  }

  /// A session was closed here: check every session again at its next call.
  void forget() => _checkedUntil.clear();
}
