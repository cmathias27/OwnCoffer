import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  const food = 1, fuel = 2, rent = 3, salary = 4, transfer = 5;
  const categories = [
    SpendingCategory(food, StandardKind.expense),
    SpendingCategory(fuel, StandardKind.expense),
    SpendingCategory(rent, StandardKind.expense),
    SpendingCategory(salary, StandardKind.income),
    SpendingCategory(transfer, StandardKind.transfer),
  ];
  final today = LocalDate(2026, 10, 10);
  final current = Period.containing(PeriodKind.month, today);
  SpendingOperation op(
    int m,
    int d,
    int cents,
    int? category, {
    bool planned = false,
    bool internal = false,
  }) => SpendingOperation(
    LocalDate(2026, m, d),
    cents,
    categoryId: category,
    planned: planned,
    internalTransfer: internal,
  );

  group('variable spending estimate', () {
    test('median of the three last months, per category', () {
      final e = estimateVariableSpending(
        categories: categories,
        operations: [
          op(7, 5, -30000, food),
          op(8, 5, -32000, food),
          // A big one-off month does not move the median.
          op(9, 5, -90000, food),
          op(7, 9, -6000, fuel),
          op(9, 9, -8000, fuel),
          // Planned, income, transfers: left out.
          op(9, 1, -70000, rent, planned: true),
          op(9, 1, 200000, salary),
          op(9, 2, -50000, transfer),
          op(9, 3, -40000, null, internal: true),
          // Unclassified debits: one bucket.
          op(8, 12, -1500, null),
          // This month, up to today.
          op(10, 3, -12000, food),
          op(10, 4, 2000, food),
        ],
        current: current,
        today: today,
        historyStart: LocalDate(2026, 6, 20),
      );
      expect(e.months.map((p) => p.start), [
        LocalDate(2026, 7, 1),
        LocalDate(2026, 8, 1),
        LocalDate(2026, 9, 1),
      ]);
      expect(e.categories.map((c) => c.categoryId), [food, fuel]);
      expect(e.categories.first.monthsCents, [30000, 32000, 90000]);
      expect(e.categories.first.monthlyCents, 32000);
      expect(e.categories[1].monthlyCents, 6000, reason: '0, 6000, 8000');
      expect(e.monthlyCents, 38000, reason: 'unclassified median is 0');
      expect(e.spentThisMonthCents, 10000, reason: 'refund lowers it');
      expect(e.leftThisMonthCents, 28000);
    });

    test('months before the first operation are not used', () {
      final e = estimateVariableSpending(
        categories: categories,
        operations: [op(8, 20, -10000, food), op(9, 5, -30000, food)],
        current: current,
        today: today,
        historyStart: LocalDate(2026, 8, 20),
      );
      expect(e.months.map((p) => p.start), [LocalDate(2026, 9, 1)]);
      expect(e.monthlyCents, 30000);
      final none = estimateVariableSpending(
        categories: categories,
        operations: const [],
        current: current,
        today: today,
      );
      expect(none.months, isEmpty);
      expect(none.monthlyCents, 0);
    });

    test('two months: the mean of both', () {
      final e = estimateVariableSpending(
        categories: categories,
        operations: [op(8, 5, -10000, food), op(9, 5, -20001, food)],
        current: current,
        today: today,
        historyStart: LocalDate(2026, 8, 1),
      );
      expect(e.monthlyCents, 15000);
    });

    test('spread: the rest of this month, then each month, to the cent', () {
      const e = VariableEstimate(
        categories: [],
        monthlyCents: 31000,
        months: [],
        spentThisMonthCents: 10000,
      );
      final days = spreadVariableSpending(
        e,
        current: current,
        today: today,
        until: LocalDate(2026, 11, 30),
      );
      expect(days.containsKey(today), isFalse, reason: 'today is spent');
      final october = [
        for (final MapEntry(:key, :value) in days.entries)
          if (key.month == 10) value,
      ];
      expect(october, hasLength(21));
      expect(october.fold(0, (a, b) => a + b), 21000);
      final november = [
        for (final MapEntry(:key, :value) in days.entries)
          if (key.month == 11) value,
      ];
      expect(november, hasLength(30));
      expect(november.fold(0, (a, b) => a + b), 31000);
      // Cut at the horizon.
      final short = spreadVariableSpending(
        e,
        current: current,
        today: today,
        until: LocalDate(2026, 10, 12),
      );
      expect(short.keys, [LocalDate(2026, 10, 11), LocalDate(2026, 10, 12)]);
      expect(short.values.fold(0, (a, b) => a + b), 2000);
    });

    test('forecast: the estimate comes off the balance day by day', () {
      final f = computeForecast(
        currentBalanceCents: 100000,
        today: today,
        horizonDays: 3,
        scheduled: const [],
        variableSpending: {
          LocalDate(2026, 10, 11): 1000,
          LocalDate(2026, 10, 13): 2000,
        },
      );
      expect(f.days.map((d) => d.balanceCents), [
        100000,
        99000,
        99000,
        97000,
      ]);
      expect(f.variableCents, 3000);
    });
  });
}
