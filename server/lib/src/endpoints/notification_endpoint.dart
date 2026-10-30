import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/scopes.dart';

/// The current user's notifications.
class NotificationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<List<AppNotification>> list(
    Session session, {
    bool? unreadOnly,
  }) async {
    final user = Access.userId(session);
    return AppNotification.db.find(
      session,
      where: (n) => unreadOnly == true
          ? n.authUserId.equals(user) & n.readAt.equals(null)
          : n.authUserId.equals(user),
      orderByList: (n) => [n.createdAt.desc()],
      limit: 100,
    );
  }

  Future<int> unreadCount(Session session) => AppNotification.db.count(
    session,
    where: (n) =>
        n.authUserId.equals(Access.userId(session)) & n.readAt.equals(null),
  );

  Future<void> markRead(Session session, int notificationId) async {
    final n = await AppNotification.db.findById(session, notificationId);
    if (n == null || n.authUserId != Access.userId(session)) {
      throw AccessDeniedException(code: 'notification_access_denied');
    }
    if (n.readAt == null) {
      await AppNotification.db.updateRow(
        session,
        n.copyWith(readAt: DateTime.now().toUtc()),
      );
    }
  }

  Future<void> markAllRead(Session session) async {
    final user = Access.userId(session);
    final unread = await AppNotification.db.find(
      session,
      where: (n) => n.authUserId.equals(user) & n.readAt.equals(null),
    );
    final now = DateTime.now().toUtc();
    await AppNotification.db.update(session, [
      for (final n in unread) n.copyWith(readAt: now),
    ]);
  }
}
