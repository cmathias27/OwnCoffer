import 'dart:io';
import 'dart:math';

import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:sqlite_async/native.dart';
import 'package:sqlite_async/sqlite_async.dart';

/// The database file of the standalone app, encrypted with SQLite3
/// Multiple Ciphers (decision 0033). The key is 32 random bytes kept by
/// the app in the system's secret store, never written beside the file.
///
/// Serverpod opens the file itself, with no way to pass a key: the pool of
/// connections is opened first by [openPool], every connection keyed, and
/// Serverpod's own pool on the same path shares it (sqlite_async keeps one
/// pool per file in the process).
abstract final class DatabaseKey {
  static final _hex = RegExp(r'^[0-9a-f]{64}$');

  /// A new random key, 64 hexadecimal digits.
  static String generate() {
    final random = Random.secure();
    return [
      for (var i = 0; i < 32; i++)
        random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ].join();
  }

  /// Whether [key] is one [generate] could have made (nothing else ever
  /// reaches a PRAGMA).
  static bool valid(String key) => _hex.hasMatch(key);

  static String _checked(String key) {
    if (!valid(key)) throw ArgumentError('Not a database key');
    return key;
  }

  /// What the file at [path] is: missing, a plain SQLite file, or anything
  /// else (encrypted, or not a database at all).
  static DatabaseFileState state(String path) {
    final file = File(path);
    if (!file.existsSync() || file.lengthSync() == 0) {
      return DatabaseFileState.missing;
    }
    final raf = file.openSync();
    try {
      final head = raf.readSync(16);
      return String.fromCharCodes(head) == 'SQLite format 3\u0000'
          ? DatabaseFileState.plain
          : DatabaseFileState.encrypted;
    } finally {
      raf.closeSync();
    }
  }

  /// A connection keyed with [key], then checked: a wrong key fails here
  /// ("file is not a database"), not at the first query.
  static sqlite3.Database open(
    String path,
    String key, {
    sqlite3.OpenMode mode = sqlite3.OpenMode.readWriteCreate,
  }) {
    final db = sqlite3.sqlite3.open(path, mode: mode);
    try {
      db.execute("PRAGMA hexkey = '${_checked(key)}'");
      db.select('SELECT count(*) FROM sqlite_master');
      return db;
    } on Object {
      db.close();
      rethrow;
    }
  }

  /// Encrypts the plain file at [path] in place, the server stopped: a
  /// database of an earlier version, or one just restored from a backup.
  /// SQLite3 Multiple Ciphers rewrites it page by page in a transaction;
  /// it cannot in WAL mode, so the WAL is folded back first (the pool
  /// turns it on again).
  static void encrypt(String path, String key) {
    _checked(key);
    final db = sqlite3.sqlite3.open(path);
    try {
      db.select('PRAGMA journal_mode = DELETE');
      db.execute("PRAGMA hexrekey = '$key'");
    } finally {
      db.close();
    }
    open(path, key).close();
  }

  /// Decrypts the copy at [path] in place (a backup leaves the device
  /// sealed with its passphrase alone, to be restored anywhere).
  static void decrypt(String path, String key) {
    final db = open(path, key);
    try {
      db.select('PRAGMA journal_mode = DELETE');
      db.execute("PRAGMA rekey = ''");
    } finally {
      db.close();
    }
  }

  /// The pool of connections on [path], each keyed with [key]; kept open
  /// while the server runs, which then shares it.
  static Future<SqliteDatabase> openPool(String path, String key) async {
    final db = SqliteDatabase.withFactory(
      _KeyedOpenFactory(path: path, key: _checked(key)),
    );
    try {
      await db.get('SELECT count(*) FROM sqlite_master');
      return db;
    } on Object {
      try {
        await db.close().timeout(const Duration(seconds: 5), onTimeout: () {});
      } on Object catch (_) {}
      rethrow;
    }
  }
}

enum DatabaseFileState { missing, plain, encrypted }

/// The database is encrypted and the app no longer has its key (system
/// secret store reset, or the folder copied to another computer): only a
/// backup brings the data back. The file is left untouched.
class DatabaseKeyLostException implements Exception {
  const DatabaseKeyLostException();

  @override
  String toString() => 'DatabaseKeyLostException';
}

final class _KeyedOpenFactory extends NativeSqliteOpenFactory {
  final String key;

  _KeyedOpenFactory({required super.path, required this.key});

  // The key before anything else reads the file.
  @override
  List<String> pragmaStatements(SqliteOpenOptions options) => [
    "PRAGMA hexkey = '$key'",
    ...super.pragmaStatements(options),
  ];
}
