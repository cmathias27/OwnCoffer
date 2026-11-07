import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/apps_screen.dart';
import 'package:owncoffer_app/state/app_lock.dart';
import 'package:owncoffer_app/state/pepite.dart';
import 'package:owncoffer_app/util/app_versions.dart';
import 'package:owncoffer_app/widgets/pepite_apps.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

class _MemoryStore implements LockStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}

PepiteStatus _status({List<String> badges = const []}) => PepiteStatus(
  seeds: 0,
  weeks: 0,
  doneThisWeek: false,
  badges: badges,
  earnedSeeds: 0,
  newBadges: const [],
  items: const [],
  equipped: const [],
);

/// Pépite's invitation to install the apps (decision 0027, point 8).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fr = lookupAppLocalizations(const Locale('fr'));
  late _MemoryStore store;
  late DateTime now;
  var server = _status();

  Pepite make({bool browser = true}) => Pepite(
    store: store,
    reminders: const NoReminders(),
    status: (_) async => server,
    complete: (_) async => server,
    now: () => now,
    browser: browser,
  );

  /// Signed in, nothing overdrawn.
  Future<Pepite> ready({bool browser = true}) async {
    final p = make(browser: browser);
    await p.signedIn();
    p.overdrawn = false;
    return p;
  }

  setUp(() {
    store = _MemoryStore();
    now = DateTime(2026, 11, 4, 10);
    server = _status();
  });

  group('who is invited', () {
    test('a browser user with no app session', () async {
      final p = await ready();
      expect(p.invitesApps, isTrue);
      expect(p.appsCardDue, isTrue);
    });

    test('never in the apps themselves', () async {
      expect((await ready(browser: false)).invitesApps, isFalse);
    });

    test('not with « Pépite nomade »: an app was used', () async {
      server = _status(badges: ['first_ritual', Pepite.nomadBadge]);
      expect((await ready()).invitesApps, isFalse);
    });

    test('not while an account is overdrawn, nor before it is known', () async {
      final p = make();
      await p.signedIn();
      expect(p.invitesApps, isFalse);
      p.overdrawn = true;
      expect(p.invitesApps, isFalse);
      p.overdrawn = false;
      expect(p.invitesApps, isTrue);
    });

    test('not when Pépite is hidden, nor without the server', () async {
      final p = await ready();
      await p.setEnabled(false);
      expect(p.invitesApps, isFalse);
      final offline = Pepite(
        store: _MemoryStore(),
        reminders: const NoReminders(),
        status: (_) async => throw Exception('offline'),
        complete: (_) async => throw Exception('offline'),
        browser: true,
      );
      await offline.signedIn();
      offline.overdrawn = false;
      expect(offline.invitesApps, isFalse);
    });
  });

  group('how often', () {
    test('the card: one day a week at most', () async {
      final p = await ready();
      await p.appsCardShown();
      now = DateTime(2026, 11, 4, 22);
      expect(p.appsCardDue, isTrue);
      now = DateTime(2026, 11, 5, 9);
      expect(p.appsCardDue, isFalse);
      // The invitation itself stays: the end of the ritual still says it.
      expect(p.invitesApps, isTrue);
      now = DateTime(2026, 11, 10, 23);
      expect(p.appsCardDue, isFalse);
      now = DateTime(2026, 11, 11, 8);
      expect(p.appsCardDue, isTrue);
      // Kept on the device.
      now = DateTime(2026, 11, 5, 9);
      expect((await ready()).appsCardDue, isFalse);
    });

    test('« Plus tard »: nothing for a week', () async {
      final p = await ready();
      await p.appsLater();
      expect(p.invitesApps, isFalse);
      expect(p.appsCardDue, isFalse);
      now = DateTime(2026, 11, 10, 23);
      expect((await ready()).invitesApps, isFalse);
      now = DateTime(2026, 11, 11, 8);
      expect((await ready()).appsCardDue, isTrue);
    });

    test('« Ne plus proposer »: never again', () async {
      final p = await ready();
      await p.appsNever();
      expect(p.invitesApps, isFalse);
      now = DateTime(2027, 6, 1);
      expect((await ready()).invitesApps, isFalse);
    });
  });

  group('on screen', () {
    Widget app(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      home: Scaffold(body: child),
    );

    testWidgets('the card on a computer; « Ne plus proposer »', (
      tester,
    ) async {
      final p = (await tester.runAsync(ready))!;
      await tester.pumpWidget(
        app(
          Column(
            children: [
              PepiteAppsBanner(controller: p, phone: false),
              PepiteAppsCard(controller: p, phone: false),
            ],
          ),
        ),
      );
      expect(find.text(fr.pepiteAppsCard), findsOneWidget);
      expect(find.text(fr.pepiteAppsBanner), findsNothing);
      expect(find.text(fr.pepiteAppsSee), findsOneWidget);
      await tester.tap(find.text(fr.pepiteAppsNever));
      await tester.pumpAndSettle();
      expect(find.text(fr.pepiteAppsCard), findsNothing);
      expect(find.text(fr.pepiteAppsNeverReply), findsOneWidget);
      expect(store.values['appsNever'], 'true');
    });

    testWidgets('the banner on a phone; « Plus tard »', (tester) async {
      final p = (await tester.runAsync(ready))!;
      await tester.pumpWidget(
        app(
          Column(
            children: [
              PepiteAppsBanner(controller: p, phone: true),
              PepiteAppsCard(controller: p, phone: true),
            ],
          ),
        ),
      );
      expect(find.text(fr.pepiteAppsBanner), findsOneWidget);
      expect(find.text(fr.pepiteAppsCard), findsNothing);
      await tester.tap(find.text(fr.pepiteLater));
      await tester.pumpAndSettle();
      expect(find.text(fr.pepiteAppsBanner), findsNothing);
      expect(find.text(fr.pepiteAppsLaterReply), findsOneWidget);
    });

    testWidgets('nothing in an app', (tester) async {
      final p = (await tester.runAsync(() => ready(browser: false)))!;
      await tester.pumpWidget(
        app(
          Column(
            children: [
              PepiteAppsBanner(controller: p, phone: true),
              PepiteAppsCard(controller: p, phone: false),
            ],
          ),
        ),
      );
      expect(find.byType(Card), findsNothing);
      expect(find.text(fr.pepiteAppsBanner), findsNothing);
    });

    testWidgets('the apps page says what they add', (tester) async {
      AppVersions.appForTests = '1.9.0';
      final p = (await tester.runAsync(ready))!;
      await tester.pumpWidget(
        app(
          AppsScreen(
            serverVersion: '1.9.0',
            open: (_) {},
            why: true,
            pepiteController: p,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(fr.appsWhyPepite), findsOneWidget);
      expect(find.text(fr.appsWhyReminder), findsOneWidget);
      expect(find.text(fr.appsWhyUnlock), findsOneWidget);
      expect(find.text(fr.appsWhyStandalone), findsOneWidget);
      expect(find.text(fr.pepiteBadgeNomad), findsOneWidget);

      // Pépite hidden: the same reasons, without her.
      await tester.runAsync(() => p.setEnabled(false));
      await tester.pumpWidget(
        app(
          AppsScreen(
            key: const ValueKey('hidden'),
            serverVersion: '1.9.0',
            open: (_) {},
            why: true,
            pepiteController: p,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(fr.appsWhyPepite), findsNothing);
      expect(find.text(fr.pepiteBadgeNomad), findsNothing);
      expect(find.text(fr.appsWhyReminder), findsOneWidget);
    });
  });
}
