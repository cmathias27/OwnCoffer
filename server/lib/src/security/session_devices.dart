import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'geoip.dart';
import 'scopes.dart';
import 'session_guard.dart';

/// Where and on what each session is used, and closing sessions (decision
/// 0027). A session is a JWT refresh token; its device row is told by the
/// app ([seen]) and kept [keepAfterEnd] after the session is gone.
abstract final class SessionDevices {
  /// As `refreshTokenLifetime` in `server.dart`: a session unused this long
  /// has expired.
  static const lifetime = Duration(days: 30);
  static const keepAfterEnd = Duration(days: 30);

  /// The last activity, IP and place are written at most this often.
  static const refreshEvery = Duration(hours: 1);

  static const platforms = {
    'web',
    'android',
    'windows',
    'ios',
    'macos',
    'linux',
  };

  /// Notification types sent to a person whose sessions an administrator
  /// closed.
  static const closedByAdmin = 'session_closed_by_admin';

  /// Notification type of « nouvel appareil » and « pays inhabituel »
  /// (decision 0027, point 7).
  static const alert = 'session_alert';

  static UuidValue? _uuid(String? id) {
    if (id == null) return null;
    try {
      return UuidValue.withValidation(id);
    } on Object {
      return null;
    }
  }

  static String platformOf(String raw) {
    final p = raw.trim().toLowerCase();
    return platforms.contains(p) ? p : 'other';
  }

  static String? _version(String? raw) {
    final v = raw?.trim() ?? '';
    if (v.isEmpty) return null;
    return v.length > 32 ? v.substring(0, 32) : v;
  }

  /// `82.64.x.x` for IPv4, the first two groups for IPv6: enough to tell two
  /// places apart, not enough to find a home.
  static String? maskIp(String? ip) {
    if (ip == null) return null;
    final address = InternetAddress.tryParse(ip);
    if (address == null) return null;
    if (address.type == InternetAddressType.IPv4) {
      final p = ip.split('.');
      return '${p[0]}.${p[1]}.x.x';
    }
    final groups = ip.split(':').where((g) => g.isNotEmpty).take(2).join(':');
    return '$groups:…';
  }

  /// The app of session [sessionId] says what it is. Writes at most once
  /// per [refreshEvery] unless something changed.
  static Future<void> seen(
    Session session, {
    required UuidValue user,
    required String sessionId,
    required String platform,
    String? appVersion,
    String? ip,
    GeoIp? geo,
    DateTime? now,
  }) async {
    final t = now ?? DateTime.now().toUtc();
    ({String? city, String? country})? place() =>
        (geo ?? GeoIp.instance).lookup(ip);
    final p = platformOf(platform);
    final v = _version(appVersion);
    final row = await SessionDevice.db.findFirstRow(
      session,
      where: (d) => d.sessionId.equals(sessionId),
    );
    if (row == null) {
      final where = place();
      final SessionDevice device;
      try {
        device = await SessionDevice.db.insertRow(
          session,
          SessionDevice(
            sessionId: sessionId,
            authUserId: user,
            platform: p,
            appVersion: v,
            ip: ip,
            city: where?.city,
            country: where?.country,
            firstSeenAt: t,
            lastSeenAt: t,
          ),
        );
      } on DatabaseException {
        // The same session told twice at once: the other call wrote it.
        return;
      }
      await _alert(session, device, isNew: true);
      return;
    }
    // A session id is never someone else's; ignore rather than overwrite.
    if (row.authUserId != user) return;
    final newIp = ip != null && ip != row.ip;
    final changed =
        row.platform != p ||
        row.appVersion != v ||
        newIp ||
        row.endedAt != null;
    if (!changed && t.difference(row.lastSeenAt) < refreshEvery) return;
    // The place goes with the IP.
    final where = newIp ? place() : null;
    final updated = await SessionDevice.db.updateRow(
      session,
      row.copyWith(
        platform: p,
        appVersion: v,
        ip: ip ?? row.ip,
        city: newIp ? where?.city : row.city,
        country: newIp ? where?.country : row.country,
        lastSeenAt: t,
        endedAt: null,
      ),
    );
    if (newIp && updated.country != row.country) {
      await _alert(session, updated, isNew: false, before: row.country);
    }
  }

