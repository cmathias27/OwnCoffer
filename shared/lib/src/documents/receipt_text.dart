/// Reads the useful fields of a till receipt from its recognised text.
///
/// Input is the lines an OCR engine produced (decision 0023); nothing here
/// knows which engine. Output is only a *proposal*: every field says whether
/// the reading is [ReceiptField.certain], and the app shows all of them to the
/// user for checking. Nothing is ever saved from this alone.
///
/// Deterministic, no I/O. Amounts are integer cents, dates are [LocalDate].
library;

import '../local_date.dart';
import '../money.dart';
import '../text.dart';

/// One value read from a receipt, with the line it came from.
class ReceiptField<T> {
  final T value;

  /// The raw text line the value was read from (shown next to the field).
  final String source;

  /// `false` when another reading was just as plausible: the user must check.
  final bool certain;

  const ReceiptField(this.value, this.source, {required this.certain});

  @override
  String toString() => 'ReceiptField($value, certain: $certain)';
}

/// What could be read from a receipt. Any field may be missing.
class ReceiptReading {
  final ReceiptField<String>? merchant;
  final ReceiptField<LocalDate>? date;

  /// Amount paid, positive cents (tax included).
  final ReceiptField<int>? totalCents;

  /// Total VAT, positive cents, when the receipt prints it.
  final ReceiptField<int>? vatCents;

  const ReceiptReading({
    this.merchant,
    this.date,
    this.totalCents,
    this.vatCents,
  });

  bool get isEmpty =>
      merchant == null &&
      date == null &&
      totalCents == null &&
      vatCents == null;

  /// Whether every field found can be trusted without a second look.
  bool get isFullyCertain => [
    merchant,
    date,
    totalCents,
    vatCents,
  ].whereType<ReceiptField<Object>>().every((f) => f.certain);
}

// Amount with exactly two decimals, optional thousands groups: `1 234,56`,
// `12.50`, `7,9 0` is deliberately not accepted (too ambiguous).
final RegExp _amount = RegExp(
  r'(?<![\d.,])(\d{1,3}(?:[ .]\d{3})+|\d+)[,.](\d{2})(?![\d])',
);

final RegExp _date = RegExp(
  r'(?<!\d)(\d{1,2})[/.\-](\d{1,2})[/.\-](\d{4}|\d{2})(?!\d)',
);
final RegExp _isoDate = RegExp(r'(?<!\d)(\d{4})-(\d{2})-(\d{2})(?!\d)');

// Normalised (see normalizeForMatch). Strongest first.
const List<List<String>> _totalKeywords = [
  ['NET A PAYER', 'TOTAL TTC', 'TOTAL A PAYER', 'MONTANT TTC'],
  ['A PAYER', 'TOTAL EUR', 'TOTAL CB', 'MONTANT PAYE', 'MONTANT'],
  ['TOTAL'],
];

// Lines that contain "total" without being the amount paid.
const List<String> _notTotal = [
  'SOUS TOTAL',
  'SOUS-TOTAL',
  'TOTAL HT',
  'HT',
  'TVA',
  'REMISE',
  'ECONOMIE',
  'FIDELITE',
  'ARTICLES',
  'RENDU',
  'ARRONDI',
  'POINTS',
  'CAGNOTTE',
];

const List<String> _skipMerchant = [
  'TICKET',
  'BIENVENUE',
  'MERCI',
  'FACTURE',
  'DUPLICATA',
  'COPIE',
  'CLIENT',
  'SIRET',
  'SIREN',
  'TEL',
  'WWW',
  'HTTP',
  'CAISSE',
  'RECU',
  'NOTE',
];

/// Reads [lines] (top to bottom, as recognised) into a [ReceiptReading].
///
/// [today] rejects dates in the future (a misread digit); leave it `null` to
/// accept any date.
ReceiptReading readReceiptText(List<String> lines, {LocalDate? today}) {
  final cleaned = [
    for (final l in lines)
      if (l.trim().isNotEmpty) l.trim(),
  ];
  return ReceiptReading(
    merchant: _merchant(cleaned),
    date: _readDate(cleaned, today),
    totalCents: _total(cleaned),
    vatCents: _vat(cleaned),
  );
}

/// Every amount on [line], in cents, left to right.
List<int> _amountsIn(String line) {
  final out = <int>[];
  for (final m in _amount.allMatches(line)) {
    final whole = m[1]!.replaceAll(RegExp(r'[ .]'), '');
    try {
      out.add(parseAmountCents('$whole,${m[2]}'));
    } on AmountFormatException {
      continue;
    }
  }
  return out;
}

