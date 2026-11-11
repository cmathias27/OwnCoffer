import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/month_summary_screen.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

final _user = UuidValue.fromString('00000000-0000-4000-8000-000000000001');

GroupMembership _membership() => GroupMembership(
  group: FinanceGroup(id: 1, name: 'Foyer', createdBy: _user),
  role: MemberRole.admin,
);

AccountForecastSummary _forecast({
  int end = 80000,
  int lowest = 50000,
  DateTime? below,
  int missed = 0,
}) => AccountForecastSummary(
  accountId: 7,
  accountName: 'Compte joint',
  currency: 'EUR',
  currentBalanceCents: 100000,
  endBalanceCents: end,
  lowestBalanceCents: lowest,
  lowestDate: DateTime.utc(2026, 11, 28),
  alertThresholdCents: 20000,
  firstBelowThresholdDate: below,
  plannedDebitsCents: -45000,
  plannedCreditsCents: 25000,
  missedCount: missed,
);

MonthSummary _summary({
  List<AccountForecastSummary>? forecasts,
  List<AppNotification> alerts = const [],
  List<ActionProposal> proposals = const [],
  List<ScheduledTransaction> rises = const [],
}) => MonthSummary(
  today: DateTime.utc(2026, 11, 11),
  until: DateTime.utc(2026, 12, 11),
  forecasts: forecasts ?? [_forecast()],
  alerts: alerts,
  proposals: proposals,
  priceRises: rises,
);

void main() {
  Widget app(Widget child) => MaterialApp(
    locale: const Locale('fr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: child,
  );

  Future<void> show(
    WidgetTester tester,
    MonthSummary summary, {
    List<Category> categories = const [],
    void Function(int?)? onOpenForecast,
    VoidCallback? onOpenNotifications,
    VoidCallback? onOpenAdvisor,
  }) async {
    tester.view.physicalSize = const Size(900, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      app(
        MonthSummaryScreen(
          membership: _membership(),
          onOpenForecast: onOpenForecast ?? (_) {},
          onOpenNotifications: onOpenNotifications ?? () {},
          onOpenAdvisor: onOpenAdvisor ?? () {},
          load: (groupId) async {
            expect(groupId, 1);
            return (summary, categories);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('texts in both languages', () {
    for (final locale in const [Locale('fr'), Locale('en')]) {
      final l = lookupAppLocalizations(locale);
      expect(l.summaryTitle, isNotEmpty);
      expect(
        l.summaryEnd('11/12', '800 €'),
        allOf(contains('11/12'), contains('800 €')),
      );
      expect(l.summaryMissed(2), contains('2'));
      expect(l.summaryPriceRise('BOX', '34,99 €', '01/12'), contains('BOX'));
      expect(l.summaryAiQuestion, isNotEmpty);
    }
  });

  testWidgets('nothing waiting: forecast and calm sections', (tester) async {
    await show(tester, _summary());
    final l = lookupAppLocalizations(const Locale('fr'));
    expect(find.text(l.summaryTitle), findsOneWidget);
    expect(find.text('Compte joint'), findsOneWidget);
    expect(find.text(l.summaryNoAlert), findsOneWidget);
    expect(find.text(l.summaryNoProposal), findsOneWidget);
    expect(find.text(l.summaryPriceRisesTitle), findsNothing);
    // No AI set up: no explanation button (decision 0006).
    expect(find.text(l.summaryAskAi), findsNothing);
    expect(find.textContaining('en retard'), findsNothing);
  });

  testWidgets('alerts, proposals, rises and links', (tester) async {
    int? forecastAccount;
    var notifications = 0;
    var advisor = 0;
    final food = Category(
      id: 3,
      groupId: 1,
      name: 'Courses',
      kind: CategoryKind.expense,
    );
    await show(
      tester,
      _summary(
        forecasts: [
          _forecast(
            end: -1500,
            lowest: -4000,
            below: DateTime.utc(2026, 11, 20),
            missed: 2,
          ),
        ],
        alerts: [
          AppNotification(
            authUserId: _user,
            groupId: 1,
            accountId: 7,
            type: 'overdraft_forecast',
            data:
                '{"accountName":"Compte joint","date":"2026-11-20",'
                '"balanceCents":-4000,"thresholdCents":20000}',
            dedupKey: 'k',
          ),
        ],
        proposals: [
          ActionProposal(
            id: 9,
            groupId: 1,
            authUserId: _user,
            origin: 'engine',
            kind: 'set_goal',
            targetId: 3,
            proposedValue: 30000,
            reason: 'suggest_goal',
            data: '{}',
            dataVersion: '1',
            status: 'pending',
            dedupKey: 'p',
          ),
        ],
        rises: [
          ScheduledTransaction(
            id: 4,
            accountId: 7,
            amountCents: -2999,
            label: 'BOX',
            frequency: ScheduleFrequency.monthly,
            startDate: DateTime.utc(2026, 1, 5),
            subscription: true,
            priceRiseDate: DateTime.utc(2026, 12, 1),
            priceRiseAmountCents: -3499,
          ),
        ],
      ),
      categories: [food],
      onOpenForecast: (id) => forecastAccount = id,
      onOpenNotifications: () => notifications++,
      onOpenAdvisor: () => advisor++,
    );
    final l = lookupAppLocalizations(const Locale('fr'));
    expect(find.text(l.summaryMissed(2)), findsOneWidget);
    expect(find.textContaining('Sous le seuil'), findsOneWidget);
    expect(find.text(l.summaryNoAlert), findsNothing);
    expect(find.textContaining('Compte joint'), findsNWidgets(2));
    expect(find.textContaining('Courses'), findsOneWidget);
    expect(find.textContaining('BOX'), findsOneWidget);
    expect(find.textContaining('34,99'), findsOneWidget);

    await tester.tap(find.text('Compte joint').first);
    expect(forecastAccount, 7);
    await tester.tap(find.text(l.summaryOpenNotifications));
    expect(notifications, 1);
    await tester.tap(find.text(l.summaryOpenAdvisor));
    await tester.tap(find.textContaining('Courses'));
    expect(advisor, 2);
  });

  testWidgets('a loading error is shown', (tester) async {
    await tester.pumpWidget(
      app(
        MonthSummaryScreen(
          membership: _membership(),
          onOpenForecast: (_) {},
          onOpenNotifications: () {},
          onOpenAdvisor: () {},
          load: (_) async => throw StateError('offline'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Compte joint'), findsNothing);
  });
}
