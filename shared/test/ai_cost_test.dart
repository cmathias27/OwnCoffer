import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('AI cost (decision 0048)', () {
    int cost(int input, int output, int inPrice, int outPrice) => aiCostCents(
      inputTokens: input,
      outputTokens: output,
      inputPrice: inPrice,
      outputPrice: outPrice,
    );

    test('a million tokens cost the price per million', () {
      // 3 € and 15 € per million tokens sent and received.
      expect(cost(1000000, 0, 30000, 150000), 300);
      expect(cost(0, 1000000, 30000, 150000), 1500);
      expect(cost(1000000, 1000000, 30000, 150000), 1800);
    });

    test('rounded once, to the nearest cent, half up', () {
      // 0.075 € per million: 200 000 tokens = 1.5 cents → 2.
      expect(cost(200000, 0, 750, 0), 2);
      // 199 999 tokens = 1.499… cents → 1.
      expect(cost(199999, 0, 750, 0), 1);
      // Two halves of a cent make one cent: not rounded apart (0 + 0).
      expect(cost(66667, 66667, 750, 750), 1);
      expect(cost(0, 0, 30000, 150000), 0);
    });

    test('large volumes stay exact (integers only)', () {
      expect(cost(5000000000, 1000000000, 30000, 150000), 3000000);
    });

    test('negative values are refused', () {
      expect(() => cost(-1, 0, 1, 1), throwsArgumentError);
      expect(() => cost(1, 0, -1, 1), throwsArgumentError);
    });

    test('prices typed by the user', () {
      expect(parseAiPrice('0,075'), 750);
      expect(parseAiPrice('0.075'), 750);
      expect(parseAiPrice('3'), 30000);
      expect(parseAiPrice(' 2,5 '), 25000);
      expect(parseAiPrice('15.0001'), 150001);
      expect(parseAiPrice('0,00001'), isNull);
      expect(parseAiPrice('-1'), isNull);
      expect(parseAiPrice('1,2,3'), isNull);
      expect(parseAiPrice(''), isNull);
      expect(formatAiPrice(750), '0.075');
      expect(formatAiPrice(750, decimal: ','), '0,075');
      expect(formatAiPrice(30000), '3');
      expect(formatAiPrice(25000), '2.5');
      expect(formatAiPrice(0), '0');
    });
  });
}
