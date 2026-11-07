import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Pepite shop catalog', () {
    test(
      'every item has a unique code, positive price, and valid category',
      () {
        final codes = <String>{};
        for (final item in pepiteShopCatalog) {
          expect(
            codes.add(item.code),
            isTrue,
            reason: 'duplicate: ${item.code}',
          );
          expect(item.price, greaterThan(0));
          expect(item.code, matches(r'^[a-z_]+$'));
        }
      },
    );

    test('accessory and burrow items are both present', () {
      final accessories = pepiteItemsByCategory(PepiteItemCategory.accessory);
      final burrows = pepiteItemsByCategory(PepiteItemCategory.burrow);
      expect(accessories, isNotEmpty);
      expect(burrows, isNotEmpty);
      expect(
        accessories.length + burrows.length,
        equals(pepiteShopCatalog.length),
      );
    });

    test(
      'at least one item requires the native app (decision 0028 point 5)',
      () {
        final appItems = pepiteShopCatalog.where((i) => i.requiresApp);
        expect(appItems, isNotEmpty);
        expect(appItems.any((i) => i.code == 'backpack'), isTrue);
      },
    );

    test('pepiteItemByCode returns the exact item or null', () {
      expect(
        pepiteItemByCode('scarf')?.category,
        equals(PepiteItemCategory.accessory),
      );
      expect(
        pepiteItemByCode('wheel')?.category,
        equals(PepiteItemCategory.burrow),
      );
      expect(pepiteItemByCode('unknown_item'), isNull);
    });
  });
}
