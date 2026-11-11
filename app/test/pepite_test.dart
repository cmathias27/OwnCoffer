import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/state/app_lock.dart';
import 'package:owncoffer_app/state/pepite.dart';
import 'package:owncoffer_app/state/pepite_messages.dart';
import 'package:owncoffer_app/state/getting_started.dart';
import 'package:owncoffer_app/state/start_device.dart';
import 'package:owncoffer_app/screens/pepite_screen.dart';
import 'package:owncoffer_app/widgets/pepite.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

class _MemoryStore implements LockStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}

class _FakeReminders implements PepiteReminders {
  var allowed = true;
  var planned = <DateTime>[];
  var cancelled = 0;

  @override
  bool get supported => true;

  @override
  Future<bool> requestPermission() async => allowed;

  @override
  Future<void> schedule(
    List<DateTime> at, {
    required String title,
    required String body,
    required String channel,
  }) async => planned = at;

  @override
  Future<void> cancel() async {
    cancelled++;
    planned = [];
  }
}

PepiteStatus _status({
  int seeds = 0,
  int weeks = 0,
  bool done = false,
  DateTime? last,
  List<String> badges = const [],
  int earned = 0,
  List<String> fresh = const [],
  List<String>? weekSteps,
  PepiteChallengeState? challenge,
}) => PepiteStatus(
  seeds: seeds,
  weeks: weeks,
  doneThisWeek: done,
  firstRitualAt: last,
  lastRitualAt: last,
  badges: badges,
  earnedSeeds: earned,
  newBadges: fresh,
  items: const [],
  equipped: const [],
  weekSteps: weekSteps,
  challenge: challenge,
);

