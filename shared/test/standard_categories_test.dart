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
        '${c['id']}|$parent|$t|${name['fr']}|${name['en']}|${c['deprecated'] == true}'
        '|${c['replaced_by']}|${c['since'] ?? 1}',
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
        '${c.id}|${c.parent}|${c.kind.name}|${c.fr}|${c.en}|${c.deprecated}'
            '|${c.replacedBy}|${c.since}',
    ], expected);
    expect(standardCatalogVersion, doc['version']);
  });

  test('18 categories, 79 sub-categories, unique stable ids', () {
    expect(standardCategories.where((c) => c.parent == null), hasLength(18));
    expect(standardCategories.where((c) => c.parent != null), hasLength(79));
    expect(standardCategoriesById, hasLength(97));
    expect(standardCategories.where((c) => !c.deprecated), hasLength(96));
    for (final c in standardCategories.where((c) => c.parent != null)) {
      expect(c.id, startsWith('${c.parent}.'));
      expect(standardCategoriesById[c.parent]!.kind, c.kind);
    }
    expect(standardCategoriesById['food.groceries']!.name('fr'), 'Courses');
  });

  test('a deprecated entry is replaced by a live entry of the same kind', () {
    for (final c in standardCategories.where((c) => c.replacedBy != null)) {
      expect(c.deprecated, isTrue, reason: c.id);
      final next = standardCategoriesById[c.replacedBy]!;
      expect(next.deprecated, isFalse, reason: c.id);
      expect(next.kind, c.kind, reason: c.id);
    }
    expect(standardCategoriesById['family.pets']!.replacedBy, 'pets.other');
  });

  test('entries are added by a catalogue version that exists', () {
    for (final c in standardCategories) {
      expect(c.since, inInclusiveRange(1, standardCatalogVersion));
      final parent = standardCategoriesById[c.parent];
      if (parent != null) expect(c.since, greaterThanOrEqualTo(parent.since));
    }
    expect(standardCategoriesById['pets.vet']!.since, 2);
  });
}
