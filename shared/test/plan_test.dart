import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  final today = LocalDate(2026, 11, 14);

  group('savings project', () {
    test('monthly amount to the target month, this month included', () {
      final p = projectPlan(
        targetCents: 300000,
        savedCents: 60000,
        today: today,
        targetDate: LocalDate(2027, 6, 30),
      );
      expect(p.remainingCents, 240000);
      expect(p.monthsLeft, 8, reason: 'November to June');
      expect(p.monthlyCents, 30000);
      expect(p.progressPerMille, 200);
      expect(p.reached, isFalse);
      expect(p.overdue, isFalse);
    });

    test('rounded up; reached; overdue; no date', () {
      expect(
        projectPlan(
          targetCents: 10000,
          savedCents: 0,
          today: today,
          targetDate: LocalDate(2027, 1, 1),
        ).monthlyCents,
        3334,
      );
      final reached = projectPlan(
        targetCents: 10000,
        savedCents: 12000,
        today: today,
        targetDate: LocalDate(2027, 1, 1),
      );
      expect(reached.reached, isTrue);
      expect(reached.monthlyCents, isNull);
      expect(reached.progressPerMille, 1000);
      final late = projectPlan(
        targetCents: 10000,
        savedCents: 2000,
        today: today,
        targetDate: LocalDate(2026, 10, 1),
      );
      expect(late.overdue, isTrue);
      expect(late.monthlyCents, isNull);
      final open = projectPlan(
        targetCents: 10000,
        savedCents: 2500,
        today: today,
      );
      expect(open.monthsLeft, isNull);
      expect(open.monthlyCents, isNull);
      expect(open.progressPerMille, 250);
    });
  });

  group('spread expenses', () {
    test('yearly: a twelfth a month, put aside since the last one', () {
      final s = smoothExpense(
        amountCents: 60000,
        frequency: Frequency.yearly,
        interval: 1,
        nextDue: LocalDate(2027, 2, 15),
        today: today,
      )!;
      expect(s.periodMonths, 12);
      expect(s.monthlyCents, 5000);
      expect(s.monthsUntil, 3);
      expect(s.setAsideCents, 45000, reason: '9 months of 12 gone');
    });

    test('quarterly; monthly and weekly need none', () {
      final q = smoothExpense(
        amountCents: 30001,
        frequency: Frequency.monthly,
        interval: 3,
        nextDue: today,
        today: today,
      )!;
      expect(q.periodMonths, 3);
      expect(q.monthlyCents, 10001);
      expect(q.setAsideCents, 30001);
      for (final (f, i) in [
        (Frequency.monthly, 1),
        (Frequency.weekly, 2),
        (Frequency.once, 1),
      ]) {
        expect(
          smoothExpense(
            amountCents: 1000,
            frequency: f,
            interval: i,
            nextDue: today,
            today: today,
          ),
          isNull,
        );
      }
    });
  });

  test('contract: next renewal and last day to cancel', () {
    final c = contractDates(
      renewal: LocalDate(2025, 12, 1),
      noticeDays: 30,
      today: today,
    );
    expect(c.renewal, LocalDate(2026, 12, 1));
    expect(c.deadline, LocalDate(2026, 11, 1));
    expect(c.daysToDeadline, -13);
    final later = contractDates(
      renewal: LocalDate(2027, 3, 1),
      noticeDays: 60,
      today: today,
    );
    expect(later.deadline, LocalDate(2026, 12, 31));
    expect(later.daysToDeadline, 47);
  });

  test('expected refund: same amount, received after, earliest first', () {
    final credits = [
      (LocalDate(2026, 11, 1), 2500),
      (LocalDate(2026, 11, 12), 2500),
      (LocalDate(2026, 11, 8), 2500),
      (LocalDate(2026, 11, 9), 2600),
    ];
    expect(
      matchRefund(
        amountCents: 2500,
        since: LocalDate(2026, 11, 5),
        credits: credits,
      ),
      2,
    );
    expect(
      matchRefund(amountCents: 999, since: today, credits: credits),
      isNull,
    );
  });

  group('regulated savings', () {
    test('ceilings', () {
      expect(regulatedCeilingCents(RegulatedSavings.livretA), 2295000);
      expect(regulatedCeilingCents(RegulatedSavings.ldds), 1200000);
    });

    test('fortnight rule: deposits wait, withdrawals stop at once', () {
      // 10 000 € all year at 2 %: 200 €.
      expect(
        fortnightInterest(
          openingCents: 1000000,
          movements: const [],
          year: 2026,
          rateBp: 200,
        ),
        20000,
      );
      // A deposit of 2 400 € on 10 January earns 23 fortnights of 24.
      expect(
        fortnightInterest(
          openingCents: 0,
          movements: [(LocalDate(2026, 1, 10), 240000)],
          year: 2026,
          rateBp: 200,
        ),
        4600,
      );
      // Deposited on the 16th: from 1 February, 22 fortnights.
      expect(
        fortnightInterest(
          openingCents: 0,
          movements: [(LocalDate(2026, 1, 16), 240000)],
          year: 2026,
          rateBp: 200,
        ),
        4400,
      );
      // A withdrawal on 20 December stops the last fortnight at once.
      expect(
        fortnightInterest(
          openingCents: 240000,
          movements: [(LocalDate(2026, 12, 20), -240000)],
          year: 2026,
          rateBp: 200,
        ),
        4600,
      );
      // Up to today only: 21 fortnights over on 14 November.
      expect(fortnightsOver(2026, today), 20);
      expect(
        fortnightInterest(
          openingCents: 240000,
          movements: const [],
          year: 2026,
          rateBp: 200,
          fortnights: fortnightsOver(2026, today),
        ),
        4000,
      );
    });
  });

  group('health', () {
    test('levels and score', () {
      final good = [
        emergencyIndicator(600000, 200000),
        savingsRateIndicator(300000, 250000),
        debtIndicator(80000, 300000),
        regularityIndicator(const [10, 0, 5, 3, -1, 8]),
      ];
      expect([for (final i in good) i.value], [30, 166, 266, 5]);
      expect(good.every((i) => i.level == HealthLevel.good), isTrue);
      expect(healthScore(good), 100);
      final mixed = [
        emergencyIndicator(100000, 200000),
        savingsRateIndicator(300000, 300000),
        debtIndicator(120000, 300000),
        savingsRateIndicator(0, 100),
      ];
      expect(
        [for (final i in mixed) i.level],
        [
          HealthLevel.weak,
          HealthLevel.fair,
          HealthLevel.weak,
          HealthLevel.unknown,
        ],
      );
      expect(healthScore(mixed), 17);
      expect(healthScore(const []), isNull);
      expect(debtIndicator(0, 0).level, HealthLevel.good);
      expect(regularityIndicator(const [1, 2]).level, HealthLevel.unknown);
    });
  });

  group('sharing', () {
    test('balances and few repayments', () {
      final b = sharedBalances(const [
        SharedEntry('anne', 9000, ['anne', 'bruno', 'chloe']),
        SharedEntry('bruno', 3000, ['anne', 'bruno']),
        SharedEntry('chloe', 1000, ['chloe', 'anne', 'bruno']),
      ]);
      expect(b.values.fold(0, (a, x) => a + x), 0);
      expect(b, {'anne': 4166, 'bruno': -1833, 'chloe': -2333});
      expect(settle(b), const [
        Settlement('chloe', 'anne', 2333),
        Settlement('bruno', 'anne', 1833),
      ]);
      // A repayment is an entry with one participant.
      final after = sharedBalances(const [
        SharedEntry('anne', 1000, ['anne', 'bruno']),
        SharedEntry('bruno', 500, ['anne']),
      ]);
      expect(after, {'anne': 0, 'bruno': 0});
      expect(settle(after), isEmpty);
    });

    test('equal shares: the extra cents to the first ones', () {
      expect(equalShares(100, const ['c', 'a', 'b']), {
        'a': 34,
        'b': 33,
        'c': 33,
      });
    });

    test('pot by income, exact to the cent', () {
      final p = prorata(150000, const {'anne': 300000, 'bruno': 200000});
      expect(p, {'anne': 90000, 'bruno': 60000});
      final odd = prorata(100, const {'a': 1, 'b': 1, 'c': 1});
      expect(odd.values.fold(0, (a, x) => a + x), 100);
      expect(prorata(1000, const {'a': 0, 'b': 0}), {'a': 500, 'b': 500});
    });
  });
}
