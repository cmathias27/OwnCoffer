import 'dart:convert';

/// Result of decoding a bank file.
class DecodedText {
  final String text;

  /// `utf-8` or `windows-1252`.
  final String encoding;

  const DecodedText(this.text, this.encoding);
}

/// Windows-1252 characters for bytes 0x80–0x9F (others match ISO-8859-1).
const List<int> _cp1252High = [
  0x20AC, 0x0081, 0x201A, 0x0192, 0x201E, 0x2026, 0x2020, 0x2021, //
  0x02C6, 0x2030, 0x0160, 0x2039, 0x0152, 0x008D, 0x017D, 0x008F,
  0x0090, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2013, 0x2014,
  0x02DC, 0x2122, 0x0161, 0x203A, 0x0153, 0x009D, 0x017E, 0x0178,
];

/// Decodes bank file bytes: UTF-8 (with or without BOM) when the bytes are
/// valid UTF-8, Windows-1252 otherwise (French bank exports often are).
///
/// Line endings are normalised to `\n`.
DecodedText decodeBankFile(List<int> bytes) {
  var start = 0;
  if (bytes.length >= 3 &&
      bytes[0] == 0xEF &&
      bytes[1] == 0xBB &&
      bytes[2] == 0xBF) {
    start = 3;
  }
  final body = start == 0 ? bytes : bytes.sublist(start);
  String text;
  String encoding;
  try {
    text = const Utf8Decoder(allowMalformed: false).convert(body);
    encoding = 'utf-8';
  } on FormatException {
    text = decodeWindows1252(body);
    encoding = 'windows-1252';
  }
  text = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  return DecodedText(text, encoding);
}

String decodeWindows1252(List<int> bytes) {
  final codes = List<int>.filled(bytes.length, 0);
  for (var i = 0; i < bytes.length; i++) {
    final b = bytes[i];
    codes[i] = (b >= 0x80 && b <= 0x9F) ? _cp1252High[b - 0x80] : b;
  }
  return String.fromCharCodes(codes);
}

/// Encodes text back to Windows-1252. Characters it cannot represent are
/// replaced by `?`.
List<int> encodeWindows1252(String text) {
  final reverse = <int, int>{
    for (var i = 0; i < _cp1252High.length; i++) _cp1252High[i]: 0x80 + i,
  };
  return [
    for (final rune in text.runes)
      if (rune < 0x80 || (rune >= 0xA0 && rune <= 0xFF))
        rune
      else
        reverse[rune] ?? 0x3F,
  ];
}
