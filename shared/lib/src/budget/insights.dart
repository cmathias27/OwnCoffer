/// Analyses computed without AI (cahier des charges : analyses calculées,
/// détection des frais bancaires, anomalies, fiabilité des prévisions).
/// Every figure is shown with what it comes from.
library;

import '../local_date.dart';
import '../text.dart';
import 'period.dart';

/// How bank fees start on French statements (normalised: upper case, no
/// accents). Merchants rarely start their label so.
const bankFeeStarts = [
  'FRAIS',
  'COMMISSION',
  'COM INTERVENTION',
  'AGIOS',
  'INTERETS DEBITEURS',
  'TENUE DE COMPTE',
  'REJET',
  'MINIMUM FORFAITAIRE',
];

/// A membership fee is a bank fee only when it is about the account.
const _cotisationWords = [
  'CARTE',
  'CB',
  'BOUQUET',
  'OFFRE',
  'FORFAIT',
  'PACKAGE',
  'COMPTE',
];

/// Whether a debit looks like a bank fee from its label alone.
bool isBankFeeLabel(String label) {
  final l = normalizeForMatch(label);
  if (bankFeeStarts.any(l.startsWith)) return true;
  if (l.startsWith('COTIS')) {
    final words = l.split(RegExp(r'[^A-Z0-9]+'));
    return _cotisationWords.any(words.contains);
  }
  return false;
}

/// One debit seen by the analyses.
class InsightOperation {
  final int id;
  final LocalDate date;

  /// Signed: negative = debit.
  final int amountCents;
  final String label;

  /// Classified in a bank fee category (fees, overdraft interest).
  final bool feeCategory;

  const InsightOperation({
    required this.id,
    required this.date,
    required this.amountCents,
    required this.label,
    this.feeCategory = false,
  });
}

class BankFees {
  /// Paid per month, oldest first (one value per month of [months]).
  final List<int> perMonthCents;
  final List<Period> months;

  /// By cleaned label, largest first.
  final List<({String label, int cents, int count})> byLabel;

  /// The operations counted, newest first.
  final List<InsightOperation> operations;

  const BankFees(
    this.perMonthCents,
    this.months,
    this.byLabel,
    this.operations,
  );

  int get totalCents => perMonthCents.fold(0, (a, c) => a + c);
}

/// Bank fees over the [count] budget months ending with [last] (included):
/// debits classified as fees, or whose label says so. Refunds of fees
/// (credits with such a label) are taken off.
BankFees bankFees(
  Iterable<InsightOperation> operations,
  Period last, {
  int count = 12,
}) {
  final months = [for (var i = count - 1; i >= 0; i--) last.shift(-i)];
  final per = List.filled(count, 0);
  final byLabel = <String, ({int cents, int count})>{};
  final kept = <InsightOperation>[];
  for (final op in operations) {
    if (!(op.feeCategory || isBankFeeLabel(op.label))) continue;
    final m = months.indexWhere((p) => p.contains(op.date));
    if (m < 0) continue;
    per[m] -= op.amountCents;
    final b = byLabel[op.label];
    byLabel[op.label] = (
      cents: (b?.cents ?? 0) - op.amountCents,
      count: (b?.count ?? 0) + 1,
    );
    kept.add(op);
  }
  kept.sort((a, b) => b.date.compareTo(a.date));
  final labels = [
    for (final e in byLabel.entries)
      if (e.value.cents > 0)
        (label: e.key, cents: e.value.cents, count: e.value.count),
  ]..sort((a, b) => b.cents.compareTo(a.cents));
  return BankFees(
    [for (final v in per) v < 0 ? 0 : v],
    months,
    labels,
    kept,
  );
}

enum UnusualKind {
  /// Much more than usual for this label.
  amount,

  /// Same label and amount a few days apart: charged twice?
  duplicate,
}

class UnusualOperation {
  final UnusualKind kind;
  final InsightOperation operation;

  /// The usual amount (median of the earlier debits of the label), or the
  /// other operation's amount for a duplicate.
  final int usualCents;

  /// How many earlier debits the usual amount comes from; for a duplicate,
  /// the other operation's id.
  final int basis;

  const UnusualOperation(
    this.kind,
    this.operation,
    this.usualCents,
    this.basis,
  );
}

int _median(List<int> values) {
  final s = [...values]..sort();
  final mid = s.length ~/ 2;
  return s.length.isOdd ? s[mid] : (s[mid - 1] + s[mid] + 1) ~/ 2;
}

/// Debits since [from] that stand out from the history of their label:
/// at least [factor] times the median of at least three earlier debits and
/// [minExtraCents] more; or the same label and amount within [days] days
/// (possible double charge). Largest first.
List<UnusualOperation> unusualOperations(
  Iterable<InsightOperation> history, {
  required LocalDate from,
  int factor = 2,
  int minExtraCents = 3000,
  int days = 3,
}) {
  final debits =
      [
        for (final o in history)
          if (o.amountCents < 0 && o.label.trim().isNotEmpty) o,
      ]..sort((a, b) {
        final c = a.date.compareTo(b.date);
        return c != 0 ? c : a.id.compareTo(b.id);
      });
  final byLabel = <String, List<InsightOperation>>{};
  final result = <UnusualOperation>[];
  for (final o in debits) {
    final before = byLabel.putIfAbsent(o.label, () => []);
    if (o.date >= from) {
      final twin = before
          .where(
            (p) =>
                p.amountCents == o.amountCents &&
                p.date.daysUntil(o.date) <= days,
          )
          .lastOrNull;
      if (twin != null) {
        result.add(
          UnusualOperation(
            UnusualKind.duplicate,
            o,
            -twin.amountCents,
            twin.id,
          ),
        );
      } else if (before.length >= 3) {
        final usual = _median([for (final p in before) -p.amountCents]);
        final amount = -o.amountCents;
        if (amount >= usual * factor && amount - usual >= minExtraCents) {
          result.add(
            UnusualOperation(UnusualKind.amount, o, usual, before.length),
          );
        }
      }
    }
    before.add(o);
  }
  result.sort(
    (a, b) => a.operation.amountCents.compareTo(b.operation.amountCents),
  );
  return result;
}

/// How far the forecasts can be trusted, from what happened: planned
/// operations that came as planned, and the variable spending estimated for
/// the last complete month against what was really spent.
class ForecastReliability {
  final int plannedDue;
  final int plannedPaid;
  final int plannedLate;
  final int? variableEstimateCents;
  final int? variableActualCents;

  const ForecastReliability({
    required this.plannedDue,
    required this.plannedPaid,
    required this.plannedLate,
    this.variableEstimateCents,
    this.variableActualCents,
  });

  /// Planned operations that came, in percent; null without any due.
  int? get plannedPercent =>
      plannedDue == 0 ? null : plannedPaid * 100 ~/ plannedDue;

  /// Gap of the estimate to the actual, in percent of the actual (positive:
  /// more spent than estimated); null without both.
  int? get variableGapPercent {
    final e = variableEstimateCents, a = variableActualCents;
    if (e == null || a == null || a == 0) return null;
    return (a - e) * 100 ~/ a;
  }
}
