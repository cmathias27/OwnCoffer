import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import 'offline.dart';
import 'offline/offline_stub.dart'
    if (dart.library.io) 'offline/offline_io.dart'
    as impl;

/// Offline entry of the Windows and Android apps connected to a server
/// (decision 0038): a manual entry made while the server cannot be reached
/// waits here, on the device, then is sent when it answers again. Each
/// entry has an id made on the device, so the server never creates it
/// twice, even when an answer is lost on the way back. Only creations wait
/// here: changes and deletions need the server, so no conflict can arise.

/// An entry waiting to be sent, or refused by the server ([error]: the
/// server's error code, shown until the user retries or drops it).
class PendingEntry {
  final int? id;
  final String userId;
  final int accountId;

  /// To show it without the server.
  final String accountName;
  final DateTime date;
  final int amountCents;
  final String label;
  final String clientRef;
  final DateTime savedAt;
  final String? error;

  const PendingEntry({
    this.id,
    required this.userId,
    required this.accountId,
    required this.accountName,
    required this.date,
    required this.amountCents,
    required this.label,
    required this.clientRef,
    required this.savedAt,
    this.error,
  });

  bool get refused => error != null;
}

/// Where entries wait. One per device and server, beside the kept answers.
abstract class OutboxStore {
  /// In the order they were made.
  Future<List<PendingEntry>> all();
  Future<void> add(PendingEntry entry);
  Future<void> setError(int id, String? error);
  Future<void> remove(int id);

  /// Forgets the entries of every other account of this server: they
  /// cannot be sent under this one.
  Future<void> removeOthers(String userId);
  Future<void> clear();
}

/// The outbox of this device, or null on the web and in standalone mode.
Future<OutboxStore?> openOutboxStore() => impl.openOutboxStore();

/// Whether [error] means the server could not be reached, so the call may
/// be tried again later: no network, a timeout, a proxy whose server is
/// down.
bool cannotReach(Object error) =>
    error is ServerpodClientNetworkException ||
    error is TimeoutException ||
    (error is ServerpodClientHttpException && gatewayDown(error.statusCode)) ||
    isUnreachable(error);

/// The server's error code of a refusal, kept to explain it.
String refusalCode(Object error) => switch (error) {
  AccessDeniedException(:final code) => code,
  InvalidInputException(:final code) => code,
  _ => 'generic',
};

/// A fresh id for an entry: 32 random hex digits.
String newClientRef([Random? random]) {
  final r = random ?? Random.secure();
  return [
    for (var i = 0; i < 32; i++) r.nextInt(16).toRadixString(16),
  ].join();
}

/// Sends an entry to the server, with its id.
typedef SendEntry = Future<void> Function(PendingEntry entry);

class Outbox extends ChangeNotifier {
  final SendEntry send;
  final DateTime Function() _now;
  final Duration retryEvery;

  Outbox({
    required this.send,
    DateTime Function()? now,
    this.retryEvery = const Duration(seconds: 30),
  }) : _now = now ?? DateTime.now {
    offlineSince.addListener(_answering);
  }

  /// The server answers again: what waits is sent at once.
  void _answering() {
    if (offlineSince.value == null && waiting > 0) unawaited(flush());
  }

  OutboxStore? _store;
  String? _user;
  List<PendingEntry> _entries = const [];
  Future<void>? _flushing;
  Timer? _timer;

  /// Counts the entries the server has received, so that pages showing
  /// operations reload.
  final sent = ValueNotifier<int>(0);

  /// Whether entries can wait on this device.
  bool get available => _store != null && _user != null;

  /// Entries of the signed-in account, waiting or refused, oldest first.
  List<PendingEntry> get entries => _entries;

  int get waiting => _entries.where((e) => !e.refused).length;

  /// The store of this device (null: offline entry not possible).
  void attach(OutboxStore? store) {
    _store = store;
    _user = null;
    _entries = const [];
    _stopTimer();
    notifyListeners();
  }

