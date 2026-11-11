import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/offline.dart';
import 'package:owncoffer_app/util/offline/offline_io.dart';
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
}
