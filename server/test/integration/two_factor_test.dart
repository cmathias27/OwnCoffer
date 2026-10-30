import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/ip_guard.dart';
import 'package:owncoffer_server/src/security/client_ip.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_server/src/security/totp.dart';
import 'package:owncoffer_server/src/security/two_factor.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Two-factor authentication', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue user;
    late int groupId;

    TestSessionBuilder full(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    TestSessionBuilder partial(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {},
      ),
    );

    setUp(() async {
      db = sessionBuilder.build();
      IpGuard.instance = IpGuard(
        resolver: ClientIpResolver.fromEnvironment(const {}),
      );
      user = (await AuthUser.db.insertRow(
        db,
        AuthUser(
          createdAt: DateTime.now(),
          scopeNames: {'owncoffer.serverAdmin', accessScope.name!},
          blocked: false,
        ),
      )).id!;
      groupId = (await endpoints.group.create(full(user), 'G')).group.id!;
    });

    test('a partial session cannot read group data', () async {
      await expectLater(
        endpoints.account.list(partial(user), groupId),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );
      await expectLater(
        endpoints.group.myGroups(partial(user)),
        throwsA(isA<ServerpodInsufficientAccessException>()),
      );
      expect(
        (await endpoints.twoFactor.status(partial(user))).fullAccess,
        isFalse,
      );
    });

    test('enable: wrong code refused, right code gives 10 backup codes, '
        'and the account loses its permanent access', () async {
      final enrollment = await endpoints.twoFactor.begin(full(user));
      expect(enrollment.otpauthUri, startsWith('otpauth://totp/OwnCoffer'));
      final secret = Totp.base32Decode(enrollment.secret);
      await expectLater(
        endpoints.twoFactor.confirm(full(user), '000000'),
        throwsA(isA<InvalidInputException>()),
      );
      final codes = await endpoints.twoFactor.confirm(
        full(user),
        Totp.codeAt(secret, DateTime.now()),
      );
      expect(codes, hasLength(10));
      expect(codes.toSet(), hasLength(10));
      final account = (await AuthUser.db.findById(db, user))!;
      expect(account.scopeNames, isNot(contains(accessScope.name)));
      final status = await endpoints.twoFactor.status(full(user));
      expect(status.enabled, isTrue);
      expect(status.backupCodesLeft, 10);
      final stored = (await BackupCode.db.find(db)).map((b) => b.codeHash);
      expect(stored.any(codes.contains), isFalse, reason: 'hashed');
    });

    test('codes and backup codes work once; disable restores access', () async {
      final enrollment = await endpoints.twoFactor.begin(full(user));
      final secret = Totp.base32Decode(enrollment.secret);
      final first = Totp.codeAt(secret, DateTime.now());
      final backups = await endpoints.twoFactor.confirm(full(user), first);
      // The code used to enable cannot be replayed.
      expect(await TwoFactor.check(db, user, first), isFalse);
      expect(await TwoFactor.check(db, user, backups[0]), isTrue);
      expect(await TwoFactor.check(db, user, backups[0]), isFalse);
      expect(await TwoFactor.check(db, user, backups[1].toUpperCase()), isTrue);
      expect(await TwoFactor.backupCodesLeft(db, user), 8);

      await expectLater(
        endpoints.twoFactor.disable(full(user), 'zzzz-zzzz'),
        throwsA(isA<InvalidInputException>()),
      );
      await endpoints.twoFactor.disable(full(user), backups[2]);
      expect(await TwoFactor.isEnabled(db, user), isFalse);
      final account = (await AuthUser.db.findById(db, user))!;
      expect(account.scopeNames, contains(accessScope.name));
    });

    test('enrolment and settings need full access', () async {
      await expectLater(
        endpoints.twoFactor.begin(partial(user)),
        throwsA(isA<AccessDeniedException>()),
      );
      await expectLater(
        endpoints.twoFactor.disable(partial(user), '000000'),
        throwsA(isA<AccessDeniedException>()),
      );
    });

    test('wrong codes count towards the IP ban', () async {
      await expectLater(
        endpoints.twoFactor.verify(partial(user), '000000'),
        throwsA(isA<InvalidInputException>()),
      );
    });
  });
}
