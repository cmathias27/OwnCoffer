import 'package:owncoffer_server/src/endpoints/category_endpoint.dart';
import 'package:owncoffer_server/src/generated/protocol.dart';
import 'package:owncoffer_server/src/security/scopes.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Standard catalogue update', (sessionBuilder, endpoints) {
    late Session db;
    late UuidValue alice;
    late int groupId;

    TestSessionBuilder as(UuidValue u) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        u.toString(),
        {accessScope},
      ),
    );

    Future<List<Category>> all() => Category.db.find(
      db,
      where: (c) => c.groupId.equals(groupId),
      orderBy: (c) => c.id,
    );

    /// Turns a fresh group into one created with catalogue v1: no Pets
    /// branch, the old `family.pets` sub-category, renamed by the user.
    Future<Category> makeV1Group() async {
      final cats = await all();
      final pets = [
        for (final c in cats)
          if (c.standardCode == 'pets' ||
              (c.standardCode?.startsWith('pets.') ?? false))
            c,
      ];
      await Category.db.delete(db, pets);
      final family = cats.firstWhere((c) => c.standardCode == 'family');
      final old = await Category.db.insertRow(
        db,
        Category(
          groupId: groupId,
          parentId: family.id,
          name: 'Le chien',
          kind: CategoryKind.expense,
          standardCode: 'family.pets',
        ),
      );
      final group = (await FinanceGroup.db.findById(db, groupId))!;
      await FinanceGroup.db.updateRow(
        db,
        group.copyWith(standardCatalogVersion: 1),
      );
      return old;
    }

    setUp(() async {
      db = sessionBuilder.build();
      alice = (await AuthUser.db.insertRow(
        db,
        AuthUser(
          createdAt: DateTime.now(),
          scopeNames: {'owncoffer.serverAdmin'},
          blocked: false,
        ),
      )).id!;
      groupId = (await endpoints.group.create(as(alice), 'A')).group.id!;
    });

    test('a new group is created at the current catalogue version', () async {
      final g = (await FinanceGroup.db.findById(db, groupId))!;
      expect(g.standardCatalogVersion, core.standardCatalogVersion);
      final before = await all();
      await updateAllStandardCategories(db);
      expect(await all(), hasLength(before.length));
    });

    test('an older group gets the Pets branch; the old category is moved and '
        'relinked, keeping its id, name and operations', () async {
      final old = await makeV1Group();
      final account = await endpoints.account.create(
        as(alice),
        groupId,
        'Courant',
        AccountKind.checking,
      );
      final op = await endpoints.transaction.create(
        as(alice),
        account.id!,
        DateTime.utc(2026, 10, 2),
        -4500,
        'CROQUETTES',
        categoryId: old.id,
      );

      await updateAllStandardCategories(db);

      final cats = await all();
      final byCode = {for (final c in cats) c.standardCode: c};
      final pets = byCode['pets']!;
      expect(pets.parentId, isNull);
      for (final code in [
        'pets.food',
        'pets.vet',
        'pets.insurance',
        'pets.care',
        'pets.supplies',
        'pets.other',
      ]) {
        expect(
          cats.where((c) => c.standardCode == code),
          hasLength(1),
          reason: code,
        );
        expect(byCode[code]!.parentId, pets.id, reason: code);
      }
      final moved = byCode['pets.other']!;
      expect(moved.id, old.id);
      expect(moved.name, 'Le chien');
      expect(byCode.containsKey('family.pets'), isFalse);
      expect(
        (await BankTransaction.db.findById(db, op.id!))!.categoryId,
        old.id,
      );
      expect(
        (await FinanceGroup.db.findById(db, groupId))!.standardCatalogVersion,
        core.standardCatalogVersion,
      );

      // Once per version: a second run changes nothing.
      await updateAllStandardCategories(db);
      expect(await all(), hasLength(cats.length));
    });

    test('an archived old category is not revived; the branch is created '
        'fresh', () async {
      final old = await makeV1Group();
      await endpoints.category.archive(as(alice), old.id!);
      await updateAllStandardCategories(db);
      final cats = await all();
      final other = cats.firstWhere((c) => c.standardCode == 'pets.other');
      expect(other.id, isNot(old.id));
      expect(
        (await Category.db.findById(db, old.id!))!.standardCode,
        'family.pets',
      );
    });
  });
}
