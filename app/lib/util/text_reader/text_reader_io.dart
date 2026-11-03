import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:path_provider/path_provider.dart';

import '../text_reader.dart';

/// Local Tesseract engine, Android only (decision 0023). Models are bundled
/// in the app (`assets/tessdata/`): nothing is downloaded and the image never
/// leaves the device. Other platforms keep the manual flow.
class _TesseractTextReader implements TextReader {
  const _TesseractTextReader();

  static const _languages = 'fra+eng';

  @override
  bool get isAvailable => true;

  @override
  Future<TextReading?> read(Uint8List imageBytes) async {
    File? file;
    try {
      final dir = await getTemporaryDirectory();
      file = File(
        '${dir.path}/ocr-${DateTime.now().microsecondsSinceEpoch}.img',
      );
      await file.writeAsBytes(imageBytes, flush: true);
      final text = await FlutterTesseractOcr.extractText(
        file.path,
        language: _languages,
      );
      final lines = [
        for (final line in text.split('\n'))
          if (line.trim().isNotEmpty) TextLine(line.trim()),
      ];
      return lines.isEmpty ? null : TextReading(lines);
    } on Object {
      // Any engine failure means "no reading": the user types as before.
      return null;
    } finally {
      try {
        await file?.delete();
      } on Object {
        // Temporary file: the system cleans it up anyway.
      }
    }
  }
}

class _NoTextReader implements TextReader {
  const _NoTextReader();

  @override
  bool get isAvailable => false;

  @override
  Future<TextReading?> read(Uint8List imageBytes) async => null;
}

TextReader createTextReader() =>
    Platform.isAndroid ? const _TesseractTextReader() : const _NoTextReader();
