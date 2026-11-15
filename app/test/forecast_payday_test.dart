import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/forecast_screen.dart';
import 'package:owncoffer_app/state/ui_prefs.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

/// Forecast balance: the pay found in the history is proposed, and the
/// month end is marked, budget or calendar month as chosen.
void main() {
  final now = DateTime.now().toUtc();
  final today = DateTime.utc(now.year, now.month, now.day);
  final account = Account(
    id: 4,
    groupId: 1,
    name: 'Courant',
    kind: AccountKind.checking,
  );
  final forecast = ForecastResult(
    accountId: 4,
    today: today,
    until: today.add(const Duration(days: 40)),
    currentBalanceCents: 120000,
    clearedBalanceCents: 120000,
    alertThresholdCents: 0,
    days: [
      for (var i = 0; i <= 40; i++)
        ForecastDay(
          date: DateTime.utc(today.year, today.month, today.day + i),
          balanceCents: 120000 - i * 1000,
        ),
    ],
    events: const [],
    lowestDate: today.add(const Duration(days: 40)),
    lowestBalanceCents: 80000,
    missed: const [],
    proposals: const [],
    autoReconciledCount: 0,
  );
  final payday = PaydaySuggestion(
    accountId: 4,
    label: 'VIR SALAIRE ACME',
    amountCents: 195000,
    dayOfMonth: 25,
    months: 3,
    lastDate: today.subtract(const Duration(days: 10)),
    nextDate: today.add(const Duration(days: 20)),
    tolerancePercent: 5,
  );
  final membership = GroupMembership(
    group: FinanceGroup(
      id: 1,
      name: 'Foyer',
      monthStartDay: 25,
      createdBy: UuidValue.fromString('00000000-0000-4000-8000-000000000000'),
    ),
    role: MemberRole.user,
  );

  /// The first day among the next 41 whose next day is the [start]th.
  DateTime firstEnd(int start) {
    for (var i = 0; ; i++) {
      final d = DateTime.utc(today.year, today.month, today.day + i);
      if (DateTime.utc(d.year, d.month, d.day + 1).day == start) return d;
    }
  }

  late List<String> created;

  setUp(() async {
    created = [];
    await uiPrefs.setMonthEndCalendar(false);
    client = Client(
      'https://coffre.example/api/',
      httpClientOverride: MockClient((r) async {
        if (r.url.path == '/api/scheduled/create') {
          created.add(r.body);
        }
        final Object? answer = switch (r.url.path) {
          '/api/scheduled/forecast' => forecast,
          '/api/scheduled/list' => <ScheduledTransaction>[],
          '/api/scheduled/paydaySuggestion' => payday,
          '/api/category/list' => <Category>[],
          '/api/scheduled/create' => ScheduledTransaction(
            id: 9,
            accountId: 4,
            amountCents: 195000,
            label: 'VIR SALAIRE ACME',
            frequency: ScheduleFrequency.monthly,
            startDate: payday.nextDate,
          ),
          _ => null,
        };
        if (answer == null) return http.Response('{}', 500);
        return http.Response(
          SerializationManager.encodeForProtocol(answer),
          200,
        );
      }),
    );
  });

  Widget screen() => MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: ForecastScreen(
        membership: membership,
        accounts: [account],
        onChanged: () {},
      ),
    ),
  );

  String endText(WidgetTester tester) =>
      tester.widget<Text>(find.textContaining('Fin de mois, le')).data!;

  testWidgets('month end: budget month, then calendar month', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(screen());
    await tester.pumpAndSettle();

    final budget = firstEnd(25);
    final calendar = firstEnd(1);
    expect(endText(tester), contains('${budget.day}'));
    expect(find.text('Repère de fin de mois'), findsOneWidget);

    await tester.tap(find.text('Mois civil'));
    await tester.pumpAndSettle();
    expect(uiPrefs.monthEndCalendar, isTrue);
    expect(endText(tester), contains('${calendar.day}'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the pay found is proposed, checked, then planned', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(screen());
    await tester.pumpAndSettle();

    expect(find.text('Paie repérée'), findsOneWidget);
    expect(find.textContaining('VIR SALAIRE ACME'), findsWidgets);

    await tester.tap(find.text('Ajouter à la prévision'));
    await tester.pumpAndSettle();
    // The form opens filled, as a new planned operation (no delete).
    expect(find.text('Supprimer'), findsNothing);
    expect(
      find.widgetWithText(TextFormField, 'VIR SALAIRE ACME'),
      findsWidgets,
    );
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(created, hasLength(1));
    expect(created.single, contains('195000'));
    expect(find.text('Paie ajoutée au solde prévu.'), findsOneWidget);
  });

  testWidgets('a pay dismissed is not proposed again', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(screen());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ignorer'));
    await tester.pumpAndSettle();
    expect(find.text('Paie repérée'), findsNothing);
    expect(uiPrefs.paydayDismissed(4, 'VIR SALAIRE ACME'), isTrue);
  });
}
