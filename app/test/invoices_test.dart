import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/invoices.dart';
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
  home: Scaffold(body: ListView(children: [child])),
);

InvoiceInfo _info({DateTime? until, bool attached = true}) => InvoiceInfo(
  invoice: Invoice(
    id: 1,
    groupId: 1,
    transactionId: attached ? 7 : null,
    fileName: 'scan.pdf',
    mimeType: 'application/pdf',
    sizeBytes: 2048,
    label: 'Lave-linge',
    warrantyUntil: until,
    createdAt: DateTime.utc(2026, 10, 31),
  ),
  name: attached
      ? '2026-10-31 - DARTY - Lave-linge - 499,00 EUR.pdf'
      : 'Lave-linge.pdf',
  transactionDate: attached ? DateTime.utc(2026, 10, 31) : null,
  transactionLabel: attached ? 'DARTY' : null,
  amountCents: attached ? -49900 : null,
  currency: attached ? 'EUR' : null,
  accountName: attached ? 'Courant' : null,
);

void main() {
  testWidgets('tile: name, operation, running warranty, menu', (tester) async {
    await tester.pumpWidget(
      _app(
        InvoiceTile(
          info: _info(until: DateTime.utc(2099, 1, 1)),
          canWrite: true,
          showOperation: true,
          onChanged: (_) {},
        ),
      ),
    );
    expect(
      find.text('2026-10-31 - DARTY - Lave-linge - 499,00 EUR.pdf'),
      findsOneWidget,
    );
    expect(find.textContaining('Courant'), findsOneWidget);
    expect(find.textContaining('499,00 €'), findsOneWidget);
    expect(find.textContaining('Garantie jusqu'), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    expect(find.text('Description et garantie'), findsOneWidget);
    expect(find.text('Envoyer par courriel'), findsOneWidget);
    expect(find.text('Supprimer'), findsOneWidget);
  });

  testWidgets('tile: reader, ended warranty, no operation', (tester) async {
    await tester.pumpWidget(
      _app(
        InvoiceTile(
          info: _info(until: DateTime.utc(2020, 1, 1), attached: false),
          canWrite: false,
          showOperation: true,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.textContaining('Sans opération'), findsOneWidget);
    expect(find.textContaining('Garantie terminée'), findsOneWidget);
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    expect(find.text('Envoyer par courriel'), findsOneWidget);
    expect(find.text('Supprimer'), findsNothing);
    expect(find.text('Description et garantie'), findsNothing);
  });

  testWidgets('tile: a waiting invoice can be attached', (tester) async {
    await tester.pumpWidget(
      _app(
        InvoiceTile(
          info: _info(attached: false),
          canWrite: true,
          showOperation: true,
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    expect(find.text('Rattacher à une opération'), findsOneWidget);
    expect(find.text('Ce que dit la facture'), findsOneWidget);
  });

  test('warranty ending within a month', () {
    final today = DateTime.utc(2026, 10, 31);
    expect(warrantyEndingSoon(DateTime.utc(2026, 11, 20), today), isTrue);
    expect(warrantyEndingSoon(DateTime.utc(2027, 1, 1), today), isFalse);
  });
}
