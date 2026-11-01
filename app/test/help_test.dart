import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/help/help.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';

Widget _app(Widget home, String language) => MaterialApp(
  locale: Locale(language),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  test('every help page exists in French and English, with a title, the '
      'same sections, and balanced bold marks', () {
    for (final t in HelpTopic.values) {
      final docs = {
        for (final lang in ['fr', 'en'])
          lang: () {
            final file = File(t.asset(lang));
            expect(file.existsSync(), isTrue, reason: file.path);
            final text = file.readAsStringSync();
            for (final line in text.split('\n')) {
              expect(
                '**'.allMatches(line).length.isEven,
                isTrue,
                reason: '${file.path}: $line',
              );
            }
            return HelpDoc.parse(text);
          }(),
      };
      for (final d in docs.values) {
        expect(d.title, isNotEmpty, reason: t.name);
        expect(d.blocks, isNotEmpty, reason: t.name);
      }
      int headings(HelpDoc d) =>
          d.blocks.where((b) => b.kind == HelpBlockKind.heading).length;
      expect(
        headings(docs['en']!),
        headings(docs['fr']!),
        reason: '${t.name}: same sections in both languages',
      );
    }
  });

  test('the small Markdown of the help pages', () {
    final d = HelpDoc.parse(
      '# Titre\n\nUn paragraphe\nsur deux lignes.\n\n## Partie\n\n'
      '- un **point**\n1. première étape\n2. seconde\n',
    );
    expect(d.title, 'Titre');
    expect(
      [for (final b in d.blocks) b.kind],
      [
        HelpBlockKind.paragraph,
        HelpBlockKind.heading,
        HelpBlockKind.bullet,
        HelpBlockKind.numbered,
        HelpBlockKind.numbered,
      ],
    );
    expect(d.blocks.first.text, 'Un paragraphe sur deux lignes.');
    expect(d.blocks[4].number, '2');
    final spans = helpSpans('un **point** fort');
    expect([for (final s in spans) s.text], ['un ', 'point', ' fort']);
    expect(spans[1].style?.fontWeight, FontWeight.w600);
  });

  for (final (lang, title, heading, all, first) in [
    ('fr', 'Comptes', 'Créer un compte', "Toute l'aide", 'Premiers pas'),
    ('en', 'Accounts', 'Create an account', 'All the help', 'Getting started'),
  ]) {
    testWidgets('the ? opens the page of its screen, then all the help '
        '($lang)', (tester) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            appBar: AppBar(actions: const [HelpButton(HelpTopic.accounts)]),
          ),
          lang,
        ),
      );
      await tester.tap(find.byIcon(Icons.help_outline));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
      expect(find.text(heading), findsOneWidget);
      final button = find.widgetWithText(OutlinedButton, all);
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      // The index reads every page from the bundle: real input/output.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsWidgets);
      expect(find.text(first), findsOneWidget);
    });
  }
}
