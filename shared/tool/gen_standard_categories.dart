/// Generates lib/src/data/standard_categories.dart from the reference file
/// docs/data/standard_categories.yaml. Run from shared/:
///   dart run tool/gen_standard_categories.dart
library;

import 'dart:io';

import 'package:yaml/yaml.dart';

String generate(String yamlText) {
  final doc = loadYaml(yamlText) as YamlMap;
  final out = StringBuffer()
    ..writeln('// GENERATED from docs/data/standard_categories.yaml by')
    ..writeln('// tool/gen_standard_categories.dart — do not edit by hand.')
    ..writeln()
    ..writeln("import '../categories.dart';")
    ..writeln()
    ..writeln('const int standardCatalogVersion = ${doc['version']};')
    ..writeln()
    ..writeln('const List<StandardCategoryDef> standardCategories = [');
  String q(Object? s) =>
      "'${s.toString().replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";
  void emit(YamlMap c, {String? parent, required String type, String? icon}) {
    final name = c['name'] as YamlMap;
    final thisType = (c['type'] ?? type) as String;
    final thisIcon = (c['icon'] ?? icon) as String?;
    out.writeln(
      '  StandardCategoryDef(${q(c['id'])}, '
      'parent: ${parent == null ? 'null' : q(parent)}, '
      'kind: StandardKind.$thisType, '
      'fr: ${q(name['fr'])}, en: ${q(name['en'])}, '
      'icon: ${thisIcon == null ? 'null' : q(thisIcon)}'
      '${c['deprecated'] == true ? ', deprecated: true' : ''}),',
    );
    for (final child in (c['children'] as YamlList?) ?? const []) {
      emit(
        child as YamlMap,
        parent: c['id'] as String,
        type: thisType,
        icon: thisIcon,
      );
    }
  }

  for (final c in doc['categories'] as YamlList) {
    emit(c as YamlMap, type: c['type'] as String);
  }
  out.writeln('];');
  return out.toString();
}

void main() {
  final yaml = File('../docs/data/standard_categories.yaml').readAsStringSync();
  const path = 'lib/src/data/standard_categories.dart';
  File(path).writeAsStringSync(generate(yaml));
  Process.runSync('dart', ['format', path]);
  stdout.writeln('lib/src/data/standard_categories.dart generated.');
}
