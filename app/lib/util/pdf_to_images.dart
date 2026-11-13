import 'dart:typed_data';

import 'package:pdfx/pdfx.dart';

import 'file_pick.dart';

/// Renders PDF pages locally. The returned temporary image bytes are only
/// passed to the AI reader after the user confirms the transfer.
abstract final class PdfToImages {
  static const maxBytes = 8 * 1024 * 1024;
  static const maxPages = 12;
  static const maxPageSide = 1600.0;
  static const maxTotalImageBytes = 12 * 1024 * 1024;

  static Future<List<PickedFile>> convert(Uint8List bytes) async {
    if (bytes.isEmpty) {
      throw const PdfConversionException('empty');
    }
    if (bytes.length > maxBytes) {
      throw const PdfConversionException('too_large');
    }
    if (!await hasPdfSupport()) {
      throw const PdfConversionException('render_failed');
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
          final scale = longestSide > maxPageSide
              ? maxPageSide / longestSide
              : 1.0;
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
          final ext = _isPng(image.bytes) ? 'png' : 'jpg';
          pages.add(PickedFile('page_$number.$ext', image.bytes));
        } finally {
          await page.close();
        }
      }
      return pages;
    } on PdfConversionException {
      rethrow;
    } on StateError {
      throw const PdfConversionException('render_failed');
    } on Object {
      throw const PdfConversionException('invalid_or_encrypted');
    } finally {
      await document?.close();
    }
  }

  static bool _isPng(List<int> bytes) =>
      bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47;
}

class PdfConversionException implements Exception {
  final String code;
  const PdfConversionException(this.code);
}
