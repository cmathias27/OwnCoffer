import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/ai_usage.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

Widget _app(Widget child, {String lang = 'fr'}) => MaterialApp(
  locale: Locale(lang),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: ListView(children: [child])),
);

AiUsageLine _line(
  int month,
  String feature, {
  int requests = 1,
  int input = 0,
  int output = 0,
  int? cost,
  int users = 1,
  String provider = 'Gemini',
}) => AiUsageLine(
  month: month,
  providerId: 1,
  providerName: provider,
  feature: feature,
  requests: requests,
  inputTokens: input,
  outputTokens: output,
  costCents: cost,
  users: users,
);

void main() {
  testWidgets('the user sees each month and function, with the cost when '
      'the prices are known (0048)', (tester) async {
    await tester.pumpWidget(
      _app(
        AiUsageSection(
          load: () async => [
            _line(
              202611,
              'chat',
              requests: 12,
              input: 1200000,
              output: 40000,
              cost: 420,
            ),
            _line(
              202611,
              'invoice',
              requests: 3,
              input: 90000,
              output: 2000,
              cost: 15,
            ),
            _line(202610, 'loan', provider: 'Ollama'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Consommation de l\'IA'), findsOneWidget);
    expect(find.text('novembre 2026'), findsOneWidget);
    expect(find.text('octobre 2026'), findsOneWidget);
    expect(find.text('Discussion · Gemini'), findsOneWidget);
    expect(find.text('Tickets et factures · Gemini'), findsOneWidget);
    expect(find.text('Documents de crédit · Ollama'), findsOneWidget);
    // Month total only when every line has a cost.
    expect(find.text('≈ 4,35\u00a0€'), findsOneWidget);
    expect(find.text('≈ 4,20\u00a0€'), findsOneWidget);
    expect(find.text('prix non saisi'), findsOneWidget);
    expect(
      find.textContaining('jetons non communiqués'),
      findsOneWidget,
    );
    expect(find.textContaining('12 demandes'), findsOneWidget);
    // Never a count of users on the user's own page.
    expect(find.textContaining('utilisateur'), findsNothing);
  });

  testWidgets('the server view says how many users, in English too', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        AiUsageSection(
          server: true,
          load: () async => [
            _line(
              202611,
              'chat',
              requests: 4,
              input: 2000,
              output: 300,
              users: 2,
            ),
          ],
        ),
        lang: 'en',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('AI use on the server'), findsOneWidget);
    expect(find.textContaining('4 requests'), findsOneWidget);
    expect(find.textContaining('2 users'), findsOneWidget);
    expect(find.text('no price set'), findsOneWidget);
  });

  testWidgets('nothing used: said plainly', (tester) async {
    await tester.pumpWidget(_app(AiUsageSection(load: () async => [])));
    await tester.pumpAndSettle();
    expect(
      find.text('Aucune demande à l\'IA sur cette période.'),
      findsOneWidget,
    );
  });
}
