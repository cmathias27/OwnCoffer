import 'package:owncoffer_server/src/core/portable_sql.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Pépite's advice on the app (decision 0028, point 12): « Bien démarrer »
/// and the tips already seen.
void main() {
  withServerpod('Pépite: « Bien démarrer » and tips', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue alice, mallory, reader;
    late int groupA, groupB;
    late Account shared, restricted;
    late Category category;
    final denied = throwsA(isA<AccessDeniedException>());

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

    Future<void> imported(Account a, UuidValue author) =>
        StatementImport.db.insertRow(
          db,
          StatementImport(
            accountId: a.id!,
            format: 'ofx',
            fileName: 'releve.ofx',
            fileHash: 'h${a.id}',
            encoding: 'utf-8',
            readCount: 1,
            addedCount: 1,
            duplicateCount: 0,
            possibleDuplicateCount: 0,
            errorCount: 0,
            classifiedCount: 0,
            authorId: author,
          ),
        );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({'owncoffer.serverAdmin'});
      reader = await user({});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      groupB = (await endpoints.group.create(as(mallory), 'B')).group.id!;
      shared = await endpoints.account.create(
        as(alice),
        groupA,
        'Courant',
        AccountKind.checking,
      );
      restricted = await endpoints.account.create(
        as(alice),
        groupA,
        'Perso',
        AccountKind.checking,
        visibility: AccountVisibility.restricted,
      );
      category = (await endpoints.category.list(as(alice), groupA)).first;
    });

    group('« Bien démarrer »', () {
      test('a new group: every step to do', () async {
        final s = await endpoints.pepiteAdvice.start(as(alice), groupA);
        // The standalone app has no password and no other member.
        final standalone = db.onSqlite;
        expect(s.steps, [
          'account',
          'rules',
          'scheduled',
          'goal',
          if (!standalone) 'two_factor',
          'app',
          if (!standalone) 'members',
        ]);
        expect(s.done, isEmpty);
        // The server's administrator also has the server's list; no host
        // folder in the tests, and no proxy. None in the standalone app.
        expect(s.adminSteps, [
          if (!standalone) ...[
            'backups',
            'restore_test',
            'auto_update',
            'invitations',
            'ai',
            'proxy',
          ],
        ]);
        for (final code in ['backups', 'restore_test', 'auto_update', 'ai']) {
          expect(s.adminDone, isNot(contains(code)));
        }
        expect(s.adminDone, isNot(contains('proxy')));
      });

      test('each step checked from the data', () async {
        await imported(shared, alice);
        await Rule.db.insertRow(
          db,
          Rule(
            groupId: groupA,
            categoryId: category.id!,
            matchType: RuleMatchType.contains,
            pattern: 'LIDL',
          ),
        );
        await ScheduledTransaction.db.insertRow(
          db,
          ScheduledTransaction(
            accountId: shared.id!,
            amountCents: -1000,
            label: 'Box',
            frequency: ScheduleFrequency.monthly,
            startDate: DateTime.utc(2026, 11, 1),
          ),
        );
        await Goal.db.insertRow(
          db,
          Goal(groupId: groupA, categoryId: category.id!, amountCents: 20000),
        );
        await TotpSecret.db.insertRow(
          db,
          TotpSecret(authUserId: alice, secretBox: 'x', enabled: true),
        );
        await GroupMember.db.insertRow(
          db,
          GroupMember(
            groupId: groupA,
            authUserId: reader,
            role: MemberRole.reader,
          ),
        );
        final s = await endpoints.pepiteAdvice.start(as(alice), groupA);
        expect(s.done, [
          'account',
          'rules',
          'scheduled',
          'goal',
          if (!db.onSqlite) ...['two_factor', 'members'],
        ]);
      });

      test('a member: no « inviter » step, no server list, only the '
          'accounts they see', () async {
        await GroupMember.db.insertRow(
          db,
          GroupMember(
            groupId: groupA,
            authUserId: reader,
            role: MemberRole.reader,
          ),
        );
        await imported(restricted, alice);
        final s = await endpoints.pepiteAdvice.start(as(reader), groupA);
        expect(s.steps, isNot(contains('members')));
        expect(s.adminSteps, isEmpty);
        expect(s.done, isNot(contains('account')));
        // The administrator sees the restricted account.
        expect(
          (await endpoints.pepiteAdvice.start(as(alice), groupA)).done,
          contains('account'),
        );
      });

      test('isolation: another group is refused and sees nothing', () async {
        await imported(shared, alice);
        await Goal.db.insertRow(
          db,
          Goal(groupId: groupA, categoryId: category.id!, amountCents: 100),
        );
        await expectLater(
          endpoints.pepiteAdvice.start(as(mallory), groupA),
          denied,
        );
        final b = await endpoints.pepiteAdvice.start(as(mallory), groupB);
        expect(b.done, isEmpty);
        // Nothing was changed.
        expect(
          await StatementImport.db.count(
            db,
            where: (i) => i.accountId.equals(shared.id!),
          ),
          1,
        );
      });
    });

    group('« Le savais-tu ? »', () {
      test('seen once, on every device, per user', () async {
        final none = await endpoints.pepiteAdvice.tips(as(alice));
        expect(none.seen, isEmpty);
        expect(none.lastSeenAt, isNull);
        final one = await endpoints.pepiteAdvice.tipSeen(
          as(alice),
          'operations_search',
        );
        expect(one.seen, ['operations_search']);
        expect(one.lastSeenAt, isNotNull);
        final again = await endpoints.pepiteAdvice.tipSeen(
          as(alice),
          'operations_search',
        );
        expect(again.seen, ['operations_search']);
        await endpoints.pepiteAdvice.tipSeen(as(alice), 'budget_goal');
        expect(
          (await endpoints.pepiteAdvice.tips(as(alice))).seen.toSet(),
          {'operations_search', 'budget_goal'},
        );
        expect((await endpoints.pepiteAdvice.tips(as(mallory))).seen, isEmpty);
      });

      test('only codes of the catalogue', () async {
        for (final code in ['', 'Majuscule', 'a b', 'x' * 41, "a'b"]) {
          await expectLater(
            endpoints.pepiteAdvice.tipSeen(as(alice), code),
            throwsA(isA<InvalidInputException>()),
          );
        }
        expect(await PepiteTipSeen.db.count(db), 0);
      });
    });
  });
}
