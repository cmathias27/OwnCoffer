import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../import/csv_parser.dart';
import '../import/decoding.dart';
import '../import/statement.dart';
import '../import/statement_reader.dart';
import '../money.dart';
import '../text.dart';

/// Turns a real bank export into a file that can be used for tests without
/// revealing who it belongs to, keeping its exact format (encoding, line
/// endings, field layout) so the parsers see the same quirks.
///
/// - Every amount is multiplied by the same secret factor (identical amounts
///   stay identical, so duplicate detection can still be tested).
/// - Numbers of 5 digits or more (accounts, IBAN, references, mandates) are
///   replaced by pseudo-random digits of the same length; dates are kept.
/// - Transfer counterparties are replaced by `TIERS A`, `TIERS B`…
/// - Words listed by the user (name, street, city, employer) are replaced.
/// - Merchant names are kept: they are needed for classification.
class StatementAnonymizer {
  /// Factor applied to amounts, e.g. 1.13. Never written anywhere.
  final double amountFactor;

  /// Secret salt for pseudo digits; random by default.
  final String salt;

  /// Upper-case words or phrases → replacement.
  final Map<String, String> replacements;

  final _parties = <String, String>{};

  /// Distinct labels after anonymisation, with their count (for review).
  final Map<String, int> labels = {};

  StatementAnonymizer({
    double? amountFactor,
    String? salt,
    Map<String, String> replacements = const {},
  }) : amountFactor = amountFactor ?? _randomFactor(),
       salt = salt ?? _randomSalt(),
       replacements = {
         for (final e in replacements.entries)
           normalizeForMatch(e.key): e.value,
       };

  static double _randomFactor() {
    final r = Random.secure();
    // 0.701–1.300 in steps of 0.001, never exactly 1.
    var step = 300;
    while (step == 300) {
      step = r.nextInt(600) + 1;
    }
    return 0.7 + step / 1000;
  }

  static String _randomSalt() {
    final r = Random.secure();
    return base64Encode(List<int>.generate(16, (_) => r.nextInt(256)));
  }

  /// Anonymises one file; returns the new bytes in the original encoding.
  List<int> anonymize(List<int> bytes) {
    final format = detectStatementFormat(bytes);
    if (format == null) throw const StatementFormatException('unknown_format');
    final decoded = decodeBankFile(bytes);
    final crlf = _usesCrlf(bytes);
    final text = switch (format) {
      StatementFormat.qif => _qif(decoded.text),
      StatementFormat.ofx => _ofx(decoded.text),
      StatementFormat.csv => _csv(decoded.text),
    };
    final out = crlf ? text.replaceAll('\n', '\r\n') : text;
    final hadBom = bytes.length >= 3 && bytes[0] == 0xEF && bytes[1] == 0xBB;
    return decoded.encoding == 'utf-8'
        ? [
            if (hadBom) ...[0xEF, 0xBB, 0xBF],
            ...utf8.encode(out),
          ]
        : encodeWindows1252(out);
  }

  static bool _usesCrlf(List<int> bytes) {
    for (var i = 0; i + 1 < bytes.length; i++) {
      if (bytes[i] == 0x0D && bytes[i + 1] == 0x0A) return true;
      if (bytes[i] == 0x0A) return false;
    }
    return false;
  }

  // --- Amounts ---------------------------------------------------------------

  int scaleCents(int cents) => (cents * amountFactor).round();

  /// Rewrites a French/international amount keeping its decimal separator.
  String _scaleAmountText(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return raw;
    final cents = parseAmountCents(trimmed);
    final comma =
        trimmed.contains(',') &&
        (!trimmed.contains('.') ||
            trimmed.lastIndexOf(',') > trimmed.lastIndexOf('.'));
    final explicitPlus = trimmed.startsWith('+');
    final scaled = scaleCents(cents);
    var s = formatCents(
      scaled,
      decimalSeparator: comma ? ',' : '.',
      thousandsSeparator: '',
    );
    if (explicitPlus && scaled > 0) s = '+$s';
    return raw.replaceFirst(trimmed, s);
  }

  String _scaleDecimalText(String raw) {
    final cents = parseDecimalCents(raw);
    final sep = raw.contains(',') ? ',' : '.';
    return formatCents(
      scaleCents(cents),
      decimalSeparator: sep,
      thousandsSeparator: '',
    );
  }

  // --- Text ------------------------------------------------------------------

  static final _longNumber = RegExp(r'\d{5,}');
  static final _compactDate = RegExp(
    r'^(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])(\d{2}|20\d{2})$',
  );
  static final _transfer = RegExp(
    r'^(\s*(?:VIR(?:EMENT)?\.?(?:\s+(?:SEPA|INST|INSTANTANE|EUROPEEN|PERMANENT))?'
    r'(?:\s+(?:RECU|EMIS))?(?:\s+(?:DE|POUR|A))?)\s+)(.+)$',
    caseSensitive: false,
  );

  String _digits(String number) {
    if (_compactDate.hasMatch(number)) return number;
    final h = sha256.convert(utf8.encode('$salt|$number')).bytes;
    final b = StringBuffer();
    for (var i = 0; i < number.length; i++) {
      b.write(h[i % h.length] % 10);
    }
    return b.toString();
  }

