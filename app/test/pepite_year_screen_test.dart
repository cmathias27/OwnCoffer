import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/pepite_year_screen.dart';
import 'package:owncoffer_app/state/pepite.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

PepiteYear _year({
  int weeks = 0,
  List<String> badges = const [],
  int challenges = 0,
  int kept = 0,
  int tracked = 0,
  Category? best,
  int stopped = 0,
  int monthly = 0,
}) => PepiteYear(
  year: 2026,
  weeks: weeks,
  badges: badges,
  challenges: challenges,
  seeds: weeks * 10 + badges.length * 5 + challenges * 10,
  goalMonthsKept: kept,
  goalMonthsTracked: tracked,
  bestCategory: best,
  bestCategoryMonths: best == null ? null : kept,
  subscriptionsStopped: stopped,
  subscriptionsMonthlyCents: monthly,
);

void main() {
  final fr = lookupAppLocalizations(const Locale('fr'));
  final en = lookupAppLocalizations(const Locale('en'));

  Widget app(Widget child) => MaterialApp(
    locale: const Locale('fr'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: child,
  );

  test('which years can be seen', () {
    expect(pepiteYears(DateTime(2026, 11, 11)), isEmpty);
    expect(pepiteYears(DateTime(2026, 12, 1)), [2026]);
    expect(pepiteYears(DateTime(2027, 1, 3)), [2026]);
    expect(pepiteYears(DateTime(2028, 12, 24)), [2028, 2027, 2026]);
  });

  test('texts in both languages', () {
    for (final l in [fr, en]) {
      expect(l.pepiteYearTitle(2026), contains('2026'));
      expect(l.pepiteYearGoals(75), contains('75'));
      expect(l.pepiteYearHow, isNotEmpty);
    }
  });

  testWidgets('the year told: weeks, goals, best category, subscriptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final food = Category(
      id: 3,
      groupId: 1,
      standardCode: 'food',
      kind: CategoryKind.expense,
    );
    await tester.pumpWidget(
      app(
        PepiteYearScreen(
          year: 2026,
          load: (_) async => _year(
            weeks: 12,
            badges: ['first_ritual'],
            challenges: 2,
            kept: 3,
            tracked: 4,
            best: food,
            stopped: 1,
            monthly: 999,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(fr.pepiteYearTitle(2026)), findsOneWidget);
    expect(find.text(fr.pepiteYearWeeks(12)), findsOneWidget);
    expect(find.text(fr.pepiteYearSeeds(145)), findsOneWidget);
    expect(find.text(fr.pepiteYearChallenges(2)), findsOneWidget);
    expect(find.text(fr.pepiteYearGoals(75)), findsOneWidget);
    expect(find.text(fr.pepiteYearGoalsDetail(3, 4)), findsOneWidget);
    expect(find.textContaining(fr.pepiteYearSubscriptions(1)), findsOneWidget);
  });

  testWidgets('an empty year is said without reproach', (tester) async {
    await tester.pumpWidget(
      app(PepiteYearScreen(year: 2026, load: (_) async => _year())),
    );
    await tester.pumpAndSettle();
    expect(find.text(fr.pepiteYearEmpty(2026)), findsOneWidget);
    expect(find.text(fr.pepiteYearWeeks(0)), findsNothing);
  });
}
