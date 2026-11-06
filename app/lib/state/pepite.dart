import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:timezone/timezone.dart' as tz;

import '../client.dart';
import '../l10n/app_localizations.dart';
import 'app_lock.dart';

/// Pépite, the hamster of OwnCoffer (decision 0026).
final pepite = Pepite(
  store: SecurePepiteStore(),
  reminders: PepiteReminders.platform(),
  status: (today) => client.pepite.status(today),
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

/// The steps of the weekly ritual; [celebrate] completes it.
enum PepiteStep { statements, check, forecast, celebrate }

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
  final DateTime Function() _now;

  Pepite({
    required this._store,
    required this.reminders,
    required Future<PepiteStatus> Function(DateTime today) status,
    required this._complete,
    DateTime Function()? now,
  }) : _fetch = status,
       _now = now ?? DateTime.now;

  // Settings of this device.
  var enabled = true;
  var reminderOn = false;
  var reminderDay = defaultDay;
  var reminderHour = defaultHour;

  /// Where the user stands; null until known (or when the server cannot
  /// be reached: Pépite then stays quiet).
  PepiteStatus? status;
  DateTime? _snoozedUntil;
  String? _stepsWeek;
  var _steps = <PepiteStep>{};

  Future<void>? _loading;

  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    try {
      enabled = await _store.read('enabled') != 'false';
      reminderOn = await _store.read('reminder') == 'true';
      reminderDay = _int(await _store.read('day'), defaultDay, 1, 7);
      reminderHour = _int(await _store.read('hour'), defaultHour, 0, 23);
      _snoozedUntil = DateTime.tryParse(await _store.read('snoozed') ?? '');
      _stepsWeek = await _store.read('stepsWeek');
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

  /// Steps already done this week (forgotten once the week is over).
  Set<PepiteStep> get steps =>
      _stepsWeek == _week ? Set.unmodifiable(_steps) : const {};

  bool get doneThisWeek => status?.doneThisWeek ?? false;

  /// "Plus tard": the reminder card hides until tomorrow.
  bool get snoozed {
    final until = _snoozedUntil;
    return until != null && _now().isBefore(until);
  }

  /// A signed-in session is on screen.
  Future<void> signedIn() async {
    await load();
    await refresh();
  }

  /// Back to the sign-in page: nothing to remind until the next session.
  Future<void> signedOut() async {
    status = null;
    notifyListeners();
    await _quietly(reminders.cancel);
  }

  Future<void> refresh() async {
    try {
      status = await _fetch(_now());
    } catch (_) {
      // No server: Pépite says nothing rather than something wrong.
      status = null;
    }
    notifyListeners();
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
  }

  /// The fourth step: the server counts the week (once) and gives the
  /// seeds and badges.
  Future<PepiteStatus> celebrate() async {
    final s = await _complete(_now());
    status = s;
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
