import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:owncoffer_server/embedded.dart' show DatabaseKey;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../offline.dart';
import '../outbox.dart';

/// Kept answers in their own SQLite file, beside the app's other private
/// files, with the entries made offline waiting to be sent (table
/// `outbox`). As for the standalone database (decision 0033): on Windows the
/// file is encrypted with a key kept by the system for this Windows
/// account; Android's private folder is already encrypted and closed to
/// other apps. A lost key or a broken file is replaced by an empty one:
/// what it held cannot be read anymore.
const _keyName = 'offline.cacheKey';
const _fileName = 'offline-cache.db';

Database? _open;

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
  db.execute('''
    CREATE TABLE IF NOT EXISTS outbox (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id TEXT NOT NULL,
      account_id INTEGER NOT NULL,
      account_name TEXT NOT NULL,
      day INTEGER NOT NULL,
      amount_cents INTEGER NOT NULL,
      label TEXT NOT NULL,
      client_ref TEXT NOT NULL UNIQUE,
      saved_at INTEGER NOT NULL,
      error TEXT
    )''');
  return db;
}

Future<Database?> _database() async {
  if (!Platform.isWindows && !Platform.isAndroid) return null;
  final open = _open;
  if (open != null) return open;
  final file = await _file();
  return _open = (await openOfflineStoreAt(
    file,
    key: ({required bool fresh}) => _key(fresh: fresh),
  )).db;
}

Future<OfflineStore?> openOfflineStore() async {
  final db = await _database();
  return db == null ? null : SqliteOfflineStore(db);
}

Future<OutboxStore?> openOutboxStore() async {
  final db = await _database();
  return db == null ? null : SqliteOutboxStore(db);
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

/// [outbox]: also the entries not sent yet (another server).
Future<void> clearOfflineStore({required bool outbox}) async {
  final open = _open;
  if (open != null) {
    await SqliteOfflineStore(open).clear();
    if (outbox) await SqliteOutboxStore(open).clear();
    return;
  }
  if (!outbox) return;
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

class SqliteOutboxStore implements OutboxStore {
  final Database db;

  SqliteOutboxStore(this.db);

  @override
  Future<List<PendingEntry>> all() async => [
    for (final row in db.select('SELECT * FROM outbox ORDER BY id'))
      PendingEntry(
        id: row['id'] as int,
        userId: row['user_id'] as String,
        accountId: row['account_id'] as int,
        accountName: row['account_name'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(
          row['day'] as int,
          isUtc: true,
        ),
        amountCents: row['amount_cents'] as int,
        label: row['label'] as String,
        clientRef: row['client_ref'] as String,
        savedAt: DateTime.fromMillisecondsSinceEpoch(row['saved_at'] as int),
        error: row['error'] as String?,
      ),
  ];

  @override
  Future<void> add(PendingEntry e) async => db.execute(
    'INSERT INTO outbox (user_id, account_id, account_name, day, '
    'amount_cents, label, client_ref, saved_at) '
    'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [
      e.userId,
      e.accountId,
      e.accountName,
      e.date.millisecondsSinceEpoch,
      e.amountCents,
      e.label,
      e.clientRef,
      e.savedAt.millisecondsSinceEpoch,
    ],
  );

  @override
  Future<void> setError(int id, String? error) async =>
      db.execute('UPDATE outbox SET error = ? WHERE id = ?', [error, id]);

  @override
  Future<void> remove(int id) async =>
      db.execute('DELETE FROM outbox WHERE id = ?', [id]);

  @override
  Future<void> removeOthers(String userId) async =>
      db.execute('DELETE FROM outbox WHERE user_id <> ?', [userId]);

  @override
  Future<void> clear() async => db.execute('DELETE FROM outbox');
}
