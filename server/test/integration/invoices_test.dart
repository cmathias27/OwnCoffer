import 'dart:convert';
import 'dart:typed_data';

import 'package:owncoffer_server/src/finance/warranty_alert_service.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/mail/mail_service.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' show LocalDate;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Invoices', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, bob, reader, mallory;
    late int groupA;
    late Account shared, restricted;
    late BankTransaction darty, secret;
    final denied = throwsA(isA<AccessDeniedException>());
    final invalid = throwsA(isA<InvalidInputException>());
    final now = DateTime.now().toUtc();
    final today = LocalDate(now.year, now.month, now.day);

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> user(String email, Set<String> scopes) async {
      final id = (await AuthUser.db.insertRow(
        db,
        AuthUser(createdAt: DateTime.now(), scopeNames: scopes, blocked: false),
      )).id!;
      await UserProfile.db.insertRow(
        db,
        UserProfile(authUserId: id, email: email, fullName: email[0]),
      );
      return id;
    }

    ByteData bytes(List<int> b) => ByteData.sublistView(Uint8List.fromList(b));
    final pdf = bytes([...ascii.encode('%PDF-1.7\n'), 1, 2, 3]);
    final jpg = bytes([0xFF, 0xD8, 0xFF, 0xE0, 1, 2]);
    Future<BankTransaction> op(Account a, String label, int cents) =>
        BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: a.id!,
            date: DateTime.utc(2026, 10, 31),
            amountCents: cents,
            rawLabel: 'CB $label',
            cleanLabel: label,
            operationKind: 'card',
          ),
        );

    setUp(() async {
      db = sessionBuilder.build();
      MailService.instance = MailService.recording();
      alice = await user('alice@example.org', {'owncoffer.serverAdmin'});
      mallory = await user('mallory@example.org', {'owncoffer.serverAdmin'});
      bob = await user('bob@example.org', {});
      reader = await user('reader@example.org', {});
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
      darty = await op(shared, 'DARTY', -49900);
      secret = await op(restricted, 'BIJOUX', -12000);
    });

    test('attached, named after the operation, listed, opened, '
        'marked in the operations list', () async {
      final first = await endpoints.invoice.upload(
        as(bob),
        darty.id!,
        'scan.pdf',
        pdf,
      );
      expect(first.name, '2026-10-31 - DARTY - 499,00 EUR.pdf');
      expect(first.accountName, 'Courant');
      expect(first.invoice.mimeType, 'application/pdf');
      final second = await endpoints.invoice.upload(
        as(bob),
        darty.id!,
        'photo.jpg',
        jpg,
      );
      expect(second.name, '2026-10-31 - DARTY - 499,00 EUR (2).jpg');

      final updated = await endpoints.invoice.update(
        as(bob),
        first.invoice.id!,
        ' Lave-linge ',
        DateTime.utc(2028, 10, 31, 15),
      );
      expect(updated.name, '2026-10-31 - DARTY - Lave-linge - 499,00 EUR.pdf');
      expect(updated.invoice.warrantyUntil, DateTime.utc(2028, 10, 31));

      final list = await endpoints.invoice.list(as(reader), groupA);
      expect(
        [for (final i in list) i.invoice.id],
        [
          second.invoice.id,
          first.invoice.id,
        ],
      );
      expect(
        (await endpoints.invoice.list(as(reader), groupA, search: 'lave')).map(
          (i) => i.invoice.id,
        ),
        [first.invoice.id],
      );
      expect(
        (await endpoints.invoice.list(as(reader), groupA, warranty: true)).map(
          (i) => i.invoice.id,
        ),
        [first.invoice.id],
      );
      expect(await endpoints.invoice.list(as(reader), groupA, year: 2025), []);
      expect(
        await endpoints.invoice.forTransaction(as(reader), darty.id!),
        hasLength(2),
      );
      final back = await endpoints.invoice.download(
        as(reader),
        first.invoice.id!,
      );
      expect(
        back.buffer.asUint8List(back.offsetInBytes, back.lengthInBytes),
        pdf.buffer.asUint8List(),
      );

      final page = await endpoints.transaction.list(as(reader), shared.id!);
      expect(page.withInvoices, [darty.id]);

      // Clearing the label and the warranty.
      final cleared = await endpoints.invoice.update(
        as(bob),
        first.invoice.id!,
        '',
        null,
      );
      expect(cleared.invoice.label, isNull);
      expect(cleared.invoice.warrantyUntil, isNull);

      await endpoints.invoice.delete(as(bob), second.invoice.id!);
      expect(await InvoiceBlob.db.count(db), 1, reason: 'content deleted too');
    });

    test('only PDFs and images, 10 MB at most', () async {
      await expectLater(
        endpoints.invoice.upload(as(bob), darty.id!, 'x.pdf', bytes([1, 2])),
        invalid,
        reason: 'not a PDF',
      );
      await expectLater(
        endpoints.invoice.upload(
          as(bob),
          darty.id!,
          'x.csv',
          bytes(ascii.encode('a;b')),
        ),
        invalid,
      );
      await expectLater(
        endpoints.invoice.upload(
          as(bob),
          darty.id!,
          'big.pdf',
          bytes([...ascii.encode('%PDF'), ...List.filled(10 * 1024 * 1024, 0)]),
        ),
        invalid,
      );
      expect(await Invoice.db.count(db), 0);
    });

    test('isolation: other group, restricted account, reader', () async {
      final mine = await endpoints.invoice.upload(
        as(bob),
        darty.id!,
        'a.pdf',
        pdf,
      );
      final hidden = await endpoints.invoice.upload(
        as(alice),
        secret.id!,
        'b.pdf',
        pdf,
      );
      final id = mine.invoice.id!;

      // Another group sees and changes nothing.
      await expectLater(endpoints.invoice.list(as(mallory), groupA), denied);
      await expectLater(
        endpoints.invoice.forTransaction(as(mallory), darty.id!),
        denied,
      );
      await expectLater(
        endpoints.invoice.upload(as(mallory), darty.id!, 'm.pdf', pdf),
        denied,
      );
      await expectLater(endpoints.invoice.download(as(mallory), id), denied);
      await expectLater(
        endpoints.invoice.update(as(mallory), id, 'x', null),
        denied,
      );
      await expectLater(
        endpoints.invoice.send(as(mallory), id, 'm@example.org', null),
        denied,
      );
      await expectLater(endpoints.invoice.delete(as(mallory), id), denied);

      // The restricted account's invoice stays hidden from bob.
      expect(
        (await endpoints.invoice.list(as(bob), groupA)).map(
          (i) => i.invoice.id,
        ),
        [id],
      );
      await expectLater(
        endpoints.invoice.download(as(bob), hidden.invoice.id!),
        denied,
      );
      await expectLater(
        endpoints.invoice.forTransaction(as(bob), secret.id!),
        denied,
      );

      // A reader reads but does not change.
      await expectLater(
        endpoints.invoice.upload(as(reader), darty.id!, 'r.pdf', pdf),
        denied,
      );
      await expectLater(endpoints.invoice.delete(as(reader), id), denied);
      await expectLater(
        endpoints.invoice.update(as(reader), id, 'x', null),
        denied,
      );

      final kept = (await Invoice.db.findById(db, id))!;
      expect(kept.label, isNull);
      expect(await Invoice.db.count(db), 2);
      expect(MailService.instance.outbox, isEmpty);

      // In the trash, the operation's invoices are hidden; restored, back.
      await endpoints.transaction.trash(as(bob), darty.id!);
      expect(await endpoints.invoice.list(as(bob), groupA), isEmpty);
      await expectLater(endpoints.invoice.download(as(bob), id), denied);
      await endpoints.transaction.restore(as(bob), darty.id!);
      expect(await endpoints.invoice.list(as(bob), groupA), hasLength(1));
    });

    test('emailed with the invoice attached, limited per day', () async {
      final i = await endpoints.invoice.upload(
        as(bob),
        darty.id!,
        'a.pdf',
        pdf,
      );
      await endpoints.invoice.send(
        as(bob),
        i.invoice.id!,
        ' SAV@Example.org ',
        'Bonjour, voici la facture.',
      );
      final mail = MailService.instance.outbox.single;
      expect(mail.to, 'sav@example.org');
      expect(mail.subject, contains('2026-10-31 - DARTY - 499,00 EUR.pdf'));
      expect(mail.body, startsWith('Bonjour, voici la facture.'));
      expect(mail.attachments.single.name, i.name);
      expect(mail.attachments.single.bytes, pdf.buffer.asUint8List());

      await expectLater(
        endpoints.invoice.send(as(bob), i.invoice.id!, 'pas une adresse', null),
        invalid,
      );
      for (var n = 1; n < 20; n++) {
        await endpoints.invoice.send(as(bob), i.invoice.id!, 'a@b.fr', null);
      }
      await expectLater(
        endpoints.invoice.send(as(bob), i.invoice.id!, 'a@b.fr', null),
        throwsA(
          isA<InvalidInputException>().having(
            (e) => e.code,
            'code',
            'send_limit',
          ),
        ),
      );

      MailService.instance = MailService.fromEnvironment(const {});
      await expectLater(
        endpoints.invoice.send(as(alice), i.invoice.id!, 'a@b.fr', null),
        throwsA(
          isA<InvalidInputException>().having(
            (e) => e.code,
            'code',
            'mail_not_configured',
          ),
        ),
      );
    });

    test(
      'warranty reminder a month before, once, to those who see it',
      () async {
        final soon = await endpoints.invoice.upload(
          as(alice),
          secret.id!,
          'a.pdf',
          pdf,
        );
        await endpoints.invoice.update(
          as(alice),
          soon.invoice.id!,
          'Montre',
          now.add(const Duration(days: 20)),
        );
        final later = await endpoints.invoice.upload(
          as(bob),
          darty.id!,
          'b.pdf',
          pdf,
        );
        await endpoints.invoice.update(
          as(bob),
          later.invoice.id!,
          null,
          now.add(const Duration(days: 90)),
        );

        expect(await WarrantyAlertService.checkAll(db, today), 1);
        final n = (await AppNotification.db.find(db)).single;
        expect(n.authUserId, alice, reason: 'restricted account: admin only');
        expect(n.type, WarrantyAlertService.type);
        expect(jsonDecode(n.data)['name'], 'Montre');
        expect(MailService.instance.outbox.single.to, 'alice@example.org');
        expect(await WarrantyAlertService.checkAll(db, today), 0);
      },
    );
  });
}
