import '../local_date.dart';
import 'amortization.dart';

/// Which law caps the early repayment penalty (indemnité de remboursement
/// anticipé), French rules.
enum PrepaymentLaw {
  /// Home loan (Code de la consommation, art. L313-47 and R313-25): at most
  /// six months of interest on the amount repaid, and at most 3 % of the
  /// capital owed before the repayment.
  mortgage,

  /// Consumer credit (art. L312-34): at most 1 % of the amount
  /// repaid (0.5 % within the last year), never more than the interest it
  /// saves, nothing when no more than 10 000 € was repaid over 12 months.
  consumer,

  /// Revolving credit, payments in instalments: no penalty.
  none,
}

/// The penalty clause of the loan offer, when read or entered: months of
/// interest on the amount repaid and/or a percentage of it (thousandths of
/// a percent). Both null: unknown, the legal maximum is shown. Zero: no
/// penalty.
class PrepaymentClause {
  final int? interestMonths;
  final int? percentMilli;

  const PrepaymentClause({this.interestMonths, this.percentMilli});

  bool get known => interestMonths != null || percentMilli != null;
}

/// Most months of interest a clause may state.
const int maxPrepaymentInterestMonths = 12;

/// Largest percentage a clause may state (10 %).
const int maxPrepaymentPercentMilli = 10000;

/// Amount repaid over 12 months without penalty on a consumer credit.
const int consumerFreePrepaymentCents = 1000000;

enum PrepaymentBasis {
  /// The clause of the offer, within the legal maximum.
  offer,

  /// The clause is unknown: the most the lender may ask.
  legalMax,

  /// No penalty (clause, law or amount).
  none,
}

class PrepaymentPenalty {
  /// Penalty for this repayment.
  final int penaltyCents;

  /// The most the law allows for it.
  final int legalMaxCents;

  final PrepaymentBasis basis;

  const PrepaymentPenalty({
    required this.penaltyCents,
    required this.legalMaxCents,
    required this.basis,
  });
}

int _percentOf(int cents, int milli) => (cents * milli + 50000) ~/ 100000;

/// Interest of [months] months on [cents] at [rateMilli] (thousandths of a
/// percent a year).
int _interestOf(int cents, int rateMilli, int months) =>
    (cents * rateMilli * months + 600000) ~/ 1200000;

/// The penalty of repaying [amountCents] early, computed by the engine:
/// the clause of the offer when known, never above the legal maximum.
/// [owedBeforeCents] is the capital owed just before the repayment,
/// [rateMilli] the rate then, [monthsLeft] the instalments left before it,
/// [interestSavedCents] what it saves, and [repaidLastYearCents] the money
/// already repaid early over the 12 months before.
PrepaymentPenalty prepaymentPenalty({
  required PrepaymentLaw law,
  required PrepaymentClause clause,
  required int amountCents,
  required int owedBeforeCents,
  required int rateMilli,
  required int monthsLeft,
  required int interestSavedCents,
  int repaidLastYearCents = 0,
}) {
  final amount = amountCents.clamp(
    0,
    owedBeforeCents < 0 ? 0 : owedBeforeCents,
  );
  const none = PrepaymentPenalty(
    penaltyCents: 0,
    legalMaxCents: 0,
    basis: PrepaymentBasis.none,
  );
  if (amount <= 0) return none;
  final saved = interestSavedCents < 0 ? 0 : interestSavedCents;
  final int legal;
  switch (law) {
    case PrepaymentLaw.none:
      return none;
    case PrepaymentLaw.mortgage:
      final six = _interestOf(amount, rateMilli, 6);
      final three = _percentOf(owedBeforeCents, 3000);
      legal = six < three ? six : three;
    case PrepaymentLaw.consumer:
      if (repaidLastYearCents + amount <= consumerFreePrepaymentCents) {
        return none;
      }
      final pct = _percentOf(amount, monthsLeft > 12 ? 1000 : 500);
      legal = pct < saved ? pct : saved;
  }
  if (!clause.known) {
    return PrepaymentPenalty(
      penaltyCents: legal,
      legalMaxCents: legal,
      basis: legal == 0 ? PrepaymentBasis.none : PrepaymentBasis.legalMax,
    );
  }
  var fromClause = 1 << 62;
  if (clause.interestMonths != null) {
    final m = clause.interestMonths!.clamp(0, maxPrepaymentInterestMonths);
    fromClause = _interestOf(amount, rateMilli, m);
  }
  if (clause.percentMilli != null) {
    final p = _percentOf(
      amount,
      clause.percentMilli!.clamp(0, maxPrepaymentPercentMilli),
    );
    if (p < fromClause) fromClause = p;
  }
  final penalty = fromClause < legal ? fromClause : legal;
  return PrepaymentPenalty(
    penaltyCents: penalty,
    legalMaxCents: legal,
    basis: penalty == 0 ? PrepaymentBasis.none : PrepaymentBasis.offer,
  );
}

/// The rate in effect on [date]: the last change of rate on or before it.
int loanRateOn(LoanTerms terms, List<LoanChange> changes, LocalDate date) {
  var rate = terms.annualRateMilli;
  final sorted = [...changes]..sort((a, b) => a.date.compareTo(b.date));
  for (final c in sorted) {
    if (c.date > date) break;
    if (c.annualRateMilli != null) rate = c.annualRateMilli!;
  }
  return rate;
}

/// Money repaid early by [changes] in the 12 months up to [date].
int repaidOverYear(List<LoanChange> changes, LocalDate date) {
  final from = date.addMonths(-12);
  var sum = 0;
  for (final c in changes) {
    if (c.drawCents < 0 && c.date > from && c.date <= date) sum -= c.drawCents;
  }
  return sum;
}
