import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Analyses without AI', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, bob, mallory;
    late int groupA;
    late Account shared, restricted;
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
    Future<void> debit(
      Account a,
      int monthsAgo,
      int day,
      int cents,
      String label,
    ) => BankTransaction.db.insertRow(
      db,
      BankTransaction(
        accountId: a.id!,
        date: DateTime.utc(now.year, now.month - monthsAgo, day),
        amountCents: -cents,
        rawLabel: label,
        cleanLabel: label,
        operationKind: 'other',
      ),
    );

    setUp(() async {
      db = sessionBuilder.build();
      alice = await user({'owncoffer.serverAdmin'});
      mallory = await user({'owncoffer.serverAdmin'});
      bob = await user({});
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
      for (var m = 1; m <= 5; m++) {
        await debit(shared, m, 3, 850, 'COTIS CARTE VISA');
        await debit(shared, m, 5, 4500, 'EDF');
      }
      await debit(shared, 0, 1, 21000, 'EDF');
      await debit(restricted, 0, 1, 1500, 'FRAIS TENUE DE COMPTE');
    });

    test('bank fees and unusual debits, on the visible accounts only; '
        'another household is refused', () async {
      await expectLater(
        endpoints.analysis.insights(as(mallory), groupA),
        throwsA(isA<AccessDeniedException>()),
      );
      final bob_ = await endpoints.analysis.insights(as(bob), groupA);
      expect(bob_.feeMonths, hasLength(12));
      expect(bob_.feeTotalCents, 5 * 850, reason: 'not the restricted fees');
      expect(bob_.feeLines.single.label, 'COTIS CARTE VISA');
      expect(
        [for (final u in bob_.unusual) (u.kind, u.transaction.cleanLabel)],
        [('amount', 'EDF')],
      );
      expect(bob_.unusual.single.usualCents, 4500);
      final alice_ = await endpoints.analysis.insights(as(alice), groupA);
      expect(alice_.feeTotalCents, 5 * 850 + 1500);
    });
  });
}
