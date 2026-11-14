/// Cost of the AI (decision 0048). Prices are typed by the server
/// administrator per million tokens, kept as integers in hundredths of a
/// cent (0.075 € per million = 750): cheap models cost fractions of a cent.
library;

/// Hundredths of a cent in one unit of currency.
const pricePrecision = 10000;

/// The cost in cents of the tokens sent and received at the prices per
/// million (hundredths of a cent), rounded once to the nearest cent (half
/// up). Integers only: never a `double`.
int aiCostCents({
  required int inputTokens,
  required int outputTokens,
  required int inputPrice,
  required int outputPrice,
}) {
  if ([inputTokens, outputTokens, inputPrice, outputPrice].any((v) => v < 0)) {
    throw ArgumentError('tokens and prices must not be negative');
  }
  const divisor = 1000000 * 100; // a million tokens, hundredths of a cent
  final exact = inputTokens * inputPrice + outputTokens * outputPrice;
  return (exact + divisor ~/ 2) ~/ divisor;
}

/// A price typed by the user: `0,075`, `3`, `2.50`; up to four decimals.
/// Returns hundredths of a cent, or null when unreadable or negative.
int? parseAiPrice(String text) {
  final t = text.trim().replaceAll(' ', '').replaceAll(' ', '');
  final m = RegExp(r'^(\d{1,6})(?:[.,](\d{1,4}))?$').firstMatch(t);
  if (m == null) return null;
  final whole = int.parse(m[1]!);
  final decimals = (m[2] ?? '').padRight(4, '0');
  return whole * pricePrecision + int.parse(decimals);
}

/// A price as the user typed it: `0.075`, `3`, `2.5` (with [decimal] as
/// the separator), never more decimals than needed.
String formatAiPrice(int price, {String decimal = '.'}) {
  final whole = price ~/ pricePrecision;
  final rest = (price % pricePrecision).toString().padLeft(4, '0');
  final trimmed = rest.replaceFirst(RegExp(r'0+$'), '');
  return trimmed.isEmpty ? '$whole' : '$whole$decimal$trimmed';
}
