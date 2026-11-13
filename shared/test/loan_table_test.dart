import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  // 100 000 € at 1 % over 10 years, first instalment on 31 January 2026.
  LoanTerms terms({int? payment, int? firstInterest, int insurance = 0}) =>
      LoanTerms(
        principalCents: 10000000,
        annualRateMilli: 1000,
        months: 120,
        firstDue: LocalDate(2026, 1, 31),
        paymentCents: payment,
        firstInterestCents: firstInterest,
        insuranceMonthlyCents: insurance,
      );
  int capital(List<Installment> s) => s.fold(0, (a, i) => a + i.principalCents);

  /// The lender's table: the engine's schedule as printed.
  List<LoanTableRow> printed(List<Installment> s) => [
    for (final i in s)
      LoanTableRow(
        number: i.number,
        paymentCents: i.paymentCents,
        interestCents: i.interestCents,
        remainingCents: i.remainingCents,
      ),
  ];

  group('pause of instalments (report d\'échéances)', () {
    test('partial pause: only the interest, the loan lasts as much longer, '
        'the instalment stays', () {
      final base = amortize(terms());
      final s = amortize(
        terms(),
        changes: [LoanChange(date: LocalDate(2027, 1, 1), pauseMonths: 6)],
      );
      expect(s, hasLength(126));
      expect(s.last.date, base.last.date.addMonths(6));
      for (final i in s.sublist(12, 18)) {
        expect(i.paused, isTrue);
        expect(i.principalCents, 0);
        expect(i.paymentCents, i.interestCents);
        expect(i.remainingCents, s[11].remainingCents);
      }
      expect(s[18].paused, isFalse);
      expect(
        (s[18].paymentCents - base[12].paymentCents).abs(),
        lessThanOrEqualTo(1),
        reason: 'same capital over as many instalments',
      );
      expect(capital(s), 10000000);
      expect(s.last.remainingCents, 0);
    });

    test('total pause: nothing paid, the interest is added to what is owed '
        'and repaid after', () {
      final s = amortize(
        terms(insurance: 1500),
        changes: [
          LoanChange(
            date: LocalDate(2027, 1, 1),
            pauseMonths: 3,
            pauseCapitalized: true,
          ),
        ],
      );
      expect(s, hasLength(123));
      var owed = s[11].remainingCents;
      for (final i in s.sublist(12, 15)) {
        expect(i.paused, isTrue);
        expect(i.paymentCents, 0);
        expect(i.insuranceCents, 1500, reason: 'insurance stays due');
        expect(i.principalCents, -i.interestCents);
        expect(i.remainingCents, owed + i.interestCents);
        owed = i.remainingCents;
      }
      final added = s.sublist(12, 15).fold(0, (a, i) => a + i.interestCents);
      expect(
        s
            .where((i) => i.principalCents > 0)
            .fold(0, (a, i) => a + i.principalCents),
        10000000 + added,
      );
      expect(s.last.remainingCents, 0);
      // What is still owed before the pause ends includes the interest added.
      final status = loanStatus(terms(), s, LocalDate(2027, 3, 31));
      expect(status.remainingCents, s[14].remainingCents);
    });

    test('a loan following its actual instalment keeps it after a pause', () {
      final t = terms(payment: 87604);
      final s = amortize(
        t,
        changes: [LoanChange(date: LocalDate(2026, 6, 1), pauseMonths: 2)],
      );
      expect(s[7].paymentCents, 87604);
      expect(s.last.remainingCents, 0);
    });

    test('a pause from the first instalment (deferred loan)', () {
      final s = amortize(
        terms(),
        changes: [
          LoanChange(
            date: LocalDate(2026, 1, 1),
            pauseMonths: 24,
            pauseCapitalized: true,
          ),
        ],
      );
      expect(s, hasLength(144));
      expect(s.take(24).every((i) => i.paused && i.paymentCents == 0), isTrue);
      expect(s[23].remainingCents, greaterThan(10000000));
      expect(s.last.remainingCents, 0);
    });

    test('pause length within the limits', () {
      expect(
        () => LoanChange(date: LocalDate(2026, 1, 1), pauseMonths: 0),
        throwsArgumentError,
      );
      expect(
        () => LoanChange(
          date: LocalDate(2026, 1, 1),
          pauseMonths: maxLoanPauseMonths + 1,
        ),
        throwsArgumentError,
      );
      // Ten years of interest at 50 % added to the largest loan stay
      // within the integer limits.
      final s = amortize(
        LoanTerms(
          principalCents: maxLoanPrincipalCents,
          annualRateMilli: maxLoanRateMilli,
          months: 480,
          firstDue: LocalDate(2026, 1, 1),
        ),
        changes: [
          LoanChange(
            date: LocalDate(2026, 1, 1),
            pauseMonths: maxLoanPauseMonths,
            pauseCapitalized: true,
          ),
        ],
      );
      for (final i in s) {
        expect(i.remainingCents, lessThanOrEqualTo(5 * maxLoanPrincipalCents));
      }
    });

    test(
      'a paused instalment without insurance is not expected as a debit',
      () {
        final s = amortize(
          terms(),
          changes: [
            LoanChange(
              date: LocalDate(2026, 3, 1),
              pauseMonths: 1,
              pauseCapitalized: true,
            ),
          ],
        );
        final c = checkLoan(
          s,
          [
            for (final i in s.take(4))
              if (!i.paused)
                (
                  id: i.number,
                  date: i.date,
                  amountCents: i.totalCents,
                  dueDate: null,
                ),
          ],
          historyFrom: LocalDate(2026, 1, 1),
          historyTo: LocalDate(2026, 5, 15),
        );
        expect(
          c.rows.where((r) => r.status == LoanCheckStatus.missing),
          isEmpty,
        );
      },
    );
  });

  group('the lender\'s full table read by the engine', () {
    test('a table that follows the terms: nothing changed', () {
      final r = readLoanTable(terms(), printed(amortize(terms())));
      expect(r.changes, isEmpty);
      expect(r.gapCount, 0);
      expect(r.rowsCompared, 120);
      expect((r.firstNumber, r.lastNumber), (1, 120));
    });

    test('a rate change in the third year is found, with its date', () {
      final real = amortize(
        terms(),
        changes: [
          LoanChange(date: LocalDate(2028, 1, 1), annualRateMilli: 2350),
        ],
      );
      final r = readLoanTable(terms(), printed(real));
      expect(r.changes, hasLength(1));
      expect(r.changes.single.date, LocalDate(2028, 1, 31));
      expect(r.changes.single.annualRateMilli, 2350);
      expect(r.gapCount, 0);
    });

    test('a variable rate revised every year', () {
      final changes = [
        for (final (y, rate) in [(2027, 1500), (2028, 2100), (2029, 1850)])
          LoanChange(date: LocalDate(y, 1, 31), annualRateMilli: rate),
      ];
      final r = readLoanTable(
        terms(),
        printed(amortize(terms(), changes: changes)),
      );
      expect(r.changes.map((c) => c.annualRateMilli), [1500, 2100, 1850]);
      expect(r.changes.map((c) => c.date), changes.map((c) => c.date));
      expect(r.gapCount, 0);
    });

    test('a partial then a total pause are found with their length', () {
      final changes = [
        LoanChange(date: LocalDate(2026, 6, 30), pauseMonths: 4),
        LoanChange(
          date: LocalDate(2027, 9, 30),
          pauseMonths: 6,
          pauseCapitalized: true,
        ),
      ];
      final r = readLoanTable(
        terms(),
        printed(amortize(terms(), changes: changes)),
      );
      expect(r.changes, hasLength(2));
      expect(
        [
          for (final c in r.changes)
            (c.date, c.pauseMonths, c.pauseCapitalized),
        ],
        [
          (LocalDate(2026, 6, 30), 4, false),
          (LocalDate(2027, 9, 30), 6, true),
        ],
      );
      expect(r.gapCount, 0);
    });

    test('a renegotiation with a new instalment, and money repaid early', () {
      final changes = [
        LoanChange(
          date: LocalDate(2027, 3, 31),
          annualRateMilli: 650,
          paymentCents: 120000,
        ),
        LoanChange(date: LocalDate(2028, 5, 31), drawCents: -1500000),
      ];
      final r = readLoanTable(
        terms(),
        printed(amortize(terms(), changes: changes)),
      );
      expect(r.gapCount, 0);
      final s = amortize(terms(), changes: r.changes);
      final real = amortize(terms(), changes: changes);
      expect(s.length, real.length);
      for (final (k, i) in s.indexed) {
        expect(
          (i.remainingCents - real[k].remainingCents).abs(),
          lessThanOrEqualTo(loanTableToleranceCents),
        );
      }
      expect(
        r.changes.where((c) => c.drawCents == -1500000).single.date,
        LocalDate(2028, 5, 31),
      );
    });

    test('a rate change and a pause on a loan following its actual '
        'instalment, table rounded by the bank', () {
      final t = terms(payment: 87604);
      final changes = [
        LoanChange(date: LocalDate(2026, 10, 31), annualRateMilli: 1800),
        LoanChange(date: LocalDate(2027, 2, 28), pauseMonths: 3),
      ];
      // The bank rounds each figure its own way: a few cents off.
      final rows = [
        for (final i in amortize(t, changes: changes))
          LoanTableRow(
            number: i.number,
            paymentCents: i.paymentCents,
            interestCents: i.interestCents + (i.number.isEven ? 1 : 0),
            remainingCents: i.remainingCents + (i.number % 3),
          ),
      ];
      final r = readLoanTable(t, rows);
      expect(r.changes.map((c) => c.annualRateMilli), [1800, null]);
      expect(r.changes.last.pauseMonths, 3);
      expect(r.gapCount, 0);
    });

    test('a row misread is reported, never explained by a made-up change', () {
      final rows = printed(amortize(terms()));
      rows[40] = LoanTableRow(
        number: 41,
        paymentCents: rows[40].paymentCents,
        interestCents: rows[40].interestCents! * 3,
        remainingCents: rows[40].remainingCents,
      );
      final r = readLoanTable(terms(), rows);
      expect(r.changes, isEmpty);
      expect(r.gapCount, 1);
      expect(r.gaps.single.number, 41);
      expect(r.gaps.single.field, 'interest');
    });

    test('row 1 tells the intercalary interest', () {
      final real = amortize(terms(firstInterest: 15234));
      final r = readLoanTable(terms(), printed(real));
      expect(r.firstInterestCents, 15234);
      expect(r.changes, isEmpty);
      expect(r.gapCount, 0);
    });

    test('part of the table, out of order and with rows missing', () {
      final real = amortize(
        terms(),
        changes: [
          LoanChange(date: LocalDate(2027, 6, 30), annualRateMilli: 3000),
        ],
      );
      final rows = printed(real).sublist(10, 40).reversed.toList()..removeAt(5);
      final r = readLoanTable(terms(), rows);
      expect(r.changes.single.annualRateMilli, 3000);
      expect(r.changes.single.date, LocalDate(2027, 6, 30));
      expect((r.firstNumber, r.lastNumber), (11, 40));
      expect(r.gapCount, 0);
    });

    test('nothing read, rows out of range ignored', () {
      final r = readLoanTable(terms(), const [
        LoanTableRow(number: 0, paymentCents: 1),
        LoanTableRow(number: 3, paymentCents: -5),
        LoanTableRow(number: 4),
      ]);
      expect(r.rowsCompared, 0);
      expect(r.changes, isEmpty);
    });

    test('a table the engine cannot follow stays quick and is reported', () {
      final rows = [
        for (var k = 1; k <= 600; k++)
          LoanTableRow(
            number: k,
            paymentCents: 1000 + k * 37 % 500,
            interestCents: k * 13 % 700,
            remainingCents: 5000000 - k * 17 % 900,
          ),
      ];
      final watch = Stopwatch()..start();
      final r = readLoanTable(terms(), rows);
      expect(watch.elapsed, lessThan(const Duration(seconds: 5)));
      expect(r.gapCount, greaterThan(100));
      expect(r.gaps, hasLength(10));
    });
  });
}
