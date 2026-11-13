import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  PrepaymentPenalty penalty(
    PrepaymentLaw law, {
    PrepaymentClause clause = const PrepaymentClause(),
    int amount = 2000000,
    int owed = 15000000,
    int rate = 3000,
    int monthsLeft = 200,
    int saved = 500000,
    int repaidLastYear = 0,
  }) => prepaymentPenalty(
    law: law,
    clause: clause,
    amountCents: amount,
    owedBeforeCents: owed,
    rateMilli: rate,
    monthsLeft: monthsLeft,
    interestSavedCents: saved,
    repaidLastYearCents: repaidLastYear,
  );

  group('home loan: 6 months of interest, at most 3 % of the capital owed', () {
    test('clause unknown: the legal maximum', () {
      // 20 000 € at 3 %: 6 months of interest = 300 €; 3 % of 150 000 € =
      // 4 500 €.
      final p = penalty(PrepaymentLaw.mortgage);
      expect(p.penaltyCents, 30000);
      expect(p.legalMaxCents, 30000);
      expect(p.basis, PrepaymentBasis.legalMax);
    });

    test('3 % of the capital owed caps a large repayment', () {
      // Everything repaid at 10 %: 6 months = 7 500 €, 3 % = 4 500 €.
      final p = penalty(
        PrepaymentLaw.mortgage,
        amount: 15000000,
        rate: 10000,
      );
      expect(p.penaltyCents, 450000);
    });

    test('the clause of the offer applies when lower, never above the law', () {
      final low = penalty(
        PrepaymentLaw.mortgage,
        clause: const PrepaymentClause(percentMilli: 1000),
      );
      expect(low.penaltyCents, 20000, reason: '1 % of 20 000 €');
      expect(low.legalMaxCents, 30000);
      expect(low.basis, PrepaymentBasis.offer);
      final high = penalty(
        PrepaymentLaw.mortgage,
        clause: const PrepaymentClause(interestMonths: 12),
      );
      expect(high.penaltyCents, 30000, reason: 'capped by the law');
      final both = penalty(
        PrepaymentLaw.mortgage,
        clause: const PrepaymentClause(interestMonths: 6, percentMilli: 1000),
      );
      expect(both.penaltyCents, 20000, reason: 'the lower of the two');
    });

    test('an offer without penalty', () {
      final p = penalty(
        PrepaymentLaw.mortgage,
        clause: const PrepaymentClause(interestMonths: 0),
      );
      expect(p.penaltyCents, 0);
      expect(p.basis, PrepaymentBasis.none);
    });
  });

  group('consumer credit: 1 % (0.5 % in the last year), at most the '
      'interest saved, free up to 10 000 € a year', () {
    test('more than a year left: 1 %', () {
      final p = penalty(PrepaymentLaw.consumer);
      expect(p.penaltyCents, 20000);
      expect(p.basis, PrepaymentBasis.legalMax);
    });

    test('last year: 0.5 %', () {
      expect(
        penalty(PrepaymentLaw.consumer, monthsLeft: 12).penaltyCents,
        10000,
      );
    });

    test('never more than the interest saved', () {
      expect(penalty(PrepaymentLaw.consumer, saved: 4321).penaltyCents, 4321);
      expect(penalty(PrepaymentLaw.consumer, saved: -5).penaltyCents, 0);
    });

    test('10 000 € over 12 months repaid without penalty', () {
      expect(
        penalty(PrepaymentLaw.consumer, amount: 1000000).basis,
        PrepaymentBasis.none,
      );
      expect(
        penalty(
          PrepaymentLaw.consumer,
          amount: 600000,
          repaidLastYear: 500000,
        ).penaltyCents,
        6000,
        reason: 'over 10 000 € with the earlier repayment',
      );
    });
  });

  test('revolving credit and instalments: no penalty', () {
    expect(penalty(PrepaymentLaw.none).penaltyCents, 0);
    expect(penalty(PrepaymentLaw.none).basis, PrepaymentBasis.none);
  });

  test('nothing repaid, or more than owed: bounded', () {
    expect(penalty(PrepaymentLaw.mortgage, amount: 0).penaltyCents, 0);
    expect(
      penalty(
        PrepaymentLaw.mortgage,
        amount: maxLoanPrincipalCents,
      ).penaltyCents,
      225000,
      reason: 'only what is owed is repaid: 6 months on 150 000 €',
    );
    final big = prepaymentPenalty(
      law: PrepaymentLaw.mortgage,
      clause: const PrepaymentClause(interestMonths: 12),
      amountCents: maxLoanPrincipalCents,
      owedBeforeCents: maxLoanPrincipalCents,
      rateMilli: maxLoanRateMilli,
      monthsLeft: maxLoanMonths,
      interestSavedCents: maxLoanPrincipalCents,
    );
    expect(big.penaltyCents, greaterThan(0));
  });

  test('rate on a date and money repaid over a year follow the changes', () {
    final terms = LoanTerms(
      principalCents: 10000000,
      annualRateMilli: 1000,
      months: 120,
      firstDue: LocalDate(2026, 1, 31),
    );
    final changes = [
      LoanChange(date: LocalDate(2027, 1, 31), annualRateMilli: 2000),
      LoanChange(date: LocalDate(2026, 3, 31), drawCents: -300000),
      LoanChange(date: LocalDate(2027, 6, 30), drawCents: -200000),
    ];
    expect(loanRateOn(terms, changes, LocalDate(2026, 12, 1)), 1000);
    expect(loanRateOn(terms, changes, LocalDate(2027, 2, 1)), 2000);
    expect(repaidOverYear(changes, LocalDate(2027, 7, 1)), 200000);
    expect(repaidOverYear(changes, LocalDate(2027, 3, 1)), 300000);
  });
}
