import 'dart:typed_data';

import 'text_reader/text_reader_stub.dart'
    if (dart.library.js_interop) 'text_reader/text_reader_web.dart'
    if (dart.library.io) 'text_reader/text_reader_io.dart'
    as impl;

/// One line returned by an on-device text recognition engine.
class TextLine {
  final String text;

  /// Recognition confidence, when the platform provides it (0 to 1).
  final double? confidence;

  const TextLine(this.text, {this.confidence});
}

/// Result of OCR. Lines stay in reading order; no network or persistence is
/// involved. The shared package turns these lines into receipt proposals.
class TextReading {
  final List<TextLine> lines;

  const TextReading(this.lines);

  String get text => lines.map((line) => line.text).join('\n');

  bool get isEmpty => lines.every((line) => line.text.trim().isEmpty);
}

/// Local OCR facade. Platform engines are deliberately optional: when a
/// platform has no configured engine, [read] returns null and callers keep
/// the existing manual invoice flow.
abstract interface class TextReader {
  /// Whether this build has a usable local engine.
  bool get isAvailable;

  /// Reads [imageBytes] locally. Returns null when OCR is unavailable or no
  /// text could be recognised. Never sends bytes to a server.
  Future<TextReading?> read(Uint8List imageBytes);

  factory TextReader.local() => impl.createTextReader();
}
