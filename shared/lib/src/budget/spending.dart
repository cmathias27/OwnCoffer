import '../categories.dart';
import '../local_date.dart';

/// A category as seen by the spending summary.
class SpendingCategory {
  final int id;
  final int? parentId;
  final StandardKind kind;
  const SpendingCategory(this.id, this.kind, {this.parentId});
}

/// An operation as seen by the spending summary.
class SpendingOperation {
  final LocalDate date;

  /// Signed: negative = debit.
  final int amountCents;
  final int? categoryId;

  /// One side of a transfer between two accounts of the group: excluded, as
  /// the other side cancels it.
  final bool internalTransfer;

  const SpendingOperation(
    this.date,
    this.amountCents, {
    this.categoryId,
    this.internalTransfer = false,
  });
}

/// Where the money came from and went, over a set of operations.
///
/// Amounts are positive "flows": money received for income, money spent for
/// expenses, money put aside for savings. A refund in an expense category
/// lowers that category's spending. Transfer categories and internal
/// transfers are left out, so nothing is counted twice.
class SpendingSummary {
  /// Income, unclassified credits included.
  final int incomeCents;

  /// Expenses, unclassified debits included.
  final int expenseCents;

  /// Net amount put aside (savings categories).
  final int savingsCents;

  final int unclassifiedCount;
  final int unclassifiedInCents;
  final int unclassifiedOutCents;

  /// Flow of each category, its sub-categories included.
  final Map<int, int> totals;

  /// Operations of each category, its sub-categories included.
  final Map<int, int> counts;

  const SpendingSummary({
    required this.incomeCents,
    required this.expenseCents,
    required this.savingsCents,
    required this.unclassifiedCount,
    required this.unclassifiedInCents,
    required this.unclassifiedOutCents,
    required this.totals,
    required this.counts,
  });

  /// What is left once expenses and savings are paid.
  int get netCents => incomeCents - expenseCents - savingsCents;
}

SpendingSummary summarizeSpending(
  Iterable<SpendingCategory> categories,
  Iterable<SpendingOperation> operations,
) {
  final byId = {for (final c in categories) c.id: c};
  var income = 0, expense = 0, savings = 0;
  var unclassified = 0, unIn = 0, unOut = 0;
  final totals = <int, int>{};
  final counts = <int, int>{};
  for (final op in operations) {
    if (op.internalTransfer) continue;
    final c = byId[op.categoryId];
    if (c == null) {
      unclassified++;
      if (op.amountCents > 0) {
        unIn += op.amountCents;
        income += op.amountCents;
      } else {
        unOut -= op.amountCents;
        expense -= op.amountCents;
      }
      continue;
    }
    final int flow;
    switch (c.kind) {
      case StandardKind.transfer:
        continue;
      case StandardKind.income:
        flow = op.amountCents;
        income += flow;
      case StandardKind.expense:
        flow = -op.amountCents;
        expense += flow;
      case StandardKind.savings:
        flow = -op.amountCents;
        savings += flow;
    }
    // The category and its ancestors (guarded against a cycle).
    SpendingCategory? node = c;
    final seen = <int>{};
    while (node != null && seen.add(node.id)) {
      totals[node.id] = (totals[node.id] ?? 0) + flow;
      counts[node.id] = (counts[node.id] ?? 0) + 1;
      node = byId[node.parentId];
    }
  }
  return SpendingSummary(
    incomeCents: income,
    expenseCents: expense,
    savingsCents: savings,
    unclassifiedCount: unclassified,
    unclassifiedInCents: unIn,
    unclassifiedOutCents: unOut,
    totals: totals,
    counts: counts,
  );
}
