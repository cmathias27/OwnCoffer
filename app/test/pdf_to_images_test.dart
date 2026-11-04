import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/pdf_to_images.dart';

void main() {
  test('empty bytes throws empty exception', () async {
    expect(
      () => PdfToImages.convert(Uint8List(0)),
      throwsA(
        isA<PdfConversionException>().having((e) => e.code, 'code', 'empty'),
      ),
    );
  });

  test('oversized bytes throws too_large exception', () async {
    expect(
      () => PdfToImages.convert(Uint8List(PdfToImages.maxBytes + 1)),
      throwsA(
        isA<PdfConversionException>().having(
          (e) => e.code,
          'code',
          'too_large',
        ),
      ),
    );
  });
}
