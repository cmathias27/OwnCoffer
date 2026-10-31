import '../labels/label_cleaner.dart';
import '../local_date.dart';
import '../money.dart';
import '../text.dart';
import 'recurrence.dart';

/// A planned operation: rent, salary, subscription…
class ScheduledOperation {
  final Object id;

  /// Signed cents, negative for a debit.
  final int amountCents;
  final String label;
  final Recurrence recurrence;

  /// First occurrence not yet realised (matched with a real operation or
  /// skipped by the user). Null means "from the start of the recurrence".
  final LocalDate? nextDue;

  /// Words expected in the real operation's label, for reconciliation
  /// (normalised). Empty: amount and date only.
  final String matchPattern;

  /// How far the real operation may be from the planned date.
  final int dateToleranceDays;

  /// Allowed amount difference for variable bills (electricity…), in percent.
  final int amountTolerancePercent;

  ScheduledOperation({
    required this.id,
    required this.amountCents,
    required this.label,
    required this.recurrence,
    this.nextDue,
    String matchPattern = '',
    this.dateToleranceDays = 5,
    this.amountTolerancePercent = 0,
  }) : matchPattern = normalizeForMatch(matchPattern) {
    if (amountCents == 0) throw ArgumentError('Scheduled amount is zero');
  }

  LocalDate get _from => nextDue ?? recurrence.start;

  /// Occurrences still expected, from [nextDue] up to [to].
  List<LocalDate> pendingUntil(LocalDate to) => recurrence.between(_from, to);
}

/// A real operation already known for the account.
class RealOperation {
  final Object id;
  final LocalDate date;
  final int amountCents;
  final CleanedLabel label;

  const RealOperation({
    required this.id,
    required this.date,
    required this.amountCents,
    required this.label,
  });
}

class ForecastEvent {
  final LocalDate date;
  final int amountCents;
  final String label;

  /// The scheduled operation it comes from; null for a real operation dated
  /// in the future.
  final Object? scheduledId;

  /// Original due date, when the occurrence is late and moved to today.
  final LocalDate? dueDate;

  const ForecastEvent({
    required this.date,
    required this.amountCents,
    required this.label,
    this.scheduledId,
    this.dueDate,
  });

  bool get isLate => dueDate != null;
}

class DailyBalance {
  final LocalDate date;

  /// Balance at the end of the day, in cents.
  final int balanceCents;

  const DailyBalance(this.date, this.balanceCents);

  @override
  String toString() => '$date: ${formatCents(balanceCents)}';
}

/// A scheduled occurrence that never arrived and is too old to be counted.
class MissedOccurrence {
  final Object scheduledId;
  final LocalDate dueDate;
  final int amountCents;

  const MissedOccurrence(this.scheduledId, this.dueDate, this.amountCents);
}

class Forecast {
  final LocalDate today;
  final LocalDate until;
  final int startBalanceCents;
  final int alertThresholdCents;

  /// Chronological; events of the same day keep a stable order (debits
  /// first, so the low point of the day is never hidden).
  final List<ForecastEvent> events;

  /// One entry per day from [today] to [until].
  final List<DailyBalance> days;
  final List<MissedOccurrence> missed;

  /// Estimated variable spending counted in [days] (positive).
  final int variableCents;

  const Forecast({
    required this.today,
    required this.until,
    required this.startBalanceCents,
    required this.alertThresholdCents,
    required this.events,
    required this.days,
    required this.missed,
    this.variableCents = 0,
  });

  int get endBalanceCents => days.last.balanceCents;

  /// Lowest end-of-day balance (first day reaching it).
  DailyBalance get lowest =>
      days.reduce((a, b) => b.balanceCents < a.balanceCents ? b : a);

  /// First day whose end-of-day balance is below the alert threshold.
  DailyBalance? get firstBelowThreshold {
    for (final d in days) {
      if (d.balanceCents < alertThresholdCents) return d;
    }
    return null;
  }

  bool get overdraftExpected => firstBelowThreshold != null;

  int balanceOn(LocalDate date) {
    if (date < today) throw ArgumentError('Date before forecast start');
    if (date > until) throw ArgumentError('Date after forecast end');
    return days[today.daysUntil(date)].balanceCents;
  }
}

/// Projects the balance of one account, day by day.
///
/// - [currentBalanceCents]: initial balance + every real operation dated
///   today or earlier.
/// - [futureOperations]: real operations dated after today (deferred debits).
/// - Pending scheduled occurrences due before today are still expected: if
///   they are at most [lateGraceDays] late they are counted today, otherwise
///   they are reported in [Forecast.missed] and not counted.
/// - [variableSpending]: estimated variable spending by day (positive cents,
///   see `spreadVariableSpending`), taken off the balance after the events
///   of the day.
Forecast computeForecast({
  required int currentBalanceCents,
  required LocalDate today,
  required List<ScheduledOperation> scheduled,
  List<RealOperation> futureOperations = const [],
  int horizonDays = 30,
  int alertThresholdCents = 0,
  int lateGraceDays = 10,
  Map<LocalDate, int> variableSpending = const {},
}) {
  if (horizonDays < 0) throw ArgumentError('Negative horizon');
  final until = today.addDays(horizonDays);
  final events = <ForecastEvent>[];
  final missed = <MissedOccurrence>[];

  for (final s in scheduled) {
    for (final due in s.pendingUntil(until)) {
      if (due >= today) {
        events.add(
          ForecastEvent(
            date: due,
            amountCents: s.amountCents,
            label: s.label,
            scheduledId: s.id,
          ),
        );
      } else if (due.daysUntil(today) <= lateGraceDays) {
        events.add(
          ForecastEvent(
            date: today,
            amountCents: s.amountCents,
            label: s.label,
            scheduledId: s.id,
            dueDate: due,
          ),
        );
      } else {
        missed.add(MissedOccurrence(s.id, due, s.amountCents));
      }
    }
  }
  for (final op in futureOperations) {
    if (op.date > today && op.date <= until) {
      events.add(
        ForecastEvent(
          date: op.date,
          amountCents: op.amountCents,
          label: op.label.display,
        ),
      );
    }
  }

  events.sort((a, b) {
    final d = a.date.compareTo(b.date);
    if (d != 0) return d;
    final s = a.amountCents.sign.compareTo(b.amountCents.sign);
    if (s != 0) return s;
    return a.label.compareTo(b.label);
  });

  final days = <DailyBalance>[];
  var balance = currentBalanceCents;
  var variable = 0;
  var e = 0;
  for (var day = today; day <= until; day = day.addDays(1)) {
    while (e < events.length && events[e].date == day) {
      balance = sumCents([balance, events[e].amountCents]);
      e++;
    }
    final v = variableSpending[day] ?? 0;
    balance = sumCents([balance, -v]);
    variable += v;
    days.add(DailyBalance(day, balance));
  }

  return Forecast(
    today: today,
    until: until,
    startBalanceCents: currentBalanceCents,
    alertThresholdCents: alertThresholdCents,
    events: events,
    days: days,
    missed: missed,
    variableCents: variable,
  );
}