  String _party(String name) => _parties.putIfAbsent(
    normalizeForMatch(name),
    () => 'TIERS ${_letters(_parties.length)}',
  );

  static String _letters(int n) {
    var s = '';
    var x = n;
    do {
      s = String.fromCharCode(65 + x % 26) + s;
      x = x ~/ 26 - 1;
    } while (x >= 0);
    return s;
  }

  /// Anonymises free text (labels, memos, references).
  String text(String input, {bool isLabel = false}) {
    var s = input;
    for (final e in replacements.entries) {
      final pattern = RegExp(
        r'(?<![A-Za-z0-9À-ÿ])' +
            e.key.split(' ').map(RegExp.escape).join(r'[\s\W]+') +
            r'(?![A-Za-z0-9À-ÿ])',
        caseSensitive: false,
      );
      s = s.replaceAll(pattern, e.value);
    }
    final transfer = _transfer.firstMatch(s);
    if (transfer != null) {
      s = '${transfer[1]}${_party(transfer[2]!)}';
    }
    s = s.replaceAllMapped(_longNumber, (m) => _digits(m[0]!));
    if (isLabel) labels.update(s.trim(), (n) => n + 1, ifAbsent: () => 1);
    return s;
  }

  /// Account-like identifiers: every digit is replaced.
  String identifier(String input) => input.replaceAllMapped(
    RegExp(r'\d+'),
    (m) => _digits(m[0]!.padLeft(5, '0')).substring(0, m[0]!.length),
  );

  // --- Formats ---------------------------------------------------------------

  String _qif(String text) {
    final lines = text.split('\n');
    var memoIsTransfer = false;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.isEmpty || line.startsWith('!') || line.trim() == '^') {
        if (line.trim() == '^') memoIsTransfer = false;
        continue;
      }
      final code = line[0];
      final value = line.substring(1);
      switch (code) {
        case 'T' || 'U' || r'$':
          lines[i] = code + _scaleAmountText(value);
        case 'P':
          final out = this.text(value, isLabel: true);
          memoIsTransfer = out != value && out.contains('TIERS ');
          lines[i] = 'P$out';
        case 'M':
          lines[i] = memoIsTransfer ? 'MMOTIF' : 'M${this.text(value)}';
        case 'N' || 'A' || 'E':
          lines[i] = code + this.text(value);
      }
    }
    return lines.join('\n');
  }

  String _ofx(String text) {
    var memoIsTransfer = false;
    return text.replaceAllMapped(
      RegExp(r'<([A-Z0-9.]+)>([^<\n]*)', caseSensitive: false),
      (m) {
        final tag = m[1]!.toUpperCase();
        final value = m[2]!;
        if (tag == 'STMTTRN') memoIsTransfer = false;
        if (value.trim().isEmpty) return m[0]!;
        String out;
        switch (tag) {
          case 'TRNAMT' || 'BALAMT':
            out = _scaleDecimalText(value.trim());
          case 'NAME' || 'PAYEE':
            out = this.text(value, isLabel: true);
            memoIsTransfer = out.contains('TIERS ') && out != value;
          case 'MEMO':
            out = memoIsTransfer ? 'MOTIF' : this.text(value);
          case 'ACCTID' ||
              'BANKID' ||
              'BRANCHID' ||
              'FITID' ||
              'CHECKNUM' ||
              'REFNUM' ||
              'TRNUID' ||
              'SRVRTID':
            out = identifier(value);
          default:
            out = value;
        }
        return '<${m[1]}>$out';
      },
    );
  }

  String _csv(String text) {
    final mapping = detectCsvMapping(text);
    if (mapping == null) {
      throw const StatementFormatException('csv_columns_unknown');
    }
    final amountColumns = {
      mapping.amountColumn,
      mapping.debitColumn,
      mapping.creditColumn,
    }.whereType<int>().toSet();
    final lines = text.split('\n');
    final d = mapping.delimiter;
    for (var r = 0; r < lines.length; r++) {
      if (lines[r].trim().isEmpty) continue;
      if (r < mapping.headerRow) {
        // Preamble: account number, holder name…
        lines[r] = this.text(identifier(lines[r]));
        continue;
      }
      if (r == mapping.headerRow) continue;
      final cells = splitCsv(lines[r], d).firstOrNull ?? const <String>[];
      final out = <String>[];
      for (var c = 0; c < cells.length; c++) {
        final v = cells[c];
        if (c == mapping.dateColumn || v.trim().isEmpty) {
          out.add(v);
        } else if (amountColumns.contains(c)) {
          out.add(_safe(() => _scaleAmountText(v), v));
        } else {
          out.add(this.text(v, isLabel: c == mapping.labelColumn));
        }
      }
      lines[r] = out.map((v) => _quote(v, d)).join(d);
    }
    return lines.join('\n');
  }

  static String _safe(String Function() f, String fallback) {
    try {
      return f();
    } on AmountFormatException {
      return fallback;
    }
  }

  static String _quote(String v, String d) =>
      (v.contains(d) || v.contains('"')) ? '"${v.replaceAll('"', '""')}"' : v;
}
