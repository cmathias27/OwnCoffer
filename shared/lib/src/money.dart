/// Amounts are always integer cents. Never use `double` for money.
library;

/// Thrown when a text cannot be read as an amount without ambiguity.
class AmountFormatException implements Exception {
  final String input;
  final String reason;
  const AmountFormatException(this.input, this.reason);

  @override
  String toString() => 'AmountFormatException: "$input" — $reason';
}

/// Largest absolute amount accepted, in cents (10^13 € — far beyond any
/// real balance, and well inside the 2^53 range that is exact on the web).
const int maxAbsCents = 1000000000000000;

final RegExp _spaces = RegExp(r"[\s   ']");
final RegExp _digitsOnly = RegExp(r'^\d+$');
final RegExp _thousandsGroups = RegExp(r'^\d{1,3}(\d{3})*$');

/// Parses a bank amount into cents.
///
/// Accepts French and international notations: `-1 234,56`, `1.234,56`,
/// `1,234.56`, `+12`, `12,5`, `(12,30)`, `12,30-`, `−12,30` (Unicode minus),
/// and an optional trailing `€` / `EUR`.
///
/// Rejects anything ambiguous instead of guessing: more than two decimals,
/// a single `.` followed by exactly three digits (`1.234`), misplaced
/// thousands separators, empty values.
int parseAmountCents(String input) {
  var s = input.trim();
  if (s.isEmpty) throw AmountFormatException(input, 'empty');

  s = s.replaceAll(_spaces, '');
  s = s.replaceAll(RegExp(r'(€|EUR)$', caseSensitive: false), '');
  s = s.replaceAll('−', '-');

  var negative = false;
  if (s.startsWith('(') && s.endsWith(')')) {
    negative = true;
    s = s.substring(1, s.length - 1);
  }
  if (s.startsWith('-')) {
    negative = !negative;
    s = s.substring(1);
  } else if (s.startsWith('+')) {
    s = s.substring(1);
  } else if (s.endsWith('-')) {
    negative = !negative;
    s = s.substring(0, s.length - 1);
  }
  if (s.isEmpty) throw AmountFormatException(input, 'no digits');

  final lastComma = s.lastIndexOf(',');
  final lastDot = s.lastIndexOf('.');
  String intPart;
  String decPart;

  if (lastComma >= 0 && lastDot >= 0) {
    // Both separators: the last one is the decimal separator.
    final decSep = lastComma > lastDot ? ',' : '.';
    final thSep = decSep == ',' ? '.' : ',';
    final decIndex = s.lastIndexOf(decSep);
    if (s.indexOf(decSep) != decIndex) {
      throw AmountFormatException(input, 'decimal separator repeated');
    }
    intPart = s.substring(0, decIndex);
    decPart = s.substring(decIndex + 1);
    final groups = intPart.split(thSep);
    if (!_validThousands(groups)) {
      throw AmountFormatException(input, 'bad thousands grouping');
    }
    intPart = groups.join();
  } else if (lastComma >= 0 || lastDot >= 0) {
    final sep = lastComma >= 0 ? ',' : '.';
    final parts = s.split(sep);
    if (parts.length > 2) {
      // Repeated separator: thousands only (e.g. 1.234.567).
      if (!_validThousands(parts)) {
        throw AmountFormatException(input, 'bad thousands grouping');
      }
      intPart = parts.join();
      decPart = '';
    } else if (parts[1].length == 3 && sep == '.') {
      throw AmountFormatException(
        input,
        'ambiguous: "." followed by three digits',
      );
    } else {
      intPart = parts[0];
      decPart = parts[1];
    }
  } else {
    intPart = s;
    decPart = '';
  }

  if (intPart.isEmpty) intPart = '0';
  if (!_digitsOnly.hasMatch(intPart) ||
      (decPart.isNotEmpty && !_digitsOnly.hasMatch(decPart))) {
    throw AmountFormatException(input, 'unexpected characters');
  }
  if (decPart.length > 2) {
    throw AmountFormatException(input, 'more than two decimals');
  }
  if (intPart.length > 13) {
    throw AmountFormatException(input, 'amount too large');
  }

  final cents = int.parse(intPart) * 100 + int.parse(decPart.padRight(2, '0'));
  if (cents > maxAbsCents) {
    throw AmountFormatException(input, 'amount too large');
  }
  return negative ? -cents : cents;
}

final RegExp _plainDecimal = RegExp(r'^([+\-]?)(\d*)(?:[.,](\d*))?$');

/// Parses a machine-written decimal (OFX `TRNAMT`): optional sign, no
/// thousands separator, `.` or `,` as decimal point. Extra decimals are
/// accepted only when they are zeros (`-50.000` → -5000); `12.345` is
/// rejected rather than rounded.
int parseDecimalCents(String input) {
  final s = input.trim().replaceAll('−', '-');
  final m = _plainDecimal.firstMatch(s);
  if (m == null || (m[2]!.isEmpty && (m[3] ?? '').isEmpty)) {
    throw AmountFormatException(input, 'not a plain decimal');
  }
  var dec = m[3] ?? '';
  if (dec.length > 2) {
    if (dec.substring(2).replaceAll('0', '').isNotEmpty) {
      throw AmountFormatException(input, 'more than two decimals');
    }
    dec = dec.substring(0, 2);
  }
  final intPart = m[2]!.isEmpty ? '0' : m[2]!;
  if (intPart.length > 13) {
    throw AmountFormatException(input, 'amount too large');
  }
  final cents = int.parse(intPart) * 100 + int.parse(dec.padRight(2, '0'));
  return m[1] == '-' ? -cents : cents;
}

bool _validThousands(List<String> groups) {
  if (groups.isEmpty || groups.first.isEmpty || groups.first.length > 3) {
    return false;
  }
  for (final g in groups.skip(1)) {
    if (g.length != 3) return false;
  }
  return _thousandsGroups.hasMatch(groups.join());
}

/// Formats cents for logs and tests: `-1 234,56`. User-facing formatting goes
/// through the app's localization layer.
String formatCents(
  int cents, {
  String decimalSeparator = ',',
  String thousandsSeparator = ' ',
}) {
  final negative = cents < 0;
  final abs = cents.abs();
  final units = (abs ~/ 100).toString();
  final dec = (abs % 100).toString().padLeft(2, '0');
  final buffer = StringBuffer();
  for (var i = 0; i < units.length; i++) {
    if (i > 0 && (units.length - i) % 3 == 0) buffer.write(thousandsSeparator);
    buffer.write(units[i]);
  }
  return '${negative ? '-' : ''}$buffer$decimalSeparator$dec';
}

/// Sums cents and checks the result stays inside the safe range.
int sumCents(Iterable<int> values) {
  var total = 0;
  for (final v in values) {
    total += v;
    if (total.abs() > maxAbsCents) {
      throw StateError('Sum exceeds the supported amount range');
    }
  }
  return total;
}
