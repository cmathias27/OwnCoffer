import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../text_reader.dart';

/// Local Tesseract engine, Android only (decision 0023). The French and
/// English models are bundled in the app (`assets/tessdata/`) and copied once
/// to the app's private folder: nothing is downloaded and the image never
/// leaves the device. Other platforms keep the manual flow.
class _TesseractTextReader implements TextReader {
  _TesseractTextReader();

  static const _channel = MethodChannel('org.owncoffer.app/text_reader');
  static const _models = ['fra', 'eng'];

  Future<String>? _dataPath;

  @override
  bool get isAvailable => true;

  @override
  Future<TextReading?> read(Uint8List imageBytes) async {
    try {
      final dataPath = await (_dataPath ??= _installModels());
      final lines = await _channel.invokeMethod<List<Object?>>('read', {
        'image': imageBytes,
        'dataPath': dataPath,
        'languages': _models.join('+'),
      });
      return textReadingFromChannel(lines);
    } on Object {
      // Any engine failure means "no reading": the user types as before.
      _dataPath = null;
      return null;
    }
  }

  /// Copies the bundled models to `<support>/ocr/tessdata/`, the layout
  /// Tesseract expects, and returns `<support>/ocr`. A file of the wrong size
  /// (interrupted copy, model updated with the app) is written again.
  static Future<String> _installModels() async {
    final support = await getApplicationSupportDirectory();
    final root = '${support.path}/ocr';
    final dir = Directory('$root/tessdata');
    await dir.create(recursive: true);
    for (final model in _models) {
      final data = await rootBundle.load('assets/tessdata/$model.traineddata');
      final target = File('${dir.path}/$model.traineddata');
      if (await target.exists() &&
          await target.length() == data.lengthInBytes) {
        continue;
      }
      final partial = File('${target.path}.part');
      await partial.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
      await partial.rename(target.path);
    }
    return root;
  }
}

/// Turns the lines sent by the Android engine (`{text, confidence}` maps)
/// into a [TextReading]; anything unexpected or empty gives null.
@visibleForTesting
TextReading? textReadingFromChannel(List<Object?>? raw) {
  if (raw == null) return null;
  final lines = <TextLine>[];
  for (final item in raw) {
    if (item is! Map) continue;
    final text = item['text'];
    if (text is! String || text.trim().isEmpty) continue;
    final confidence = item['confidence'];
    lines.add(
      TextLine(
        text.trim(),
        confidence: confidence is num
            ? confidence.toDouble().clamp(0.0, 1.0)
            : null,
      ),
    );
  }
  final reading = TextReading(lines);
  return reading.isEmpty ? null : reading;
}

class _NoTextReader implements TextReader {
  const _NoTextReader();

  @override
  bool get isAvailable => false;

  @override
  Future<TextReading?> read(Uint8List imageBytes) async => null;
}

TextReader? _android;

TextReader createTextReader() => Platform.isAndroid
    ? _android ??= _TesseractTextReader()
    : const _NoTextReader();
