import 'dart:typed_data';

import 'file_pick/file_pick_stub.dart'
    if (dart.library.js_interop) 'file_pick/file_pick_web.dart'
    as impl;

/// A file chosen by the user, read in memory. Nothing is sent anywhere.
class PickedFile {
  final String name;
  final Uint8List bytes;
  const PickedFile(this.name, this.bytes);
}

/// Opens the browser's file dialog. Returns null when the user cancels.
Future<PickedFile?> pickFile({List<String> extensions = const []}) =>
    impl.pickFile(extensions);
