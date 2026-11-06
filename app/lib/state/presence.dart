import 'dart:async';

import 'package:flutter/widgets.dart';

import '../client.dart';
import '../util/app_versions.dart';

/// Tells the server on what this session runs (decision 0027): once signed
/// in, and each time the app comes back to the foreground. Nothing in the
/// standalone mode (one device, no session list).
final presence = Presence(
  ping: (platform, version) => client.presence.ping(platform, version),
  version: AppVersions.app,
  standalone: () => isStandalone,
);

class Presence with WidgetsBindingObserver {
  /// A ping at most this often (the server writes at most once an hour
  /// anyway unless something changed).
  static const minInterval = Duration(minutes: 5);

  final Future<void> Function(String platform, String? version) _ping;
  final Future<String> Function() _version;
  final bool Function() _standalone;
  final DateTime Function() _now;

  Presence({
    required this._ping,
    required this._version,
    required this._standalone,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  bool _attached = false;
  DateTime? _last;

  /// Signed in: ping now and on every return to the foreground.
  Future<void> attach() async {
    if (_standalone()) return;
    if (!_attached) {
      _attached = true;
      WidgetsBinding.instance.addObserver(this);
    }
    await send(force: true);
  }

  /// Signed out.
  void detach() {
    if (!_attached) return;
    _attached = false;
    _last = null;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(send());
  }

  /// Never fails: a lost ping only delays the session's details.
  Future<void> send({bool force = false}) async {
    if (_standalone()) return;
    final now = _now();
    final last = _last;
    if (!force && last != null && now.difference(last) < minInterval) return;
    _last = now;
    String? version;
    try {
      version = await _version();
    } on Object {
      version = null;
    }
    try {
      await _ping(AppVersions.platform, version);
    } on Object {
      _last = null;
    }
  }
}
