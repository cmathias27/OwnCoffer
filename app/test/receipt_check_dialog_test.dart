import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/receipt_check_dialog.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart';

Widget _wrap(Widget child, [Locale locale = const Locale('fr')]) => MaterialApp(
  locale: locale,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('displays proposed values and highlights uncertain fields', (
    tester,
  ) async {
    final reading = ReceiptReading(
      merchant: const ReceiptField(
        'BOULANGERIE DUPONT',
        'BOULANGERIE DUPONT 75001',
        certain: true,
      ),
      date: ReceiptField(
        LocalDate(2026, 11, 2),
        'LE 02/11/2026',
        certain: false,
      ),
      totalCents: const ReceiptField(1480, 'TOTAL : 14,80 €', certain: false),
    );

    ReceiptCheckResult? result;
    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showReceiptCheckDialog(context, reading);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Vérifier le ticket'), findsOneWidget);
    expect(find.text('BOULANGERIE DUPONT'), findsOneWidget);
    expect(find.text('14,80'), findsOneWidget);
    expect(find.text('Lu : TOTAL : 14,80 €'), findsOneWidget);
    expect(find.text('À vérifier'), findsNWidgets(2)); // date and total

    // User confirms
    await tester.tap(find.text('Utiliser ces informations'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.merchant, 'BOULANGERIE DUPONT');
    expect(result!.amountCents, 1480);
    expect(result!.date, DateTime.utc(2026, 11, 2));
  });

  testWidgets('cancel returns null', (tester) async {
    const reading = ReceiptReading(
      totalCents: ReceiptField(500, '5,00', certain: true),
    );

    ReceiptCheckResult? result;
    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showReceiptCheckDialog(context, reading);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(result, isNull);
  });
}
