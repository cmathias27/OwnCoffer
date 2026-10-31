/// Purchase simulator (cahier des charges : « si j'achète cet équipement à
/// 600 € ce mois-ci, quel sera mon solde au 25 du mois prochain ? »): the
/// same forecast with the purchase paid in cash, in 3 or 4 instalments, or
/// a month later, compared side by side.
library;

import '../loans/amortization.dart';
import '../local_date.dart';
import 'forecast.dart';
import 'recurrence.dart';

enum PurchaseOption {
  /// Not buying: the reference.
  none,
  cash,
  threeTimes,
  fourTimes,

  /// Same day, next month.
  nextMonth,
}

class PurchasePayment {
  final LocalDate date;

  /// Positive.
  final int amountCents;
  const PurchasePayment(this.date, this.amountCents);
}

/// The debits of [option] for a purchase of [amountCents] on [date]. In
/// instalments, monthly from [date], as a payment in several instalments is
/// recorded (page Crédits): instalments rounded up, the last one settling.
List<PurchasePayment> purchasePayments(
  PurchaseOption option,
  int amountCents,
  LocalDate date,
) {
  if (amountCents <= 0) throw ArgumentError.value(amountCents, 'amountCents');
  List<PurchasePayment> split(int n) {
    final each = loanPaymentCents(amountCents, 0, n);
    return [
      for (var i = 0; i < n; i++)
        PurchasePayment(
          date.addMonths(i, preferredDay: date.day),
          i < n - 1 ? each : amountCents - each * (n - 1),
        ),
    ];
  }

  return switch (option) {
    PurchaseOption.none => const [],
    PurchaseOption.cash => [PurchasePayment(date, amountCents)],
    PurchaseOption.threeTimes => split(3),
    PurchaseOption.fourTimes => split(4),
    PurchaseOption.nextMonth => [
      PurchasePayment(date.addMonths(1, preferredDay: date.day), amountCents),
    ],
  };
}

/// One option, computed by the forecast engine.
class PurchaseScenario {
  final PurchaseOption option;
  final List<PurchasePayment> payments;

  /// Balance at the end of the chosen day.
  final int balanceOnTargetCents;
  final DailyBalance lowest;

  /// First day below the account's alert threshold, if any.
  final LocalDate? firstBelowThreshold;

  const PurchaseScenario({
    required this.option,
    required this.payments,
    required this.balanceOnTargetCents,
    required this.lowest,
    required this.firstBelowThreshold,
  });
}

/// Runs [forecast] (the account's forecast for given extra planned
/// operations, up to [until]) once per option. [until] must cover the
/// [target] day and every payment.
List<PurchaseScenario> simulatePurchase({
  required int amountCents,
  required LocalDate date,
  required LocalDate target,
  required LocalDate until,
  required Forecast Function(List<ScheduledOperation> extra) forecast,
  List<PurchaseOption> options = PurchaseOption.values,
}) => [
  for (final o in options)
    () {
      final payments = purchasePayments(o, amountCents, date);
      final f = forecast([
        for (final (i, p) in payments.indexed)
          ScheduledOperation(
            id: 'purchase-$i',
            amountCents: -p.amountCents,
            label: 'purchase',
            recurrence: Recurrence.once(p.date),
          ),
      ]);
      if (target < f.today || target > f.until || f.until < until) {
        throw ArgumentError.value(target, 'target');
      }
      return PurchaseScenario(
        option: o,
        payments: payments,
        balanceOnTargetCents: f.balanceOn(target),
        lowest: f.lowest,
        firstBelowThreshold: f.firstBelowThreshold?.date,
      );
    }(),
];

/// The day the forecast must reach: the target, and the last payment of
/// every option.
LocalDate purchaseHorizon(int amountCents, LocalDate date, LocalDate target) {
  var last = target;
  for (final o in PurchaseOption.values) {
    for (final p in purchasePayments(o, amountCents, date)) {
      if (p.date > last) last = p.date;
    }
  }
  return last;
}
