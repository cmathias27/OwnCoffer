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

  static const every = Duration(days: 1);

  static Future<({String? passphrase, String? folder, DateTime? last})>
  settings() async => (
    passphrase: await _storage.read(key: _passKey),
    folder: await _storage.read(key: _folderKey),
    last: DateTime.tryParse(await _storage.read(key: _lastKey) ?? ''),
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
    return path;
  }

  /// At each start of the standalone mode: a backup if the last one is a
  /// day old. Never stops the app: a failure waits for the next start.
  static Future<void> runIfDue({DateTime? now}) async {
    try {
      final s = await settings();
      if (s.passphrase == null) return;
      final last = s.last;
      if (last != null && (now ?? DateTime.now()).difference(last) < every) {
        return;
      }
      await backupNow();
    } on Object {
      // Shown as "last backup" in the backups page.
    }
  }
}
