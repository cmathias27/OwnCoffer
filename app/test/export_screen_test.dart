import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/export_screen.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

void main() {
  testWidgets('JSON and CSV exports saved under a dated name', (tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final saved = <(String, String, List<int>)>[];
    final asked = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ExportScreen(
          membership: GroupMembership(
            group: FinanceGroup(
              id: 7,
              name: 'Foyer Dupont',
              createdBy: UuidValue.fromString(
                '00000000-0000-4000-8000-000000000001',
              ),
            ),
            role: MemberRole.reader,
          ),
          now: DateTime(2026, 11, 2),
          json: (g) async {
            asked.add('json $g');
            return '{"format":"owncoffer-export"}';
          },
          csv: (g, language) async {
            asked.add('csv $g $language');
            return '\uFEFFdate;compte\r\n';
          },
          save: (name, mime, bytes) async => saved.add((name, mime, bytes)),
        ),
      ),
    );
    expect(find.textContaining('« Foyer Dupont »'), findsOneWidget);
    await tester.tap(find.text('Télécharger').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Télécharger').last);
    await tester.pumpAndSettle();
    expect(asked, ['json 7', 'csv 7 fr']);
    expect(saved[0].$1, 'owncoffer-foyer-dupont-2026-11-02.json');
    expect(saved[0].$2, 'application/json');
    expect(saved[1].$1, 'owncoffer-foyer-dupont-2026-11-02.csv');
    // UTF-8 with its byte order mark, for spreadsheets.
    expect(saved[1].$3.take(3), [0xEF, 0xBB, 0xBF]);
    expect(utf8.decode(saved[1].$3), contains('date;compte'));
    expect(find.textContaining('Export prêt'), findsOneWidget);
  });
}
