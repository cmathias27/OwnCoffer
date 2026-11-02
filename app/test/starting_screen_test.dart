import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/first_launch_screen.dart';

Widget _app(Widget home) => MaterialApp(
  locale: const Locale('fr'),
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
  testWidgets('standalone start: a failure shows its reason, retry, back', (
    tester,
  ) async {
    var retried = 0;
    var back = 0;
    await tester.pumpWidget(
      _app(
        StartingScreen(
          error: '[start] SQLite cannot open the database: boom',
          onRetry: () async => retried++,
          onBack: () async => back++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('SQLite cannot open'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.text('Réessayer'));
    await tester.tap(find.text('Retour'));
    expect((retried, back), (1, 1));
  });

  testWidgets('standalone start: waiting without error', (tester) async {
    await tester.pumpWidget(_app(const StartingScreen()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Ouverture de vos comptes…'), findsOneWidget);
  });
}
