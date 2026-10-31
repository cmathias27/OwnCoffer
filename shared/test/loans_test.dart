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
}
