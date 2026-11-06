import 'package:owncoffer_server/src/endpoints/pepite_endpoint.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Pépite: ritual, seeds and badges', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue alice, mallory;

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user() async => (await AuthUser.db.insertRow(
      db,
      AuthUser(
        createdAt: DateTime.now(),
        scopeNames: {'owncoffer.serverAdmin'},
        blocked: false,
      ),
    )).id!;

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user();
      mallory = await user();
    });

    final today = DateTime.now();

    PepiteStatus empty({
      int seeds = 0,
      int weeks = 0,
      List<String> badges = const [],
      DateTime? last,
    }) => PepiteStatus(
      seeds: seeds,
      weeks: weeks,
      doneThisWeek: false,
      firstRitualAt: last,
      lastRitualAt: last,
      badges: badges,
      earnedSeeds: 0,
      newBadges: const [],
    );

    test('a new user starts with an empty reserve', () async {
      final s = await endpoints.pepite.status(as(alice), today);
      expect(s.seeds, 0);
      expect(s.weeks, 0);
      expect(s.doneThisWeek, isFalse);
      expect(s.badges, isEmpty);
    });

    test('the ritual gives seeds and the first badge once a week', () async {
      final first = await endpoints.pepite.completeRitual(as(alice), today);
      expect(first.doneThisWeek, isTrue);
      expect(first.weeks, 1);
      expect(first.newBadges, ['first_ritual']);
      expect(
        first.seeds,
        PepiteEndpoint.ritualSeeds + PepiteEndpoint.badgeSeeds,
      );
      expect(first.earnedSeeds, first.seeds);

      final again = await endpoints.pepite.completeRitual(as(alice), today);
      expect(again.weeks, 1);
      expect(again.seeds, first.seeds);
      expect(again.earnedSeeds, 0);
      expect(again.newBadges, isEmpty);
      expect(again.badges, ['first_ritual']);
    });

    test('a new week counts again, a missed one resets nothing', () async {
      await endpoints.pepite.completeRitual(as(alice), today);
      // Pretend the last ritual was three weeks ago.
      final p = (await PepiteProgress.db.findFirstRow(
        db,
        where: (p) => p.authUserId.equals(alice),
      ))!;
      await PepiteProgress.db.updateRow(
        db,
        p.copyWith(lastWeek: p.lastWeek!.subtract(const Duration(days: 21))),
      );
      final before = await endpoints.pepite.status(as(alice), today);
      expect(before.doneThisWeek, isFalse);
      expect(before.weeks, 1);

      final s = await endpoints.pepite.completeRitual(as(alice), today);
      expect(s.weeks, 2);
      expect(s.doneThisWeek, isTrue);
      expect(s.earnedSeeds, PepiteEndpoint.ritualSeeds);
    });

    test('four weeks earn the weeks_4 badge', () async {
      await PepiteProgress.db.insertRow(
        db,
        PepiteProgress(authUserId: alice, seeds: 0, weeks: 3),
      );
      final s = await endpoints.pepite.completeRitual(as(alice), today);
      expect(s.weeks, 4);
      expect(s.newBadges, containsAll(['first_ritual', 'weeks_4']));
      expect(s.newBadges, isNot(contains('weeks_12')));
    });

    test('a first import earns its badge', () async {
      final group = (await endpoints.group.create(as(alice), 'A')).group.id!;
      final account = await endpoints.account.create(
        as(alice),
        group,
        'Courant',
        AccountKind.checking,
      );
      await StatementImport.db.insertRow(
        db,
        StatementImport(
          accountId: account.id!,
          format: 'qif',
          fileName: 'releve.qif',
          fileHash: 'x',
          encoding: 'utf-8',
          readCount: 0,
          addedCount: 0,
          duplicateCount: 0,
          possibleDuplicateCount: 0,
          errorCount: 0,
          classifiedCount: 0,
          authorId: alice,
        ),
      );
      final s = await endpoints.pepite.status(as(alice), today);
      expect(s.newBadges, ['first_import']);
      expect(s.seeds, PepiteEndpoint.badgeSeeds);
      // Not twice.
      final again = await endpoints.pepite.status(as(alice), today);
      expect(again.newBadges, isEmpty);
      expect(again.seeds, PepiteEndpoint.badgeSeeds);
      // Alice's import is not Mallory's.
      final other = await endpoints.pepite.status(as(mallory), today);
      expect(other.badges, isEmpty);
    });

    test("another user's reserve stays theirs", () async {
      await endpoints.pepite.completeRitual(as(alice), today);
      final m = await endpoints.pepite.status(as(mallory), today);
      expect(m.seeds, 0);
      expect(m.weeks, 0);
      expect(m.badges, isEmpty);
      await endpoints.pepite.completeRitual(as(mallory), today);
      final a = await endpoints.pepite.status(as(alice), today);
      expect(a.weeks, 1);
      expect(
        a.seeds,
        PepiteEndpoint.ritualSeeds + PepiteEndpoint.badgeSeeds,
      );
    });

    test('a date far from the server is ignored', () async {
      final s = await endpoints.pepite.completeRitual(
        as(alice),
        today.add(const Duration(days: 30)),
      );
      expect(s.weeks, 1);
      // Same server week: a forged future date does not count twice.
      final again = await endpoints.pepite.completeRitual(
        as(alice),
        today.add(const Duration(days: 60)),
      );
      expect(again.weeks, 1);
    });

    test('adopt takes a standalone reserve into an empty account', () async {
      final last = DateTime.utc(2026, 10, 28);
      final ok = await endpoints.pepite.adopt(
        as(alice),
        empty(
          seeds: 55,
          weeks: 4,
          badges: ['first_ritual', 'weeks_4', 'weeks_4', 'not_a_badge'],
          last: last,
        ),
      );
      expect(ok, isTrue);
      final s = await endpoints.pepite.status(as(alice), today);
      expect(s.weeks, 4);
      expect(s.seeds, 55);
      expect(s.badges, unorderedEquals(['first_ritual', 'weeks_4']));
      expect(s.doneThisWeek, isFalse);
    });

    test('adopt clamps the seeds to what could have been earned', () async {
      await endpoints.pepite.adopt(as(alice), empty(seeds: 1000000, weeks: 1));
      final s = await endpoints.pepite.status(as(alice), today);
      // One week and every badge at most, then first_ritual given now.
      expect(
        s.seeds,
        PepiteEndpoint.ritualSeeds +
            PepiteEndpoint.badgeCodes.length * PepiteEndpoint.badgeSeeds +
            PepiteEndpoint.badgeSeeds,
      );
      expect(s.newBadges, ['first_ritual']);
    });

    test('adopt never adds to an existing reserve', () async {
      await endpoints.pepite.completeRitual(as(alice), today);
      final before = await endpoints.pepite.status(as(alice), today);
      final ok = await endpoints.pepite.adopt(
        as(alice),
        empty(seeds: 50, weeks: 5, badges: ['weeks_4']),
      );
      expect(ok, isFalse);
      final after = await endpoints.pepite.status(as(alice), today);
      expect(after.seeds, before.seeds);
      expect(after.weeks, before.weeks);
      expect(after.badges, before.badges);
    });

    test('adopt only touches the caller', () async {
      await endpoints.pepite.adopt(as(alice), empty(seeds: 20, weeks: 2));
      final m = await endpoints.pepite.status(as(mallory), today);
      expect(m.seeds, 0);
      expect(m.weeks, 0);
    });

    test('needs a signed-in user', () async {
      await expectLater(
        endpoints.pepite.status(sessionBuilder, today),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      await expectLater(
        endpoints.pepite.completeRitual(sessionBuilder, today),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      await expectLater(
        endpoints.pepite.adopt(sessionBuilder, empty(seeds: 10, weeks: 1)),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}
