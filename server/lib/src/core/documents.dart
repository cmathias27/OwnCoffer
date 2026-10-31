import 'dart:convert';
import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../generated/protocol.dart';

/// Files kept by the server (loan documents, invoices): name cleaning, size
/// limit and type check from the first bytes, so a renamed file is refused.
abstract final class Documents {
  static const maxBytes = 10 * 1024 * 1024;

  /// Accepted types, by extension.
  static const types = {
    'pdf': 'application/pdf',
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'webp': 'image/webp',
    'csv': 'text/csv',
    'txt': 'text/plain',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ods': 'application/vnd.oasis.opendocument.spreadsheet',
  };

  /// Checks [file] sent as [fileName]; returns the cleaned name and its MIME
  /// type. Only [allowed] extensions are accepted.
  static ({String name, String mime}) check(
    String fileName,
    ByteData file, {
    required Set<String> allowed,
  }) {
    final name = fileName.trim().replaceAll(RegExp(r'[\\/\x00-\x1f]'), '_');
    if (name.isEmpty || name.length > 120) {
      throw InvalidInputException(code: 'invalid_name', field: 'fileName');
    }
    final size = file.lengthInBytes;
    if (size == 0 || size > maxBytes) {
      throw InvalidInputException(code: 'document_too_large');
    }
    final ext = core.fileExtension(name);
    final mime = types[ext];
    final bytes = file.buffer.asUint8List(file.offsetInBytes, size);
    if (mime == null || !allowed.contains(ext) || !_looksLike(ext, bytes)) {
      throw InvalidInputException(code: 'document_type');
    }
    return (name: name, mime: mime);
  }

  /// Magic bytes of the binary formats; text files must be valid UTF-8.
  static bool _looksLike(String ext, Uint8List b) {
    bool starts(List<int> sig) =>
        b.length >= sig.length &&
        [for (var i = 0; i < sig.length; i++) b[i] == sig[i]].every((x) => x);
    return switch (ext) {
      'pdf' => starts([0x25, 0x50, 0x44, 0x46]),
      'png' => starts([0x89, 0x50, 0x4E, 0x47]),
      'jpg' || 'jpeg' => starts([0xFF, 0xD8, 0xFF]),
      'webp' =>
        starts([0x52, 0x49, 0x46, 0x46]) &&
            b.length > 12 &&
            String.fromCharCodes(b.sublist(8, 12)) == 'WEBP',
      'xlsx' || 'ods' => starts([0x50, 0x4B, 0x03, 0x04]),
      'csv' || 'txt' => () {
        try {
          utf8.decode(b);
          return true;
        } on FormatException {
          return false;
        }
      }(),
      _ => false,
    };
  }
}
