import '../local_date.dart';
import '../money.dart';
import 'decoding.dart';
import 'statement.dart';

const _transactionTypes = {'bank', 'cash', 'ccard', 'oth a', 'oth l'};

/// Reads a QIF file ("format Money" of French banks).
///
/// Only cash-like sections (`!Type:Bank`, `Cash`, `CCard`, `Oth A`, `Oth L`)
/// are read; other sections (categories, classes, investments) are skipped.
/// A record whose date or amount cannot be read is skipped with an error,
/// never guessed.
ParsedStatement parseQif(
  List<int> bytes, {
  DateOrder dateOrder = DateOrder.dayMonthYear,
}) {
  final decoded = decodeBankFile(bytes);
  final lines = decoded.text.split('\n');
  final transactions = <ParsedTransaction>[];
  final issues = <ImportIssue>[];

  var sawHeader = false;
  var inTransactions = false;
  _QifRecord? record;

  void flush(int line, {required bool terminated}) {
    final r = record;
    record = null;
    if (r == null || r.isEmpty) return;
    if (!terminated) {
      issues.add(ImportIssue(IssueSeverity.warning, 'qif_missing_end', line));
    }
    final t = r.build(issues, dateOrder);
    if (t != null) transactions.add(t);
  }

  for (var i = 0; i < lines.length; i++) {
    final lineNo = i + 1;
    final raw = lines[i];
    final line = raw.trimRight();
    if (line.trim().isEmpty) continue;

    if (line.startsWith('!')) {
      final header = line.substring(1).trim().toLowerCase();
      if (header.startsWith('type:')) {
        flush(lineNo, terminated: false);
        sawHeader = true;
        final type = header.substring(5).trim();
        inTransactions = _transactionTypes.contains(type);
        if (!inTransactions) {
          issues.add(
            ImportIssue(
              IssueSeverity.warning,
              'qif_section_skipped',
              lineNo,
              type,
            ),
          );
        }
      } else if (header == 'account') {
        flush(lineNo, terminated: false);
        sawHeader = true;
        inTransactions = false;
      }
      // !Option:… and !Clear:… lines carry no data.
      continue;
    }

    if (!sawHeader) {
      throw const StatementFormatException('qif_no_header');
    }

    if (line.trim() == '^') {
      if (inTransactions) {
        flush(lineNo, terminated: true);
      } else {
        record = null;
      }
      continue;
    }
    if (!inTransactions) continue;

    record ??= _QifRecord(lineNo);
    record!.add(line[0], line.substring(1).trim(), lineNo, issues);
  }
  flush(lines.length, terminated: false);

  if (!sawHeader) throw const StatementFormatException('qif_no_header');

  return ParsedStatement(
    format: StatementFormat.qif,
    transactions: transactions,
    issues: issues,
    encoding: decoded.encoding,
  );
}

class _QifRecord {
  final int startLine;
  String? date;
  String? amount;
  int? dateLine;
  int? amountLine;
  String? payee;
  final memo = <String>[];
  String? number;
  var hasT = false;
  var hasSplits = false;
  var isEmpty = true;

  _QifRecord(this.startLine);

  void add(String code, String value, int line, List<ImportIssue> issues) {
    isEmpty = false;
    switch (code) {
      case 'D':
        date = value;
        dateLine = line;
      case 'T':
        amount = value;
        amountLine = line;
        hasT = true;
      case 'U':
        // U usually repeats T; it is only used when T is absent.
        if (!hasT) {
          amount = value;
          amountLine = line;
        }
      case 'P':
        payee = value;
      case 'M':
        if (value.isNotEmpty) memo.add(value);
      case 'N':
        number = value;
      case 'S':
      case 'E':
      case r'$':
        if (!hasSplits) {
          hasSplits = true;
          issues.add(
            ImportIssue(IssueSeverity.warning, 'qif_split_ignored', line),
          );
        }
      default:
        // C (cleared), L (category), A (address)… are not used.
        break;
    }
  }

  ParsedTransaction? build(List<ImportIssue> issues, DateOrder order) {
    if (date == null) {
      issues.add(ImportIssue(IssueSeverity.error, 'missing_date', startLine));
      return null;
    }
    if (amount == null) {
      issues.add(ImportIssue(IssueSeverity.error, 'missing_amount', startLine));
      return null;
    }
    final LocalDate parsedDate;
    try {
      parsedDate = LocalDate.parse(date!, order: order);
    } on FormatException {
      issues.add(ImportIssue(IssueSeverity.error, 'invalid_date', dateLine!));
      return null;
    }
    final int cents;
    try {
      cents = parseAmountCents(amount!);
    } on AmountFormatException catch (e) {
      issues.add(
        ImportIssue(
          IssueSeverity.error,
          'invalid_amount',
          amountLine!,
          e.reason,
        ),
      );
      return null;
    }
    final memoText = memo.join(' ');
    var label = payee ?? '';
    if (label.isEmpty) label = memoText;
    if (label.isEmpty) {
      issues.add(
        ImportIssue(IssueSeverity.warning, 'missing_label', startLine),
      );
    }
    return ParsedTransaction(
      date: parsedDate,
      amountCents: cents,
      label: label,
      memo: memoText.isEmpty || memoText == label ? null : memoText,
      reference: (number?.isEmpty ?? true) ? null : number,
      line: startLine,
    );
  }
}
