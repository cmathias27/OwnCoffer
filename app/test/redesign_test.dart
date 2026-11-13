import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/navigation/search.dart';
import 'package:owncoffer_app/navigation/sections.dart';
import 'package:owncoffer_app/screens/notifications_screen.dart';
import 'package:owncoffer_app/screens/operations_screen.dart';
import 'package:owncoffer_app/state/app_lock.dart' show LockStore;
import 'package:owncoffer_app/state/ui_prefs.dart';
import 'package:owncoffer_app/widgets/period_bar.dart';
import 'package:owncoffer_app/widgets/soft.dart';
import 'package:owncoffer_app/widgets/why.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

// Decision 0041: the pieces of the new interface that do not need a server.

class _MemoryStore implements LockStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}

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
  final fr = lookupAppLocalizations(const Locale('fr'));

  group('sections', () {
    test('five sections, every page in exactly one', () {
      expect(AppSection.values, hasLength(5));
      final pages = [for (final s in AppSection.values) ...s.pages];
      expect(pages.toSet(), AppPage.values.toSet());
      expect(pages, hasLength(AppPage.values.length));
      for (final p in AppPage.values) {
        expect(p.section.pages, contains(p));
      }
      expect(AppPage.loans.section, AppSection.plan);
      expect(AppPage.advisor.section, AppSection.advisor);
    });

    testWidgets('a page opened on top shows its trail', (tester) async {
      await tester.pumpWidget(
        _app(
          Scaffold(
            appBar: AppBar(
              title: TrailTitle(
                trail: [fr.navPlan, fr.navLoans],
                title: 'Maison',
              ),
            ),
          ),
        ),
      );
      expect(find.text('${fr.navPlan} › ${fr.navLoans}'), findsOneWidget);
      expect(find.text('Maison'), findsOneWidget);
    });
  });

  group('device preferences', () {
    test('kept and read back, defaults otherwise', () async {
      final store = _MemoryStore();
      final prefs = UiPrefs(store: store);
      await prefs.load();
      expect(prefs.period, SharedPeriod.thisMonth);
      expect(prefs.accountId, isNull);
      expect(prefs.textScale, 1.0);

      await prefs.setSimpleMode(true);
      await prefs.setLargeText(true);
      await prefs.setPeriod(SharedPeriod.thisYear);
      await prefs.setAccountId(12);
      await prefs.markAdvisorSeen(DateTime.utc(2026, 11, 12, 8));
      await prefs.setOperationFilters('1,0,0,');
      await prefs.setHomeBoard(
        HomeBoard.defaults(2).removed(HomeTileKind.firstSteps),
      );

      final again = UiPrefs(store: store);
      await again.load();
      expect(again.simpleMode, isTrue);
      expect(again.textScale, 1.25);
      expect(again.period, SharedPeriod.thisYear);
      expect(again.accountId, 12);
      expect(again.advisorSeenAt, DateTime.utc(2026, 11, 12, 8));
      expect(again.operationFilters, '1,0,0,');
      expect(again.homeBoard(2).contains(HomeTileKind.firstSteps), isFalse);
    });

    test('only the look rebuilds the app', () async {
      final prefs = UiPrefs(store: _MemoryStore());
      var calls = 0;
      prefs.addListener(() => calls++);
      await prefs.setPeriod(SharedPeriod.lastMonth);
      await prefs.setAccountId(3);
      await prefs.setOperationFilters('0,1,0,');
      expect(calls, 0);
      await prefs.setHighContrast(true);
      expect(calls, 1);
    });

    test('an unknown period falls back to this month', () async {
      final store = _MemoryStore()..values['period'] = 'someday';
      final prefs = UiPrefs(store: store);
      await prefs.load();
      expect(prefs.period, SharedPeriod.thisMonth);
    });
  });

  group('shared period', () {
    test('a day inside the period asked for', () {
      final today = DateTime.utc(2026, 3, 31);
      expect(sharedPeriodRange(SharedPeriod.thisMonth, today), (
        BudgetPeriod.month,
        today,
      ));
      // 31 March minus one month must not fall on 3 March.
      expect(sharedPeriodRange(SharedPeriod.lastMonth, today), (
        BudgetPeriod.month,
        DateTime.utc(2026, 2, 28),
      ));
      expect(
        sharedPeriodRange(SharedPeriod.lastMonth, DateTime.utc(2026, 1, 10)),
        (BudgetPeriod.month, DateTime.utc(2025, 12, 10)),
      );
      expect(sharedPeriodRange(SharedPeriod.thisYear, today), (
        BudgetPeriod.year,
        today,
      ));
    });
  });

  group('operation filters', () {
    test('written and read back', () {
      final s = encodeOperationFilters(
        toClassify: false,
        uncleared: true,
        subscriptions: false,
        category: 42,
      );
      final f = decodeOperationFilters(s);
      expect(f.toClassify, isFalse);
      expect(f.uncleared, isTrue);
      expect(f.subscriptions, isFalse);
      expect(f.category, 42);
    });

    test('nothing kept: no filter', () {
      final f = decodeOperationFilters('');
      expect(f.toClassify, isFalse);
      expect(f.uncleared, isFalse);
      expect(f.subscriptions, isFalse);
      expect(f.category, isNull);
    });
  });

  group('search of the functions', () {
    test('accents and case do not matter', () {
      expect(foldForSearch('Opérations À CLASSER'), 'operations a classer');
    });

    test('found by name or keyword, the name first', () {
      expect(
        searchFunctions(fr, 'opé', AppFunction.values).first,
        AppFunction.operations,
      );
      expect(
        searchFunctions(fr, 'mot de passe', AppFunction.values),
        contains(AppFunction.security),
      );
      expect(searchFunctions(fr, '', AppFunction.values), isEmpty);
      expect(searchFunctions(fr, 'zzzz', AppFunction.values), isEmpty);
    });

    test('only among the functions offered', () {
      expect(
        searchFunctions(fr, 'administration', const [AppFunction.home]),
        isEmpty,
      );
    });
  });

  group('global search', () {
    final account = Account(
      id: 3,
      groupId: 1,
      name: 'Compte courant',
      kind: AccountKind.checking,
    );
    final operation = BankTransaction(
      id: 7,
      accountId: 3,
      date: DateTime.utc(2026, 10, 5),
      amountCents: -4590,
      rawLabel: 'CB BOULANGERIE DU COIN',
      cleanLabel: 'BOULANGERIE DU COIN',
      operationKind: 'card',
    );

    testWidgets('functions at once, then the operations of the server', (
      tester,
    ) async {
      final asked = <String>[];
      SearchPick? picked;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  picked = await Navigator.of(context).push<SearchPick>(
                    MaterialPageRoute(
                      builder: (_) => GlobalSearchScreen(
                        groupId: 1,
                        functions: AppFunction.values,
                        accounts: {3: account},
                        searcher: (groupId, query) async {
                          asked.add(query);
                          return GlobalSearchResult(
                            operations: [operation],
                            loans: const [],
                            invoices: const [],
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('global-search-field')),
        'boulang',
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(asked, ['boulang']);
      expect(find.text('BOULANGERIE DU COIN'), findsOneWidget);

      await tester.tap(find.text('BOULANGERIE DU COIN'));
      await tester.pumpAndSettle();
      expect(picked, isA<OperationPick>());
      expect((picked! as OperationPick).operation.id, 7);
    });

    testWidgets('offline: the functions only', (tester) async {
      await tester.pumpWidget(
        _app(
          GlobalSearchScreen(
            groupId: 1,
            functions: AppFunction.values,
            searcher: (groupId, query) async => throw StateError('offline'),
          ),
        ),
      );
      await tester.enterText(
        find.byKey(const Key('global-search-field')),
        'budget',
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('search-fn-budget')), findsOneWidget);
      expect(find.text(fr.globalSearchOffline), findsOneWidget);
    });
  });

  group('notifications', () {
    test('sorted in three families', () {
      expect(
        notificationFamily('overdraft_forecast'),
        NotificationFamily.alerts,
      );
      expect(notificationFamily('goal_over'), NotificationFamily.alerts);
      expect(notificationFamily('goal_forecast'), NotificationFamily.advice);
      expect(notificationFamily('warranty_ending'), NotificationFamily.advice);
      expect(
        notificationFamily('session_closed_by_admin'),
        NotificationFamily.system,
      );
      expect(notificationFamily('unknown_future'), NotificationFamily.system);
    });
  });

  group('explanations', () {
    testWidgets('why this figure shows the calculation', (tester) async {
      await tester.pumpWidget(
        _app(
          const Scaffold(
            body: WhyButton(
              title: 'Reste',
              lines: [
                WhyLine('Revenus', 200000),
                WhyLine('Dépenses', -150000),
                WhyLine('Reste', 50000, total: true),
              ],
              explanation: 'Revenus moins dépenses.',
            ),
          ),
        ),
      );
      await tester.tap(find.text(fr.whyThisFigure));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('why-dialog')), findsOneWidget);
      expect(find.text('Revenus'), findsOneWidget);
      expect(find.text('Revenus moins dépenses.'), findsOneWidget);
      await tester.tap(find.text(fr.close));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('why-dialog')), findsNothing);
    });

    testWidgets('a card tells what it shows', (tester) async {
      await tester.pumpWidget(
        _app(
          const Scaffold(
            body: SoftSection(
              icon: Icons.event_outlined,
              title: 'Cette semaine',
              help: 'Les échéances des 7 prochains jours.',
              children: [],
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip(fr.cardHelpTooltip));
      await tester.pumpAndSettle();
      expect(find.text('Les échéances des 7 prochains jours.'), findsOneWidget);
    });

    testWidgets('an empty page gives the first step', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: EmptyState(
              icon: Icons.receipt_long_outlined,
              text: fr.operationsEmpty,
              hint: fr.emptyOperationsHint,
              actionLabel: fr.operationAdd,
              onAction: () => tapped++,
            ),
          ),
        ),
      );
      expect(find.text(fr.emptyOperationsHint), findsOneWidget);
      await tester.tap(find.byKey(const Key('empty-action')));
      expect(tapped, 1);
    });
  });

  group('period bar', () {
    testWidgets('the choice is kept on the device', (tester) async {
      SharedPeriod? chosen;
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: PeriodBar(
              selected: SharedPeriod.thisMonth,
              onChanged: (p) => chosen = p,
            ),
          ),
        ),
      );
      await tester.tap(find.text(fr.periodThisYear));
      await tester.pump();
      expect(chosen, SharedPeriod.thisYear);
      expect(uiPrefs.period, SharedPeriod.thisYear);
    });
  });
}
