/// Regulated savings accounts and the financial health indicators
/// (decision 0050): computed by the engine, each with its figures.
library;

import '../local_date.dart';

/// French regulated savings accounts.
enum RegulatedSavings { livretA, ldds, lep, livretJeune }

/// The legal ceiling of deposits (interest may take the balance above it).
int regulatedCeilingCents(RegulatedSavings kind) => switch (kind) {
  RegulatedSavings.livretA => 2295000,
  RegulatedSavings.ldds => 1200000,
  RegulatedSavings.lep => 1000000,
  RegulatedSavings.livretJeune => 160000,
};

/// The fortnight of [date] in its year, from 0 (1st–15th January) to 23
/// (16th–31st December).
int fortnightOf(LocalDate date) =>
    (date.month - 1) * 2 + (date.day >= 16 ? 1 : 0);

/// Interest of a regulated account under the fortnight rule: a deposit
/// earns from the fortnight after it, a withdrawal stops earning from the
/// start of its own fortnight; each fortnight earns 1/24 of the yearly rate
/// on its balance. [rateBp] is the yearly rate in hundredths of a percent
/// (1.70 % = 170). Only the [fortnights] first fortnights of the year are
/// counted (24 = the whole year). Rounded once, to the nearest cent.
int fortnightInterest({
  required int openingCents,
  required List<(LocalDate date, int amountCents)> movements,
  required int year,
  required int rateBp,
  int fortnights = 24,
}) {
  final deltas = List<int>.filled(25, 0);
  for (final (date, cents) in movements) {
    if (date.year != year) continue;
    final f = fortnightOf(date) + (cents > 0 ? 1 : 0);
    deltas[f] += cents;
  }
  var balance = openingCents;
  var sum = 0;
  final n = fortnights.clamp(0, 24);
  for (var f = 0; f < n; f++) {
    balance += deltas[f];
    if (balance > 0) sum += balance;
  }
  // sum × rate / 100 % / 24 fortnights, rounded half up.
  return (sum * rateBp * 2 + 240000) ~/ 480000;
}

/// Fortnights of [year] fully over on [today] (24 once the year is over).
int fortnightsOver(int year, LocalDate today) {
  if (today.year > year) return 24;
  if (today.year < year) return 0;
  return fortnightOf(today);
}

enum HealthLevel { good, fair, weak, unknown }

/// An indicator of financial health, with the figure behind its level.
class HealthIndicator {
  final String key;
  final HealthLevel level;

  /// The figure: tenths of a month, thousandths or a count, see [key].
  final int? value;

  const HealthIndicator(this.key, this.level, this.value);
}

/// Precautionary savings, in tenths of a month of spending: good from
/// three months, fair from one.
HealthIndicator emergencyIndicator(int savingsCents, int monthlyExpenseCents) {
  if (monthlyExpenseCents <= 0) {
    return const HealthIndicator('emergency', HealthLevel.unknown, null);
  }
  final tenths =
      (savingsCents < 0 ? 0 : savingsCents) * 10 ~/ monthlyExpenseCents;
  return HealthIndicator(
    'emergency',
    tenths >= 30
        ? HealthLevel.good
        : tenths >= 10
        ? HealthLevel.fair
        : HealthLevel.weak,
    tenths,
  );
}

/// Savings rate in thousandths of income: good from 10 %, fair from 0.
HealthIndicator savingsRateIndicator(int incomeCents, int expenseCents) {
  if (incomeCents <= 0) {
    return const HealthIndicator('savingsRate', HealthLevel.unknown, null);
  }
  final perMille = (incomeCents - expenseCents) * 1000 ~/ incomeCents;
  return HealthIndicator(
    'savingsRate',
    perMille >= 100
        ? HealthLevel.good
        : perMille >= 0
        ? HealthLevel.fair
        : HealthLevel.weak,
    perMille,
  );
}

/// Loan instalments over income, in thousandths: good up to 30 %, fair up
/// to 35 % (the usual bank limit).
HealthIndicator debtIndicator(int monthlyLoanCents, int monthlyIncomeCents) {
  if (monthlyLoanCents <= 0) {
    return const HealthIndicator('debt', HealthLevel.good, 0);
  }
  if (monthlyIncomeCents <= 0) {
    return const HealthIndicator('debt', HealthLevel.unknown, null);
  }
  final perMille = monthlyLoanCents * 1000 ~/ monthlyIncomeCents;
  return HealthIndicator(
    'debt',
    perMille <= 300
        ? HealthLevel.good
        : perMille <= 350
        ? HealthLevel.fair
        : HealthLevel.weak,
    perMille,
  );
}

/// Months ended without spending more than earned, among the last ones
/// ([monthlyNetCents], at least three needed): good from 5 out of 6.
HealthIndicator regularityIndicator(List<int> monthlyNetCents) {
  if (monthlyNetCents.length < 3) {
    return const HealthIndicator('regularity', HealthLevel.unknown, null);
  }
  final ok = monthlyNetCents.where((n) => n >= 0).length;
  final n = monthlyNetCents.length;
  return HealthIndicator(
    'regularity',
    ok * 6 >= n * 5
        ? HealthLevel.good
        : ok * 2 >= n
        ? HealthLevel.fair
        : HealthLevel.weak,
    ok,
  );
}

/// Out of 100: good 100, fair 50, weak 0, averaged over the known
/// indicators; null when none is known.
int? healthScore(List<HealthIndicator> indicators) {
  final known = [
    for (final i in indicators)
      if (i.level != HealthLevel.unknown) i.level,
  ];
  if (known.isEmpty) return null;
  final points = known.fold(
    0,
    (a, l) =>
        a +
        switch (l) {
          HealthLevel.good => 100,
          HealthLevel.fair => 50,
          _ => 0,
        },
  );
  return (points + known.length ~/ 2) ~/ known.length;
}
