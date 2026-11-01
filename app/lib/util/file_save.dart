import 'dart:typed_data';

import 'file_save/file_save_stub.dart'
    if (dart.library.js_interop) 'file_save/file_save_web.dart'
    if (dart.library.io) 'file_save/file_save_io.dart'
    as impl;

/// Opens a file received from the server in a new tab (PDF, images) or
/// saves it (other types). Windows: "Save as"; Android: the share sheet.
/// Nothing is sent anywhere unless the user picks a destination.
Future<void> openOrSaveFile(String name, String mimeType, Uint8List bytes) =>
    impl.openOrSaveFile(name, mimeType, bytes);
