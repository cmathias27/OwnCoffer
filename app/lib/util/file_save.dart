import 'dart:typed_data';

import 'file_save/file_save_stub.dart'
    if (dart.library.js_interop) 'file_save/file_save_web.dart'
    as impl;

/// Opens a file received from the server in a new tab (PDF, images) or
/// saves it (other types). Nothing is sent anywhere.
void openOrSaveFile(String name, String mimeType, Uint8List bytes) =>
    impl.openOrSaveFile(name, mimeType, bytes);
