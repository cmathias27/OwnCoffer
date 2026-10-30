import '../text.dart';

/// Kind of operation, deduced from the bank label.
enum OperationKind {
  card,
  directDebit,
  transferIn,
  transferOut,
  transfer,
  withdrawal,
  cheque,
  deposit,
  fee,
  loan,
  other,
}

class CleanedLabel {
  /// Short label for display and matching, e.g. `EDF`. Normalised
  /// (upper case, no accents).
  final String display;

  /// Normalised full label (prefixes kept), for "contains" rules.
  final String full;

  final OperationKind kind;

  const CleanedLabel(this.display, this.full, this.kind);

  /// Key used by the history and by "equals" / "starts with" rules.
  String get key => display;

  @override
  String toString() => 'CleanedLabel($display, $kind)';
}

/// A prefix that announces the operation kind, normalised.
class LabelPrefix {
  final String text;
  final OperationKind kind;
  const LabelPrefix(this.text, this.kind);
}

/// Bank-specific cleaning rules. See `banks/caisse_epargne.dart`.
class BankLabelProfile {
  /// Longest first is not required: prefixes are tried by decreasing length.
  final List<LabelPrefix> prefixes;

  /// Patterns removed anywhere (references, dates, card numbers…), applied to
  /// the normalised label.
  final List<RegExp> noise;

  /// Markers after which everything is noise (`ID EMETTEUR`, `MDT`…).
  final List<String> cutMarkers;

  const BankLabelProfile({
    required this.prefixes,
    required this.noise,
    required this.cutMarkers,
  });
}

const _legalForms = {
  'SA', 'SAS', 'SASU', 'SARL', 'EURL', 'SNC', 'SCI', 'SCP', 'SCOP', 'GIE', //
};

/// Legal forms written with dots or in several words once normalised:
/// "S.a.r.l." → `S A R L`, "et Cie" → `ET CIE`.
const _legalSuffixes = [
  ['S', 'A', 'R', 'L'],
  ['S', 'A', 'S', 'U'],
  ['S', 'A', 'S'],
  ['S', 'C', 'A'],
  ['S', 'A'],
  ['ET', 'CIE'],
  ['ET', 'C'],
];

final RegExp _multiSpace = RegExp(r' {2,}');
final RegExp _leadingDayMonth = RegExp(
  r'^(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2]) ',
);

/// Generic French-bank profile; banks extend it.
final BankLabelProfile genericFrenchProfile = BankLabelProfile(
  prefixes: const [
    LabelPrefix('PRLV SEPA', OperationKind.directDebit),
    LabelPrefix('PRELEVEMENT SEPA', OperationKind.directDebit),
    LabelPrefix('PRELEVEMENT', OperationKind.directDebit),
    LabelPrefix('PRLV', OperationKind.directDebit),
    LabelPrefix('VIR SEPA RECU', OperationKind.transferIn),
    LabelPrefix('VIR SEPA EMIS', OperationKind.transferOut),
    LabelPrefix('VIR INST RECU', OperationKind.transferIn),
    LabelPrefix('VIR INST EMIS', OperationKind.transferOut),
    LabelPrefix('VIREMENT RECU', OperationKind.transferIn),
    LabelPrefix('VIREMENT EMIS', OperationKind.transferOut),
    LabelPrefix('VIR SEPA', OperationKind.transfer),
    LabelPrefix('VIR INST', OperationKind.transfer),
    LabelPrefix('VIREMENT', OperationKind.transfer),
    LabelPrefix('VIR', OperationKind.transfer),
    LabelPrefix('PAIEMENT PAR CARTE', OperationKind.card),
    LabelPrefix('PAIEMENT CB', OperationKind.card),
    LabelPrefix('CARTE', OperationKind.card),
    LabelPrefix('CB', OperationKind.card),
    LabelPrefix('RETRAIT DAB', OperationKind.withdrawal),
    LabelPrefix('RETRAIT', OperationKind.withdrawal),
    LabelPrefix('CHEQUE', OperationKind.cheque),
    LabelPrefix('CHQ', OperationKind.cheque),
    LabelPrefix('REMISE CHEQUE', OperationKind.deposit),
    LabelPrefix('REMISE CHQ', OperationKind.deposit),
    LabelPrefix('VERSEMENT', OperationKind.deposit),
    LabelPrefix('FRAIS', OperationKind.fee),
    LabelPrefix('COTISATION', OperationKind.fee),
    LabelPrefix('COMMISSION', OperationKind.fee),
    LabelPrefix('ECHEANCE PRET', OperationKind.loan),
    LabelPrefix('ECH PRET', OperationKind.loan),
  ],
  noise: [
    // Masked card numbers: 4970XXXXXXXX1234, XXXX1234, ****1234.
    RegExp(r'\b\d{0,6}X{2,}\d{0,4}\b'),
    // Dates: 29/10, 29/10/26, 29.10.2026 (separators are spaces once
    // normalised), and compact 291026 / 29102026.
    RegExp(r'\b\d{1,2} \d{1,2}( \d{2,4})?\b'),
    RegExp(r'\b(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])(\d{2}|\d{4})\b'),
    // Tokens holding 5 digits or more (references, contract numbers,
    // 123456E loan numbers).
    RegExp(r'\b[A-Z0-9]*\d{5,}[A-Z0-9]*\b'),
    // Tokens mixing letters and many digits (FR12ZZZ123456, REF A1B2C3D4).
    RegExp(r'\b(?=[A-Z]*\d)(?=\d*[A-Z])[A-Z0-9]{10,}\b'),
    // "FACT 281026", "DU 281026" leftovers.
    RegExp(r'\b(FACT|FACTURE|DU|LE)\b(?= *$)'),
  ],
  cutMarkers: const [
    'ID EMETTEUR',
    'ID CREANCIER',
    'MDT',
    'RUM',
    'REF',
    'MOTIF',
    'LIB',
    'ECH',
    'NUMERO',
  ],
);

