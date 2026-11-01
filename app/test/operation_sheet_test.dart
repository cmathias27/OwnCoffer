import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/widgets/operation_sheet.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

void main() {
  setUpAll(() => client = Client('http://localhost:9/'));

  final membership = GroupMembership(
    group: FinanceGroup(
      id: 1,
      name: 'Foyer',
      createdBy: UuidValue.fromString('00000000-0000-4000-8000-000000000000'),
    ),
    role: MemberRole.user,
  );
  final op = BankTransaction(
    id: 5,
    accountId: 3,
    date: DateTime.utc(2026, 10, 2),
    amountCents: -8000,
    rawLabel: 'CB LIDL',
    cleanLabel: 'LIDL',
    operationKind: 'card',
    scheduledId: 9,
  );

  // Operations page (subscription known) and Budget (opened over the list
  // of a category, subscription looked up): the sheet must show, not a
  // grey error box.
  for (final planned in [true, false]) {
    testWidgets('the operation sheet shows (subscription given: $planned)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 900);
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
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => TextButton(
                    onPressed: () => showOperationSheet(
                      context,
                      membership: membership,
                      operation: op,
                      accounts: [
                        Account(
                          id: 3,
                          groupId: 1,
                          name: 'Courant',
                          kind: AccountKind.checking,
                        ),
                      ],
                      categories: {},
                      subscription: planned
                          ? ScheduledTransaction(
                              id: 9,
                              accountId: 3,
                              amountCents: -8000,
                              label: 'Courses',
                              frequency: ScheduleFrequency.monthly,
                              startDate: DateTime.utc(2026, 1, 2),
                              subscription: true,
                            )
                          : null,
                      onUndone: () {},
                      onChanged: (_) {},
                    ),
                    child: const Text('LIDL'),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('LIDL'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.text('Libellé de la banque : CB LIDL', skipOffstage: false),
        findsOneWidget,
      );
      // Actions as tiles: an icon and its name.
      expect(
        find.byIcon(Icons.call_split, skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('Ventiler entre plusieurs catégories', skipOffstage: false),
        findsOneWidget,
      );
      for (final section in ['Fournisseur', 'Classement', 'Suivi']) {
        expect(find.text(section, skipOffstage: false), findsOneWidget);
      }
      expect(find.textContaining('80,00', skipOffstage: false), findsOneWidget);
      expect(
        find.text('Abonnement « Courses »', skipOffstage: false),
        planned ? findsOneWidget : findsNothing,
      );
    });
  }
}
