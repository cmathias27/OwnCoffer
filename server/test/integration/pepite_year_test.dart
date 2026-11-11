import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/pepite/pepite_year.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// « Ton année avec Pépite » (decisions 0028 point 7, 0031): from the user's
/// own doings and the accounts they may see, never another's.
void main() {
  withServerpod('Pépite: your year', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, mallory;
    late int groupA, groupB;
    late Account account;
    late Map<String, Category> cats;
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final day = core.LocalDate(today.year, today.month, today.day);

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
    Future<PepiteYear> year(UuidValue u, int y) =>
        PepiteYears.of(db, u, y, day);
    Future<void> spend(Account a, DateTime date, int cents) =>
        BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: a.id!,
            date: date,
            amountCents: -cents,
            rawLabel: 'CB MAGASIN',
            cleanLabel: 'MAGASIN',
            operationKind: 'card',
            categoryId: cats['food']!.id,
          ),
        );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user();
      mallory = await user();
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      groupB = (await endpoints.group.create(as(mallory), 'B')).group.id!;
      account = await endpoints.account.create(
        as(alice),
        groupA,
        'Courant',
        AccountKind.checking,
      );
      cats = {
        for (final c in await endpoints.category.list(as(alice), groupA))
          c.standardCode!: c,
      };
    });

    test('a new user: an empty year', () async {
      final y = await year(alice, today.year);
      expect(y.weeks, 0);
      expect(y.badges, isEmpty);
      expect(y.seeds, 0);
      expect(y.goalMonthsTracked, 0);
      expect(y.bestCategory, isNull);
      expect(y.subscriptionsStopped, 0);
    });

    test('weeks, badges, challenges and their seeds', () async {
      await endpoints.pepite.completeRitual(as(alice), today);
      await endpoints.pepite.chooseChallenge(as(alice), 'goal_1', today);
      await endpoints.goal.set(as(alice), groupA, cats['food']!.id!, 20000);
      final s = await endpoints.pepite.status(as(alice), today);
      expect(s.challenge!.done, isTrue);
      final y = await year(alice, today.year);
      expect(y.weeks, 1);
      expect(y.badges, containsAll(['first_ritual', 'first_goal']));
      expect(y.challenges, 1);
      expect(y.seeds, 10 + y.badges.length * 5 + 10);
      expect(y.seeds, s.seeds);
      // Another year: nothing.
      final before = await year(alice, today.year - 1);
      expect(before.weeks, 0);
      expect(before.badges, isEmpty);
      expect(before.challenges, 0);
    });

    test('weeks counted before the marks: the year of the first', () async {
      await PepiteProgress.db.insertRow(
        db,
        PepiteProgress(
          authUserId: alice,
          seeds: 30,
          weeks: 3,
          firstRitualAt: now,
          lastRitualAt: now,
        ),
      );
      expect((await year(alice, today.year)).weeks, 3);
      expect((await year(alice, today.year - 1)).weeks, 0);
    });

    test('subscriptions stopped and what they cost a month', () async {
      Future<ScheduledTransaction> planned({required bool subscription}) =>
          endpoints.scheduled.create(
            as(alice),
            account.id!,
            -999,
            'Abonnement',
            ScheduleFrequency.monthly,
            today,
            subscription: subscription,
          );
      final plain = await planned(subscription: false);
      await endpoints.scheduled.delete(as(alice), plain.id!);
      final sub = await planned(subscription: true);
      await endpoints.scheduled.delete(as(alice), sub.id!);
      final y = await year(alice, today.year);
      expect(y.subscriptionsStopped, 1);
      expect(y.subscriptionsMonthlyCents, 999);
      expect((await year(mallory, today.year)).subscriptionsStopped, 0);
    });

    test('goals: months kept, the best category; only own groups', () async {
      // The last month over (budget months start on the 1st).
      final start = DateTime.utc(today.year, today.month - 1);
      final food = cats['food']!.id!;
      await Goal.db.insertRow(
        db,
        Goal(
          groupId: groupA,
          categoryId: food,
          amountCents: 20000,
          createdAt: start.subtract(const Duration(days: 40)),
        ),
      );
      await spend(account, start.add(const Duration(days: 4)), 19000);
      // The month before: over the goal.
      final earlier = DateTime.utc(start.year, start.month - 1);
      await spend(account, earlier.add(const Duration(days: 2)), 25000);
      final y = await year(alice, start.year);
      final both = earlier.year == start.year;
      expect(y.goalMonthsTracked, both ? 2 : 1);
      expect(y.goalMonthsKept, 1);
      expect(y.bestCategory!.id, food);
      expect(y.bestCategoryMonths, 1);
      // Mallory's year reads only her own group.
      final m = await year(mallory, start.year);
      expect(m.goalMonthsTracked, 0);
      expect(m.bestCategory, isNull);
      expect(groupB, isNot(groupA));
    });

    test('the endpoint: past years only, signed in', () async {
      await expectLater(
        endpoints.pepite.year(as(alice), today.year + 1, today),
        throwsA(isA<InvalidInputException>()),
      );
      await expectLater(
        endpoints.pepite.year(as(alice), 1999, today),
        throwsA(isA<InvalidInputException>()),
      );
      final y = await endpoints.pepite.year(as(alice), today.year - 1, today);
      expect(y.year, today.year - 1);
      // The current year from December only.
      final current = endpoints.pepite.year(as(alice), today.year, today);
      if (today.month == DateTime.december) {
        expect((await current).year, today.year);
      } else {
        await expectLater(current, throwsA(isA<InvalidInputException>()));
      }
      await expectLater(
        endpoints.pepite.year(sessionBuilder, today.year - 1, today),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}
