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

  testWidgets('payment in instalments found: count set with − and +, the '
      'total follows until typed', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final op = BankTransaction(
      id: 8,
      accountId: 3,
      date: DateTime.utc(2026, 9, 12),
      amountCents: -4500,
      rawLabel: 'PRLV ONEY 4X 1/4',
      cleanLabel: 'ONEY 4X 1/4',
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
          initialKind: LoanKind.installments,
          initialCount: 4,
          initialLender: 'ONEY 4X',
        ),
      ),
    );
    await tester.pump();
    Finder field(String label) =>
        find.widgetWithText(TextFormField, label).first;
    String text(String label) =>
        tester.widget<TextFormField>(field(label)).controller!.text;
    expect(find.text('ONEY 4X'), findsOneWidget, reason: 'lender');
    expect(text('Nombre d\'échéances'), '4');
    expect(text('Montant total de l\'achat'), '180,00');

    await tester.tap(find.byTooltip('Une mensualité de plus'));
    await tester.pump();
    expect(text('Nombre d\'échéances'), '5');
    expect(text('Montant total de l\'achat'), '225,00');
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byTooltip('Une mensualité de moins'));
    }
    await tester.pump();
    expect(text('Nombre d\'échéances'), '2', reason: 'never under 2');

    await tester.enterText(field('Montant total de l\'achat'), '95');
    await tester.tap(find.byTooltip('Une mensualité de plus'));
    await tester.pump();
    expect(text('Montant total de l\'achat'), '95', reason: 'typed: kept');
    expect(tester.takeException(), isNull);
  });

  testWidgets('revolving credit: no duration to enter, a limit, the '
      'instalment is required', (tester) async {
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
        home: const LoanFormScreen(
          groupId: 1,
          accounts: [],
          categories: [],
          initialKind: LoanKind.revolving,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Crédit renouvelable'), findsOneWidget);
    expect(find.text('Plafond de la réserve'), findsOneWidget);
    expect(find.text('Montant utilisé (à rembourser)'), findsOneWidget);
    expect(find.text('Durée en mois'), findsNothing);
    final save = find.text('Enregistrer');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pump();
    expect(
      find.text('La mensualité est nécessaire pour un crédit renouvelable.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'duration deduced from debit and capital, breakdown and fill payment',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
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
          home: const LoanFormScreen(
            groupId: 1,
            accounts: [],
            categories: [],
            initialKind: LoanKind.personal,
          ),
        ),
      );
      await tester.pump();

      Finder field(String label) =>
          find.widgetWithText(TextFormField, label).first;
      String text(String label) =>
          tester.widget<TextFormField>(field(label)).controller!.text;

      // Enter capital, rate, insurance, and duration.
      await tester.enterText(field('Capital emprunté'), '15000');
      await tester.enterText(field('Taux nominal'), '4,90');
      await tester.enterText(field('Assurance par mois'), '24');
      await tester.enterText(field('Durée en mois'), '96');
      await tester.pump();

      // "Remplir avec la mensualité calculée" is available when actual payment is empty
      final fillButton = find.text('Remplir avec la mensualité calculée');
      expect(fillButton, findsOneWidget);
      await tester.tap(fillButton);
      await tester.pump();

      // 15 000 € at 4.90 % over 96 months: credit is 189.19 €, insurance 24.00 € -> 213.19 €
      expect(text('Mensualité prélevée (assurance comprise)'), '213,19');

      // Breakdown text is displayed
      expect(find.textContaining('crédit +'), findsOneWidget);
      expect(find.textContaining('assurance ='), findsOneWidget);

      // Clear duration and test deducing duration from the debit
      await tester.enterText(field('Durée en mois'), '');
      await tester.pump();
      expect(text('Durée en mois'), '');

      final deduceMonthsButton = find.text(
        'Calculer la durée à partir de ce prélèvement',
      );
      expect(deduceMonthsButton, findsOneWidget);
      await tester.tap(deduceMonthsButton);
      await tester.pump();

      expect(text('Durée en mois'), '96');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'existing loan with past firstDue displays status today in preview',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final pastDate = DateTime.utc(
        DateTime.now().year - 2,
        DateTime.now().month,
        1,
      );
      final loan = Loan(
        groupId: 1,
        id: 42,
        kind: LoanKind.personal,
        lender: 'Ma Banque',
        label: 'Prêt Conso',
        principalCents: 1500000,
        annualRateMilli: 4900,
        durationMonths: 96,
        firstDueDate: pastDate,
        insuranceMonthlyCents: 2400,
        paymentCents: 18919,
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
            accounts: const [],
            categories: const [],
            loan: loan,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining("Aujourd'hui ("), findsOneWidget);
      expect(
        find.textContaining('intérêts prochaine échéance'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  test('three families: loans, consumer credit, payments in instalments', () {
    expect(
      {for (final k in LoanKind.values) k: loanFamily(k)},
      {
        LoanKind.mortgage: LoanFamily.loans,
        LoanKind.car: LoanFamily.loans,
        LoanKind.consumer: LoanFamily.consumer,
        LoanKind.student: LoanFamily.loans,
        LoanKind.personal: LoanFamily.loans,
        LoanKind.other: LoanFamily.loans,
        LoanKind.installments: LoanFamily.installments,
        LoanKind.revolving: LoanFamily.consumer,
      },
    );
  });

  testWidgets('a pause of the instalments: months, interest paid or nothing '
      'paid, refused out of the limits', (tester) async {
    LoanEvent? got;
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
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => got = await showLoanEventDialog(
              context,
              Loan(
                groupId: 1,
                kind: LoanKind.mortgage,
                lender: 'Banque',
                principalCents: 10000000,
                annualRateMilli: 1000,
                durationMonths: 120,
                firstDueDate: DateTime.utc(2026, 1, 5),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nouveau taux (taux variable)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Report d\'échéances (pause)').last);
    await tester.pumpAndSettle();
    final months = find.widgetWithText(TextField, 'Nombre de mois de pause');
    await tester.enterText(months, '121');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(find.text('Indiquez une pause de 1 à 120 mois.'), findsOneWidget);
    await tester.enterText(months, '3');
    await tester.tap(find.text('Rien payé'));
    await tester.pumpAndSettle();
    expect(find.textContaining('les intérêts s\'ajoutent'), findsOneWidget);
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(got?.pauseMonths, 3);
    expect(got?.pauseCapitalized, isTrue);
    expect(tester.takeException(), isNull);
  });
}
