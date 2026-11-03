import 'dart:typed_data';

import '../text_reader.dart';

/// No local engine: callers fall back to the manual flow.
class _NoTextReader implements TextReader {
  const _NoTextReader();

  @override
  bool get isAvailable => false;

  @override
  Future<TextReading?> read(Uint8List imageBytes) async => null;
}

TextReader createTextReader() => const _NoTextReader();
