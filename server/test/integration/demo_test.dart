import 'package:owncoffer_server/src/demo/demo_seed.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Demonstration instance', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue admin, bob;
    late int groupA;

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
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

    setUp(() async {
      db = sessionBuilder.build();
      admin = await user({'owncoffer.serverAdmin'});
      bob = await user({});
      groupA = (await endpoints.group.create(as(admin), 'Démo')).group.id!;
      await GroupMember.db.insertRow(
        db,
        GroupMember(groupId: groupA, authUserId: bob, role: MemberRole.user),
      );
    });
    tearDown(() => DemoSeed.enabledOverride = null);

    test('never on a normal instance', () async {
      DemoSeed.enabledOverride = false;
      expect((await endpoints.setup.status(sessionBuilder)).demo, isFalse);
      await expectLater(
        endpoints.admin.fillDemo(as(admin), groupA),
        throwsA(isA<AccessDeniedException>()),
      );
      expect(await Account.db.count(db), 0);
    });

    test('a demo instance fills an empty household, once, by the server '
        'administrator', () async {
      DemoSeed.enabledOverride = true;
      expect((await endpoints.setup.status(sessionBuilder)).demo, isTrue);
      await expectLater(
        endpoints.admin.fillDemo(as(bob), groupA),
        throwsA(isA<AccessDeniedException>()),
      );
      await endpoints.admin.fillDemo(as(admin), groupA);
      final accounts = await endpoints.account.list(as(bob), groupA);
      expect(accounts, hasLength(3));
      final ops = await endpoints.transaction.list(as(bob), accounts.first.id!);
      expect(ops.total, greaterThan(100));
      final subs = await endpoints.scheduled.subscriptions(as(bob), groupA);
      expect(subs.items, isNotEmpty);
      expect(await endpoints.goal.list(as(bob), groupA), hasLength(3));
      expect(
        (await endpoints.loan.overview(as(bob), groupA)).loans,
        hasLength(1),
      );
      final found = await endpoints.loan.detectedInstalments(as(bob), groupA);
      expect(found.map((c) => c.label), contains('ONEY 4X'));
      await expectLater(
        endpoints.admin.fillDemo(as(admin), groupA),
        throwsA(
          isA<InvalidInputException>().having(
            (e) => e.code,
            'code',
            'demo_group_not_empty',
          ),
        ),
      );
    });
  });
}
