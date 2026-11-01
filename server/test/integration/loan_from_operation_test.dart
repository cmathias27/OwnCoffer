import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Loan declared from an operation', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, mallory, reader, bob;
    late int groupA;
    late Account shared, restricted;
    late Map<String, Category> cats;
    final denied = throwsA(isA<AccessDeniedException>());
    final now = DateTime.now().toUtc();
    // 100 000 € at 1 % over 10 years: 876,04 € + 15 € insurance.
    const instalment = 87604 + 1500;
    DateTime due(int monthsAgo) =>
        DateTime.utc(now.year, now.month - monthsAgo, 5);

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
    Future<BankTransaction> debit(
      Account a,
      DateTime date,
      int cents, {
      String label = 'PRET IMMO 123',
      int? categoryId,
      CategorySource source = CategorySource.none,
    }) => BankTransaction.db.insertRow(
      db,
      BankTransaction(
        accountId: a.id!,
        date: date,
        amountCents: -cents,
        rawLabel: 'PRLV $label',
        cleanLabel: label,
        operationKind: 'directDebit',
        categoryId: categoryId,
        categorySource: source,
      ),
    );

    /// Terms the user types; account and category come from the operation.
    Loan terms() => Loan(
      groupId: 0,
      kind: LoanKind.mortgage,
      lender: 'Banque',
      principalCents: 10000000,
      annualRateMilli: 1000,
      durationMonths: 120,
      firstDueDate: due(3),
      insuranceMonthlyCents: 1500,
    );

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
          c.standardCode!: c,
      };
    });

    test('classifies and links the instalments, keeps manual choices and '
        'other debits apart', () async {
      final first = await debit(shared, due(3), instalment);
      final second = await debit(shared, due(2), instalment + 30);
      final source = await debit(shared, due(1), instalment);
      final manual = await debit(
        shared,
        due(1).add(const Duration(days: 1)),
        instalment,
        categoryId: cats['banking.bank_fees']!.id,
        source: CategorySource.manual,
      );
      final small = await debit(shared, due(1), 2000);
      final other = await debit(shared, due(1), instalment, label: 'LOYER');

      final r = await endpoints.loan.createFromTransaction(
        as(bob),
        source.id!,
        terms().copyWith(accountId: restricted.id),
      );
      final loan = r.info.loan;
      expect(loan.groupId, groupA);
      expect(loan.accountId, shared.id, reason: "the operation's account");
      expect(loan.categoryId, cats['housing.mortgage']!.id);
      expect(loan.matchPattern, 'PRET IMMO 123');
      expect(r.reclassifiedCount, 2, reason: 'first and second');
      expect(r.linkedCount, 3, reason: 'first, second and source');

      final rule = (await Rule.db.findById(db, loan.ruleId!))!;
      expect(rule.groupId, groupA);
      expect(rule.categoryId, loan.categoryId);
      expect(rule.direction, RuleDirection.debit);
      expect(rule.minAbsCents, lessThan(instalment));
      expect(rule.maxAbsCents, greaterThan(instalment));

      final s = (await ScheduledTransaction.db.findById(
        db,
        loan.scheduledId!,
      ))!;
      expect(s.matchPattern, 'PRET IMMO 123');
      expect(s.amountCents, -instalment);

      Future<BankTransaction> reread(BankTransaction t) async =>
          (await BankTransaction.db.findById(db, t.id!))!;
      for (final t in [first, second]) {
        final x = await reread(t);
        expect(x.categoryId, loan.categoryId);
        expect(x.categorySource, CategorySource.groupRule);
        expect(x.scheduledId, s.id);
      }
      final src = await reread(source);
      expect(src.categoryId, loan.categoryId);
      expect(src.categorySource, CategorySource.manual);
      expect(src.scheduledId, s.id);
      expect((await reread(manual)).categoryId, cats['banking.bank_fees']!.id);
      expect((await reread(small)).categoryId, isNull);
      expect((await reread(other)).categoryId, isNull);
      expect((await reread(other)).scheduledId, isNull);
    });

    test('a planned operation made for these debits is replaced', () async {
      final source = await debit(shared, due(1), instalment);
      final planned = await endpoints.scheduled.subscribeFrom(
        as(bob),
        source.id!,
      );
      final r = await endpoints.loan.createFromTransaction(
        as(bob),
        source.id!,
        terms(),
      );
      final old = (await ScheduledTransaction.db.findById(db, planned.id!))!;
      expect(old.deletedAt, isNotNull);
      final src = (await BankTransaction.db.findById(db, source.id!))!;
      expect(src.scheduledId, r.info.loan.scheduledId);
    });

    test('category change follows on the rule; deleting the loan removes '
        'the rule, classified operations keep their category', () async {
      final source = await debit(shared, due(1), instalment);
      final r = await endpoints.loan.createFromTransaction(
        as(bob),
        source.id!,
        terms(),
      );
      final other = cats['banking.consumer_loan']!.id!;
      final updated = await endpoints.loan.update(
        as(bob),
        r.info.loan.copyWith(categoryId: other),
      );
      expect(updated.loan.ruleId, r.info.loan.ruleId);
      expect(updated.loan.matchPattern, 'PRET IMMO 123');
      expect(
        (await Rule.db.findById(db, r.info.loan.ruleId!))!.categoryId,
        other,
      );

      await endpoints.loan.delete(as(bob), r.info.loan.id!);
      expect(await Rule.db.findById(db, r.info.loan.ruleId!), isNull);
      expect(
        (await BankTransaction.db.findById(db, source.id!))!.categoryId,
        cats['housing.mortgage']!.id,
      );
    });

    test('isolation: another group, a reader or a hidden account are '
        'refused and nothing is written', () async {
      final source = await debit(shared, due(1), instalment);
      final hidden = await debit(restricted, due(1), instalment);
      await expectLater(
        endpoints.loan.createFromTransaction(as(mallory), source.id!, terms()),
        denied,
      );
      await expectLater(
        endpoints.loan.createFromTransaction(as(reader), source.id!, terms()),
        denied,
      );
      await expectLater(
        endpoints.loan.createFromTransaction(as(bob), hidden.id!, terms()),
        denied,
      );
      expect(await Loan.db.count(db), 0);
      expect(await Rule.db.count(db), 0);
      final t = (await BankTransaction.db.findById(db, source.id!))!;
      expect(t.categoryId, isNull);
      expect(t.scheduledId, isNull);
    });

    test('payments in instalments found in the operations, until they are '
        'in the loans; isolation', () async {
      final instalments = cats['banking.installments']!.id;
      final oney = await debit(
        shared,
        due(2),
        4650,
        label: 'ONEY 4X 1/4',
        categoryId: instalments,
      );
      await debit(
        shared,
        due(1),
        4500,
        label: 'ONEY 4X 2/4',
        categoryId: instalments,
      );
      for (final m in [3, 2, 1]) {
        await debit(
          shared,
          due(m),
          12000,
          label: 'COFIDIS',
          categoryId: cats['banking.consumer_loan']!.id,
        );
      }
      await debit(
        restricted,
        due(1),
        2000,
        label: 'KLARNA',
        categoryId: instalments,
      );
      await debit(shared, due(1), 3000, label: 'ALMA 3X 1/3');

      final all = await endpoints.loan.detectedInstalments(as(alice), groupA);
      expect(all.map((c) => (c.label, c.kind, c.paidCount)), [
        ('COFIDIS', LoanKind.consumer, 3),
        ('ONEY 4X', LoanKind.installments, 2),
        ('KLARNA', LoanKind.installments, 1),
      ], reason: 'largest first; an unclassified debit is not proposed');
      final found = all[1];
      expect(found.first.id, oney.id, reason: 'declared from the first one');
      expect(found.amountCents, 4500);
      expect(found.statedCount, 4);
      expect(found.suggestedCount, 4);

      final forBob = await endpoints.loan.detectedInstalments(as(bob), groupA);
      expect(
        forBob.map((c) => c.label),
        ['COFIDIS', 'ONEY 4X'],
        reason: 'the restricted account stays hidden',
      );
      expect(
        await endpoints.loan.detectedInstalments(as(reader), groupA),
        hasLength(2),
      );
      await expectLater(
        endpoints.loan.detectedInstalments(as(mallory), groupA),
        denied,
      );

      await endpoints.loan.createFromTransaction(
        as(bob),
        oney.id!,
        Loan(
          groupId: 0,
          kind: LoanKind.installments,
          lender: 'ONEY 4X',
          principalCents: 18150,
          annualRateMilli: 0,
          durationMonths: 4,
          firstDueDate: due(2),
        ),
      );
      expect(
        (await endpoints.loan.detectedInstalments(
          as(bob),
          groupA,
        )).map((c) => c.label),
        ['COFIDIS'],
        reason: 'once in the loans, no longer proposed',
      );
    });

    test('only from a debit', () async {
      final credit = await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: shared.id!,
          date: due(1),
          amountCents: 5000,
          rawLabel: 'VIR',
          cleanLabel: 'VIR',
          operationKind: 'transfer',
        ),
      );
      await expectLater(
        endpoints.loan.createFromTransaction(as(bob), credit.id!, terms()),
        throwsA(isA<InvalidInputException>()),
      );
    });

    test("the loan's operations, kept when the loan is changed", () async {
      final first = await debit(shared, due(3), instalment);
      final source = await debit(shared, due(1), instalment);
      await debit(shared, due(1), instalment, label: 'LOYER');
      final r = await endpoints.loan.createFromTransaction(
        as(bob),
        source.id!,
        terms(),
      );
      Future<List<int?>> ids(UuidValue u) async => [
        for (final t in await endpoints.loan.operations(as(u), r.info.loan.id!))
          t.id,
      ];
      expect(await ids(reader), [source.id, first.id]);

      final changed = await endpoints.loan.update(
        as(bob),
        r.info.loan.copyWith(label: 'Maison'),
      );
      expect(changed.loan.scheduledId, isNot(r.info.loan.scheduledId));
      expect(await ids(reader), [source.id, first.id]);
      expect(
        (await BankTransaction.db.findById(db, first.id!))!.scheduledId,
        changed.loan.scheduledId,
      );

      await expectLater(
        endpoints.loan.operations(as(mallory), r.info.loan.id!),
        denied,
      );
    });

    group('attach to an existing loan', () {
      test('a loan without account takes the debit, its label and a rule; '
          'undo puts things back', () async {
        final info = await endpoints.loan.create(as(bob), groupA, terms());
        expect(info.loan.accountId, isNull);
        final older = await debit(shared, due(2), instalment);
        // 8 days late: beyond the tolerance, linked because the user said so.
        final source = await debit(
          shared,
          due(1).add(const Duration(days: 8)),
          instalment,
        );
        final r = await endpoints.loan.attachTransaction(
          as(bob),
          info.loan.id!,
          source.id!,
        );
        final loan = r.info.loan;
        expect(loan.accountId, shared.id);
        expect(loan.matchPattern, 'PRET IMMO 123');
        expect(loan.categoryId, cats['housing.mortgage']!.id);
        expect(r.ruleId, loan.ruleId);
        expect(r.linkedCount, 2);
        expect(r.reclassifiedCount, 1);
        final src = (await BankTransaction.db.findById(db, source.id!))!;
        expect(src.scheduledId, loan.scheduledId);
        expect(src.categorySource, CategorySource.manual);
        expect(
          (await BankTransaction.db.findById(db, older.id!))!.scheduledId,
          loan.scheduledId,
        );

        await expectLater(
          endpoints.loan.undoAttach(
            as(mallory),
            loan.id!,
            source.id!,
            ruleId: r.ruleId,
          ),
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
        expect(
          await endpoints.loan.undoAttach(
            as(bob),
            loan.id!,
            source.id!,
            ruleId: r.ruleId,
          ),
          1,
        );
        final back = (await BankTransaction.db.findById(db, source.id!))!;
        expect(back.scheduledId, isNull);
        expect(back.categoryId, isNull);
        expect(await Rule.db.findById(db, r.ruleId!), isNull);
        expect(
          (await BankTransaction.db.findById(db, older.id!))!.categoryId,
          isNull,
        );
      });

      test('a loan on another account, a credit, another group or a reader '
          'are refused', () async {
        final other = await endpoints.account.create(
          as(alice),
          groupA,
          'Joint',
          AccountKind.checking,
        );
        final info = await endpoints.loan.create(
          as(bob),
          groupA,
          terms().copyWith(accountId: other.id),
        );
        final source = await debit(shared, due(1), instalment);
        await expectLater(
          endpoints.loan.attachTransaction(as(bob), info.loan.id!, source.id!),
          throwsA(isA<InvalidInputException>()),
        );
        final free = await endpoints.loan.create(as(bob), groupA, terms());
        await expectLater(
          endpoints.loan.attachTransaction(
            as(mallory),
            free.loan.id!,
            source.id!,
          ),
          denied,
        );
        await expectLater(
          endpoints.loan.attachTransaction(
            as(reader),
            free.loan.id!,
            source.id!,
          ),
          denied,
        );
        final hidden = await debit(restricted, due(1), instalment);
        await expectLater(
          endpoints.loan.attachTransaction(as(bob), free.loan.id!, hidden.id!),
          denied,
        );
        final unchanged = (await Loan.db.findById(db, free.loan.id!))!;
        expect(unchanged.accountId, isNull);
        expect(unchanged.ruleId, isNull);
        expect(
          (await BankTransaction.db.findById(db, source.id!))!.scheduledId,
          isNull,
        );
      });
    });
  });
}
