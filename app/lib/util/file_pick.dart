import 'package:flutter/foundation.dart';

import 'file_pick/file_pick_stub.dart'
    if (dart.library.js_interop) 'file_pick/file_pick_web.dart'
    if (dart.library.io) 'file_pick/file_pick_io.dart'
    as impl;

/// A file chosen by the user, read in memory. Nothing is sent anywhere.
class PickedFile {
  final String name;
  final Uint8List bytes;
  const PickedFile(this.name, this.bytes);
}

/// Whether [pickFile] can open a camera: phones (browser or Android app);
/// not the Windows app.
bool get canUseCamera => debugCanUseCamera ?? impl.canUseCamera;

/// For tests: a device with or without a camera.
@visibleForTesting
bool? debugCanUseCamera;

/// Opens the file dialog (browser, Windows or Android). Returns null when the user cancels.
/// [camera]: on a phone, opens the back camera to take a photo (the
/// browser's `capture`, the camera app on Android; a file dialog elsewhere).
Future<PickedFile?> pickFile({
  List<String> extensions = const [],
  bool camera = false,
}) => impl.pickFile(extensions, camera: camera);

/// Opens the file dialog for several files at once. Empty when cancelled.
Future<List<PickedFile>> pickFiles({List<String> extensions = const []}) =>
    impl.pickFiles(extensions);
