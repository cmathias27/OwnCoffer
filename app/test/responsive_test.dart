import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/budget_screen.dart';
import 'package:owncoffer_app/screens/compare_screen.dart';
import 'package:owncoffer_app/screens/home_screen.dart';
import 'package:owncoffer_app/screens/loans_screen.dart';
import 'package:owncoffer_app/screens/update_progress_screen.dart';
import 'package:owncoffer_app/widgets/operation_sheet.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

final _membership = GroupMembership(
  group: FinanceGroup(
    id: 1,
    name: 'Foyer',
    createdBy: UuidValue.fromString('00000000-0000-4000-8000-000000000000'),
  ),
  role: MemberRole.user,
);
final _accounts = [
  for (final (id, name) in [(1, 'Courant'), (2, 'Commun')])
    Account(id: id, groupId: 1, name: name, kind: AccountKind.checking),
];

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
  setUpAll(() => client = Client('http://localhost:9/'));

  test('a bottom bar on a phone, a rail on a tablet, extended on large', () {
    expect(navLayoutFor(360), NavLayout.bar);
    expect(navLayoutFor(599), NavLayout.bar);
    expect(navLayoutFor(768), NavLayout.rail);
    expect(navLayoutFor(1199), NavLayout.rail);
    expect(navLayoutFor(1200), NavLayout.extendedRail);
  });

  final screens = <String, Widget Function()>{
    'budget': () => Scaffold(
      body: BudgetScreen(membership: _membership, accounts: _accounts),
    ),
    'compare': () => CompareScreen(
      membership: _membership,
      accounts: _accounts,
      categories: const {},
      period: BudgetPeriod.month,
      date: DateTime.utc(2026, 10, 15),
    ),
    'loan form': () =>
        LoanFormScreen(groupId: 1, accounts: _accounts, categories: const []),
    'update': () => const UpdateProgressScreen(target: 'v0.3.21'),
    'operation sheet': () => Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showOperationSheet(
            context,
            membership: _membership,
            operation: BankTransaction(
              id: 5,
              accountId: 1,
              date: DateTime.utc(2026, 10, 2),
              amountCents: -8000,
              rawLabel: 'CB SUPERMARCHE DU CENTRE 02/10',
              cleanLabel: 'SUPERMARCHE DU CENTRE',
              operationKind: 'card',
            ),
            accounts: _accounts,
            categories: {},
            onUndone: () {},
            onChanged: (_) {},
          ),
          child: const Text('open'),
        ),
      ),
    ),
  };

  for (final width in [360.0, 768.0, 1200.0]) {
    for (final MapEntry(key: name, value: build) in screens.entries) {
      testWidgets('$name fits at $width px', (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(_app(build()));
        for (var i = 0; i < 4; i++) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        if (name == 'operation sheet') {
          await tester.tap(find.text('open'));
          for (var i = 0; i < 6; i++) {
            await tester.pump(const Duration(milliseconds: 250));
          }
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
