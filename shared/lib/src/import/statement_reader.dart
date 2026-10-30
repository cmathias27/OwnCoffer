import '../local_date.dart';
import 'csv_parser.dart';
import 'decoding.dart';
import 'ofx_parser.dart';
import 'qif_parser.dart';
import 'statement.dart';

/// Guesses the format from the content (not the file name).
StatementFormat? detectStatementFormat(List<int> bytes) {
  final head = decodeBankFile(
    bytes.length > 4096 ? bytes.sublist(0, 4096) : bytes,
  ).text.trimLeft();
  final upper = head.toUpperCase();
  if (upper.startsWith('!TYPE:') ||
      upper.startsWith('!ACCOUNT') ||
      upper.startsWith('!OPTION:')) {
    return StatementFormat.qif;
  }
  if (upper.startsWith('OFXHEADER') ||
      upper.contains('<OFX>') ||
      (upper.startsWith('<?XML') && upper.contains('OFX'))) {
    return StatementFormat.ofx;
  }
  if (detectCsvMapping(head) != null) return StatementFormat.csv;
  return null;
}

/// Reads a bank file of any supported format.
ParsedStatement readStatement(
  List<int> bytes, {
  StatementFormat? format,
  CsvMapping? csvMapping,
  DateOrder qifDateOrder = DateOrder.dayMonthYear,
}) {
  if (bytes.isEmpty) throw const StatementFormatException('empty_file');
  final f =
      format ??
      (csvMapping != null ? StatementFormat.csv : null) ??
      detectStatementFormat(bytes);
  return switch (f) {
    StatementFormat.qif => parseQif(bytes, dateOrder: qifDateOrder),
    StatementFormat.ofx => parseOfx(bytes),
    StatementFormat.csv => parseCsv(bytes, mapping: csvMapping),
    null => throw const StatementFormatException('unknown_format'),
  };
}
