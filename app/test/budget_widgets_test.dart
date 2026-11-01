import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/budget_screen.dart';
import 'package:owncoffer_app/widgets/budget_charts.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

Widget _app(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: ThemeData(brightness: brightness),
      locale: const Locale('fr'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

SpendingReport _report({int income = 300000, int expense = 250000}) =>
    SpendingReport(
      period: BudgetPeriod.month,
      start: DateTime.utc(2026, 10, 1),
      last: DateTime.utc(2026, 10, 31),
      incomeCents: income,
      expenseCents: expense,
      savingsCents: 20000,
      netCents: income - expense - 20000,
      unclassifiedCount: 0,
      unclassifiedInCents: 0,
      unclassifiedOutCents: 0,
      categories: const [],
      history: const [],
    );

void main() {
  for (final width in [360.0, 1000.0]) {
    for (final b in Brightness.values) {
      testWidgets('budget cards fit at $width px ($b)', (tester) async {
        tester.view.physicalSize = Size(width, 2000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          _app(
            Column(
              children: [
                BalanceCard(
                  report: _report(),
                  previous: PeriodTotals(
                    start: DateTime.utc(2026, 9, 1),
                    incomeCents: 280000,
                    expenseCents: 260000,
                    savingsCents: 0,
                  ),
                ),
                LeftToLiveCard(
                  report: LeftToLiveReport(
                    today: DateTime.utc(2026, 10, 20),
                    last: DateTime.utc(2026, 10, 31),
                    balanceCents: 120000,
                    plannedDebitsCents: -45000,
                    plannedCreditsCents: 0,
                    leftCents: 75000,
                    daysLeft: 12,
                    perDayCents: 6250,
                    accountIds: const [1],
                  ),
                ),
                RankRow(
                  name: 'Alimentation et maison',
                  flow: CategoryFlow(
                    categoryId: 1,
                    amountCents: 60000,
                    count: 12,
                    previousCents: 50000,
                    averageCents: 45000,
                    history: const [],
                    goalCents: 55000,
                  ),
                  max: 60000,
                  total: 250000,
                  color: Colors.orange,
                  expense: true,
                  expandable: true,
                  onTap: () {},
                  onOperations: () {},
                ),
                SubRows(
                  children: [
                    RankRow(
                      name: 'Courses',
                      flow: CategoryFlow(
                        categoryId: 2,
                        amountCents: 40000,
                        count: 8,
                        previousCents: 0,
                        averageCents: 0,
                        history: const [],
                      ),
                      max: 60000,
                      total: 250000,
                      color: Colors.orange,
                      expense: true,
                      child: true,
                      onTap: () {},
                      onOperations: () {},
                    ),
                  ],
                ),
                const GoalMeter(
                  spentCents: 50000,
                  goalCents: 55000,
                  elapsed: 0.6,
                ),
              ],
            ),
            brightness: b,
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.textContaining('Il vous reste'), findsOneWidget);
        expect(find.text('Reste à vivre'), findsOneWidget);
        expect(find.text('Bientôt atteint', findRichText: true), findsNothing);
        expect(find.textContaining('Bientôt atteint'), findsOneWidget);
        expect(
          find.textContaining('+33 %'),
          findsOneWidget,
          reason: 'vs average',
        );
      });
    }
  }

  testWidgets('overspending is said plainly', (tester) async {
    await tester.pumpWidget(
      _app(BalanceCard(report: _report(expense: 320000), previous: null)),
    );
    expect(find.textContaining('de plus que vos revenus'), findsOneWidget);
    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('goal meter: projection, and the day it should be exceeded', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            const GoalMeter(
              spentCents: 20000,
              goalCents: 50000,
              projectedCents: 40000,
            ),
            GoalMeter(
              spentCents: 30000,
              goalCents: 50000,
              projectedCents: 62000,
              projectedOverDate: DateTime.utc(2026, 10, 26),
            ),
            const GoalMeter(
              spentCents: 60000,
              goalCents: 50000,
              projectedCents: 70000,
            ),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.textContaining('400,00\u00a0€ en fin de mois'), findsOneWidget);
    expect(
      find.textContaining('120,00\u00a0€ de trop, dépassement vers le'),
      findsOneWidget,
    );
    expect(find.textContaining('26'), findsWidgets);
    expect(
      find.textContaining('À ce rythme'),
      findsNWidgets(2),
      reason: 'not once the goal is exceeded',
    );
  });

  for (final width in [360.0, 1000.0]) {
    for (final b in Brightness.values) {
      testWidgets('pie and chart fit at $width px ($b)', (tester) async {
        tester.view.physicalSize = Size(width, 2000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final tapped = <int>[];
        await tester.pumpWidget(
          _app(
            Column(
              children: [
                DonutChart(
                  slices: const [
                    ChartSlice(
                      label: 'Logement',
                      cents: 90000,
                      color: Colors.blue,
                    ),
                    ChartSlice(
                      label: 'Alimentation et maison',
                      cents: 60000,
                      color: Colors.orange,
                    ),
                    ChartSlice(
                      label: 'Autres',
                      cents: 50000,
                      color: Colors.grey,
                    ),
                  ],
                  totalLabel: 'Total',
                  semanticLabel: 'Répartition',
                  money: (c) => '${c ~/ 100} €',
                  percent: (p) => '$p %',
                  onTap: tapped.add,
                ),
                TrendChart(
                  labels: [for (var i = 1; i <= 24; i++) 'M$i'],
                  series: [
                    ChartSeries(
                      label: 'Logement',
                      color: Colors.blue,
                      values: [for (var i = 0; i < 24; i++) 90000 + i * 100],
                    ),
                    ChartSeries(
                      label: 'Loisirs',
                      color: Colors.orange,
                      values: [for (var i = 0; i < 24; i++) i * 1000],
                    ),
                  ],
                  semanticLabel: 'Évolution',
                  money: (c) => '${c ~/ 100} €',
                  axisMoney: (c) => '${c ~/ 100}',
                  onTapSeries: tapped.add,
                ),
              ],
            ),
            brightness: b,
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('45 %'), findsOneWidget, reason: '900 of 2000');
        expect(find.text('2000 €'), findsOneWidget, reason: 'total inside');
        await tester.tap(find.text('Alimentation et maison'));
        await tester.tap(find.text('Loisirs'));
        expect(tapped, [1, 1]);
      });
    }
  }
}
