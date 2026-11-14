/// Expenses shared between the members of a group, and the common pot
/// split by income (decision 0050). Members are identified by any string.
library;

/// One expense paid by [paidBy] for [participants] (split equally), or a
/// repayment: [paidBy] gives [amountCents] to the single participant.
class SharedEntry {
  final String paidBy;
  final int amountCents;
  final List<String> participants;
  const SharedEntry(this.paidBy, this.amountCents, this.participants);
}

/// [amountCents] split equally between [people] (sorted), the cents left
/// going one by one to the first ones.
Map<String, int> equalShares(int amountCents, List<String> people) {
  final sorted = {...people}.toList()..sort();
  if (sorted.isEmpty) return const {};
  final base = amountCents ~/ sorted.length;
  var rest = amountCents - base * sorted.length;
  return {
    for (final p in sorted) p: base + (rest-- > 0 ? 1 : 0),
  };
}

/// What each member is owed (positive) or owes (negative); the sum is 0.
Map<String, int> sharedBalances(List<SharedEntry> entries) {
  final balance = <String, int>{};
  for (final e in entries) {
    if (e.participants.isEmpty || e.amountCents <= 0) continue;
    balance[e.paidBy] = (balance[e.paidBy] ?? 0) + e.amountCents;
    equalShares(e.amountCents, e.participants).forEach((p, share) {
      balance[p] = (balance[p] ?? 0) - share;
    });
  }
  return balance;
}

/// A repayment that settles the balances.
class Settlement {
  final String from;
  final String to;
  final int amountCents;
  const Settlement(this.from, this.to, this.amountCents);

  @override
  bool operator ==(Object other) =>
      other is Settlement &&
      other.from == from &&
      other.to == to &&
      other.amountCents == amountCents;

  @override
  int get hashCode => Object.hash(from, to, amountCents);

  @override
  String toString() => '$from → $to: $amountCents';
}

/// Few repayments that bring every balance to 0: the biggest debtor pays
/// the biggest creditor, again and again (ties by name).
List<Settlement> settle(Map<String, int> balances) {
  final owed = [
    for (final e in balances.entries)
      if (e.value > 0) [e.key, e.value],
  ];
  final owing = [
    for (final e in balances.entries)
      if (e.value < 0) [e.key, -e.value],
  ];
  int order(List<Object> a, List<Object> b) {
    final c = (b[1] as int).compareTo(a[1] as int);
    return c != 0 ? c : (a[0] as String).compareTo(b[0] as String);
  }

  final result = <Settlement>[];
  while (owed.isNotEmpty && owing.isNotEmpty) {
    owed.sort(order);
    owing.sort(order);
    final to = owed.first, from = owing.first;
    final amount = (to[1] as int) < (from[1] as int)
        ? to[1] as int
        : from[1] as int;
    result.add(Settlement(from[0] as String, to[0] as String, amount));
    to[1] = (to[1] as int) - amount;
    from[1] = (from[1] as int) - amount;
    owed.removeWhere((x) => x[1] == 0);
    owing.removeWhere((x) => x[1] == 0);
  }
  return result;
}

/// [totalCents] split in proportion to [incomes] (largest remainders, so
/// the shares add up exactly); equally when no income is known.
Map<String, int> prorata(int totalCents, Map<String, int> incomes) {
  final people = incomes.keys.toList()..sort();
  if (people.isEmpty) return const {};
  final positive = {
    for (final p in people) p: (incomes[p] ?? 0) > 0 ? incomes[p]! : 0,
  };
  final sum = positive.values.fold(0, (a, b) => a + b);
  if (sum == 0) return equalShares(totalCents, people);
  final shares = <String, int>{};
  final remainders = <String, int>{};
  var given = 0;
  for (final p in people) {
    final exact = totalCents * positive[p]!;
    shares[p] = exact ~/ sum;
    remainders[p] = exact % sum;
    given += shares[p]!;
  }
  final order = people.toList()
    ..sort((a, b) {
      final c = remainders[b]!.compareTo(remainders[a]!);
      return c != 0 ? c : a.compareTo(b);
    });
  for (var i = 0; i < totalCents - given; i++) {
    shares[order[i % order.length]] = shares[order[i % order.length]]! + 1;
  }
  return shares;
}
