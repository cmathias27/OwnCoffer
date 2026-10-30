import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('parseAmountCents', () {
    final valid = {
      '0': 0,
      '12': 1200,
      '12,3': 1230,
      '12,34': 1234,
      '-12,34': -1234,
      '+12,34': 1234,
      '12.34': 1234,
      ',5': 50,
      '12,': 1200,
      '1 234,56': 123456,
      '1 234,56': 123456,
      '1 234,56': 123456,
      '-1 234 567,89': -123456789,
      '1.234,56': 123456,
      '1,234.56': 123456,
      '1.234.567': 123456700,
      '1,234,567.00': 123456700,
      '−12,30': -1230,
      '12,30-': -1230,
      '(12,30)': -1230,
      '12,30 €': 1230,
      '12,30EUR': 1230,
      "1'234.50": 123450,
      '  -0,01 ': -1,
      '0,10': 10,
      '-0,1': -10,
    };
    valid.forEach((input, expected) {
      test('"$input" → $expected', () {
        expect(parseAmountCents(input), expected);
      });
    });

    final invalid = [
      '',
      '   ',
      '-',
      'abc',
      '12,345', // three decimals
      '1.234', // ambiguous: thousands or decimal
      '12.3.4,5',
      '1,23,456.00', // bad grouping
      '12,34,56',
      '1.2345,00',
      '12a',
      '--12',
      '99999999999999,00', // too large
    ];
    for (final input in invalid) {
      test('rejects "$input"', () {
        expect(
          () => parseAmountCents(input),
          throwsA(isA<AmountFormatException>()),
        );
      });
    }

    test('never loses a cent over a typical range', () {
      for (var c = -100000; c <= 100000; c += 7) {
        final text = formatCents(c, thousandsSeparator: ' ');
        expect(parseAmountCents(text), c, reason: text);
      }
    });
  });

  group('parseDecimalCents', () {
    test('reads OFX amounts', () {
      expect(parseDecimalCents('-50.00'), -5000);
      expect(parseDecimalCents('-50.000'), -5000);
      expect(parseDecimalCents('1234.5'), 123450);
      expect(parseDecimalCents('1234,56'), 123456);
      expect(parseDecimalCents('+0.01'), 1);
      expect(parseDecimalCents('.5'), 50);
      expect(parseDecimalCents('100'), 10000);
    });
    test('rejects non-zero extra decimals and grouping', () {
      for (final s in ['12.345', '1,234.56', '', '-', 'abc', '1 000']) {
        expect(
          () => parseDecimalCents(s),
          throwsA(isA<AmountFormatException>()),
          reason: s,
        );
      }
    });
  });

  group('formatCents', () {
    test('formats with French separators', () {
      expect(formatCents(0, thousandsSeparator: ' '), '0,00');
      expect(formatCents(5, thousandsSeparator: ' '), '0,05');
      expect(formatCents(-5, thousandsSeparator: ' '), '-0,05');
      expect(formatCents(123456789, thousandsSeparator: ' '), '1 234 567,89');
      expect(formatCents(-100000, thousandsSeparator: ' '), '-1 000,00');
    });
  });

  group('sumCents', () {
    test('sums exactly where doubles would drift', () {
      // 0.1 + 0.2 in cents, ten thousand times.
      final values = [for (var i = 0; i < 10000; i++) i.isEven ? 10 : 20];
      expect(sumCents(values), 150000);
    });
    test('refuses out-of-range totals', () {
      expect(() => sumCents([maxAbsCents, 1]), throwsStateError);
    });
  });
}
