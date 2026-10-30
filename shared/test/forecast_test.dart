import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

LocalDate d(int y, int m, int day) => LocalDate(y, m, day);

void main() {
  group('Recurrence', () {
    test('monthly on the 31st never drifts', () {
      final r = Recurrence(frequency: Frequency.monthly, start: d(2026, 1, 31));
      expect(r.between(d(2026, 1, 1), d(2026, 6, 30)), [
        d(2026, 1, 31),
        d(2026, 2, 28),
        d(2026, 3, 31),
        d(2026, 4, 30),
        d(2026, 5, 31),
        d(2026, 6, 30),
      ]);
    });

    test('quarterly, yearly on 29 February, weekly', () {
      final q = Recurrence(
        frequency: Frequency.monthly,
        interval: 3,
        start: d(2026, 1, 15),
      );
      expect(q.between(d(2026, 2, 1), d(2027, 1, 15)), [
        d(2026, 4, 15),
        d(2026, 7, 15),
        d(2026, 10, 15),
        d(2027, 1, 15),
      ]);
      final leap = Recurrence(
        frequency: Frequency.yearly,
        start: d(2028, 2, 29),
      );
      expect(leap.between(d(2028, 1, 1), d(2032, 12, 31)), [
        d(2028, 2, 29),
        d(2029, 2, 28),
        d(2030, 2, 28),
        d(2031, 2, 28),
        d(2032, 2, 29),
      ]);
      final w = Recurrence(
        frequency: Frequency.weekly,
        interval: 2,
        start: d(2026, 10, 2),
      );
      expect(w.between(d(2026, 10, 10), d(2026, 11, 10)), [
        d(2026, 10, 16),
        d(2026, 10, 30),
      ]);
    });

    test('end date, count and one-off', () {
      final r = Recurrence(
        frequency: Frequency.monthly,
        start: d(2026, 1, 5),
        end: d(2026, 3, 5),
      );
      expect(r.between(d(2025, 1, 1), d(2027, 1, 1)), hasLength(3));
      final c = Recurrence(
        frequency: Frequency.monthly,
        start: d(2026, 1, 5),
        count: 4,
      );
      expect(c.between(d(2025, 1, 1), d(2027, 1, 1)).last, d(2026, 4, 5));
      final once = Recurrence.once(d(2026, 11, 3));
      expect(once.between(d(2026, 1, 1), d(2027, 1, 1)), [d(2026, 11, 3)]);
      expect(once.nextAfter(d(2026, 11, 3)), isNull);
    });

    test('far from the start gives the same result as iterating', () {
      final r = Recurrence(frequency: Frequency.monthly, start: d(2000, 1, 31));
      final all = r.between(d(2000, 1, 1), d(2030, 12, 31));
      final window = r.between(d(2026, 2, 1), d(2026, 4, 30));
      expect(
        window,
        all.where((x) => x >= d(2026, 2, 1) && x <= d(2026, 4, 30)),
      );
      expect(r.nextAfter(d(2026, 2, 28)), d(2026, 3, 31));
    });

    test('invalid recurrences', () {
      expect(
        () => Recurrence(
          frequency: Frequency.monthly,
          start: d(2026, 1, 1),
          interval: 0,
        ),
        throwsArgumentError,
      );
      expect(
        () => Recurrence(
          frequency: Frequency.monthly,
          start: d(2026, 2, 1),
          end: d(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });
  });

  group('computeForecast', () {
    final today = d(2026, 10, 20);
    ScheduledOperation monthly(
      Object id,
      int cents,
      LocalDate start, {
      LocalDate? nextDue,
    }) => ScheduledOperation(
      id: id,
      amountCents: cents,
      label: '$id',
      recurrence: Recurrence(frequency: Frequency.monthly, start: start),
      nextDue: nextDue,
    );

    test('day-by-day balance, low point and overdraft alert', () {
      final f = computeForecast(
        currentBalanceCents: 30000,
        today: today,
        scheduled: [
          monthly('rent', -65000, d(2026, 1, 1), nextDue: d(2026, 11, 1)),
          monthly('salary', 215035, d(2026, 1, 2), nextDue: d(2026, 11, 2)),
          monthly('phone', -1999, d(2026, 1, 25), nextDue: d(2026, 10, 25)),
        ],
      );
      expect(f.days, hasLength(31));
      expect(f.balanceOn(today), 30000);
      expect(f.balanceOn(d(2026, 10, 25)), 28001);
      expect(f.balanceOn(d(2026, 11, 1)), 28001 - 65000);
      expect(f.balanceOn(d(2026, 11, 2)), 28001 - 65000 + 215035);
      expect(f.lowest.date, d(2026, 11, 1));
      expect(f.lowest.balanceCents, -36999);
      expect(f.overdraftExpected, isTrue);
      expect(f.firstBelowThreshold!.date, d(2026, 11, 1));
      expect(f.endBalanceCents, 30000 - 1999 - 65000 + 215035);
    });

    test('authorised overdraft threshold', () {
      final f = computeForecast(
        currentBalanceCents: 10000,
        today: today,
        scheduled: [monthly('x', -30000, d(2026, 10, 22))],
        alertThresholdCents: -50000,
      );
      expect(f.overdraftExpected, isFalse);
      expect(f.lowest.balanceCents, -20000);
    });

    test('debit and credit on the same day: debit counted first', () {
      final f = computeForecast(
        currentBalanceCents: 0,
        today: today,
        scheduled: [
          monthly('in', 1000, d(2026, 10, 21)),
          monthly('out', -1000, d(2026, 10, 21)),
        ],
      );
      expect(f.events.map((e) => e.amountCents), [-1000, 1000]);
      expect(f.balanceOn(d(2026, 10, 21)), 0);
    });

    test('late occurrences: counted today within grace, missed beyond', () {
      final f = computeForecast(
        currentBalanceCents: 100000,
        today: today,
        horizonDays: 5,
        scheduled: [
          monthly('late', -5000, d(2026, 1, 15), nextDue: d(2026, 10, 15)),
          monthly('old', -7000, d(2026, 1, 1), nextDue: d(2026, 10, 1)),
        ],
      );
      expect(f.balanceOn(today), 95000);
      expect(f.events.first.isLate, isTrue);
      expect(f.events.first.dueDate, d(2026, 10, 15));
      expect(f.missed.single.dueDate, d(2026, 10, 1));
    });

    test('future-dated real operations are included', () {
      final f = computeForecast(
        currentBalanceCents: 0,
        today: today,
        scheduled: const [],
        futureOperations: [
          RealOperation(
            id: 1,
            date: d(2026, 10, 31),
            amountCents: -12345,
            label: cleanLabel('CB DEBIT DIFFERE'),
          ),
          RealOperation(
            id: 2,
            date: d(2026, 10, 1),
            amountCents: -999,
            label: cleanLabel('PAST'),
          ),
        ],
      );
      expect(f.endBalanceCents, -12345);
    });

    test('no scheduled operation: flat balance', () {
      final f = computeForecast(
        currentBalanceCents: 4242,
        today: today,
        scheduled: const [],
      );
      expect(f.days.every((x) => x.balanceCents == 4242), isTrue);
      expect(f.overdraftExpected, isFalse);
    });
  });

  group('computeBalances', () {
    test('cleared, current and all real', () {
      final b = computeBalances(
        initialBalanceCents: 100000,
        today: d(2026, 10, 20),
        operations: [
          BalanceInput(d(2026, 10, 1), -65000, cleared: true),
          BalanceInput(d(2026, 10, 2), 215035),
          BalanceInput(d(2026, 10, 31), -12345),
        ],
      );
      expect(b.clearedCents, 35000);
      expect(b.currentCents, 250035);
      expect(b.allRealCents, 237690);
    });
  });

  group('reconcile', () {
    final today = d(2026, 11, 5);
    RealOperation op(Object id, LocalDate date, int cents, String label) =>
        RealOperation(
          id: id,
          date: date,
          amountCents: cents,
          label: cleanLabel(label),
        );

    test('exact rent found two days late', () {
      final rent = ScheduledOperation(
        id: 'rent',
        amountCents: -65000,
        label: 'Loyer',
        matchPattern: 'AGENCE LOGEMENT',
        recurrence: Recurrence(
          frequency: Frequency.monthly,
          start: d(2026, 1, 1),
        ),
        nextDue: d(2026, 11, 1),
      );
      final m = reconcile(
        scheduled: [rent],
        unlinkedOperations: [
          op(1, d(2026, 11, 3), -65000, 'PRLV SEPA AGENCE LOGEMENT EXEMPLE'),
          op(2, d(2026, 11, 3), -4500, 'CB CARREFOUR'),
        ],
        today: today,
      );
      expect(m.single.operationId, 1);
      expect(m.single.dueDate, d(2026, 11, 1));
      expect(m.single.exact, isTrue);
    });

    test('variable bill within tolerance needs the label', () {
      final edf = ScheduledOperation(
        id: 'edf',
        amountCents: -7000,
        label: 'Électricité',
        matchPattern: 'EDF',
        amountTolerancePercent: 15,
        recurrence: Recurrence(
          frequency: Frequency.monthly,
          start: d(2026, 1, 6),
        ),
        nextDue: d(2026, 11, 6),
      );
      final m = reconcile(
        scheduled: [edf],
        unlinkedOperations: [
          op(1, d(2026, 11, 6), -7400, 'CB AUTRE CHOSE'),
          op(2, d(2026, 11, 7), -7900, 'PRLV SEPA EDF SA'),
          op(3, d(2026, 11, 6), -8100, 'PRLV SEPA EDF SA'),
        ],
        today: today,
      );
      expect(m.single.operationId, 2);
      expect(m.single.exact, isFalse);
    });

    test('two identical subscriptions get two different operations', () {
      ScheduledOperation sub(String id) => ScheduledOperation(
        id: id,
        amountCents: -999,
        label: id,
        recurrence: Recurrence(
          frequency: Frequency.monthly,
          start: d(2026, 1, 3),
        ),
        nextDue: d(2026, 11, 3),
      );
      final m = reconcile(
        scheduled: [sub('a'), sub('b')],
        unlinkedOperations: [
          op(1, d(2026, 11, 3), -999, 'X'),
          op(2, d(2026, 11, 4), -999, 'Y'),
        ],
        today: today,
      );
      expect(m.map((x) => x.operationId).toSet(), {1, 2});
      expect(m.map((x) => x.scheduledId).toSet(), {'a', 'b'});
    });

    test('opposite sign or too far: no match', () {
      final s = ScheduledOperation(
        id: 's',
        amountCents: -1000,
        label: 's',
        recurrence: Recurrence.once(d(2026, 11, 1)),
      );
      final m = reconcile(
        scheduled: [s],
        unlinkedOperations: [
          op(1, d(2026, 11, 1), 1000, 'X'),
          op(2, d(2026, 10, 20), -1000, 'Y'),
        ],
        today: today,
      );
      expect(m, isEmpty);
    });
  });
}
