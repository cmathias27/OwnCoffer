import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/admin_updates.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

UpdateOverview _overview({String latest = 'v0.4.0', bool auto = true}) =>
    UpdateOverview(
      available: true,
      runningVersion: '0.3.9',
      current: 'v0.3.9',
      latest: latest,
      checkedAt: DateTime.utc(2026, 11, 1, 10),
      auto: auto,
      failedVersion: 'v0.3.8',
      requestPending: false,
      history: [
        UpdateHistoryEntry(
          at: DateTime.utc(2026, 10, 31, 19, 35),
          fromVersion: 'v0.3.8',
          toVersion: 'v0.3.9',
          result: 'installed',
        ),
        UpdateHistoryEntry(
          at: DateTime.utc(2026, 10, 31, 18),
          fromVersion: 'v0.3.7',
          toVersion: 'v0.3.8',
          result: 'rollback',
          message: 'did not answer',
        ),
      ],
      releases: [
        ReleaseNotes(
          version: '0.4.0',
          date: '1 novembre 2026',
          body:
              '### Factures\n\n- **Joindre** une facture.\n  - depuis la photo',
        ),
        ReleaseNotes(
          version: '0.3.9',
          date: '31 octobre 2026',
          body: '- Invitations.',
        ),
      ],
    );

void main() {
  testWidgets('updates: available, notes to come, install after confirm', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(380, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    String? installed;
    bool? auto;
    await tester.pumpWidget(
      _app(
        AdminUpdatesView(
          overview: _overview(),
          onAuto: (v) => auto = v,
          onCheck: () {},
          onInstall: (v) => installed = v,
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      find.textContaining('Nouvelle version disponible : v0.4.0'),
      findsOneWidget,
    );
    expect(find.text('À venir'), findsOneWidget);
    expect(find.text('Factures'), findsOneWidget);
    expect(find.textContaining('Joindre', findRichText: true), findsOneWidget);
    expect(find.textContaining("n'a pas démarré"), findsOneWidget);
    expect(
      find.textContaining('retour à la version précédente'),
      findsOneWidget,
    );

    await tester.tap(find.text('Installer v0.4.0'));
    await tester.pumpAndSettle();
    expect(find.text('Installer v0.4.0 maintenant ?'), findsOneWidget);
    await tester.tap(find.text('Installer'));
    await tester.pumpAndSettle();
    expect(installed, 'v0.4.0');

    await tester.tap(find.byType(Switch));
    expect(auto, isFalse);
  });

  testWidgets('updates: up to date, no install button', (tester) async {
    await tester.pumpWidget(
      _app(
        AdminUpdatesView(
          overview: _overview(latest: 'v0.3.9', auto: false),
          onAuto: (_) {},
          onCheck: () {},
          onInstall: (_) {},
        ),
      ),
    );
    expect(find.text('OwnCoffer est à jour.'), findsOneWidget);
    expect(find.textContaining('Installer v'), findsNothing);
    expect(find.textContaining('Désactivées'), findsOneWidget);
  });
}
