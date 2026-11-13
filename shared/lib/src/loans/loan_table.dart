import '../local_date.dart';
import 'amortization.dart';

/// One row of a lender's amortisation table, as read from the document
/// (figures in cents; null when not read).
class LoanTableRow {
  final int number;
  final int? paymentCents;
  final int? interestCents;
  final int? remainingCents;

  const LoanTableRow({
    required this.number,
    this.paymentCents,
    this.interestCents,
    this.remainingCents,
  });
}

/// A row the engine could not explain: [field] read differs from the
/// schedule computed with the changes found.
class LoanTableGap {
  final int number;

  /// `payment`, `interest`, `remaining` or `missing` (no such instalment in
  /// the schedule computed).
  final String field;
  final int? readCents;
  final int? computedCents;

  const LoanTableGap({
    required this.number,
    required this.field,
    this.readCents,
    this.computedCents,
  });
}

class LoanTableReading {
  /// Interest of the first instalment as row 1 shows it, when the terms
  /// had none and it differs from the one computed (intercalary period).
  final int? firstInterestCents;

  /// What changed the loan according to its table (new rate, new
  /// instalment, pause, money repaid early), oldest first.
  final List<LoanChange> changes;

  /// Rows compared (with at least one figure read).
  final int rowsCompared;

  /// Rows that still differ with [changes], first ones only.
  final List<LoanTableGap> gaps;

  /// Rows that differ, in all.
  final int gapCount;

  /// First and last instalment numbers read.
  final int firstNumber;
  final int lastNumber;

  const LoanTableReading({
    this.firstInterestCents,
    required this.changes,
    required this.rowsCompared,
    required this.gaps,
    required this.gapCount,
    required this.firstNumber,
    required this.lastNumber,
  });
}

/// Largest gap, in cents, between a figure of the table and the same figure
/// computed that is not reported (banks round differently). The capital
/// still owed also allows 0.05 % (rounding builds up over the years).
const int loanTableToleranceCents = 100;

/// Most changes deduced from one table.
const int maxLoanTableChanges = 40;

/// Most gaps listed (all are counted).
const int _maxGapsListed = 10;

/// Rows left unexplained after which no more change is looked for.
const int _maxGapsSearched = 24;

