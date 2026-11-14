import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/follow_up_screen.dart';
import 'package:owncoffer_app/screens/projects_screen.dart';
import 'package:owncoffer_app/screens/together_screen.dart';
import 'package:owncoffer_app/screens/wealth_screen.dart';
import 'package:owncoffer_app/widgets/entry_dialog.dart';
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
  home: Scaffold(body: home),
);

final _membership = GroupMembership(
  group: FinanceGroup(
    id: 1,
    name: 'Foyer',
    createdBy: UuidValue.fromString('00000000-0000-4000-8000-000000000000'),
  ),
  role: MemberRole.user,
);

final _accounts = [
  Account(id: 1, groupId: 1, name: 'Courant', kind: AccountKind.checking),
];

void main() {
  setUpAll(() => client = Client('http://localhost:9/'));

  testWidgets('entry dialog: a missing amount is said, cents come back', (
    tester,
  ) async {
    Map<String, Object?>? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showEntryDialog(
                context,
                title: 'Projet',
                fields: [
                  const TextEntry('name', 'Nom'),
                  const AmountEntry('amount', 'Montant'),
                  DateEntry('date', 'Date', initial: DateTime.utc(2026, 11, 1)),
                  const AmountEntry('extra', 'Bonus', optional: true),
                ],
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Vacances');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(find.text('Vérifiez le champ « Montant ».'), findsOneWidget);
    expect(result, isNull);

    await tester.enterText(find.byType(TextField).at(1), '1 234,50');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(result, {
      'name': 'Vacances',
      'amount': 123450,
      'date': DateTime.utc(2026, 11, 1),
      'extra': null,
    });
  });

  final pages = <String, Widget Function()>{
    'projects': () =>
        ProjectsScreen(membership: _membership, accounts: _accounts),
    'wealth': () => WealthScreen(membership: _membership, accounts: _accounts),
    'together': () => TogetherScreen(membership: _membership),
    'follow-up': () =>
        FollowUpScreen(membership: _membership, accounts: _accounts),
  };
  for (final MapEntry(key: name, value: build) in pages.entries) {
    testWidgets('$name: a phone width, an unreachable server is said', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(build()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  }
}