/// The three balances of an account (cahier des charges, "Comptes").
class AccountBalances {
  /// Initial balance + checked (pointed) operations.
  final int clearedCents;

  /// Initial balance + all operations dated today or earlier.
  final int currentCents;

  /// Initial balance + all real operations, including future-dated ones.
  final int allRealCents;

  const AccountBalances(
    this.clearedCents,
    this.currentCents,
    this.allRealCents,
  );
}

class BalanceInput {
  final LocalDate date;
  final int amountCents;
  final bool cleared;
  const BalanceInput(this.date, this.amountCents, {this.cleared = false});
}

AccountBalances computeBalances({
  required int initialBalanceCents,
  required Iterable<BalanceInput> operations,
  required LocalDate today,
}) {
  final ops = operations.toList();
  return AccountBalances(
    sumCents([
      initialBalanceCents,
      for (final o in ops)
        if (o.cleared) o.amountCents,
    ]),
    sumCents([
      initialBalanceCents,
      for (final o in ops)
        if (o.date <= today) o.amountCents,
    ]),
    sumCents([initialBalanceCents, for (final o in ops) o.amountCents]),
  );
}

/// A proposed link between a scheduled occurrence and a real operation.
class ReconciliationMatch {
  final Object scheduledId;
  final LocalDate dueDate;
  final Object operationId;

  /// Exact amount, and label pattern found when one is set: safe to confirm
  /// automatically. Otherwise the user confirms.
  final bool exact;

  const ReconciliationMatch(
    this.scheduledId,
    this.dueDate,
    this.operationId, {
    required this.exact,
  });
}

/// Pairs pending scheduled occurrences (due up to [today] + tolerance) with
/// real operations not yet linked. Each side is used at most once; closest
/// amount, then closest date, wins.
List<ReconciliationMatch> reconcile({
  required List<ScheduledOperation> scheduled,
  required List<RealOperation> unlinkedOperations,
  required LocalDate today,
}) {
  final candidates = <_Candidate>[];
  for (final s in scheduled) {
    final horizon = today.addDays(s.dateToleranceDays);
    for (final due in s.pendingUntil(horizon)) {
      for (final op in unlinkedOperations) {
        if (op.amountCents.sign != s.amountCents.sign) continue;
        final dayGap = (op.date.daysUntil(due)).abs();
        if (dayGap > s.dateToleranceDays) continue;
        final diff = (op.amountCents - s.amountCents).abs();
        // Integer comparison: diff / |amount| <= percent / 100.
        if (diff * 100 > s.amountCents.abs() * s.amountTolerancePercent) {
          continue;
        }
        final labelOk =
            s.matchPattern.isEmpty ||
            containsWords(op.label.full, s.matchPattern);
        if (!labelOk && s.amountTolerancePercent > 0) continue;
        candidates.add(
          _Candidate(s, due, op, diff, dayGap, exact: diff == 0 && labelOk),
        );
      }
    }
  }
  candidates.sort((a, b) {
    if (a.exact != b.exact) return a.exact ? -1 : 1;
    final c = a.amountDiff.compareTo(b.amountDiff);
    if (c != 0) return c;
    final d = a.dayGap.compareTo(b.dayGap);
    if (d != 0) return d;
    return a.due.compareTo(b.due);
  });
  final usedOccurrences = <String>{};
  final usedOperations = <Object>{};
  final result = <ReconciliationMatch>[];
  for (final c in candidates) {
    final occurrenceKey = '${c.scheduled.id}|${c.due}';
    if (usedOccurrences.contains(occurrenceKey) ||
        usedOperations.contains(c.operation.id)) {
      continue;
    }
    usedOccurrences.add(occurrenceKey);
    usedOperations.add(c.operation.id);
    result.add(
      ReconciliationMatch(
        c.scheduled.id,
        c.due,
        c.operation.id,
        exact: c.exact,
      ),
    );
  }
  return result;
}

class _Candidate {
  final ScheduledOperation scheduled;
  final LocalDate due;
  final RealOperation operation;
  final int amountDiff;
  final int dayGap;
  final bool exact;

  _Candidate(
    this.scheduled,
    this.due,
    this.operation,
    this.amountDiff,
    this.dayGap, {
    required this.exact,
  });
}