  /// Tells [device]'s person, in the app, about a session on a platform
  /// and in a city never seen for them (a new session only), or in a
  /// country never seen (also when an open session moves there). Nothing
  /// for a first session, nothing to compare it with. Places unknown
  /// before this check (older rows, no database) match anything, so that
  /// installing the database raises no alert. Whether the IP was ever
  /// banned (`ip_guard`) goes with the alert.
  static Future<void> _alert(
    Session session,
    SessionDevice device, {
    required bool isNew,
    String? before,
  }) async {
    final others = await SessionDevice.db.find(
      session,
      where: (d) =>
          d.authUserId.equals(device.authUserId) &
          d.sessionId.notEquals(device.sessionId),
    );
    final city = device.city;
    final country = device.country;
    final newDevice =
        isNew &&
        others.isNotEmpty &&
        !others.any(
          (o) =>
              o.platform == device.platform &&
              (city == null || o.city == null || o.city == city),
        );
    final countries = {for (final o in others) ?o.country, ?before};
    final unusualCountry =
        country != null && countries.isNotEmpty && !countries.contains(country);
    if (!newDevice && !unusualCountry) return;
    final ip = device.ip;
    final ban = ip == null
        ? null
        : await IpBan.db.findFirstRow(session, where: (b) => b.ip.equals(ip));
    final banned =
        ban != null &&
        (ban.banCount > 0 ||
            (ban.bannedUntil?.isAfter(DateTime.now().toUtc()) ?? false));
    try {
      await AppNotification.db.insertRow(
        session,
        AppNotification(
          authUserId: device.authUserId,
          type: alert,
          data: jsonEncode({
            'session': device.sessionId,
            'platform': device.platform,
            'city': ?city,
            'country': ?country,
            'ip': ?ip,
            'newDevice': newDevice,
            'unusualCountry': unusualCountry,
            'banned': banned,
          }),
          dedupKey: 'session_alert:${device.sessionId}:${country ?? ''}',
        ),
      );
    } on DatabaseException {
      // Already told for this session and country.
    }
  }

  /// Hides the alerts about [current] from that very session: they are
  /// meant for the person's other devices.
  static bool aboutOther(AppNotification n, String? current) {
    if (n.type != alert || current == null) return true;
    try {
      return (jsonDecode(n.data) as Map)['session'] != current;
    } on Object {
      return true;
    }
  }

  /// Open sessions of [user], the [current] one first, then the most
  /// recently active. Password-only sessions still waiting for their
  /// two-factor code are not listed.
  static Future<List<SessionInfo>> list(
    Session session,
    UuidValue user, {
    String? current,
    required bool masked,
    DateTime? now,
  }) async {
    final oldest = (now ?? DateTime.now().toUtc()).subtract(lifetime);
    final tokens = [
      for (final t in await RefreshToken.db.find(
        session,
        where: (t) => t.authUserId.equals(user) & (t.lastUpdatedAt >= oldest),
      ))
        if (t.scopeNames.contains(accessScope.name)) t,
    ];
    if (tokens.isEmpty) return [];
    final Set<String> ids = {for (final t in tokens) t.id.toString()};
    final devices = {
      for (final d in await SessionDevice.db.find(
        session,
        where: (d) => d.sessionId.inSet(ids),
      ))
        d.sessionId: d,
    };
    final list = [
      for (final t in tokens)
        _info(t, devices[t.id.toString()], current: current, masked: masked),
    ];
    list.sort((a, b) {
      if (a.current != b.current) return a.current ? -1 : 1;
      return b.lastActiveAt.compareTo(a.lastActiveAt);
    });
    return list;
  }

  static SessionInfo _info(
    RefreshToken t,
    SessionDevice? d, {
    required String? current,
    required bool masked,
  }) {
    final seen = d?.lastSeenAt;
    return SessionInfo(
      id: t.id.toString(),
      platform: d?.platform,
      appVersion: d?.appVersion,
      deviceLabel: d?.deviceLabel,
      ip: masked ? maskIp(d?.ip) : d?.ip,
      city: d?.city,
      country: d?.country,
      connectedSince: t.createdAt,
      lastActiveAt: seen != null && seen.isAfter(t.lastUpdatedAt)
          ? seen
          : t.lastUpdatedAt,
      current: t.id.toString() == current,
    );
  }

  /// Names session [sessionId] of [user]; false when it is not theirs or
  /// the app never said anything about it.
  static Future<bool> rename(
    Session session,
    UuidValue user,
    String sessionId,
    String? label,
  ) async {
    final row = await SessionDevice.db.findFirstRow(
      session,
      where: (d) => d.sessionId.equals(sessionId) & d.authUserId.equals(user),
    );
    if (row == null) return false;
    final name = label?.trim() ?? '';
    await SessionDevice.db.updateRow(
      session,
      row.copyWith(
        deviceLabel: name.isEmpty
            ? null
            : name.length > 60
            ? name.substring(0, 60)
            : name,
      ),
    );
    return true;
  }

