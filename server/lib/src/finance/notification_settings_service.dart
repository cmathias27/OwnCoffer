import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The user's choices about alerts (everything on until they change it).
abstract final class NotificationSettingsService {
  static NotificationSettings defaults(UuidValue user) => NotificationSettings(
    authUserId: user,
    overdraftApp: true,
    overdraftEmail: true,
    goalWarning: true,
    goalOver: true,
    goalForecast: true,
    warrantyApp: true,
    warrantyEmail: true,
  );

  static Future<NotificationSettings> of(
    Session session,
    UuidValue user,
  ) async =>
      await NotificationSettings.db.findFirstRow(
        session,
        where: (s) => s.authUserId.equals(user),
      ) ??
      defaults(user);
}
