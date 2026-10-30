import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Proves that nobody can read or change another group's data, nor a
/// restricted account they were not given access to (roadbook, phase 2).
void main() {
  withServerpod('Permissions', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, bob, carol, mallory;
    late int groupA, groupB;
    late Account sharedA, restrictedA, accountB;

    TestSessionBuilder as(UuidValue user) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        user.toString(),
        {accessScope},
      ),
    );

    Future<UuidValue> newUser() async => (await AuthUser.db.insertRow(
      db,
      AuthUser(createdAt: DateTime.now(), scopeNames: {}, blocked: false),
    )).id!;

    Future<int> newGroup(
      String name,
      Map<UuidValue, MemberRole> members,
    ) async {
      final g = await FinanceGroup.db.insertRow(
        db,
        FinanceGroup(name: name, createdBy: members.keys.first),
      );
      for (final e in members.entries) {
        await GroupMember.db.insertRow(
          db,
          GroupMember(groupId: g.id!, authUserId: e.key, role: e.value),
        );
      }
      return g.id!;
    }

    setUp(() async {
      db = sessionBuilder.build();
      alice = await newUser(); // admin of A
      bob = await newUser(); // user of A
      carol = await newUser(); // reader of A
      mallory = await newUser(); // admin of B only
      groupA = await newGroup('A', {
        alice: MemberRole.admin,
        bob: MemberRole.user,
        carol: MemberRole.reader,
      });
      groupB = await newGroup('B', {mallory: MemberRole.admin});
      sharedA = await endpoints.account.create(
        as(alice),
        groupA,
        'Courant',
        AccountKind.checking,
        initialBalanceCents: 100000,
      );
      restrictedA = await endpoints.account.create(
        as(alice),
        groupA,
        'Perso Alice',
        AccountKind.savings,
        visibility: AccountVisibility.restricted,
      );
      accountB = await endpoints.account.create(
        as(mallory),
        groupB,
        'Compte B',
        AccountKind.checking,
      );
    });

    final denied = throwsA(isA<AccessDeniedException>());

    group('another group', () {
      test('cannot list its accounts or members', () async {
        await expectLater(endpoints.account.list(as(mallory), groupA), denied);
        await expectLater(endpoints.group.members(as(mallory), groupA), denied);
      });

      test('cannot change, archive or share its accounts', () async {
        await expectLater(
          endpoints.account.update(as(mallory), sharedA.id!, name: 'x'),
          denied,
        );
        await expectLater(
          endpoints.account.archive(as(mallory), sharedA.id!),
          denied,
        );
        await expectLater(
          endpoints.account.setAccess(
            as(mallory),
            restrictedA.id!,
            mallory,
            true,
          ),
          denied,
        );
        final unchanged = await Account.db.findById(db, sharedA.id!);
        expect(unchanged!.name, 'Courant');
        expect(unchanged.deletedAt, isNull);
      });

      test('cannot rename the group or change roles', () async {
        await expectLater(
          endpoints.group.rename(as(mallory), groupA, 'x'),
          denied,
        );
        await expectLater(
          endpoints.group.setRole(
            as(mallory),
            groupA,
            mallory,
            MemberRole.admin,
          ),
          denied,
        );
        await expectLater(
          endpoints.group.removeMember(as(mallory), groupA, alice),
          denied,
        );
      });

      test('cannot create an account in it', () async {
        await expectLater(
          endpoints.account.create(as(mallory), groupA, 'x', AccountKind.cash),
          denied,
        );
      });

      test('sees only its own groups', () async {
        final mine = await endpoints.group.myGroups(as(mallory));
        expect(mine.map((m) => m.group.id), [groupB]);
      });

      test('missing and forbidden ids give the same error', () async {
        Object? forbidden, missing;
        try {
          await endpoints.account.update(as(mallory), sharedA.id!, name: 'x');
        } on AccessDeniedException catch (e) {
          forbidden = e.code;
        }
        try {
          await endpoints.account.update(as(mallory), 999999, name: 'x');
        } on AccessDeniedException catch (e) {
          missing = e.code;
        }
        expect(forbidden, isNotNull);
        expect(forbidden, missing);
      });
    });

    group('restricted account', () {
      test(
        'hidden from members without access, visible to the admin',
        () async {
          final bobSees = await endpoints.account.list(as(bob), groupA);
          expect(bobSees.map((a) => a.id), [sharedA.id]);
          final aliceSees = await endpoints.account.list(as(alice), groupA);
          expect(aliceSees.map((a) => a.id).toSet(), {
            sharedA.id,
            restrictedA.id,
          });
          await expectLater(
            endpoints.account.update(as(bob), restrictedA.id!, name: 'x'),
            denied,
          );
        },
      );

      test(
        'visible once access is granted, hidden again when revoked',
        () async {
          await endpoints.account.setAccess(
            as(alice),
            restrictedA.id!,
            bob,
            true,
          );
          expect(
            (await endpoints.account.list(as(bob), groupA)).map((a) => a.id),
            containsAll([sharedA.id, restrictedA.id]),
          );
          await endpoints.account.setAccess(
            as(alice),
            restrictedA.id!,
            bob,
            false,
          );
          expect(
            (await endpoints.account.list(as(bob), groupA)).map((a) => a.id),
            [sharedA.id],
          );
        },
      );

      test('access cannot be granted to someone outside the group', () async {
        await expectLater(
          endpoints.account.setAccess(
            as(alice),
            restrictedA.id!,
            mallory,
            true,
          ),
          throwsA(isA<InvalidInputException>()),
        );
      });
    });

    group('roles inside the group', () {
      test('readers and users cannot manage accounts', () async {
        for (final u in [bob, carol]) {
          await expectLater(
            endpoints.account.create(as(u), groupA, 'x', AccountKind.cash),
            denied,
          );
          await expectLater(
            endpoints.account.update(as(u), sharedA.id!, name: 'x'),
            denied,
          );
        }
      });

      test('the last admin cannot be demoted or removed', () async {
        await expectLater(
          endpoints.group.setRole(as(alice), groupA, alice, MemberRole.user),
          throwsA(isA<InvalidInputException>()),
        );
        await expectLater(
          endpoints.group.removeMember(as(alice), groupA, alice),
          throwsA(isA<InvalidInputException>()),
        );
      });

      test('a member can leave; a removed member loses access', () async {
        await endpoints.account.setAccess(
          as(alice),
          restrictedA.id!,
          bob,
          true,
        );
        await endpoints.group.removeMember(as(alice), groupA, bob);
        await expectLater(endpoints.account.list(as(bob), groupA), denied);
        final grants = await AccountAccess.db.count(
          db,
          where: (a) => a.authUserId.equals(bob),
        );
        expect(grants, 0);
        await endpoints.group.removeMember(as(carol), groupA, carol);
        await expectLater(endpoints.group.members(as(carol), groupA), denied);
      });
    });

    test('unauthenticated calls are refused', () async {
      await expectLater(
        endpoints.group.myGroups(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('sensitive changes are audited', () async {
      await endpoints.account.update(as(alice), sharedA.id!, name: 'Joint');
      final entries = await AuditEntry.db.find(
        db,
        where: (e) => e.groupId.equals(groupA) & e.action.equals('update'),
      );
      expect(entries, hasLength(1));
      expect(entries.single.authUserId, alice);
      expect(entries.single.before, contains('Courant'));
      expect(entries.single.after, contains('Joint'));
    });

    test('accountB stays untouched by everything above', () async {
      final b = await Account.db.findById(db, accountB.id!);
      expect(b!.name, 'Compte B');
      expect(b.groupId, groupB);
    });
  });
}
