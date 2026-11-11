import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:timezone/timezone.dart' as tz;

import '../client.dart';
import '../l10n/app_localizations.dart';
import 'app_lock.dart';
import 'start_device.dart';

/// Pépite, the hamster of OwnCoffer (decision 0026).
final pepite = Pepite(
  store: SecurePepiteStore(),
  reminders: PepiteReminders.platform(),
  status: (today) async {
    final dev = await startDevice();
    final marks = deviceMarks(dev);
    return client.pepite.status(today, device: marks.isEmpty ? null : marks);
  },
  complete: (today) => client.pepite.completeRitual(today),
);

class SecurePepiteStore implements LockStore {
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: 'pepite.$key');

  @override
  Future<void> write(String key, String? value) => value == null
      ? _storage.delete(key: 'pepite.$key')
      : _storage.write(key: 'pepite.$key', value: value);
}

/// Pépite was born in 2026 (decision 0026).
const pepiteFirstYear = 2026;

/// The years whose « Ton année » can be seen on [today] (decision 0031):
/// each year over since Pépite exists, and the current one from December.
List<int> pepiteYears(DateTime today) => [
  for (
    var y = today.month == DateTime.december ? today.year : today.year - 1;
    y >= pepiteFirstYear;
    y--
  )
    y,
];

/// The steps of the weekly ritual; [celebrate] completes it.
enum PepiteStep { statements, check, forecast, celebrate }

/// What Pépite cheers about without being asked (decision 0029).
class PepiteCheer {
  /// The status after it.
  final PepiteStatus status;

  /// The week was completed (otherwise only badges).
  final bool week;
  final int seeds;
  final List<String> badges;

  /// The challenge of the month just done (decision 0030), by its code.
  final String? challenge;

  const PepiteCheer({
    required this.status,
    required this.week,
    required this.seeds,
    required this.badges,
    this.challenge,
  });
}

/// The mascot: the weekly accounts ritual, its seeds and badges (kept by
/// the server, or by the embedded server in the standalone version), and
/// its settings, which belong to the device: shown or hidden, the weekly
/// reminder by notification (opt-in, Android and Windows only).
///
/// What Pépite says is decided by [pepiteLine], never by an AI.
class Pepite extends ChangeNotifier {
  static const defaultDay = DateTime.sunday;
  static const defaultHour = 18;

  /// Notifications are planned this many weeks ahead (Windows cannot
  /// repeat one); each start of the app plans them again.
  static const plannedWeeks = 4;
  static const _firstId = 4200;

  final LockStore _store;
  final PepiteReminders reminders;
  final Future<PepiteStatus> Function(DateTime today) _fetch;
  final Future<PepiteStatus> Function(DateTime today) _complete;
  final Future<PepiteStatus> Function(String code, DateTime today) _buy;
  final Future<PepiteStatus> Function(String code, bool on, DateTime today)
  _equip;
  final Future<PepiteStatus> Function(String code, DateTime today) _choose;
  final Future<PepiteStatus> Function(DateTime today) _drop;
  final DateTime Function() _now;

  /// The web app, where Pépite invites to install the apps.
  final bool browser;

  Pepite({
    required this._store,
    required this.reminders,
    required Future<PepiteStatus> Function(DateTime today) status,
    required this._complete,
    Future<PepiteStatus> Function(String code, DateTime today)? buy,
    Future<PepiteStatus> Function(String code, bool on, DateTime today)? equip,
    Future<PepiteStatus> Function(String code, DateTime today)? choose,
    Future<PepiteStatus> Function(DateTime today)? drop,
    DateTime Function()? now,
    bool? browser,
  }) : _fetch = status,
       _buy = buy ?? ((code, today) => client.pepite.buy(code, today)),
       _equip =
           equip ?? ((code, on, today) => client.pepite.equip(code, on, today)),
       _choose =
           choose ??
           ((code, today) => client.pepite.chooseChallenge(code, today)),
       _drop = drop ?? ((today) => client.pepite.dropChallenge(today)),
       _now = now ?? DateTime.now,
       browser = browser ?? kIsWeb;

  // Settings of this device.
  var enabled = true;
  var reminderOn = false;
  var reminderDay = defaultDay;
  var reminderHour = defaultHour;

  /// The challenges of the month are offered (decision 0028, point 10).
  var challengesOn = true;

  /// Where the user stands; null until known (or when the server cannot
  /// be reached: Pépite then stays quiet).
  PepiteStatus? status;
  DateTime? _snoozedUntil;
  String? _stepsWeek;
  var _steps = <PepiteStep>{};

  // The invitation to install the apps (decision 0027, point 8).
  DateTime? _appsShownOn;
  DateTime? _appsLaterUntil;
  var _appsNever = false;
  bool? _overdrawn;

