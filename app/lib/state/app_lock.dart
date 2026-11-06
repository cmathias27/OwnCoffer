import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../client.dart';
import '../util/device_auth.dart';

/// The app's lock, above every page.
final appLock = AppLock(
  store: SecureLockStore(),
  deviceAuth: DeviceAuth.platform(),
  verifyPassword: (password) => client.appLock.verifyPassword(password),
  standalone: () => isStandalone,
);

/// Where the lock keeps its settings and state, on this device only.
abstract class LockStore {
  Future<String?> read(String key);
  Future<void> write(String key, String? value);
}

class SecureLockStore implements LockStore {
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: 'appLock.$key');

  @override
  Future<void> write(String key, String? value) => value == null
      ? _storage.delete(key: 'appLock.$key')
      : _storage.write(key: 'appLock.$key', value: value);
}

enum UnlockResult { unlocked, wrongPassword, signedOut }

/// The automatic lock (decision 0025): after some minutes without any
/// touch, click or key, the app hides behind a lock screen. The session
/// stays open; the password, or the device's own unlock (fingerprint,
/// Windows Hello), lifts the lock. After [maxFailures] wrong passwords or
/// [maxLocked] behind the lock, the device is signed out.
///
/// Off by default; settings belong to the device, not to the account.
class AppLock extends ChangeNotifier {
  static const timeouts = [5, 15, 30, 60];
  static const defaultMinutes = 15;
  static const maxFailures = 5;
  static const maxLocked = Duration(hours: 8);

  /// The last activity is written at most this often (it survives a reload
  /// of the web page, which must not lift the lock).
  static const _persistEvery = Duration(seconds: 30);

  final LockStore _store;
  final DeviceAuth deviceAuth;
  final Future<bool> Function(String password) _verifyPassword;
  final DateTime Function() _now;
  final bool Function() _standalone;

  AppLock({
    required this._store,
    required this.deviceAuth,
    required this._verifyPassword,
    required this._standalone,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    _lastActivity = _now();
  }

  // Settings.
  var enabled = false;
  var minutes = defaultMinutes;
  var deviceUnlock = false;
  var deviceUnlockOffered = false;
  var hideContent = false;

  // State.
  var locked = false;
  DateTime? lockedAt;
  var failures = 0;
  late DateTime _lastActivity;
  DateTime? _persistedActivity;

  /// Set when the device was signed out by the lock (shown once).
  var signedOutByLock = false;

  /// Whether the sign-in page says why the device was signed out; only
  /// the first time.
  bool takeSignedOutByLock() {
    final value = signedOutByLock;
    signedOutByLock = false;
    return value;
  }

  /// A signed-in session is on screen: only then does the lock apply.
  var active = false;
  Future<void> Function()? _signOut;

  Future<void>? _loading;
  DeviceAuthKind? _kind;

  bool get standalone => _standalone();
  Duration get timeout => Duration(minutes: minutes);
  int get attemptsLeft => maxFailures - failures;

  /// Reads the settings and a lock left by a previous run (a web page
  /// reloaded while locked stays locked).
  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    try {
      enabled = await _store.read('enabled') == 'true';
      final m = int.tryParse(await _store.read('minutes') ?? '');
      if (m != null && timeouts.contains(m)) minutes = m;
      deviceUnlock = await _store.read('device') == 'true';
      deviceUnlockOffered = await _store.read('deviceOffered') == 'true';
      hideContent = await _store.read('hide') == 'true';
      final last = int.tryParse(await _store.read('lastActivity') ?? '');
      if (last != null) {
        _lastActivity = DateTime.fromMillisecondsSinceEpoch(last);
        _persistedActivity = _lastActivity;
      }
      final at = int.tryParse(await _store.read('lockedAt') ?? '');
      if (enabled && at != null) {
        locked = true;
        lockedAt = DateTime.fromMillisecondsSinceEpoch(at);
      }
      failures = int.tryParse(await _store.read('failures') ?? '') ?? 0;
      if (hideContent) unawaited(setWindowSecure(true));
    } on Object catch (e) {
      // Unreadable storage: the defaults (no lock) apply.
      debugPrint('App lock settings unreadable: $e');
    }
    notifyListeners();
  }

  /// What the device offers to unlock (cached).
  Future<DeviceAuthKind> deviceKind() async =>
      _kind ??= await deviceAuth.kind();

  /// Whether the device's unlock is offered on the lock screen.
  Future<bool> canUseDevice() async =>
      (deviceUnlock || standalone) && await deviceKind() != DeviceAuthKind.none;

  /// A signed-in session is shown; [signOut] ends it.
  Future<void> attach(Future<void> Function() signOut) async {
    _signOut = signOut;
    if (active) return;
    active = true;
    // A lock already loaded (web page reloaded) shows before anything else.
    notifyListeners();
    await load();
    await check();
    notifyListeners();
  }