  /// Closes the sessions of [user]: [only] one, or all of them but [keep].
  /// Their next call is refused, and they cannot be renewed. Returns the ids
  /// closed.
  static Future<List<String>> close(
    Session session,
    UuidValue user, {
    String? only,
    String? keep,
  }) async {
    final one = _uuid(only);
    if (only != null && one == null) return [];
    final kept = _uuid(keep);
    final deleted = await RefreshToken.db.deleteWhere(
      session,
      where: (t) {
        Expression<dynamic> e = t.authUserId.equals(user);
        if (one != null) e &= t.id.equals(one);
        if (kept != null) e &= t.id.notEquals(kept);
        return e;
      },
    );
    SessionGuard.instance.forget();
    final closed = [for (final t in deleted) t.id.toString()];
    await ended(session, closed);
    return closed;
  }

  /// Sessions [ids] are gone: their rows start their last 30 days.
  static Future<void> ended(
    Session session,
    List<String> ids, {
    DateTime? now,
  }) async {
    if (ids.isEmpty) return;
    final Set<String> set = {...ids};
    final rows = await SessionDevice.db.find(
      session,
      where: (d) => d.sessionId.inSet(set) & d.endedAt.equals(null),
    );
    if (rows.isEmpty) return;
    final t = now ?? DateTime.now().toUtc();
    await SessionDevice.db.update(session, [
      for (final r in rows) r.copyWith(endedAt: t),
    ]);
  }

  /// Every session of [user] is gone (blocked account).
  static Future<void> endedAll(Session session, UuidValue user) async {
    final rows = await SessionDevice.db.find(
      session,
      where: (d) => d.authUserId.equals(user) & d.endedAt.equals(null),
    );
    await ended(session, [for (final r in rows) r.sessionId]);
  }

  /// A notification for [user]: an administrator closed [count] of their
  /// sessions ([platform] when only one).
  static Future<void> notifyClosed(
    Session session,
    UuidValue user, {
    required List<String> ids,
    String? platform,
  }) async {
    if (ids.isEmpty) return;
    await AppNotification.db.insertRow(
      session,
      AppNotification(
        authUserId: user,
        type: closedByAdmin,
        data: jsonEncode({'count': ids.length, 'platform': ?platform}),
        dedupKey: 'session_closed:${ids.first}',
      ),
    );
  }

  /// Hourly: rows of sessions gone or expired are marked ended; rows ended
  /// more than [keepAfterEnd] ago are deleted.
  static Future<void> cleanUp(Session session, {DateTime? now}) async {
    final t = now ?? DateTime.now().toUtc();
    final open = await SessionDevice.db.find(
      session,
      where: (d) => d.endedAt.equals(null),
    );
    if (open.isNotEmpty) {
      final Set<UuidValue> ids = {
        for (final d in open) ?_uuid(d.sessionId),
      };
      final oldest = t.subtract(lifetime);
      final alive = ids.isEmpty
          ? <String>{}
          : {
              for (final r in await RefreshToken.db.find(
                session,
                where: (r) => r.id.inSet(ids) & (r.lastUpdatedAt >= oldest),
              ))
                r.id.toString(),
            };
      await ended(session, [
        for (final d in open)
          if (!alive.contains(d.sessionId)) d.sessionId,
      ], now: t);
    }
    await SessionDevice.db.deleteWhere(
      session,
      where: (d) => d.endedAt < t.subtract(keepAfterEnd),
    );
  }

  /// People seen in the last 30 days in the Android app, in the Windows
  /// app, and only in a browser.
  static Future<({int android, int windows, int webOnly})> adoption(
    Session session, {
    DateTime? now,
  }) async {
    final since = (now ?? DateTime.now().toUtc()).subtract(lifetime);
    final byUser = <UuidValue, Set<String>>{};
    for (final d in await SessionDevice.db.find(
      session,
      where: (d) => d.lastSeenAt >= since,
    )) {
      byUser.putIfAbsent(d.authUserId, () => {}).add(d.platform);
    }
    var android = 0, windows = 0, webOnly = 0;
    for (final p in byUser.values) {
      if (p.contains('android')) android++;
      if (p.contains('windows')) windows++;
      if (p.length == 1 && p.contains('web')) webOnly++;
    }
    return (android: android, windows: windows, webOnly: webOnly);
  }
}
