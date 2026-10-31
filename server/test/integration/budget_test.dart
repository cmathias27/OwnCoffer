import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Budget: report, goals, month start, subscriptions', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue alice, mallory, reader, bob;
    late int groupA, groupB;
    late Account shared, restricted;
    late Map<String, Category> cats;
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

    Future<BankTransaction> op(
      Account a,
      DateTime date,
      int cents,
      String label, {
      String? category,
    }) => BankTransaction.db.insertRow(
      db,
      BankTransaction(
        accountId: a.id!,
        date: date,
        amountCents: cents,
        rawLabel: label,
        cleanLabel: label,
        operationKind: 'card',
        categoryId: category == null ? null : cats[category]!.id,
      ),
    );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({'owncoffer.serverAdmin'});
      reader = await user({});
      bob = await user({});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      groupB = (await endpoints.group.create(as(mallory), 'B')).group.id!;
      for (final (u, role) in [
        (reader, MemberRole.reader),
        (bob, MemberRole.user),
      ]) {
        await GroupMember.db.insertRow(
          db,
          GroupMember(groupId: groupA, authUserId: u, role: role),
        );
      }
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
      cats = {
        for (final c in await endpoints.category.list(as(alice), groupA))
          c.standardCode!: c,
      };
    });

    Future<void> october() async {
      await op(
        shared,
        DateTime.utc(2026, 10, 2),
        -8000,
        'LIDL',
        category: 'food.groceries',
      );
      await op(
        shared,
        DateTime.utc(2026, 10, 9),
        -2500,
        'PIZZA',
        category: 'food.restaurants',
      );
      await op(
        shared,
        DateTime.utc(2026, 10, 27),
        250000,
        'SALAIRE',
        category: 'income.salary',
      );
      await op(
        shared,
        DateTime.utc(2026, 10, 15),
        -50000,
        'VIR LIVRET',
        category: 'transfers.between_accounts',
      );
      await op(shared, DateTime.utc(2026, 10, 20), -1234, 'INCONNU');
      await op(
        shared,
        DateTime.utc(2026, 9, 5),
        -6000,
        'LIDL',
        category: 'food.groceries',
      );
      await op(
        restricted,
        DateTime.utc(2026, 10, 3),
        -99900,
        'SECRET',
        category: 'shopping.clothing',
      );
    }

    test('month report: totals, ranking by category, previous period, '
        'history; restricted accounts follow visibility', () async {
      await october();
      final r = await endpoints.analysis.report(
        as(bob),
        groupA,
        BudgetPeriod.month,
        DateTime.utc(2026, 10, 15),
      );
      expect(r.start, DateTime.utc(2026, 10, 1));
      expect(r.last, DateTime.utc(2026, 10, 31));
      expect(r.incomeCents, 250000);
      expect(r.expenseCents, 8000 + 2500 + 1234, reason: 'transfer left out');
      expect(r.unclassifiedCount, 1);
      CategoryFlow flow(String code) =>
          r.categories.firstWhere((f) => f.categoryId == cats[code]!.id);
      expect(flow('food').amountCents, 10500);
      expect(flow('food').count, 2);
      expect(flow('food').previousCents, 6000);
      expect(flow('food.groceries').averageCents, 2000, reason: '6000 / 3');
      expect(
        r.categories.any((f) => f.categoryId == cats['shopping.clothing']!.id),
        isFalse,
        reason: 'bob cannot see the restricted account',
      );
      expect(r.history, hasLength(6));
      expect(r.history.last.start, DateTime.utc(2026, 10, 1));
      expect(r.history[4].expenseCents, 6000);

      final admin = await endpoints.analysis.report(
        as(alice),
        groupA,
        BudgetPeriod.month,
        DateTime.utc(2026, 10, 15),
      );
      expect(admin.expenseCents, r.expenseCents + 99900);
    });

    test('week and year reports', () async {
      await october();
      final w = await endpoints.analysis.report(
        as(alice),
        groupA,
        BudgetPeriod.week,
        DateTime.utc(2026, 10, 9),
      );
      expect(w.start, DateTime.utc(2026, 10, 5));
      expect(w.expenseCents, 2500);
      final y = await endpoints.analysis.report(
        as(alice),
        groupA,
        BudgetPeriod.year,
        DateTime.utc(2026, 3, 1),
      );
      expect(y.start, DateTime.utc(2026, 1, 1));
      expect(y.expenseCents, 8000 + 2500 + 1234 + 6000 + 99900);
    });

    test('operations behind a figure: category with sub-categories, '
        'unclassified, largest first', () async {
      await october();
      final food = await endpoints.analysis.operations(
        as(alice),
        groupA,
        BudgetPeriod.month,
        DateTime.utc(2026, 10, 1),
        categoryId: cats['food']!.id,
      );
      expect(food.map((t) => t.amountCents), [-8000, -2500]);
      final none = await endpoints.analysis.operations(
        as(alice),
        groupA,
        BudgetPeriod.month,
        DateTime.utc(2026, 10, 1),
        unclassified: true,
      );
      expect(none.map((t) => t.rawLabel), ['INCONNU']);
    });

    test('month start day moves the budget month', () async {
      await october();
      await expectLater(
        endpoints.group.setMonthStartDay(as(bob), groupA, 27),
        denied,
        reason: 'admins only',
      );
      await expectLater(
        endpoints.group.setMonthStartDay(as(alice), groupA, 29),
        throwsA(isA<InvalidInputException>()),
      );
      await endpoints.group.setMonthStartDay(as(alice), groupA, 27);
      final r = await endpoints.analysis.report(
        as(alice),
        groupA,
        BudgetPeriod.month,
        DateTime.utc(2026, 10, 30),
      );
      expect(r.start, DateTime.utc(2026, 10, 27));
      expect(r.last, DateTime.utc(2026, 11, 26));
      expect(r.incomeCents, 250000);
      expect(r.expenseCents, 0);
    });

    test('goals: expense categories only, shown in the month report', () async {
      await october();
      final food = cats['food']!.id!;
      await endpoints.goal.set(as(bob), groupA, food, 10000);
      final g = await endpoints.goal.set(as(bob), groupA, food, 12000);
      expect(g.amountCents, 12000);
      expect(await endpoints.goal.list(as(reader), groupA), hasLength(1));
      await expectLater(
        endpoints.goal.set(as(bob), groupA, cats['income']!.id!, 100),
        throwsA(isA<InvalidInputException>()),
      );
      await expectLater(
        endpoints.goal.set(as(bob), groupA, food, 0),
        throwsA(isA<InvalidInputException>()),
      );
      await expectLater(
        endpoints.goal.set(as(reader), groupA, food, 100),
        denied,
      );
      final r = await endpoints.analysis.report(
        as(alice),
        groupA,
        BudgetPeriod.month,
        DateTime.utc(2026, 10, 1),
      );
      expect(
        r.categories.firstWhere((f) => f.categoryId == food).goalCents,
        12000,
      );
      await endpoints.goal.remove(as(bob), groupA, food);
      expect(await endpoints.goal.list(as(alice), groupA), isEmpty);
    });

    test('subscriptions: from an operation, monthly total, flag', () async {
      final now = DateTime.now().toUtc();
      final netflix = await op(
        shared,
        DateTime.utc(now.year, now.month, now.day - 3),
        -1399,
        'NETFLIX',
        category: 'subscriptions.streaming',
      );
      final s = await endpoints.scheduled.subscribeFrom(as(bob), netflix.id!);
      expect(s.subscription, isTrue);
      expect(s.amountCents, -1399);
      expect(s.frequency, ScheduleFrequency.monthly);
      expect(s.categoryId, cats['subscriptions.streaming']!.id);
      expect(s.nextDue, isNotNull, reason: 'the operation is the first one');
      final linked = await BankTransaction.db.findById(db, netflix.id!);
      expect(linked!.scheduledId, s.id);
      expect(
        (await endpoints.scheduled.subscribeFrom(as(bob), netflix.id!)).id,
        s.id,
        reason: 'no duplicate',
      );
      await endpoints.scheduled.create(
        as(alice),
        shared.id!,
        -12000,
        'ASSURANCE',
        ScheduleFrequency.yearly,
        DateTime.utc(now.year, now.month, now.day),
        subscription: true,
      );
      final o = await endpoints.scheduled.subscriptions(as(reader), groupA);
      expect(o.items, hasLength(2));
      expect(o.monthlyTotalCents, -1399 - 1000);
      expect(o.yearlyTotalCents, (-1399 - 1000) * 12);
      await endpoints.scheduled.update(as(alice), s.id!, subscription: false);
      expect(
        (await endpoints.scheduled.subscriptions(as(alice), groupA)).items,
        hasLength(1),
      );
    });

    test('operations list: subscriptions filter and marks', () async {
      final now = DateTime.now().toUtc();
      final day = DateTime.utc(now.year, now.month, now.day - 3);
      final netflix = await op(shared, day, -1399, 'NETFLIX');
      final rent = await op(shared, day, -70000, 'LOYER');
      await op(shared, day, -2500, 'HYPER');
      final s = await endpoints.scheduled.subscribeFrom(as(bob), netflix.id!);
      // A planned operation that is not a subscription.
      final planned = await endpoints.scheduled.create(
        as(alice),
        shared.id!,
        -70000,
        'LOYER',
        ScheduleFrequency.monthly,
        day,
      );
      await BankTransaction.db.updateRow(
        db,
        rent.copyWith(scheduledId: planned.id),
      );

      final all = await endpoints.transaction.list(as(reader), shared.id!);
      expect(all.total, 3);
      expect(all.subscriptions.map((x) => x.id), [s.id]);
      final only = await endpoints.transaction.list(
        as(reader),
        shared.id!,
        subscriptions: true,
      );
      expect(only.items.map((t) => t.id), [netflix.id]);
      expect(only.total, 1);

      await endpoints.scheduled.update(as(alice), s.id!, subscription: false);
      final none = await endpoints.transaction.list(
        as(reader),
        shared.id!,
        subscriptions: true,
      );
      expect(none.items, isEmpty);
      expect(none.subscriptions, isEmpty);
    });

    test('operations list: a category with its sub-categories', () async {
      await october();
      final page = await endpoints.transaction.list(
        as(alice),
        shared.id!,
        categoryId: cats['food']!.id,
        includeSubcategories: true,
      );
      expect(page.total, 3);
      final only = await endpoints.transaction.list(
        as(alice),
        shared.id!,
        categoryId: cats['food']!.id,
      );
      expect(only.total, 0);
    });

    group('isolation', () {
      test(
        'another group cannot read reports, goals or subscriptions',
        () async {
          await october();
          final t = DateTime.utc(2026, 10, 1);
          await expectLater(
            endpoints.analysis.report(
              as(mallory),
              groupA,
              BudgetPeriod.month,
              t,
            ),
            denied,
          );
          await expectLater(
            endpoints.analysis.report(
              as(mallory),
              groupB,
              BudgetPeriod.month,
              t,
              accountId: shared.id,
            ),
            denied,
          );
          await expectLater(
            endpoints.analysis.operations(
              as(mallory),
              groupB,
              BudgetPeriod.month,
              t,
              categoryId: cats['food']!.id,
            ),
            denied,
          );
          await expectLater(
            endpoints.analysis.operations(
              as(bob),
              groupA,
              BudgetPeriod.month,
              t,
              accountId: restricted.id,
            ),
            denied,
          );
          await expectLater(endpoints.goal.list(as(mallory), groupA), denied);
          await expectLater(
            endpoints.goal.set(as(mallory), groupB, cats['food']!.id!, 100),
            denied,
          );
          await endpoints.goal.set(as(alice), groupA, cats['food']!.id!, 100);
          await endpoints.goal.remove(as(mallory), groupB, cats['food']!.id!);
          await expectLater(
            endpoints.goal.remove(as(mallory), groupA, cats['food']!.id!),
            denied,
          );
          expect(await endpoints.goal.list(as(alice), groupA), hasLength(1));
          await expectLater(
            endpoints.scheduled.subscriptions(as(mallory), groupA),
            denied,
          );
          await expectLater(
            endpoints.transaction.list(
              as(mallory),
              shared.id!,
              subscriptions: true,
            ),
            denied,
          );
          final o = await op(shared, DateTime.utc(2026, 10, 1), -999, 'X');
          await expectLater(
            endpoints.scheduled.subscribeFrom(as(mallory), o.id!),
            denied,
          );
          await expectLater(
            endpoints.scheduled.subscribeFrom(as(reader), o.id!),
            denied,
          );
          await expectLater(
            endpoints.group.setMonthStartDay(as(mallory), groupA, 5),
            denied,
          );
          expect(
            (await FinanceGroup.db.findById(db, groupA))!.monthStartDay,
            1,
          );
        },
      );
    });
  });
}
