import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/category_field.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

void main() {
  final categories = [
    Category(
      id: 1,
      groupId: 1,
      name: 'Alimentation',
      kind: CategoryKind.expense,
    ),
    Category(
      id: 2,
      groupId: 1,
      parentId: 1,
      name: 'Épicerie',
      kind: CategoryKind.expense,
    ),
    Category(id: 3, groupId: 1, name: 'Logement', kind: CategoryKind.expense),
    Category(id: 4, groupId: 1, name: 'Salaire', kind: CategoryKind.income),
  ];

  Future<List<int?>> pump(
    WidgetTester tester, {
    CategoryCreator? onCreate,
  }) async {
    final picked = <int?>[];
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
          body: CategoryFormField(
            categories: categories,
            initialValue: 3,
            label: 'Catégorie',
            noneLabel: 'À classer',
            onChanged: picked.add,
            onCreate: onCreate,
          ),
        ),
      ),
    );
    return picked;
  }

  testWidgets('shows the current category with its parent path', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Logement'), findsOneWidget);
  });

  testWidgets('search ignores accents and case, then picks', (tester) async {
    final picked = await pump(tester);
    await tester.tap(find.text('Logement'));
    await tester.pumpAndSettle();
    expect(find.text('Alimentation › Épicerie'), findsOneWidget);
    expect(find.text('Salaire'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'epic');
    await tester.pumpAndSettle();
    expect(find.text('Salaire'), findsNothing);
    expect(find.text('À classer'), findsNothing);

    await tester.tap(find.text('Alimentation › Épicerie'));
    await tester.pumpAndSettle();
    expect(picked, [2]);
    expect(find.text('Alimentation › Épicerie'), findsOneWidget);
  });

  testWidgets('Enter picks the only match; no match shows a message', (
    tester,
  ) async {
    final picked = await pump(tester);
    await tester.tap(find.text('Logement'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('Aucune catégorie ne correspond.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'sal');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(picked, [4]);
  });

  testWidgets('"no category" is offered when allowed', (tester) async {
    final picked = await pump(tester);
    await tester.tap(find.text('Logement'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('À classer'));
    await tester.pumpAndSettle();
    expect(picked, [null]);
  });

  testWidgets('creates a category named after the search', (tester) async {
    final names = <String>[];
    final picked = await pump(
      tester,
      onCreate: (context, name) async {
        names.add(name);
        return Category(
          id: 9,
          groupId: 1,
          name: name,
          kind: CategoryKind.expense,
        );
      },
    );
    await tester.tap(find.text('Logement'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), ' Vélo ');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Créer la catégorie « Vélo »'));
    await tester.pumpAndSettle();
    expect(names, ['Vélo']);
    expect(picked, [9]);
  });
}