  Future<void>? _loading;

  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    try {
      enabled = await _store.read('enabled') != 'false';
      reminderOn = await _store.read('reminder') == 'true';
      challengesOn = await _store.read('challenges') != 'false';
      reminderDay = _int(await _store.read('day'), defaultDay, 1, 7);
      reminderHour = _int(await _store.read('hour'), defaultHour, 0, 23);
      _snoozedUntil = DateTime.tryParse(await _store.read('snoozed') ?? '');
      _stepsWeek = await _store.read('stepsWeek');
      _appsShownOn = DateTime.tryParse(await _store.read('appsShown') ?? '');
      _appsLaterUntil = DateTime.tryParse(
        await _store.read('appsLater') ?? '',
      );
      _appsNever = await _store.read('appsNever') == 'true';
      _steps = {
        for (final name in (await _store.read('steps') ?? '').split(','))
          ...PepiteStep.values.where((s) => s.name == name),
      };
    } catch (_) {
      // Storage unavailable: defaults.
    }
    notifyListeners();
  }

  static int _int(String? value, int fallback, int min, int max) {
    final v = int.tryParse(value ?? '');
    return v == null || v < min || v > max ? fallback : v;
  }

  /// Monday of the current week, as the key of the steps done.
  String get _week {
    final now = _now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - DateTime.monday));
    return '${monday.year}-${monday.month}-${monday.day}';
  }

  /// Steps already done this week (forgotten once the week is over):
  /// ticked or seen on this device, or seen by the server in the data, a
  /// statement imported or an operation changed (decision 0029).
  Set<PepiteStep> get steps => Set.unmodifiable({
    if (_stepsWeek == _week) ..._steps,
    for (final name in status?.weekSteps ?? const <String>[])
      ...PepiteStep.values.where((s) => s.name == name),
  });

  /// The three steps before celebrating.
  static const ritualSteps = [
    PepiteStep.statements,
    PepiteStep.check,
    PepiteStep.forecast,
  ];

  bool get ritualReady => ritualSteps.every(steps.contains);

  /// What Pépite noticed by herself (decision 0029): the week completed as
  /// soon as its three steps are seen, or badges earned along the way.
  /// Shown once by the home page ([takeCheer]).
  PepiteCheer? _cheer;

  bool get hasCheer => _cheer != null;

  PepiteCheer? takeCheer() {
    final c = _cheer;
    _cheer = null;
    return c;
  }

  void _addCheer(PepiteStatus s, {bool week = false}) {
    final challenge = challengesOn && (s.challenge?.justDone ?? false)
        ? s.challenge!.code
        : null;
    if (!enabled || (!week && s.newBadges.isEmpty && challenge == null)) {
      return;
    }
    final before = _cheer;
    _cheer = PepiteCheer(
      status: s,
      week: week || (before?.week ?? false),
      seeds: s.earnedSeeds + (before?.seeds ?? 0),
      badges: [...?before?.badges, ...s.newBadges],
      challenge: challenge ?? before?.challenge,
    );
  }

  Future<void>? _completing;
  DateTime? _fetchedAt;

  /// Pépite looks by herself again (a change of page, an import): at most
  /// every [noticeEvery], unless [force].
  static const noticeEvery = Duration(seconds: 20);

  Future<void> notice({bool force = false}) async {
    final last = _fetchedAt;
    if (!force && last != null && _now().difference(last) < noticeEvery) {
      return;
    }
    await refresh();
  }

  /// The three steps are seen and the week not counted yet: the server
  /// counts it, without waiting for "Fêter ça".
  Future<void> _completeIfReady() async {
    final s = status;
    if (!enabled || s == null || s.doneThisWeek || !ritualReady) return;
    if (_completing != null) return _completing;
    _completing = () async {
      try {
        await celebrate(cheer: true);
      } catch (_) {
        // The server will be asked again at the next look.
      } finally {
        _completing = null;
      }
    }();
    return _completing;
  }

  bool get doneThisWeek => status?.doneThisWeek ?? false;

  /// "Plus tard": the reminder card hides until tomorrow.
  bool get snoozed {
    final until = _snoozedUntil;
    return until != null && _now().isBefore(until);
  }

  /// Today, as a date (UTC midnight, so that days are 24 hours apart).
  DateTime get _today {
    final now = _now();
    return DateTime.utc(now.year, now.month, now.day);
  }

  /// An account is below zero, now or in the forecast (said by the home
  /// page): no invitation then. Unknown until it says so.
  set overdrawn(bool value) {
    if (_overdrawn == value) return;
    _overdrawn = value;
    notifyListeners();
  }

  /// Pépite invites to install the Android or Windows app: in a browser,
  /// for someone with no app session (no « Pépite nomade » badge), unless
  /// an account is overdrawn, after « Plus tard » for a week, or ever
  /// after « Ne plus proposer ».
  bool get invitesApps {
    final s = status;
    final later = _appsLaterUntil;
    return enabled &&
        browser &&
        s != null &&
        !s.badges.contains(nomadBadge) &&
        _overdrawn == false &&
        !_appsNever &&
        (later == null || !_today.isBefore(later));
  }

  /// The card of the home page (or the banner of a phone's browser): on
  /// one day of the week at most.
  bool get appsCardDue {
    if (!invitesApps) return false;
    final shown = _appsShownOn;
    final today = _today;
    return shown == null ||
        shown == today ||
        today.difference(shown).inDays >= 7;
  }

  /// The card was shown today.
  Future<void> appsCardShown() async {
    final today = _today;
    if (_appsShownOn == today) return;
    _appsShownOn = today;
    await _quietly(() => _store.write('appsShown', today.toIso8601String()));
  }

  /// « Plus tard »: not a word about the apps for a week.
  Future<void> appsLater() async {
    _appsLaterUntil = _today.add(const Duration(days: 7));
    notifyListeners();
    await _quietly(
      () => _store.write('appsLater', _appsLaterUntil!.toIso8601String()),
    );
  }

  /// « Ne plus proposer »: never again on this device.
  Future<void> appsNever() async {
    _appsNever = true;
    notifyListeners();
    await _quietly(() => _store.write('appsNever', 'true'));
  }

  /// Seeds left to spend in the shop (decision 0028, point 4); the total
  /// earned, [PepiteStatus.seeds], never goes down.
  int get seedsToSpend {
    final s = status;
    return s == null ? 0 : (s.seeds - s.spentSeeds).clamp(0, s.seeds);
  }

  bool owns(String code) => status?.items.contains(code) ?? false;

  bool wears(String code) => status?.equipped.contains(code) ?? false;

  /// The accessory Pépite wears, if any (one at a time).
  String? get accessory {
    for (final code in status?.equipped ?? const <String>[]) {
      if (core.pepiteItemByCode(code)?.category ==
          core.PepiteItemCategory.accessory) {
        return code;
      }
    }
    return null;
  }

  /// The burrow items on show, in the order they were acquired.
  List<String> get burrow => [
    for (final code in status?.equipped ?? const <String>[])
      if (core.pepiteItemByCode(code)?.category ==
          core.PepiteItemCategory.burrow)
        code,
  ];

  /// Buys [code]; the server checks the seeds and the item. Throws the
  /// server's refusal.
  Future<void> buyItem(String code) async {
    status = await _buy(code, _now());
    notifyListeners();
  }

  /// Puts on (or shows) [code], or takes it off.
  Future<void> equipItem(String code, bool on) async {
    status = await _equip(code, on, _now());
    notifyListeners();
  }

  /// The years whose « Ton année » can be seen (decision 0031).
  List<int> get years => pepiteYears(_now());

  /// In January, the year just over, offered on the home page.
  int? get yearReady {
    final now = _now();
    final year = now.year - 1;
    return enabled && now.month == DateTime.january && year >= pepiteFirstYear
        ? year
        : null;
  }

  /// Chooses the challenge of this month (decision 0030), counted from now.
  Future<void> chooseChallenge(String code) async {
    status = await _choose(code, _now());
    notifyListeners();
  }

  /// Drops this month's challenge: nothing is lost.
  Future<void> dropChallenge() async {
    status = await _drop(_now());
    notifyListeners();
  }

  Future<void> setChallengesOn(bool value) async {
    challengesOn = value;
    notifyListeners();
    await _quietly(() => _store.write('challenges', '$value'));
  }

  /// The badge of a first session on an app (PepiteEndpoint).
  static const nomadBadge = 'nomad';

  /// A signed-in session is on screen.
  Future<void> signedIn() async {
    await load();
    await refresh();
  }

  /// Back to the sign-in page: nothing to remind until the next session.
  Future<void> signedOut() async {
    status = null;
    _cheer = null;
    _fetchedAt = null;
    notifyListeners();
    await _quietly(reminders.cancel);
  }

  Future<void> refresh() async {
    try {
      final s = await _fetch(_now());
      status = s;
      _fetchedAt = _now();
      _addCheer(s);
    } catch (_) {
      // No server: Pépite says nothing rather than something wrong.
      status = null;
    }
    notifyListeners();
    await _completeIfReady();
    await plan();
  }

  Future<void> later() async {
    final now = _now();
    _snoozedUntil = DateTime(now.year, now.month, now.day + 1);
    notifyListeners();
    await _store.write('snoozed', _snoozedUntil!.toIso8601String());
  }

  Future<void> markStep(PepiteStep step) async {
    if (_stepsWeek != _week) {
      _stepsWeek = _week;
      _steps = {};
    }
    if (!_steps.add(step)) return;
    notifyListeners();
    await _store.write('stepsWeek', _stepsWeek);
    await _store.write('steps', _steps.map((s) => s.name).join(','));
    await _completeIfReady();
  }

  /// The fourth step: the server counts the week (once) and gives the
  /// seeds and badges.
  /// [cheer]: completed by Pépite herself, the home page cheers.
  Future<PepiteStatus> celebrate({bool cheer = false}) async {
    final s = await _complete(_now());
    status = s;
    if (cheer) _addCheer(s, week: true);
    await markStep(PepiteStep.celebrate);
    notifyListeners();
    await plan();
    return s;
  }

  Future<void> setEnabled(bool value) async {
    enabled = value;
    notifyListeners();
    await _store.write('enabled', '$value');
    await plan();
  }

  /// Turns the notification on; false when the device refuses it.
  Future<bool> setReminder(bool value) async {
    if (value && !await reminders.requestPermission()) return false;
    reminderOn = value;
    notifyListeners();
    await _store.write('reminder', '$value');
    await plan();
    return true;
  }

  Future<void> setReminderTime({int? day, int? hour}) async {
    reminderDay = day ?? reminderDay;
    reminderHour = hour ?? reminderHour;
    notifyListeners();
    await _store.write('day', '$reminderDay');
    await _store.write('hour', '$reminderHour');
    await plan();
  }

  /// Plans the next reminders (or none): a week already done is skipped.
  Future<void> plan() async {
    if (!reminders.supported) return;
    if (!enabled || !reminderOn) {
      await _quietly(reminders.cancel);
      return;
    }
    final l = lookupAppLocalizations(_locale());
    final at = nextReminders(
      now: _now(),
      day: reminderDay,
      hour: reminderHour,
      skipThisWeek: doneThisWeek,
    );
    await _quietly(
      () => reminders.schedule(
        at,
        title: l.pepiteNotifTitle,
        body: l.pepiteNotifBody,
        channel: l.pepiteNotificationChannel,
      ),
    );
  }

  static Locale _locale() =>
      WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'en'
      ? const Locale('en')
      : const Locale('fr');

  static Future<void> _quietly(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('Pépite reminder: $e');
    }
  }

  /// The next [plannedWeeks] times of the reminder, on [day] (1 = Monday)
  /// at [hour], in the device's time, after [now].
  static List<DateTime> nextReminders({
    required DateTime now,
    required int day,
    required int hour,
    required bool skipThisWeek,
  }) {
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - DateTime.monday));
    final result = <DateTime>[];
    for (var week = 0; result.length < plannedWeeks; week++) {
      if (week == 0 && skipThisWeek) continue;
      final at = DateTime(
        monday.year,
        monday.month,
        monday.day + 7 * week + day - 1,
        hour,
      );
      if (at.isAfter(now)) result.add(at);
    }
    return result;
  }

  static int notificationId(int index) => _firstId + index;
}

