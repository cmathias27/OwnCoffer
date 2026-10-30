import '../local_date.dart';
import '../money.dart';
import 'decoding.dart';
import 'statement.dart';

final RegExp _trnBlock = RegExp(
  r'<STMTTRN>(.*?)(?=</STMTTRN>|<STMTTRN>|</BANKTRANLIST>)',
  dotAll: true,
  caseSensitive: false,
);

/// Reads an OFX file, version 1 (SGML, unclosed tags) or 2 (XML).
///
/// Only the first bank or card statement is read. Transactions whose date or
/// amount cannot be read are skipped with an error.
ParsedStatement parseOfx(List<int> bytes) {
  final decoded = decodeBankFile(bytes);
  final text = decoded.text;
  final upper = text.toUpperCase();
  if (!upper.contains('<OFX>')) {
    throw const StatementFormatException('ofx_no_root');
  }

  final transactions = <ParsedTransaction>[];
  final issues = <ImportIssue>[];
  final lineStarts = _lineStarts(text);

  for (final match in _trnBlock.allMatches(text)) {
    final block = match.group(1)!;
    final line = _lineOf(lineStarts, match.start);
    final rawDate = _tag(block, 'DTPOSTED');
    final rawAmount = _tag(block, 'TRNAMT');
    if (rawDate == null) {
      issues.add(ImportIssue(IssueSeverity.error, 'missing_date', line));
      continue;
    }
    if (rawAmount == null) {
      issues.add(ImportIssue(IssueSeverity.error, 'missing_amount', line));
      continue;
    }
    final LocalDate date;
    try {
      date = LocalDate.parse(rawDate);
    } on FormatException {
      issues.add(ImportIssue(IssueSeverity.error, 'invalid_date', line));
      continue;
    }
    final int cents;
    try {
      cents = parseDecimalCents(rawAmount);
    } on AmountFormatException catch (e) {
      issues.add(
        ImportIssue(IssueSeverity.error, 'invalid_amount', line, e.reason),
      );
      continue;
    }
    final name = _tag(block, 'NAME') ?? _tag(block, 'PAYEE') ?? '';
    final memo = _tag(block, 'MEMO');
    final label = name.isNotEmpty ? name : (memo ?? '');
    if (label.isEmpty) {
      issues.add(ImportIssue(IssueSeverity.warning, 'missing_label', line));
    }
    transactions.add(
      ParsedTransaction(
        date: date,
        amountCents: cents,
        label: label,
        memo: (memo == null || memo == label) ? null : memo,
        reference: _tag(block, 'CHECKNUM') ?? _tag(block, 'REFNUM'),
        bankId: _tag(block, 'FITID'),
        line: line,
      ),
    );
  }

  int? balance;
  LocalDate? balanceDate;
  final ledger = RegExp(
    r'<LEDGERBAL>(.*?)(?=</LEDGERBAL>|<AVAILBAL>|</STMTRS>|</CCSTMTRS>|$)',
    dotAll: true,
    caseSensitive: false,
  ).firstMatch(text);
  if (ledger != null) {
    final amount = _tag(ledger.group(1)!, 'BALAMT');
    final asOf = _tag(ledger.group(1)!, 'DTASOF');
    try {
      if (amount != null) balance = parseDecimalCents(amount);
      if (asOf != null) balanceDate = LocalDate.parse(asOf);
    } on Object {
      issues.add(
        ImportIssue(
          IssueSeverity.warning,
          'ofx_balance_unreadable',
          _lineOf(lineStarts, ledger.start),
        ),
      );
      balance = null;
      balanceDate = null;
    }
  }

  return ParsedStatement(
    format: StatementFormat.ofx,
    transactions: transactions,
    issues: issues,
    encoding: decoded.encoding,
    accountNumber: _tag(text, 'ACCTID'),
    statedBalanceCents: balance,
    statedBalanceDate: balanceDate,
  );
}

/// Value of the first `<TAG>` in [source]: text up to the next `<` or line end.
String? _tag(String source, String tag) {
  final m = RegExp(
    '<$tag>([^<\\n]*)',
    caseSensitive: false,
  ).firstMatch(source);
  if (m == null) return null;
  final value = _unescape(m.group(1)!.trim());
  return value.isEmpty ? null : value;
}

String _unescape(String s) => s
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    .replaceAll('&nbsp;', ' ')
    .replaceAll('&amp;', '&');

/// 1-based line of [offset], by binary search over the line start offsets.
int _lineOf(List<int> lineStarts, int offset) {
  var lo = 0, hi = lineStarts.length - 1;
  while (lo < hi) {
    final mid = (lo + hi + 1) >> 1;
    if (lineStarts[mid] <= offset) {
      lo = mid;
    } else {
      hi = mid - 1;
    }
  }
  return lo + 1;
}

List<int> _lineStarts(String text) {
  final starts = <int>[0];
  for (var i = 0; i < text.length; i++) {
    if (text.codeUnitAt(i) == 10) starts.add(i + 1);
  }
  return starts;
}
