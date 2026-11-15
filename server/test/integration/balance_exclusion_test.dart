import 'package:owncoffer_server/src/core/dates.dart';
import 'package:owncoffer_server/src/endpoints/category_endpoint.dart';
import 'package:owncoffer_server/src/finance/forecast_service.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Balance exclusion (decision 0051)', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue alice, mallory, reader;
    late int groupA, groupB;
    late Account accountA;
    late Category cardSettlementCategory, normalCategory, categoryB;

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    DateTime day(int offset) => today.add(Duration(days: offset));

    final denied = throwsA(isA<AccessDeniedException>());
    final invalid = throwsA(isA<InvalidInputException>());

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );

    Future<UuidValue> makeUser([Set<String> scopes = const {}]) async =>
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
      alice = await makeUser({'owncoffer.serverAdmin'});
      mallory = await makeUser({'owncoffer.serverAdmin'});
      reader = await makeUser();

      groupA = (await endpoints.group.create(as(alice), 'Famille A')).group.id!;
      await GroupMember.db.insertRow(
        db,
        GroupMember(
          groupId: groupA,
          authUserId: reader,
          role: MemberRole.reader,
        ),
      );

      groupB = (await endpoints.group.create(
        as(mallory),
        'Mallory Group',
      )).group.id!;

      accountA = await endpoints.account.create(
        as(alice),
        groupA,
        'Compte courant A',
        AccountKind.checking,
        initialBalanceCents: 100000, // 1000.00 €
      );
      await endpoints.account.create(
        as(mallory),
        groupB,
        'Compte B',
        AccountKind.checking,
        initialBalanceCents: 50000,
      );

      cardSettlementCategory = (await Category.db.findFirstRow(
        db,
        where: (c) =>
            c.groupId.equals(groupA) &
            c.standardCode.equals('transfers.card_settlement'),
      ))!;
      normalCategory = (await Category.db.findFirstRow(
        db,
        where: (c) =>
            c.groupId.equals(groupA) & c.standardCode.equals('food.groceries'),
      ))!;
      categoryB = (await Category.db.findFirstRow(
        db,
        where: (c) =>
            c.groupId.equals(groupB) &
            c.standardCode.equals('transfers.card_settlement'),
      ))!;
    });

    test(
      'standard card settlement category defaults to excludedFromBalance = true',
      () {
        expect(cardSettlementCategory.excludedFromBalance, isTrue);
        expect(normalCategory.excludedFromBalance, isFalse);
      },
    );

    test(
      'setExcludedFromBalance modifies category and verifies isolation',
      () async {
        // Alice can toggle excludedFromBalance on her group's category
        final updated = await endpoints.category.setExcludedFromBalance(
          as(alice),
          normalCategory.id!,
          true,
        );
        expect(updated.excludedFromBalance, isTrue);

        // Mallory from group B cannot modify group A's category
        await expectLater(
          endpoints.category.setExcludedFromBalance(
            as(mallory),
            normalCategory.id!,
            false,
          ),
          denied,
        );

        // Reader in group A cannot modify category
        await expectLater(
          endpoints.category.setExcludedFromBalance(
            as(reader),
            normalCategory.id!,
            false,
          ),
          denied,
        );

        // Alice cannot modify group B's category
        await expectLater(
          endpoints.category.setExcludedFromBalance(
            as(alice),
            categoryB.id!,
            true,
          ),
          denied,
        );
      },
    );

    test(
      'setBalanceOverride modifies transaction and verifies isolation and closing',
      () async {
        final op = await BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: accountA.id!,
            date: today,
            amountCents: -5000,
            rawLabel: 'DEBIT DIFFERE CB',
            cleanLabel: 'Débit différé',
            operationKind: 'transfer',
            categoryId: cardSettlementCategory.id,
          ),
        );

        // Alice sets override to true (forced in balance)
        final t1 = await endpoints.transaction.setBalanceOverride(
          as(alice),
          op.id!,
          true,
        );
        expect(t1.balanceOverride, isTrue);

        // Alice sets override to false (forced out of balance)
        final t2 = await endpoints.transaction.setBalanceOverride(
          as(alice),
          op.id!,
          false,
        );
        expect(t2.balanceOverride, isFalse);

        // Alice resets override to null (follows category)
        final t3 = await endpoints.transaction.setBalanceOverride(
          as(alice),
          op.id!,
          null,
        );
        expect(t3.balanceOverride, isNull);

        // Mallory cannot modify Alice's transaction
        await expectLater(
          endpoints.transaction.setBalanceOverride(
            as(mallory),
            op.id!,
            true,
          ),
          denied,
        );

        // Reader cannot modify transaction
        await expectLater(
          endpoints.transaction.setBalanceOverride(
            as(reader),
            op.id!,
            true,
          ),
          denied,
        );

        // Month closing blocks balance override modification
        await endpoints.group.setClosedUntil(
          as(alice),
          groupA,
          today,
        );
        await expectLater(
          endpoints.transaction.setBalanceOverride(
            as(alice),
            op.id!,
            true,
          ),
          invalid,
        );
      },
    );

    test('balancesOf excludes category operations and respects overrides', () async {
      final t = today.toLocalDate();

      // 1. Normal purchase: -30.00 € (cleared)
      await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: accountA.id!,
          date: today,
          amountCents: -3000,
          rawLabel: 'SUPERMARCHE',
          cleanLabel: 'Supermarché',
          operationKind: 'card',
          categoryId: normalCategory.id,
          cleared: true,
        ),
      );

      // 2. Deferred card settlement: -30.00 € (cleared, in excluded category)
      final settlement = await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: accountA.id!,
          date: today,
          amountCents: -3000,
          rawLabel: 'TOTAL CB DIFFERE',
          cleanLabel: 'Total CB différé',
          operationKind: 'transfer',
          categoryId: cardSettlementCategory.id,
          cleared: true,
        ),
      );

      // Initial = 1000.00 € (100000).
      // Normal purchase (-3000) counts -> 970.00 € (97000).
      // Card settlement (-3000) is excluded from balance -> does NOT double-deduct!
      var b = await ForecastService.balancesOf(db, accountA, t);
      expect(b.clearedCents, equals(97000));
      expect(b.currentCents, equals(97000));

      // Override settlement with balanceOverride = true -> now it is included: 940.00 €
      await endpoints.transaction.setBalanceOverride(
        as(alice),
        settlement.id!,
        true,
      );
      b = await ForecastService.balancesOf(db, accountA, t);
      expect(b.clearedCents, equals(94000));
      expect(b.currentCents, equals(94000));

      // Override settlement with balanceOverride = false -> excluded again: 970.00 €
      await endpoints.transaction.setBalanceOverride(
        as(alice),
        settlement.id!,
        false,
      );
      b = await ForecastService.balancesOf(db, accountA, t);
      expect(b.clearedCents, equals(97000));
      expect(b.currentCents, equals(97000));
    });

    test('checkBalance respects balance exclusion', () async {
      // Normal purchase: -20.00 €
      await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: accountA.id!,
          date: today,
          amountCents: -2000,
          rawLabel: 'SUPERMARCHE',
          cleanLabel: 'Supermarché',
          operationKind: 'card',
          categoryId: normalCategory.id,
          cleared: false,
        ),
      );

      // Settlement: -20.00 € (in excluded category)
      await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: accountA.id!,
          date: today,
          amountCents: -2000,
          rawLabel: 'TOTAL CB',
          cleanLabel: 'Total CB',
          operationKind: 'transfer',
          categoryId: cardSettlementCategory.id,
          cleared: false,
        ),
      );

      // Initial = 100000. Normal = -2000. Settlement is excluded.
      // Computed = 98000, Uncleared = -2000.
      final check = await endpoints.account.checkBalance(
        as(alice),
        accountA.id!,
        today,
        98000,
      );
      expect(check.computedCents, equals(98000));
      expect(check.differenceCents, equals(0));
      expect(check.unclearedManualCents, equals(-2000));
    });

    test('forecast ignores future operations excluded from balance', () async {
      final t = today.toLocalDate();
      final futureDate = day(5);

      // Future excluded settlement: -50.00 €
      await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: accountA.id!,
          date: futureDate,
          amountCents: -5000,
          rawLabel: 'CB DIFFERE FUTUR',
          cleanLabel: 'CB différé futur',
          operationKind: 'transfer',
          categoryId: cardSettlementCategory.id,
        ),
      );

      final f = await ForecastService.compute(
        db,
        accountA,
        t,
        horizonDays: 10,
      );

      // Initial balance is 1000.00 € (100000 cents).
      // Future excluded settlement should not deduct from any day in forecast!
      for (final day in f.days) {
        expect(day.balanceCents, equals(100000));
      }
    });

    test(
      'forecast ignores scheduled operations in category excluded from balance',
      () async {
        final t = today.toLocalDate();
        final futureDate = day(3);

        await endpoints.scheduled.create(
          as(alice),
          accountA.id!,
          -15000,
          'Prélèvement CB différé prévu',
          ScheduleFrequency.monthly,
          futureDate,
          categoryId: cardSettlementCategory.id,
        );

        final f = await ForecastService.compute(
          db,
          accountA,
          t,
          horizonDays: 10,
        );

        // Initial balance is 100000 cents.
        // Scheduled card settlement is in excluded category -> should not deduct!
        for (final day in f.days) {
          expect(day.balanceCents, equals(100000));
        }
      },
    );

    test(
      'updateAllStandardCategories preserves user choice on excludedFromBalance',
      () async {
        // Alice enables card settlement in balance
        await endpoints.category.setExcludedFromBalance(
          as(alice),
          cardSettlementCategory.id!,
          false,
        );

        var cat = await Category.db.findById(db, cardSettlementCategory.id!);
        expect(cat!.excludedFromBalance, isFalse);

        // Server restarts and runs updateAllStandardCategories
        await updateAllStandardCategories(db);

        // User's choice must NOT be reverted to true
        cat = await Category.db.findById(db, cardSettlementCategory.id!);
        expect(cat!.excludedFromBalance, isFalse);
      },
    );
  });
}
