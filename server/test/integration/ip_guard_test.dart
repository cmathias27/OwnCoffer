import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/client_ip.dart';
import 'package:owncoffer_server/src/security/ip_guard.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('IP blocking', (sessionBuilder, endpoints) {
    late Session db;
    late IpGuard guard;
    final t0 = DateTime.utc(2026, 10, 30, 12);

    setUp(() {
      db = sessionBuilder.build();
      guard = IpGuard(
        resolver: ClientIpResolver.fromEnvironment(const {}),
        allowlist: parseRanges('192.168.1.0/24'),
      );
      IpGuard.instance = guard;
    });

    Future<void> fail(String ip, int n, DateTime at) async {
      for (var i = 0; i < n; i++) {
        await guard.recordFailureFor(db, ip, 'login', now: at);
      }
    }

    test('5 failures in 15 minutes ban the IP for 1 hour', () async {
      await fail('203.0.113.7', 4, t0);
      expect(guard.isBanned('203.0.113.7', now: t0), isFalse);
      await fail('203.0.113.7', 1, t0.add(const Duration(minutes: 14)));
      final at = t0.add(const Duration(minutes: 15));
      expect(guard.isBanned('203.0.113.7', now: at), isTrue);
      expect(
        guard.isBanned('203.0.113.7', now: t0.add(const Duration(minutes: 75))),
        isFalse,
      );
      expect(guard.isBanned('198.51.100.1', now: at), isFalse);
    });

    test('failures spread over more than 15 minutes do not ban', () async {
      await fail('203.0.113.8', 4, t0);
      await fail('203.0.113.8', 4, t0.add(const Duration(minutes: 16)));
      expect(
        guard.isBanned('203.0.113.8', now: t0.add(const Duration(minutes: 17))),
        isFalse,
      );
    });

    test('each new ban doubles the duration', () {
      expect(guard.banDuration(1), const Duration(hours: 1));
      expect(guard.banDuration(2), const Duration(hours: 2));
      expect(guard.banDuration(3), const Duration(hours: 4));
      expect(guard.banDuration(30), const Duration(days: 30));
    });

    test('second ban lasts 2 hours, and survives a restart', () async {
      await fail('203.0.113.9', 5, t0);
      final after = t0.add(const Duration(hours: 1, minutes: 1));
      await fail('203.0.113.9', 5, after);
      final row = (await IpBan.db.find(
        db,
        where: (b) => b.ip.equals('203.0.113.9'),
      )).single;
      expect(row.banCount, 2);
      expect(row.bannedUntil, after.add(const Duration(hours: 2)));
    });

    test('allow-listed IPs are never banned', () async {
      await fail('192.168.1.20', 20, t0);
      expect(guard.isBanned('192.168.1.20', now: t0), isFalse);
    });

    test('the server admin lists and lifts bans; others cannot', () async {
      final now = DateTime.now().toUtc();
      await fail('203.0.113.10', 5, now);
      final admin = (await AuthUser.db.insertRow(
        db,
        AuthUser(
          createdAt: DateTime.now(),
          scopeNames: {'owncoffer.serverAdmin'},
          blocked: false,
        ),
      )).id!;
      final user = (await AuthUser.db.insertRow(
        db,
        AuthUser(createdAt: DateTime.now(), scopeNames: {}, blocked: false),
      )).id!;
      TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          u.toString(),
          {},
        ),
      );
      await expectLater(
        endpoints.admin.bannedIps(as(user)),
        throwsA(isA<AccessDeniedException>()),
      );
      final bans = await endpoints.admin.bannedIps(as(admin));
      expect(bans.map((b) => b.ip), contains('203.0.113.10'));
      await endpoints.admin.unbanIp(as(admin), '203.0.113.10');
      expect(guard.isBanned('203.0.113.10'), isFalse);
      expect(
        (await endpoints.admin.bannedIps(as(admin))).map((b) => b.ip),
        isNot(contains('203.0.113.10')),
      );
    });
  });
}
