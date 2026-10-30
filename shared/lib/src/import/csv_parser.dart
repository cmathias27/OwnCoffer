import '../local_date.dart';
import '../money.dart';
import '../text.dart';
import 'decoding.dart';
import 'statement.dart';

/// Which columns hold what. Indexes are 0-based.
class CsvMapping {
  final String delimiter;

  /// 0-based index of the header row in the file; data starts after it.
  /// `-1` when the file has no header row.
  final int headerRow;
  final int dateColumn;
  final int labelColumn;
  final int? memoColumn;
  final int? referenceColumn;

  /// Either [amountColumn] (signed), or [debitColumn] and/or [creditColumn].
  final int? amountColumn;
  final int? debitColumn;
  final int? creditColumn;
  final DateOrder dateOrder;

  const CsvMapping({
    required this.delimiter,
    required this.headerRow,
    required this.dateColumn,
    required this.labelColumn,
    this.memoColumn,
    this.referenceColumn,
    this.amountColumn,
    this.debitColumn,
    this.creditColumn,
    this.dateOrder = DateOrder.dayMonthYear,
  }) : assert(
         amountColumn != null || debitColumn != null || creditColumn != null,
       );
}

// Header names, normalised, in order of preference.
const _dateHeaders = [
  'DATE DE COMPTABILISATION',
  'DATE COMPTABLE',
  'DATE OPERATION',
  'DATE D OPERATION',
  'DATE',
];
const _labelHeaders = [
  'LIBELLE OPERATION',
  'LIBELLE DE L OPERATION',
  'LIBELLE',
  'LIBELLE SIMPLIFIE',
  'DESCRIPTION',
];
const _memoHeaders = [
  'INFORMATIONS COMPLEMENTAIRES',
  'DETAIL',
  'DETAILS',
  'COMPLEMENT',
];
const _referenceHeaders = [
  'REFERENCE',
  'NUMERO D OPERATION',
  'NUMERO OPERATION',
];
const _amountHeaders = ['MONTANT', 'MONTANT EUROS', 'MONTANT EUR', 'AMOUNT'];
const _debitHeaders = ['DEBIT', 'DEBIT EUROS', 'DEBIT EUR'];
const _creditHeaders = ['CREDIT', 'CREDIT EUROS', 'CREDIT EUR'];

/// Splits CSV text into rows (RFC 4180 quoting, quotes may span lines).
List<List<String>> splitCsv(String text, String delimiter) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var inQuotes = false;
  var i = 0;
  while (i < text.length) {
    final c = text[i];
    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          field.write('"');
          i += 2;
          continue;
        }
        inQuotes = false;
      } else {
        field.write(c);
      }
    } else if (c == '"' && field.isEmpty) {
      inQuotes = true;
    } else if (c == delimiter) {
      row.add(field.toString());
      field.clear();
    } else if (c == '\n') {
      row.add(field.toString());
      field.clear();
      rows.add(row);
      row = <String>[];
    } else {
      field.write(c);
    }
    i++;
  }
  if (field.isNotEmpty || row.isNotEmpty) {
    row.add(field.toString());
    rows.add(row);
  }
  return rows;
}

/// Guesses the delimiter from the first lines: `;`, `,` or tab.
String detectDelimiter(String text) {
  final sample = text.split('\n').take(40).join('\n');
  var best = ';';
  var bestCount = 0;
  for (final d in const [';', '\t', ',']) {
    final count = d.allMatches(sample).length;
    if (count > bestCount) {
      best = d;
      bestCount = count;
    }
  }
  return best;
}

int? _find(List<String> headers, List<String> candidates) {
  for (final candidate in candidates) {
    final i = headers.indexOf(candidate);
    if (i >= 0) return i;
  }
  return null;
}

