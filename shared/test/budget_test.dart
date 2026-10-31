import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('periods', () {
    test('a week runs from Monday to Sunday', () {
      // Friday 31 October 2026.
      final w = Period.containing(PeriodKind.week, LocalDate(2026, 10, 31));
      expect(w.start, LocalDate(2026, 10, 26));
      expect(w.last, LocalDate(2026, 11, 1));
      expect(w.days, 7);
      expect(
        Period.containing(PeriodKind.week, LocalDate(2026, 10, 26)),
        w,
        reason: 'a Monday starts its own week',
      );
      expect(w.shift(-1).start, LocalDate(2026, 10, 19));
    });

    test('months and years, across the year end', () {
      final m = Period.containing(PeriodKind.month, LocalDate(2026, 2, 14));
      expect(m.start, LocalDate(2026, 2, 1));
      expect(m.end, LocalDate(2026, 3, 1));
      expect(m.days, 28);
      expect(m.shift(-2).start, LocalDate(2025, 12, 1));
      final y = Period.containing(PeriodKind.year, LocalDate(2024, 7, 1));
      expect(y.days, 366);
      expect(y.contains(LocalDate(2024, 12, 31)), isTrue);
      expect(y.contains(LocalDate(2025, 1, 1)), isFalse);
    });
  });

  group('spending summary', () {
    const food = 1, groceries = 2, restaurants = 3, salary = 4;
    const savings = 5, transfers = 6;
    final cats = [
      const SpendingCategory(food, StandardKind.expense),
      const SpendingCategory(groceries, StandardKind.expense, parentId: food),
      const SpendingCategory(restaurants, StandardKind.expense, parentId: food),
      const SpendingCategory(salary, StandardKind.income),
      const SpendingCategory(savings, StandardKind.savings),
      const SpendingCategory(transfers, StandardKind.transfer),
    ];
    final d = LocalDate(2026, 10, 5);

    test('expenses roll up into their parent; a refund lowers them', () {
      final s = summarizeSpending(cats, [
        SpendingOperation(d, -8000, categoryId: groceries),
        SpendingOperation(d, -2550, categoryId: restaurants),
        SpendingOperation(d, 1000, categoryId: groceries),
        SpendingOperation(d, 250000, categoryId: salary),
      ]);
      expect(s.totals[groceries], 7000);
      expect(s.totals[restaurants], 2550);
      expect(s.totals[food], 9550);
      expect(s.counts[food], 3);
      expect(s.expenseCents, 9550);
      expect(s.incomeCents, 250000);
      expect(s.netCents, 250000 - 9550);
    });

    test('transfers are left out; savings are counted apart', () {
      final s = summarizeSpending(cats, [
        SpendingOperation(d, -50000, categoryId: transfers),
        SpendingOperation(d, -20000, categoryId: savings),
        SpendingOperation(d, -3000, internalTransfer: true),
        SpendingOperation(d, 100000, categoryId: salary),
      ]);
      expect(s.expenseCents, 0);
      expect(s.savingsCents, 20000);
      expect(s.totals.containsKey(transfers), isFalse);
      expect(s.netCents, 80000);
    });

    test('unclassified operations count by their direction', () {
      final s = summarizeSpending(cats, [
        SpendingOperation(d, -1234),
        SpendingOperation(d, 500),
        SpendingOperation(d, -66, categoryId: 999),
      ]);
      expect(s.unclassifiedCount, 3);
      expect(s.unclassifiedOutCents, 1300);
      expect(s.unclassifiedInCents, 500);
      expect(s.expenseCents, 1300);
      expect(s.incomeCents, 500);
    });

    test('a parent cycle does not loop', () {
      final s = summarizeSpending(
        [
          const SpendingCategory(1, StandardKind.expense, parentId: 2),
          const SpendingCategory(2, StandardKind.expense, parentId: 1),
        ],
        [SpendingOperation(d, -100, categoryId: 1)],
      );
      expect(s.totals, {1: 100, 2: 100});
    });
  });

  group('goals', () {
    test('green under 80 %, orange up to 100 %, red over', () {
      expect(goalLevel(7999, 10000), GoalLevel.ok);
      expect(goalLevel(8000, 10000), GoalLevel.warning);
      expect(goalLevel(10000, 10000), GoalLevel.warning);
      expect(goalLevel(10001, 10000), GoalLevel.over);
      expect(goalLevel(-500, 10000), GoalLevel.ok, reason: 'refunds');
    });

    test('suggestion: average of previous months, rounded up to 10 €', () {
      expect(suggestedGoal([30000, 32000, 35100]), 33000);
      expect(suggestedGoal([30000]), 30000);
      expect(suggestedGoal([30001]), 31000);
      expect(suggestedGoal([]), isNull);
      expect(suggestedGoal([0, 0]), isNull);
    });
  });

  group('subscriptions', () {
    test('monthly equivalent of each frequency', () {
      expect(monthlyEquivalentCents(-1399, Frequency.monthly, 1), -1399);
      expect(monthlyEquivalentCents(-12000, Frequency.yearly, 1), -1000);
      expect(monthlyEquivalentCents(-1000, Frequency.weekly, 1), -4333);
      expect(monthlyEquivalentCents(-3000, Frequency.monthly, 3), -1000);
      expect(monthlyEquivalentCents(-4999, Frequency.once, 1), 0);
      expect(monthlyEquivalentCents(-1, Frequency.yearly, 1), 0);
    });
  });
}
