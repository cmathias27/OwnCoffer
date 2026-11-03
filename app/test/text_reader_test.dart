import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/text_reader.dart';

void main() {
  test('local reader is unavailable until an engine is configured', () async {
    final reader = TextReader.local();
    expect(reader.isAvailable, isFalse);
    expect(await reader.read(Uint8List.fromList([1, 2, 3])), isNull);
  });

  test('TextReading joins lines and detects emptiness', () {
    const reading = TextReading([TextLine('TOTAL'), TextLine('5,49')]);
    expect(reading.text, 'TOTAL\n5,49');
    expect(reading.isEmpty, isFalse);
    expect(const TextReading([TextLine('  ')]).isEmpty, isTrue);
  });
}
