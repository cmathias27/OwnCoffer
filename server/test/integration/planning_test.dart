import 'dart:convert';

import 'package:owncoffer_server/src/finance/follow_up_alert_service.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Decision 0050: projects, spread expenses, net worth, regulated savings,
/// health, yearly review, refunds, contracts, events, shared expenses, pot,
/// reminders and month closing. Every endpoint refuses another household.
void main() {
  withServerpod('Planning (decision 0050)', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, bob, mallory;
    late int groupA;
    late Account shared, restricted, savings;
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final denied = throwsA(isA<AccessDeniedException>());

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user([Set<String> scopes = const {}]) async =>
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
      int? categoryId,
    }) => BankTransaction.db.insertRow(
      db,
      BankTransaction(
        accountId: a.id!,
        date: date,
        amountCents: cents,
        rawLabel: label,
        cleanLabel: label,
        operationKind: 'other',
        categoryId: categoryId,
      ),
    );
    Future<List<AppNotification>> notes(UuidValue u, String type) =>
        AppNotification.db.find(
          db,
          where: (n) => n.authUserId.equals(u) & n.type.equals(type),
        );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      bob = await user();
      mallory = await user({'owncoffer.serverAdmin'});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      await endpoints.group.create(as(mallory), 'B');
      await GroupMember.db.insertRow(
        db,
        GroupMember(groupId: groupA, authUserId: bob, role: MemberRole.user),
      );
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
      savings = await endpoints.account.create(
        as(alice),
        groupA,
        'Livret A',
        AccountKind.savings,
      );
    });

    test('savings projects and spread expenses; another household is '
        'refused', () async {
      final target = DateTime.utc(now.year + 1, now.month, 1);
      final p = await endpoints.project.save(
        as(bob),
        groupA,
        SavingsProject(
          groupId: 0,
          name: ' Vacances ',
          targetCents: 130000,
          savedCents: 0,
          targetDate: target,
        ),
      );
      expect(p.project.name, 'Vacances');
      expect(p.monthsLeft, 13, reason: 'this month to the same next year');
      expect(p.monthlyCents, 10000);
      final more = await endpoints.project.addSaved(
        as(alice),
        p.project.id!,
        30000,
      );
      expect(more.remainingCents, 100000);
      await expectLater(
        endpoints.project.addSaved(as(alice), p.project.id!, -40000),
        throwsA(isA<InvalidInputException>()),
      );

      // A yearly insurance of 600 € on the shared account, one on the
      // restricted one; a monthly rent that needs no smoothing.
      final next = DateTime.utc(now.year, now.month + 3, 10);
      await endpoints.scheduled.create(
        as(alice),
        shared.id!,
        -60000,
        'Assurance maison',
        ScheduleFrequency.yearly,
        next,
      );
      await endpoints.scheduled.create(
        as(alice),
        restricted.id!,
        -24000,
        'Assurance perso',
        ScheduleFrequency.yearly,
        next,
      );
      await endpoints.scheduled.create(
        as(alice),
        shared.id!,
        -70000,
        'Loyer',
        ScheduleFrequency.monthly,
        DateTime.utc(now.year, now.month, 5),
      );
      final o = await endpoints.project.overview(as(bob), groupA);
      expect(o.projects.single.project.savedCents, 30000);
      expect(o.projectsMonthlyCents, o.projects.single.monthlyCents);
      expect([for (final s in o.smoothed) s.label], ['Assurance maison']);
      expect(o.smoothed.single.monthlyCents, 5000);
      expect(o.smoothed.single.monthsUntil, 3);
      expect(o.smoothed.single.setAsideCents, 45000);
      final a = await endpoints.project.overview(as(alice), groupA);
      expect(a.smoothedMonthlyCents, 5000 + 2000);

      await expectLater(
        endpoints.project.overview(as(mallory), groupA),
        throwsA(isA<AccessDeniedException>()),
      );
      for (final call in [
        () => endpoints.project.addSaved(as(mallory), p.project.id!, 100),
        () => endpoints.project.setArchived(as(mallory), p.project.id!, true),
        () => endpoints.project.remove(as(mallory), p.project.id!),
        () => endpoints.project.save(
          as(mallory),
          groupA,
          SavingsProject(groupId: 0, name: 'X', targetCents: 1),
        ),
      ]) {
        await expectLater(call(), denied);
      }
      final kept = await SavingsProject.db.findById(db, p.project.id!);
      expect(kept!.savedCents, 30000);
      expect(kept.archivedAt, isNull);
    });

    test('net worth, regulated savings and health; another household is '
        'refused', () async {
      await op(shared, today, 150000, 'SALAIRE');
      await op(restricted, today, 50000, 'PERSO');
      await op(savings, DateTime.utc(now.year - 1, 12, 20), 1000000, 'DEPOT');
      final asset = await endpoints.wealth.saveAsset(
        as(bob),
        groupA,
        Asset(
          groupId: 0,
          name: 'Voiture',
          kind: AssetKind.vehicle,
          valueCents: 800000,
          valuedAt: today,
        ),
      );
      final w = await endpoints.wealth.overview(as(bob), groupA);
      expect(w.accountsCents, 150000 + 1000000, reason: 'not the restricted');
      expect(w.assetsCents, 800000);
      expect(w.netWorthCents, 150000 + 1000000 + 800000);
      final wa = await endpoints.wealth.overview(as(alice), groupA);
      expect(wa.accountsCents, 150000 + 50000 + 1000000);

      // Regulated savings: admins set the terms.
      await expectLater(
        endpoints.account.setSavingsTerms(
          as(bob),
          savings.id!,
          RegulatedKind.livretA,
          200,
        ),
        denied,
      );
      await endpoints.account.setSavingsTerms(
        as(alice),
        savings.id!,
        RegulatedKind.livretA,
        200,
      );
      final l = (await endpoints.wealth.savings(as(bob), groupA)).single;
      expect(l.ceilingCents, 2295000);
      expect(l.roomCents, 2295000 - 1000000);
      expect(l.interestYearCents, 20000, reason: '10 000 € all year at 2 %');
      expect(
        l.interestSoFarCents,
        core.fortnightInterest(
          openingCents: 1000000,
          movements: const [],
          year: now.year,
          rateBp: 200,
          fortnights: core.fortnightsOver(
            now.year,
            core.LocalDate(now.year, now.month, now.day),
          ),
        ),
      );

      final h = await endpoints.wealth.health(as(bob), groupA);
      expect(h.indicators.map((i) => i.key), [
        'emergency',
        'savingsRate',
        'debt',
        'regularity',
      ]);
      expect(h.savingsCents, 1000000);
      expect(h.indicators[2].grade, HealthGrade.good, reason: 'no loan');

      for (final call in [
        () => endpoints.wealth.overview(as(mallory), groupA),
        () => endpoints.wealth.savings(as(mallory), groupA),
        () => endpoints.wealth.health(as(mallory), groupA),
        () => endpoints.wealth.year(as(mallory), groupA, now.year),
        () => endpoints.wealth.removeAsset(as(mallory), asset.id!),
        () => endpoints.wealth.saveAsset(
          as(mallory),
          groupA,
          asset.copyWith(valueCents: 1),
        ),
        () => endpoints.account.setSavingsTerms(
          as(mallory),
          savings.id!,
          null,
          null,
        ),
      ]) {
        await expectLater(call(), denied);
      }
      expect((await Asset.db.findById(db, asset.id!))!.valueCents, 800000);
    });

    test(
      'yearly review lists the operations marked for the tax return',
      () async {
        final gift = await endpoints.category.create(
          as(alice),
          groupA,
          'Dons',
          CategoryKind.expense,
        );
        final food = await endpoints.category.create(
          as(alice),
          groupA,
          'Courses',
          CategoryKind.expense,
        );
        await endpoints.category.setTaxRelevant(as(bob), gift.id!, true);
        final year = now.year - 1;
        await op(
          shared,
          DateTime.utc(year, 3, 2),
          -5000,
          'DON',
          categoryId: gift.id,
        );
        await op(
          restricted,
          DateTime.utc(year, 4, 2),
          -7000,
          'DON PERSO',
          categoryId: gift.id,
        );
        await op(
          shared,
          DateTime.utc(year, 5, 2),
          -20000,
          'MARCHE',
          categoryId: food.id,
        );
        final r = await endpoints.wealth.year(as(bob), groupA, year);
        expect(r.expenseCents, 25000);
        expect(r.topExpenses.first.categoryId, food.id);
        expect(r.taxCategories.single.amountCents, 5000);
        expect(r.taxOperations.single.cleanLabel, 'DON');
        final ra = await endpoints.wealth.year(as(alice), groupA, year);
        expect(ra.taxOperations, hasLength(2));
        await expectLater(
          endpoints.category.setTaxRelevant(as(mallory), food.id!, true),
          denied,
        );
        expect((await Category.db.findById(db, food.id!))!.taxRelevant, false);
      },
    );

    test('expected refunds: settled by the credit, late ones notified; '
        'another household is refused', () async {
      final since = today.subtract(const Duration(days: 10));
      final r = await endpoints.refund.save(
        as(bob),
        groupA,
        ExpectedRefund(
          groupId: 0,
          createdBy: mallory,
          label: 'Mutuelle',
          amountCents: 2500,
          since: since,
        ),
      );
      expect(r.createdBy, bob, reason: 'the author is the caller');
      final late = await endpoints.refund.save(
        as(bob),
        groupA,
        ExpectedRefund(
          groupId: 0,
          createdBy: bob,
          label: 'Caution',
          amountCents: 90000,
          since: since,
          dueBy: today.subtract(const Duration(days: 1)),
        ),
      );
      // A credit of the same amount before its day does not count.
      await op(shared, since.subtract(const Duration(days: 1)), 2500, 'CPAM');
      expect(
        (await endpoints.refund.list(as(bob), groupA)).first.receivedAt,
        isNull,
      );
      final credit = await op(shared, today, 2500, 'MUTUELLE');
      final list = await endpoints.refund.list(as(bob), groupA);
      final got = list.firstWhere((x) => x.id == r.id);
      expect(got.transactionId, credit.id);
      expect(got.receivedAt, today);
      expect(list.first.id, late.id, reason: 'open ones first');

      await FollowUpAlertService.checkAll(
        db,
        core.LocalDate(now.year, now.month, now.day),
      );
      final n = await notes(bob, FollowUpAlertService.refundLate);
      expect(jsonDecode(n.single.data)['label'], 'Caution');
      await FollowUpAlertService.checkAll(
        db,
        core.LocalDate(now.year, now.month, now.day),
      );
      expect(await notes(bob, FollowUpAlertService.refundLate), hasLength(1));

      for (final call in [
        () => endpoints.refund.list(as(mallory), groupA),
        () => endpoints.refund.setReceived(as(mallory), late.id!, true),
        () => endpoints.refund.remove(as(mallory), late.id!),
        () => endpoints.refund.save(as(mallory), groupA, late),
      ]) {
        await expectLater(call(), denied);
      }
      expect(
        (await ExpectedRefund.db.findById(db, late.id!))!.receivedAt,
        isNull,
      );
    });

    test('contracts: last day to cancel, notified a month before', () async {
      final s = await endpoints.scheduled.create(
        as(alice),
        shared.id!,
        -3000,
        'Box internet',
        ScheduleFrequency.monthly,
        DateTime.utc(now.year, now.month, 1),
      );
      final renewal = today.add(const Duration(days: 40));
      await endpoints.scheduled.setContract(
        as(bob),
        s.id!,
        renewalDate: renewal,
        noticeDays: 30,
      );
      final c = (await endpoints.scheduled.contracts(as(bob), groupA)).single;
      expect(c.renewal, renewal);
      expect(c.deadline, today.add(const Duration(days: 10)));
      expect(c.daysToDeadline, 10);
      await FollowUpAlertService.checkAll(
        db,
        core.LocalDate(now.year, now.month, now.day),
      );
      expect(
        await notes(alice, FollowUpAlertService.contractNotice),
        hasLength(1),
      );
      expect(
        await notes(bob, FollowUpAlertService.contractNotice),
        hasLength(1),
      );
      await expectLater(
        endpoints.scheduled.contracts(as(mallory), groupA),
        denied,
      );
      await expectLater(
        endpoints.scheduled.setContract(as(mallory), s.id!),
        denied,
      );
      expect(
        (await ScheduledTransaction.db.findById(db, s.id!))!.noticeDays,
        30,
      );
    });

    test(
      'events gather visible operations; another household is refused',
      () async {
        final e = await endpoints.event.save(
          as(bob),
          groupA,
          LifeEvent(
            groupId: 0,
            name: 'Mariage',
            startDate: today,
            budgetCents: 500000,
          ),
        );
        final a = await op(shared, today, -120000, 'TRAITEUR');
        final b = await op(shared, today, -30000, 'FLEURS');
        final hidden = await op(restricted, today, -9900, 'ROBE');
        expect(await endpoints.event.attach(as(bob), e.id!, [a.id!, b.id!]), 2);
        expect(await endpoints.event.attach(as(bob), e.id!, [a.id!]), 0);
        await expectLater(
          endpoints.event.attach(as(bob), e.id!, [hidden.id!]),
          denied,
        );
        await endpoints.event.attach(as(alice), e.id!, [hidden.id!]);
        final mine = (await endpoints.event.list(as(bob), groupA)).single;
        expect(mine.totalCents, -150000, reason: 'not the restricted one');
        expect(mine.count, 2);
        final hers = (await endpoints.event.list(as(alice), groupA)).single;
        expect(hers.totalCents, -159900);
        await endpoints.event.detach(as(bob), e.id!, b.id!);
        expect(await endpoints.event.operations(as(bob), e.id!), hasLength(1));

        for (final call in [
          () => endpoints.event.list(as(mallory), groupA),
          () => endpoints.event.operations(as(mallory), e.id!),
          () => endpoints.event.attach(as(mallory), e.id!, [b.id!]),
          () => endpoints.event.detach(as(mallory), e.id!, a.id!),
          () => endpoints.event.remove(as(mallory), e.id!),
          () => endpoints.event.save(as(mallory), groupA, e),
        ]) {
          await expectLater(call(), denied);
        }
        expect(
          await EventOperation.db.count(
            db,
            where: (l) => l.eventId.equals(e.id!),
          ),
          2,
        );
      },
    );

    test('shared expenses, repayments and the pot by income; another '
        'household is refused', () async {
      await endpoints.shared.add(
        as(alice),
        groupA,
        SharedExpense(
          groupId: 0,
          label: 'Courses',
          date: today,
          amountCents: 9000,
          paidBy: alice,
          participants: [alice, bob],
          createdBy: alice,
        ),
      );
      var o = await endpoints.shared.overview(as(bob), groupA);
      expect(
        {for (final b in o.balances) b.userId: b.balanceCents},
        {alice: 4500, bob: -4500},
      );
      expect(o.settlements.single.fromUserId, bob);
      expect(o.settlements.single.amountCents, 4500);
      // Bob pays Alice back.
      await endpoints.shared.add(
        as(bob),
        groupA,
        SharedExpense(
          groupId: 0,
          label: 'Remboursement',
          date: today,
          amountCents: 4500,
          paidBy: bob,
          participants: [alice],
          repayment: true,
          createdBy: bob,
        ),
      );
      o = await endpoints.shared.overview(as(alice), groupA);
      expect(o.settlements, isEmpty);
      await expectLater(
        endpoints.shared.add(
          as(alice),
          groupA,
          SharedExpense(
            groupId: 0,
            label: 'X',
            date: today,
            amountCents: 100,
            paidBy: alice,
            participants: [alice, mallory],
            createdBy: alice,
          ),
        ),
        throwsA(isA<InvalidInputException>()),
      );

      await endpoints.shared.setPot(as(bob), groupA, 150000);
      await endpoints.shared.setIncome(as(bob), groupA, alice, 300000);
      final pot = await endpoints.shared.setIncome(
        as(bob),
        groupA,
        bob,
        200000,
      );
      expect(
        {for (final s in pot.shares) s.userId: s.shareCents},
        {alice: 90000, bob: 60000},
      );

      final expense = o.expenses.first;
      for (final call in [
        () => endpoints.shared.overview(as(mallory), groupA),
        () => endpoints.shared.remove(as(mallory), expense.id!),
        () => endpoints.shared.pot(as(mallory), groupA),
        () => endpoints.shared.setPot(as(mallory), groupA, 1),
        () => endpoints.shared.setIncome(as(mallory), groupA, alice, 1),
        () => endpoints.shared.add(as(mallory), groupA, expense),
      ]) {
        await expectLater(call(), denied);
      }
      expect(await SharedExpense.db.count(db), 2);
      expect(
        (await endpoints.shared.pot(as(alice), groupA)).totalCents,
        150000,
      );
    });

    test('reminders are personal and notified on their day', () async {
      final r = await endpoints.reminder.save(
        as(alice),
        groupA,
        Reminder(
          groupId: 0,
          authUserId: bob,
          text: 'Appeler la banque',
          dueDate: today,
        ),
      );
      expect(r.authUserId, alice);
      await endpoints.reminder.save(
        as(alice),
        groupA,
        Reminder(
          groupId: 0,
          authUserId: alice,
          text: 'Plus tard',
          dueDate: today.add(const Duration(days: 5)),
        ),
      );
      expect(await endpoints.reminder.list(as(bob), groupA), isEmpty);
      await expectLater(
        endpoints.reminder.setDone(as(bob), r.id!, true),
        denied,
      );
      await FollowUpAlertService.checkAll(
        db,
        core.LocalDate(now.year, now.month, now.day),
      );
      final n = await notes(alice, FollowUpAlertService.reminderDue);
      expect(jsonDecode(n.single.data)['text'], 'Appeler la banque');
      await endpoints.reminder.setDone(as(alice), r.id!, true);
      final list = await endpoints.reminder.list(as(alice), groupA);
      expect(list.map((x) => x.text), ['Plus tard', 'Appeler la banque']);
      for (final call in [
        () => endpoints.reminder.list(as(mallory), groupA),
        () => endpoints.reminder.remove(as(mallory), r.id!),
        () => endpoints.reminder.save(as(mallory), groupA, r),
      ]) {
        await expectLater(call(), denied);
      }
      expect(await Reminder.db.count(db), 2);
    });

    test('closed months: no change by hand, rules leave them alone', () async {
      final cat = await endpoints.category.create(
        as(alice),
        groupA,
        'Courses',
        CategoryKind.expense,
      );
      final old = await op(
        shared,
        DateTime.utc(now.year, now.month - 2, 3),
        -4000,
        'SUPERMARCHE',
      );
      final recent = await op(shared, today, -3000, 'SUPERMARCHE');
      final until = DateTime.utc(now.year, now.month - 1, 0);
      await expectLater(
        endpoints.group.setClosedUntil(as(bob), groupA, until),
        denied,
      );
      await expectLater(
        endpoints.group.setClosedUntil(as(mallory), groupA, until),
        denied,
      );
      await expectLater(
        endpoints.group.setClosedUntil(
          as(alice),
          groupA,
          today.add(const Duration(days: 2)),
        ),
        throwsA(isA<InvalidInputException>()),
      );
      final g = await endpoints.group.setClosedUntil(as(alice), groupA, until);
      expect(g.closedUntil, until);

      Matcher closed() => throwsA(
        isA<InvalidInputException>().having(
          (e) => e.code,
          'code',
          'month_closed',
        ),
      );
      await expectLater(
        endpoints.transaction.setCategory(as(bob), old.id!, cat.id),
        closed(),
      );
      await expectLater(
        endpoints.transaction.trash(as(bob), old.id!),
        closed(),
      );
      await expectLater(
        endpoints.transaction.create(
          as(bob),
          shared.id!,
          until,
          -100,
          'ESPECES',
        ),
        closed(),
      );
      await expectLater(
        endpoints.transaction.update(
          as(bob),
          recent.id!,
          date: until,
        ),
        closed(),
      );
      // The note stays free.
      await endpoints.transaction.update(as(bob), old.id!, note: 'vu');
      // A rule from a recent operation leaves the closed one alone.
      final r = await endpoints.transaction.createRuleFrom(
        as(bob),
        recent.id!,
        cat.id!,
      );
      expect(r.reclassifiedCount, 0);
      expect(
        (await BankTransaction.db.findById(db, old.id!))!.categoryId,
        isNull,
      );
      // Opened again.
      await endpoints.group.setClosedUntil(as(alice), groupA, null);
      await endpoints.transaction.setCategory(as(bob), old.id!, cat.id);
    });

    test(
      'scheduled.update preserves category and endDate when omitted, clears when asked',
      () async {
        final cat = await endpoints.category.create(
          as(alice),
          groupA,
          'Abonnements',
          CategoryKind.expense,
        );
        final end = DateTime.utc(now.year + 1, now.month, 1);
        final start = DateTime.utc(now.year, now.month, 1);

        final s = await endpoints.scheduled.create(
          as(alice),
          shared.id!,
          -1000,
          'Streaming',
          ScheduleFrequency.monthly,
          start,
          categoryId: cat.id,
          endDate: end,
          matchPattern: 'STREAM',
        );
        expect(s.categoryId, cat.id);
        expect(s.endDate, end);
        expect(s.matchPattern, 'STREAM');

        // Partial update: amountCents only (e.g. from operation sheet)
        final updatedAmount = await endpoints.scheduled.update(
          as(alice),
          s.id!,
          amountCents: -1200,
        );
        expect(updatedAmount.amountCents, -1200);
        expect(updatedAmount.categoryId, cat.id, reason: 'category preserved');
        expect(updatedAmount.endDate, end, reason: 'endDate preserved');
        expect(
          updatedAmount.matchPattern,
          'STREAM',
          reason: 'pattern preserved',
        );

        // Explicit clear
        final cleared = await endpoints.scheduled.update(
          as(alice),
          s.id!,
          clearCategory: true,
          clearEndDate: true,
          matchPattern: '',
        );
        expect(cleared.categoryId, isNull);
        expect(cleared.endDate, isNull);
        expect(cleared.matchPattern, '', reason: 'empty pattern clears it');
      },
    );
  });
}
