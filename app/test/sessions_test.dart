import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/state/presence.dart';
import 'package:owncoffer_app/widgets/session_alert.dart';
import 'package:owncoffer_app/widgets/sessions_list.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

SessionInfo _session(
  String id, {
  String? platform,
  String? label,
  String? city,
  bool current = false,
}) => SessionInfo(
  id: id,
  platform: platform,
  appVersion: platform == 'android' ? '1.6.0' : null,
  deviceLabel: label,
  ip: '82.64.10.20',
  city: city,
  country: city == null ? null : 'FR',
  connectedSince: DateTime.utc(2026, 11, 1, 9),
  lastActiveAt: DateTime.utc(2026, 11, 6, 9),
  current: current,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Presence', () {
    test('pings once signed in, then at most every 5 minutes', () async {
      final pings = <String?>[];
      var now = DateTime(2026, 11, 6, 12);
      final p = Presence(
        ping: (platform, version) async => pings.add(version),
        version: () async => '1.6.0',
        standalone: () => false,
        now: () => now,
      );
      await p.attach();
      expect(pings, ['1.6.0']);
      await p.send();
      expect(pings, hasLength(1));
      now = now.add(const Duration(minutes: 6));
      await p.send();
      expect(pings, hasLength(2));
      p.detach();
    });

    test('never in the standalone mode; a failure is retried', () async {
      var calls = 0;
      final alone = Presence(
        ping: (_, _) async => calls++,
        version: () async => '1.6.0',
        standalone: () => true,
      );
      await alone.attach();
      await alone.send(force: true);
      expect(calls, 0);

      var fail = true;
      final p = Presence(
        ping: (_, _) async {
          calls++;
          if (fail) throw Exception('offline');
        },
        version: () async => throw Exception('no version'),
        standalone: () => false,
      );
      await p.attach();
      fail = false;
      // The failed ping does not count: the next one goes at once.
      await p.send();
      expect(calls, 2);
      p.detach();
    });
  });

  testWidgets('own sessions: names, places, close and close the others', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(380, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var sessions = [
      _session('a', platform: 'web', city: 'Rouen', current: true),
      _session('b', platform: 'android', label: 'Téléphone de Léa'),
      _session('c'),
    ];
    final closed = <String>[];
    final renamed = <String, String>{};
    await tester.pumpWidget(
      _app(
        SessionsList(
          load: () async => sessions,
          onClose: (s) async {
            closed.add(s.id);
            sessions = [
              for (final x in sessions)
                if (x.id != s.id) x,
            ];
          },
          onCloseOthers: () async {
            final n = sessions.where((s) => !s.current).length;
            sessions = [
              for (final x in sessions)
                if (x.current) x,
            ];
            return n;
          },
          onRename: (s, label) async => renamed[s.id] = label,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Navigateur · Cet appareil'), findsOneWidget);
    expect(
      find.textContaining('environ Rouen, FR · 82.64.10.20'),
      findsOneWidget,
    );
    expect(find.textContaining('IP Geolocation by DB-IP'), findsOneWidget);
    expect(find.text('Téléphone de Léa'), findsOneWidget);
    expect(
      find.textContaining('Application Android · version 1.6.0'),
      findsOneWidget,
    );
    expect(find.text('Appareil non identifié'), findsOneWidget);
    expect(find.textContaining('lieu inconnu'), findsNWidgets(2));

    // Close the phone.
    await tester.tap(find.byType(PopupMenuButton<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fermer').last);
    await tester.pumpAndSettle();
    expect(find.text('Fermer cette session ?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Fermer'));
    await tester.pumpAndSettle();
    expect(closed, ['b']);
    expect(find.text('Téléphone de Léa'), findsNothing);

    // Close every other one.
    await tester.tap(find.text('Fermer toutes les autres'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Fermer'));
    await tester.pumpAndSettle();
    expect(find.text('1 session fermée'), findsOneWidget);
    expect(find.text('Fermer toutes les autres'), findsNothing);
    expect(find.text('Appareil non identifié'), findsNothing);

    // Rename this one.
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Renommer'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  Bureau  ');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(renamed, {'a': 'Bureau'});
  });

  testWidgets('administrator: no rename, nothing to do on his own session', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        SessionsList(
          load: () async => [_session('a', platform: 'web', current: true)],
          onClose: (_) async {},
          onCloseOthers: () async => 0,
          closeOthersLabel: 'Tout fermer',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PopupMenuButton<String>), findsNothing);
    expect(find.text('Tout fermer'), findsNothing);
  });

  group('session alerts', () {
    AppNotification note(Map<String, Object?> data, {String? type}) =>
        AppNotification(
          authUserId: UuidValue.fromString(
            '00000000-0000-4000-8000-000000000001',
          ),
          type: type ?? SessionAlert.type,
          data: jsonEncode(data),
          dedupKey: 'k',
        );

    test('read from the notification, texts in French', () async {
      final l = await AppLocalizations.delegate.load(const Locale('fr'));
      final device = SessionAlert.of(
        note({
          'session': 's1',
          'platform': 'windows',
          'city': 'Rouen',
          'country': 'FR',
          'ip': '82.64.1.1',
          'newDevice': true,
          'unusualCountry': false,
          'banned': false,
        }),
      )!;
      expect(device.title(l), 'Nouvel appareil connecté : Application Windows');
      expect(
        device.body(l),
        'Application Windows, environ Rouen, FR (82.64.1.1). C\'est vous ?',
      );
      final away = SessionAlert.of(
        note({
          'session': 's2',
          'platform': 'web',
          'country': 'ES',
          'ip': '90.1.2.3',
          'unusualCountry': true,
          'banned': true,
        }),
      )!;
      expect(away.title(l), 'Connexion depuis un pays inhabituel : ES');
      expect(away.body(l), contains('environ ES (90.1.2.3)'));
      expect(away.body(l), contains('déjà été bloquée'));
      expect(SessionAlert.of(note({'session': 's'}, type: 'other')), isNull);
      expect(SessionAlert.of(note({'platform': 'web'})), isNull);
    });

    Future<void> open(
      WidgetTester tester,
      Future<void> Function(String) close,
    ) => tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showSessionAlert(
              context,
              const SessionAlert(
                session: 's1',
                platform: 'android',
                city: 'Rouen',
                country: 'FR',
                ip: '82.64.1.1',
              ),
              close: close,
            ),
            child: const Text('ouvrir'),
          ),
        ),
      ),
    );

    testWidgets('« Oui » closes nothing', (tester) async {
      final closed = <String>[];
      await open(tester, (id) async => closed.add(id));
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();
      expect(find.text('C\'est vous ?'), findsOneWidget);
      await tester.tap(find.text('Oui, c\'est moi'));
      await tester.pumpAndSettle();
      expect(closed, isEmpty);
      expect(find.text('C\'est vous ?'), findsNothing);
    });

    testWidgets('« Non » closes the session, then offers a new password', (
      tester,
    ) async {
      final closed = <String>[];
      await open(tester, (id) async => closed.add(id));
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Non, déconnecter'));
      await tester.pumpAndSettle();
      expect(closed, ['s1']);
      expect(find.text('Session fermée'), findsOneWidget);
      await tester.tap(find.text('Changer le mot de passe'));
      await tester.pumpAndSettle();
      expect(find.text('Nouveau mot de passe'), findsWidgets);
    });

    testWidgets('a session already gone is said so', (tester) async {
      await open(
        tester,
        (_) async => throw InvalidInputException(code: 'session_not_found'),
      );
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Non, déconnecter'));
      await tester.pumpAndSettle();
      expect(find.text('Cette session est déjà fermée'), findsOneWidget);
      await tester.tap(find.text('Plus tard'));
      await tester.pumpAndSettle();
      expect(find.text('Cette session est déjà fermée'), findsNothing);
    });
  });
}
