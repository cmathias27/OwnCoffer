import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Scheduled operations and forecast', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue alice, mallory, reader;
    late int groupA;
    late Account account;
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    DateTime day(int offset) => today.add(Duration(days: offset));

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

    Future<BankTransaction> op(int offset, int cents, String label) =>
        BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: account.id!,
            date: day(offset),
            amountCents: cents,
            rawLabel: label,
            cleanLabel: label,
            operationKind: 'directDebit',
          ),
        );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({'owncoffer.serverAdmin'});
      reader = await user({});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      await endpoints.group.create(as(mallory), 'B');
      await GroupMember.db.insertRow(
        db,
        GroupMember(
          groupId: groupA,
          authUserId: reader,
          role: MemberRole.reader,
        ),
      );
      account = await endpoints.account.create(
        as(alice),
        groupA,
        'Courant',
        AccountKind.checking,
        initialBalanceCents: 30000,
      );
    });

    test('day-by-day forecast, low point and overdraft date', () async {
      await endpoints.scheduled.create(
        as(alice),
        account.id!,
        -65000,
        'Loyer',
        ScheduleFrequency.monthly,
        day(2),
      );
      await endpoints.scheduled.create(
        as(alice),
        account.id!,
        215035,
        'Salaire',
        ScheduleFrequency.monthly,
        day(3),
      );
      final f = await endpoints.scheduled.forecast(
        as(alice),
        account.id!,
        today,
      );
      expect(f.days, hasLength(31));
      expect(f.currentBalanceCents, 30000);
      expect(f.days[2].balanceCents, 30000 - 65000);
      expect(f.days[3].balanceCents, 30000 - 65000 + 215035);
      expect(f.lowestBalanceCents, -35000);
      expect(f.lowestDate, day(2));
      expect(f.firstBelowThresholdDate, day(2));
    });

    test('authorised overdraft threshold on the account', () async {
      await endpoints.account.update(
        as(alice),
        account.id!,
        alertThresholdCents: -50000,
      );
      await endpoints.scheduled.create(
        as(alice),
        account.id!,
        -65000,
        'Loyer',
        ScheduleFrequency.once,
        day(2),
      );
      final f = await endpoints.scheduled.forecast(
        as(alice),
        account.id!,
        today,
      );
      expect(f.lowestBalanceCents, -35000);
      expect(f.firstBelowThresholdDate, isNull);
    });

    test(
      'an exact real operation is linked automatically, never counted twice',
      () async {
        final rent = await endpoints.scheduled.create(
          as(alice),
          account.id!,
          -65000,
          'Loyer',
          ScheduleFrequency.monthly,
          day(-2),
          matchPattern: 'agence logement',
        );
        final paid = await op(-1, -65000, 'PRLV SEPA AGENCE LOGEMENT EXEMPLE');
        final f = await endpoints.scheduled.forecast(
          as(alice),
          account.id!,
          today,
        );
        expect(f.autoReconciledCount, 1);
        expect(f.currentBalanceCents, 30000 - 65000);
        // The paid rent is not expected again today: only next month's.
        expect(
          f.events.where(
            (e) => e.scheduledId == rent.id && e.date.isBefore(day(20)),
          ),
          isEmpty,
        );
        final linked = await BankTransaction.db.findById(db, paid.id!);
        expect(linked!.scheduledId, rent.id);
        final again = await endpoints.scheduled.forecast(
          as(alice),
          account.id!,
          today,
        );
        expect(again.autoReconciledCount, 0);
        expect(again.currentBalanceCents, f.currentBalanceCents);
      },
    );

    test(
      'an approximate match is proposed, then confirmed by the user',
      () async {
        final edf = await endpoints.scheduled.create(
          as(alice),
          account.id!,
          -7000,
          'Électricité',
          ScheduleFrequency.monthly,
          day(-1),
          matchPattern: 'EDF',
          amountTolerancePercent: 15,
        );
        final t = await op(0, -7600, 'PRLV SEPA EDF SA');
        final f = await endpoints.scheduled.forecast(
          as(alice),
          account.id!,
          today,
        );
        expect(f.autoReconciledCount, 0);
        final p = f.proposals.single;
        expect(p.transactionId, t.id);
        // Until confirmed, the planned bill is still expected (prudent).
        expect(f.days.first.balanceCents, 30000 - 7600 - 7000);
        await endpoints.scheduled.confirmMatch(
          as(alice),
          edf.id!,
          p.dueDate,
          t.id!,
        );
        final after = await endpoints.scheduled.forecast(
          as(alice),
          account.id!,
          today,
        );
        expect(after.proposals, isEmpty);
        expect(after.days.first.balanceCents, 30000 - 7600);
      },
    );

    test('late occurrences count today; skipNext removes one', () async {
      final s = await endpoints.scheduled.create(
        as(alice),
        account.id!,
        -1000,
        'Abonnement',
        ScheduleFrequency.monthly,
        day(-3),
      );
      var f = await endpoints.scheduled.forecast(as(alice), account.id!, today);
      expect(f.events.first.dueDate, day(-3));
      expect(f.days.first.balanceCents, 29000);
      await endpoints.scheduled.skipNext(as(alice), s.id!);
      f = await endpoints.scheduled.forecast(as(alice), account.id!, today);
      expect(f.days.first.balanceCents, 30000);
    });

    test('invalid inputs are refused', () async {
      Future<void> bad(Future<Object?> call) =>
          expectLater(call, throwsA(isA<InvalidInputException>()));
      await bad(
        endpoints.scheduled.create(
          as(alice),
          account.id!,
          0,
          'Zéro',
          ScheduleFrequency.monthly,
          day(1),
        ),
      );
      await bad(
        endpoints.scheduled.create(
          as(alice),
          account.id!,
          -100,
          ' ',
          ScheduleFrequency.monthly,
          day(1),
        ),
      );
      await bad(
        endpoints.scheduled.create(
          as(alice),
          account.id!,
          -100,
          'X',
          ScheduleFrequency.monthly,
          day(1),
          interval: 0,
        ),
      );
      await bad(
        endpoints.scheduled.create(
          as(alice),
          account.id!,
          -100,
          'X',
          ScheduleFrequency.monthly,
          day(5),
          endDate: day(1),
        ),
      );
      await bad(endpoints.scheduled.forecast(as(alice), account.id!, day(-5)));
    });

    test('variable spending: median of the last months, shown and '
        'counted unless turned off', () async {
      DateTime monthAgo(int n, int d) =>
          DateTime.utc(now.year, now.month - n, d);
      // Unclassified card payments: 300 €, 900 € (one-off), 300 €.
      for (final (n, cents) in [(3, -30000), (2, -90000), (1, -30000)]) {
        await BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: account.id!,
            date: monthAgo(n, 1),
            amountCents: cents,
            rawLabel: 'CB HYPER',
            cleanLabel: 'HYPER',
            operationKind: 'card',
          ),
        );
      }
      final f = await endpoints.scheduled.forecast(
        as(reader),
        account.id!,
        today,
      );
      final v = f.variable!;
      expect(v.months, hasLength(3));
      expect(v.monthlyCents, 30000);
      expect(v.categories.single.categoryId, isNull);
      expect(v.categories.single.monthsCents, [30000, 90000, 30000]);
      expect(v.spentThisMonthCents, 0);
      expect(v.horizonCents, greaterThan(0));
      expect(
        f.days.first.balanceCents - f.days.last.balanceCents,
        v.horizonCents,
        reason: 'nothing else planned',
      );

      final without = await endpoints.scheduled.forecast(
        as(reader),
        account.id!,
        today,
        includeVariable: false,
      );
      expect(without.variable, isNull);
      expect(without.days.last.balanceCents, without.currentBalanceCents);
    });

    group('isolation (decision 0016)', () {
      final denied = throwsA(isA<AccessDeniedException>());

      test('another group cannot see, plan, change or forecast', () async {
        final s = await endpoints.scheduled.create(
          as(alice),
          account.id!,
          -1000,
          'X',
          ScheduleFrequency.monthly,
          day(1),
        );
        await expectLater(
          endpoints.scheduled.list(as(mallory), account.id!),
          denied,
        );
        await expectLater(
          endpoints.scheduled.create(
            as(mallory),
            account.id!,
            -1,
            'Y',
            ScheduleFrequency.once,
            day(1),
          ),
          denied,
        );
        await expectLater(
          endpoints.scheduled.update(as(mallory), s.id!, amountCents: -999999),
          denied,
        );
        await expectLater(
          endpoints.scheduled.delete(as(mallory), s.id!),
          denied,
        );
        await expectLater(
          endpoints.scheduled.skipNext(as(mallory), s.id!),
          denied,
        );
        await expectLater(
          endpoints.scheduled.forecast(as(mallory), account.id!, today),
          denied,
        );
        expect(
          (await ScheduledTransaction.db.findById(db, s.id!))!.amountCents,
          -1000,
        );
      });

      test('another group cannot confirm a match either way', () async {
        final s = await endpoints.scheduled.create(
          as(alice),
          account.id!,
          -7000,
          'EDF',
          ScheduleFrequency.monthly,
          day(0),
        );
        final t = await op(0, -7000, 'EDF');
        final groupB = (await endpoints.group.myGroups(
          as(mallory),
        )).single.group.id!;
        final other = await endpoints.account.create(
          as(mallory),
          groupB,
          'B',
          AccountKind.checking,
        );
        final mine = await endpoints.scheduled.create(
          as(mallory),
          other.id!,
          -7000,
          'EDF',
          ScheduleFrequency.monthly,
          day(0),
        );
        // Alice's planned operation with Alice's operation.
        await expectLater(
          endpoints.scheduled.confirmMatch(as(mallory), s.id!, day(0), t.id!),
          denied,
        );
        // Mallory's planned operation with Alice's operation.
        await expectLater(
          endpoints.scheduled.confirmMatch(
            as(mallory),
            mine.id!,
            day(0),
            t.id!,
          ),
          denied,
        );
        final unchanged = (await BankTransaction.db.findById(db, t.id!))!;
        expect(unchanged.amountCents, -7000);
        expect(
          (await ScheduledTransaction.db.findById(db, s.id!))!.nextDue,
          isNull,
        );
      });

      test('a reader can forecast but not plan', () async {
        expect(
          (await endpoints.scheduled.forecast(
            as(reader),
            account.id!,
            today,
          )).days,
          hasLength(31),
        );
        await expectLater(
          endpoints.scheduled.create(
            as(reader),
            account.id!,
            -1,
            'Y',
            ScheduleFrequency.once,
            day(1),
          ),
          denied,
        );
      });
    });
  });
}
