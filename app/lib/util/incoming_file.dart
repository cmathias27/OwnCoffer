import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'file_pick.dart';

/// Bank statement files received from outside the app (Android intent:
/// "Open with", download notification, or Share to OwnCoffer).
class IncomingFileHandler {
  static const MethodChannel channel = MethodChannel(
    'org.owncoffer.app/incoming_file',
  );

  static final StreamController<PickedFile> _controller =
      StreamController<PickedFile>.broadcast();

  /// Stream of files opened or shared to OwnCoffer.
  static Stream<PickedFile> get files => _controller.stream;

  static var _initialized = false;

  /// Starts listening to incoming files from native Android. Safe to call multiple times.
  static Future<void> init({MethodChannel? testChannel}) async {
    final c = testChannel ?? channel;
    if (_initialized && testChannel == null) return;
    _initialized = true;

    c.setMethodCallHandler((call) async {
      if (call.method == 'onFileReceived') {
        final args = call.arguments;
        if (args is Map) {
          final file = parseFile(args);
          if (file != null) _controller.add(file);
        }
      }
    });

    try {
      final initial = await c.invokeMethod<Map>('getInitialFile');
      if (initial != null) {
        final file = parseFile(initial);
        if (file != null) _controller.add(file);
      }
    } catch (_) {
      // Channel unavailable or not supported on this platform
    }
  }

  @visibleForTesting
  static void reset() {
    _initialized = false;
  }

  static PickedFile? parseFile(Map data) {
    final name = data['name'] as String?;
    final bytes = data['bytes'];
    if (name == null || bytes == null) return null;
    final Uint8List uint8 = bytes is Uint8List
        ? bytes
        : Uint8List.fromList((bytes as List).cast<int>());
    return PickedFile(name, uint8);
  }
}