/// Whether [raw] starts with a known operation prefix (`CB`, `PRLV`, `VIR`…).
bool startsWithOperationPrefix(String raw, {BankLabelProfile? profile}) {
  final s = normalizeForMatch(raw);
  return (profile ?? genericFrenchProfile).prefixes.any(
    (p) => startsWithWords(s, p.text),
  );
}

/// Turns a raw bank label into a short, stable merchant label.
///
/// `PRLV SEPA EDF SA REF 123456789 MDT FR12ZZZ1` → `EDF` (direct debit).
/// The result never contains dates, card numbers or long references, so it
/// can be shared in community rules (personal transfers are excluded by the
/// caller using [CleanedLabel.kind]).
CleanedLabel cleanLabel(
  String raw, {
  String? memo,
  BankLabelProfile? profile,
}) {
  final p = profile ?? genericFrenchProfile;
  // The short label comes from the operation label only; the memo (bank's
  // short name, transfer reason…) is only used for matching rules.
  final full = normalizeForMatch(
    memo == null || memo.trim().isEmpty ? raw : '$raw $memo',
  );
  var s = normalizeForMatch(raw);

  var kind = OperationKind.other;
  final prefixes = [...p.prefixes]
    ..sort((a, b) => b.text.length.compareTo(a.text.length));
  for (final prefix in prefixes) {
    if (startsWithWords(s, prefix.text)) {
      kind = prefix.kind;
      s = s.substring(prefix.text.length).trim();
      break;
    }
  }
  // Card payments often start with the purchase day: "CB 0210 SNCF".
  if (kind == OperationKind.card) s = s.replaceFirst(_leadingDayMonth, '');

  for (final marker in p.cutMarkers) {
    final i = ' $s '.indexOf(' $marker ');
    if (i > 0) s = s.substring(0, i - 0).trim();
  }

  for (final pattern in p.noise) {
    s = s.replaceAll(pattern, ' ');
  }
  s = s.replaceAll(_multiSpace, ' ').trim();

  // Drop trailing legal forms: "EDF SA" → "EDF".
  var words = s.isEmpty ? <String>[] : s.split(' ');
  var trimmed = true;
  while (trimmed) {
    trimmed = false;
    if (words.length > 1 && _legalForms.contains(words.last)) {
      words = words.sublist(0, words.length - 1);
      trimmed = true;
      continue;
    }
    for (final suffix in _legalSuffixes) {
      if (words.length > suffix.length && _endsWith(words, suffix)) {
        words = words.sublist(0, words.length - suffix.length);
        trimmed = true;
        break;
      }
    }
  }
  s = words.join(' ');

  if (s.isEmpty) {
    // Nothing left (e.g. "RETRAIT DAB 29/10"): keep the kind as label.
    final label = normalizeForMatch(raw);
    s =
        prefixes
            .where((x) => x.kind == kind && startsWithWords(label, x.text))
            .map((x) => x.text)
            .firstOrNull ??
        label;
  }
  return CleanedLabel(s, full, kind);
}

bool _endsWith(List<String> words, List<String> suffix) {
  for (var i = 0; i < suffix.length; i++) {
    if (words[words.length - suffix.length + i] != suffix[i]) return false;
  }
  return true;
}
