import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/ip_guard.dart';
import '../security/scopes.dart';
import '../security/session_devices.dart';

/// « Mes sessions » (decision 0027): the app says on what it runs; the
/// person sees where and since when each of their sessions is open, and
/// closes the ones they do not want. Only their own sessions.
class PresenceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  String? _current(Session session) => session.authenticated?.authId;

  /// At start and back in the foreground: [platform] (`web`, `android`,
  /// `windows`…) and the app's version.
  Future<void> ping(
    Session session,
    String platform,
    String? appVersion,
  ) async {
    final current = _current(session);
    if (current == null) return;
    await SessionDevices.seen(
      session,
      user: Access.userId(session),
      sessionId: current,
      platform: platform,
      appVersion: appVersion,
      ip: IpGuard.instance.clientIp(session),
    );
  }

  /// The open sessions of the signed-in person, this one first, with their
  /// whole IP.
  Future<List<SessionInfo>> mySessions(Session session) => SessionDevices.list(
    session,
    Access.userId(session),
    current: _current(session),
    masked: false,
  );

  /// Names one of their sessions (empty: no name).
  Future<void> rename(Session session, String sessionId, String? label) async {
    if (!await SessionDevices.rename(
      session,
      Access.userId(session),
      sessionId,
      label,
    )) {
      throw InvalidInputException(code: 'session_not_found');
    }
  }

  /// Closes one of their sessions (another device); this one is closed by
  /// signing out.
  Future<void> close(Session session, String sessionId) async {
    if (sessionId == _current(session)) {
      throw InvalidInputException(code: 'session_is_current');
    }
    final closed = await SessionDevices.close(
      session,
      Access.userId(session),
      only: sessionId,
    );
    if (closed.isEmpty) {
      throw InvalidInputException(code: 'session_not_found');
    }
    await Audit.log(
      session,
      groupId: null,
      action: 'close_own_session',
      entity: 'session',
      rowId: sessionId,
    );
  }

  /// Closes all their sessions but this one; returns how many.
  Future<int> closeOthers(Session session) async {
    final closed = await SessionDevices.close(
      session,
      Access.userId(session),
      keep: _current(session),
    );
    if (closed.isNotEmpty) {
      await Audit.log(
        session,
        groupId: null,
        action: 'close_other_sessions',
        entity: 'session',
        rowId: closed.length,
      );
    }
    return closed.length;
  }
}
