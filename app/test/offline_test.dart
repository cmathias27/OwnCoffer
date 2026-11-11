import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/util/offline.dart';
import 'package:owncoffer_app/widgets/offline_banner.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

class _MemoryStore implements OfflineStore {
  final kept = <String, ({String body, DateTime savedAt})>{};

  @override
  Future<({String body, DateTime savedAt})?> read(String key) async =>
      kept[key];

  @override
  Future<void> write(String key, String body, DateTime savedAt) async =>
      kept[key] = (body: body, savedAt: savedAt);

  @override
  Future<void> clear() async => kept.clear();
}

const _api = 'https://coffre.example/api/';

void main() {
  late _MemoryStore store;
  late DateTime clock;
  // What the server does: answers, refuses, or cannot be reached.
  late Future<http.Response> Function(http.Request) server;

  OfflineHttpClient offlineClient() => OfflineHttpClient(
    MockClient((r) => server(r)),
    store,
    now: () => clock,
  );

  Future<http.Response> post(String call, [String body = '{}']) =>
      offlineClient().post(Uri.parse('$_api$call'), body: body);

  setUp(() {
    store = _MemoryStore();
    clock = DateTime(2026, 11, 11, 9);
    offlineSince.value = null;
  });

  test(
    'a read is kept, then shown when the server cannot be reached',
    () async {
      server = (_) async => http.Response('[1]', 200);
      expect((await post('account/list', '{"groupId":1}')).body, '[1]');
      expect(offlineSince.value, isNull);

      clock = clock.add(const Duration(hours: 2));
      server = (_) async => throw const SocketException('no route');
      final r = await post('account/list', '{"groupId":1}');
      expect((r.statusCode, r.body), (200, '[1]'));
      expect(offlineSince.value, DateTime(2026, 11, 11, 9));

      // Other arguments: nothing kept for them.
      await expectLater(
        post('account/list', '{"groupId":2}'),
        throwsA(isA<SocketException>()),
      );

      // Back online: the banner goes.
      server = (_) async => http.Response('[1,2]', 200);
      await post('account/list', '{"groupId":1}');
      expect(offlineSince.value, isNull);
      expect(store.kept.values.single.body, '[1,2]');
    },
  );

  test('a proxy whose server is down counts as unreachable', () async {
    server = (_) async => http.Response('{}', 200);
    await post('group/myGroups');
    for (final status in [502, 503, 504, 521, 522]) {
      server = (_) async => http.Response('down', status);
      expect((await post('group/myGroups')).statusCode, 200);
    }
    server = (_) async => http.Response('down', 502);
    expect((await post('category/list')).statusCode, 502);
  });

  test('a write is never kept nor replayed', () async {
    server = (_) async => http.Response('{"id":3}', 200);
    await post('transaction/create', '{"accountId":1}');
    expect(store.kept, isEmpty);

    server = (_) async => throw const SocketException('no route');
    await expectLater(
      post('transaction/create', '{"accountId":1}'),
      throwsA(isA<SocketException>()),
    );
    expect(offlineSince.value, isNull);
  });

  test('a refusal is not kept and leaves the old copy alone', () async {
    server = (_) async => http.Response('[1]', 200);
    await post('account/list');
    server = (_) async => http.Response('denied', 403);
    expect((await post('account/list')).statusCode, 403);
    expect(store.kept.values.single.body, '[1]');
  });

  test('a copy older than 30 days is not shown', () async {
    server = (_) async => http.Response('[1]', 200);
    await post('account/list');
    clock = clock.add(offlineKeep + const Duration(minutes: 1));
    server = (_) async => throw http.ClientException('offline');
    await expectLater(
      post('account/list'),
      throwsA(isA<http.ClientException>()),
    );
    expect(offlineSince.value, isNull);
  });

  test(
    'the Serverpod client reads the kept answer as from the server',
    () async {
      final accounts = [
        Account(id: 4, groupId: 1, name: 'Courant', kind: AccountKind.checking),
      ];
      var reachable = true;
      final client = Client(
        _api,
        httpClientOverride: OfflineHttpClient(
          MockClient((r) async {
            if (!reachable) throw const SocketException('no route');
            expect(r.url.path, '/api/account/list');
            return http.Response(
              SerializationManager.encodeForProtocol(accounts),
              200,
            );
          }),
          store,
          now: () => clock,
        ),
      );
      expect((await client.account.list(1)).single.name, 'Courant');
      reachable = false;
      final offline = await client.account.list(1);
      expect(offline.single.name, 'Courant');
      expect(offline.single.kind, AccountKind.checking);
      await expectLater(
        client.account.create(1, 'Livret', AccountKind.savings),
        throwsA(isA<ServerpodClientNetworkException>()),
      );
    },
  );

  test('every kept call is a read', () {
    const writes = [
      'create',
      'update',
      'delete',
      'set',
      'remove',
      'archive',
      'trash',
      'restore',
      'purge',
      'accept',
      'refuse',
      'mark',
      'save',
      'buy',
      'upload',
      'attach',
      'ping',
    ];
    for (final call in offlineReads) {
      final method = call.split('.').last.toLowerCase();
      expect(
        writes.where(method.startsWith),
        isEmpty,
        reason: '$call looks like a write',
      );
    }
  });

  testWidgets('the banner says from when, read-only', (tester) async {
    final since = ValueNotifier<DateTime?>(null);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: OfflineBanner(since: since, child: const Text('page')),
      ),
    );
    expect(find.byIcon(Icons.cloud_off_outlined), findsNothing);
    since.value = DateTime(2026, 11, 2, 18, 5);
    await tester.pump();
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(find.textContaining('18:05'), findsOneWidget);
    expect(find.textContaining('lecture seule'), findsOneWidget);
    expect(find.text('page'), findsOneWidget);
  });
}