PepiteChallengeState _challenge(
  String code, {
  int progress = 0,
  bool done = false,
  bool justDone = false,
}) => PepiteChallengeState(
  month: '2026-11',
  code: code,
  target: core.pepiteChallengeByCode(code)!.target,
  progress: progress,
  done: done,
  justDone: justDone,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fr = lookupAppLocalizations(const Locale('fr'));
  final en = lookupAppLocalizations(const Locale('en'));

  group('reminder times', () {
    // 2026-11-04 is a Wednesday.
    final wednesday = DateTime(2026, 11, 4, 10);

    test('the next four Sundays at 18:00', () {
      final at = Pepite.nextReminders(
        now: wednesday,
        day: DateTime.sunday,
        hour: 18,
        skipThisWeek: false,
      );
      expect(at, [
        DateTime(2026, 11, 8, 18),
        DateTime(2026, 11, 15, 18),
        DateTime(2026, 11, 22, 18),
        DateTime(2026, 11, 29, 18),
      ]);
    });

    test('a week already done is skipped', () {
      final at = Pepite.nextReminders(
        now: wednesday,
        day: DateTime.sunday,
        hour: 18,
        skipThisWeek: true,
      );
      expect(at.first, DateTime(2026, 11, 15, 18));
      expect(at, hasLength(Pepite.plannedWeeks));
    });

    test('a time already past this week waits for the next', () {
      final at = Pepite.nextReminders(
        now: wednesday,
        day: DateTime.monday,
        hour: 9,
        skipThisWeek: false,
      );
      expect(at.first, DateTime(2026, 11, 9, 9));
      expect(at.every((t) => t.isAfter(wednesday)), isTrue);
    });
  });

  group('what Pépite says', () {
    final today = DateTime(2026, 11, 4);

    test('sober when an account goes below zero', () {
      final line = pepiteLine(
        fr,
        _status(weeks: 5, done: true),
        overdrawn: true,
        today: today,
      );
      expect(line.text, fr.pepiteSober);
      expect(line.pose, isNot(PepitePose.cheer));
    });

    test('cheers once the week is done, no reminder', () {
      final line = pepiteLine(
        fr,
        _status(weeks: 3, done: true),
        overdrawn: false,
        today: today,
      );
      expect(line.pose, PepitePose.cheer);
      expect(line.remind, isFalse);
      expect(
        [fr.pepiteDone0, fr.pepiteDone1, fr.pepiteDone2],
        [
          ...{fr.pepiteDone0, fr.pepiteDone1, fr.pepiteDone2},
        ],
      );
      expect(
        [fr.pepiteDone0, fr.pepiteDone1, fr.pepiteDone2],
        contains(line.text),
      );
    });

    test('welcomes a first time, and a return without reproach', () {
      expect(
        pepiteLine(fr, _status(), overdrawn: false, today: today).text,
        fr.pepiteWelcome,
      );
      final back = pepiteLine(
        fr,
        _status(weeks: 6, last: today.subtract(const Duration(days: 40))),
        overdrawn: false,
        today: today,
      );
      expect(back.text, fr.pepiteWelcomeBack);
      expect(back.remind, isTrue);
    });

    test('the same words all week, other words the next week', () {
      final s = _status(weeks: 2, last: today);
      String on(DateTime d) =>
          pepiteLine(fr, s, overdrawn: false, today: d).text;
      // Monday to Sunday of one week.
      final week = {
        for (var d = 2; d <= 8; d++) on(DateTime(2026, 11, d)),
      };
      expect(week, hasLength(1));
      expect(on(DateTime(2026, 11, 9)), isNot(week.single));
    });

    test('every badge has a name in both languages and a silhouette icon', () {
      for (final l in [fr, en]) {
        for (final code in pepiteBadges) {
          final (name, help) = pepiteBadgeText(l, code);
          expect(name, isNot(code));
          expect(help, isNotEmpty);
          expect(pepiteBadgeIcon(code), isNotNull);
        }
      }
      expect(pepiteBadges, hasLength(24));
    });

    test('decision 0028 badges have hints in both languages', () {
      const hintCodes = [
        'tidy',
        'seer',
        'archivist',
        'loan_master',
        'subscription_hunter',
        'vault',
        'velvet',
        'provident',
        'vigilant',
        'to_the_cent',
        'month_reviews',
        'first_goal',
        'goal_half',
        'goal_kept',
        'scissors',
        'team',
      ];
      for (final l in [fr, en]) {
        for (final code in hintCodes) {
          final hint = pepiteBadgeHint(l, code);
          expect(hint, isNotNull);
          expect(hint, isNotEmpty);
        }
      }
    });

    test('deviceMarks turns device facts into server marks', () {
      expect(
        deviceMarks(const StartDevice(deviceUnlock: true, backup: true)),
        ['device_unlock', 'backup'],
      );
      expect(
        deviceMarks(const StartDevice(deviceUnlock: false, backup: null)),
        isEmpty,
      );
    });
  });

  group('the ritual and settings', () {
    late _MemoryStore store;
    late _FakeReminders reminders;
    late DateTime now;
    late List<DateTime> completed;
    late List<String> chosen;
    var fetches = 0;
    var server = _status();

    Pepite make() => Pepite(
      store: store,
      reminders: reminders,
      status: (_) async {
        fetches++;
        return server;
      },
      complete: (today) async {
        completed.add(today);
        return server = _status(
          seeds: 15,
          weeks: 1,
          done: true,
          last: today,
          badges: ['first_ritual'],
          earned: 15,
          fresh: ['first_ritual'],
        );
      },
      choose: (code, _) async {
        chosen.add(code);
        return server = _status(challenge: _challenge(code));
      },
      drop: (_) async {
        chosen.add('');
        return server = _status();
      },
      now: () => now,
    );

    setUp(() {
      store = _MemoryStore();
      reminders = _FakeReminders();
      now = DateTime(2026, 11, 4, 10);
      completed = [];
      chosen = [];
      fetches = 0;
      server = _status();
    });
    test('the steps seen by the server count (decision 0029)', () async {
      server = _status(weekSteps: ['statements', 'check']);
      final p = make();
      await p.signedIn();
      expect(p.steps, {PepiteStep.statements, PepiteStep.check});
      expect(p.ritualReady, isFalse);
      expect(completed, isEmpty);
      expect(p.hasCheer, isFalse);
    });
    test(
      'the week is counted by herself once the three steps are seen',
      () async {
        server = _status(weekSteps: ['statements']);
        final p = make();
        await p.signedIn();
        await p.markStep(PepiteStep.check);
        expect(completed, isEmpty);
        await p.markStep(PepiteStep.forecast);
        expect(completed, [now]);
        expect(p.doneThisWeek, isTrue);
        final cheer = p.takeCheer()!;
        expect(cheer.week, isTrue);
        expect(cheer.seeds, 15);
        expect(cheer.badges, ['first_ritual']);
        expect(p.takeCheer(), isNull);
        // Once a week: looking again counts nothing more.
        await p.notice(force: true);
        await p.markStep(PepiteStep.forecast);
        expect(completed, hasLength(1));
      },
    );
    test('badges earned along the way are cheered once', () async {
      server = _status(
        seeds: 5,
        badges: ['nomad'],
        earned: 5,
        fresh: ['nomad'],
      );
      final p = make();
      await p.signedIn();
      final cheer = p.takeCheer()!;
      expect(cheer.week, isFalse);
      expect(cheer.badges, ['nomad']);
      expect(cheer.seeds, 5);
      server = _status(seeds: 5, badges: ['nomad']);
      // She looks again at most every 20 s, unless asked.
      expect(fetches, 1);
      await p.notice();
      expect(fetches, 1);
      now = now.add(const Duration(seconds: 21));
      await p.notice();
      expect(fetches, 2);
      await p.notice(force: true);
      expect(fetches, 3);
      expect(p.hasCheer, isFalse);
    });
    test('a challenge chosen, dropped, and cheered once done', () async {
      final p = make();
      await p.load();
      await p.chooseChallenge('rules_3');
      expect(p.status!.challenge!.code, 'rules_3');
      await p.dropChallenge();
      expect(p.status!.challenge, isNull);
      expect(chosen, ['rules_3', '']);
      server = _status(
        earned: core.pepiteChallengeSeeds,
        challenge: _challenge(
          'rules_3',
          progress: 3,
          done: true,
          justDone: true,
        ),
      );
      await p.refresh();
      final cheer = p.takeCheer()!;
      expect(cheer.challenge, 'rules_3');
      expect(cheer.week, isFalse);
      expect(cheer.seeds, core.pepiteChallengeSeeds);
    });
    test('challenges turned off: no cheer, kept on this device', () async {
      final p = make();
      await p.load();
      await p.setChallengesOn(false);
      server = _status(
        challenge: _challenge(
          'goal_1',
          progress: 1,
          done: true,
          justDone: true,
        ),
      );
      await p.refresh();
      expect(p.hasCheer, isFalse);
      final again = make();
      await again.load();
      expect(again.challengesOn, isFalse);
    });
    test('every challenge has a name and a help in both languages', () {
      for (final l in [fr, en]) {
        for (final c in core.pepiteChallenges) {
          final (name, help) = pepiteChallengeText(l, c.code);
          expect(name, isNot(c.code));
          expect(help, isNotEmpty);
        }
      }
    });
    test('a hidden Pépite counts nothing by herself', () async {
      server = _status(
        weekSteps: ['statements', 'check'],
        fresh: ['nomad'],
        earned: 5,
      );
      final p = make();
      await p.load();
      await p.setEnabled(false);
      await p.refresh();
      await p.markStep(PepiteStep.forecast);
      expect(completed, isEmpty);
      expect(p.hasCheer, isFalse);
    });

    test('shown by default, no notification until asked', () async {
      final p = make();
      await p.signedIn();
      expect(p.enabled, isTrue);
      expect(p.reminderOn, isFalse);
      expect(p.status!.weeks, 0);
      expect(reminders.planned, isEmpty);
    });

    test('"Plus tard" hides the reminder until tomorrow', () async {
      final p = make();
      await p.load();
      await p.later();
      expect(p.snoozed, isTrue);
      now = DateTime(2026, 11, 4, 23, 59);
      expect(p.snoozed, isTrue);
      now = DateTime(2026, 11, 5, 0, 1);
      expect(p.snoozed, isFalse);
    });

    test('steps are kept for the week, on this device', () async {
      final p = make();
      await p.load();
      await p.markStep(PepiteStep.statements);
      await p.markStep(PepiteStep.check);
      final again = make();
      await again.load();
      expect(again.steps, {PepiteStep.statements, PepiteStep.check});
      now = DateTime(2026, 11, 10, 10);
      expect(again.steps, isEmpty);
    });

    test('celebrating counts the week and skips its reminder', () async {
      final p = make();
      await p.signedIn();
      expect(await p.setReminder(true), isTrue);
      expect(reminders.planned.first, DateTime(2026, 11, 8, 18));
      final s = await p.celebrate();
      expect(completed, [now]);
      expect(s.earnedSeeds, 15);
      expect(p.doneThisWeek, isTrue);
      expect(reminders.planned.first, DateTime(2026, 11, 15, 18));
    });

    test('a refused permission leaves the reminder off', () async {
      reminders.allowed = false;
      final p = make();
      await p.load();
      expect(await p.setReminder(true), isFalse);
      expect(p.reminderOn, isFalse);
      expect(reminders.planned, isEmpty);
    });

    test('hiding Pépite or signing out cancels the reminder', () async {
      final p = make();
      await p.signedIn();
      await p.setReminder(true);
      await p.setReminderTime(day: DateTime.friday, hour: 8);
      expect(reminders.planned.first, DateTime(2026, 11, 6, 8));
      await p.setEnabled(false);
      expect(reminders.planned, isEmpty);
      await p.setEnabled(true);
      expect(reminders.planned, isNotEmpty);
      await p.signedOut();
      expect(reminders.planned, isEmpty);
      expect(p.status, isNull);
      final again = make();
      await again.load();
      expect(again.reminderDay, DateTime.friday);
      expect(again.reminderHour, 8);
    });

    test('no server: Pépite stays quiet', () async {
      final p = Pepite(
        store: store,
        reminders: reminders,
        status: (_) async => throw Exception('offline'),
        complete: (_) async => throw Exception('offline'),
        now: () => now,
      );
      await p.signedIn();
      expect(p.status, isNull);
    });

    Widget app(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      home: Scaffold(body: child),
    );

    testWidgets('the card reminds, and "Plus tard" hides it', (tester) async {
      final p = make();
      await tester.runAsync(p.signedIn);
      await tester.pumpWidget(
        app(PepiteCard(overdrawn: false, onStep: (_) {}, controller: p)),
      );
      expect(find.text(fr.pepiteWelcome), findsOneWidget);
      expect(find.text(fr.pepiteStart), findsOneWidget);
      await tester.tap(find.text(fr.pepiteLater));
      await tester.pumpAndSettle();
      expect(find.text(fr.pepiteWelcome), findsNothing);
      expect(find.text(fr.pepiteLaterReply), findsOneWidget);
    });

    testWidgets('done this week: the reserve, no reminder', (tester) async {
      server = _status(seeds: 40, weeks: 3, done: true, last: now);
      final p = make();
      await tester.runAsync(p.signedIn);
      await tester.pumpWidget(
        app(PepiteCard(overdrawn: false, onStep: (_) {}, controller: p)),
      );
      expect(find.text(fr.pepiteReserve), findsOneWidget);
      expect(find.text(fr.pepiteStart), findsNothing);
      expect(find.text(fr.pepiteSeeds(40)), findsOneWidget);
    });

    testWidgets('hidden when turned off', (tester) async {
      final p = make();
      await tester.runAsync(p.signedIn);
      await tester.runAsync(() => p.setEnabled(false));
      await tester.pumpWidget(
        app(PepiteCard(overdrawn: false, onStep: (_) {}, controller: p)),
      );
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('PepiteScreen: choose a challenge, see it move', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(900, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final p = make();
      await tester.runAsync(p.signedIn);
      await tester.pumpWidget(app(PepiteScreen(controller: p)));
      await tester.pumpAndSettle();
      expect(find.text(fr.pepiteChallengeIntro(10)), findsOneWidget);
      await tester.tap(find.byKey(const Key('pepite-challenge-goal_1')));
      await tester.pumpAndSettle();
      expect(chosen, ['goal_1']);
      expect(find.byKey(const Key('pepite-challenge')), findsOneWidget);
      expect(find.text(fr.pepiteChallengeProgress(0, 1)), findsOneWidget);
      expect(find.byKey(const Key('pepite-challenge-goal_1')), findsNothing);
      await tester.tap(find.text(fr.pepiteChallengeDrop));
      await tester.pumpAndSettle();
      expect(chosen, ['goal_1', '']);
      expect(find.byKey(const Key('pepite-challenge')), findsNothing);
    });
    testWidgets('PepiteScreen: a challenge done cannot be changed', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(900, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      server = _status(
        seeds: 10,
        challenge: _challenge('rules_3', progress: 3, done: true),
      );
      final p = make();
      await tester.runAsync(p.signedIn);
      await tester.pumpWidget(app(PepiteScreen(controller: p)));
      await tester.pumpAndSettle();
      expect(find.text(fr.pepiteChallengeWon(10)), findsOneWidget);
      expect(find.text(fr.pepiteChallengeDrop), findsNothing);
      expect(find.text(fr.pepiteChallengeChoose), findsNothing);
    });
    testWidgets(
      'PepiteScreen shows locked silhouettes with hints and earned trophies',
      (tester) async {
        tester.view.physicalSize = const Size(900, 2400);
        tester.view.devicePixelRatio = 1;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        server = _status(
          seeds: 25,
          weeks: 2,
          badges: ['first_import', 'tidy'],
        );
        final p = make();
        await tester.runAsync(p.signedIn);
        await tester.pumpWidget(app(PepiteScreen(controller: p)));
        await tester.pumpAndSettle();
        expect(find.text(fr.pepiteBadgeTidy), findsOneWidget);
        expect(find.byIcon(Icons.emoji_events), findsNWidgets(2));
        expect(find.text(fr.pepiteBadgeSeer), findsOneWidget);
        expect(find.text(fr.pepiteBadgeSeerHint), findsOneWidget);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      },
    );
  });
}
