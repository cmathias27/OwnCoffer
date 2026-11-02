import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/assistant/chat_markdown.dart';

const _reply = '''
### Diagnostic

Votre **solde prévu** reste positif.

- Réduire les *abonnements* : `Streaming`
- Garder une marge
  - sous-point

1. Premier pas
2. Second pas
''';

List<SelectableText> _blocks(WidgetTester tester) =>
    tester.widgetList<SelectableText>(find.byType(SelectableText)).toList();

void main() {
  testWidgets('Markdown marks are rendered, not shown', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ChatMarkdown(_reply))),
      ),
    );
    final texts = [for (final b in _blocks(tester)) b.textSpan!.toPlainText()];
    expect(texts, contains('Diagnostic'));
    expect(texts, contains('Votre solde prévu reste positif.'));
    expect(texts, contains('Réduire les abonnements : Streaming'));
    expect(texts, contains('sous-point'));
    expect(texts, contains('Premier pas'));
    for (final t in texts) {
      expect(t, isNot(contains('**')));
      expect(t, isNot(contains('###')));
      expect(t, isNot(contains('`')));
    }
    // Bullets and numbers are drawn beside the text.
    expect(find.text('•'), findsNWidgets(2));
    expect(find.text('◦'), findsOneWidget);
    expect(find.text('1.'), findsOneWidget);
    expect(find.text('2.'), findsOneWidget);
  });

  testWidgets('the key figures are bold', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ChatMarkdown('Il reste **1 250,00 €** ce mois.')),
      ),
    );
    final span = _blocks(tester).single.textSpan!;
    final bold = <String>[];
    span.visitChildren((s) {
      if (s is TextSpan && s.style?.fontWeight == FontWeight.w700) {
        bold.add(s.text!);
      }
      return true;
    });
    expect(bold, ['1 250,00 €']);
  });

  testWidgets('a long reply fits a narrow window at 200 % text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: const Scaffold(
          body: SingleChildScrollView(child: ChatMarkdown(_reply)),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
