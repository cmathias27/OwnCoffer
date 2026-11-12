import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/offline.dart';
import 'package:owncoffer_app/util/offline/offline_io.dart';
import 'package:owncoffer_app/util/outbox.dart';
import 'package:owncoffer_server/embedded.dart' show DatabaseKey;

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('offline'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('answers kept encrypted, forgotten at sign-out', () async {
    final file = File('${dir.path}/offline-cache.db');
    final key = DatabaseKey.generate();
    final store = await openOfflineStoreAt(
      file,
      key: ({required fresh}) async => key,
    );
    final at = DateTime(2026, 11, 11, 9);
    await store.write('a', '[{"name":"Courant"}]', at);
    await store.write('a', '[{"name":"Livret"}]', at);
    final kept = await store.read('a');
    expect(kept?.body, '[{"name":"Livret"}]');
    expect(kept?.savedAt, at);
    expect(await store.read('b'), isNull);

    final bytes = file.readAsBytesSync();
    expect(String.fromCharCodes(bytes.take(15)), isNot('SQLite format 3'));
    expect(String.fromCharCodes(bytes).contains('Livret'), isFalse);

    await store.clear();
    expect(await store.read('a'), isNull);
    store.db.close();
  });

  test('a lost key starts an empty copy, never fails the app', () async {
    final file = File('${dir.path}/offline-cache.db');
    final first = await openOfflineStoreAt(
      file,
      key: ({required fresh}) async => DatabaseKey.generate(),
    );
    await first.write('a', 'x', DateTime.now());
    first.db.close();

    final asked = <bool>[];
    final again = await openOfflineStoreAt(
      file,
      key: ({required fresh}) async {
        asked.add(fresh);
        return DatabaseKey.generate();
      },
    );
    expect(asked, [false, true]);
    expect(await again.read('a'), isNull);
    await again.write('b', 'y', DateTime.now());
    expect((await again.read('b'))?.body, 'y');
    again.db.close();
  });

  test('copies older than 30 days go at opening', () async {
    final file = File('${dir.path}/offline-cache.db');
    final store = await openOfflineStoreAt(
      file,
      key: ({required fresh}) async => null,
    );
    await store.write('old', 'x', DateTime.now().subtract(offlineKeep * 2));
    await store.write('new', 'y', DateTime.now());
    store.db.close();
    final again = await openOfflineStoreAt(
      file,
      key: ({required fresh}) async => null,
    );
    expect(await again.read('old'), isNull);
    expect((await again.read('new'))?.body, 'y');
    again.db.close();
  });

  test('entries made offline are kept encrypted, in order, and survive '
      'a restart', () async {
    final file = File('${dir.path}/offline-cache.db');
    final key = DatabaseKey.generate();
    Future<SqliteOfflineStore> open() =>
        openOfflineStoreAt(file, key: ({required fresh}) async => key);
    PendingEntry entry(String ref, String label) => PendingEntry(
      userId: 'u1',
      accountId: 4,
      accountName: 'Courant',
      date: DateTime.utc(2026, 11, 2),
      amountCents: -1250,
      label: label,
      clientRef: ref,
      savedAt: DateTime(2026, 11, 2, 9),
    );
    var db = (await open()).db;
    var box = SqliteOutboxStore(db);
    await box.add(entry('a' * 32, 'BOULANGERIE'));
    await box.add(entry('b' * 32, 'MARCHE'));
    final first = (await box.all()).first;
    await box.setError(first.id!, 'account_access_denied');
    db.close();
    expect(
      String.fromCharCodes(file.readAsBytesSync()).contains('BOULANGERIE'),
      isFalse,
    );

    final store = await open();
    db = store.db;
    box = SqliteOutboxStore(db);
    final all = await box.all();
    expect(all.map((e) => e.label), ['BOULANGERIE', 'MARCHE']);
    expect(all.first.error, 'account_access_denied');
    expect(all.first.date, DateTime.utc(2026, 11, 2));
    expect(all.first.accountName, 'Courant');
    expect(all.last.error, isNull);

    // The kept answers are forgotten at sign-out, not the entries.
    await store.clear();
    expect(await box.all(), hasLength(2));
    await box.removeOthers('u2');
    expect(await box.all(), isEmpty);
    db.close();
  });
}
