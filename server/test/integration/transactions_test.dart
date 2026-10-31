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
  withServerpod('Operations', (sessionBuilder, endpoints) {
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
    Future<int> category(String code) async => (await Category.db.findFirstRow(
      db,
      where: (c) => c.groupId.equals(groupA) & c.standardCode.equals(code),
    ))!.id!;

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
      await endpoints.import.commit(
        as(alice),
        account.id!,
        'a.qif',
        fixture('ce_export.qif'),
      );
    });

    test('list: newest first, paging, search, filters', () async {
      final all = await endpoints.transaction.list(as(alice), account.id!);
      expect(all.total, 20);
      expect(all.items.first.date, DateTime.utc(2026, 10, 30));
      expect(all.items.last.date, DateTime.utc(2026, 10, 1));
      final page = await endpoints.transaction.list(
        as(alice),
        account.id!,
        limit: 5,
        offset: 5,
      );
      expect(page.items, hasLength(5));
      expect(page.total, 20);
      final search = await endpoints.transaction.list(
        as(alice),
        account.id!,
        search: 'boulangerie',
      );
      expect(search.total, 2);
      final wildcard = await endpoints.transaction.list(
        as(alice),
        account.id!,
        search: '%',
      );
      expect(wildcard.total, 0, reason: 'LIKE wildcards are escaped');
      final october = await endpoints.transaction.list(
        as(alice),
        account.id!,
        from: DateTime.utc(2026, 10, 25),
        to: DateTime.utc(2026, 10, 27),
      );
      expect(
        october.items.every(
          (t) =>
              !t.date.isBefore(DateTime.utc(2026, 10, 25)) &&
              !t.date.isAfter(DateTime.utc(2026, 10, 27)),
        ),
        isTrue,
      );
      final todo = await endpoints.transaction.list(
        as(alice),
        account.id!,
        toClassify: true,
      );
      expect(todo.items.every((t) => t.categoryId == null), isTrue);
      final groceries = await endpoints.transaction.list(
        as(alice),
        account.id!,
        categoryId: await category('food.groceries'),
      );
      expect(groceries.total, greaterThanOrEqualTo(2));
      expect(groceries.amountSumCents, isNull);

      final label = search.items.first.cleanLabel;
      final same = await endpoints.transaction.list(
        as(alice),
        account.id!,
        sameLabel: label,
      );
      expect(same.total, greaterThanOrEqualTo(1));
      expect(same.items.every((t) => t.cleanLabel == label), isTrue);
      expect(
        same.amountSumCents,
        same.items.fold<int>(0, (a, t) => a + t.amountCents),
      );
      final none = await endpoints.transaction.list(
        as(alice),
        account.id!,
        sameLabel: label.substring(0, 2),
      );
      expect(none.total, 0, reason: 'exact label, not a search');
      expect(none.amountSumCents, 0);
    });

    test(
      'manual entry is classified by the rules; a given category wins',
      () async {
        final auto = await endpoints.transaction.create(
          as(alice),
          account.id!,
          DateTime.utc(2026, 10, 31),
          -2350,
          'CB INTERMARCHE',
        );
        expect(auto.categoryId, await category('food.groceries'));
        expect(auto.categorySource, CategorySource.communityRule);
        expect(auto.fingerprint, isNull);
        final chosen = await endpoints.transaction.create(
          as(alice),
          account.id!,
          DateTime.utc(2026, 10, 31),
          -500,
          'Marché',
          categoryId: await category('food.groceries'),
        );
        expect(chosen.categorySource, CategorySource.manual);
        await expectLater(
          endpoints.transaction.create(
            as(alice),
            account.id!,
            DateTime.utc(2026, 10, 31),
            0,
            'Zéro',
          ),
          throwsA(isA<InvalidInputException>()),
        );
      },
    );

    test('imported operations keep what the bank wrote', () async {
      final t = (await endpoints.transaction.list(
        as(alice),
        account.id!,
      )).items.first;
      await expectLater(
        endpoints.transaction.update(as(alice), t.id!, amountCents: -1),
        throwsA(isA<InvalidInputException>()),
      );
      final noted = await endpoints.transaction.update(
        as(alice),
        t.id!,
        note: 'Note',
      );
      expect(noted.note, 'Note');
      expect(noted.memo, t.memo, reason: 'bank details untouched');
      expect(noted.amountCents, t.amountCents);
    });

    test('category correction, back to "to classify", checking', () async {
      final t = (await endpoints.transaction.list(
        as(alice),
        account.id!,
        search: 'CAFE',
      )).items.single;
      final gifts = await category('leisure.gifts');
      final set = await endpoints.transaction.setCategory(
        as(alice),
        t.id!,
        gifts,
      );
      expect(set.categorySource, CategorySource.manual);
      final cleared = await endpoints.transaction.setCategory(
        as(alice),
        t.id!,
        null,
      );
      expect(cleared.categoryId, isNull);
      expect(cleared.categorySource, CategorySource.none);
      final checked = await endpoints.transaction.setCleared(
        as(alice),
        t.id!,
        true,
      );
      expect(checked.cleared, isTrue);
    });

    test(
      'rule from a correction reclassifies others, never manual choices',
      () async {
        final bakery = (await endpoints.transaction.list(
          as(alice),
          account.id!,
          search: 'BOULANGERIE',
        )).items;
        final restaurants = await category('food.restaurants');
        final gifts = await category('leisure.gifts');
        // The second bakery purchase was set by hand: it must not change.
        await endpoints.transaction.setCategory(
          as(alice),
          bakery[1].id!,
          gifts,
        );
        final r = await endpoints.transaction.createRuleFrom(
          as(alice),
          bakery[0].id!,
          restaurants,
        );
        expect(r.rule.pattern, 'BOULANGERIE DU COIN');
        expect(r.rule.direction, RuleDirection.debit);
        expect(r.reclassifiedCount, 0);
        final after = {
          for (final t in (await endpoints.transaction.list(
            as(alice),
            account.id!,
            search: 'BOULANGERIE',
          )).items)
            t.id: t,
        };
        expect(after[bakery[0].id]!.categoryId, restaurants);
        expect(after[bakery[0].id]!.categorySource, CategorySource.manual);
        expect(after[bakery[1].id]!.categoryId, gifts);

        // A new import uses the rule.
        final p = await endpoints.import.preview(
          as(alice),
          account.id!,
          ByteData.sublistView(
            utf8.encode(
              '!Type:Bank\nD02/11/2026\nT-2.50\nPCB BOULANGERIE DU COIN FACT 011126\n^\n',
            ),
          ),
        );
        expect(p.lines.single.categoryId, restaurants);
        expect(p.lines.single.categorySource, CategorySource.groupRule);
      },
    );

    test(
      'trash and restore; restore refused if re-imported meanwhile',
      () async {
        final t = (await endpoints.transaction.list(
          as(alice),
          account.id!,
          search: 'CARREFOUR',
        )).items.single;
        await endpoints.transaction.trash(as(alice), t.id!);
        expect(
          (await endpoints.transaction.list(as(alice), account.id!)).total,
          19,
        );
        final back = await endpoints.transaction.restore(as(alice), t.id!);
        expect(back.fingerprint, isNotNull);
        expect(
          (await endpoints.transaction.list(as(alice), account.id!)).total,
          20,
        );

        await endpoints.transaction.trash(as(alice), t.id!);
        await endpoints.import.commit(
          as(alice),
          account.id!,
          'again.qif',
          fixture('ce_export.qif'),
        );
        await expectLater(
          endpoints.transaction.restore(as(alice), t.id!),
          throwsA(isA<InvalidInputException>()),
        );
        expect(
          (await endpoints.transaction.list(as(alice), account.id!)).total,
          20,
        );
      },
    );

    group('isolation (decision 0016)', () {
      final denied = throwsA(isA<AccessDeniedException>());

      test(
        'another group cannot list, enter, correct, check or trash',
        () async {
          final t = (await endpoints.transaction.list(
            as(alice),
            account.id!,
          )).items.first;
          final c = await category('food.groceries');
          await expectLater(
            endpoints.transaction.list(as(mallory), account.id!),
            denied,
          );
          await expectLater(
            endpoints.transaction.create(
              as(mallory),
              account.id!,
              DateTime.utc(2026, 10, 1),
              -1,
              'x',
            ),
            denied,
          );
          await expectLater(
            endpoints.transaction.update(as(mallory), t.id!, note: 'x'),
            denied,
          );
          await expectLater(
            endpoints.transaction.setCategory(as(mallory), t.id!, null),
            denied,
          );
          await expectLater(
            endpoints.transaction.setCleared(as(mallory), t.id!, true),
            denied,
          );
          await expectLater(
            endpoints.transaction.trash(as(mallory), t.id!),
            denied,
          );
          await expectLater(
            endpoints.transaction.createRuleFrom(as(mallory), t.id!, c),
            denied,
          );
          final same = await BankTransaction.db.findById(db, t.id!);
          expect(same!.deletedAt, isNull);
          expect(same.cleared, isFalse);
          expect(same.note, t.note);
        },
      );

      test('a category of another group cannot be used', () async {
        final t = (await endpoints.transaction.list(
          as(alice),
          account.id!,
        )).items.first;
        final theirs = (await Category.db.findFirstRow(
          db,
          where: (c) => c.groupId.notEquals(groupA),
        ))!.id!;
        await expectLater(
          endpoints.transaction.setCategory(as(alice), t.id!, theirs),
          denied,
        );
      });

      test('a reader can list but not change', () async {
        final page = await endpoints.transaction.list(as(reader), account.id!);
        expect(page.total, 20);
        await expectLater(
          endpoints.transaction.setCleared(
            as(reader),
            page.items.first.id!,
            true,
          ),
          denied,
        );
      });
    });
  });
}
