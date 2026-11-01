import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/compare_screen.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

void main() {
  setUpAll(() => client = Client('http://localhost:9/'));

  for (final width in [360.0, 1000.0]) {
    testWidgets('compare: choices fit at $width px, a failed load is said', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1600);
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
          home: CompareScreen(
            membership: GroupMembership(
              group: FinanceGroup(
                id: 1,
                name: 'Foyer',
                createdBy: UuidValue.fromString(
                  '00000000-0000-4000-8000-000000000000',
                ),
              ),
              role: MemberRole.user,
            ),
            accounts: [
              for (final (id, name) in [(1, 'Courant'), (2, 'Commun')])
                Account(
                  id: id,
                  groupId: 1,
                  name: name,
                  kind: AccountKind.checking,
                ),
            ],
            categories: const {},
            period: BudgetPeriod.month,
            date: DateTime.utc(2026, 10, 15),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Catégories'), findsOneWidget);
      expect(find.text('Comptes'), findsOneWidget, reason: 'two accounts');
      await tester.tap(find.text('Périodes'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(InputChip), findsNWidgets(3), reason: 'now, -1, -12');
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  }

  testWidgets('simulation: a cheaper contract, saving and pay-back on a '
      'phone', (tester) async {
    tester.view.physicalSize = const Size(360, 2400);
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
        home: CompareScreen(
          membership: GroupMembership(
            group: FinanceGroup(
              id: 1,
              name: 'Foyer',
              createdBy: UuidValue.fromString(
                '00000000-0000-4000-8000-000000000000',
              ),
            ),
            role: MemberRole.user,
          ),
          accounts: [
            Account(
              id: 1,
              groupId: 1,
              name: 'Courant',
              kind: AccountKind.checking,
            ),
          ],
          categories: const {},
          period: BudgetPeriod.month,
          date: DateTime.utc(2026, 10, 15),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulation'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Indiquez le prix actuel'), findsOneWidget);
    Finder field(String label) => find.widgetWithText(TextField, label).first;
    await tester.enterText(field('Prix actuel par mois'), '45');
    await tester.enterText(field('Nouveau prix par mois'), '30');
    await tester.enterText(field('Coût du changement'), '50');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Vous économiseriez'), findsOneWidget);
    expect(find.text('Rentabilisé au bout de 4 mois.'), findsOneWidget);
  });
}
