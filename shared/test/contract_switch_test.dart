import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  test('a cheaper contract pays its switching cost back', () {
    final s = simulateContractSwitch(
      currentMonthlyCents: 4500,
      newMonthlyCents: 3000,
      months: 60,
      switchCostCents: 5000,
    );
    expect(s.months, 60);
    expect(s.keepCents.first, 4500);
    expect(s.switchCents.first, 8000, reason: 'cost paid at the start');
    expect(s.totalSavingCents, 60 * 1500 - 5000);
    expect(s.yearlySavingCents, (60 * 1500 - 5000) * 12 ~/ 60);
    expect(s.breakEvenMonth, 4, reason: '4 × 15 € ≥ 50 €');
  });

  test('yearly increases, rounded each year', () {
    final s = simulateContractSwitch(
      currentMonthlyCents: 4500,
      newMonthlyCents: 3000,
      months: 24,
      currentYearlyIncreasePerMille: 30,
      newYearlyIncreasePerMille: 100,
    );
    // Second year: 46,35 € against 33,00 €.
    expect(s.keepCents[12] - s.keepCents[11], 4635);
    expect(s.switchCents[12] - s.switchCents[11], 3300);
    expect(s.breakEvenMonth, 1);
    expect(s.totalSavingCents, 12 * (4500 - 3000) + 12 * (4635 - 3300));
  });

  test('a dearer contract never pays off', () {
    final s = simulateContractSwitch(
      currentMonthlyCents: 3000,
      newMonthlyCents: 3500,
      months: 12,
    );
    expect(s.breakEvenMonth, isNull);
    expect(s.totalSavingCents, -6000);
  });

  test('inputs out of range are refused', () {
    for (final f in <void Function()>[
      () => simulateContractSwitch(
        currentMonthlyCents: -1,
        newMonthlyCents: 0,
        months: 12,
      ),
      () => simulateContractSwitch(
        currentMonthlyCents: 0,
        newMonthlyCents: 0,
        months: 0,
      ),
      () => simulateContractSwitch(
        currentMonthlyCents: 0,
        newMonthlyCents: 0,
        months: 601,
      ),
      () => simulateContractSwitch(
        currentMonthlyCents: 0,
        newMonthlyCents: 0,
        months: 12,
        newYearlyIncreasePerMille: 301,
      ),
    ]) {
      expect(f, throwsArgumentError);
    }
  });
}
