import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Global search (decision 0041)', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, mallory, bob;
    late int groupA, groupB;
    late Account shared, restricted;
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
    Future<BankTransaction> op(Account a, String label, int cents) =>
        BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: a.id!,
            date: DateTime.utc(2026, 10, 3),
            amountCents: cents,
            rawLabel: 'CB $label',
            cleanLabel: label,
            operationKind: 'card',
            categorySource: CategorySource.none,
          ),
        );
    Loan loan(int groupId, String lender, {int? accountId}) => Loan(
      groupId: groupId,
      accountId: accountId,
      kind: LoanKind.consumer,
      lender: lender,
      principalCents: 500000,
      annualRateMilli: 3000,
      durationMonths: 24,
      firstDueDate: DateTime.utc(2026, 1, 10),
    );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({'owncoffer.serverAdmin'});
      bob = await user({});
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      groupB = (await endpoints.group.create(as(mallory), 'B')).group.id!;
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
    });

    test('operations of every visible account, loans, amounts', () async {
      await op(shared, 'BOULANGERIE DU PORT', -450);
      await op(shared, 'PHARMACIE', -4250);
      await op(restricted, 'BOULANGERIE SECRETE', -300);
      await Loan.db.insertRow(db, loan(groupA, 'Banque du Port'));
      await Loan.db.insertRow(
        db,
        loan(groupA, 'Port Crédit', accountId: restricted.id),
      );

      final a = await endpoints.search.global(as(alice), groupA, 'port');
      expect(
        [for (final t in a.operations) t.cleanLabel],
        [
          'BOULANGERIE DU PORT',
        ],
      );
      expect(
        [for (final l in a.loans) l.lender],
        [
          'Banque du Port',
          'Port Crédit',
        ],
      );

      final b = await endpoints.search.global(as(bob), groupA, 'boulangerie');
      expect(
        [for (final t in b.operations) t.cleanLabel],
        ['BOULANGERIE DU PORT'],
        reason: 'the restricted account is hidden from bob',
      );
      final bLoans = await endpoints.search.global(as(bob), groupA, 'port');
      expect([for (final l in bLoans.loans) l.lender], ['Banque du Port']);

      final amount = await endpoints.search.global(as(bob), groupA, '42,50');
      expect(
        [for (final t in amount.operations) t.cleanLabel],
        [
          'PHARMACIE',
        ],
      );

      // LIKE wildcards are searched as text.
      final wild = await endpoints.search.global(as(alice), groupA, '%_');
      expect(wild.operations, isEmpty);
      final short = await endpoints.search.global(as(alice), groupA, 'p');
      expect(short.operations, isEmpty);
    });

    test('isolation: another group is refused, sees nothing', () async {
      await op(shared, 'BOULANGERIE DU PORT', -450);
      await expectLater(
        endpoints.search.global(as(mallory), groupA, 'boulangerie'),
        denied,
      );
      final own = await endpoints.search.global(
        as(mallory),
        groupB,
        'boulangerie',
      );
      expect(own.operations, isEmpty);
      expect(own.loans, isEmpty);
      expect(own.invoices, isEmpty);
    });
  });
}
