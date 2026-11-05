import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_versions.dart';
import 'standalone.dart';

/// The automatic backups of the standalone mode (decision 0022): encrypted
/// with the user's passphrase, written to a folder once a day, the ten
/// newest kept. Settings in the device's secure storage.
abstract final class StandaloneBackups {
  static const _storage = FlutterSecureStorage();
  static const _passKey = 'owncoffer.backup.passphrase';
  static const _folderKey = 'owncoffer.backup.folder';
  static const _lastKey = 'owncoffer.backup.last';
  static const _failedKey = 'owncoffer.backup.failed';
  static const _failureKey = 'owncoffer.backup.failure';

  static const every = Duration(days: 1);

  /// How often a running app checks whether a backup is due: an app left
  /// open for days (Windows) still makes its daily backup.
  static const checkEvery = Duration(hours: 1);

  static Future<BackupSettings> settings() async => (
    passphrase: await _storage.read(key: _passKey),
    folder: await _storage.read(key: _folderKey),
    last: DateTime.tryParse(await _storage.read(key: _lastKey) ?? ''),
    failed: DateTime.tryParse(await _storage.read(key: _failedKey) ?? ''),
    failure: await _storage.read(key: _failureKey),
  );

  static Future<bool> get enabled async =>
      (await settings()).passphrase != null;

  static Future<void> enable(String passphrase, String folder) async {
    await _storage.write(key: _passKey, value: passphrase);
    await _storage.write(key: _folderKey, value: folder);
  }

  static Future<void> disable() async {
    await _storage.delete(key: _passKey);
    await _storage.delete(key: _lastKey);
    await _clearFailure();
  }

  static Future<void> _clearFailure() async {
    await _storage.delete(key: _failedKey);
    await _storage.delete(key: _failureKey);
  }

  /// `owncoffer-20261102-0830.ocbackup`: sorted by name = by date.
  static String fileName(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return 'owncoffer-${t.year}${two(t.month)}${two(t.day)}-'
        '${two(t.hour)}${two(t.minute)}${two(t.second)}.ocbackup';
  }

  /// Makes a backup now; returns where it was written.
  static Future<String> backupNow() async {
    final s = await settings();
    final passphrase = s.passphrase, folder = s.folder;
    if (passphrase == null || folder == null) {
      throw StateError('backups not enabled');
    }
    final bytes = await standaloneBackup(passphrase, {
      'app': await AppVersions.app(),
    });
    final now = DateTime.now();
    final path = await writeBackup(folder, fileName(now), bytes);
    await _storage.write(key: _lastKey, value: now.toUtc().toIso8601String());
    await _clearFailure();
    return path;
  }

  /// Whether a backup is due at [now]: never made, a day old, or dated
  /// after [now] (the device's clock was set back: without this, no backup
  /// until the clock catches up).
  static bool isDue(DateTime? last, DateTime now) =>
      last == null || last.isAfter(now) || now.difference(last) >= every;

  static Timer? _timer;
  static var _running = false;

  /// At each start of the standalone mode, then every [checkEvery].
  static void schedule() {
    _timer?.cancel();
    _timer = Timer.periodic(checkEvery, (_) => runIfDue());
    unawaited(runIfDue());
  }

  /// A backup if the last one is a day old. Never stops the app: a failure
  /// is kept (shown in the backups page) and retried at the next check.
  static Future<void> runIfDue({DateTime? now}) async {
    // One at a time; none while a restore has stopped the server.
    if (_running || !standaloneRunning) return;
    _running = true;
    try {
      final s = await settings();
      if (s.passphrase == null) return;
      if (!isDue(s.last, now ?? DateTime.now())) return;
      await backupNow();
    } on Object catch (e) {
      try {
        await _storage.write(
          key: _failedKey,
          value: DateTime.now().toUtc().toIso8601String(),
        );
        await _storage.write(key: _failureKey, value: '$e');
      } on Object {
        // Nothing more to do: the next check tries again.
      }
    } finally {
      _running = false;
    }
  }
}

/// The automatic backups' settings, the last success and the last failure
/// (cleared by the next success).
typedef BackupSettings = ({
  String? passphrase,
  String? folder,
  DateTime? last,
  DateTime? failed,
  String? failure,
});
