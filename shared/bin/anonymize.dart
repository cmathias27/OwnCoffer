/// Anonymises real bank exports for tests (see StatementAnonymizer).
///
///   dart run owncoffer_shared:anonymize <input dir> <output dir> [words file]
///
/// The words file lists one word or phrase per line to replace (your name,
/// street, city, employer…), optionally as `WORD=REPLACEMENT`. Only counts
/// are printed: no label, amount or number ever reaches the console.
library;

import 'dart:io';

import 'package:owncoffer_shared/src/tools/anonymizer.dart';

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln('Usage: anonymize <input dir> <output dir> [words file]');
    exit(64);
  }
  final input = Directory(args[0]);
  final output = Directory(args[1])..createSync(recursive: true);
  final replacements = <String, String>{};
  if (args.length > 2) {
    for (final raw in File(args[2]).readAsLinesSync()) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final eq = line.indexOf('=');
      if (eq < 0) {
        replacements[line] = 'XXXX';
      } else {
        replacements[line.substring(0, eq).trim()] = line
            .substring(eq + 1)
            .trim();
      }
    }
  }

  final anonymizer = StatementAnonymizer(replacements: replacements);
  final files =
      input
          .listSync()
          .whereType<File>()
          .where(
            (f) => RegExp(
              r'\.(qif|ofx|csv)$',
              caseSensitive: false,
            ).hasMatch(f.path),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  var n = 0;
  for (final file in files) {
    n++;
    final ext = file.path.split('.').last.toLowerCase();
    try {
      final bytes = anonymizer.anonymize(file.readAsBytesSync());
      File('${output.path}/releve_$n.$ext').writeAsBytesSync(bytes);
      stdout.writeln('File $n ($ext): anonymised.');
    } on Object catch (e) {
      stdout.writeln('File $n ($ext): FAILED (${e.runtimeType}).');
    }
  }
  final report = StringBuffer()
    ..writeln(
      '# Libellés après anonymisation — à relire avant toute utilisation.',
    )
    ..writeln('# Nombre d\'occurrences, puis libellé.');
  final sorted = anonymizer.labels.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  for (final e in sorted) {
    report.writeln('${e.value.toString().padLeft(4)}  ${e.key}');
  }
  File('${output.path}/RAPPORT_A_RELIRE.txt').writeAsStringSync('$report');
  stdout.writeln(
    '${files.length} file(s), ${anonymizer.labels.length} distinct labels. '
    'Review ${output.path}/RAPPORT_A_RELIRE.txt',
  );
}
