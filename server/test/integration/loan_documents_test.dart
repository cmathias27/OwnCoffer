import 'dart:convert';
import 'dart:typed_data';

import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Loan: actual instalment and documents', (
    sessionBuilder,
    endpoints,
  ) {
    late Session db;
    late UuidValue alice, mallory, reader, bob;
    late int groupA;
    late Account shared, restricted;
    final denied = throwsA(isA<AccessDeniedException>());
    final invalid = throwsA(isA<InvalidInputException>());
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
    Loan terms({int? accountId, int? payment}) => Loan(
      groupId: 0,
      accountId: accountId,
      kind: LoanKind.mortgage,
      lender: 'Banque',
      principalCents: 10000000,
      annualRateMilli: 1000,
      durationMonths: 120,
      paymentCents: payment,
      firstDueDate: DateTime.utc(now.year, now.month - 3, 5),
      insuranceMonthlyCents: 1500,
    );
    ByteData bytes(List<int> b) => ByteData.sublistView(Uint8List.fromList(b));
    final pdf = bytes([...ascii.encode('%PDF-1.7\n'), 1, 2, 3]);

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
    });

    test('the actual instalment drives the schedule and the planned '
        'debits', () async {
      final computed = await endpoints.loan.create(as(bob), groupA, terms());
      expect(computed.paymentIsActual, isFalse);
      expect(computed.paymentCents, 87604);

      final actual = await endpoints.loan.create(
        as(bob),
        groupA,
        terms(accountId: shared.id, payment: 90000),
      );
      expect(actual.paymentIsActual, isTrue);
      expect(actual.paymentCents, 90000);
      expect(actual.totalCount, lessThan(120), reason: 'repaid sooner');
      final s = (await ScheduledTransaction.db.findById(
        db,
        actual.loan.scheduledId!,
      ))!;
      expect(s.amountCents, -(90000 + 1500));
      expect(s.occurrenceCount, actual.totalCount);
      final schedule = await endpoints.loan.schedule(
        as(reader),
        actual.loan.id!,
      );
      expect(schedule.first.paymentCents, 90000);
      expect(schedule.last.remainingCents, 0);

      // Not even the interest: refused.
      await expectLater(
        endpoints.loan.create(
          as(bob),
          groupA,
          terms(payment: 5000),
        ),
        invalid,
      );
    });

    test('declared from a debit: the debit is the instalment', () async {
      final t = await BankTransaction.db.insertRow(
        db,
        BankTransaction(
          accountId: shared.id!,
          date: DateTime.utc(now.year, now.month - 1, 5),
          amountCents: -(91000 + 1500),
          rawLabel: 'PRLV PRET 77',
          cleanLabel: 'PRET 77',
          operationKind: 'directDebit',
        ),
      );
      final r = await endpoints.loan.createFromTransaction(
        as(bob),
        t.id!,
        terms(),
      );
      expect(r.info.loan.paymentCents, 91000);
      expect(r.info.paymentIsActual, isTrue);
    });

    test(
      'documents: kept, listed without content, downloaded, deleted',
      () async {
        final loan = (await endpoints.loan.create(
          as(bob),
          groupA,
          terms(),
        )).loan;
        final doc = await endpoints.loan.uploadDocument(
          as(bob),
          loan.id!,
          ' tableau/2026.pdf ',
          pdf,
        );
        expect(doc.fileName, 'tableau_2026.pdf');
        expect(doc.mimeType, 'application/pdf');
        expect(doc.sizeBytes, pdf.lengthInBytes);
        final list = await endpoints.loan.documents(as(reader), loan.id!);
        expect([for (final d in list) d.id], [doc.id]);
        final back = await endpoints.loan.downloadDocument(as(reader), doc.id!);
        expect(
          back.buffer.asUint8List(back.offsetInBytes, back.lengthInBytes),
          pdf.buffer.asUint8List(),
        );

        await expectLater(
          endpoints.loan.uploadDocument(
            as(bob),
            loan.id!,
            'x.pdf',
            bytes([1, 2]),
          ),
          invalid,
          reason: 'not a PDF',
        );
        await expectLater(
          endpoints.loan.uploadDocument(as(bob), loan.id!, 'x.exe', pdf),
          invalid,
        );
        await expectLater(
          endpoints.loan.uploadDocument(
            as(bob),
            loan.id!,
            'big.pdf',
            bytes([
              ...ascii.encode('%PDF'),
              ...List.filled(10 * 1024 * 1024, 0),
            ]),
          ),
          invalid,
        );
        final csv = await endpoints.loan.uploadDocument(
          as(bob),
          loan.id!,
          'echeances.csv',
          bytes(utf8.encode('date;montant\n2026-01-05;900,00\n')),
        );
        expect(csv.mimeType, 'text/csv');

        await endpoints.loan.deleteDocument(as(bob), doc.id!);
        expect(await LoanDocumentBlob.db.count(db), 1, reason: 'csv left');
        // Deleting the loan for good removes its documents (cascade).
      },
    );

    test(
      'documents isolation: another group, a reader, a hidden account',
      () async {
        final loan = (await endpoints.loan.create(
          as(bob),
          groupA,
          terms(),
        )).loan;
        final hidden = (await endpoints.loan.create(
          as(alice),
          groupA,
          terms(accountId: restricted.id),
        )).loan;
        final doc = await endpoints.loan.uploadDocument(
          as(bob),
          loan.id!,
          'offre.pdf',
          pdf,
        );
        final secret = await endpoints.loan.uploadDocument(
          as(alice),
          hidden.id!,
          'perso.pdf',
          pdf,
        );
        await expectLater(
          endpoints.loan.documents(as(mallory), loan.id!),
          denied,
        );
        await expectLater(
          endpoints.loan.downloadDocument(as(mallory), doc.id!),
          denied,
        );
        await expectLater(
          endpoints.loan.uploadDocument(as(mallory), loan.id!, 'a.pdf', pdf),
          denied,
        );
        await expectLater(
          endpoints.loan.deleteDocument(as(mallory), doc.id!),
          denied,
        );
        await expectLater(
          endpoints.loan.uploadDocument(as(reader), loan.id!, 'a.pdf', pdf),
          denied,
        );
        await expectLater(
          endpoints.loan.deleteDocument(as(reader), doc.id!),
          denied,
        );
        await expectLater(
          endpoints.loan.downloadDocument(as(bob), secret.id!),
          denied,
        );
        expect(await LoanDocument.db.count(db), 2);
      },
    );
  });
}