/// Finds what changed a loan from the lender's full amortisation table:
/// the engine computes the schedule from [terms] and, at each row it does
/// not explain, tries the changes the row suggests (a new rate from the
/// interest on the capital owed before, a new instalment, a pause from an
/// instalment without capital, money repaid from a drop of the capital
/// owed). A change is kept when it explains that row and the next one at
/// least. Rows nothing explains are
/// reported as gaps, never guessed. Deterministic, without AI: the model
/// only reads the figures. [known] are changes the table does not show
/// (before its first row read), applied first and not returned.
LoanTableReading readLoanTable(
  LoanTerms terms,
  List<LoanTableRow> rows, {
  List<LoanChange> known = const [],
}) {
  final byNumber = <int, LoanTableRow>{};
  for (final r in rows) {
    final ok =
        r.number >= 1 &&
        r.number <= maxLoanMonths &&
        _valid(r.paymentCents) &&
        _valid(r.interestCents) &&
        _valid(r.remainingCents) &&
        (r.paymentCents != null ||
            r.interestCents != null ||
            r.remainingCents != null);
    if (ok) byNumber.putIfAbsent(r.number, () => r);
  }
  final table = byNumber.values.toList()
    ..sort((a, b) => a.number.compareTo(b.number));
  if (table.isEmpty) {
    return const LoanTableReading(
      changes: [],
      rowsCompared: 0,
      gaps: [],
      gapCount: 0,
      firstNumber: 0,
      lastNumber: 0,
    );
  }
  // Row 1 tells the first instalment's interest (intercalary period) when
  // the terms do not.
  int? firstInterest;
  final one = byNumber[1]?.interestCents;
  if (one != null && terms.firstInterestCents == null) {
    final computed = amortize(
      terms,
      changes: known,
    ).firstOrNull?.interestCents;
    if (computed != null && (one - computed).abs() > loanTableToleranceCents) {
      try {
        terms = LoanTerms(
          principalCents: terms.principalCents,
          annualRateMilli: terms.annualRateMilli,
          months: terms.months,
          firstDue: terms.firstDue,
          insuranceMonthlyCents: terms.insuranceMonthlyCents,
          disbursementDate: terms.disbursementDate,
          firstInterestCents: one,
          paymentCents: terms.paymentCents,
        );
        firstInterest = one;
      } on ArgumentError {
        // Out of the limits: row 1 stays a gap.
      }
    }
  }
  final changes = <LoanChange>[...known];
  final gapRows = <int>{};
  // Rows followed by money repaid: the capital owed after them is the
  // table's, not the one computed before the repayment.
  final repaidAfter = <int>{};
  var schedule = _numbered(amortize(terms, changes: changes));
  var start = 0;
  // Each turn either explains a row (and moves past it) or reports it.
  for (var turn = 0; turn < table.length + maxLoanTableChanges; turn++) {
    final j = _firstMismatch(table, schedule, start);
    if (j == null) break;
    LoanChange? best;
    var bestFrom = j;
    var bestScore = 0;
    if (changes.length - known.length < maxLoanTableChanges) {
      for (final (c, from) in _candidates(terms, table, j, schedule)) {
        final Map<int, Installment> s;
        try {
          s = _numbered(amortize(terms, changes: [...changes, c]));
        } on ArgumentError {
          continue;
        }
        final score = _matching(table, s, from);
        // Confirmed by the next row: a single row read wrong is not a change.
        if (score >= 2 && score > bestScore) {
          (best, bestFrom, bestScore) = (c, from, score);
        }
      }
    }
    if (best == null) {
      gapRows.add(j);
      // A table the engine cannot follow: the rest is only compared.
      if (gapRows.length >= _maxGapsSearched) break;
      start = j + 1;
      continue;
    }
    if (bestFrom > j) repaidAfter.add(j);
    changes.add(best);
    schedule = _numbered(amortize(terms, changes: changes));
    start = bestFrom;
  }
  // Final comparison with the changes kept.
  final gaps = <LoanTableGap>[];
  var count = 0;
  var compared = 0;
  for (final (i, r) in table.indexed) {
    compared++;
    final gap = _gap(r, schedule[r.number]);
    if (gap == null) continue;
    // A row before money repaid shows the capital after it.
    if (gap.field == 'remaining' && repaidAfter.contains(i)) continue;
    count++;
    if (gaps.length < _maxGapsListed) gaps.add(gap);
  }
  return LoanTableReading(
    firstInterestCents: firstInterest,
    changes: changes.sublist(known.length),
    rowsCompared: compared,
    gaps: gaps,
    gapCount: count,
    firstNumber: table.first.number,
    lastNumber: table.last.number,
  );
}

bool _valid(int? cents) =>
    cents == null || (cents >= 0 && cents <= 5 * maxLoanPrincipalCents);

Map<int, Installment> _numbered(List<Installment> s) => {
  for (final i in s) i.number: i,
};

bool _close(int? read, int computed, [int extra = 0]) =>
    read == null || (read - computed).abs() <= loanTableToleranceCents + extra;

LoanTableGap? _gap(LoanTableRow r, Installment? c) {
  if (c == null) return LoanTableGap(number: r.number, field: 'missing');
  if (!_close(r.paymentCents, c.paymentCents)) {
    return LoanTableGap(
      number: r.number,
      field: 'payment',
      readCents: r.paymentCents,
      computedCents: c.paymentCents,
    );
  }
  if (!_close(r.interestCents, c.interestCents)) {
    return LoanTableGap(
      number: r.number,
      field: 'interest',
      readCents: r.interestCents,
      computedCents: c.interestCents,
    );
  }
  if (!_close(r.remainingCents, c.remainingCents, c.remainingCents ~/ 2000)) {
    return LoanTableGap(
      number: r.number,
      field: 'remaining',
      readCents: r.remainingCents,
      computedCents: c.remainingCents,
    );
  }
  return null;
}

int? _firstMismatch(
  List<LoanTableRow> table,
  Map<int, Installment> schedule,
  int start,
) {
  for (var j = start; j < table.length; j++) {
    if (_gap(table[j], schedule[table[j].number]) != null) return j;
  }
  return null;
}

/// Rows that match from [from] on, until the first that does not.
int _matching(
  List<LoanTableRow> table,
  Map<int, Installment> schedule,
  int from,
) {
  var n = 0;
  for (var j = from; j < table.length; j++) {
    if (_gap(table[j], schedule[table[j].number]) != null) break;
    n++;
  }
  return n;
}

