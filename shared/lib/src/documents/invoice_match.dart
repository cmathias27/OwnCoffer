import '../local_date.dart';
import '../text.dart';

/// What is known of an invoice waiting for its operation: all optional
/// but [addedOn], the day it was saved.
class InvoiceHint {
  /// Total paid, positive cents.
  final int? amountCents;
  final LocalDate? date;
  final String? merchant;
  final LocalDate addedOn;

  const InvoiceHint({
    required this.addedOn,
    this.amountCents,
    this.date,
    this.merchant,
  });

  bool get isEmpty =>
      amountCents == null &&
      date == null &&
      (merchant == null || merchant!.trim().isEmpty);

  /// Days of operations worth looking at: around the invoice's date, or
  /// before the day it was saved (a receipt is kept after paying).
  ({LocalDate from, LocalDate to}) get window => date != null
      ? (from: date!.addDays(-45), to: date!.addDays(45))
      : (from: addedOn.addDays(-90), to: addedOn.addDays(10));
}

/// An operation that could be the invoice's.
class MatchCandidate {
  final int id;
  final LocalDate date;

  /// Signed, as on the statement (debits are negative).
  final int amountCents;
  final String label;

  const MatchCandidate({
    required this.id,
    required this.date,
    required this.amountCents,
    required this.label,
  });
}

/// How well [c] fits [hint], 0 to 100; null when it cannot be it (another
/// amount, too far in time, a credit). Same amount weighs most, then the
/// date, then the merchant's name in the label.
int? invoiceMatchScore(InvoiceHint hint, MatchCandidate c) {
  if (c.amountCents >= 0) return null;
  final w = hint.window;
  if (c.date < w.from || c.date > w.to) return null;
  var score = 0;

  final amount = hint.amountCents;
  if (amount != null) {
    final paid = -c.amountCents;
    if (paid == amount) {
      score += 55;
    } else if ((paid - amount).abs() * 100 <= amount) {
      // Within 1 %: a rounding, a currency conversion.
      score += 25;
    } else {
      return null;
    }
  }

  final ref = hint.date ?? hint.addedOn;
  final days = ref.daysUntil(c.date).abs();
  if (hint.date != null) {
    score += days <= 3
        ? 25
        : days <= 10
        ? 15
        : days <= 30
        ? 5
        : 0;
  } else {
    score += days <= 7
        ? 10
        : days <= 30
        ? 5
        : 0;
  }

  final merchant = hint.merchant == null
      ? ''
      : normalizeForMatch(hint.merchant!);
  if (merchant.isNotEmpty) {
    final label = ' ${normalizeForMatch(c.label)} ';
    final words = [
      for (final w in merchant.split(' '))
        if (w.length >= 3) w,
    ];
    if (words.isNotEmpty && words.any((w) => label.contains(' $w'))) {
      score += 20;
    } else if (amount == null) {
      // Only a name to go by, and it is not there.
      return null;
    }
  }
  return score > 100 ? 100 : score;
}

/// The best [max] candidates for [hint], best first (closest date on a
/// tie). Without any hint, the most recent debits before it was saved.
List<({MatchCandidate candidate, int score})> rankInvoiceMatches(
  InvoiceHint hint,
  Iterable<MatchCandidate> candidates, {
  int max = 5,
}) {
  final ref = hint.date ?? hint.addedOn;
  final scored = [
    for (final c in candidates)
      if (invoiceMatchScore(hint, c) case final s?) (candidate: c, score: s),
  ];
  scored.sort((a, b) {
    final s = b.score.compareTo(a.score);
    if (s != 0) return s;
    final d = ref
        .daysUntil(a.candidate.date)
        .abs()
        .compareTo(ref.daysUntil(b.candidate.date).abs());
    return d != 0 ? d : b.candidate.id.compareTo(a.candidate.id);
  });
  return scored.take(max).toList();
}
