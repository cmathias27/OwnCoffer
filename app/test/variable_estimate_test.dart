import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/util/format.dart';
import 'package:owncoffer_app/widgets/variable_estimate.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

Widget _app(VariableEstimateInfo e) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Builder(
      builder: (context) => SingleChildScrollView(
        child: VariableEstimateCard(
          estimate: e,
          categories: {
            1: Category(
              id: 1,
              groupId: 1,
              name: 'Courses',
              kind: CategoryKind.expense,
            ),
          },
          money: (c) => context.money(c),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('variable spending: total, then the calculation on demand', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        VariableEstimateInfo(
          monthlyCents: 33500,
          spentThisMonthCents: 10000,
          leftThisMonthCents: 23500,
          horizonCents: 30000,
          months: [
            DateTime.utc(2026, 7, 1),
            DateTime.utc(2026, 8, 1),
            DateTime.utc(2026, 9, 1),
          ],
          categories: [
            VariableCategoryInfo(
              categoryId: 1,
              monthsCents: [30000, 32000, 90000],
              monthlyCents: 32000,
            ),
            VariableCategoryInfo(
              categoryId: null,
              monthsCents: [1500, 0, 2000],
              monthlyCents: 1500,
            ),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      find.textContaining('Dont 300,00 € de dépenses variables'),
      findsOneWidget,
    );
    expect(find.textContaining('Courses'), findsNothing);
    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('Courses', findRichText: true), findsOneWidget);
    expect(find.textContaining('900,00', findRichText: true), findsOneWidget);
    expect(find.textContaining('juil.'), findsOneWidget);
    expect(find.textContaining('235,00 € encore attendus'), findsOneWidget);
  });

  testWidgets('variable spending: not enough history is said', (tester) async {
    await tester.pumpWidget(
      _app(
        VariableEstimateInfo(
          monthlyCents: 0,
          spentThisMonthCents: 0,
          leftThisMonthCents: 0,
          horizonCents: 0,
          months: const [],
          categories: const [],
        ),
      ),
    );
    expect(
      find.textContaining("pas encore assez d'historique"),
      findsOneWidget,
    );
  });
}
