import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('DeferredCardCycle', () {
    test('user scenario: cutoff 28, debit 4 of next month', () {
      // 1) Mid-cycle: 16 Nov 2026
      final midCycle = deferredCardCycle(
        LocalDate(2026, 11, 16),
        cutoffDay: 28,
        debitDay: 4,
      );
      expect(midCycle.start, equals(LocalDate(2026, 10, 29)));
      expect(midCycle.end, equals(LocalDate(2026, 11, 28)));
      expect(midCycle.debitDate, equals(LocalDate(2026, 12, 4)));
      expect(midCycle.hasPendingDebit, isFalse);
      expect(midCycle.contains(LocalDate(2026, 10, 29)), isTrue);
      expect(midCycle.contains(LocalDate(2026, 11, 16)), isTrue);
      expect(midCycle.contains(LocalDate(2026, 11, 28)), isTrue);
      expect(midCycle.contains(LocalDate(2026, 10, 28)), isFalse);
      expect(midCycle.contains(LocalDate(2026, 11, 29)), isFalse);

      // 2) Cutoff day: 28 Nov 2026
      final cutoffDay = deferredCardCycle(
        LocalDate(2026, 11, 28),
        cutoffDay: 28,
        debitDay: 4,
      );
      expect(cutoffDay.start, equals(LocalDate(2026, 10, 29)));
      expect(cutoffDay.end, equals(LocalDate(2026, 11, 28)));
      expect(cutoffDay.hasPendingDebit, isFalse);

      // 3) Day after cutoff: 29 Nov 2026 (new active cycle, previous cycle pending debit)
      final afterCutoff = deferredCardCycle(
        LocalDate(2026, 11, 29),
        cutoffDay: 28,
        debitDay: 4,
      );
      expect(afterCutoff.start, equals(LocalDate(2026, 11, 29)));
      expect(afterCutoff.end, equals(LocalDate(2026, 12, 28)));
      expect(afterCutoff.debitDate, equals(LocalDate(2027, 1, 4)));
      expect(afterCutoff.hasPendingDebit, isTrue);
      expect(afterCutoff.pendingDebitStart, equals(LocalDate(2026, 10, 29)));
      expect(afterCutoff.pendingDebitEnd, equals(LocalDate(2026, 11, 28)));
      expect(afterCutoff.pendingDebitDate, equals(LocalDate(2026, 12, 4)));
      expect(afterCutoff.contains(LocalDate(2026, 11, 29)), isTrue);
      expect(afterCutoff.containsPending(LocalDate(2026, 11, 15)), isTrue);
      expect(afterCutoff.containsPending(LocalDate(2026, 11, 28)), isTrue);
      expect(afterCutoff.containsPending(LocalDate(2026, 11, 29)), isFalse);

      // 4) On debit day: 4 Dec 2026
      final onDebitDay = deferredCardCycle(
        LocalDate(2026, 12, 4),
        cutoffDay: 28,
        debitDay: 4,
      );
      expect(onDebitDay.start, equals(LocalDate(2026, 11, 29)));
      expect(onDebitDay.end, equals(LocalDate(2026, 12, 28)));
      expect(onDebitDay.hasPendingDebit, isTrue);
      expect(onDebitDay.pendingDebitDate, equals(LocalDate(2026, 12, 4)));

      // 5) Day after debit day: 5 Dec 2026 (pending debit has cleared)
      final afterDebitDay = deferredCardCycle(
        LocalDate(2026, 12, 5),
        cutoffDay: 28,
        debitDay: 4,
      );
      expect(afterDebitDay.start, equals(LocalDate(2026, 11, 29)));
      expect(afterDebitDay.end, equals(LocalDate(2026, 12, 28)));
      expect(afterDebitDay.hasPendingDebit, isFalse);
    });

    test('month end cutoff (day 31) handles variable month lengths', () {
      // February 2026 has 28 days
      final feb = deferredCardCycle(
        LocalDate(2026, 2, 10),
        cutoffDay: 31,
        debitDay: 5,
      );
      // Clamped to 28 Feb
      expect(feb.start, equals(LocalDate(2026, 2, 1)));
      expect(feb.end, equals(LocalDate(2026, 2, 28)));
      expect(feb.debitDate, equals(LocalDate(2026, 3, 5)));

      // April 2026 has 30 days
      final apr = deferredCardCycle(
        LocalDate(2026, 4, 15),
        cutoffDay: 31,
        debitDay: 1,
      );
      expect(apr.start, equals(LocalDate(2026, 4, 1)));
      expect(apr.end, equals(LocalDate(2026, 4, 30)));
      expect(apr.debitDate, equals(LocalDate(2026, 5, 1)));
    });

    test('same-month debit day (cutoff 15, debit 25)', () {
      final cycle = deferredCardCycle(
        LocalDate(2026, 11, 10),
        cutoffDay: 15,
        debitDay: 25,
      );
      expect(cycle.start, equals(LocalDate(2026, 10, 16)));
      expect(cycle.end, equals(LocalDate(2026, 11, 15)));
      expect(cycle.debitDate, equals(LocalDate(2026, 11, 25)));
    });

    test('clamping of invalid days', () {
      final cycle = deferredCardCycle(
        LocalDate(2026, 11, 10),
        cutoffDay: 50,
        debitDay: -5,
      );
      // Cutoff clamped to 31 (so Nov 30), debitDay clamped to 1 (Dec 1)
      expect(cycle.end, equals(LocalDate(2026, 11, 30)));
      expect(cycle.debitDate, equals(LocalDate(2026, 12, 1)));
    });
  });
}
