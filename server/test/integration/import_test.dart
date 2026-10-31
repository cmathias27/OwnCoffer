import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

ByteData fixture(String name) => ByteData.sublistView(
  File('../shared/test/fixtures/$name').readAsBytesSync(),
);

void main() {
  withServerpod('Import', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, reader, mallory;
    late int groupA;
    late Account account;

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
      );
    });

    Future<int> categoryOf(String code) async =>
        (await Category.db.findFirstRow(
          db,
          where: (c) => c.groupId.equals(groupA) & c.standardCode.equals(code),
        ))!.id!;

    Future<List<BankTransaction>> ops() => BankTransaction.db.find(
      db,
      where: (t) => t.accountId.equals(account.id!) & t.deletedAt.equals(null),
    );

    test('preview reads, classifies and writes nothing', () async {
      final p = await endpoints.import.preview(
        as(alice),
        account.id!,
        fixture('ce_export.qif'),
      );
      expect(p.format, 'qif');
      expect(p.readCount, 20);
      expect(p.newCount, 20);
      expect(p.duplicateCount, 0);
      expect(p.errorCount, 0);
      expect(p.classifiedCount, greaterThanOrEqualTo(14));
      final carrefour = p.lines.firstWhere(
        (l) => l.label.contains('CARREFOUR'),
      );
      expect(carrefour.categoryId, await categoryOf('food.groceries'));
      expect(carrefour.categorySource, CategorySource.communityRule);
      expect(carrefour.cleanLabel, 'CARREFOUR MARKET');
      expect(await ops(), isEmpty);
    });

    test(
      'import, then the same file or the other format adds nothing',
      () async {
        final first = await endpoints.import.commit(
          as(alice),
          account.id!,
          'export.qif',
          fixture('ce_export.qif'),
        );
        expect(first.addedCount, 20);
        final saved = await ops();
        expect(saved, hasLength(20));
        expect(
          saved.fold<int>(0, (s, t) => s + t.amountCents),
          63917,
          reason: 'every cent kept',
        );
        expect(
          saved.where((t) => t.rawLabel.contains('BOULANGERIE')),
          hasLength(2),
        );

        final again = await endpoints.import.preview(
          as(alice),
          account.id!,
          fixture('ce_export.qif'),
        );
        expect(again.sameFileAlreadyImported, isTrue);
        expect(again.newCount, 0);

        final ofx = await endpoints.import.commit(
          as(alice),
          account.id!,
          'export.ofx',
          fixture('ce_export.ofx'),
        );
        expect(ofx.addedCount, 0);
        expect(ofx.duplicateCount, 20);
        expect(await ops(), hasLength(20));
      },
    );

    group('account recognised from the OFX number', () {
      // The fixture has a placeholder number (zeros, ignored): a fictional
      // one is put in its place.
      ByteData ofxOf(String number) => ByteData.sublistView(
        utf8.encode(
          utf8
              .decode(fixture('ce_export.ofx').buffer.asUint8List())
              .replaceFirst('<ACCTID>00000000000', '<ACCTID>$number'),
        ),
      );

      test('learnt at the first import, never stored in clear', () async {
        final file = ofxOf('12345678901');
        final first = await endpoints.import.preview(
          as(alice),
          account.id!,
          file,
        );
        expect(first.recognisedAccountId, isNull);
        await endpoints.import.commit(
          as(alice),
          account.id!,
          'a.ofx',
          file,
        );
        final saved = (await Account.db.findById(db, account.id!))!;
        expect(saved.bankAccountKey, isNotNull);
        expect(saved.bankAccountKey, isNot(contains('12345678901')));

        final other = await endpoints.account.create(
          as(alice),
          groupA,
          'Joint',
          AccountKind.checking,
        );
        final p = await endpoints.import.preview(as(alice), other.id!, file);
        expect(p.recognisedAccountId, account.id);
        expect(p.otherBankAccount, isFalse);

        final same = await endpoints.import.preview(
          as(alice),
          account.id!,
          file,
        );
        expect(same.recognisedAccountId, account.id);

        final wrong = await endpoints.import.preview(
          as(alice),
          account.id!,
          ofxOf('99999999999'),
        );
        expect(wrong.recognisedAccountId, isNull);
        expect(wrong.otherBankAccount, isTrue);
      });

      test('a restricted account is not revealed to others', () async {
        final file = ofxOf('12345678901');
        await endpoints.import.commit(
          as(alice),
          account.id!,
          'a.ofx',
          file,
        );
        await endpoints.account.update(
          as(alice),
          account.id!,
          visibility: AccountVisibility.restricted,
        );
        final shared = await endpoints.account.create(
          as(alice),
          groupA,
          'Joint',
          AccountKind.checking,
        );
        final bob = await user({});
        await GroupMember.db.insertRow(
          db,
          GroupMember(groupId: groupA, authUserId: bob, role: MemberRole.user),
        );
        final p = await endpoints.import.preview(as(bob), shared.id!, file);
        expect(p.recognisedAccountId, isNull);
      });

      test('another group\'s account is never revealed', () async {
        final file = ofxOf('12345678901');
        await endpoints.import.commit(
          as(alice),
          account.id!,
          'a.ofx',
          file,
        );
        final groupB = (await endpoints.group.myGroups(
          as(mallory),
        )).single.group.id!;
        final theirs = await endpoints.account.create(
          as(mallory),
          groupB,
          'B',
          AccountKind.checking,
        );
        final p = await endpoints.import.preview(
          as(mallory),
          theirs.id!,
          file,
        );
        expect(p.recognisedAccountId, isNull);
        expect(p.otherBankAccount, isFalse);
      });
    });

    test('the balance after import is compared with the bank one', () async {
      final before = await endpoints.import.preview(
        as(alice),
        account.id!,
        fixture('ce_export.ofx'),
      );
      expect(before.statedBalanceCents, 183917);
      // Initial balance 0: the 20 operations only.
      expect(before.balanceAfterImportCents, 63917);

      await endpoints.import.commit(
        as(alice),
        account.id!,
        'export.qif',
        fixture('ce_export.qif'),
      );
      final after = await endpoints.import.preview(
        as(alice),
        account.id!,
        fixture('ce_export.ofx'),
      );
      expect(after.newCount, 0);
      expect(
        after.balanceAfterImportCents,
        63917,
        reason: 'duplicates are not counted twice',
      );
    });

    test('group rules win over community rules', () async {
      final restaurants = await categoryOf('food.restaurants');
      await endpoints.rule.create(
        as(alice),
        groupA,
        restaurants,
        'CARREFOUR',
        RuleMatchType.contains,
      );
      final p = await endpoints.import.preview(
        as(alice),
        account.id!,
        fixture('ce_export.qif'),
      );
      final carrefour = p.lines.firstWhere(
        (l) => l.label.contains('CARREFOUR'),
      );
      expect(carrefour.categoryId, restaurants);
      expect(carrefour.categorySource, CategorySource.groupRule);
    });

    test('history learns from manual choices', () async {
      await endpoints.import.commit(
        as(alice),
        account.id!,
        'export.qif',
        fixture('ce_export.qif'),
      );
      final gifts = await categoryOf('leisure.gifts');
      final cafe = (await ops()).firstWhere((t) => t.rawLabel.contains('CAFE'));
      await BankTransaction.db.updateRow(
        db,
        cafe.copyWith(categoryId: gifts, categorySource: CategorySource.manual),
      );
      final p = await endpoints.import.preview(
        as(alice),
        account.id!,
        ByteData.sublistView(
          utf8.encode(
            '!Type:Bank\nD01/11/2026\nT-3.10\nPCB CAFE DE LA GARE FACT 011126\n^\n',
          ),
        ),
      );
      expect(p.lines.single.categoryId, gifts);
      expect(p.lines.single.categorySource, CategorySource.history);
    });

    test(
      'possible duplicates are skipped unless the user accepts them',
      () async {
        // Manual entry: same date and amount as the Carrefour payment.
        await BankTransaction.db.insertRow(
          db,
          BankTransaction(
            accountId: account.id!,
            date: DateTime.utc(2026, 10, 30),
            amountCents: -4512,
            rawLabel: 'Courses',
            cleanLabel: 'COURSES',
            operationKind: 'other',
          ),
        );
        final p = await endpoints.import.preview(
          as(alice),
          account.id!,
          fixture('ce_export.qif'),
        );
        expect(p.possibleDuplicateCount, 1);
        final index = p.lines
            .firstWhere((l) => l.status == 'possibleDuplicate')
            .index;

        final skipped = await endpoints.import.commit(
          as(alice),
          account.id!,
          'a.qif',
          fixture('ce_export.qif'),
        );
        expect(skipped.addedCount, 19);
        await endpoints.import.cancel(as(alice), skipped.id!);

        final accepted = await endpoints.import.commit(
          as(alice),
          account.id!,
          'a.qif',
          fixture('ce_export.qif'),
          acceptedPossibleDuplicates: [index],
        );
        expect(accepted.addedCount, 20);
        expect(await ops(), hasLength(21));
      },
    );

    test(
      'cancel moves operations to the trash; the file can be re-imported',
      () async {
        final first = await endpoints.import.commit(
          as(alice),
          account.id!,
          'a.qif',
          fixture('ce_export.qif'),
        );
        final cancelled = await endpoints.import.cancel(as(alice), first.id!);
        expect(cancelled.cancelledAt, isNotNull);
        expect(await ops(), isEmpty);
        final trashed = await BankTransaction.db.find(
          db,
          where: (t) => t.importId.equals(first.id!),
        );
        expect(trashed.every((t) => t.fingerprint == null), isTrue);
        expect(trashed.every((t) => t.trashedFingerprint != null), isTrue);
        final again = await endpoints.import.commit(
          as(alice),
          account.id!,
          'a.qif',
          fixture('ce_export.qif'),
        );
        expect(again.addedCount, 20);
        final history = await endpoints.import.history(as(alice), account.id!);
        expect(history.map((h) => h.id), [again.id, first.id]);
      },
    );

    test('unreadable or empty files are refused with a code', () async {
      await expectLater(
        endpoints.import.preview(
          as(alice),
          account.id!,
          ByteData.sublistView(utf8.encode('not a bank file')),
        ),
        throwsA(
          isA<InvalidInputException>().having(
            (e) => e.code,
            'code',
            'import_unknown_format',
          ),
        ),
      );
      await expectLater(
        endpoints.import.preview(as(alice), account.id!, ByteData(0)),
        throwsA(isA<InvalidInputException>()),
      );
    });

    group('isolation (decision 0016)', () {
      final denied = throwsA(isA<AccessDeniedException>());

      test('another group cannot preview, import, list or cancel', () async {
        final mine = await endpoints.import.commit(
          as(alice),
          account.id!,
          'a.qif',
          fixture('ce_export.qif'),
        );
        await expectLater(
          endpoints.import.preview(
            as(mallory),
            account.id!,
            fixture('ce_export.qif'),
          ),
          denied,
        );
        await expectLater(
          endpoints.import.commit(
            as(mallory),
            account.id!,
            'x.qif',
            fixture('ce_export.qif'),
          ),
          denied,
        );
        await expectLater(
          endpoints.import.history(as(mallory), account.id!),
          denied,
        );
        await expectLater(
          endpoints.import.cancel(as(mallory), mine.id!),
          denied,
        );
        expect(await ops(), hasLength(20));
      });

      test('a reader cannot import nor cancel', () async {
        await expectLater(
          endpoints.import.commit(
            as(reader),
            account.id!,
            'x.qif',
            fixture('ce_export.qif'),
          ),
          denied,
        );
        expect(
          await endpoints.import.history(as(reader), account.id!),
          isEmpty,
        );
      });
    });
  });
}
