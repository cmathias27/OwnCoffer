import 'dart:convert';
import 'dart:io';

import 'package:owncoffer_server/embedded.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:sqlite_async/sqlite_async.dart';
import 'package:test/test.dart';

/// Decision 0033: the standalone database file, encrypted with SQLite3
/// Multiple Ciphers.
void main() {
  late Directory tmp;
  late String path;
  setUp(() {
    tmp = Directory.systemTemp.createTempSync('owncoffer-key-');
    path = '${tmp.path}/owncoffer.db';
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  String raw(String p) =>
      latin1.decode(File(p).readAsBytesSync(), allowInvalid: true);

  void plainDatabase() {
    final db = sqlite3.sqlite3.open(path);
    db.execute('PRAGMA journal_mode = WAL');
    db.execute('CREATE TABLE t (label TEXT)');
    db.execute("INSERT INTO t VALUES ('BOULANGERIE')");
    db.close();
  }

  test('keys: random, 64 hexadecimal digits, nothing else accepted', () {
    final a = DatabaseKey.generate();
    expect(DatabaseKey.valid(a), isTrue);
    expect(DatabaseKey.generate(), isNot(a));
    expect(DatabaseKey.valid("' ; DROP TABLE t; --"), isFalse);
    expect(DatabaseKey.valid(a.toUpperCase()), isFalse);
    expect(() => DatabaseKey.encrypt(path, 'x'), throwsArgumentError);
  });

  test('a plain file encrypted in place, then readable with its key '
      'only', () {
    expect(DatabaseKey.state(path), DatabaseFileState.missing);
    plainDatabase();
    expect(DatabaseKey.state(path), DatabaseFileState.plain);
    final key = DatabaseKey.generate();
    DatabaseKey.encrypt(path, key);
    expect(DatabaseKey.state(path), DatabaseFileState.encrypted);
    expect(raw(path), isNot(contains('BOULANGERIE')));
    expect(File('$path-wal').existsSync(), isFalse);

    final db = DatabaseKey.open(path, key);
    expect(db.select('SELECT label FROM t').single['label'], 'BOULANGERIE');
    db.close();
    expect(
      () => DatabaseKey.open(path, DatabaseKey.generate()),
      throwsA(
        isA<sqlite3.SqliteException>().having(
          (e) => e.resultCode,
          'code',
          sqlite3.SqlError.SQLITE_NOTADB,
        ),
      ),
    );
    final plain = sqlite3.sqlite3.open(path);
    expect(() => plain.select('SELECT * FROM t'), throwsA(anything));
    plain.close();
  });

  test('the keyed pool is the one a plain pool on the same file gets '
      '(as Serverpod opens it)', () async {
    final key = DatabaseKey.generate();
    final keyed = await DatabaseKey.openPool(path, key);
    final pod = SqliteDatabase(path: path);
    await pod.execute('CREATE TABLE t (label TEXT)');
    await pod.execute("INSERT INTO t VALUES ('CAFE')");
    expect((await pod.get('SELECT label FROM t'))['label'], 'CAFE');
    expect((await pod.get('PRAGMA journal_mode'))['journal_mode'], 'wal');

    // A consistent copy has the same key; decrypted for a backup.
    final copy = '${tmp.path}/copy.db';
    await pod.execute("VACUUM INTO '$copy'");
    await pod.close();
    await keyed.close();
    expect(DatabaseKey.state(path), DatabaseFileState.encrypted);
    expect(DatabaseKey.state(copy), DatabaseFileState.encrypted);
    DatabaseKey.decrypt(copy, key);
    expect(DatabaseKey.state(copy), DatabaseFileState.plain);
    expect(raw(copy), contains('CAFE'));

    // Once the keyed pool is closed, a plain one cannot read the file.
    final alone = SqliteDatabase(path: path);
    await expectLater(alone.get('SELECT label FROM t'), throwsA(anything));
    try {
      await alone.close();
    } on Object catch (_) {}
  });
}
