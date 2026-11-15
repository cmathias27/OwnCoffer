import '../local_date.dart';
import '../text.dart';

/// A credit of one account that may be a pay: its label as cleaned by the
/// import, and whether the user (or a rule) classified it as a salary.
typedef PaydayCredit = ({
  int id,
  LocalDate date,
  int amountCents,
  String label,
  bool salary,
});

/// The pay found in an account's history: one credit a month, the same
/// label, about the same amount, around the same day.
class PaydayPattern {
  /// The label shared by the credits, without dates or references
  /// ("VIR SEPA SALAIRE ACME").
  final String label;

  /// The credits read as the pay, oldest first, one per month.
  final List<PaydayCredit> credits;

  /// Classified as salary (otherwise: the largest regular income).
  final bool salary;

  const PaydayPattern({
    required this.label,
    required this.credits,
    required this.salary,
  });

  /// The median amount (the lower one of the two middle ones).
  int get amountCents => _median([for (final c in credits) c.amountCents]);

  /// The usual day of the month (median).
  int get dayOfMonth => _median([for (final c in credits) c.date.day]);

  int get months => credits.length;
  LocalDate get last => credits.last.date;

  /// The next pay: the month after the last one, on the usual day (clamped
  /// to the end of shorter months).
  LocalDate get next => LocalDate(
    last.year,
    last.month,
    1,
  ).addMonths(1, preferredDay: dayOfMonth);

  /// The amount tolerance to propose for reconciliation, in percent: the
  /// largest gap seen to the median, rounded up to 5, from 5 to 30.
  int get tolerancePercent {
    final m = amountCents;
    var worst = 0;
    for (final c in credits) {
      final gap = ((c.amountCents - m).abs() * 100 + m - 1) ~/ m;
      if (gap > worst) worst = gap;
    }
    final rounded = (worst + 4) ~/ 5 * 5;
    return rounded.clamp(5, 30);
  }
}

int _median(List<int> values) {
  final sorted = [...values]..sort();
  return sorted[(sorted.length - 1) ~/ 2];
}

const _months = {
  'JANVIER', 'FEVRIER', 'MARS', 'AVRIL', 'MAI', 'JUIN', 'JUILLET', 'AOUT', //
  'SEPTEMBRE', 'OCTOBRE', 'NOVEMBRE', 'DECEMBRE', 'JANV', 'FEV', 'FEVR', //
  'AVR', 'JUIL', 'SEPT', 'OCT', 'NOV', 'DEC', 'JANUARY', 'FEBRUARY', //
  'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', //
  'OCTOBER', 'NOVEMBER', 'DECEMBER', 'JAN', 'FEB', 'MAR', 'APR', 'JUN', //
  'JUL', 'AUG', 'SEP',
};

/// [label] without what changes from one month to the next: words with a
/// digit (dates, references) and month names. At most five words are kept.
String paydayLabel(String label) => normalizeForMatch(label)
    .split(' ')
    .where((w) => w.isNotEmpty && !w.contains(RegExp(r'\d')))
    .where((w) => !_months.contains(w))
    .take(5)
    .join(' ');

/// The pay of an account among its recent [credits], or null: credits
/// grouped by [paydayLabel] (all those classified as salary together), the
/// largest one kept when two come less than 20 days apart, then the group
/// with at least [minMonths] credits 24 to 38 days apart, within 25 % of
/// their median, the last one at most 40 days before [today]. A salary
/// group comes first, then the largest amount; below [minAmountCents] a
/// credit is not taken for a pay.
///
/// [plannedCredits]: amounts of the monthly credits already planned on the
/// account; a pay within 30 % of one of them is already in the forecast.
PaydayPattern? detectPayday(
  Iterable<PaydayCredit> credits, {
  required LocalDate today,
  Iterable<int> plannedCredits = const [],
  int minMonths = 3,
  int minAmountCents = 20000,
}) {
  final from = today.addMonths(-6);
  final groups = <String, List<PaydayCredit>>{};
  for (final c in credits) {
    if (c.amountCents < minAmountCents) continue;
    if (c.date.isBefore(from) || c.date.isAfter(today)) continue;
    final label = paydayLabel(c.label);
    final key = c.salary ? '' : label;
    if (key.isEmpty && !c.salary) continue;
    (groups[key] ??= []).add(c);
  }
  PaydayPattern? best;
  for (final MapEntry(key: key, value: list) in groups.entries) {
    final kept = _onePerMonth(list);
    final run = _lastRegularRun(kept);
    if (run.length < minMonths) continue;
    if (run.last.date.daysUntil(today) > 40) continue;
    final salary = key.isEmpty;
    final pattern = PaydayPattern(
      label: salary ? _commonLabel(run) : key,
      credits: run,
      salary: salary,
    );
    if (best == null ||
        (salary && !best.salary) ||
        (salary == best.salary && pattern.amountCents > best.amountCents)) {
      best = pattern;
    }
  }
  if (best == null) return null;
  final amount = best.amountCents;
  for (final p in plannedCredits) {
    if (p > 0 && (p - amount).abs() * 10 <= amount * 3) return null;
  }
  return best;
}

/// Credits less than 20 days apart are one pay (a pay and an advance, or
/// a salary split between two transfers): the largest one is kept.
List<PaydayCredit> _onePerMonth(List<PaydayCredit> list) {
  final sorted = [...list]
    ..sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
  final kept = <PaydayCredit>[];
  for (final c in sorted) {
    final prev = kept.lastOrNull;
    if (prev != null && prev.date.daysUntil(c.date) < 20) {
      if (c.amountCents > prev.amountCents) kept[kept.length - 1] = c;
    } else {
      kept.add(c);
    }
  }
  return kept;
}

/// The latest credits that come once a month (24 to 38 days apart) within
/// 25 % of their median; an odd one (a bonus month) ends the run.
List<PaydayCredit> _lastRegularRun(List<PaydayCredit> kept) {
  if (kept.isEmpty) return const [];
  final run = <PaydayCredit>[kept.last];
  for (var i = kept.length - 2; i >= 0; i--) {
    final gap = kept[i].date.daysUntil(run.first.date);
    if (gap < 24 || gap > 38) break;
    run.insert(0, kept[i]);
  }
  final m = _median([for (final c in run) c.amountCents]);
  bool close(PaydayCredit c) => (c.amountCents - m).abs() * 4 <= m;
  // Keep the end of the run whose amounts stay close to the median.
  var start = run.length;
  while (start > 0 && close(run[start - 1])) {
    start--;
  }
  return run.sublist(start);
}

/// The label of the last credit, reduced like [paydayLabel], for a group
/// of salaries that may come with different labels.
String _commonLabel(List<PaydayCredit> run) {
  final label = paydayLabel(run.last.label);
  return label.isEmpty ? normalizeForMatch(run.last.label) : label;
}
