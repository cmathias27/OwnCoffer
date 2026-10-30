import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('parse', () {
    final cases = {
      '30/10/2026': LocalDate(2026, 10, 30),
      '1/2/2026': LocalDate(2026, 2, 1),
      '30/10/26': LocalDate(2026, 10, 30),
      '01/01/99': LocalDate(1999, 1, 1),
      '01/01/69': LocalDate(2069, 1, 1),
      '30-10-2026': LocalDate(2026, 10, 30),
      '30.10.2026': LocalDate(2026, 10, 30),
      '2026-10-30': LocalDate(2026, 10, 30),
      '20261030': LocalDate(2026, 10, 30),
      '20261030120000': LocalDate(2026, 10, 30),
      '20261030120000.000[-5:EST]': LocalDate(2026, 10, 30),
      '20261030000000[+1:CET]': LocalDate(2026, 10, 30),
      ' 29/02/2028 ': LocalDate(2028, 2, 29),
    };
    cases.forEach((input, expected) {
      test('"$input"', () => expect(LocalDate.parse(input), expected));
    });

    test('month-day-year order', () {
      expect(
        LocalDate.parse('10/30/2026', order: DateOrder.monthDayYear),
        LocalDate(2026, 10, 30),
      );
      expect(
        LocalDate.parse("10/30'26", order: DateOrder.monthDayYear),
        LocalDate(2026, 10, 30),
      );
    });

    for (final bad in [
      '',
      '31/02/2026',
      '29/02/2026',
      '32/01/2026',
      '00/01/2026',
      '10/13/2026',
      '2026/13/01',
      '1/1/1',
      'hier',
      '20261330',
    ]) {
      test('rejects "$bad"', () {
        expect(() => LocalDate.parse(bad), throwsFormatException);
        expect(LocalDate.tryParse(bad), isNull);
      });
    }
  });

  group('arithmetic', () {
    test('addDays crosses months, years and DST changes', () {
      expect(LocalDate(2026, 10, 24).addDays(2), LocalDate(2026, 10, 26));
      expect(LocalDate(2026, 3, 28).addDays(2), LocalDate(2026, 3, 30));
      expect(LocalDate(2026, 12, 31).addDays(1), LocalDate(2027, 1, 1));
      expect(LocalDate(2028, 2, 28).addDays(1), LocalDate(2028, 2, 29));
      expect(LocalDate(2026, 1, 1).addDays(-1), LocalDate(2025, 12, 31));
    });

    test('addMonths clamps to the end of the month', () {
      expect(LocalDate(2026, 1, 31).addMonths(1), LocalDate(2026, 2, 28));
      expect(LocalDate(2028, 1, 31).addMonths(1), LocalDate(2028, 2, 29));
      expect(LocalDate(2026, 3, 31).addMonths(1), LocalDate(2026, 4, 30));
      expect(LocalDate(2026, 11, 15).addMonths(3), LocalDate(2027, 2, 15));
      expect(LocalDate(2026, 3, 15).addMonths(-3), LocalDate(2025, 12, 15));
    });

    test('daysUntil and epoch round trip', () {
      final a = LocalDate(2026, 1, 1);
      final b = LocalDate(2027, 1, 1);
      expect(a.daysUntil(b), 365);
      for (var i = -800; i < 800; i += 13) {
        final d = a.addDays(i);
        expect(LocalDate.fromEpochDay(d.epochDay), d);
        expect(a.daysUntil(d), i);
      }
    });

    test('ordering and equality', () {
      expect(LocalDate(2026, 1, 2) > LocalDate(2026, 1, 1), isTrue);
      expect(LocalDate(2026, 1, 1), LocalDate(2026, 1, 1));
      expect(LocalDate(2026, 1, 1).toString(), '2026-01-01');
    });
  });
}
