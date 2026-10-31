import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Categories and rules', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice, reader, mallory;
    late int groupA, groupB;

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );
    Future<UuidValue> admin() async => (await AuthUser.db.insertRow(
      db,
      AuthUser(
        createdAt: DateTime.now(),
        scopeNames: {'owncoffer.serverAdmin'},
        blocked: false,
      ),
    )).id!;

    setUp(() async {
      db = sessionBuilder.build();
      alice = await admin();
      mallory = await admin();
      groupA = (await endpoints.group.create(as(alice), 'A')).group.id!;
      groupB = (await endpoints.group.create(as(mallory), 'B')).group.id!;
      reader = (await AuthUser.db.insertRow(
        db,
        AuthUser(createdAt: DateTime.now(), scopeNames: {}, blocked: false),
      )).id!;
      await GroupMember.db.insertRow(
        db,
        GroupMember(
          groupId: groupA,
          authUserId: reader,
          role: MemberRole.reader,
        ),
      );
    });

    Future<Category> standard(int groupId, String code) async =>
        (await endpoints.category.list(as(alice), groupId)).firstWhere(
          (c) => c.standardCode == code,
        );

    test(
      'a new group gets the 96 standard categories, linked and nested',
      () async {
        final cats = await endpoints.category.list(as(alice), groupA);
        expect(cats, hasLength(96));
        final groceries = cats.firstWhere(
          (c) => c.standardCode == 'food.groceries',
        );
        final food = cats.firstWhere((c) => c.standardCode == 'food');
        expect(groceries.parentId, food.id);
        expect(groceries.name, isNull, reason: 'shown in the user language');
        expect(groceries.kind, CategoryKind.expense);
        expect(
          cats.firstWhere((c) => c.standardCode == 'transfers').kind,
          CategoryKind.transfer,
        );
      },
    );

    test('create, rename, reset name, archive', () async {
      final food = await standard(groupA, 'food');
      final c = await endpoints.category.create(
        as(alice),
        groupA,
        '  Marché  ',
        CategoryKind.expense,
        parentId: food.id,
        standardCode: 'food.groceries',
      );
      expect(c.name, 'Marché');
      final renamed = await endpoints.category.update(
        as(alice),
        c.id!,
        name: 'Primeur',
      );
      expect(renamed.name, 'Primeur');
      final reset = await endpoints.category.update(
        as(alice),
        c.id!,
        resetName: true,
      );
      expect(reset.name, isNull);
      await endpoints.category.archive(as(alice), c.id!);
      expect(
        (await endpoints.category.list(as(alice), groupA)).map((x) => x.id),
        isNot(contains(c.id)),
      );
      await expectLater(
        endpoints.category.create(
          as(alice),
          groupA,
          'x',
          CategoryKind.expense,
          standardCode: 'nope',
        ),
        throwsA(isA<InvalidInputException>()),
      );
    });

    test('rules: pattern normalised, bounds checked', () async {
      final groceries = await standard(groupA, 'food.groceries');
      final r = await endpoints.rule.create(
        as(alice),
        groupA,
        groceries.id!,
        ' Carrefour  Market ',
        RuleMatchType.contains,
        direction: RuleDirection.debit,
      );
      expect(r.pattern, 'CARREFOUR MARKET');
      expect(r.priority, 100);
      await expectLater(
        endpoints.rule.create(
          as(alice),
          groupA,
          groceries.id!,
          ' - ',
          RuleMatchType.contains,
        ),
        throwsA(isA<InvalidInputException>()),
      );
      await expectLater(
        endpoints.rule.update(
          as(alice),
          r.id!,
          minAbsCents: 500,
          maxAbsCents: 100,
        ),
        throwsA(isA<InvalidInputException>()),
      );
      final updated = await endpoints.rule.update(
        as(alice),
        r.id!,
        enabled: false,
      );
      expect(updated.enabled, isFalse);
      await endpoints.rule.delete(as(alice), r.id!);
      expect(await endpoints.rule.list(as(alice), groupA), isEmpty);
    });

    test('rule tester: group rule first, then community rule', () async {
      final groceries = await standard(groupA, 'food.groceries');
      final community = await endpoints.rule.tryLabel(
        as(alice),
        groupA,
        'CB CARREFOUR MARKET FACT 281026',
        -4512,
      );
      expect(community.cleanLabel, 'CARREFOUR MARKET');
      expect(community.operationKind, 'card');
      expect(community.categoryId, groceries.id);
      expect(community.source, CategorySource.communityRule);

      final shopping = await standard(groupA, 'shopping');
      final rule = await endpoints.rule.create(
        as(alice),
        groupA,
        shopping.id!,
        'CARREFOUR',
        RuleMatchType.startsWith,
      );
      final group = await endpoints.rule.tryLabel(
        as(alice),
        groupA,
        'CB CARREFOUR MARKET FACT 281026',
        -4512,
      );
      expect(group.categoryId, shopping.id);
      expect(group.source, CategorySource.groupRule);
      expect(group.ruleRef, '${rule.id}');

      final none = await endpoints.rule.tryLabel(
        as(alice),
        groupA,
        'VIR SEPA RECU EXEMPLE',
        1000,
      );
      expect(none.categoryId, isNull);
      expect(none.source, CategorySource.none);
      await expectLater(
        endpoints.rule.tryLabel(as(alice), groupA, '  ', -1),
        throwsA(isA<InvalidInputException>()),
      );
    });

    group('isolation (decision 0016)', () {
      final denied = throwsA(isA<AccessDeniedException>());

      test('another group cannot use the rule tester', () async {
        await expectLater(
          endpoints.rule.tryLabel(as(mallory), groupA, 'CB EXEMPLE', -100),
          denied,
        );
      });

      test('another group cannot read or change categories', () async {
        final c = await standard(groupA, 'food');
        await expectLater(endpoints.category.list(as(mallory), groupA), denied);
        await expectLater(
          endpoints.category.create(
            as(mallory),
            groupA,
            'x',
            CategoryKind.expense,
          ),
          denied,
        );
        await expectLater(
          endpoints.category.update(as(mallory), c.id!, name: 'pwned'),
          denied,
        );
        await expectLater(
          endpoints.category.archive(as(mallory), c.id!),
          denied,
        );
        final after = await Category.db.findById(db, c.id!);
        expect(after!.name, isNull);
        expect(after.deletedAt, isNull);
      });

      test('another group cannot use, read or change rules', () async {
        final mine = await standard(groupA, 'food');
        final r = await endpoints.rule.create(
          as(alice),
          groupA,
          mine.id!,
          'X',
          RuleMatchType.contains,
        );
        await expectLater(endpoints.rule.list(as(mallory), groupA), denied);
        await expectLater(
          endpoints.rule.update(as(mallory), r.id!, pattern: 'Y'),
          denied,
        );
        await expectLater(endpoints.rule.delete(as(mallory), r.id!), denied);
        // A rule of group B cannot target a category of group A.
        await expectLater(
          endpoints.rule.create(
            as(mallory),
            groupB,
            mine.id!,
            'Z',
            RuleMatchType.contains,
          ),
          denied,
        );
        expect((await Rule.db.findById(db, r.id!))!.pattern, 'X');
      });

      test('readers can read but not change', () async {
        expect(
          await endpoints.category.list(as(reader), groupA),
          hasLength(96),
        );
        final c = await standard(groupA, 'food');
        await expectLater(
          endpoints.category.update(as(reader), c.id!, name: 'x'),
          denied,
        );
        await expectLater(
          endpoints.rule.create(
            as(reader),
            groupA,
            c.id!,
            'X',
            RuleMatchType.contains,
          ),
          denied,
        );
      });
    });
  });
}
