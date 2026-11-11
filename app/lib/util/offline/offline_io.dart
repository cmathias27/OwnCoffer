import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:owncoffer_server/embedded.dart' show DatabaseKey;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../offline.dart';

/// Kept answers in their own SQLite file, beside the app's other private
/// files. As for the standalone database (decision 0033): on Windows the
/// file is encrypted with a key kept by the system for this Windows
/// account; Android's private folder is already encrypted and closed to
/// other apps. It is only a copy: a lost key or a broken file is replaced
/// by an empty one.
const _keyName = 'offline.cacheKey';
const _fileName = 'offline-cache.db';

SqliteOfflineStore? _open;

Future<File> _file() async =>
    File('${(await getApplicationSupportDirectory()).path}/$_fileName');

Future<String?> _key({required bool fresh}) async {
  if (!Platform.isWindows) return null;
  const storage = FlutterSecureStorage();
  if (!fresh) {
    final saved = await storage.read(key: _keyName);
    if (saved != null && DatabaseKey.valid(saved)) return saved;
  }
  final key = DatabaseKey.generate();
  await storage.write(key: _keyName, value: key);
  return key;
}

Database _connect(String path, String? key) {
  final db = key == null ? sqlite3.open(path) : DatabaseKey.open(path, key);
  // What is forgotten is overwritten, not left in free pages.
  db.execute('PRAGMA secure_delete = ON');
  db.execute('''
    CREATE TABLE IF NOT EXISTS answer (
      key TEXT PRIMARY KEY,
      body TEXT NOT NULL,
      saved_at INTEGER NOT NULL
    )''');
  return db;
}

Future<OfflineStore?> openOfflineStore() async {
  if (!Platform.isWindows && !Platform.isAndroid) return null;
  final open = _open;
  if (open != null) return open;
  final file = await _file();
  return _open = await openOfflineStoreAt(
    file,
    key: ({required bool fresh}) => _key(fresh: fresh),
  );
}

/// The store in [file], keyed by [key] (null: not encrypted).
@visibleForTesting
Future<SqliteOfflineStore> openOfflineStoreAt(
  File file, {
  required Future<String?> Function({required bool fresh}) key,
}) async {
  await file.parent.create(recursive: true);
  Database db;
  try {
    db = _connect(file.path, await key(fresh: false));
  } on Object catch (e) {
    // Key lost, file damaged: the copy starts again, empty.
    debugPrint('Offline copy reset: $e');
    if (file.existsSync()) file.deleteSync();
    db = _connect(file.path, await key(fresh: true));
  }
  return SqliteOfflineStore(db)..purge(DateTime.now().subtract(offlineKeep));
}

Future<void> clearOfflineStore() async {
  final open = _open;
  if (open != null) return open.clear();
  final file = await _file();
  if (file.existsSync()) await file.delete();
}

bool isUnreachable(Object error) =>
    error is SocketException ||
    error is HandshakeException ||
    error is HttpException ||
    error is http.ClientException;

class SqliteOfflineStore implements OfflineStore {
  final Database db;

  SqliteOfflineStore(this.db);

  void purge(DateTime before) => db.execute(
    'DELETE FROM answer WHERE saved_at < ?',
    [before.millisecondsSinceEpoch],
  );

  @override
  Future<({String body, DateTime savedAt})?> read(String key) async {
    final rows = db.select(
      'SELECT body, saved_at FROM answer WHERE key = ?',
      [key],
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return (
      body: row['body'] as String,
      savedAt: DateTime.fromMillisecondsSinceEpoch(row['saved_at'] as int),
    );
  }

  @override
  Future<void> write(String key, String body, DateTime savedAt) async =>
      db.execute(
        'INSERT OR REPLACE INTO answer (key, body, saved_at) VALUES (?, ?, ?)',
        [key, body, savedAt.millisecondsSinceEpoch],
      );

  @override
  Future<void> clear() async => db.execute('DELETE FROM answer');
}
