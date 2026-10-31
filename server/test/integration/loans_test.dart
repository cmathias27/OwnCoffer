import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Loans', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, mallory, reader, bob;
    late int groupA, groupB;
    late Account shared, restricted;
    final denied = throwsA(isA<AccessDeniedException>());
    final now = DateTime.now().toUtc();

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

    /// 100 000 € at 1 % over 10 years, started 3 instalments ago.
    Loan mortgage({int? accountId, int insurance = 1500}) => Loan(
      groupId: 0,
      accountId: accountId,
      kind: LoanKind.mortgage,
      lender: '  Caisse d\'Épargne ',
      label: 'Maison',
      principalCents: 10000000,
      annualRateMilli: 1000,
      durationMonths: 120,
      firstDueDate: DateTime.utc(now.year, now.month - 2, 5),
      insuranceMonthlyCents: insurance,
      feesCents: 50000,
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
    });

    test('create: where the loan stands, planned instalments on the '
        'account', () async {
      final info = await endpoints.loan.create(
        as(bob),
        groupA,
        mortgage(accountId: shared.id),
      );
      final loan = info.loan;
      expect(loan.groupId, groupA);
      expect(loan.lender, "Caisse d'Épargne");
      expect(info.paymentCents, 87604);
      expect(info.totalCount, 120);
      expect(info.paidCount, inInclusiveRange(2, 3));
      expect(info.costCents, 512494 + 120 * 1500 + 50000);
      expect(info.nextDueDate, isNotNull);

      final s = (await ScheduledTransaction.db.findById(
        db,
        loan.scheduledId!,
      ))!;
      expect(s.accountId, shared.id);
      expect(s.amountCents, -(87604 + 1500));
      expect(s.frequency, ScheduleFrequency.monthly);
      expect(s.occurrenceCount, 120);
      expect(s.nextDue, info.nextDueDate);
      expect(s.label, "Caisse d'Épargne · Maison");

      final schedule = await endpoints.loan.schedule(as(reader), loan.id!);
      expect(schedule, hasLength(120));
      expect(schedule.last.remainingCents, 0);
    });

    test('overview: totals and debt ratio from the income', () async {
      final cats = {
        for (final c in await endpoints.category.list(as(alice), groupA))
          c.standardCode!: c,
      };
      for (var m = 1; m <= 3; m++) {
        await BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: shared.id!,
            date: DateTime.utc(now.year, now.month - m, 1),
            amountCents: 300000,
            rawLabel: 'SALAIRE',
            cleanLabel: 'SALAIRE',
            operationKind: 'transfer',
            categoryId: cats['income.salary']!.id,
          ),
        );
      }
      await endpoints.loan.create(as(bob), groupA, mortgage());
      final o = await endpoints.loan.overview(as(reader), groupA);
      expect(o.loans, hasLength(1));
      expect(o.totalMonthlyCents, 87604 + 1500);
      expect(o.monthlyIncomeCents, 300000);
      expect(o.debtRatioPerMille, (87604 + 1500) * 1000 ~/ 300000);
      expect(o.totalRemainingCents, o.loans.single.remainingCents);
    });

    test(
      'update recomputes the planned instalments; delete stops them',
      () async {
        final info = await endpoints.loan.create(
          as(bob),
          groupA,
          mortgage(accountId: shared.id),
        );
        final first = info.loan.scheduledId!;
        final updated = await endpoints.loan.update(
          as(bob),
          info.loan.copyWith(insuranceMonthlyCents: 0, durationMonths: 60),
        );
        expect(updated.totalCount, 60);
        expect(
          (await ScheduledTransaction.db.findById(db, first))!.deletedAt,
          isNotNull,
        );
        final s = (await ScheduledTransaction.db.findById(
          db,
          updated.loan.scheduledId!,
        ))!;
        expect(s.amountCents, -updated.paymentCents);
        expect(s.occurrenceCount, 60);

        await endpoints.loan.delete(as(bob), info.loan.id!);
        expect(
          await endpoints.loan.overview(as(alice), groupA),
          isA<LoanOverview>(),
        );
        expect(
          (await endpoints.loan.overview(as(alice), groupA)).loans,
          isEmpty,
        );
        expect(
          (await ScheduledTransaction.db.findById(db, s.id!))!.deletedAt,
          isNotNull,
        );
      },
    );

    test('early repayment simulation', () async {
      final info = await endpoints.loan.create(as(bob), groupA, mortgage());
      final r = await endpoints.loan.simulate(
        as(reader),
        info.loan.id!,
        2000000,
      );
      expect(r.interestSavedCents, greaterThan(0));
      expect(r.installmentsLeft, lessThan(120 - info.paidCount));
      final all = await endpoints.loan.simulate(
        as(reader),
        info.loan.id!,
        99999999,
      );
      expect(all.installmentsLeft, 0);
      expect(all.interestSavedCents, info.interestRemainingCents);
    });

    test('invalid terms are refused', () async {
      for (final bad in [
        mortgage().copyWith(principalCents: 0),
        mortgage().copyWith(annualRateMilli: -1),
        mortgage().copyWith(durationMonths: 0),
        mortgage().copyWith(lender: '  '),
        mortgage().copyWith(feesCents: -1),
      ]) {
        await expectLater(
          endpoints.loan.create(as(bob), groupA, bad),
          throwsA(isA<InvalidInputException>()),
        );
      }
    });

    group('isolation', () {
      test(
        'another group cannot see, simulate, change or delete a loan',
        () async {
          final info = await endpoints.loan.create(as(bob), groupA, mortgage());
          final id = info.loan.id!;
          await expectLater(
            endpoints.loan.overview(as(mallory), groupA),
            denied,
          );
          await expectLater(endpoints.loan.schedule(as(mallory), id), denied);
          await expectLater(
            endpoints.loan.simulate(as(mallory), id, 100),
            denied,
          );
          await expectLater(
            endpoints.loan.update(as(mallory), info.loan.copyWith(lender: 'X')),
            denied,
          );
          await expectLater(endpoints.loan.delete(as(mallory), id), denied);
          await expectLater(
            endpoints.loan.create(
              as(mallory),
              groupB,
              mortgage(accountId: shared.id),
            ),
            denied,
            reason: 'an account of another group',
          );
          final kept = (await Loan.db.findById(db, id))!;
          expect(kept.lender, "Caisse d'Épargne");
          expect(kept.deletedAt, isNull);
        },
      );

      test('readers cannot write; a loan on a restricted account is hidden '
          'from members without access', () async {
        await expectLater(
          endpoints.loan.create(as(reader), groupA, mortgage()),
          denied,
        );
        final secret = await endpoints.loan.create(
          as(alice),
          groupA,
          mortgage(accountId: restricted.id),
        );
        expect((await endpoints.loan.overview(as(bob), groupA)).loans, isEmpty);
        await expectLater(
          endpoints.loan.schedule(as(bob), secret.loan.id!),
          denied,
        );
        await expectLater(
          endpoints.loan.create(
            as(bob),
            groupA,
            mortgage(accountId: restricted.id),
          ),
          denied,
        );
        expect(
          (await endpoints.loan.overview(as(alice), groupA)).loans,
          hasLength(1),
        );
      });
    });
  });
}
