import 'dart:typed_data';

import 'package:pdfx/pdfx.dart';

import 'file_pick.dart';

/// Renders PDF pages locally. The returned temporary image bytes are only
/// passed to the AI reader after the user confirms the transfer.
abstract final class PdfToImages {
  static const maxBytes = 8 * 1024 * 1024;
  static const maxPages = 5;
  static const maxPageSide = 1600.0;
  static const maxTotalImageBytes = 12 * 1024 * 1024;

  static Future<List<PickedFile>> convert(Uint8List bytes) async {
    if (bytes.isEmpty) {
      throw const PdfConversionException('empty');
    }
    if (bytes.length > maxBytes) {
      throw const PdfConversionException('too_large');
    }
    PdfDocument? document;
    try {
      document = await PdfDocument.openData(bytes);
      if (document.pagesCount == 0) {
        throw const PdfConversionException('empty');
      }
      if (document.pagesCount > maxPages) {
        throw const PdfConversionException('too_many_pages');
      }
      final pages = <PickedFile>[];
      var totalBytes = 0;
      for (var number = 1; number <= document.pagesCount; number++) {
        final page = await document.getPage(number, autoCloseAndroid: true);
        try {
          final longestSide = page.width > page.height
              ? page.width
              : page.height;
          final scale = maxPageSide / longestSide;
          final image = await page.render(
            width: (page.width * scale).clamp(1, maxPageSide).toDouble(),
            height: (page.height * scale).clamp(1, maxPageSide).toDouble(),
            format: PdfPageImageFormat.jpeg,
            backgroundColor: '#FFFFFF',
            quality: 82,
          );
          if (image == null || image.bytes.isEmpty) {
            throw const PdfConversionException('render_failed');
          }
          totalBytes += image.bytes.length;
          if (totalBytes > maxTotalImageBytes) {
            throw const PdfConversionException('too_large');
          }
          pages.add(PickedFile('page_$number.jpg', image.bytes));
        } finally {
          await page.close();
        }
      }
      return pages;
    } on PdfConversionException {
      rethrow;
    } on Object {
      throw const PdfConversionException('invalid_or_encrypted');
    } finally {
      await document?.close();
    }
  }
}

class PdfConversionException implements Exception {
  final String code;
  const PdfConversionException(this.code);
}
