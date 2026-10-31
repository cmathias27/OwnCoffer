import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/loans_screen.dart';
import 'package:owncoffer_app/widgets/budget_charts.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

void main() {
  test('rates are read in thousandths of a percent, without double', () {
    expect(parseRateMilli('3,45'), 3450);
    expect(parseRateMilli('3.125'), 3125);
    expect(parseRateMilli(' 0 '), 0);
    expect(parseRateMilli('12 %'), 12000);
    expect(parseRateMilli('1,2345'), isNull);
    expect(parseRateMilli('-1'), isNull);
    expect(parseRateMilli('abc'), isNull);
  });

  testWidgets('income / expense chart: legend, tooltip on tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            child: IncomeExpenseChart(
              points: [
                for (var i = 0; i < 6; i++)
                  IncomeExpensePoint(
                    label: 'M$i',
                    tooltipTitle: 'Mois $i',
                    incomeCents: 200000 + i * 1000,
                    expenseCents: 150000 + i * 5000,
                  ),
              ],
              incomeLabel: 'Revenus',
              expenseLabel: 'Dépenses',
              netLabel: 'Reste',
              semanticLabel: 'chart',
              money: (c) => '${c ~/ 100} €',
              axisMoney: (c) => '${c ~/ 100}',
            ),
          ),
        ),
      ),
    );
    expect(find.text('Revenus'), findsOneWidget);
    expect(find.text('Dépenses'), findsOneWidget);
    expect(find.text('Mois 5'), findsNothing);
    // Last slot: right edge of the plot.
    final box = tester.getRect(find.byType(CustomPaint).last);
    await tester.tapAt(Offset(box.right - 10, box.center.dy));
    await tester.pump();
    expect(find.text('Mois 5'), findsOneWidget);
    expect(find.text('2050 €'), findsOneWidget);
    expect(find.text('1750 €'), findsOneWidget);
    expect(find.text('300 €'), findsOneWidget, reason: 'net');
    expect(tester.takeException(), isNull);
  });

  testWidgets('declared from a debit: prefilled, capital deduced from the '
      'debit, gap warned', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final op = BankTransaction(
      id: 7,
      accountId: 3,
      date: DateTime.utc(2026, 9, 5),
      amountCents: -(115479 + 2000),
      rawLabel: 'PRLV PRET HABITAT',
      cleanLabel: 'PRET HABITAT',
      operationKind: 'directDebit',
    );
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
        home: LoanFormScreen(
          groupId: 1,
          accounts: [
            Account(
              id: 3,
              groupId: 1,
              name: 'Courant',
              kind: AccountKind.checking,
            ),
          ],
          fromOperation: op,
          categories: const [],
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Déclarer le crédit'), findsOneWidget);
    expect(find.text('PRET HABITAT'), findsOneWidget, reason: 'lender');
    expect(find.text('Courant'), findsOneWidget, reason: 'account');

    Finder field(String label) =>
        find.widgetWithText(TextFormField, label).first;
    await tester.enterText(field('Taux nominal'), '3,45');
    await tester.enterText(field('Durée en mois'), '240');
    await tester.enterText(field('Assurance par mois'), '20');
    await tester.tap(
      find.text('Calculer le capital à partir de ce prélèvement'),
    );
    await tester.pump();
    final principal = tester
        .widget<TextFormField>(field('Capital emprunté'))
        .controller!
        .text;
    expect(principal, startsWith('20000'), reason: '≈ 200 000 €');
    expect(find.textContaining('s\'écarte de plus de 5 %'), findsNothing);

    await tester.enterText(field('Capital emprunté'), '100000');
    await tester.pump();
    expect(find.textContaining('s\'écarte de plus de 5 %'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
