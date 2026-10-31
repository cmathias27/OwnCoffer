/// Month-end review and day-to-day helpers of the budget, computed without
/// AI (cahier des charges : revue de fin de mois, reste à vivre, ventilation,
/// calendrier des échéances).
library;

import '../local_date.dart';

/// A category whose spending moved noticeably against a reference (the
/// average of the previous months).
class CategoryChange {
  final int categoryId;
  final int amountCents;
  final int referenceCents;

  const CategoryChange(this.categoryId, this.amountCents, this.referenceCents);

  int get deltaCents => amountCents - referenceCents;

  /// Change in percent of the reference; null without reference.
  int? get percent =>
      referenceCents == 0 ? null : deltaCents * 100 ~/ referenceCents;
}

/// Categories of [candidates] whose amount moved by at least [minPercent] %
/// and [minDeltaCents] against [reference]; rises first by size when
/// [rises], else drops. At most [limit].
List<CategoryChange> notableChanges(
  Map<int, int> current,
  Map<int, int> reference,
  Iterable<int> candidates, {
  bool rises = true,
  int minDeltaCents = 2000,
  int minPercent = 20,
  int limit = 5,
}) {
  final result = <CategoryChange>[];
  for (final id in candidates) {
    final c = CategoryChange(id, current[id] ?? 0, reference[id] ?? 0);
    final delta = rises ? c.deltaCents : -c.deltaCents;
    if (delta < minDeltaCents) continue;
    if (c.referenceCents > 0 && delta * 100 < c.referenceCents * minPercent) {
      continue;
    }
    if (!rises && c.referenceCents <= 0) continue;
    result.add(c);
  }
  result.sort(
    (a, b) => rises
        ? b.deltaCents.compareTo(a.deltaCents)
        : a.deltaCents.compareTo(b.deltaCents),
  );
  return result.take(limit).toList();
}

/// A split of one operation between categories is valid when it has at
/// least two parts, each of the operation's sign and not zero, adding up to
/// the operation's amount exactly.
bool isValidSplit(int totalCents, List<int> partsCents) {
  if (totalCents == 0 || partsCents.length < 2) return false;
  var sum = 0;
  for (final p in partsCents) {
    if (p == 0 || (p < 0) != (totalCents < 0)) return false;
    sum += p;
  }
  return sum == totalCents;
}

/// What is left to spend until the next pay day: the balance expected on
/// the last day of the budget month, spread over the remaining days.
class LeftToLive {
  final LocalDate today;

  /// Last day of the budget month, inclusive.
  final LocalDate last;

  /// Balance now.
  final int balanceCents;

  /// Planned debits (negative) and credits until [last], not yet realised.
  final int plannedDebitsCents;
  final int plannedCreditsCents;

  const LeftToLive({
    required this.today,
    required this.last,
    required this.balanceCents,
    required this.plannedDebitsCents,
    required this.plannedCreditsCents,
  });

  int get leftCents => balanceCents + plannedDebitsCents + plannedCreditsCents;

  /// Days from today to [last], both included.
  int get daysLeft => today.daysUntil(last) + 1;

  /// Per remaining day, rounded down; 0 when nothing is left.
  int get perDayCents =>
      leftCents <= 0 || daysLeft <= 0 ? 0 : leftCents ~/ daysLeft;
}

enum OccurrenceStatus {
  /// Matched with a real operation.
  paid,

  /// Passed without a matching operation and not skipped: late or missed.
  late,

  /// Skipped by the user (before the planned operation's next due date).
  skipped,

  /// Still to come.
  upcoming,
}

/// Where an occurrence of a planned operation stands on [today].
OccurrenceStatus occurrenceStatus({
  required LocalDate due,
  required LocalDate today,
  required bool linked,
  LocalDate? nextDue,
}) {
  if (linked) return OccurrenceStatus.paid;
  if (nextDue != null && due < nextDue) return OccurrenceStatus.skipped;
  if (due < today) return OccurrenceStatus.late;
  return OccurrenceStatus.upcoming;
}
