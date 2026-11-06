import 'dart:typed_data';

import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_server/src/security/session_devices.dart';
import 'package:owncoffer_server/src/security/session_guard.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Decision 0027: each person sees and closes only their own sessions; only
/// the server administrator sees (IP masked) and closes those of others; a
/// closed session is refused at its next call.
void main() {
  withServerpod('Sessions and devices', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue admin, alice, bob;
    final denied = throwsA(isA<AccessDeniedException>());
    Matcher invalid(String code) => throwsA(
      isA<InvalidInputException>().having((e) => e.code, 'code', code),
    );

    TestSessionBuilder as(UuidValue u, String sessionId) =>
        sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            u.toString(),
            {accessScope},
            authId: sessionId,
          ),
        );

    Future<UuidValue> user(Set<String> scopes) async =>
        (await AuthUser.db.insertRow(
          db,
          AuthUser(
            createdAt: DateTime.now(),
            scopeNames: scopes,
            blocked: false,
          ),
        )).id!;

    /// A session (refresh token) of [u]; its id.
    Future<String> token(
      UuidValue u, {
      Set<String>? scopes,
      DateTime? lastUpdatedAt,
    }) async => (await RefreshToken.db.insertRow(
      db,
      RefreshToken(
        authUserId: u,
        scopeNames: scopes ?? {accessScope.name!},
        method: 'email',
        fixedSecret: ByteData(16),
        rotatingSecretHash: 'x',
        lastUpdatedAt: lastUpdatedAt,
      ),
    )).id.toString();

    setUp(() async {
      db = sessionBuilder.build();
      SessionGuard.instance = SessionGuard();
      admin = await user({'owncoffer.serverAdmin'});
      alice = await user({});
      bob = await user({});
    });

    test('ping records the device; the list shows own sessions only', () async {
      final phone = await token(alice);
      final laptop = await token(alice);
      // Waiting for its two-factor code: not listed.
      await token(alice, scopes: {});
      // Unused for longer than a session lives: not listed.
      await token(
        alice,
        lastUpdatedAt: DateTime.now().toUtc().subtract(
          const Duration(days: 31),
        ),
      );
      final bobs = await token(bob);
      await endpoints.presence.ping(as(alice, phone), 'Android', '1.6.0');
      await endpoints.presence.ping(as(bob, bobs), 'windows', null);

      final mine = await endpoints.presence.mySessions(as(alice, phone));
      expect(mine.map((s) => s.id), [phone, laptop]);
      expect(mine.first.current, isTrue);
      expect(mine.first.platform, 'android');
      expect(mine.first.appVersion, '1.6.0');
      expect(mine.last.platform, isNull);
      expect(
        (await endpoints.presence.mySessions(as(bob, bobs))).map((s) => s.id),
        [bobs],
      );
    });

    test('nobody renames or closes the session of someone else', () async {
      final a = await token(alice);
      final b = await token(bob);
      final b2 = await token(bob);
      await endpoints.presence.ping(as(bob, b2), 'web', null);

      await expectLater(
        endpoints.presence.rename(as(alice, a), b2, 'Pirate'),
        invalid('session_not_found'),
      );
      await expectLater(
        endpoints.presence.close(as(alice, a), b2),
        invalid('session_not_found'),
      );
      expect(await endpoints.presence.closeOthers(as(alice, a)), 0);
      final left = await RefreshToken.db.find(
        db,
        where: (t) => t.authUserId.equals(bob),
      );
      expect(left.map((t) => t.id.toString()).toSet(), {b, b2});
      final device = await SessionDevice.db.findFirstRow(
        db,
        where: (d) => d.sessionId.equals(b2),
      );
      expect(device!.deviceLabel, isNull);
      expect(device.endedAt, isNull);
    });

    test('closing: one, all others, never the current one', () async {
      final here = await token(alice);
      final other = await token(alice);
      final third = await token(alice);
      await endpoints.presence.ping(as(alice, other), 'windows', null);
      await endpoints.presence.rename(as(alice, here), other, '  Bureau  ');
      expect(
        (await SessionDevice.db.findFirstRow(
          db,
          where: (d) => d.sessionId.equals(other),
        ))!.deviceLabel,
        'Bureau',
      );

      await expectLater(
        endpoints.presence.close(as(alice, here), here),
        invalid('session_is_current'),
      );
      await endpoints.presence.close(as(alice, here), other);
      expect(
        (await SessionDevice.db.findFirstRow(
          db,
          where: (d) => d.sessionId.equals(other),
        ))!.endedAt,
        isNotNull,
      );
      expect(await endpoints.presence.closeOthers(as(alice, here)), 1);
      final left = await RefreshToken.db.find(
        db,
        where: (t) => t.authUserId.equals(alice),
      );
      expect(left.map((t) => t.id.toString()), [here]);
      expect(left.map((t) => t.id.toString()), isNot(contains(third)));
    });

    test('a closed session is refused at its next call', () async {
      final here = await token(alice);
      final other = await token(alice);
      final guard = SessionGuard.instance;
      expect(await guard.allows(db, other), isTrue);
      await endpoints.presence.close(as(alice, here), other);
      // Closed here: the kept answer is dropped at once.
      expect(await guard.allows(db, other), isFalse);
      expect(await guard.allows(db, here), isTrue);
      // Not a session id (none today): left to its own check.
      expect(await guard.allows(db, 'mcp:1'), isTrue);
    });

    test('the guard asks again once its answer is 30 seconds old', () async {
      var calls = 0;
      var open = true;
      var now = DateTime.utc(2026, 11, 6, 12);
      final guard = SessionGuard(
        isOpen: (_, _) async {
          calls++;
          return open;
        },
        now: () => now,
      );
      final id = await token(alice);
      expect(await guard.allows(db, id), isTrue);
      expect(await guard.allows(db, id), isTrue);
      expect(calls, 1);
      // Closed by another server: refused once the answer is stale.
      open = false;
      now = now.add(const Duration(seconds: 31));
      expect(await guard.allows(db, id), isFalse);
      expect(calls, 2);
    });

    test(
      'only the server administrator sees and closes others\' sessions',
      () async {
        final adminHere = await token(admin);
        final a = await token(alice);
        final a2 = await token(alice);
        final bobs = await token(bob);
        await SessionDevices.seen(
          db,
          user: alice,
          sessionId: a,
          platform: 'android',
          ip: '82.64.10.20',
        );

        for (final call in <Future<Object?> Function()>[
          () => endpoints.admin.userSessions(as(bob, bobs), alice),
          () => endpoints.admin.closeUserSessions(as(bob, bobs), alice, null),
          () => endpoints.admin.closeUserSessions(as(bob, bobs), alice, a),
        ]) {
          await expectLater(call(), denied);
        }
        expect(
          await RefreshToken.db.count(
            db,
            where: (t) => t.authUserId.equals(alice),
          ),
          2,
        );

        final seen = await endpoints.admin.userSessions(
          as(admin, adminHere),
          alice,
        );
        expect(seen.map((s) => s.id).toSet(), {a, a2});
        expect(seen.firstWhere((s) => s.id == a).ip, '82.64.x.x');
        // Alice herself sees her whole IP.
        expect(
          (await endpoints.presence.mySessions(
            as(alice, a),
          )).firstWhere((s) => s.id == a).ip,
          '82.64.10.20',
        );

        expect(
          await endpoints.admin.closeUserSessions(
            as(admin, adminHere),
            alice,
            a,
          ),
          1,
        );
        expect(
          await endpoints.admin.closeUserSessions(
            as(admin, adminHere),
            alice,
            null,
          ),
          1,
        );
        expect(
          await RefreshToken.db.count(
            db,
            where: (t) => t.authUserId.equals(alice),
          ),
          0,
        );
        final notes = await AppNotification.db.find(
          db,
          where: (n) => n.authUserId.equals(alice),
        );
        expect(notes, hasLength(2));
        expect(
          notes.every((n) => n.type == SessionDevices.closedByAdmin),
          isTrue,
        );
        // Bob's session was not touched.
        expect(await RefreshToken.db.count(db), 2);
      },
    );

    test('the administrator keeps the session he is using', () async {
      final here = await token(admin);
      final other = await token(admin);
      await expectLater(
        endpoints.admin.closeUserSessions(as(admin, here), admin, here),
        invalid('session_is_current'),
      );
      expect(
        await endpoints.admin.closeUserSessions(as(admin, here), admin, null),
        1,
      );
      expect(
        (await RefreshToken.db.find(
          db,
          where: (t) => t.authUserId.equals(admin),
        )).map((t) => t.id.toString()),
        [here],
      );
      expect(other, isNot(here));
      // Nobody is told about their own action.
      expect(await AppNotification.db.count(db), 0);
    });

    test('blocking an account closes its sessions', () async {
      final here = await token(admin);
      final a = await token(alice);
      await endpoints.presence.ping(as(alice, a), 'web', null);
      await endpoints.admin.setBlocked(as(admin, here), alice, true);
      expect(await SessionGuard.instance.allows(db, a), isFalse);
      expect(
        (await SessionDevice.db.findFirstRow(
          db,
          where: (d) => d.sessionId.equals(a),
        ))!.endedAt,
        isNotNull,
      );
    });

    test('a new IP forgets the place; quiet pings are not written', () async {
      final a = await token(alice);
      final t0 = DateTime.utc(2026, 11, 6, 10);
      await SessionDevices.seen(
        db,
        user: alice,
        sessionId: a,
        platform: 'web',
        ip: '82.64.10.20',
        now: t0,
      );
      var row = (await SessionDevice.db.findFirstRow(
        db,
        where: (d) => d.sessionId.equals(a),
      ))!;
      await SessionDevice.db.updateRow(
        db,
        row.copyWith(city: 'Rouen', country: 'FR'),
      );
      await SessionDevices.seen(
        db,
        user: alice,
        sessionId: a,
        platform: 'web',
        ip: '82.64.10.20',
        now: t0.add(const Duration(minutes: 5)),
      );
      row = (await SessionDevice.db.findFirstRow(
        db,
        where: (d) => d.sessionId.equals(a),
      ))!;
      expect(row.lastSeenAt, t0);
      expect(row.city, 'Rouen');
      await SessionDevices.seen(
        db,
        user: alice,
        sessionId: a,
        platform: 'web',
        ip: '90.1.2.3',
        now: t0.add(const Duration(minutes: 6)),
      );
      row = (await SessionDevice.db.findFirstRow(
        db,
        where: (d) => d.sessionId.equals(a),
      ))!;
      expect(row.ip, '90.1.2.3');
      expect(row.city, isNull);
      expect(row.country, isNull);
      // Someone else's session id is never overwritten.
      await SessionDevices.seen(
        db,
        user: bob,
        sessionId: a,
        platform: 'android',
      );
      row = (await SessionDevice.db.findFirstRow(
        db,
        where: (d) => d.sessionId.equals(a),
      ))!;
      expect(row.authUserId, alice);
      expect(row.platform, 'web');
    });

    test(
      'clean-up ends rows of gone sessions, deletes them 30 days later',
      () async {
        final kept = await token(alice);
        final gone = await token(alice);
        final now = DateTime.now().toUtc();
        for (final id in [kept, gone]) {
          await SessionDevices.seen(
            db,
            user: alice,
            sessionId: id,
            platform: 'web',
          );
        }
        await RefreshToken.db.deleteWhere(
          db,
          where: (t) => t.id.equals(UuidValue.withValidation(gone)),
        );
        await SessionDevices.cleanUp(db, now: now);
        final rows = {
          for (final d in await SessionDevice.db.find(db)) d.sessionId: d,
        };
        expect(rows[kept]!.endedAt, isNull);
        expect(rows[gone]!.endedAt, isNotNull);
        await SessionDevices.cleanUp(
          db,
          now: now.add(const Duration(days: 31)),
        );
        final left = await SessionDevice.db.find(db);
        // The kept session has expired by then: ended, not deleted yet.
        expect(left.map((d) => d.sessionId), [kept]);
        expect(left.single.endedAt, isNotNull);
      },
    );

    test('adoption: Android, Windows and browser-only people', () async {
      final here = await token(admin);
      Future<void> seen(UuidValue u, String platform) async =>
          SessionDevices.seen(
            db,
            user: u,
            sessionId: await token(u),
            platform: platform,
          );
      await seen(alice, 'android');
      await seen(alice, 'web');
      await seen(bob, 'web');
      await seen(admin, 'windows');
      await seen(admin, 'android');
      final stats = await endpoints.admin.stats(as(admin, here));
      expect(stats.androidUsers, 2);
      expect(stats.windowsUsers, 1);
      expect(stats.webOnlyUsers, 1);
    });

    test('masked IPs', () {
      expect(SessionDevices.maskIp('82.64.10.20'), '82.64.x.x');
      expect(SessionDevices.maskIp('2a01:cb00:1:2::5'), '2a01:cb00:…');
      expect(SessionDevices.maskIp('pas une IP'), isNull);
      expect(SessionDevices.maskIp(null), isNull);
    });
  });
}
