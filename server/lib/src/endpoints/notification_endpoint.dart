import 'package:serverpod/serverpod.dart';

import '../finance/notification_settings_service.dart';
import '../generated/protocol.dart';
import '../pepite/pepite_badges.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';
import '../security/session_devices.dart';

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
    final current = session.authenticated?.authId;
    return [
      for (final n in await AppNotification.db.find(
        session,
        where: (n) => unreadOnly == true
            ? n.authUserId.equals(user) & n.readAt.equals(null)
            : n.authUserId.equals(user),
        orderByList: (n) => [n.createdAt.desc()],
        limit: 100,
      ))
        if (SessionDevices.aboutOther(n, current)) n,
    ];
  }

  Future<int> unreadCount(Session session) async {
    final where =
        AppNotification.t.authUserId.equals(Access.userId(session)) &
        AppNotification.t.readAt.equals(null);
    final all = await AppNotification.db.count(session, where: (_) => where);
    final current = session.authenticated?.authId;
    if (all == 0 || current == null) return all;
    // Alerts about this very session are not shown here (decision 0027).
    final alerts = await AppNotification.db.find(
      session,
      where: (n) => where & n.type.equals(SessionDevices.alert),
    );
    return all -
        alerts.where((n) => !SessionDevices.aboutOther(n, current)).length;
  }

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
    // « Vigilant » (decision 0028): a sign-in alert opened, so answered.
    if (n.type == SessionDevices.alert) {
      await PepiteBadges.mark(
        session,
        n.authUserId,
        PepiteBadges.sessionAlert,
        '',
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

  /// The user's own choices (everything on by default).
  Future<NotificationSettings> settings(Session session) =>
      NotificationSettingsService.of(session, Access.userId(session));

  /// Saves the user's choices; always for the user signed in, whatever
  /// [settings] says. An email needs its alert in the app.
  Future<NotificationSettings> saveSettings(
    Session session,
    NotificationSettings settings,
  ) async {
    final user = Access.userId(session);
    final current = await NotificationSettings.db.findFirstRow(
      session,
      where: (s) => s.authUserId.equals(user),
    );
    final clean = settings.copyWith(
      id: current?.id,
      authUserId: user,
      overdraftEmail: settings.overdraftApp && settings.overdraftEmail,
      warrantyEmail: settings.warrantyApp && settings.warrantyEmail,
      updatedAt: DateTime.now().toUtc(),
    );
    final saved = current == null
        ? await NotificationSettings.db.insertRow(session, clean)
        : await NotificationSettings.db.updateRow(session, clean);
    await Audit.log(
      session,
      groupId: null,
      action: 'update',
      entity: 'notification_settings',
      rowId: saved.id,
      after: saved,
    );
    return saved;
  }
}
