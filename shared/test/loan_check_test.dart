import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  // 12 instalments of 900.00 + 20.00 insurance, due on the 5th from January.
  final schedule = amortize(
    LoanTerms(
      principalCents: 1000000,
      annualRateMilli: 1000,
      months: 12,
      firstDue: LocalDate(2026, 1, 5),
      paymentCents: 90000,
      insuranceMonthlyCents: 2000,
    ),
  );
  final regular = schedule.first.totalCents;
  var nextId = 0;
  LoanDebit debit(int month, int day, {int? cents, LocalDate? due}) => (
    id: ++nextId,
    date: LocalDate(2026, month, day),
    amountCents: cents ?? regular,
    dueDate: due,
  );
  LoanCheck check(
    List<LoanDebit> debits, {
    LocalDate? from,
    LocalDate? to,
  }) => checkLoan(
    schedule,
    debits,
    historyFrom: from ?? LocalDate(2026, 1, 1),
    historyTo: to ?? LocalDate(2026, 6, 30),
  );
  List<LoanCheckStatus> statuses(LoanCheck c) => [
    for (final r in c.rows) r.status,
  ];

  test('every instalment debited on time is paid', () {
    final c = check([for (var m = 1; m <= 6; m++) debit(m, 5)]);
    expect(statuses(c), List.filled(6, LoanCheckStatus.paid));
    expect(c.problems, isEmpty);
  });

  test('a debit a few days late still counts', () {
    final c = check([
      for (var m = 1; m <= 6; m++) debit(m, m == 3 ? 9 : 5),
    ]);
    expect(c.problems, isEmpty);
  });

  test('a month without debit is missing', () {
    final c = check([
      for (var m = 1; m <= 6; m++)
        if (m != 4) debit(m, 5),
    ]);
    expect(c.problems.single.status, LoanCheckStatus.missing);
    expect(c.problems.single.instalment!.date, LocalDate(2026, 4, 5));
    expect(c.count(LoanCheckStatus.paid), 5);
  });

  test('instalments outside the imported history are not checked', () {
    // History from March to June 7: January, February not imported; June
    // due on the 5th may still come (5 days of tolerance).
    final c = check(
      [for (var m = 3; m <= 5; m++) debit(m, 5)],
      from: LocalDate(2026, 3, 1),
      to: LocalDate(2026, 6, 7),
    );
    expect(statuses(c), List.filled(3, LoanCheckStatus.paid));
    final late = check(
      [for (var m = 3; m <= 5; m++) debit(m, 5)],
      from: LocalDate(2026, 3, 1),
      to: LocalDate(2026, 6, 10),
    );
    expect(late.problems.single.status, LoanCheckStatus.missing);
  });

  test('two debits for the same instalment are a duplicate', () {
    final c = check([
      for (var m = 1; m <= 6; m++) debit(m, 5),
      debit(2, 8),
    ]);
    final p = c.problems.single;
    expect(p.status, LoanCheckStatus.duplicate);
    expect(p.instalment!.number, 2);
    expect(p.debits.length, 2);
  });

  test('another amount is reported with its gap', () {
    final c = check([
      for (var m = 1; m <= 6; m++)
        debit(m, 5, cents: m == 5 ? regular + 1500 : null),
    ]);
    final p = c.problems.single;
    expect(p.status, LoanCheckStatus.differentAmount);
    expect(p.instalment!.number, 5);
    expect(p.gapCents, 1500);
  });

  test('a cent of rounding is not another amount', () {
    final c = check([
      for (var m = 1; m <= 6; m++) debit(m, 5, cents: regular - 1),
    ]);
    expect(c.problems, isEmpty);
  });

  test('insurance debited apart: the instalment alone is right', () {
    final c = check([
      for (var m = 1; m <= 6; m++)
        debit(m, 5, cents: schedule[m - 1].paymentCents),
    ]);
    expect(c.problems, isEmpty);
  });

  test('a debit far from every instalment is unexpected', () {
    // March 2027: the last instalment was in December 2026.
    final after = check([
      for (var m = 1; m <= 6; m++) debit(m, 5),
      (id: 99, date: LocalDate(2027, 3, 1), amountCents: 5000, dueDate: null),
    ]);
    final p = after.problems.single;
    expect(p.status, LoanCheckStatus.unexpected);
    expect(p.instalment, isNull);
    expect(after.rows.last, same(p));
  });

  test('a linked debit keeps its instalment, even far from it', () {
    // Paid three weeks late but linked by the user to February.
    final c = check([
      debit(1, 5),
      debit(2, 26, due: LocalDate(2026, 2, 5)),
      debit(3, 5),
      debit(4, 5),
      debit(5, 5),
      debit(6, 5),
    ]);
    expect(c.problems, isEmpty);
  });

  test('a debit between two instalments goes to the nearer one', () {
    final c = check([
      debit(1, 5),
      debit(2, 5),
      debit(3, 5),
      debit(4, 5),
      debit(5, 5),
      debit(6, 5),
      debit(3, 18), // 13 days after March 5, 18 before April 5
    ]);
    expect(c.problems.single.status, LoanCheckStatus.duplicate);
    expect(c.problems.single.instalment!.number, 3);
  });
}
