import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  final today = LocalDate(2026, 11, 2);

  test('the demo household: the same every time, nothing in the future', () {
    final a = DemoHousehold.generate(today);
    final b = DemoHousehold.generate(today);
    expect(a.operations.length, b.operations.length);
    expect(a.operations.first, b.operations.first);
    expect(a.operations.every((o) => !o.date.isAfter(today)), isTrue);
    expect(a.accounts, hasLength(3));
    expect(a.operations.map((o) => o.account).toSet(), {0, 1, 2});
  });

  test('a year of believable life: income above spending, some left to '
      'classify, a payment in instalments', () {
    final h = DemoHousehold.generate(today);
    final income = h.operations
        .where((o) => o.category == 'income.salary')
        .fold(0, (s, o) => s + o.amountCents);
    final spending = h.operations
        .where(
          (o) =>
              o.amountCents < 0 &&
              o.category != 'transfers.between_accounts' &&
              o.category != 'savings.savings_deposit',
        )
        .fold(0, (s, o) => s - o.amountCents);
    expect(income, greaterThan(spending));
    expect(h.operations.where((o) => o.category == null), isNotEmpty);
    expect(
      h.operations.where((o) => o.label.startsWith('ONEY 4X')),
      hasLength(3),
    );
    expect(h.planned.where((p) => p.subscription), isNotEmpty);
    // Labels carry no real name or account number.
    expect(
      h.operations.every((o) => !RegExp(r'\d{8,}').hasMatch(o.label)),
      isTrue,
    );
  });
}
