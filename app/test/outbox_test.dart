import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:owncoffer_app/client.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/operations_screen.dart';
import 'package:owncoffer_app/screens/outbox_screen.dart';
import 'package:owncoffer_app/util/offline.dart';
import 'package:owncoffer_app/util/outbox.dart';
import 'package:owncoffer_app/widgets/offline_banner.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

class _MemoryOutbox implements OutboxStore {
  final rows = <PendingEntry>[];
  var _next = 1;

  PendingEntry _copy(PendingEntry e, {int? id, String? error}) => PendingEntry(
    id: id ?? e.id,
    userId: e.userId,
    accountId: e.accountId,
    accountName: e.accountName,
    date: e.date,
    amountCents: e.amountCents,
    label: e.label,
    clientRef: e.clientRef,
    savedAt: e.savedAt,
    error: error,
  );

  @override
  Future<List<PendingEntry>> all() async => List.of(rows);

  @override
  Future<void> add(PendingEntry entry) async =>
      rows.add(_copy(entry, id: _next++));

  @override
  Future<void> setError(int id, String? error) async {
    final i = rows.indexWhere((e) => e.id == id);
    rows[i] = _copy(rows[i], error: error);
  }

  @override
  Future<void> remove(int id) async => rows.removeWhere((e) => e.id == id);

  @override
  Future<void> removeOthers(String userId) async =>
      rows.removeWhere((e) => e.userId != userId);

  @override
  Future<void> clear() async => rows.clear();
}

/// The server's own rule for an entry's id (TransactionEndpoint).
final _serverRef = RegExp(r'^[0-9A-Za-z-]{16,64}$');

