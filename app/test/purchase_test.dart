import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/purchase_screen.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

PurchaseScenarioInfo _s(
  PurchaseOption o,
  int balance, {
  DateTime? overdraft,
  int? goalOver,
  List<int> payments = const [],
}) => PurchaseScenarioInfo(
  option: o,
  payments: [
    for (final (i, p) in payments.indexed)
      PurchasePaymentInfo(date: DateTime.utc(2026, 11 + i, 15), amountCents: p),
  ],
  balanceOnTargetCents: balance,
  lowestDate: DateTime.utc(2026, 11, 15),
  lowestBalanceCents: balance - 10000,
  firstBelowThresholdDate: overdraft,
  thisMonthCents: 0,
  goalOverCents: goalOver,
);

void main() {
  testWidgets('scenarios side by side, warnings, save on choices only', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var saved = 0;
    final sim = PurchaseSimulation(
      accountId: 1,
      amountCents: 60000,
      date: DateTime.utc(2026, 11, 15),
      target: DateTime.utc(2026, 12, 25),
      until: DateTime.utc(2027, 2, 15),
      alertThresholdCents: 0,
      variableIncluded: true,
      scenarios: [
        _s(PurchaseOption.none, 240000),
        _s(
          PurchaseOption.cash,
          -5000,
          overdraft: DateTime.utc(2026, 11, 15),
          goalOver: 4000,
          payments: [60000],
        ),
        _s(
          PurchaseOption.threeTimes,
          200000,
          payments: [20000, 20000, 20000],
        ),
      ],
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
        home: Scaffold(
          body: SingleChildScrollView(
            child: Wrap(
              children: [
                for (final s in sim.scenarios)
                  PurchaseScenarioCard(
                    scenario: s,
                    simulation: sim,
                    currency: 'EUR',
                    onSave: s.option == PurchaseOption.none
                        ? null
                        : () => saved++,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text("Sans l'achat"), findsOneWidget);
    expect(find.text('Comptant'), findsOneWidget);
    expect(find.text('En 3 fois'), findsOneWidget);
    expect(find.textContaining('Découvert prévu'), findsOneWidget);
    expect(find.textContaining('Objectif du mois dépassé'), findsOneWidget);
    expect(find.text('Choisir et enregistrer'), findsNWidgets(2));
    await tester.tap(find.text('Choisir et enregistrer').last);
    expect(saved, 1);
  });
}
