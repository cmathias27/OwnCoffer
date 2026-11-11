import 'package:owncoffer_server/src/endpoints/pepite_endpoint.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// The challenge of the month (decisions 0028 point 8, 0030): chosen,
/// measured from the user's own doings since then, 10 seeds once done.
void main() {
  withServerpod('Pépite: challenge of the month', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, mallory;
    late int group;
    late Account account;
    late Map<String, Category> cats;
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user() async => (await AuthUser.db.insertRow(
      db,
      AuthUser(
        createdAt: now,
        scopeNames: {'owncoffer.serverAdmin'},
        blocked: false,
      ),
    )).id!;
    Future<PepiteStatus> status(UuidValue u) =>
        endpoints.pepite.status(as(u), today);
    Future<void> rule(UuidValue u, String pattern) => endpoints.rule.create(
      as(u),
      group,
      cats['food']!.id!,
      pattern,
      RuleMatchType.contains,
    );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user();
      mallory = await user();
      group = (await endpoints.group.create(as(alice), 'A')).group.id!;
      account = await endpoints.account.create(
        as(alice),
        group,
        'Courant',
        AccountKind.checking,
      );
      cats = {
        for (final c in await endpoints.category.list(as(alice), group))
          c.standardCode!: c,
      };
    });

    test('none until chosen; then counted from the choice', () async {
      expect((await status(alice)).challenge, isNull);
      // Done before choosing: not counted.
      await rule(alice, 'AVANT');
      final chosen = await endpoints.pepite.chooseChallenge(
        as(alice),
        'rules_3',
        today,
      );
      expect(chosen.challenge!.code, 'rules_3');
      expect(chosen.challenge!.month, core.pepiteChallengeMonth(today));
      expect(chosen.challenge!.target, 3);
      expect(chosen.challenge!.progress, 0);
      expect(chosen.challenge!.done, isFalse);
      await rule(alice, 'UN');
      await rule(alice, 'DEUX');
      final two = await status(alice);
      expect(two.challenge!.progress, 2);
      expect(two.earnedSeeds, 0);
      await rule(alice, 'TROIS');
      final done = await status(alice);
      expect(done.challenge!.done, isTrue);
      expect(done.challenge!.justDone, isTrue);
      expect(done.earnedSeeds, core.pepiteChallengeSeeds);
      expect(done.challengesDone, 1);
      final seeds = done.seeds;
      // Once: no more seeds, cannot be changed or dropped.
      final again = await status(alice);
      expect(again.challenge!.justDone, isFalse);
      expect(again.seeds, seeds);
      await expectLater(
        endpoints.pepite.chooseChallenge(as(alice), 'goal_1', today),
        throwsA(isA<InvalidInputException>()),
      );
      await endpoints.pepite.dropChallenge(as(alice), today);
      expect((await status(alice)).challenge!.done, isTrue);
    });

    test('dropped or changed: nothing lost, nothing gained', () async {
      await endpoints.pepite.chooseChallenge(as(alice), 'rules_3', today);
      await rule(alice, 'UN');
      final dropped = await endpoints.pepite.dropChallenge(as(alice), today);
      expect(dropped.challenge, isNull);
      final changed = await endpoints.pepite.chooseChallenge(
        as(alice),
        'classify_20',
        today,
      );
      expect(changed.challenge!.code, 'classify_20');
      expect(changed.challenge!.progress, 0);
      final op = await endpoints.transaction.create(
        as(alice),
        account.id!,
        today,
        -1250,
        'Boulangerie',
      );
      await endpoints.transaction.setCategory(
        as(alice),
        op.id!,
        cats['food']!.id!,
      );
      expect((await status(alice)).challenge!.progress, 1);
      await expectLater(
        endpoints.pepite.chooseChallenge(as(alice), 'nope', today),
        throwsA(isA<InvalidInputException>()),
      );
    });

    test("only the user's own doings count", () async {
      await endpoints.pepite.chooseChallenge(as(mallory), 'rules_3', today);
      await endpoints.pepite.chooseChallenge(as(alice), 'rules_3', today);
      for (final p in ['UN', 'DEUX', 'TROIS']) {
        await rule(alice, p);
      }
      final m = await status(mallory);
      expect(m.challenge!.progress, 0);
      expect(m.challenge!.done, isFalse);
      expect((await status(alice)).challenge!.done, isTrue);
    });

    test('adopt keeps the seeds of challenges done', () async {
      final from = PepiteStatus(
        seeds: 2 * core.pepiteChallengeSeeds,
        weeks: 0,
        doneThisWeek: false,
        badges: const [],
        earnedSeeds: 0,
        newBadges: const [],
        items: const [],
        equipped: const [],
        challengesDone: 2,
      );
      expect(await endpoints.pepite.adopt(as(alice), from), isTrue);
      expect((await status(alice)).seeds, 2 * core.pepiteChallengeSeeds);
      expect(PepiteEndpoint.ritualSeeds, 10);
    });

    test('every challenge of the list can be measured', () async {
      for (final c in core.pepiteChallenges) {
        final s = await endpoints.pepite.chooseChallenge(
          as(alice),
          c.code,
          today,
        );
        expect(s.challenge!.code, c.code);
        expect(s.challenge!.progress, 0);
      }
    });

    test('needs a signed-in user', () async {
      await expectLater(
        endpoints.pepite.chooseChallenge(sessionBuilder, 'rules_3', today),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}
