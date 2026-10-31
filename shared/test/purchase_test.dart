import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  final today = LocalDate(2026, 10, 10);
  final date = LocalDate(2026, 10, 15);

  group('purchase payments', () {
    test('cash, 3 and 4 times (rounded up, the last settles), next month', () {
      expect(purchasePayments(PurchaseOption.none, 60000, date), isEmpty);
      final cash = purchasePayments(PurchaseOption.cash, 60000, date);
      expect([for (final p in cash) (p.date, p.amountCents)], [(date, 60000)]);
      final three = purchasePayments(PurchaseOption.threeTimes, 10000, date);
      expect(
        [for (final p in three) (p.date, p.amountCents)],
        [
          (date, 3334),
          (LocalDate(2026, 11, 15), 3334),
          (LocalDate(2026, 12, 15), 3332),
        ],
      );
      final four = purchasePayments(PurchaseOption.fourTimes, 10002, date);
      expect(four.map((p) => p.amountCents), [2501, 2501, 2501, 2499]);
      expect(four.last.date, LocalDate(2027, 1, 15));
      final later = purchasePayments(PurchaseOption.nextMonth, 60000, date);
      expect(later.single.date, LocalDate(2026, 11, 15));
      expect(
        () => purchasePayments(PurchaseOption.cash, 0, date),
        throwsArgumentError,
      );
    });

    test('31st: instalments keep the end of the month', () {
      final p = purchasePayments(
        PurchaseOption.threeTimes,
        300,
        LocalDate(2027, 1, 31),
      );
      expect(p.map((x) => x.date), [
        LocalDate(2027, 1, 31),
        LocalDate(2027, 2, 28),
        LocalDate(2027, 3, 31),
      ]);
    });

    test('horizon: the target or the last instalment', () {
      expect(
        purchaseHorizon(60000, date, LocalDate(2026, 11, 25)),
        LocalDate(2027, 1, 15),
      );
      expect(
        purchaseHorizon(60000, date, LocalDate(2027, 3, 1)),
        LocalDate(2027, 3, 1),
      );
    });
  });

  group('simulation', () {
    final salary = ScheduledOperation(
      id: 'salary',
      amountCents: 200000,
      label: 'Salaire',
      recurrence: Recurrence(
        frequency: Frequency.monthly,
        start: LocalDate(2026, 10, 28),
      ),
    );
    final target = LocalDate(2026, 11, 25);
    final until = purchaseHorizon(60000, date, target);
    Forecast run(List<ScheduledOperation> extra) => computeForecast(
      currentBalanceCents: 40000,
      today: today,
      horizonDays: today.daysUntil(until),
      scheduled: [salary, ...extra],
    );

    test('side by side: balance on the day, low point, overdraft', () {
      final s = simulatePurchase(
        amountCents: 60000,
        date: date,
        target: target,
        until: until,
        forecast: run,
      );
      final by = {for (final x in s) x.option: x};
      expect(by[PurchaseOption.none]!.balanceOnTargetCents, 240000);
      expect(by[PurchaseOption.none]!.firstBelowThreshold, isNull);

      final cash = by[PurchaseOption.cash]!;
      expect(cash.balanceOnTargetCents, 180000);
      expect(cash.lowest.balanceCents, -20000);
      expect(cash.lowest.date, date);
      expect(cash.firstBelowThreshold, date);

      final three = by[PurchaseOption.threeTimes]!;
      expect(three.balanceOnTargetCents, 240000 - 40000);
      expect(three.firstBelowThreshold, isNull);
      expect(three.lowest.balanceCents, 20000);

      final later = by[PurchaseOption.nextMonth]!;
      expect(later.balanceOnTargetCents, 180000);
      expect(later.firstBelowThreshold, isNull);
    });

    test('a target outside the forecast is refused', () {
      expect(
        () => simulatePurchase(
          amountCents: 60000,
          date: date,
          target: LocalDate(2026, 10, 1),
          until: until,
          forecast: run,
        ),
        throwsArgumentError,
      );
    });
  });
}
