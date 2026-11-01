import 'dart:convert';

import 'package:owncoffer_server/src/finance/proposal_service.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Advisor: proposals validated by the user (0009)', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue alice, bob, reader, mallory;
    late int groupA;
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
    final now = DateTime.now().toUtc();
    // Three complete budget months before the current one.
    DateTime monthsAgo(int n) => DateTime.utc(now.year, now.month - n, 10);
    Future<void> spend(Account a, int monthsBack, int cents, String code) =>
        BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: a.id!,
            date: monthsAgo(monthsBack),
            amountCents: -cents,
            rawLabel: 'CB $code',
            cleanLabel: 'MAGASIN',
            operationKind: 'card',
            categoryId: cats[code]!.id,
          ),
        );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({'owncoffer.serverAdmin'});
      bob = await user({});
      reader = await user({});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      await endpoints.group.create(as(mallory), 'B');
      for (final (u, role) in [
        (bob, MemberRole.user),
        (reader, MemberRole.reader),
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
      for (final (m, cents) in [(3, 21000), (2, 19000), (1, 23000)]) {
        await spend(shared, m, cents, 'food');
      }
      // Only alice sees this one.
      for (final m in [3, 2, 1]) {
        await spend(restricted, m, 40000, 'leisure');
      }
    });

    test('goals proposed from the visible accounts only, accepted once, '
        'undone', () async {
      final mine = await endpoints.advisor.proposals(as(alice), groupA);
      final food = cats['food']!.id;
      expect(
        mine.map((p) => (p.kind, p.targetId, p.proposedValue)).toSet(),
        {('set_goal', food, 21000), ('set_goal', cats['leisure']!.id, 40000)},
      );
      final forBob = await endpoints.advisor.proposals(as(bob), groupA);
      expect(
        forBob.map((p) => p.targetId),
        [food],
        reason: "bob does not see the restricted account's spending",
      );
      // Asking again does not repeat them.
      expect(await endpoints.advisor.proposals(as(bob), groupA), hasLength(1));

      final p = forBob.single;
      await expectLater(endpoints.advisor.accept(as(alice), p.id!), denied);
      await expectLater(endpoints.advisor.accept(as(mallory), p.id!), denied);
      final done = await endpoints.advisor.accept(as(bob), p.id!);
      expect(done.status, 'executed');
      final again = await endpoints.advisor.accept(as(bob), p.id!);
      expect(again.executedAt, done.executedAt, reason: 'applied once');
      final goals = await endpoints.goal.list(as(bob), groupA);
      expect(goals.single.amountCents, 21000);

      final undone = await endpoints.advisor.undo(as(bob), p.id!);
      expect(undone.status, 'undone');
      expect(await endpoints.goal.list(as(bob), groupA), isEmpty);
      final log = await endpoints.admin.audit(as(alice));
      expect(
        log.where((e) => e.entity == 'action_proposal').map((e) => e.action),
        containsAll(['propose', 'execute', 'undo']),
      );
    });

    test('a proposal whose data changed is not applied', () async {
      final p = (await endpoints.advisor.proposals(as(bob), groupA)).single;
      await endpoints.goal.set(as(bob), groupA, p.targetId, 15000);
      await expectLater(
        endpoints.advisor.accept(as(bob), p.id!),
        throwsA(
          isA<InvalidInputException>().having(
            (e) => e.code,
            'code',
            'proposal_stale',
          ),
        ),
      );
      final goals = await endpoints.goal.list(as(bob), groupA);
      expect(goals.single.amountCents, 15000, reason: 'left as it was');
      final now = await endpoints.advisor.proposals(as(bob), groupA);
      expect(
        now.any((x) => x.id == p.id && x.status == 'expired'),
        isTrue,
      );
    });

    test(
      'a reader may look but not accept; refused proposals stay refused',
      () async {
        final r = (await endpoints.advisor.proposals(
          as(reader),
          groupA,
        )).single;
        await expectLater(endpoints.advisor.accept(as(reader), r.id!), denied);
        expect(await endpoints.goal.list(as(alice), groupA), isEmpty);
        await expectLater(endpoints.advisor.refuse(as(reader), r.id!), denied);
        final b = (await endpoints.advisor.proposals(as(bob), groupA)).single;
        expect(
          (await endpoints.advisor.refuse(as(bob), b.id!)).status,
          'refused',
        );
        await expectLater(
          endpoints.advisor.accept(as(bob), b.id!),
          throwsA(isA<InvalidInputException>()),
        );
        await expectLater(
          endpoints.advisor.proposals(as(mallory), groupA),
          denied,
        );
      },
    );

    test('a loan read from a document: created when accepted, removed when '
        'undone', () async {
      final fields = {
        'lender': 'Banque Exemple',
        'label': 'Voiture',
        'kind': 'car',
        'principal_cents': 1500000,
        'annual_rate_milli': 3450,
        'duration_months': 48,
        'payment_cents': 33500,
        'insurance_monthly_cents': 0,
        'first_due_date': '2026-12-05',
      };
      final p = await ProposalService.propose(
        sessionBuilder.build(),
        groupId: groupA,
        kind: 'create_loan',
        targetId: groupA,
        currentValue: null,
        proposedValue: null,
        proposedData: jsonEncode(fields),
        reason: 'ai_loan',
        data: fields,
        origin: 'ai',
        provider: 'Test',
        model: 'test-1',
        forUser: bob,
      );
      expect(p, isNotNull);
      final done = await endpoints.advisor.accept(as(bob), p!.id!);
      expect(done.resultId, isNotNull);
      final loans = (await endpoints.loan.overview(as(bob), groupA)).loans;
      expect(loans.single.loan.lender, 'Banque Exemple');
      expect(loans.single.loan.durationMonths, 48);
      await endpoints.advisor.undo(as(bob), p.id!);
      expect((await endpoints.loan.overview(as(bob), groupA)).loans, isEmpty);
    });

    test('kinds are fixed: anything else is refused', () async {
      final session = sessionBuilder.build();
      await expectLater(
        ProposalService.propose(
          session,
          groupId: groupA,
          kind: 'transfer_money',
          targetId: 1,
          currentValue: null,
          proposedValue: 1,
          reason: 'x',
          data: const {},
          forUser: alice,
        ),
        throwsArgumentError,
      );
    });
  });
}