void main() {
  late _MemoryOutbox store;
  late Outbox box;
  // What the server does with each entry received.
  late Future<void> Function(PendingEntry) server;
  late List<String> received;

  Future<bool> keep(String label, {int cents = -1250}) => box.keep(
    accountId: 4,
    accountName: 'Courant',
    date: DateTime.utc(2026, 11, 2),
    amountCents: cents,
    label: label,
  );

  setUp(() async {
    offlineSince.value = null;
    store = _MemoryOutbox();
    received = [];
    server = (e) async => received.add(e.label);
    box = Outbox(send: (e) => server(e), retryEvery: const Duration(hours: 1))
      ..attach(store);
    await box.signedIn('u1');
  });

  tearDown(() => box.dispose());

  test(
    'an entry kept offline is sent once, with its id, then forgotten',
    () async {
      server = (_) async =>
          throw const ServerpodClientNetworkException('offline');
      expect(await keep('BOULANGERIE'), isTrue);
      await box.flush();
      expect(box.waiting, 1);
      final ref = box.entries.single.clientRef;
      expect(_serverRef.hasMatch(ref), isTrue);

      final refs = <String>[];
      server = (e) async {
        refs.add(e.clientRef);
        received.add(e.label);
      };
      // Two sends at once (timer and reconnection): one only.
      await Future.wait([box.flush(), box.flush()]);
      expect(received, ['BOULANGERIE']);
      expect(refs, [ref]);
      expect(box.entries, isEmpty);
      expect(store.rows, isEmpty);
      expect(box.sent.value, 1);
    },
  );

  test('sent in order; stops when the server cannot be reached', () async {
    server = (_) async =>
        throw const ServerpodClientNetworkException('offline');
    await keep('A');
    await keep('B');
    var tries = 0;
    server = (_) async {
      tries++;
      throw TimeoutException('slow');
    };
    await box.flush();
    expect(tries, 1, reason: 'the next one waits too');
    expect(box.waiting, 2);

    server = (e) async => received.add(e.label);
    await box.flush();
    expect(received, ['A', 'B']);
  });

  test('a refusal stays visible with its reason; the next ones are still '
      'sent; retry and drop', () async {
    server = (_) async =>
        throw const ServerpodClientNetworkException('offline');
    await keep('REFUSED');
    await keep('OK');
    server = (e) async {
      if (e.label == 'REFUSED') {
        throw AccessDeniedException(code: 'account_access_denied');
      }
      received.add(e.label);
    };
    await box.flush();
    expect(received, ['OK']);
    expect(box.entries.single.error, 'account_access_denied');
    expect(box.waiting, 0);

    // A refused one is not sent again by itself.
    await box.flush();
    expect(received, ['OK']);

    // Sent again on demand: refused again, then accepted.
    await box.retry(box.entries.single);
    expect(box.entries.single.refused, isTrue);
    server = (e) async => received.add(e.label);
    await box.retry(box.entries.single);
    expect(received, ['OK', 'REFUSED']);
    expect(box.entries, isEmpty);

    server = (_) async => throw InvalidInputException(code: 'invalid_amount');
    await keep('DROPPED');
    await box.flush();
    await box.drop(box.entries.single);
    expect(store.rows, isEmpty);
  });

  test('the server answering again sends what waits', () async {
    server = (_) async =>
        throw const ServerpodClientNetworkException('offline');
    offlineSince.value = DateTime(2026, 11, 2, 9);
    await keep('A');
    server = (e) async => received.add(e.label);
    offlineSince.value = null;
    await pumpEventQueue();
    expect(received, ['A']);
  });

  test('another account signing in drops the entries it cannot send; '
      'a session that ends keeps them', () async {
    server = (_) async =>
        throw const ServerpodClientNetworkException('offline');
    await keep('A');
    box.signedOut();
    expect(box.entries, isEmpty);
    expect(await box.kept(), 1);
    expect(await keep('NOT KEPT'), isFalse, reason: 'nobody signed in');

    await box.signedIn('u1');
    expect(box.entries.single.label, 'A');

    box.signedOut();
    await box.signedIn('u2');
    expect(box.entries, isEmpty);
    expect(store.rows, isEmpty);
  });

  test('no store (web, standalone): nothing is kept', () async {
    final none = Outbox(send: (_) async {})..attach(null);
    await none.signedIn('u1');
    expect(none.available, isFalse);
    expect(
      await none.keep(
        accountId: 1,
        accountName: 'x',
        date: DateTime.utc(2026),
        amountCents: 1,
        label: 'x',
      ),
      isFalse,
    );
    none.dispose();
  });

  test('what cannot reach the server, and what is a refusal', () {
    expect(
      cannotReach(const ServerpodClientNetworkException('offline')),
      isTrue,
    );
    expect(cannotReach(TimeoutException('x')), isTrue);
    expect(
      cannotReach(ServerpodClientUnknownHttpException('down', 502)),
      isTrue,
    );
    expect(cannotReach(ServerpodClientUnknownHttpException('x', 500)), isFalse);
    expect(cannotReach(AccessDeniedException(code: 'x')), isFalse);
    expect(
      refusalCode(InvalidInputException(code: 'invalid_date')),
      'invalid_date',
    );
    expect(refusalCode(StateError('x')), 'generic');
    final refs = {for (var i = 0; i < 100; i++) newClientRef()};
    expect(refs, hasLength(100));
    expect(refs.every(_serverRef.hasMatch), isTrue);
  });

  Widget app(Widget home, {Locale locale = const Locale('fr')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );

  testWidgets('the banner counts what waits and opens « À synchroniser »', (
    tester,
  ) async {
    var opened = 0;
    await tester.runAsync(() async {
      server = (_) async =>
          throw const ServerpodClientNetworkException('offline');
      await keep('A');
    });
    await tester.pumpWidget(
      app(
        OfflineBanner(
          since: ValueNotifier(null),
          pending: box,
          onOpenOutbox: () => opened++,
          child: const Text('page'),
        ),
      ),
    );
    expect(find.text('1 opération à envoyer'), findsOneWidget);
    await tester.tap(find.text('1 opération à envoyer'));
    expect(opened, 1);
  });

  testWidgets('« À synchroniser » shows the reason, sends again, drops after '
      'asking', (tester) async {
    await tester.runAsync(() async {
      server = (_) async => throw AccessDeniedException(
        code: 'account_access_denied',
      );
      await keep('BOULANGERIE');
      await box.flush();
    });
    await tester.pumpWidget(app(OutboxScreen(pending: box)));
    expect(find.text('À synchroniser'), findsOneWidget);
    expect(find.text('BOULANGERIE'), findsOneWidget);
    expect(find.textContaining('Refusée :'), findsOneWidget);
    expect(find.text('Renvoyer'), findsOneWidget);

    await tester.tap(find.text('Abandonner'));
    await tester.pumpAndSettle();
    expect(find.textContaining('jamais envoyée'), findsOneWidget);
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(box.entries, hasLength(1));

    await tester.tap(find.text('Abandonner'));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await tester.tap(find.widgetWithText(FilledButton, 'Abandonner'));
      await pumpEventQueue();
    });
    await tester.pumpAndSettle();
    expect(box.entries, isEmpty);
    expect(find.text('Rien à synchroniser.'), findsOneWidget);
  });

  testWidgets('leaving asks before losing what is not sent', (tester) async {
    await tester.runAsync(() async {
      server = (_) async =>
          throw const ServerpodClientNetworkException('offline');
      await keep('A');
      await keep('B');
    });
    bool? left;
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async =>
                left = await confirmDropOutbox(context, pending: box),
            child: const Text('quit'),
          ),
        ),
        locale: const Locale('en'),
      ),
    );
    await tester.runAsync(() async {
      await tester.tap(find.text('quit'));
      await pumpEventQueue();
    });
    await tester.pumpAndSettle();
    expect(find.textContaining('2 operations entered'), findsOneWidget);
    await tester.runAsync(() async {
      await tester.tap(find.text('Cancel'));
      await pumpEventQueue();
    });
    await tester.pumpAndSettle();
    expect(left, isFalse);
    expect(store.rows, hasLength(2));

    await tester.runAsync(() async {
      await tester.tap(find.text('quit'));
      await pumpEventQueue();
    });
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await tester.tap(find.text('Continue and lose them'));
      await pumpEventQueue();
    });
    await tester.pumpAndSettle();
    expect(left, isTrue);
    expect(store.rows, isEmpty);
  });

  testWidgets('an operation entered without network waits on the device', (
    tester,
  ) async {
    final calls = <String>[];
    client = Client(
      'https://coffre.example/api/',
      httpClientOverride: MockClient((r) async {
        calls.add(r.url.path);
        throw http.ClientException('offline');
      }),
    );
    await tester.runAsync(() async {
      outbox.attach(store);
      await outbox.signedIn('u1');
    });
    final account = Account(
      id: 4,
      groupId: 1,
      name: 'Courant',
      kind: AccountKind.checking,
    );
    await tester.pumpWidget(
      app(
        OperationsScreen(
          membership: GroupMembership(
            group: FinanceGroup(
              id: 1,
              name: 'Foyer',
              createdBy: UuidValue.fromString(
                '00000000-0000-4000-8000-000000000000',
              ),
            ),
            role: MemberRole.user,
          ),
          accounts: [account],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    final fields = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.at(0), '-12,50');
    await tester.enterText(fields.at(1), 'BOULANGERIE');
    await tester.runAsync(() async {
      await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
      for (var i = 0; i < 20 && outbox.entries.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();
    expect(calls, contains('/api/transaction/create'));
    final kept = outbox.entries.single;
    expect(
      (kept.accountId, kept.accountName, kept.amountCents, kept.label),
      (4, 'Courant', -1250, 'BOULANGERIE'),
    );
    expect(find.textContaining("gardée sur l'appareil"), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    outbox.attach(null);
  });
}
