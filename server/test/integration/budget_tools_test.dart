import 'package:owncoffer_server/src/core/dates.dart';
import 'package:owncoffer_server/src/finance/goal_alert_service.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Budget tools (0.3.0)', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, mallory, reader, bob;
    late int groupA;
    late Account shared, restricted;
    late Map<String, int> cats;
    final denied = throwsA(isA<AccessDeniedException>());
    final invalid = throwsA(isA<InvalidInputException>());
    final now = DateTime.now().toUtc();
    final today = core.LocalDate(now.year, now.month, now.day);
    // Budget months start on the 1st (group default).
    DateTime month(int ago) => DateTime.utc(now.year, now.month - ago, 1);
    final monthLast = core.LocalDate(
      now.year,
      now.month,
      1,
    ).addMonths(1).addDays(-1);

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
      int cents, {
      String label = 'MAGASIN',
      String? category,
      bool cleared = false,
    }) => BankTransaction.db.insertRow(
      db,
      BankTransaction(
        accountId: a.id!,
        date: date,
        amountCents: cents,
        rawLabel: 'CB $label',
        cleanLabel: label,
        operationKind: 'card',
        categoryId: category == null ? null : cats[category],
        categorySource: category == null
            ? CategorySource.none
            : CategorySource.manual,
        cleared: cleared,
      ),
    );
    Future<BankTransaction> reread(BankTransaction t) async =>
        (await BankTransaction.db.findById(db, t.id!))!;

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({'owncoffer.serverAdmin'});
      reader = await user({});
      bob = await user({});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      await endpoints.group.create(as(mallory), 'B');
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
          c.standardCode!: c.id!,
      };
    });

    group('split', () {
      test('parts count in the budget and the category filters; one '
          'category again removes the split', () async {
        final t = await op(
          shared,
          month(0),
          -10000,
          category: 'food.groceries',
        );
        final split = await endpoints.transaction.setSplits(as(bob), t.id!, [
          TransactionSplit(
            transactionId: 0,
            categoryId: cats['food.groceries'],
            amountCents: -6000,
          ),
          TransactionSplit(
            transactionId: 0,
            categoryId: cats['banking.bank_fees'],
            amountCents: -4000,
            note: ' frais ',
          ),
        ]);
        expect(split.categoryId, cats['food.groceries']);
        expect(split.categorySource, CategorySource.manual);
        final parts = await endpoints.transaction.splits(as(reader), t.id!);
        expect([for (final p in parts) p.amountCents], [-6000, -4000]);
        expect(parts.last.note, 'frais');

        final r = await endpoints.analysis.report(
          as(reader),
          groupA,
          BudgetPeriod.month,
          month(0),
        );
        int flow(String code) => r.categories
            .firstWhere((c) => c.categoryId == cats[code])
            .amountCents;
        expect(flow('food.groceries'), 6000);
        expect(flow('banking.bank_fees'), 4000);
        expect(r.expenseCents, 10000);

        final fees = await endpoints.transaction.list(
          as(reader),
          shared.id!,
          categoryId: cats['banking.bank_fees'],
        );
        expect([for (final x in fees.items) x.id], [t.id]);

        await endpoints.transaction.setCategory(
          as(bob),
          t.id!,
          cats['food.groceries'],
        );
        expect(await endpoints.transaction.splits(as(bob), t.id!), isEmpty);
      });

      test('invalid splits are refused', () async {
        final t = await op(shared, month(0), -10000);
        TransactionSplit p(int c) => TransactionSplit(
          transactionId: 0,
          categoryId: cats['food.groceries'],
          amountCents: c,
        );
        await expectLater(
          endpoints.transaction.setSplits(as(bob), t.id!, [p(-6000), p(-3000)]),
          invalid,
        );
        await expectLater(
          endpoints.transaction.setSplits(as(bob), t.id!, [p(-10000)]),
          invalid,
        );
        await expectLater(
          endpoints.transaction.setSplits(as(bob), t.id!, [p(-12000), p(2000)]),
          invalid,
        );
      });

      test('isolation: another group or a reader cannot split, another '
          "group's category cannot be used", () async {
        final t = await op(shared, month(0), -10000);
        final parts = [
          TransactionSplit(transactionId: 0, amountCents: -5000),
          TransactionSplit(transactionId: 0, amountCents: -5000),
        ];
        await expectLater(
          endpoints.transaction.setSplits(as(mallory), t.id!, parts),
          denied,
        );
        await expectLater(
          endpoints.transaction.setSplits(as(reader), t.id!, parts),
          denied,
        );
        await expectLater(
          endpoints.transaction.splits(as(mallory), t.id!),
          denied,
        );
        final foreign = (await Category.db.findFirstRow(
          db,
          where: (c) => c.groupId.notEquals(groupA),
        ))!;
        await expectLater(
          endpoints.transaction.setSplits(as(bob), t.id!, [
            parts.first.copyWith(categoryId: foreign.id),
            parts.last,
          ]),
          denied,
        );
        expect(await TransactionSplit.db.count(db), 0);
      });
    });

    group('goal alerts', () {
      test(
        '80 % then 100 %, once each, on the accounts each member sees',
        () async {
          await endpoints.goal.set(
            as(bob),
            groupA,
            cats['food.groceries']!,
            10000,
          );
          await op(shared, month(0), -8500, category: 'food.groceries');
          expect(await GoalAlertService.checkGroup(db, groupA, today), 3);
          expect(await GoalAlertService.checkGroup(db, groupA, today), 0);
          final warnings = await AppNotification.db.find(
            db,
            where: (n) => n.type.equals(GoalAlertService.warningType),
          );
          expect(
            {for (final n in warnings) n.authUserId},
            {alice, bob, reader},
          );
          expect(warnings.every((n) => n.groupId == groupA), isTrue);

          // Over the goal only with the restricted account: admins see it.
          await op(restricted, month(0), -3000, category: 'food.groceries');
          expect(await GoalAlertService.checkGroup(db, groupA, today), 1);
          final over = await AppNotification.db.find(
            db,
            where: (n) => n.type.equals(GoalAlertService.overType),
          );
          expect([for (final n in over) n.authUserId], [alice]);
          expect(over.single.data, contains('"spentCents":11500'));
          final mine = await AppNotification.db.count(
            db,
            where: (n) => n.authUserId.equals(mallory),
          );
          expect(mine, 0);
        },
      );
    });

    group('left to live', () {
      test(
        'checking accounts, planned operations until the month end',
        () async {
          final savings = await endpoints.account.create(
            as(alice),
            groupA,
            'Livret',
            AccountKind.savings,
          );
          await op(savings, month(0), 500000);
          await op(shared, month(0), 100000);
          await op(restricted, month(0), 70000);
          if (today < monthLast) {
            await endpoints.scheduled.create(
              as(bob),
              shared.id!,
              -30000,
              'LOYER',
              ScheduleFrequency.once,
              monthLast.toDb(),
            );
          }
          final r = await endpoints.analysis.leftToLive(as(bob), groupA);
          expect(r.accountIds, [shared.id], reason: 'no savings, no hidden');
          expect(r.balanceCents, 100000);
          expect(r.plannedDebitsCents, today < monthLast ? -30000 : 0);
          expect(r.leftCents, r.balanceCents + r.plannedDebitsCents);
          expect(r.daysLeft, today.daysUntil(monthLast) + 1);
          expect(r.perDayCents, r.leftCents ~/ r.daysLeft);
          expect(r.last.toLocalDate(), monthLast);

          final admin = await endpoints.analysis.leftToLive(as(alice), groupA);
          expect(admin.balanceCents, 170000);
          await expectLater(
            endpoints.analysis.leftToLive(as(mallory), groupA),
            denied,
          );
          await expectLater(
            endpoints.analysis.leftToLive(
              as(bob),
              groupA,
              accountId: restricted.id,
            ),
            denied,
          );
        },
      );
    });

    group('calendar', () {
      test(
        'occurrences of the month: paid, late or to come, loans marked',
        () async {
          final rent = await endpoints.scheduled.create(
            as(bob),
            shared.id!,
            -50000,
            'LOYER',
            ScheduleFrequency.monthly,
            month(1),
          );
          final paid = await op(shared, month(0), -50000, label: 'LOYER');
          await endpoints.scheduled.confirmMatch(
            as(bob),
            rent.id!,
            month(0),
            paid.id!,
          );
          final last = await endpoints.scheduled.create(
            as(bob),
            shared.id!,
            -2000,
            'DERNIER JOUR',
            ScheduleFrequency.once,
            monthLast.toDb(),
          );
          final loan = await endpoints.loan.create(
            as(bob),
            groupA,
            Loan(
              groupId: 0,
              accountId: shared.id,
              kind: LoanKind.installments,
              lender: 'Alma',
              principalCents: 40000,
              annualRateMilli: 0,
              durationMonths: 4,
              firstDueDate: monthLast.toDb(),
            ),
          );
          expect(loan.paymentCents, 10000);
          await endpoints.scheduled.create(
            as(alice),
            restricted.id!,
            -1000,
            'CACHE',
            ScheduleFrequency.monthly,
            month(1),
          );

          final c = await endpoints.scheduled.calendar(
            as(bob),
            groupA,
            month(0),
          );
          expect(c.start, month(0));
          CalendarItem item(int scheduledId) =>
              c.items.firstWhere((i) => i.scheduledId == scheduledId);
          expect(item(rent.id!).status, OccurrenceStatus.paid);
          expect(item(rent.id!).transactionId, paid.id);
          expect(item(last.id!).status, OccurrenceStatus.upcoming);
          final instalment = item(loan.loan.scheduledId!);
          expect(instalment.loanId, loan.loan.id);
          expect(instalment.amountCents, -10000);
          expect(c.items.any((i) => i.label == 'CACHE'), isFalse);
          // The loan table counts an instalment due today as paid.
          expect(
            instalment.status,
            isIn([
              OccurrenceStatus.upcoming,
              OccurrenceStatus.skipped,
            ]),
          );
          expect(
            c.upcomingDebitsCents,
            -2000 +
                (instalment.status == OccurrenceStatus.upcoming ? -10000 : 0),
          );
          expect(
            [for (final i in c.items) i.date],
            [
              ...[for (final i in c.items) i.date],
            ]..sort(),
          );

          await expectLater(
            endpoints.scheduled.calendar(as(mallory), groupA, month(0)),
            denied,
          );
        },
      );
    });

    group('month review', () {
      test('rises, fees, biggest expenses, subscription changes', () async {
        for (var m = 1; m <= 3; m++) {
          await op(shared, month(m), -10000, category: 'food.groceries');
        }
        await op(shared, month(0), -25000, category: 'food.groceries');
        await op(shared, month(0), -800, category: 'banking.bank_fees');
        final stream = await op(shared, month(1), -999, label: 'NETFLIX');
        final sub = await endpoints.scheduled.subscribeFrom(
          as(bob),
          stream.id!,
        );
        final dearer = await op(shared, month(0), -1299, label: 'NETFLIX');
        await endpoints.scheduled.confirmMatch(
          as(bob),
          sub.id!,
          month(0),
          dearer.id!,
        );
        await op(restricted, month(0), -90000, category: 'food.groceries');

        final r = await endpoints.analysis.review(as(bob), groupA, month(0));
        expect(r.start, month(0));
        final rise = r.rises.firstWhere(
          (c) => c.categoryId == cats['food.groceries'],
        );
        expect(rise.amountCents, 25000);
        expect(rise.averageCents, 10000);
        expect(r.bankFeesCents, 800);
        expect(r.bankFees.single.amountCents, -800);
        expect(
          r.biggestExpenses.first.amountCents,
          -25000,
          reason:
              'hidden '
              'account left out',
        );
        final change = r.subscriptionChanges.single;
        expect(change.plannedCents, -999);
        expect(change.actualCents, -1299);
        expect(r.newSubscriptions.map((s) => s.id), [sub.id]);

        await expectLater(
          endpoints.analysis.review(as(mallory), groupA, month(0)),
          denied,
        );
      });
    });

    group('balance check', () {
      test(
        'gap with the computed balance, uncleared manual operations',
        () async {
          await op(shared, month(0), 100000, cleared: true);
          await op(shared, month(0), -2000);
          final c = await endpoints.account.checkBalance(
            as(bob),
            shared.id!,
            today.toDb(),
            100000,
          );
          expect(c.computedCents, 98000);
          expect(c.differenceCents, -2000);
          expect(c.unclearedManualCents, -2000);
          expect(c.lastImportedDate, isNull);
          final list = await endpoints.account.balanceChecks(
            as(reader),
            shared.id!,
          );
          expect(list.single.id, c.id);
          await expectLater(
            endpoints.account.checkBalance(
              as(bob),
              shared.id!,
              today.addDays(5).toDb(),
              0,
            ),
            invalid,
          );
        },
      );

      test('isolation', () async {
        await expectLater(
          endpoints.account.checkBalance(
            as(mallory),
            shared.id!,
            today.toDb(),
            0,
          ),
          denied,
        );
        await expectLater(
          endpoints.account.checkBalance(
            as(reader),
            shared.id!,
            today.toDb(),
            0,
          ),
          denied,
        );
        await expectLater(
          endpoints.account.checkBalance(
            as(bob),
            restricted.id!,
            today.toDb(),
            0,
          ),
          denied,
        );
        await expectLater(
          endpoints.account.balanceChecks(as(mallory), shared.id!),
          denied,
        );
        expect(await BalanceCheck.db.count(db), 0);
      });
    });

    group('undo', () {
      test(
        'a rule from a correction: removed, operations classified again',
        () async {
          final source = await op(shared, month(0), -1500, label: 'ZZTOP SHOP');
          final other = await op(shared, month(1), -1700, label: 'ZZTOP SHOP');
          final r = await endpoints.transaction.createRuleFrom(
            as(bob),
            source.id!,
            cats['food.groceries']!,
          );
          expect((await reread(other)).categoryId, cats['food.groceries']);
          await expectLater(
            endpoints.rule.undoCreate(as(mallory), r.rule.id!),
            denied,
          );
          // The app first puts the corrected operation back as it was.
          await endpoints.transaction.restoreClassification(
            as(bob),
            source.id!,
            null,
            CategorySource.none,
            null,
            [],
          );
          expect(await endpoints.rule.undoCreate(as(bob), r.rule.id!), 1);
          expect(await Rule.db.findById(db, r.rule.id!), isNull);
          final back = await reread(other);
          expect(back.categoryId, isNull);
          expect(back.categorySource, CategorySource.none);
        },
      );

      test('classification restored as it was, split included', () async {
        final t = await op(shared, month(0), -10000);
        await endpoints.transaction.setSplits(as(bob), t.id!, [
          TransactionSplit(transactionId: 0, amountCents: -5000),
          TransactionSplit(transactionId: 0, amountCents: -5000),
        ]);
        await expectLater(
          endpoints.transaction.restoreClassification(
            as(mallory),
            t.id!,
            null,
            CategorySource.none,
            null,
            [],
          ),
          denied,
        );
        final back = await endpoints.transaction.restoreClassification(
          as(bob),
          t.id!,
          null,
          CategorySource.none,
          null,
          [],
        );
        expect(back.categorySource, CategorySource.none);
        expect(await endpoints.transaction.splits(as(bob), t.id!), isEmpty);

        final again = await endpoints.transaction.restoreClassification(
          as(bob),
          t.id!,
          cats['food.groceries'],
          CategorySource.communityRule,
          'v1-3',
          [
            TransactionSplit(transactionId: 0, amountCents: -7000),
            TransactionSplit(transactionId: 0, amountCents: -3000),
          ],
        );
        expect(again.categorySource, CategorySource.communityRule);
        expect(again.categoryRuleRef, 'v1-3');
        expect(
          await endpoints.transaction.splits(as(bob), t.id!),
          hasLength(2),
        );
      });

      test('a loan declared from an operation, and a subscription', () async {
        final source = await op(shared, month(0), -10000, label: 'PRET X');
        final older = await op(shared, month(1), -10000, label: 'PRET X');
        final r = await endpoints.loan.createFromTransaction(
          as(bob),
          source.id!,
          Loan(
            groupId: 0,
            kind: LoanKind.installments,
            lender: 'X',
            principalCents: 40000,
            annualRateMilli: 0,
            durationMonths: 4,
            firstDueDate: month(1),
          ),
        );
        expect(r.linkedCount, 2);
        expect(r.info.loan.categoryId, cats['banking.installments']);
        await expectLater(
          endpoints.loan.undoCreate(as(mallory), r.info.loan.id!),
          denied,
        );
        await endpoints.transaction.restoreClassification(
          as(bob),
          source.id!,
          null,
          CategorySource.none,
          null,
          [],
        );
        expect(await endpoints.loan.undoCreate(as(bob), r.info.loan.id!), 1);
        final loan = (await Loan.db.findById(db, r.info.loan.id!))!;
        expect(loan.deletedAt, isNotNull);
        expect(await Rule.db.findById(db, r.info.loan.ruleId!), isNull);
        final o = await reread(older);
        expect(o.categoryId, isNull);
        expect(o.scheduledId, isNull);
        final s = (await ScheduledTransaction.db.findById(
          db,
          r.info.loan.scheduledId!,
        ))!;
        expect(s.deletedAt, isNotNull);

        final stream = await op(shared, month(0), -999, label: 'SPOTIFY');
        final sub = await endpoints.scheduled.subscribeFrom(
          as(bob),
          stream.id!,
        );
        expect((await reread(stream)).scheduledId, sub.id);
        await endpoints.scheduled.delete(as(bob), sub.id!);
        expect((await reread(stream)).scheduledId, isNull);
      });
    });
  });
}
