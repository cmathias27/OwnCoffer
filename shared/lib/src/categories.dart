/// Standard categories catalogue (docs/CATEGORIES_STANDARD.md): stable ids
/// shared by every OwnCoffer installation, so community rules work whatever
/// names each group gives to its own categories.
library;

import 'data/standard_categories.dart';

enum StandardKind {
  income,
  expense,

  /// Money put aside: neither income nor expense.
  savings,

  /// Internal movements (between own accounts, cash withdrawals, deferred
  /// card debits): excluded from income and expenses.
  transfer,
}

class StandardCategoryDef {
  /// Stable id: `food` or `food.groceries`. Never renamed nor reused.
  final String id;
  final String? parent;
  final StandardKind kind;
  final String fr;
  final String en;

  /// Material Symbols icon name.
  final String? icon;
  final bool deprecated;

  /// For a deprecated entry: the entry that takes over its categories when
  /// existing groups are updated to a new catalogue version.
  final String? replacedBy;

  /// Catalogue version that added the entry: groups created earlier receive
  /// it when they are updated.
  final int since;

  const StandardCategoryDef(
    this.id, {
    required this.parent,
    required this.kind,
    required this.fr,
    required this.en,
    required this.icon,
    this.deprecated = false,
    this.replacedBy,
    this.since = 1,
  });

  String name(String languageCode) => languageCode == 'fr' ? fr : en;
}

final Map<String, StandardCategoryDef> standardCategoriesById = {
  for (final c in standardCategories) c.id: c,
};
