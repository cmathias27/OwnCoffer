import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/alert_service.dart';
import '../finance/forecast_service.dart';
import '../finance/spending_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Planned operations (rent, salary, subscriptions…) and the forecast.
class ScheduledEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<List<ScheduledTransaction>> list(
    Session session,
    int accountId,
  ) async {
    await Access.requireAccount(session, accountId);
    return ScheduledTransaction.db.find(
      session,
      where: (s) => s.accountId.equals(accountId) & s.deletedAt.equals(null),
      orderBy: (s) => s.startDate,
    );
  }

  Future<ScheduledTransaction> create(
    Session session,
    int accountId,
    int amountCents,
    String label,
    ScheduleFrequency frequency,
    DateTime startDate, {
    int? interval,
    DateTime? endDate,
    int? occurrenceCount,
    int? categoryId,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    bool? subscription,
  }) async {
    final account = await Access.requireAccount(
      session,
      accountId,
      write: true,
    );
    if (categoryId != null) {
      await _ownCategory(session, account.groupId, categoryId);
    }
    final row = _validated(
      ScheduledTransaction(
        accountId: accountId,
        amountCents: amountCents,
        label: label.trim(),
        categoryId: categoryId,
        frequency: frequency,
        interval: interval ?? 1,
        startDate: _day(startDate),
        endDate: endDate == null ? null : _day(endDate),
        occurrenceCount: occurrenceCount,
        matchPattern: core.normalizeForMatch(matchPattern ?? ''),
        dateToleranceDays: dateToleranceDays ?? 5,
        amountTolerancePercent: amountTolerancePercent ?? 0,
        subscription: subscription ?? false,
      ),
    );
    final saved = await ScheduledTransaction.db.insertRow(session, row);
    await AlertService.checkAfterChange(session, account);
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'create',
      entity: 'scheduled',
      rowId: saved.id,
      after: saved,
    );
    return saved;
  }

  Future<ScheduledTransaction> update(
    Session session,
    int scheduledId, {
    int? amountCents,
    String? label,
    int? categoryId,
    DateTime? endDate,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    bool? subscription,
  }) async {
    final (current, account) = await _find(session, scheduledId);
    if (categoryId != null) {
      await _ownCategory(session, account.groupId, categoryId);
    }
    final next = _validated(
      current.copyWith(
        amountCents: amountCents,
        label: label?.trim(),
        categoryId: categoryId,
        endDate: endDate == null ? null : _day(endDate),
        matchPattern: matchPattern == null
            ? null
            : core.normalizeForMatch(matchPattern),
        dateToleranceDays: dateToleranceDays,
        amountTolerancePercent: amountTolerancePercent,
        subscription: subscription,
      ),
    );
    final saved = await ScheduledTransaction.db.updateRow(session, next);
    await AlertService.checkAfterChange(session, account);
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'update',
      entity: 'scheduled',
      rowId: scheduledId,
      before: current,
      after: saved,
    );
    return saved;
  }

  Future<void> delete(Session session, int scheduledId) async {
    final (current, account) = await _find(session, scheduledId);
    await session.db.transaction((tx) async {
      await ScheduledTransaction.db.updateRow(
        session,
        current.copyWith(deletedAt: DateTime.now().toUtc()),
        transaction: tx,
      );
      // Its operations are no longer realisations of anything.
      final linked = await BankTransaction.db.find(
        session,
        where: (t) => t.scheduledId.equals(scheduledId),
        transaction: tx,
      );
      if (linked.isNotEmpty) {
        await BankTransaction.db.update(session, [
          for (final t in linked)
            t.copyWith(scheduledId: null, scheduledDueDate: null),
        ], transaction: tx);
      }
    });
    await AlertService.checkAfterChange(session, account);
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'delete',
      entity: 'scheduled',
      rowId: scheduledId,
      before: current,
    );
  }

  /// Subscriptions of the accounts the user may see, with their monthly
  /// cost. Ended ones (last occurrence passed) are left out.
  Future<SubscriptionOverview> subscriptions(
    Session session,
    int groupId,
  ) async {
    final visible = await Access.visibleAccounts(session, groupId);
    final Set<int> ids = {for (final a in visible) a.id!};
    final today = core.LocalDate.fromDateTime(DateTime.now().toUtc());
    final items = [
      for (final s in await ScheduledTransaction.db.find(
        session,
        where: (s) =>
            s.accountId.inSet(ids) &
            s.deletedAt.equals(null) &
            s.subscription.equals(true),
        orderBy: (s) => s.label,
      ))
        if (ForecastService.recurrenceOf(s).nextAfter(today.addDays(-1)) !=
            null)
          s,
    ];
    final monthly = [
      for (final s in items)
        core.monthlyEquivalentCents(
          s.amountCents,
          core.Frequency.values.byName(s.frequency.name),
          s.interval,
        ),
    ];
    final total = monthly.fold(0, (a, b) => a + b);
    return SubscriptionOverview(
      items: items,
      monthlyCents: monthly,
      monthlyTotalCents: total,
      yearlyTotalCents: total * 12,
    );
  }

  /// "This is a subscription": a planned operation repeating [transactionId]
  /// (same amount, label and category) from its date, the operation itself
  /// being its first occurrence. Later debits are matched on the label, with
  /// a 10 % amount tolerance for price changes.
  Future<ScheduledTransaction> subscribeFrom(
    Session session,
    int transactionId, {
    ScheduleFrequency? frequency,
  }) async {
    final t = await BankTransaction.db.findById(session, transactionId);
    if (t == null || t.deletedAt != null) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    final Account account;
    try {
      account = await Access.requireAccount(session, t.accountId, write: true);
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    if (t.scheduledId != null) {
      final existing = await ScheduledTransaction.db.findById(
        session,
        t.scheduledId!,
      );
      if (existing != null && existing.deletedAt == null) {
        return ScheduledTransaction.db.updateRow(
          session,
          existing.copyWith(subscription: true),
        );
      }
    }
    final f = frequency ?? ScheduleFrequency.monthly;
    if (f == ScheduleFrequency.once) {
      throw InvalidInputException(code: 'invalid_recurrence');
    }
    final label = t.cleanLabel.length > 80
        ? t.cleanLabel.substring(0, 80)
        : t.cleanLabel;
    final saved = await ScheduledTransaction.db.insertRow(
      session,
      _validated(
        ScheduledTransaction(
          accountId: account.id!,
          amountCents: t.amountCents,
          label: label,
          categoryId: t.categoryId,
          frequency: f,
          startDate: t.date,
          matchPattern: core.normalizeForMatch(t.cleanLabel.toUpperCase()),
          dateToleranceDays: 5,
          amountTolerancePercent: 10,
          subscription: true,
        ),
      ),
    );
    await ForecastService.link(session, saved, t.date.toLocalDate(), t);
    await AlertService.checkAfterChange(session, account);
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'subscribe_from',
      entity: 'scheduled',
      rowId: saved.id,
      after: saved,
    );
    return (await ScheduledTransaction.db.findById(session, saved.id!))!;
  }

  /// Due dates of the budget month containing [date], on the accounts the
  /// user may see (or the one asked for): each occurrence of the planned
  /// operations, paid, late, skipped or to come.
  Future<DueCalendar> calendar(
    Session session,
    int groupId,
    DateTime date, {
    int? accountId,
  }) async {
    final ids = await SpendingService.accounts(session, groupId, accountId);
    final u = date.toUtc();
    final month = await SpendingService.period(
      session,
      groupId,
      core.PeriodKind.month,
      core.LocalDate(u.year, u.month, u.day),
    );
    final today = core.LocalDate.fromDateTime(DateTime.now().toUtc());
    final rows = ids.isEmpty
        ? <ScheduledTransaction>[]
        : await ScheduledTransaction.db.find(
            session,
            where: (s) => s.accountId.inSet(ids) & s.deletedAt.equals(null),
          );
    final Set<int> scheduledIds = {for (final s in rows) s.id!};
    final linked = <(int, core.LocalDate), BankTransaction>{};
    final loans = <int, int>{};
    if (scheduledIds.isNotEmpty) {
      for (final t in await BankTransaction.db.find(
        session,
        where: (t) =>
            t.scheduledId.inSet(scheduledIds) &
            t.deletedAt.equals(null) &
            (t.scheduledDueDate >= month.start.toDb()) &
            (t.scheduledDueDate < month.end.toDb()),
      )) {
        linked[(t.scheduledId!, t.scheduledDueDate!.toLocalDate())] = t;
      }
      for (final l in await Loan.db.find(
        session,
        where: (l) =>
            l.scheduledId.inSet(scheduledIds) & l.deletedAt.equals(null),
      )) {
        loans[l.scheduledId!] = l.id!;
      }
    }
    final items = <CalendarItem>[];
    var debits = 0, credits = 0;
    for (final s in rows) {
      for (final due in ForecastService.recurrenceOf(
        s,
      ).between(month.start, month.last)) {
        final t = linked[(s.id!, due)];
        final status = OccurrenceStatus.values.byName(
          core
              .occurrenceStatus(
                due: due,
                today: today,
                linked: t != null,
                nextDue: s.nextDue?.toLocalDate(),
              )
              .name,
        );
        if (status == OccurrenceStatus.upcoming ||
            status == OccurrenceStatus.late) {
          if (s.amountCents < 0) {
            debits += s.amountCents;
          } else {
            credits += s.amountCents;
          }
        }
        items.add(
          CalendarItem(
            date: due.toDb(),
            scheduledId: s.id!,
            accountId: s.accountId,
            label: s.label,
            amountCents: s.amountCents,
            categoryId: s.categoryId,
            subscription: s.subscription,
            loanId: loans[s.id],
            status: status,
            transactionId: t?.id,
            transactionAmountCents: t?.amountCents,
          ),
        );
      }
    }
    items.sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.amountCents.compareTo(b.amountCents);
    });
    return DueCalendar(
      start: month.start.toDb(),
      last: month.last.toDb(),
      items: items,
      upcomingDebitsCents: debits,
      upcomingCreditsCents: credits,
    );
  }

  /// The next occurrence will not happen (or was paid otherwise): skip it.
  Future<ScheduledTransaction> skipNext(
    Session session,
    int scheduledId,
  ) async {
    final (current, _) = await _find(session, scheduledId);
    final recurrence = ForecastService.recurrenceOf(current);
    final from = current.nextDue?.toLocalDate() ?? recurrence.start;
    final due = recurrence.between(from, from.addDays(400)).firstOrNull;
    if (due == null) return current;
    final next = recurrence.nextAfter(due) ?? due.addDays(1);
    return ScheduledTransaction.db.updateRow(
      session,
      current.copyWith(nextDue: next.toDb()),
    );
  }

  /// Forecast of the account from the user's [today] (calendar date of the
  /// device; must be within a day of the server's date). [includeVariable]
  /// (default true) adds the estimated variable spending.
  Future<ForecastResult> forecast(
    Session session,
    int accountId,
    DateTime today, {
    int? horizonDays,
    bool? includeVariable,
  }) async {
    final account = await Access.requireAccount(session, accountId);
    final t = today.toUtc();
    final day = core.LocalDate(t.year, t.month, t.day);
    final server = core.LocalDate.fromDateTime(DateTime.now().toUtc());
    if (day.daysUntil(server).abs() > 1) {
      throw InvalidInputException(code: 'invalid_date', field: 'today');
    }
    final horizon = horizonDays ?? 30;
    if (horizon < 1 || horizon > 366) {
      throw InvalidInputException(code: 'invalid_horizon');
    }
    return ForecastService.compute(
      session,
      account,
      day,
      horizonDays: horizon,
      variable: includeVariable ?? true,
    );
  }

  /// Confirms a reconciliation proposal.
  Future<void> confirmMatch(
    Session session,
    int scheduledId,
    DateTime dueDate,
    int transactionId,
  ) async {
    final (scheduled, account) = await _find(session, scheduledId);
    final t = await BankTransaction.db.findById(session, transactionId);
    if (t == null || t.accountId != account.id || t.deletedAt != null) {
      throw AccessDeniedException(code: 'account_access_denied');
    }
    final due = _day(dueDate).toLocalDate();
    if (!ForecastService.recurrenceOf(
      scheduled,
    ).between(due, due).contains(due)) {
      throw InvalidInputException(code: 'invalid_date', field: 'dueDate');
    }
    await ForecastService.link(session, scheduled, due, t);
  }

  static DateTime _day(DateTime d) {
    final u = d.toUtc();
    return DateTime.utc(u.year, u.month, u.day);
  }

  static ScheduledTransaction _validated(ScheduledTransaction s) {
    if (s.label.isEmpty || s.label.length > 80) {
      throw InvalidInputException(code: 'invalid_name', field: 'label');
    }
    if (s.amountCents == 0 || s.amountCents.abs() > 100000000000000) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    if (s.interval < 1 || s.interval > 120) {
      throw InvalidInputException(code: 'invalid_interval');
    }
    if (s.dateToleranceDays < 0 ||
        s.dateToleranceDays > 31 ||
        s.amountTolerancePercent < 0 ||
        s.amountTolerancePercent > 100) {
      throw InvalidInputException(code: 'invalid_tolerance');
    }
    try {
      ForecastService.recurrenceOf(s);
    } on ArgumentError {
      throw InvalidInputException(code: 'invalid_recurrence');
    }
    return s;
  }

  static Future<(ScheduledTransaction, Account)> _find(
    Session session,
    int id,
  ) async {
    final s = await ScheduledTransaction.db.findById(session, id);
    if (s == null || s.deletedAt != null) {
      throw AccessDeniedException(code: 'scheduled_access_denied');
    }
    try {
      final account = await Access.requireAccount(
        session,
        s.accountId,
        write: true,
      );
      return (s, account);
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'scheduled_access_denied');
    }
  }

  static Future<void> _ownCategory(
    Session session,
    int groupId,
    int categoryId,
  ) async {
    final c = await Category.db.findById(session, categoryId);
    if (c == null || c.groupId != groupId || c.deletedAt != null) {
      throw AccessDeniedException(code: 'category_access_denied');
    }
  }
}
