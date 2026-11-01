import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

InstalmentDebit _d(
  int id,
  LocalDate date,
  int cents,
  String label, {
  int account = 1,
}) => (
  id: id,
  accountId: account,
  date: date,
  amountCents: cents,
  label: label,
);

void main() {
  test('the count written in the label', () {
    expect(statedInstalmentCount('ONEY 4X 2/4'), 4);
    expect(statedInstalmentCount('PAIEMENT EN 3 FOIS'), 3);
    expect(statedInstalmentCount('Alma 10x'), 10);
    expect(statedInstalmentCount('KLARNA'), isNull);
    expect(statedInstalmentCount('CARTE 12/10'), isNull, reason: 'not n/N');
    expect(statedInstalmentCount('1X'), isNull, reason: 'one is no plan');
    expect(instalmentPlanLabel('Oney 4x 2/4'), 'ONEY 4X');
  });

  final today = LocalDate(2026, 11, 1);

  test('instalments of one plan grouped, oldest first', () {
    final plans = detectInstalmentPlans([
      _d(3, LocalDate(2026, 10, 12), -4500, 'ONEY 4X 2/4'),
      _d(1, LocalDate(2026, 9, 12), -4650, 'ONEY 4X 1/4'),
      _d(7, LocalDate(2026, 10, 20), -2000, 'KLARNA'),
      _d(8, LocalDate(2026, 10, 20), -2000, 'KLARNA', account: 2),
      _d(9, LocalDate(2026, 10, 21), 2000, 'KLARNA REMBOURSEMENT'),
    ], today: today);
    expect(plans.map((p) => (p.accountId, p.label)), [
      (1, 'ONEY 4X'),
      (1, 'KLARNA'),
      (2, 'KLARNA'),
    ], reason: 'one plan per account; credits left out');
    final oney = plans.first;
    expect(oney.debits.map((d) => d.id), [1, 3]);
    expect(oney.amountCents, 4500, reason: 'the last instalment');
    expect(oney.paidCount, 2);
    expect(oney.statedCount, 4);
    expect(oney.suggestedCount, 4);
    expect(oney.first, LocalDate(2026, 9, 12));
    expect(plans[1].statedCount, isNull);
    expect(plans[1].suggestedCount, 4);
  });

  test('finished plans are left out', () {
    final plans = detectInstalmentPlans([
      for (var i = 1; i <= 3; i++)
        _d(i, LocalDate(2026, 7 + i, 5), -3000, 'ALMA 3X $i/3'),
      _d(10, LocalDate(2026, 6, 1), -1000, 'COFIDIS'),
      for (var i = 0; i < 6; i++)
        _d(20 + i, LocalDate(2026, 5 + i, 3), -5000, 'FLOA'),
    ], today: today);
    expect(
      plans.map((p) => p.label),
      ['FLOA'],
      reason: 'all three paid; nothing for five months',
    );
    expect(plans.single.suggestedCount, 6, reason: 'more than 4 paid');
  });
}
