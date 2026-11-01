import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/assistant/chat_bubble.dart';
import 'package:owncoffer_app/assistant/chat_controller.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

final _membership = GroupMembership(
  group: FinanceGroup(
    id: 1,
    name: 'Foyer',
    createdBy: UuidValue.fromString('00000000-0000-4000-8000-000000000000'),
  ),
  role: MemberRole.user,
);

AiStatus _status({required bool enabled}) => AiStatus(
  providers: [
    AiProvider(
      id: 1,
      name: 'Gemini',
      kind: 'openai',
      baseUrl: 'https://generativelanguage.googleapis.com/v1beta/openai/',
      models: 'gemini-3.8-flash',
      toolCalling: true,
      vision: true,
      monthlyCap: 0,
      enabled: true,
    ),
  ],
  providerId: 1,
  model: 'gemini-3.8-flash',
  enabled: enabled,
  usedThisMonth: 0,
  canConfigure: false,
);

void main() {
  final navigator = GlobalKey<NavigatorState>();
  Widget app() => MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    navigatorKey: navigator,
    builder: (context, child) => ChatLayer(navigator: navigator, child: child!),
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: Text('Autre page')),
              ),
            ),
            child: const Text('Aller'),
          ),
        ),
      ),
    ),
  );

  testWidgets('no bubble while the assistant is off', (tester) async {
    chat.debugSet(_membership, _status(enabled: false));
    await tester.pumpWidget(app());
    expect(find.byTooltip("Discuter avec l'assistant"), findsNothing);
  });

  for (final width in [360.0, 1200.0]) {
    testWidgets('the bubble opens the conversation, which stays open on '
        'another page, then closes back into the bubble ($width px)', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      chat.debugSet(_membership, _status(enabled: true));
      await tester.pumpWidget(app());
      await tester.tap(find.byTooltip("Discuter avec l'assistant"));
      await tester.pumpAndSettle();
      expect(find.text('Gemini · gemini-3.8-flash'), findsOneWidget);
      expect(find.text('Classer les opérations à classer'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Bonjour');
      expect(find.text('Bonjour'), findsOneWidget);

      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('Autre page')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Gemini · gemini-3.8-flash'), findsOneWidget);
      expect(find.text('Bonjour'), findsOneWidget, reason: 'still typed');

      await tester.tap(find.byTooltip('Réduire'));
      await tester.pumpAndSettle();
      expect(find.text('Gemini · gemini-3.8-flash'), findsNothing);
      expect(find.byTooltip("Discuter avec l'assistant"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
