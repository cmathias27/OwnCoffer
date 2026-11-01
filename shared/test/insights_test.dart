import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  InsightOperation op(
    int id,
    LocalDate date,
    int cents,
    String label, {
    bool fee = false,
  }) => InsightOperation(
    id: id,
    date: date,
    amountCents: cents,
    label: label,
    feeCategory: fee,
  );

  test("bank fees from the label: the bank's words, not the merchants'", () {
    for (final l in [
      'FRAIS TENUE DE COMPTE',
      'COMMISSION INTERVENTION',
      'Agios',
      'INTERETS DEBITEURS',
      'COTIS CARTE VISA',
      'COTISATION BOUQUET LIBERTE',
      'REJET PRLV',
    ]) {
      expect(isBankFeeLabel(l), isTrue, reason: l);
    }
    for (final l in [
      'COTISATION MUTUELLE',
      'AMAZON FRAIS DE PORT',
      'CARREFOUR',
      'CLUB DE FOOT COTISATION',
    ]) {
      expect(isBankFeeLabel(l), isFalse, reason: l);
    }
  });

  test(
    'bank fees over 12 months: by month and by label, refunds taken off',
    () {
      final last = Period.containing(PeriodKind.month, LocalDate(2026, 10, 15));
      final fees = bankFees([
        op(1, LocalDate(2026, 10, 3), -850, 'COTIS CARTE VISA'),
        op(2, LocalDate(2026, 9, 3), -850, 'COTIS CARTE VISA'),
        op(3, LocalDate(2026, 10, 12), -800, 'COMMISSION INTERVENTION'),
        op(4, LocalDate(2026, 10, 20), 800, 'COMMISSION INTERVENTION'),
        op(5, LocalDate(2026, 10, 21), -1200, 'Divers', fee: true),
        op(6, LocalDate(2026, 10, 22), -5000, 'CARREFOUR'),
        op(7, LocalDate(2025, 10, 3), -850, 'COTIS CARTE VISA'),
      ], last);
      expect(fees.months, hasLength(12));
      expect(fees.perMonthCents.last, 850 + 800 - 800 + 1200);
      expect(fees.perMonthCents[10], 850);
      expect(fees.totalCents, 850 * 2 + 1200);
      expect(fees.byLabel.first, (
        label: 'COTIS CARTE VISA',
        cents: 1700,
        count: 2,
      ));
      expect(
        fees.byLabel.map((x) => x.label),
        isNot(contains('COMMISSION INTERVENTION')),
        reason: 'refunded',
      );
    },
  );

  test('unusual operations: far above the usual amount of the label, or '
      'charged twice', () {
    final ops = [
      for (var m = 5; m <= 9; m++) op(m, LocalDate(2026, m, 5), -4500, 'EDF'),
      op(10, LocalDate(2026, 10, 5), -21000, 'EDF'),
      op(11, LocalDate(2026, 10, 7), -1599, 'NETFLIX'),
      op(12, LocalDate(2026, 10, 8), -1599, 'NETFLIX'),
      op(13, LocalDate(2026, 10, 9), -6000, 'GARAGE'),
      op(14, LocalDate(2026, 10, 9), -4900, 'EDF'),
    ];
    final found = unusualOperations(ops, from: LocalDate(2026, 10, 1));
    expect(
      [for (final u in found) (u.kind, u.operation.id)],
      [
        (UnusualKind.amount, 10),
        (UnusualKind.duplicate, 12),
      ],
      reason: 'a new label or a small rise is not unusual',
    );
    expect(found.first.usualCents, 4500);
    expect(found.first.basis, 5);
    expect(found.last.basis, 11);
  });

  test('forecast reliability', () {
    const r = ForecastReliability(
      plannedDue: 20,
      plannedPaid: 18,
      plannedLate: 2,
      variableEstimateCents: 90000,
      variableActualCents: 100000,
    );
    expect(r.plannedPercent, 90);
    expect(r.variableGapPercent, 10);
    expect(
      const ForecastReliability(
        plannedDue: 0,
        plannedPaid: 0,
        plannedLate: 0,
      ).plannedPercent,
      isNull,
    );
  });

  test('goal advice: the amount from up to six months, the decision on the '
      'last three', () {
    final a = adviseGoals({
      1: [10000, 10000, 10000, 30000, 30000, 30000],
    }, const {});
    expect(a.single.proposedCents, 20000, reason: 'average of six');
    expect(a.single.monthsCents, hasLength(6));
  });
}
