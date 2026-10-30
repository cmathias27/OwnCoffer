/// Text normalisation used for matching labels.
library;

const Map<String, String> _foldings = {
  'À': 'A',
  'Á': 'A',
  'Â': 'A',
  'Ã': 'A',
  'Ä': 'A',
  'Å': 'A',
  'Æ': 'AE',
  'Ç': 'C',
  'È': 'E',
  'É': 'E',
  'Ê': 'E',
  'Ë': 'E',
  'Ì': 'I',
  'Í': 'I',
  'Î': 'I',
  'Ï': 'I',
  'Ñ': 'N',
  'Ò': 'O',
  'Ó': 'O',
  'Ô': 'O',
  'Õ': 'O',
  'Ö': 'O',
  'Ø': 'O',
  'Œ': 'OE',
  'Ù': 'U',
  'Ú': 'U',
  'Û': 'U',
  'Ü': 'U',
  'Ý': 'Y',
  'Ÿ': 'Y',
  'ß': 'SS',
};

final RegExp _nonAlnum = RegExp(r'[^A-Z0-9]+');

/// Removes accents and ligatures from an upper-cased string.
String foldAccents(String input) {
  final upper = input.toUpperCase();
  final buffer = StringBuffer();
  for (final rune in upper.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(_foldings[ch] ?? ch);
  }
  return buffer.toString();
}

/// Matching key: upper case, no accents, only `A–Z 0–9`, single spaces.
/// `"Prlv  SEPA – Électricité"` → `"PRLV SEPA ELECTRICITE"`.
String normalizeForMatch(String input) =>
    foldAccents(input).replaceAll(_nonAlnum, ' ').trim();

/// Whether [pattern] appears in [text] as whole words (both normalized).
/// `"SNCF"` matches `"TRAIN SNCF PARIS"` but not `"ASNCF"`.
bool containsWords(String text, String pattern) {
  if (pattern.isEmpty) return false;
  return ' $text '.contains(' $pattern ');
}

/// Whether [text] starts with [pattern] as whole words (both normalized).
bool startsWithWords(String text, String pattern) {
  if (pattern.isEmpty) return false;
  return text == pattern || text.startsWith('$pattern ');
}