bool _hasWords(String normalised, String phrase) =>
    containsWords(normalised, phrase);

ReceiptField<int>? _total(List<String> lines) {
  for (var tier = 0; tier < _totalKeywords.length; tier++) {
    final found = <int, String>{};
    for (var i = 0; i < lines.length; i++) {
      final norm = normalizeForMatch(lines[i]);
      if (!_totalKeywords[tier].any((k) => _hasWords(norm, k))) continue;
      if (_notTotal.any((k) => _hasWords(norm, normalizeForMatch(k)))) {
        continue;
      }
      var amounts = _amountsIn(lines[i]);
      // The figure is often alone on the next line.
      if (amounts.isEmpty && i + 1 < lines.length) {
        amounts = _amountsIn(lines[i + 1]);
      }
      if (amounts.isEmpty) continue;
      found.putIfAbsent(amounts.last, () => lines[i]);
    }
    if (found.isNotEmpty) {
      // Two different totals at the same strength: take the largest (a
      // payment line cannot exceed the bill) but ask for a check.
      final best = found.keys.reduce((a, b) => a >= b ? a : b);
      return ReceiptField(best, found[best]!, certain: found.length == 1);
    }
  }
  // No keyword at all: the largest amount is a guess.
  int? best;
  String? source;
  for (final line in lines) {
    final norm = normalizeForMatch(line);
    if (_hasWords(norm, 'TVA') || _hasWords(norm, 'RENDU')) continue;
    for (final a in _amountsIn(line)) {
      if (best == null || a > best) {
        best = a;
        source = line;
      }
    }
  }
  if (best == null || best <= 0) return null;
  return ReceiptField(best, source!, certain: false);
}

ReceiptField<int>? _vat(List<String> lines) {
  for (var i = 0; i < lines.length; i++) {
    final norm = normalizeForMatch(lines[i]);
    final total =
        _hasWords(norm, 'TOTAL TVA') ||
        _hasWords(norm, 'TVA TOTALE') ||
        _hasWords(norm, 'TOTAL DES TVA');
    if (!total) continue;
    final amounts = _amountsIn(lines[i]);
    if (amounts.isNotEmpty) {
      return ReceiptField(amounts.last, lines[i], certain: true);
    }
  }
  return null;
}

ReceiptField<LocalDate>? _readDate(List<String> lines, LocalDate? today) {
  final found = <LocalDate, String>{};
  for (final line in lines) {
    for (final m in _isoDate.allMatches(line)) {
      final d = _build(
        int.parse(m[1]!),
        int.parse(m[2]!),
        int.parse(m[3]!),
        today,
      );
      if (d != null) found.putIfAbsent(d, () => line);
    }
    for (final m in _date.allMatches(line)) {
      final yearText = m[3]!;
      var year = int.parse(yearText);
      if (yearText.length == 2) year += 2000;
      final d = _build(year, int.parse(m[2]!), int.parse(m[1]!), today);
      if (d != null) found.putIfAbsent(d, () => line);
    }
  }
  if (found.isEmpty) return null;
  // The first date printed is the purchase; a later one is a due date, a
  // warranty or a loyalty expiry. Several distinct dates still mean a check.
  final first = found.entries.first;
  return ReceiptField(first.key, first.value, certain: found.length == 1);
}

LocalDate? _build(int year, int month, int day, LocalDate? today) {
  final LocalDate d;
  try {
    d = LocalDate(year, month, day);
  } on ArgumentError {
    return null;
  }
  if (today != null && d.compareTo(today) > 0) return null;
  return d;
}

ReceiptField<String>? _merchant(List<String> lines) {
  final top = lines.length < 6 ? lines.length : 6;
  for (var i = 0; i < top; i++) {
    final line = lines[i];
    final norm = normalizeForMatch(line);
    final letters = RegExp(r'[A-Za-zÀ-ÿ]').allMatches(line).length;
    if (letters < 3) continue;
    if (_skipMerchant.any((k) => _hasWords(norm, k))) continue;
    if (_amount.hasMatch(line) || _date.hasMatch(line)) continue;
    // Digit-heavy lines are phone numbers, postcodes, store numbers.
    final digits = RegExp(r'\d').allMatches(line).length;
    if (digits > letters) continue;
    return ReceiptField(
      _tidy(line),
      line,
      certain: i <= 1 && digits <= 2,
    );
  }
  return null;
}

String _tidy(String line) => line
    .replaceAll(RegExp(r'[*_#=~|]+'), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
