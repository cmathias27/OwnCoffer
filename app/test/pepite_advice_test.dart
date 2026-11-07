import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/help/help.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/getting_started_screen.dart';
import 'package:owncoffer_app/state/app_lock.dart';
import 'package:owncoffer_app/state/getting_started.dart';
import 'package:owncoffer_app/state/pepite.dart';
import 'package:owncoffer_app/state/pepite_advice.dart';
import 'package:owncoffer_app/widgets/pepite_advice.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

class _MemoryStore implements LockStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}

const _catalogue = [
  PepiteTip('home_cards', HelpTopic.home, 'Les cartes mènent à leur page.'),
  PepiteTip('home_ritual', HelpTopic.home, 'Le rituel prend dix minutes.'),
  PepiteTip('import_ofx', HelpTopic.import, 'Préférez le format OFX.'),
];

final _membership = GroupMembership(
  group: FinanceGroup(
    id: 7,
    name: 'Foyer Exemple',
    createdBy: UuidValue.fromString('00000000-0000-4000-8000-000000000001'),
  ),
  role: MemberRole.admin,
);

PepiteStart _start({
  List<String> steps = const ['account', 'rules', 'scheduled', 'goal', 'app'],
  List<String> done = const [],
  List<String> adminSteps = const [],
  List<String> adminDone = const [],
}) => PepiteStart(
  steps: steps,
  done: done,
  adminSteps: adminSteps,
  adminDone: adminDone,
);

