import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'admin_endpoint.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/scopes.dart';

/// Remarks sent from the app to the server administrator. They stay on the
/// server: nothing goes to the project or anywhere else.
class FeedbackEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  static const _kinds = {'bug', 'idea', 'question'};
  static const _perDay = 20;

  Future<UserFeedback> send(
    Session session,
    String kind,
    String text,
    String? page,
    String? appVersion,
  ) async {
    final user = Access.userId(session);
    final clean = text.trim();
    if (!_kinds.contains(kind)) {
      throw InvalidInputException(code: 'invalid_name', field: 'kind');
    }
    if (clean.isEmpty || clean.length > 2000) {
      throw InvalidInputException(code: 'invalid_name', field: 'text');
    }
    final since = DateTime.now().toUtc().subtract(const Duration(days: 1));
    final today = await UserFeedback.db.count(
      session,
      where: (f) => f.authUserId.equals(user) & (f.createdAt > since),
    );
    if (today >= _perDay) {
      throw InvalidInputException(code: 'feedback_too_many');
    }
    String? short(String? v, int max) {
      final s = v?.trim();
      if (s == null || s.isEmpty) return null;
      return s.length > max ? s.substring(0, max) : s;
    }

    return UserFeedback.db.insertRow(
      session,
      UserFeedback(
        authUserId: user,
        kind: kind,
        text: clean,
        page: short(page, 60),
        // The server's own version; the app's (Windows and Android apps
        // can lag behind) only when it looks like one.
        appVersion: _versions(AdminEndpoint.serverVersion(), appVersion),
        status: 'open',
      ),
    );
  }

  /// `1.0.3`, or `1.0.3 · app 1.0.2 android` when the app tells another
  /// version: anything that is not a short version and platform is ignored.
  static String _versions(String server, String? app) {
    final a = app?.trim() ?? '';
    if (!RegExp(
          r'^[0-9]+\.[0-9]+\.[0-9]+( (web|android|windows|ios|linux|macos))?$',
        ).hasMatch(a) ||
        a == server) {
      return server;
    }
    return '$server · app $a';
  }

  /// The user's own remarks, newest first.
  Future<List<UserFeedback>> mine(Session session) => UserFeedback.db.find(
    session,
    where: (f) => f.authUserId.equals(Access.userId(session)),
    orderByList: (f) => [f.createdAt.desc()],
    limit: 50,
  );

  /// Server administrator: every remark, newest first, with who sent it.
  Future<List<FeedbackInfo>> all(Session session) async {
    await _requireAdmin(session);
    final rows = await UserFeedback.db.find(
      session,
      orderByList: (f) => [f.createdAt.desc()],
      limit: 200,
    );
    final emails = {
      for (final p in await UserProfile.db.find(session)) p.authUserId: p.email,
    };
    return [
      for (final f in rows)
        FeedbackInfo(feedback: f, email: emails[f.authUserId]),
    ];
  }

  Future<UserFeedback> setDone(
    Session session,
    int feedbackId,
    bool done,
  ) async {
    await _requireAdmin(session);
    final f = await UserFeedback.db.findById(session, feedbackId);
    if (f == null) throw InvalidInputException(code: 'feedback_unknown');
    return UserFeedback.db.updateRow(
      session,
      f.copyWith(status: done ? 'done' : 'open'),
    );
  }

  Future<void> _requireAdmin(Session session) async {
    if (!await Onboarding.isServerAdmin(session, Access.userId(session))) {
      throw AccessDeniedException(code: 'server_admin_only');
    }
  }
}
