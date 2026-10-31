import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  test('notable rises and drops: thresholds in euros and percent', () {
    final now = {1: 30000, 2: 10500, 3: 1000, 4: 5000, 5: 0};
    final avg = {1: 20000, 2: 10000, 3: 0, 4: 10000, 5: 3000};
    final rises = notableChanges(now, avg, [1, 2, 3, 4, 5]);
    expect([for (final c in rises) c.categoryId], [1]);
    expect(rises.single.deltaCents, 10000);
    expect(rises.single.percent, 50);
    // 3: +10 € only; 2: +5 %.
    final drops = notableChanges(now, avg, [1, 2, 3, 4, 5], rises: false);
    expect([for (final c in drops) c.categoryId], [4, 5]);
    expect(notableChanges(now, avg, [1, 2], limit: 0), isEmpty);
    // New spending with no history counts as a rise.
    expect(
      notableChanges({7: 5000}, {}, [7]).single.percent,
      isNull,
    );
  });

  test('split: two parts or more, same sign, exact sum', () {
    expect(isValidSplit(-10000, [-6000, -4000]), isTrue);
    expect(isValidSplit(-10000, [-6000, -4001]), isFalse);
    expect(isValidSplit(-10000, [-10000]), isFalse);
    expect(isValidSplit(-10000, [-11000, 1000]), isFalse);
    expect(isValidSplit(-10000, [-10000, 0]), isFalse);
    expect(isValidSplit(5000, [2500, 2500]), isTrue);
    expect(isValidSplit(0, [0, 0]), isFalse);
  });

  test('left to live until the last day of the budget month', () {
    final l = LeftToLive(
      today: LocalDate(2026, 11, 17),
      last: LocalDate(2026, 11, 26),
      balanceCents: 120000,
      plannedDebitsCents: -45000,
      plannedCreditsCents: 5000,
    );
    expect(l.leftCents, 80000);
    expect(l.daysLeft, 10);
    expect(l.perDayCents, 8000);
    final none = LeftToLive(
      today: LocalDate(2026, 11, 17),
      last: LocalDate(2026, 11, 26),
      balanceCents: 1000,
      plannedDebitsCents: -5000,
      plannedCreditsCents: 0,
    );
    expect(none.leftCents, -4000);
    expect(none.perDayCents, 0);
  });

  test('occurrence status', () {
    final today = LocalDate(2026, 11, 17);
    OccurrenceStatus s(int day, {bool linked = false, int? next}) =>
        occurrenceStatus(
          due: LocalDate(2026, 11, day),
          today: today,
          linked: linked,
          nextDue: next == null ? null : LocalDate(2026, 11, next),
        );
    expect(s(5, linked: true), OccurrenceStatus.paid);
    expect(s(5, next: 10), OccurrenceStatus.skipped);
    expect(s(12, next: 10), OccurrenceStatus.late);
    expect(s(17), OccurrenceStatus.upcoming);
    expect(s(25), OccurrenceStatus.upcoming);
  });
}
