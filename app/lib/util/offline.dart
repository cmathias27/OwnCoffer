import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'offline/offline_stub.dart'
    if (dart.library.io) 'offline/offline_io.dart'
    as impl;

/// Offline reading of the Windows and Android apps connected to a server
/// (decision 0037): the last answer of each read below is kept on the
/// device, encrypted, and shown when the server cannot be reached. Writes
/// are never kept nor replayed: without the server they fail as before,
/// except new manual entries, kept in the outbox (`outbox.dart`).
///
/// The web app keeps no financial data (decision 0011), nor does the
/// standalone mode need it (its server is on the device).

/// Reads whose last answer may be shown again offline: pure reads, never a
/// method that changes data (its success would be a lie).
const offlineReads = {
  'setup.status',
  'twoFactor.status',
  'group.myGroups',
  'group.members',
  'account.list',
  'account.balanceChecks',
  'category.list',
  'rule.list',
  'goal.list',
  'transaction.list',
  'transaction.splits',
  'analysis.report',
  'analysis.operations',
  'analysis.leftToLive',
  'analysis.summary',
  'analysis.insights',
  'scheduled.list',
  'scheduled.subscriptions',
  'scheduled.calendar',
  'scheduled.forecast',
  'invoice.list',
  'invoice.forTransaction',
  'loan.overview',
  'loan.schedule',
  'loan.operations',
  'notification.list',
  'notification.unreadCount',
  'pepite.status',
  'ai.status',
  'advisor.proposals',
  'admin.isServerAdmin',
};

/// How long a kept answer may still be shown.
const offlineKeep = Duration(days: 30);

/// When the oldest answer on screen was received, while the server cannot
/// be reached; null when it answers.
final offlineSince = ValueNotifier<DateTime?>(null);

/// Where kept answers live. One per device and server.
abstract class OfflineStore {
  Future<({String body, DateTime savedAt})?> read(String key);
  Future<void> write(String key, String body, DateTime savedAt);

  /// Forgets everything (sign-out, another server).
  Future<void> clear();
}

/// The store of this device, or null on the web.
Future<OfflineStore?> openOfflineStore() => impl.openOfflineStore();

/// Forgets every kept answer of this device; with [outbox], also the
/// entries not sent yet (another server).
Future<void> clearOfflineStore({bool outbox = false}) async {
  offlineSince.value = null;
  await impl.clearOfflineStore(outbox: outbox);
}

/// Whether [error] means the server could not be reached at all (no
/// network, refused, timed out), as opposed to an answer.
bool isUnreachable(Object error) => impl.isUnreachable(error);

/// Status codes of a proxy whose server is down (Caddy, Cloudflare).
bool gatewayDown(int status) =>
    status == 502 ||
    status == 503 ||
    status == 504 ||
    (status >= 520 && status <= 530);

/// An HTTP client for the Serverpod client: each answer to an
/// [offlineReads] call is kept; when the server cannot be reached, the kept
/// answer is returned instead, and [offlineSince] says from when.
class OfflineHttpClient extends http.BaseClient {
  final http.Client inner;
  final OfflineStore store;
  final Duration readTimeout;
  final DateTime Function() now;

  OfflineHttpClient(
    this.inner,
    this.store, {
    this.readTimeout = const Duration(seconds: 10),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  /// `endpoint.method` of a Serverpod call, from its URL.
  static String? _call(Uri url) {
    final s = url.pathSegments.where((p) => p.isNotEmpty).toList();
    return s.length < 2 ? null : '${s[s.length - 2]}.${s.last}';
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final call = _call(request.url);
    if (request is! http.Request ||
        request.method != 'POST' ||
        !offlineReads.contains(call)) {
      final response = await inner.send(request);
      if (!gatewayDown(response.statusCode)) offlineSince.value = null;
      return response;
    }
    // The arguments are part of the key: one answer per account, month…
    final key = '${request.url}\n${request.body}';
    final http.StreamedResponse response;
    try {
      response = await inner.send(request).timeout(readTimeout);
    } on Object catch (e) {
      if (!isUnreachable(e) && e is! TimeoutException) rethrow;
      return await _kept(key, request) ?? (throw e);
    }
    if (gatewayDown(response.statusCode)) {
      final kept = await _kept(key, request);
      if (kept != null) {
        await response.stream.drain<void>();
        return kept;
      }
      return response;
    }
    if (response.statusCode != 200) {
      offlineSince.value = null;
      return response;
    }
    final bytes = await response.stream.toBytes();
    offlineSince.value = null;
    try {
      await store.write(key, utf8.decode(bytes), now());
    } on Object catch (e) {
      // Keeping a copy must never break the page itself.
      debugPrint('Offline copy not kept: $e');
    }
    return http.StreamedResponse(
      Stream.value(bytes),
      200,
      contentLength: bytes.length,
      request: request,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
    );
  }

  Future<http.StreamedResponse?> _kept(String key, http.Request request) async {
    final ({String body, DateTime savedAt})? kept;
    try {
      kept = await store.read(key);
    } on Object {
      return null;
    }
    if (kept == null || now().difference(kept.savedAt) > offlineKeep) {
      return null;
    }
    final since = offlineSince.value;
    if (since == null || kept.savedAt.isBefore(since)) {
      offlineSince.value = kept.savedAt;
    }
    final bytes = utf8.encode(kept.body);
    return http.StreamedResponse(
      Stream.value(bytes),
      200,
      contentLength: bytes.length,
      request: request,
      headers: const {'content-type': 'application/json; charset=utf-8'},
    );
  }

  @override
  void close() => inner.close();
}