/// Finds the header row and the columns from their names. Returns `null` when
/// the columns cannot be recognised: the app then asks the user to choose.
CsvMapping? detectCsvMapping(String text) {
  final delimiter = detectDelimiter(text);
  final rows = splitCsv(text, delimiter);
  for (var r = 0; r < rows.length && r < 40; r++) {
    final headers = rows[r].map(normalizeForMatch).toList();
    final date = _find(headers, _dateHeaders);
    final label = _find(headers, _labelHeaders);
    if (date == null || label == null) continue;
    final amount = _find(headers, _amountHeaders);
    final debit = _find(headers, _debitHeaders);
    final credit = _find(headers, _creditHeaders);
    if (amount == null && debit == null && credit == null) continue;
    return CsvMapping(
      delimiter: delimiter,
      headerRow: r,
      dateColumn: date,
      labelColumn: label,
      memoColumn: _find(headers, _memoHeaders),
      referenceColumn: _find(headers, _referenceHeaders),
      amountColumn: (debit != null || credit != null) ? null : amount,
      debitColumn: debit,
      creditColumn: credit,
    );
  }
  return null;
}

/// Reads a CSV bank export. Columns are detected from the header row unless
/// [mapping] is given (columns chosen by the user).
ParsedStatement parseCsv(List<int> bytes, {CsvMapping? mapping}) {
  final decoded = decodeBankFile(bytes);
  final map = mapping ?? detectCsvMapping(decoded.text);
  if (map == null) throw const StatementFormatException('csv_columns_unknown');

  final rows = splitCsv(decoded.text, map.delimiter);
  final transactions = <ParsedTransaction>[];
  final issues = <ImportIssue>[];

  String? cell(List<String> row, int? column) {
    if (column == null || column >= row.length) return null;
    final v = row[column].trim();
    return v.isEmpty ? null : v;
  }

  for (var r = map.headerRow + 1; r < rows.length; r++) {
    final row = rows[r];
    final line = r + 1;
    if (row.every((c) => c.trim().isEmpty)) continue;

    final rawDate = cell(row, map.dateColumn);
    if (rawDate == null) {
      issues.add(ImportIssue(IssueSeverity.error, 'missing_date', line));
      continue;
    }
    final date = LocalDate.tryParse(rawDate, order: map.dateOrder);
    if (date == null) {
      // Footer lines ("Solde au …") are reported, not guessed.
      issues.add(ImportIssue(IssueSeverity.error, 'invalid_date', line));
      continue;
    }

    final int cents;
    try {
      if (map.amountColumn != null) {
        final raw = cell(row, map.amountColumn);
        if (raw == null) {
          issues.add(ImportIssue(IssueSeverity.error, 'missing_amount', line));
          continue;
        }
        cents = parseAmountCents(raw);
      } else {
        final rawDebit = cell(row, map.debitColumn);
        final rawCredit = cell(row, map.creditColumn);
        final debit = rawDebit == null ? 0 : parseAmountCents(rawDebit).abs();
        final credit = rawCredit == null
            ? 0
            : parseAmountCents(rawCredit).abs();
        if (debit != 0 && credit != 0) {
          issues.add(
            ImportIssue(IssueSeverity.error, 'debit_and_credit', line),
          );
          continue;
        }
        if (rawDebit == null && rawCredit == null) {
          issues.add(ImportIssue(IssueSeverity.error, 'missing_amount', line));
          continue;
        }
        cents = credit - debit;
      }
    } on AmountFormatException catch (e) {
      issues.add(
        ImportIssue(IssueSeverity.error, 'invalid_amount', line, e.reason),
      );
      continue;
    }

    final label = cell(row, map.labelColumn) ?? '';
    final memo = cell(row, map.memoColumn);
    if (label.isEmpty && memo == null) {
      issues.add(ImportIssue(IssueSeverity.warning, 'missing_label', line));
    }
    transactions.add(
      ParsedTransaction(
        date: date,
        amountCents: cents,
        label: label.isEmpty ? (memo ?? '') : label,
        memo: label.isEmpty ? null : memo,
        reference: cell(row, map.referenceColumn),
        line: line,
      ),
    );
  }

  return ParsedStatement(
    format: StatementFormat.csv,
    transactions: transactions,
    issues: issues,
    encoding: decoded.encoding,
  );
}
