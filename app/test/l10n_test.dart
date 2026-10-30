import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/l10n/error_messages.dart';

Map<String, dynamic> arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> codesIn(String dir, RegExp pattern) => {
  for (final f in Directory(dir).listSync(recursive: true).whereType<File>())
    if (f.path.endsWith('.dart') && !f.path.contains('/generated/'))
      for (final m in pattern.allMatches(f.readAsStringSync())) m[1]!,
};

void main() {
  final locales = [
    for (final l in AppLocalizations.supportedLocales)
      lookupAppLocalizations(l),
  ];

  test('French and English have exactly the same texts', () {
    Set<String> keys(Map<String, dynamic> m) =>
        m.keys.where((k) => !k.startsWith('@')).toSet();
    expect(keys(arb('en')), keys(arb('fr')));
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      {'fr', 'en'},
    );
  });

  test('every server error code has a translation', () {
    final codes = codesIn(
      '../server/lib',
      RegExp(
        r"(?:AccessDeniedException|InvalidInputException)\(\s*code: '([a-z_]+)'",
      ),
    );
    expect(codes, isNotEmpty);
    for (final l in locales) {
      for (final code in codes) {
        expect(serverErrorText(l, code), isNot(l.error_generic), reason: code);
      }
    }
  });

  test('every import issue and file format code has a translation', () {
    final issues = codesIn(
      '../shared/lib',
      RegExp(r"ImportIssue\(\s*IssueSeverity\.\w+,\s*'([a-z_]+)'"),
    );
    final formats = codesIn(
      '../shared/lib',
      RegExp(r"StatementFormatException\('([a-z_]+)'\)"),
    );
    expect(issues, isNotEmpty);
    expect(formats, isNotEmpty);
    for (final l in locales) {
      for (final code in formats) {
        expect(
          serverErrorText(l, 'import_$code'),
          importFormatText(l, code),
          reason: 'server sends import_$code',
        );
      }
      for (final code in issues) {
        expect(importIssueText(l, code, 3), contains('3'), reason: code);
      }
      for (final code in formats) {
        expect(importFormatText(l, code), isNot(l.error_generic), reason: code);
      }
    }
  });

  test('unknown codes fall back to the generic text', () {
    final fr = lookupAppLocalizations(const Locale('fr'));
    expect(serverErrorText(fr, 'nope'), fr.error_generic);
  });
}