/// The weekly reminder by notification of the device.
abstract class PepiteReminders {
  /// Android and Windows; in the browser Pépite only reminds on the home
  /// page.
  bool get supported;
  Future<bool> requestPermission();
  Future<void> schedule(
    List<DateTime> at, {
    required String title,
    required String body,
    required String channel,
  });
  Future<void> cancel();

  factory PepiteReminders.platform() =>
      !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.windows)
      ? _LocalReminders()
      : const NoReminders();
}

class NoReminders implements PepiteReminders {
  const NoReminders();

  @override
  bool get supported => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> schedule(
    List<DateTime> at, {
    required String title,
    required String body,
    required String channel,
  }) async {}

  @override
  Future<void> cancel() async {}
}

class _LocalReminders implements PepiteReminders {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<bool?>? _ready;

  Future<void> _init() async {
    await (_ready ??= _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        windows: WindowsInitializationSettings(
          appName: 'OwnCoffer',
          appUserModelId: 'OwnCoffer.OwnCoffer.App',
          guid: '6f0c2a4e-8b1d-4c3a-9e57-2d8f1b6a4c90',
        ),
      ),
    ));
  }

  @override
  bool get supported => true;

  @override
  Future<bool> requestPermission() async {
    await _init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  @override
  Future<void> schedule(
    List<DateTime> at, {
    required String title,
    required String body,
    required String channel,
  }) async {
    await cancel();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pepite',
        channel,
        importance: Importance.defaultImportance,
      ),
    );
    for (final (i, time) in at.indexed) {
      await _plugin.zonedSchedule(
        id: Pepite.notificationId(i),
        scheduledDate: tz.TZDateTime.from(time, tz.UTC),
        notificationDetails: details,
        // Inexact: no permission for exact alarms, a few minutes late at
        // worst.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
      );
    }
  }

  @override
  Future<void> cancel() async {
    await _init();
    for (var i = 0; i < Pepite.plannedWeeks; i++) {
      await _plugin.cancel(id: Pepite.notificationId(i));
    }
  }
}
