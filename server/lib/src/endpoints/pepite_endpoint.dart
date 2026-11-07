import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/scopes.dart';
import '../security/session_devices.dart';
import '../standalone/local_owner.dart';

/// Pépite, the mascot (decision 0026): the weekly accounts ritual, the seed
/// reserve and the badges of the signed-in user. Only their own; nothing
/// here reads a group's accounts.
///
/// In the standalone version this runs in the embedded server, so all of it
/// stays on the device; [adopt] carries it over to a server.
class PepiteEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  static const ritualSeeds = 10;
  static const badgeSeeds = 5;

  /// Every badge, in the order they are usually earned.
  static const badgeCodes = [
    'first_import',
    'first_ritual',
    'nomad',
    'weeks_4',
    'weeks_12',
    'weeks_26',
    'weeks_52',
    'year_together',
  ];

  /// [today]: the device's date, so that the week starts on the user's
  /// Monday; a date far from the server's is ignored.
  Future<PepiteStatus> status(Session session, DateTime today) async {
    final user = Access.userId(session);
    return session.db.transaction(
      (t) async => _status(
        session,
        t,
        user,
        await _progress(session, t, user),
        _monday(today),
      ),
    );
  }

  /// The ritual of this week is done: [ritualSeeds] seeds the first time in
  /// the week, and the badges it earns. Again in the same week: nothing more.
  Future<PepiteStatus> completeRitual(Session session, DateTime today) async {
    final user = Access.userId(session);
    final week = _monday(today);
    return session.db.transaction((t) async {
      var p = await _progress(session, t, user);
      var earned = 0;
      if (p.lastWeek == null || p.lastWeek!.isBefore(week)) {
        final now = DateTime.now().toUtc();
        p = await PepiteProgress.db.updateRow(
          session,
          p.copyWith(
            seeds: p.seeds + ritualSeeds,
            weeks: p.weeks + 1,
            lastWeek: week,
            firstRitualAt: p.firstRitualAt ?? now,
            lastRitualAt: now,
          ),
          transaction: t,
        );
        earned = ritualSeeds;
      }
      return _status(session, t, user, p, week, earned: earned);
    });
  }

  /// Standalone version moved to a server: its reserve and badges come
  /// along, only into an account that has none yet (nothing is added to an
  /// existing reserve). Returns whether they were taken.
  Future<bool> adopt(Session session, PepiteStatus from) async {
    final user = Access.userId(session);
    return session.db.transaction((t) async {
      final existing = await PepiteProgress.db.findFirstRow(
        session,
        where: (p) => p.authUserId.equals(user),
        transaction: t,
      );
      final badges = await PepiteBadge.db.count(
        session,
        where: (b) => b.authUserId.equals(user),
        transaction: t,
      );
      if ((existing != null && (existing.seeds > 0 || existing.weeks > 0)) ||
          badges > 0) {
        return false;
      }
      final weeks = from.weeks.clamp(0, 5000);
      final progress = PepiteProgress(
        authUserId: user,
        // No more than the rituals and badges could have given.
        seeds: from.seeds.clamp(
          0,
          weeks * ritualSeeds + badgeCodes.length * badgeSeeds,
        ),
        weeks: weeks,
        lastWeek: from.lastRitualAt == null
            ? null
            : _mondayOf(from.lastRitualAt!),
        firstRitualAt: from.firstRitualAt,
        lastRitualAt: from.lastRitualAt,
      );
      if (existing == null) {
        await PepiteProgress.db.insertRow(session, progress, transaction: t);
      } else {
        await PepiteProgress.db.updateRow(
          session,
          progress.copyWith(id: existing.id),
          transaction: t,
        );
      }
      final now = DateTime.now().toUtc();
      await PepiteBadge.db.insert(session, [
        for (final code in {...from.badges}.where(badgeCodes.contains))
          PepiteBadge(authUserId: user, code: code, earnedAt: now),
      ], transaction: t);
      return true;
    });
  }

  Future<PepiteProgress> _progress(
    Session session,
    Transaction t,
    UuidValue user,
  ) async =>
      await PepiteProgress.db.findFirstRow(
        session,
        where: (p) => p.authUserId.equals(user),
        transaction: t,
      ) ??
      await PepiteProgress.db.insertRow(
        session,
        PepiteProgress(authUserId: user, seeds: 0, weeks: 0),
        transaction: t,
      );

  /// Gives the badges now deserved, then says where the user stands.
  Future<PepiteStatus> _status(
    Session session,
    Transaction t,
    UuidValue user,
    PepiteProgress p,
    DateTime week, {
    int earned = 0,
  }) async {
    final have = await PepiteBadge.db.find(
      session,
      where: (b) => b.authUserId.equals(user),
      orderBy: (b) => b.earnedAt,
      transaction: t,
    );
    final codes = {for (final b in have) b.code};
    final now = DateTime.now().toUtc();
    final first = p.firstRitualAt;
    bool deserved(String code) => switch (code) {
      'first_ritual' => p.weeks >= 1,
      'weeks_4' => p.weeks >= 4,
      'weeks_12' => p.weeks >= 12,
      'weeks_26' => p.weeks >= 26,
      'weeks_52' => p.weeks >= 52,
      'year_together' =>
        first != null && now.difference(first) >= const Duration(days: 365),
      _ => false,
    };
    final fresh = [
      for (final code in badgeCodes)
        if (!codes.contains(code) &&
            switch (code) {
              'first_import' => await _hasImported(session, t, user),
              'nomad' => await _usedAnApp(session, t, user),
              _ => deserved(code),
            })
          code,
    ];
    if (fresh.isNotEmpty) {
      await PepiteBadge.db.insert(session, [
        for (final code in fresh)
          PepiteBadge(authUserId: user, code: code, earnedAt: now),
      ], transaction: t);
      p = await PepiteProgress.db.updateRow(
        session,
        p.copyWith(seeds: p.seeds + fresh.length * badgeSeeds),
        transaction: t,
      );
      earned += fresh.length * badgeSeeds;
    }
    final last = p.lastWeek;
    return PepiteStatus(
      seeds: p.seeds,
      weeks: p.weeks,
      doneThisWeek: last != null && !last.isBefore(week),
      firstRitualAt: p.firstRitualAt,
      lastRitualAt: p.lastRitualAt,
      badges: [...have.map((b) => b.code), ...fresh],
      earnedSeeds: earned,
      newBadges: fresh,
    );
  }

  Future<bool> _hasImported(
    Session session,
    Transaction t,
    UuidValue user,
  ) async =>
      await StatementImport.db.count(
        session,
        where: (i) => i.authorId.equals(user),
        transaction: t,
      ) >
      0;

  /// « Pépite nomade » (decision 0027, point 8): a session seen on the
  /// Android or Windows app, or the standalone app (which has no ping, but
  /// only runs as an app).
  Future<bool> _usedAnApp(
    Session session,
    Transaction t,
    UuidValue user,
  ) async {
    final Set<String> apps = SessionDevices.appPlatforms;
    if (await SessionDevice.db.count(
          session,
          where: (d) => d.authUserId.equals(user) & d.platform.inSet(apps),
          transaction: t,
        ) >
        0) {
      return true;
    }
    return await RefreshToken.db.count(
          session,
          where: (r) =>
              r.authUserId.equals(user) & r.method.equals(LocalOwner.method),
          transaction: t,
        ) >
        0;
  }

  /// Monday of the week of [today], the device's date, unless it is more
  /// than a day away from the server's (a wrong clock, or a forged date).
  static DateTime _monday(DateTime today) {
    final utc = DateTime.now().toUtc();
    final server = DateTime.utc(utc.year, utc.month, utc.day);
    final given = DateTime.utc(today.year, today.month, today.day);
    final close = given.difference(server).inHours.abs() <= 36;
    return _mondayOf(close ? given : server);
  }

  static DateTime _mondayOf(DateTime d) {
    final day = DateTime.utc(d.year, d.month, d.day);
    return day.subtract(Duration(days: day.weekday - DateTime.monday));
  }
}
