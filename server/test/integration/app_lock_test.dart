import 'package:owncoffer_server/src/auth/email_config.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/client_ip.dart';
import 'package:owncoffer_server/src/security/ip_guard.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Automatic lock: unlocking with the password', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );

    Future<UuidValue> user({String? email, String? password}) async {
      final id = (await AuthUser.db.insertRow(
        db,
        AuthUser(
          createdAt: DateTime.now(),
          scopeNames: {accessScope.name!},
          blocked: false,
        ),
      )).id!;
      if (email != null) {
        await AuthServices.instance.emailIdp.admin.createEmailAuthentication(
          db,
          authUserId: id,
          email: email,
          password: password,
        );
      }
      return id;
    }

    setUp(() {
      db = sessionBuilder.build();
      IpGuard.instance = IpGuard(
        resolver: ClientIpResolver.fromEnvironment(const {}),
      );
      AuthServices.set(
        tokenManagerBuilders: [JwtConfigFromPasswords()],
        identityProviderBuilders: [buildEmailIdpConfig()],
      );
    });

    test('the right password unlocks, a wrong one does not', () async {
      final me = await user(email: 'a@example.test', password: 'correct horse');
      expect(
        await endpoints.appLock.verifyPassword(as(me), 'correct horse'),
        isTrue,
      );
      expect(await endpoints.appLock.verifyPassword(as(me), 'wrong'), isFalse);
    });

    test("another member's password never unlocks my session", () async {
      final me = await user(email: 'a@example.test', password: 'mine 1234');
      await user(email: 'b@example.test', password: 'theirs 5678');
      expect(
        await endpoints.appLock.verifyPassword(as(me), 'theirs 5678'),
        isFalse,
      );
    });

    test('an account without password (standalone) cannot unlock '
        'with one', () async {
      final me = await user();
      expect(await endpoints.appLock.verifyPassword(as(me), ''), isFalse);
      expect(
        await endpoints.appLock.verifyPassword(as(me), 'anything'),
        isFalse,
      );
    });

    test('too many wrong passwords: refused even with the right one', () async {
      final me = await user(email: 'a@example.test', password: 'right 1234');
      Object? error;
      for (var i = 0; i < 20 && error == null; i++) {
        try {
          await endpoints.appLock.verifyPassword(as(me), 'wrong $i');
        } on AccessDeniedException catch (e) {
          error = e;
        }
      }
      expect(
        error,
        isA<AccessDeniedException>().having(
          (e) => e.code,
          'code',
          'unlock_too_many_attempts',
        ),
      );
      await expectLater(
        endpoints.appLock.verifyPassword(as(me), 'right 1234'),
        throwsA(isA<AccessDeniedException>()),
      );
    });

    test('needs a signed-in user', () async {
      await expectLater(
        endpoints.appLock.verifyPassword(sessionBuilder, 'x'),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}
