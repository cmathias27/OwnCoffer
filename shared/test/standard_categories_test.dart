import 'dart:io';

import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  final doc =
      loadYaml(File('../docs/data/standard_categories.yaml').readAsStringSync())
          as YamlMap;

  test('generated catalogue matches docs/data/standard_categories.yaml '
      '(run tool/gen_standard_categories.dart after editing it)', () {
    final expected = <String>[];
    void walk(YamlMap c, String? parent, String type) {
      final t = (c['type'] ?? type) as String;
      final name = c['name'] as YamlMap;
      expected.add(
        '${c['id']}|$parent|$t|${name['fr']}|${name['en']}|${c['deprecated'] == true}',
      );
      for (final child in (c['children'] as YamlList?) ?? const []) {
        walk(child as YamlMap, c['id'] as String, t);
      }
    }

    for (final c in doc['categories'] as YamlList) {
      walk(c as YamlMap, null, c['type'] as String);
    }
    expect([
      for (final c in standardCategories)
        '${c.id}|${c.parent}|${c.kind.name}|${c.fr}|${c.en}|${c.deprecated}',
    ], expected);
    expect(standardCatalogVersion, doc['version']);
  });

  test('17 categories, 73 sub-categories, unique stable ids', () {
    expect(standardCategories.where((c) => c.parent == null), hasLength(17));
    expect(standardCategories.where((c) => c.parent != null), hasLength(73));
    expect(standardCategoriesById, hasLength(90));
    for (final c in standardCategories.where((c) => c.parent != null)) {
      expect(c.id, startsWith('${c.parent}.'));
      expect(standardCategoriesById[c.parent]!.kind, c.kind);
    }
    expect(standardCategoriesById['food.groceries']!.name('fr'), 'Courses');
  });
}
