import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/split_dialog.dart';
import 'package:owncoffer_app/widgets/undo.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

Widget _app(Widget home) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  testWidgets('split: saving needs parts adding up to the amount', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: SplitDialog(
            operation: BankTransaction(
              id: 1,
              accountId: 1,
              date: DateTime.utc(2026, 10, 3),
              amountCents: -10000,
              rawLabel: 'CB HYPER',
              cleanLabel: 'HYPER',
              operationKind: 'card',
            ),
            current: const [],
            categories: [
              Category(
                id: 1,
                groupId: 1,
                name: 'Courses',
                kind: CategoryKind.expense,
              ),
            ],
            currency: 'EUR',
          ),
        ),
      ),
    );
    FilledButton save() => tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Enregistrer'),
    );
    // First part: the whole amount; second part empty.
    expect(save().onPressed, isNull);
    final amounts = find.widgetWithText(TextField, 'Montant');
    await tester.enterText(amounts.at(0), '60');
    await tester.enterText(amounts.at(1), '30');
    await tester.pump();
    expect(find.textContaining('Reste à répartir'), findsOneWidget);
    expect(save().onPressed, isNull);
    await tester.enterText(amounts.at(1), '40');
    await tester.pump();
    expect(
      find.text("Le total correspond au montant de l'opération."),
      findsOneWidget,
    );
    expect(save().onPressed, isNotNull);

    await tester.tap(find.text('Ajouter une part'));
    await tester.pump();
    expect(find.text('Part 3'), findsOneWidget);
    await tester.tap(find.byTooltip('Retirer cette part').last);
    await tester.pump();
    expect(find.text('Part 3'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('undo bar: the action is undone, then the screen refreshed', (
    tester,
  ) async {
    var undone = 0, refreshed = 0;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showUndo(
                ScaffoldMessenger.of(context),
                AppLocalizations.of(context),
                'Catégorie modifiée.',
                () async => undone++,
                after: () => refreshed++,
              ),
              child: const Text('go'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    expect(find.text('Catégorie modifiée.'), findsOneWidget);
    await tester.tap(find.widgetWithText(SnackBarAction, 'Annuler'));
    await tester.pumpAndSettle();
    expect(undone, 1);
    expect(refreshed, 1);
    expect(find.text('Action annulée.'), findsOneWidget);
  });
}
