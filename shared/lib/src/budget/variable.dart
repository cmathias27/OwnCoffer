/// Variable spending (groceries, fuel, outings…) estimated from the previous
/// months, for the balance forecast (cahier des charges : prévision des
/// dépenses variables).
library;

import '../categories.dart';
import '../local_date.dart';
import 'period.dart';
import 'spending.dart';

/// What one category usually costs in a month.
class VariableCategory {
  /// Null for unclassified debits.
  final int? categoryId;

  /// Spending of each month used, oldest first (never negative).
  final List<int> monthsCents;

  /// Median of [monthsCents]: one exceptional month does not count.
  final int monthlyCents;

  const VariableCategory(this.categoryId, this.monthsCents, this.monthlyCents);
}

class VariableEstimate {
  /// Largest first; categories with a zero median are left out.
  final List<VariableCategory> categories;

  /// Sum of the categories' medians.
  final int monthlyCents;

  /// Complete months the estimate is based on (0: not enough history).
  final List<Period> months;

  /// Variable spending already done in the current month.
  final int spentThisMonthCents;

  const VariableEstimate({
    required this.categories,
    required this.monthlyCents,
    required this.months,
    required this.spentThisMonthCents,
  });

  /// Still expected this month: the usual amount minus what is spent.
  int get leftThisMonthCents =>
      (monthlyCents - spentThisMonthCents).clamp(0, monthlyCents);
}

/// Expense flow of [op] if it is variable spending: an expense (or an
/// unclassified debit) that does not realise a planned operation and is not
/// a transfer between the group's accounts. Refunds count negatively.
int? _variableFlow(Map<int, SpendingCategory> byId, SpendingOperation op) {
  if (op.planned || op.internalTransfer) return null;
  final c = byId[op.categoryId];
  if (c == null) return op.amountCents < 0 ? -op.amountCents : null;
  return c.kind == StandardKind.expense ? -op.amountCents : null;
}

/// Estimates the variable spending of a month from up to [count] complete
/// months before [current], each category on its own median. Months that
/// start before [historyStart] (the first known operation) are not used: an
/// account imported in the middle of a month would look cheap.
VariableEstimate estimateVariableSpending({
  required Iterable<SpendingCategory> categories,
  required Iterable<SpendingOperation> operations,
  required Period current,
  required LocalDate today,
  LocalDate? historyStart,
  int count = 3,
}) {
  final byId = {for (final c in categories) c.id: c};
  final months = [
    for (var i = count; i >= 1; i--)
      if (historyStart != null && current.shift(-i).start >= historyStart)
        current.shift(-i),
  ];
  final perCategory = <int?, List<int>>{};
  var spent = 0;
  for (final op in operations) {
    final flow = _variableFlow(byId, op);
    if (flow == null) continue;
    if (current.contains(op.date) && op.date <= today) {
      spent += flow;
      continue;
    }
    final m = months.indexWhere((p) => p.contains(op.date));
    if (m < 0) continue;
    final values = perCategory.putIfAbsent(
      op.categoryId != null && byId.containsKey(op.categoryId)
          ? op.categoryId
          : null,
      () => List.filled(months.length, 0),
    );
    values[m] += flow;
  }
  final result = <VariableCategory>[];
  for (final MapEntry(key: id, value: values) in perCategory.entries) {
    final clean = [for (final v in values) v < 0 ? 0 : v];
    final median = _median(clean);
    if (median > 0) result.add(VariableCategory(id, clean, median));
  }
  result.sort((a, b) => b.monthlyCents.compareTo(a.monthlyCents));
  return VariableEstimate(
    categories: result,
    monthlyCents: result.fold(0, (a, c) => a + c.monthlyCents),
    months: months,
    spentThisMonthCents: spent < 0 ? 0 : spent,
  );
}

int _median(List<int> values) {
  if (values.isEmpty) return 0;
  final s = [...values]..sort();
  final mid = s.length ~/ 2;
  return s.length.isOdd ? s[mid] : (s[mid - 1] + s[mid]) ~/ 2;
}

/// Spreads the estimate evenly over the days after [today] up to [until]:
/// what is left of the current month over its remaining days, then the
/// usual amount over each following month. Rounding never loses a cent.
Map<LocalDate, int> spreadVariableSpending(
  VariableEstimate estimate, {
  required Period current,
  required LocalDate today,
  required LocalDate until,
}) {
  final result = <LocalDate, int>{};
  void spread(int total, LocalDate from, LocalDate last) {
    final n = from.daysUntil(last) + 1;
    if (total <= 0 || n <= 0) return;
    for (var i = 0; i < n; i++) {
      final day = from.addDays(i);
      if (day > until) break;
      final cents = total * (i + 1) ~/ n - total * i ~/ n;
      if (cents != 0) result[day] = cents;
    }
  }

  spread(estimate.leftThisMonthCents, today.addDays(1), current.last);
  for (var m = current.shift(1); m.start <= until; m = m.shift(1)) {
    spread(estimate.monthlyCents, m.start, m.last);
  }
  return result;
}