/// The changes row [j] suggests, simplest first, each with the row its
/// check starts from.
Iterable<(LoanChange, int)> _candidates(
  LoanTerms terms,
  List<LoanTableRow> table,
  int j,
  Map<int, Installment> schedule,
) sync* {
  final r = table[j];
  final n = r.number;
  final date = terms.firstDue.addMonths(n - 1);
  final computed = schedule[n];
  final prevRow = j > 0 && table[j - 1].number == n - 1 ? table[j - 1] : null;
  final before =
      prevRow?.remainingCents ??
      schedule[n - 1]?.remainingCents ??
      (n == 1 ? terms.principalCents : null);
  LoanChange? make(
    LocalDate date, {
    int? rate,
    int? payment,
    int draw = 0,
    int? pause,
    bool capitalized = false,
  }) {
    try {
      return LoanChange(
        date: date,
        annualRateMilli: rate,
        paymentCents: payment,
        drawCents: draw,
        pauseMonths: pause,
        pauseCapitalized: capitalized,
      );
    } on ArgumentError {
      return null;
    }
  }

  // A pause: no capital repaid (the capital owed stays the same) or nothing
  // paid (it grows), for as many rows in a row.
  if (before != null && r.remainingCents != null) {
    final total = r.remainingCents! > before + loanTableToleranceCents;
    final partial =
        !total && (r.remainingCents! - before).abs() <= loanTableToleranceCents;
    if (total || partial) {
      var count = 1;
      var owed = r.remainingCents!;
      for (var i = j + 1; i < table.length; i++) {
        final x = table[i];
        if (x.number != n + count || x.remainingCents == null) break;
        final grows = x.remainingCents! > owed + loanTableToleranceCents;
        final same =
            (x.remainingCents! - owed).abs() <= loanTableToleranceCents;
        if (total ? !grows : !same) break;
        owed = x.remainingCents!;
        if (++count >= maxLoanPauseMonths) break;
      }
      // A new instalment after it is found on the next turn.
      final pause = make(date, pause: count, capitalized: total);
      if (pause != null) yield (pause, j);
    }
  }
  // A new rate: the interest of the row on the capital owed before it.
  final interest = r.interestCents;
  if (n > 1 && interest != null && before != null && before > 0) {
    final exact = interest * 1200000 / before;
    final rates = {(exact / 10).round() * 10, exact.round()};
    for (final rate in rates) {
      final c = make(date, rate: rate);
      if (c != null) yield (c, j);
      if (r.paymentCents != null && r.paymentCents! > 0) {
        final both = make(date, rate: rate, payment: r.paymentCents);
        if (both != null) yield (both, j);
      }
    }
  }
  // A new instalment.
  if (r.paymentCents != null && r.paymentCents! > 0) {
    final c = make(date, payment: r.paymentCents);
    if (c != null) yield (c, j);
  }
  // Money repaid (or drawn) before this row: the capital owed before it is
  // what the row still owes plus the capital it repays.
  final payment = r.paymentCents, owedAfter = r.remainingCents;
  if (before != null &&
      payment != null &&
      interest != null &&
      owedAfter != null &&
      payment >= interest) {
    final draw = owedAfter + payment - interest - before;
    if (draw.abs() > loanTableToleranceCents) {
      final repaid = make(date, draw: draw);
      if (repaid != null) yield (repaid, j);
      if (payment > 0) {
        final both = make(date, draw: draw, payment: payment);
        if (both != null) yield (both, j);
      }
    }
  }
  // Money repaid (or drawn) after this row: the instalment matches, the
  // capital owed after it does not. The change applies to the next row.
  if (computed != null &&
      r.remainingCents != null &&
      j + 1 < table.length &&
      _close(r.paymentCents, computed.paymentCents) &&
      _close(r.interestCents, computed.interestCents)) {
    final draw = r.remainingCents! - computed.remainingCents;
    final next = table[j + 1];
    final nextDate = terms.firstDue.addMonths(next.number - 1);
    if (draw != 0 && next.number == n + 1) {
      final repaid = make(nextDate, draw: draw);
      if (repaid != null) yield (repaid, j + 1);
      final p = next.paymentCents;
      if (p != null && p > 0) {
        final both = make(nextDate, draw: draw, payment: p);
        if (both != null) yield (both, j + 1);
      }
    }
  }
}
