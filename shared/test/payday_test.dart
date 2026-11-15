import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

PaydayCredit _c(
  int id,
  LocalDate date,
  int cents,
  String label, {
  bool salary = false,
}) => (id: id, date: date, amountCents: cents, label: label, salary: salary);

void main() {
  final today = LocalDate(2026, 11, 15);

  group('paydayLabel', () {
    test('drops dates, references and month names', () {
      expect(
        paydayLabel('VIR SEPA SALAIRE OCTOBRE 2026 ACME REF 123'),
        'VIR SEPA SALAIRE ACME REF',
      );
      expect(paydayLabel('Vir salaire Novembre'), 'VIR SALAIRE');
    });
  });

  group('detectPayday', () {
    final salaries = [
      _c(1, LocalDate(2026, 8, 28), 195000, 'VIR SALAIRE AOUT ACME'),
      _c(2, LocalDate(2026, 9, 29), 195000, 'VIR SALAIRE SEPTEMBRE ACME'),
      _c(3, LocalDate(2026, 10, 28), 201000, 'VIR SALAIRE OCTOBRE ACME'),
    ];

    test('three monthly credits of the same label: the pay', () {
      final p = detectPayday(salaries, today: today)!;
      expect(p.label, 'VIR SALAIRE ACME');
      expect(p.months, 3);
      expect(p.amountCents, 195000);
      expect(p.dayOfMonth, 28);
      expect(p.next, LocalDate(2026, 11, 28));
      expect(p.tolerancePercent, 5);
      expect(p.salary, isFalse);
    });

    test('two months are not enough', () {
      expect(detectPayday(salaries.skip(1), today: today), isNull);
    });

    test('a pay last seen more than 40 days ago has stopped', () {
      expect(detectPayday(salaries, today: LocalDate(2026, 12, 20)), isNull);
    });

    test('already planned: nothing proposed', () {
      expect(
        detectPayday(salaries, today: today, plannedCredits: [190000]),
        isNull,
      );
      expect(
        detectPayday(salaries, today: today, plannedCredits: [5000, -190000]),
        isNotNull,
      );
    });

    test('a salary category wins over a larger regular credit', () {
      final p = detectPayday([
        for (final (i, m) in [(10, 8), (11, 9), (12, 10)])
          _c(i, LocalDate(2026, m, 5), 300000, 'VIR LOYER PERCU'),
        _c(20, LocalDate(2026, 8, 30), 150000, 'VIR EMPLOYEUR A', salary: true),
        _c(21, LocalDate(2026, 9, 30), 150000, 'VIR EMPLOYEUR B', salary: true),
        _c(
          22,
          LocalDate(2026, 10, 30),
          150000,
          'VIR EMPLOYEUR B',
          salary: true,
        ),
      ], today: today)!;
      expect(p.salary, isTrue);
      expect(p.amountCents, 150000);
      expect(p.label, 'VIR EMPLOYEUR B');
      expect(p.dayOfMonth, 30);
      expect(p.next, LocalDate(2026, 11, 30));
    });

    test('without a salary category, the largest regular credit', () {
      final p = detectPayday([
        ...salaries,
        for (final (i, m) in [(10, 8), (11, 9), (12, 10)])
          _c(i, LocalDate(2026, m, 5), 30000, 'VIR CAF'),
      ], today: today)!;
      expect(p.label, 'VIR SALAIRE ACME');
    });

    test('an advance a few days apart counts as the same month', () {
      final p = detectPayday([
        ...salaries,
        _c(4, LocalDate(2026, 10, 15), 40000, 'VIR SALAIRE ACOMPTE ACME'),
        _c(5, LocalDate(2026, 10, 20), 40000, 'VIR SALAIRE ACME'),
      ], today: today)!;
      expect(p.months, 3);
      expect(p.credits.last.id, 3);
    });

    test('a bonus month ends the run; small credits are ignored', () {
      final p = detectPayday([
        _c(0, LocalDate(2026, 7, 28), 390000, 'VIR SALAIRE JUILLET ACME'),
        ...salaries,
        for (final (i, m) in [(10, 8), (11, 9), (12, 10)])
          _c(i, LocalDate(2026, m, 2), 1500, 'REMBOURSEMENT'),
      ], today: today)!;
      expect(p.months, 3);
      expect(p.credits.first.id, 1);
    });

    test('irregular credits are not a pay', () {
      expect(
        detectPayday([
          _c(1, LocalDate(2026, 8, 1), 100000, 'VIR AMI'),
          _c(2, LocalDate(2026, 8, 25), 100000, 'VIR AMI'),
          _c(3, LocalDate(2026, 10, 30), 100000, 'VIR AMI'),
        ], today: today),
        isNull,
      );
    });

    test('a pay on the 31st falls on the last day of shorter months', () {
      final p = detectPayday([
        _c(1, LocalDate(2026, 8, 31), 200000, 'VIR SALAIRE'),
        _c(2, LocalDate(2026, 9, 30), 200000, 'VIR SALAIRE'),
        _c(3, LocalDate(2026, 10, 31), 200000, 'VIR SALAIRE'),
      ], today: today)!;
      expect(p.dayOfMonth, 31);
      expect(p.next, LocalDate(2026, 11, 30));
    });
  });
}
