/// What keeping a contract costs over time, against switching to another
/// one (e.g. replacing an internet box or an insurance): cumulative
/// amounts month by month, in cents, deterministic.
class ContractSwitch {
  /// Cumulative cost at the end of each month (month 1 first) if the
  /// contract is kept, and if it is switched (one-off cost included).
  final List<int> keepCents;
  final List<int> switchCents;

  const ContractSwitch._(this.keepCents, this.switchCents);

  int get months => keepCents.length;

  /// Saved over the whole period (negative: the switch costs more).
  int get totalSavingCents => keepCents.last - switchCents.last;

  /// Saved on average per year of the period.
  int get yearlySavingCents => totalSavingCents * 12 ~/ months;

  /// First month (1 = the first) by the end of which switching has cost
  /// no more than keeping; null if it never pays off within the period.
  int? get breakEvenMonth {
    for (var i = 0; i < months; i++) {
      if (switchCents[i] <= keepCents[i]) return i + 1;
    }
    return null;
  }
}

/// Upper bounds of the inputs (a contract of 10 000 € a month, 50 years).
const maxContractCents = 1000000;
const maxSwitchCostCents = 10000000;
const maxSwitchMonths = 600;
const maxYearlyIncreasePerMille = 300;

/// Simulates [months] months of a contract at [currentMonthlyCents] a
/// month, kept or replaced by one at [newMonthlyCents] from the first month
/// (paying [switchCostCents] once, at the start: termination or set-up
/// fees). Each price rises every 12 months by its yearly increase, in
/// thousandths (30 = 3 %), rounded to the cent each year.
ContractSwitch simulateContractSwitch({
  required int currentMonthlyCents,
  required int newMonthlyCents,
  required int months,
  int switchCostCents = 0,
  int currentYearlyIncreasePerMille = 0,
  int newYearlyIncreasePerMille = 0,
}) {
  void check(int v, int max, String name) {
    if (v < 0 || v > max) throw ArgumentError.value(v, name);
  }

  check(currentMonthlyCents, maxContractCents, 'currentMonthlyCents');
  check(newMonthlyCents, maxContractCents, 'newMonthlyCents');
  check(switchCostCents, maxSwitchCostCents, 'switchCostCents');
  check(
    currentYearlyIncreasePerMille,
    maxYearlyIncreasePerMille,
    'currentYearlyIncreasePerMille',
  );
  check(
    newYearlyIncreasePerMille,
    maxYearlyIncreasePerMille,
    'newYearlyIncreasePerMille',
  );
  if (months < 1 || months > maxSwitchMonths) {
    throw ArgumentError.value(months, 'months');
  }
  int rise(int price, int perMille) =>
      (price * (1000 + perMille) + 500) ~/ 1000;

  final keep = <int>[], change = <int>[];
  var current = currentMonthlyCents, next = newMonthlyCents;
  var kept = 0, switched = switchCostCents;
  for (var m = 0; m < months; m++) {
    if (m > 0 && m % 12 == 0) {
      current = rise(current, currentYearlyIncreasePerMille);
      next = rise(next, newYearlyIncreasePerMille);
    }
    kept += current;
    switched += next;
    keep.add(kept);
    change.add(switched);
  }
  return ContractSwitch._(keep, change);
}