  /// [userId] is signed in: entries of any other account are dropped (they
  /// cannot be sent under this one), the others are sent.
  Future<void> signedIn(String userId) async {
    final store = _store;
    if (store == null) return;
    _user = userId;
    try {
      await store.removeOthers(userId);
    } on Object catch (e) {
      debugPrint('Outbox not read: $e');
    }
    await _load();
    await flush();
  }

  /// Signed out without choosing to drop the entries (session expired):
  /// they stay, for the same account's next sign-in.
  void signedOut() {
    _user = null;
    _entries = const [];
    _stopTimer();
    notifyListeners();
  }

  /// Keeps an entry for later; false when it cannot be kept here.
  Future<bool> keep({
    required int accountId,
    required String accountName,
    required DateTime date,
    required int amountCents,
    required String label,
  }) async {
    final store = _store;
    final user = _user;
    if (store == null || user == null) return false;
    try {
      await store.add(
        PendingEntry(
          userId: user,
          accountId: accountId,
          accountName: accountName,
          date: date,
          amountCents: amountCents,
          label: label,
          clientRef: newClientRef(),
          savedAt: _now(),
        ),
      );
    } on Object catch (e) {
      debugPrint('Outbox entry not kept: $e');
      return false;
    }
    await _load();
    return true;
  }

  /// Sends the waiting entries in order. Stops at the first one the server
  /// cannot be reached for; a refused one is kept with its reason and the
  /// next ones are still sent.
  Future<void> flush() => _flushing ??= _flush().whenComplete(
    () => _flushing = null,
  );

  Future<void> _flush() async {
    final store = _store;
    if (store == null || _user == null) return;
    var received = 0;
    for (final entry in List.of(_entries)) {
      if (entry.refused || entry.userId != _user) continue;
      try {
        await send(entry);
      } on Object catch (e) {
        if (cannotReach(e)) break;
        await _quietly(() => store.setError(entry.id!, refusalCode(e)));
        continue;
      }
      received++;
      await _quietly(() => store.remove(entry.id!));
    }
    await _load();
    if (received > 0) sent.value += received;
  }

  /// A refused entry is tried again.
  Future<void> retry(PendingEntry entry) async {
    final store = _store;
    if (store == null) return;
    await _quietly(() => store.setError(entry.id!, null));
    await _load();
    await flush();
  }

  /// A refused or waiting entry is dropped: it will never be sent.
  Future<void> drop(PendingEntry entry) async {
    final store = _store;
    if (store == null) return;
    await _quietly(() => store.remove(entry.id!));
    await _load();
  }

  /// How many entries wait on this device, of any account (even signed
  /// out).
  Future<int> kept() async {
    final store = _store;
    if (store == null) return 0;
    try {
      return (await store.all()).length;
    } on Object {
      return 0;
    }
  }

  /// Forgets every entry of this device (sign-out chosen by the user).
  Future<void> clear() async {
    final store = _store;
    if (store != null) await _quietly(store.clear);
    _entries = const [];
    _stopTimer();
    notifyListeners();
  }

  Future<void> _load() async {
    final store = _store;
    final user = _user;
    if (store == null || user == null) return;
    try {
      _entries = [
        for (final e in await store.all())
          if (e.userId == user) e,
      ];
    } on Object catch (e) {
      debugPrint('Outbox not read: $e');
    }
    // While entries wait, the server is asked again from time to time.
    if (waiting > 0) {
      _timer ??= Timer.periodic(retryEvery, (_) => unawaited(flush()));
    } else {
      _stopTimer();
    }
    notifyListeners();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  static Future<void> _quietly(Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (e) {
      debugPrint('Outbox not updated: $e');
    }
  }

  @override
  void dispose() {
    offlineSince.removeListener(_answering);
    _stopTimer();
    sent.dispose();
    super.dispose();
  }
}

/// The outbox of this app.
final outbox = Outbox(
  send: (e) => client.transaction.create(
    e.accountId,
    e.date,
    e.amountCents,
    e.label,
    clientRef: e.clientRef,
  ),
);
