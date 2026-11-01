import 'dart:typed_data';

Future<void> openOrSaveFile(
  String name,
  String mimeType,
  Uint8List bytes,
) async => throw UnsupportedError('Files can only be opened on the web.');
