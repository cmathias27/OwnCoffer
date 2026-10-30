import 'package:owncoffer_server/src/core/dates.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' show LocalDate;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Schema v1', (sessionBuilder, endpoints) {
    late Session session;
    late Account account;

    setUp(() async {
      session = sessionBuilder.build();
      final user = await AuthUser.db.insertRow(
        session,
        AuthUser(createdAt: DateTime.now(), scopeNames: {}, blocked: false),
      );
      final group = await FinanceGroup.db.insertRow(
        session,
        FinanceGroup(name: 'Foyer test', createdBy: user.id!),
      );
      await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: group.id!,
          authUserId: user.id!,
          role: MemberRole.admin,
        ),
      );
      account = await Account.db.insertRow(
        session,
        Account(
          groupId: group.id!,
          name: 'Compte courant',
          kind: AccountKind.checking,
          initialBalanceCents: 100000,
        ),
      );
    });

    BankTransaction tx(String? fingerprint, {int cents = -1234}) =>
        BankTransaction(
          accountId: account.id!,
          date: LocalDate(2026, 10, 30).toDb(),
          amountCents: cents,
          rawLabel: 'CB TEST',
          cleanLabel: 'TEST',
          operationKind: 'card',
          fingerprint: fingerprint,
        );

    test('stores cents and calendar dates exactly', () async {
      final saved = await BankTransaction.db.insertRow(
        session,
        tx('a', cents: -123456789),
      );
      final read = await BankTransaction.db.findById(session, saved.id!);
      expect(read!.amountCents, -123456789);
      expect(read.date.toLocalDate(), LocalDate(2026, 10, 30));
      expect(read.categorySource, CategorySource.none);
      expect(account.currency, 'EUR');
    });

    test('a fingerprint is unique per account', () async {
      await BankTransaction.db.insertRow(session, tx('same'));
      await expectLater(
        BankTransaction.db.insertRow(session, tx('same')),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('manual entries (no fingerprint) never collide', () async {
      await BankTransaction.db.insertRow(session, tx(null));
      await BankTransaction.db.insertRow(session, tx(null));
      final count = await BankTransaction.db.count(
        session,
        where: (t) => t.accountId.equals(account.id!),
      );
      expect(count, 2);
    });
  });
}
