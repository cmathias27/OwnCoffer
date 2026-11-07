/// Pépite's seed shop catalog (decision 0028, points 4-5).
///
/// Seeds can be spent on accessories for Pépite and decorations for its
/// burrow. Prices are fixed and in seeds; seeds have no monetary value.
library;

/// Category of an item in Pépite's shop.
enum PepiteItemCategory {
  /// Worn by Pépite (scarf, glasses, hat, etc.).
  accessory,

  /// Placed in Pépite's burrow (wheel, sunflower, hut, etc.).
  burrow,
}

/// A fixed item in the shop catalog.
class PepiteShopItem {
  /// Unique identifier (e.g. 'scarf', 'wheel').
  final String code;

  final PepiteItemCategory category;

  /// Price in seeds.
  final int price;

  /// Whether this item can only be purchased in the native Android or
  /// Windows application (decision 0028, point 5). Once acquired, it is
  /// visible everywhere.
  final bool requiresApp;

  const PepiteShopItem({
    required this.code,
    required this.category,
    required this.price,
    this.requiresApp = false,
  });
}

/// The catalog of items in Pépite's shop.
const pepiteShopCatalog = [
  // --- Accessoires ---
  PepiteShopItem(
    code: 'scarf',
    category: PepiteItemCategory.accessory,
    price: 15,
  ),
  PepiteShopItem(
    code: 'glasses',
    category: PepiteItemCategory.accessory,
    price: 20,
  ),
  PepiteShopItem(
    code: 'beanie',
    category: PepiteItemCategory.accessory,
    price: 25,
  ),
  PepiteShopItem(
    code: 'cap',
    category: PepiteItemCategory.accessory,
    price: 20,
  ),
  PepiteShopItem(
    code: 'bowtie',
    category: PepiteItemCategory.accessory,
    price: 15,
  ),
  PepiteShopItem(
    code: 'flower',
    category: PepiteItemCategory.accessory,
    price: 10,
  ),
  PepiteShopItem(
    code: 'backpack',
    category: PepiteItemCategory.accessory,
    price: 20,
    requiresApp: true,
  ),

  // --- Décor du terrier ---
  PepiteShopItem(
    code: 'cushion',
    category: PepiteItemCategory.burrow,
    price: 15,
  ),
  PepiteShopItem(
    code: 'sunflower',
    category: PepiteItemCategory.burrow,
    price: 20,
  ),
  PepiteShopItem(
    code: 'wheel',
    category: PepiteItemCategory.burrow,
    price: 30,
  ),
  PepiteShopItem(
    code: 'hut',
    category: PepiteItemCategory.burrow,
    price: 35,
  ),
  PepiteShopItem(
    code: 'lantern',
    category: PepiteItemCategory.burrow,
    price: 25,
  ),
  PepiteShopItem(
    code: 'mat',
    category: PepiteItemCategory.burrow,
    price: 10,
  ),
];

/// Finds an item by its code, or null if unknown.
PepiteShopItem? pepiteItemByCode(String code) {
  for (final item in pepiteShopCatalog) {
    if (item.code == code) return item;
  }
  return null;
}

/// Returns all items of a given category.
List<PepiteShopItem> pepiteItemsByCategory(PepiteItemCategory category) =>
    pepiteShopCatalog.where((item) => item.category == category).toList();
