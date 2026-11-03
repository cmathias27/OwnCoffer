import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/text_reader.dart';
import 'package:owncoffer_app/util/text_reader/text_reader_io.dart';

void main() {
  test('local reader is unavailable off Android', () async {
    final reader = TextReader.local();
    expect(reader.isAvailable, isFalse);
    expect(await reader.read(Uint8List.fromList([1, 2, 3])), isNull);
  });

  test('Android engine lines become a reading, junk is ignored', () {
    final reading = textReadingFromChannel([
      {'text': ' CARREFOUR ', 'confidence': 0.91},
      {'text': '   ', 'confidence': 0.2},
      'not a map',
      {'text': 'TOTAL 5,49', 'confidence': 1.4},
      {'text': 'TVA', 'confidence': 'n/a'},
      {'confidence': 0.5},
    ])!;
    expect(reading.lines.map((line) => line.text), [
      'CARREFOUR',
      'TOTAL 5,49',
      'TVA',
    ]);
    expect(reading.lines.map((line) => line.confidence), [0.91, 1.0, null]);
    expect(textReadingFromChannel(null), isNull);
    expect(textReadingFromChannel([]), isNull);
    expect(
      textReadingFromChannel([
        {'text': ' '},
      ]),
      isNull,
    );
  });

  test('TextReading joins lines and detects emptiness', () {
    const reading = TextReading([TextLine('TOTAL'), TextLine('5,49')]);
    expect(reading.text, 'TOTAL\n5,49');
    expect(reading.isEmpty, isFalse);
    expect(const TextReading([TextLine('  ')]).isEmpty, isTrue);
  });
}
