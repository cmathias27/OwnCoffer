import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  LoanTerms terms({
    int principal = 10000000,
    int rate = 1000,
    int months = 120,
    int insurance = 0,
  }) => LoanTerms(
    principalCents: principal,
    annualRateMilli: rate,
    months: months,
    firstDue: LocalDate(2026, 1, 31),
    insuranceMonthlyCents: insurance,
  );

  test('constant instalment of the usual formula', () {
    // Checked independently with exact decimal arithmetic.
    expect(loanPaymentCents(20000000, 3450, 240), 115479);
    expect(loanPaymentCents(10000000, 1000, 120), 87604);
    expect(loanPaymentCents(1000000, 5990, 48), 23480);
    expect(loanPaymentCents(1500000, 0, 36), 41667);
  });

  test('schedule: capital repaid exactly, last instalment settles '
      'rounding', () {
    final s = amortize(terms());
    expect(s, hasLength(120));
    expect(s.first.interestCents, 8333);
    expect(s.first.principalCents, 87604 - 8333);
    expect(s.last.remainingCents, 0);
    expect(s.fold(0, (a, i) => a + i.principalCents), 10000000);
    expect(s.fold(0, (a, i) => a + i.interestCents), 512494);
    for (final i in s.take(119)) {
      expect(i.paymentCents, 87604);
    }
    expect((s.last.paymentCents - 87604).abs(), lessThan(100));
  });

  test('due dates keep the day, clamped to the month end', () {
    final s = amortize(terms());
    expect(s[0].date, LocalDate(2026, 1, 31));
    expect(s[1].date, LocalDate(2026, 2, 28));
    expect(s[2].date, LocalDate(2026, 3, 31));
  });

  test('interest-free loan', () {
    final s = amortize(terms(principal: 1500000, rate: 0, months: 36));
    expect(s, hasLength(36));
    expect(s.every((i) => i.interestCents == 0), isTrue);
    expect(s.fold(0, (a, i) => a + i.principalCents), 1500000);
    expect(s.last.remainingCents, 0);
  });

  test('status on a given day', () {
    final t = terms(insurance: 1500);
    final s = amortize(t);
    final before = loanStatus(t, s, LocalDate(2026, 1, 30));
    expect(before.paidCount, 0);
    expect(before.remainingCents, 10000000);
    expect(before.next!.number, 1);

    final mid = loanStatus(t, s, LocalDate(2026, 3, 31));
    expect(mid.paidCount, 3);
    expect(mid.remainingCents, s[2].remainingCents);
    expect(mid.interestPaidCents + mid.interestRemainingCents, 512494);
    expect(mid.insurancePaidCents, 4500);
    expect(mid.costCents, 512494 + 120 * 1500);
    expect(mid.next!.date, LocalDate(2026, 4, 30));
    expect(
      mid.repaidPerMille(10000000),
      (10000000 - s[2].remainingCents) * 1000 ~/ 10000000,
    );

    final after = loanStatus(t, s, LocalDate(2040, 1, 1));
    expect(after.finished, isTrue);
    expect(after.remainingCents, 0);
    expect(after.endDate, LocalDate(2035, 12, 31));
  });

  test('early repayment keeps the instalment and ends sooner', () {
    final t = terms();
    final r = simulateEarlyRepayment(t, LocalDate(2026, 12, 31), 2000000);
    expect(r.schedule.first.number, 13);
    expect(r.schedule.length, lessThan(120 - 12));
    expect(r.schedule.last.remainingCents, 0);
    expect(r.interestSavedCents, greaterThan(0));
    final full = simulateEarlyRepayment(t, LocalDate(2026, 12, 31), 99999999);
    expect(full.schedule, isEmpty);
    expect(
      full.interestSavedCents,
      loanStatus(
        t,
        amortize(t),
        LocalDate(2026, 12, 31),
      ).interestRemainingCents,
    );
  });

  test('out-of-range terms are refused', () {
    expect(() => terms(principal: 0), throwsArgumentError);
    expect(() => terms(rate: -1), throwsArgumentError);
    expect(() => terms(rate: 50001), throwsArgumentError);
    expect(() => terms(months: 601), throwsArgumentError);
  });

  test('principal deduced from an observed instalment', () {
    // 200 000 € at 3.45 % over 240 months -> 1 154,79 €.
    final p = loanPrincipalForPaymentCents(115479, 3450, 240)!;
    expect(loanPaymentCents(p, 3450, 240), 115479);
    expect((p - 20000000).abs(), lessThan(300));
    // Interest-free: payment × months.
    expect(loanPrincipalForPaymentCents(5000, 0, 10), 50000);
    expect(loanPaymentCents(50000, 0, 10), 5000);
    for (final (pay, rate, n) in [
      (87604, 1000, 120),
      (1, 500, 12),
      (99999, 49999, 600),
    ]) {
      final q = loanPrincipalForPaymentCents(pay, rate, n);
      if (q != null) expect(loanPaymentCents(q, rate, n), pay);
    }
    expect(loanPrincipalForPaymentCents(0, 1000, 12), isNull);
    expect(loanPrincipalForPaymentCents(1000, 1000, 601), isNull);
  });

  test('the actual instalment drives the schedule; the duration follows', () {
    // 100 000 € at 1 %: 876,04 € computed over 120 months. The bank debits
    // 900 €: repaid sooner.
    final t = LoanTerms(
      principalCents: 10000000,
      annualRateMilli: 1000,
      months: 120,
      firstDue: LocalDate(2026, 1, 5),
      paymentCents: 90000,
    );
    expect(t.payment, 90000);
    final s = amortize(t);
    expect(s.length, lessThan(120));
    expect(s.last.remainingCents, 0);
    expect(
      s.take(s.length - 1).every((i) => i.paymentCents == 90000),
      isTrue,
    );
    expect(s.fold(0, (a, i) => a + i.principalCents), 10000000);
    // Lower than computed: longer than the contract.
    final longer = amortize(
      LoanTerms(
        principalCents: 10000000,
        annualRateMilli: 1000,
        months: 120,
        firstDue: LocalDate(2026, 1, 5),
        paymentCents: 85000,
      ),
    );
    expect(longer.length, greaterThan(120));
    expect(longer.last.remainingCents, 0);
    // Not even the interest: refused.
    expect(
      () => LoanTerms(
        principalCents: 10000000,
        annualRateMilli: 12000,
        months: 120,
        firstDue: LocalDate(2026, 1, 5),
        paymentCents: 100000,
      ),
      throwsArgumentError,
    );
    // Early repayment keeps the actual instalment.
    final r = simulateEarlyRepayment(t, LocalDate(2026, 6, 10), 1000000);
    expect(r.schedule.first.paymentCents, 90000);
  });

  group('changes (variable rate, renegotiation, revolving credit)', () {
    int total(List<Installment> s) => s.fold(0, (a, i) => a + i.principalCents);

    test('no change: the same schedule as before', () {
      expect(
        amortize(terms(), changes: const []).map((i) => i.paymentCents),
        amortize(terms()).map((i) => i.paymentCents),
      );
    });

    test('a rate change keeps the end date; the instalment is computed '
        'again on what is left', () {
      final base = amortize(terms());
      final s = amortize(
        terms(),
        changes: [
          LoanChange(date: LocalDate(2028, 1, 1), annualRateMilli: 2000),
        ],
      );
      expect(s.length, base.length, reason: 'same end date');
      expect(s.last.date, base.last.date);
      expect(total(s), 10000000, reason: 'the capital is repaid exactly');
      // Before: unchanged. From January 2028 (instalment 25): new rate.
      expect(s[23].paymentCents, base[23].paymentCents);
      expect(
        s[24].paymentCents,
        loanPaymentCents(base[23].remainingCents, 2000, 96),
      );
      expect(s[24].paymentCents, greaterThan(base[24].paymentCents));
      expect(s.last.remainingCents, 0);
    });

    test('a renegotiation with a new duration', () {
      final s = amortize(
        terms(),
        changes: [
          LoanChange(
            date: LocalDate(2027, 1, 1),
            annualRateMilli: 500,
            remainingMonths: 60,
          ),
        ],
      );
      expect(s.length, 12 + 60);
      expect(total(s), 10000000);
      expect(
        s[12].paymentCents,
        loanPaymentCents(s[11].remainingCents, 500, 60),
      );
    });

    test('a new instalment: the end date follows it', () {
      final base = amortize(terms());
      final s = amortize(
        terms(),
        changes: [
          LoanChange(
            date: LocalDate(2027, 1, 1),
            paymentCents: base[12].paymentCents * 2,
          ),
        ],
      );
      expect(s.length, lessThan(base.length));
      expect(total(s), 10000000);
      expect(s.last.remainingCents, 0);
    });

    test('revolving credit: a draw adds to what is owed, the instalment '
        'is kept, the end moves', () {
      final revolving = LoanTerms(
        principalCents: 300000,
        annualRateMilli: 19000,
        months: 600,
        firstDue: LocalDate(2026, 1, 5),
        paymentCents: 10000,
      );
      final base = amortize(revolving);
      final s = amortize(
        revolving,
        changes: [LoanChange(date: LocalDate(2026, 6, 1), drawCents: 150000)],
      );
      expect(total(s), 450000, reason: 'the draw is repaid too');
      expect(s.length, greaterThan(base.length));
      expect(s[6].paymentCents, 10000, reason: 'the instalment is kept');
      final status = loanStatus(revolving, s, LocalDate(2026, 6, 10));
      expect(status.paidCount, 6);
      expect(
        status.remainingCents,
        s[5].remainingCents,
        reason: 'what the unpaid instalments still repay',
      );
    });

    test('early repayment on a loan with changes', () {
      final changes = [
        LoanChange(date: LocalDate(2027, 1, 1), annualRateMilli: 1500),
      ];
      final today = LocalDate(2028, 3, 15);
      final before = loanStatus(
        terms(),
        amortize(terms(), changes: changes),
        today,
      );
      final r = simulateEarlyRepayment(
        terms(),
        today,
        1000000,
        changes: changes,
      );
      expect(r.interestSavedCents, greaterThan(0));
      expect(r.schedule.length, lessThan(before.totalCount - before.paidCount));
      expect(total(r.schedule), before.remainingCents - 1000000);
    });

    test('a change must change something, within the limits', () {
      expect(
        () => LoanChange(date: LocalDate(2026, 1, 1)),
        throwsArgumentError,
      );
      expect(
        () => LoanChange(date: LocalDate(2026, 1, 1), annualRateMilli: -1),
        throwsArgumentError,
      );
      expect(
        () => LoanChange(date: LocalDate(2026, 1, 1), remainingMonths: 0),
        throwsArgumentError,
      );
    });
  });
}
