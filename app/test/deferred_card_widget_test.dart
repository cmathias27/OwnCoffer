import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/account_filter_chip.dart';
import 'package:owncoffer_app/screens/accounts_screen.dart';

void main() {
  final accounts = [
    Account(
      id: 1,
      groupId: 1,
      name: 'Compte Courant',
      kind: AccountKind.checking,
      bank: "Caisse d'Épargne",
    ),
    Account(
      id: 2,
      groupId: 1,
      name: 'Carte Débit Différé',
      kind: AccountKind.deferredCard,
      statementCutoffDay: 28,
      statementDebitDay: 4,
      linkedAccountId: 1,
    ),
    Account(
      id: 3,
      groupId: 1,
      name: 'Livret A',
      kind: AccountKind.savings,
    ),
  ];

  Widget wrap(Widget child) => MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );

  group('AccountFilterChip', () {
    testWidgets('shows "Tous les comptes" when selection is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AccountFilterChip(
            accounts: accounts,
            selectedIds: const {},
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tous les comptes'), findsOneWidget);
    });

    testWidgets('shows account name when single account is selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AccountFilterChip(
            accounts: accounts,
            selectedIds: const {2},
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Carte Débit Différé'), findsOneWidget);
    });

    testWidgets('shows multiple count when 2 accounts are selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AccountFilterChip(
            accounts: accounts,
            selectedIds: const {1, 2},
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('2 comptes sélectionnés'), findsOneWidget);
    });

    testWidgets('opens dialog and updates selection', (tester) async {
      Set<int>? updated;
      await tester.pumpWidget(
        wrap(
          AccountFilterChip(
            accounts: accounts,
            selectedIds: const {1},
            onChanged: (ids) => updated = ids,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap chip to open dialog
      await tester.tap(find.byType(FilterChip));
      await tester.pumpAndSettle();

      expect(find.text('Comptes pris en compte'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Compte Courant'),
        ),
        findsOneWidget,
      );
      expect(find.text('Carte Débit Différé'), findsOneWidget);
      expect(find.text('Livret A'), findsOneWidget);

      // Check the second account
      await tester.tap(find.text('Carte Débit Différé'));
      await tester.pumpAndSettle();

      // Apply
      await tester.tap(find.text('Appliquer'));
      await tester.pumpAndSettle();

      expect(updated, equals({1, 2}));
    });
  });

  group('AccountDialog', () {
    testWidgets(
      'displays deferred card configuration fields when kind is deferredCard',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            AccountDialog(
              groupId: 1,
              account: accounts[1], // deferredCard
              existingAccounts: accounts,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("Jour d'arrêté mensuel (1-31)"), findsOneWidget);
        expect(find.text('Jour de prélèvement (1-31)'), findsOneWidget);
        expect(find.text('Compte courant prélevé'), findsOneWidget);
        expect(find.text('28'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
      },
    );
  });
}