  /// No signed-in session any more (signed out, another server).
  void detach() {
    if (!active) return;
    active = false;
    _signOut = null;
    if (locked || failures > 0) {
      locked = false;
      lockedAt = null;
      failures = 0;
      unawaited(_store.write('lockedAt', null));
      unawaited(_store.write('failures', null));
    }
    notifyListeners();
  }

  /// A touch, click or key: the idle time starts again.
  void activity() {
    if (locked) return;
    final now = _now();
    _lastActivity = now;
    final persisted = _persistedActivity;
    if (enabled &&
        (persisted == null || now.difference(persisted) >= _persistEvery)) {
      unawaited(persistActivity());
    }
  }

  /// Writes the last activity now (the app goes to the background).
  Future<void> persistActivity() async {
    _persistedActivity = _lastActivity;
    await _store.write(
      'lastActivity',
      '${_lastActivity.millisecondsSinceEpoch}',
    );
  }

  /// Locks when idle too long; signs out after too long behind the lock.
  /// Called regularly and when the app comes back to the foreground.
  Future<void> check() async {
    if (!active || !enabled) return;
    if (standalone && await deviceKind() == DeviceAuthKind.none) {
      // The device lost its screen lock: nothing could unlock the app any
      // more, so the lock is turned off rather than shutting its owner out.
      await setEnabled(false);
      return;
    }
    final now = _now();
    if (!locked) {
      final idleSince = _lastActivity.add(timeout);
      if (!now.isBefore(idleSince)) await _lock(idleSince);
    }
    final at = lockedAt;
    if (locked &&
        at != null &&
        !standalone &&
        now.difference(at) >= maxLocked) {
      await _forceSignOut();
    }
  }

  /// The « Lock now » button.
  Future<void> lockNow() async {
    if (!active || !enabled || locked) return;
    await _lock(_now());
  }

  Future<void> _lock(DateTime at) async {
    locked = true;
    lockedAt = at;
    notifyListeners();
    await _store.write('lockedAt', '${at.millisecondsSinceEpoch}');
  }

  Future<void> _unlock() async {
    locked = false;
    lockedAt = null;
    failures = 0;
    _lastActivity = _now();
    notifyListeners();
    await _store.write('lockedAt', null);
    await _store.write('failures', null);
    await persistActivity();
  }

  /// Checks [password] with the server. Errors (no network) are thrown and
  /// do not count as a wrong password. [beforeUnlock] runs once the
  /// password is right, while the lock screen is still shown.
  Future<UnlockResult> unlockWithPassword(
    String password, {
    Future<void> Function()? beforeUnlock,
  }) async {
    if (await _verifyPassword(password)) {
      if (beforeUnlock != null) await beforeUnlock();
      await _unlock();
      return UnlockResult.unlocked;
    }
    return recordFailure();
  }

  /// The lock screen's « Sign out » button.
  Future<void> signOut() async {
    final signOut = _signOut;
    detach();
    if (signOut != null) await signOut();
  }

  /// A refused password (also when the server refuses any more attempts).
  Future<UnlockResult> recordFailure() async {
    failures++;
    await _store.write('failures', '$failures');
    if (failures >= maxFailures && !standalone) {
      await _forceSignOut();
      return UnlockResult.signedOut;
    }
    notifyListeners();
    return UnlockResult.wrongPassword;
  }

  /// Fingerprint, face, Windows Hello or the device's PIN.
  Future<bool> unlockWithDevice(String reason) async {
    if (!await deviceAuth.authenticate(reason)) return false;
    await _unlock();
    return true;
  }

  Future<void> _forceSignOut() async {
    signedOutByLock = true;
    await signOut();
  }

  // Settings, each written at once.

  Future<void> setEnabled(bool value) async {
    enabled = value;
    _lastActivity = _now();
    if (value && standalone) deviceUnlock = true;
    if (!value) {
      locked = false;
      lockedAt = null;
      failures = 0;
    }
    notifyListeners();
    await _store.write('enabled', '$value');
    await _store.write('device', '$deviceUnlock');
    await _store.write('lockedAt', null);
    await _store.write('failures', null);
    await persistActivity();
  }

  Future<void> setMinutes(int value) async {
    if (!timeouts.contains(value)) return;
    minutes = value;
    notifyListeners();
    await _store.write('minutes', '$value');
  }

  Future<void> setDeviceUnlock(bool value) async {
    deviceUnlock = value || standalone;
    deviceUnlockOffered = true;
    notifyListeners();
    await _store.write('device', '$deviceUnlock');
    await _store.write('deviceOffered', 'true');
  }

  Future<void> setHideContent(bool value) async {
    hideContent = value;
    notifyListeners();
    await _store.write('hide', '$value');
    await setWindowSecure(value);
  }

  /// After a first unlock with the password: whether to offer the device's
  /// unlock for the next times.
  Future<bool> shouldOfferDevice() async =>
      !standalone &&
      !deviceUnlock &&
      !deviceUnlockOffered &&
      await deviceKind() != DeviceAuthKind.none;
}
