import '../local_date.dart';

/// File formats OwnCoffer can read.
enum StatementFormat { qif, ofx, csv }

/// One operation read from a bank file, before any classification.
class ParsedTransaction {
  final LocalDate date;

  /// Signed amount in cents: negative for a debit, positive for a credit.
  final int amountCents;

  /// Main label as written by the bank (QIF `P`, OFX `NAME`, CSV label).
  final String label;

  /// Additional details (QIF `M`, OFX `MEMO`, CSV details), if any.
  final String? memo;

  /// Bank reference or cheque number, if any.
  final String? reference;

  /// Unique id given by the bank (OFX `FITID`), if any.
  final String? bankId;

  /// 1-based line in the source file, for error messages.
  final int line;

  const ParsedTransaction({
    required this.date,
    required this.amountCents,
    required this.label,
    this.memo,
    this.reference,
    this.bankId,
    this.line = 0,
  });

  /// Label and memo joined, as used for cleaning and matching.
  String get fullLabel {
    final m = memo?.trim() ?? '';
    final l = label.trim();
    if (m.isEmpty || l.contains(m)) return l;
    if (l.isEmpty || m.contains(l)) return m;
    return '$l $m';
  }

  @override
  String toString() => 'ParsedTransaction($date, $amountCents, "$label")';
}

enum IssueSeverity {
  /// The line was skipped: the user must look at it.
  error,

  /// The line was read, but something unusual was noticed.
  warning,
}

/// A problem found while reading a file. Messages are codes, translated by the
/// app; [detail] never contains amounts, labels or account numbers.
class ImportIssue {
  final IssueSeverity severity;
  final String code;
  final int line;
  final String? detail;

  const ImportIssue(this.severity, this.code, this.line, [this.detail]);

  @override
  String toString() =>
      '${severity.name} $code at line $line${detail == null ? '' : ' ($detail)'}';
}

/// Everything read from one bank file.
class ParsedStatement {
  final StatementFormat format;
  final List<ParsedTransaction> transactions;
  final List<ImportIssue> issues;

  /// Account number found in the file (OFX), to suggest the target account.
  /// Never logged.
  final String? accountNumber;

  /// Closing balance stated by the bank (OFX `LEDGERBAL`), if present.
  final int? statedBalanceCents;
  final LocalDate? statedBalanceDate;

  /// Encoding the file was decoded with.
  final String encoding;

  const ParsedStatement({
    required this.format,
    required this.transactions,
    required this.issues,
    required this.encoding,
    this.accountNumber,
    this.statedBalanceCents,
    this.statedBalanceDate,
  });

  bool get hasErrors => issues.any((i) => i.severity == IssueSeverity.error);

  LocalDate? get firstDate => transactions.isEmpty
      ? null
      : transactions.map((t) => t.date).reduce((a, b) => a < b ? a : b);

  LocalDate? get lastDate => transactions.isEmpty
      ? null
      : transactions.map((t) => t.date).reduce((a, b) => a > b ? a : b);
}

/// Thrown when a file cannot be read at all (wrong format, empty…).
class StatementFormatException implements Exception {
  final String code;
  const StatementFormatException(this.code);

  @override
  String toString() => 'StatementFormatException: $code';
}