/// Pépite's advice on the app (decision 0028, point 12).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fr = lookupAppLocalizations(const Locale('fr'));
  late _MemoryStore store;
  late DateTime now;
  late Set<String> serverSeen;
  late DateTime? serverLastSeen;
  late bool offline;
  late List<String> sent;

  PepiteTips tips() =>
      PepiteTips(seen: serverSeen.toList(), lastSeenAt: serverLastSeen);

  PepiteAdvice make() => PepiteAdvice(
    store: store,
    tips: () async {
      if (offline) throw Exception('offline');
      return tips();
    },
    seen: (code) async {
      if (offline) throw Exception('offline');
      sent.add(code);
      serverSeen.add(code);
      serverLastSeen = now.toUtc();
      return tips();
    },
    catalogue: (_) async => _catalogue,
    now: () => now,
  );

  Future<PepiteAdvice> ready() async {
    final a = make();
    await a.signedIn();
    await a.prepare('fr');
    return a;
  }

  setUp(() {
    store = _MemoryStore();
    now = DateTime(2026, 11, 7, 10);
    serverSeen = {};
    serverLastSeen = null;
    offline = false;
    sent = [];
  });

  group('the catalogue', () {
    test('headers give the code and the topic, the rest the text', () {
      final tips = PepiteTip.parse('''
# Astuces

Intro ignorée.

## home_cards · home
Les cartes
mènent à leur page.

## bad header
Ignoré.

## import_ofx · import
Préférez l'OFX.

## unknown_topic · nowhere
Ignoré aussi.
''');
      expect(tips.map((t) => t.code), ['home_cards', 'import_ofx']);
      expect(tips.first.topic, HelpTopic.home);
      expect(tips.first.text, 'Les cartes mènent à leur page.');
      expect(tips.last.topic, HelpTopic.import);
    });

    test('the shipped tips: the same codes in French and English', () {
      List<PepiteTip> read(String language) => PepiteTip.parse(
        File('assets/tips/$language/tips.md').readAsStringSync(),
      );
      final frTips = read('fr');
      final enTips = read('en');
      expect(frTips, hasLength(20));
      expect(enTips.map((t) => (t.code, t.topic)), [
        for (final t in frTips) (t.code, t.topic),
      ]);
      expect(frTips.map((t) => t.code).toSet(), hasLength(frTips.length));
    });
  });

  group('one tip a day', () {
    test('the first tip of the screen, kept until seen', () async {
      final a = await ready();
      final tip = a.tipFor(HelpTopic.home);
      expect(tip?.code, 'home_cards');
      // Another screen the same day: nothing more.
      expect(a.tipFor(HelpTopic.import), isNull);
      // Back on the screen: the same tip, even after a restart.
      expect(a.tipFor(HelpTopic.home)?.code, 'home_cards');
      expect((await ready()).tipFor(HelpTopic.home)?.code, 'home_cards');
    });

    test('seen: never again, nor another one that day', () async {
      final a = await ready();
      await a.seen(a.tipFor(HelpTopic.home)!);
      expect(sent, ['home_cards']);
      expect(a.tipFor(HelpTopic.home), isNull);
      expect(a.tipFor(HelpTopic.import), isNull);
      // The next day, the next one.
      now = now.add(const Duration(days: 1));
      expect(a.tipFor(HelpTopic.home)?.code, 'home_ritual');
    });

    test('seen on another device today: none here', () async {
      serverSeen = {'home_cards'};
      serverLastSeen = now.toUtc();
      final a = await ready();
      expect(a.tipFor(HelpTopic.home), isNull);
      now = now.add(const Duration(days: 1));
      expect(a.tipFor(HelpTopic.home)?.code, 'home_ritual');
    });

    test('« Afficher les astuces » off: none, kept on the device', () async {
      final a = await ready();
      await a.setTipsOn(false);
      expect(a.tipFor(HelpTopic.home), isNull);
      final again = await ready();
      expect(again.tipsOn, isFalse);
      expect(again.tipFor(HelpTopic.home), isNull);
    });

    test('without the server: no tip', () async {
      offline = true;
      final a = await ready();
      expect(a.tipFor(HelpTopic.home), isNull);
    });

    test('signed out: no tip until signed in again', () async {
      final a = await ready();
      a.signedOut();
      expect(a.tipFor(HelpTopic.home), isNull);
    });

    test('seen offline: hidden here all the same', () async {
      final a = await ready();
      final tip = a.tipFor(HelpTopic.home)!;
      offline = true;
      await a.seen(tip);
      expect(a.tipFor(HelpTopic.home), isNull);
    });
  });

  group('« Bien démarrer » steps', () {
    test('in the order of the decision, device steps where they apply', () {
      final steps = startSteps(
        _start(
          steps: [
            'members',
            'app',
            'two_factor',
            'goal',
            'scheduled',
            'rules',
            'account',
          ],
          done: ['account', 'app'],
        ),
        const StartDevice(deviceUnlock: true, reminder: false),
      );
      expect(steps, const [
        StartStep('account', true),
        StartStep('rules', false),
        StartStep('scheduled', false),
        StartStep('goal', false),
        StartStep('two_factor', false),
        StartStep('device_unlock', true),
        StartStep('app', true),
        StartStep('reminder', false),
        StartStep('members', false),
      ]);
    });

    test('no device step where it does not apply', () {
      final steps = startSteps(
        _start(steps: ['account']),
        const StartDevice(),
      );
      expect(steps, const [StartStep('account', false)]);
    });

    test('the server administrator\'s list apart', () {
      expect(
        adminSteps(
          _start(adminSteps: ['backups', 'ai'], adminDone: ['ai']),
        ),
        const [StartStep('backups', false), StartStep('ai', true)],
      );
    });
  });

  group('widgets', () {
    late Pepite mascot;

    setUp(() async {
      mascot = Pepite(
        store: _MemoryStore(),
        reminders: const NoReminders(),
        status: (_) async => throw Exception('offline'),
        complete: (_) async => throw Exception('offline'),
        now: () => now,
      );
    });

    Widget app(Widget home) => MaterialApp(
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

    testWidgets('the tip banner: « Compris » and « En savoir plus »', (
      tester,
    ) async {
      final a = await tester.runAsync(ready);
      final opened = <HelpTopic>[];
      await tester.pumpWidget(
        app(
          PepiteTipBanner(
            topic: HelpTopic.home,
            controller: a,
            pepiteController: mascot,
            openHelp: (_, t) => opened.add(t),
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining(_catalogue.first.text), findsOneWidget);
      await tester.tap(find.text(fr.pepiteTipMore));
      await tester.pump();
      expect(opened, [HelpTopic.home]);
      expect(find.textContaining(_catalogue.first.text), findsNothing);
    });

    testWidgets('the start card: « Pas maintenant » never comes back', (
      tester,
    ) async {
      final a = await tester.runAsync(ready);
      var opened = 0;
      Widget card({bool overdrawn = false, Key? key}) => PepiteStartCard(
        key: key,
        membership: _membership,
        overdrawn: overdrawn,
        onOpen: () => opened++,
        load: (_) async => _start(done: ['account']),
        device: () async => const StartDevice(),
        controller: a,
        pepiteController: mascot,
      );
      await tester.pumpWidget(app(card()));
      await tester.pumpAndSettle();
      expect(find.text(fr.startCard(1, 5)), findsOneWidget);
      await tester.tap(find.text(fr.startSee));
      expect(opened, 1);

      // An account below zero: the sober sentence.
      await tester.pumpWidget(
        app(card(overdrawn: true, key: const ValueKey('sober'))),
      );
      await tester.pumpAndSettle();
      expect(find.text(fr.startCardSober(1, 5)), findsOneWidget);

      await tester.tap(find.text(fr.startNotNow));
      await tester.pumpAndSettle();
      expect(find.text(fr.startNotNowReply), findsOneWidget);
      expect(find.text(fr.startCardSober(1, 5)), findsNothing);
      expect(a!.startHidden, isTrue);
      expect(store.values['startHidden'], 'true');
    });

    testWidgets('the start card: hidden once everything is done', (
      tester,
    ) async {
      final a = await tester.runAsync(ready);
      await tester.pumpWidget(
        app(
          PepiteStartCard(
            membership: _membership,
            overdrawn: false,
            onOpen: () {},
            load: (_) async => _start(steps: ['account'], done: ['account']),
            device: () async => const StartDevice(),
            controller: a,
            pepiteController: mascot,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(fr.startSee), findsNothing);
    });

    testWidgets('the list: steps ticked, a tab step closes the page', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(900, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final tabs = <String>[];
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => GettingStartedScreen(
                    membership: _membership,
                    onTab: tabs.add,
                    load: (_) async => _start(
                      done: ['account'],
                      adminSteps: ['backups'],
                    ),
                    device: () async => const StartDevice(),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text(fr.startProgress(1, 5)), findsOneWidget);
      expect(find.text(fr.startAdminTitle), findsOneWidget);
      expect(find.text(fr.startAdminBackups), findsOneWidget);
      // Done: no « Ouvrir »; 4 left plus the administrator's one.
      expect(find.text(fr.startOpen), findsNWidgets(5));
      await tester.tap(find.text(fr.startOpen).first);
      await tester.pumpAndSettle();
      expect(tabs, ['rules']);
      expect(find.text(fr.startTitle), findsNothing);
    });
  });
}
