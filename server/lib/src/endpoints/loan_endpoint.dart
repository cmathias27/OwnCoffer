import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/alert_service.dart';
import '../finance/spending_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Loans: entry, amortisation schedule, where they stand, early repayment
/// simulation. With an account, the instalments become a planned operation
/// (forecast and reconciliation with the real debits).
class LoanEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<LoanOverview> overview(Session session, int groupId) async {
    final loans = await _visible(session, groupId);
    final today = _today();
    final infos = [for (final l in loans) _info(l, today)];
    final running = infos.where((i) => i.nextDueDate != null);
    final monthly = running.fold(
      0,
      (a, i) => a + i.paymentCents + i.loan.insuranceMonthlyCents,
    );
    final income = await SpendingService.averageMonthlyIncome(
      session,
      groupId,
      today,
    );
    return LoanOverview(
      loans: infos,
      totalRemainingCents: infos.fold(0, (a, i) => a + i.remainingCents),
      totalMonthlyCents: monthly,
      monthlyIncomeCents: income,
      debtRatioPerMille: income > 0 ? monthly * 1000 ~/ income : null,
    );
  }

  Future<List<LoanInstallment>> schedule(Session session, int loanId) async {
    final loan = await _find(session, loanId);
    return [
      for (final i in core.amortize(_terms(loan)))
        LoanInstallment(
          number: i.number,
          date: i.date.toDb(),
          paymentCents: i.paymentCents,
          principalCents: i.principalCents,
          interestCents: i.interestCents,
          insuranceCents: i.insuranceCents,
          remainingCents: i.remainingCents,
        ),
    ];
  }

  Future<EarlyRepayment> simulate(
    Session session,
    int loanId,
    int amountCents,
  ) async {
    final loan = await _find(session, loanId);
    if (amountCents <= 0 || amountCents > core.maxLoanPrincipalCents) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    final r = core.simulateEarlyRepayment(_terms(loan), _today(), amountCents);
    return EarlyRepayment(
      amountCents: amountCents,
      interestSavedCents: r.interestSavedCents,
      installmentsLeft: r.schedule.length,
      endDate: r.schedule.isEmpty ? null : r.schedule.last.date.toDb(),
    );
  }

  Future<LoanInfo> create(Session session, int groupId, Loan loan) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final clean = await _validated(session, groupId, loan);
    final saved = await session.db.transaction((tx) async {
      final row = await Loan.db.insertRow(session, clean, transaction: tx);
      return _syncSchedule(session, row, tx);
    });
    await _afterChange(session, saved);
    await Audit.log(
      session,
      groupId: groupId,
      action: 'create',
      entity: 'loan',
      rowId: saved.id,
      after: saved,
    );
    return _info(saved, _today());
  }

  Future<LoanInfo> update(Session session, Loan loan) async {
    final current = await _find(session, loan.id ?? -1, write: true);
    final clean = await _validated(session, current.groupId, loan);
    final saved = await session.db.transaction((tx) async {
      final row = await Loan.db.updateRow(
        session,
        clean.copyWith(
          id: current.id,
          scheduledId: current.scheduledId,
          createdAt: current.createdAt,
        ),
        transaction: tx,
      );
      return _syncSchedule(session, row, tx);
    });
    await _afterChange(session, saved, previousAccountId: current.accountId);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'update',
      entity: 'loan',
      rowId: saved.id,
      before: current,
      after: saved,
    );
    return _info(saved, _today());
  }

  /// Moves the loan to the trash and stops its planned instalments.
  Future<void> delete(Session session, int loanId) async {
    final current = await _find(session, loanId, write: true);
    await session.db.transaction((tx) async {
      await _dropScheduled(session, current, tx);
      await Loan.db.updateRow(
        session,
        current.copyWith(deletedAt: DateTime.now().toUtc(), scheduledId: null),
        transaction: tx,
      );
    });
    await _afterChange(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'delete',
      entity: 'loan',
      rowId: loanId,
      before: current,
    );
  }

  // --- helpers --------------------------------------------------------------

  static core.LocalDate _today() {
    final n = DateTime.now();
    return core.LocalDate(n.year, n.month, n.day);
  }

  static core.LoanTerms _terms(Loan l) => core.LoanTerms(
    principalCents: l.principalCents,
    annualRateMilli: l.annualRateMilli,
    months: l.durationMonths,
    firstDue: l.firstDueDate.toLocalDate(),
    insuranceMonthlyCents: l.insuranceMonthlyCents,
  );

  static LoanInfo _info(Loan l, core.LocalDate today) {
    final terms = _terms(l);
    final schedule = core.amortize(terms);
    final s = core.loanStatus(terms, schedule, today);
    return LoanInfo(
      loan: l,
      paymentCents: core.loanPaymentCents(
        l.principalCents,
        l.annualRateMilli,
        l.durationMonths,
      ),
      paidCount: s.paidCount,
      totalCount: s.totalCount,
      remainingCents: s.remainingCents,
      principalPaidCents: s.principalPaidCents,
      interestPaidCents: s.interestPaidCents,
      interestRemainingCents: s.interestRemainingCents,
      insuranceRemainingCents: s.insuranceRemainingCents,
      costCents: s.costCents + l.feesCents,
      repaidPerMille: s.repaidPerMille(l.principalCents),
      nextDueDate: s.next?.date.toDb(),
      endDate: s.endDate.toDb(),
    );
  }

  /// Loans of the group whose account (if any) the user may see.
  static Future<List<Loan>> _visible(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    final visible = {
      for (final a in await Access.visibleAccounts(session, groupId)) a.id,
    };
    return [
      for (final l in await Loan.db.find(
        session,
        where: (l) => l.groupId.equals(groupId) & l.deletedAt.equals(null),
        orderBy: (l) => l.firstDueDate,
      ))
        if (l.accountId == null || visible.contains(l.accountId)) l,
    ];
  }

  static Future<Loan> _find(
    Session session,
    int id, {
    bool write = false,
  }) async {
    final l = await Loan.db.findById(session, id);
    if (l == null || l.deletedAt != null) {
      throw AccessDeniedException(code: 'loan_access_denied');
    }
    try {
      await Access.requireMember(
        session,
        l.groupId,
        min: write ? MemberRole.user : MemberRole.reader,
      );
      if (l.accountId != null) {
        await Access.requireAccount(session, l.accountId!);
      }
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'loan_access_denied');
    }
    return l;
  }

  /// Only the fields the user may set; checks the account and category
  /// belong to the group and the terms are computable.
  static Future<Loan> _validated(
    Session session,
    int groupId,
    Loan loan,
  ) async {
    final lender = loan.lender.trim();
    if (lender.isEmpty || lender.length > 80) {
      throw InvalidInputException(code: 'invalid_name', field: 'lender');
    }
    final label = loan.label?.trim();
    if (label != null && label.length > 80) {
      throw InvalidInputException(code: 'invalid_name', field: 'label');
    }
    if (loan.accountId != null) {
      final a = await Access.requireAccount(
        session,
        loan.accountId!,
        write: true,
      );
      if (a.groupId != groupId) {
        throw AccessDeniedException(code: 'account_access_denied');
      }
    }
    if (loan.categoryId != null) {
      final c = await Category.db.findById(session, loan.categoryId!);
      if (c == null || c.groupId != groupId || c.deletedAt != null) {
        throw AccessDeniedException(code: 'category_access_denied');
      }
    }
    if (loan.feesCents < 0 || loan.feesCents > core.maxLoanPrincipalCents) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    final apr = loan.aprMilli;
    if (apr != null && (apr < 0 || apr > core.maxLoanRateMilli)) {
      throw InvalidInputException(code: 'loan_terms_invalid');
    }
    final u = loan.firstDueDate.toUtc();
    final clean = Loan(
      groupId: groupId,
      accountId: loan.accountId,
      kind: loan.kind,
      lender: lender,
      label: label == null || label.isEmpty ? null : label,
      principalCents: loan.principalCents,
      annualRateMilli: loan.annualRateMilli,
      aprMilli: apr,
      durationMonths: loan.durationMonths,
      firstDueDate: core.LocalDate(u.year, u.month, u.day).toDb(),
      insuranceMonthlyCents: loan.insuranceMonthlyCents,
      feesCents: loan.feesCents,
      categoryId: loan.categoryId,
    );
    try {
      _terms(clean);
    } on ArgumentError {
      throw InvalidInputException(code: 'loan_terms_invalid');
    }
    return clean;
  }

  /// Replaces the planned operation of the instalments: one per month from
  /// the next instalment, until the last one. None without an account or
  /// once the loan is repaid.
  static Future<Loan> _syncSchedule(
    Session session,
    Loan loan,
    Transaction tx,
  ) async {
    await _dropScheduled(session, loan, tx);
    final status = core.loanStatus(
      _terms(loan),
      core.amortize(_terms(loan)),
      _today(),
    );
    final next = status.next;
    if (loan.accountId == null || next == null) {
      return Loan.db.updateRow(
        session,
        loan.copyWith(scheduledId: null),
        transaction: tx,
      );
    }
    final payment = core.loanPaymentCents(
      loan.principalCents,
      loan.annualRateMilli,
      loan.durationMonths,
    );
    final s = await ScheduledTransaction.db.insertRow(
      session,
      ScheduledTransaction(
        accountId: loan.accountId!,
        amountCents: -(payment + loan.insuranceMonthlyCents),
        label: loan.label == null
            ? loan.lender
            : '${loan.lender} · ${loan.label}',
        categoryId: loan.categoryId,
        frequency: ScheduleFrequency.monthly,
        startDate: loan.firstDueDate,
        occurrenceCount: loan.durationMonths,
        nextDue: next.date.toDb(),
        matchPattern: core.normalizeForMatch(loan.lender.toUpperCase()),
        dateToleranceDays: 5,
        // The last instalment settles the rounding.
        amountTolerancePercent: 5,
      ),
      transaction: tx,
    );
    return Loan.db.updateRow(
      session,
      loan.copyWith(scheduledId: s.id),
      transaction: tx,
    );
  }

  static Future<void> _dropScheduled(
    Session session,
    Loan loan,
    Transaction tx,
  ) async {
    final id = loan.scheduledId;
    if (id == null) return;
    final s = await ScheduledTransaction.db.findById(
      session,
      id,
      transaction: tx,
    );
    if (s == null || s.deletedAt != null) return;
    await ScheduledTransaction.db.updateRow(
      session,
      s.copyWith(deletedAt: DateTime.now().toUtc()),
      transaction: tx,
    );
  }

  /// Forecast alerts of the accounts whose planned instalments changed.
  static Future<void> _afterChange(
    Session session,
    Loan loan, {
    int? previousAccountId,
  }) async {
    for (final id in {loan.accountId, previousAccountId}.nonNulls) {
      final a = await Account.db.findById(session, id);
      if (a != null && a.deletedAt == null) {
        await AlertService.checkAfterChange(session, a);
      }
    }
  }
}
