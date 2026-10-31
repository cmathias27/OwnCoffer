import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/alert_service.dart';
import '../finance/classification_service.dart';
import '../finance/forecast_service.dart';
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
          matchPattern: current.matchPattern,
          ruleId: current.ruleId,
          createdAt: current.createdAt,
        ),
        transaction: tx,
      );
      await _followCategory(session, row, tx);
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

  /// "This is a loan instalment": declares a loan from one of its debits.
  /// The loan is debited from the operation's account; its instalments are
  /// recognised by the operation's label (planned operation and a group
  /// rule classifying them in the loan's category, by default the standard
  /// category of its kind). Past debits that match an instalment are linked
  /// to it; the operation itself is classified as chosen by the user.
  Future<LoanFromOperation> createFromTransaction(
    Session session,
    int transactionId,
    Loan loan,
  ) async {
    final (t, account) = await _debit(session, transactionId);
    final groupId = account.groupId;
    var clean = await _validated(
      session,
      groupId,
      loan.copyWith(accountId: account.id),
    );
    clean = clean.copyWith(
      categoryId:
          clean.categoryId ??
          await _standardCategory(session, groupId, clean.kind) ??
          t.categoryId,
      matchPattern: _pattern(t),
    );
    final visible = await _visibleIds(session, groupId);
    final r = await session.db.transaction((tx) async {
      final row = await Loan.db.insertRow(session, clean, transaction: tx);
      return _attach(session, row, t, visible, tx);
    });
    await _afterChange(session, r.loan);
    await Audit.log(
      session,
      groupId: groupId,
      action: 'create_from_transaction',
      entity: 'loan',
      rowId: r.loan.id,
      after: r.loan,
    );
    return LoanFromOperation(
      info: _info(r.loan, _today()),
      reclassifiedCount: r.reclassified,
      linkedCount: r.linked,
      ruleId: r.ruleId,
    );
  }

  /// "This is an instalment of that loan": attaches a past debit to a loan
  /// already entered. The debit is linked to the nearest instalment and
  /// classified in the loan's category; a loan without an account takes the
  /// debit's, one without a recognised label takes the debit's (and a rule
  /// classifying the next ones). Other past instalments found are linked too.
  Future<LoanFromOperation> attachTransaction(
    Session session,
    int loanId,
    int transactionId,
  ) async {
    final loan = await _find(session, loanId, write: true);
    final (t, account) = await _debit(session, transactionId);
    if (account.groupId != loan.groupId) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    if (loan.accountId != null && loan.accountId != account.id) {
      throw InvalidInputException(code: 'loan_other_account');
    }
    final updated = loan.copyWith(
      accountId: account.id,
      matchPattern: loan.matchPattern ?? _pattern(t),
      categoryId:
          loan.categoryId ??
          await _standardCategory(session, loan.groupId, loan.kind) ??
          t.categoryId,
    );
    final visible = await _visibleIds(session, loan.groupId);
    final r = await session.db.transaction((tx) async {
      final row = await Loan.db.updateRow(session, updated, transaction: tx);
      return _attach(
        session,
        row,
        t,
        visible,
        tx,
        replaced: {?loan.scheduledId},
        nearest: true,
      );
    });
    await _afterChange(session, r.loan, previousAccountId: loan.accountId);
    await Audit.log(
      session,
      groupId: loan.groupId,
      action: 'attach_transaction',
      entity: 'loan',
      rowId: loan.id,
      before: loan,
      after: r.loan,
    );
    return LoanFromOperation(
      info: _info(r.loan, _today()),
      reclassifiedCount: r.reclassified,
      linkedCount: r.linked,
      ruleId: r.ruleId,
    );
  }

  /// Undo of [attachTransaction]: unlinks the debit from the loan and, when
  /// the attachment created the loan's rule ([ruleId]), removes it and
  /// classifies again what it had classified (the app restores the debit's
  /// own classification).
  Future<int> undoAttach(
    Session session,
    int loanId,
    int transactionId, {
    int? ruleId,
  }) async {
    final loan = await _find(session, loanId, write: true);
    final (t, account) = await _debit(session, transactionId);
    if (account.groupId != loan.groupId) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    final n = await session.db.transaction((tx) async {
      if (t.scheduledId != null && t.scheduledId == loan.scheduledId) {
        await BankTransaction.db.updateRow(
          session,
          t.copyWith(scheduledId: null, scheduledDueDate: null),
          transaction: tx,
        );
      }
      if (ruleId == null || loan.ruleId != ruleId) return 0;
      await Loan.db.updateRow(
        session,
        loan.copyWith(ruleId: null),
        transaction: tx,
      );
      return ClassificationService.revertRule(
        session,
        loan.groupId,
        ruleId,
        transaction: tx,
      );
    });
    await Audit.log(
      session,
      groupId: loan.groupId,
      action: 'undo_attach',
      entity: 'loan',
      rowId: loanId,
      before: loan,
    );
    return n;
  }

  /// A debit of an account the user may change.
  static Future<(BankTransaction, Account)> _debit(
    Session session,
    int transactionId,
  ) async {
    final t = await BankTransaction.db.findById(session, transactionId);
    if (t == null || t.deletedAt != null) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    final Account account;
    try {
      account = await Access.requireAccount(session, t.accountId, write: true);
      await Access.requireMember(
        session,
        account.groupId,
        min: MemberRole.user,
      );
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    if (t.amountCents >= 0) {
      throw InvalidInputException(code: 'loan_needs_debit');
    }
    if (_pattern(t).isEmpty) {
      throw InvalidInputException(code: 'invalid_pattern', field: 'pattern');
    }
    return (t, account);
  }

  static String _pattern(BankTransaction t) =>
      core.normalizeForMatch(t.cleanLabel.toUpperCase());

  static Future<Set<int>> _visibleIds(Session session, int groupId) async => {
    for (final a in await Access.visibleAccounts(session, groupId)) a.id!,
  };

  /// Common to declaring and attaching: the rule (when the loan has none),
  /// the debit classified by hand, a planned operation made for these debits
  /// replaced, the planned instalments rebuilt and the past ones linked.
  /// With [nearest], the debit is linked to its nearest instalment even
  /// beyond the date tolerance (the user said it is one).
  static Future<({Loan loan, int reclassified, int linked, int? ruleId})>
  _attach(
    Session session,
    Loan loan,
    BankTransaction t,
    Set<int> visibleIds,
    Transaction tx, {
    Set<int> replaced = const {},
    bool nearest = false,
  }) async {
    var row = loan;
    var reclassified = 0;
    int? ruleId;
    final categoryId = row.categoryId;
    if (categoryId != null && row.ruleId == null) {
      final debit = -t.amountCents;
      final rule = await Rule.db.insertRow(
        session,
        Rule(
          groupId: row.groupId,
          categoryId: categoryId,
          matchType: RuleMatchType.startsWith,
          pattern: row.matchPattern ?? _pattern(t),
          direction: RuleDirection.debit,
          // Room for insurance changes and the last instalment, while
          // leaving apart other debits of the same lender.
          minAbsCents: debit * 8 ~/ 10,
          maxAbsCents: debit * 12 ~/ 10,
          createdBy: Access.userId(session),
        ),
        transaction: tx,
      );
      ruleId = rule.id;
      row = await Loan.db.updateRow(
        session,
        row.copyWith(ruleId: rule.id),
        transaction: tx,
      );
      final changed = await ClassificationService.applyRule(
        session,
        rule,
        visibleIds,
        transaction: tx,
      );
      reclassified = changed.where((x) => x.id != t.id).length;
    }
    if (categoryId != null) {
      await BankTransaction.db.updateRow(
        session,
        t.copyWith(
          categoryId: categoryId,
          categorySource: CategorySource.manual,
          categoryRuleRef: null,
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
    }
    // A planned operation the user had made for these debits is replaced
    // by the loan's own.
    final previous = t.scheduledId;
    if (previous != null && !replaced.contains(previous)) {
      final s = await ScheduledTransaction.db.findById(
        session,
        previous,
        transaction: tx,
      );
      if (s != null && s.deletedAt == null && s.accountId == t.accountId) {
        await ScheduledTransaction.db.updateRow(
          session,
          s.copyWith(deletedAt: DateTime.now().toUtc()),
          transaction: tx,
        );
      }
    }
    row = await _syncSchedule(session, row, tx, includePast: true);
    final linked = await _linkPast(
      session,
      row,
      {...replaced, ?previous},
      tx,
      force: nearest ? t.id : null,
    );
    return (
      loan: row,
      reclassified: reclassified,
      linked: linked,
      ruleId: ruleId,
    );
  }

  /// Undo of "this is a loan instalment": removes the loan, its planned
  /// instalments and its rule, unlinks its instalments and classifies again
  /// the operations the rule had classified (the app restores the declared
  /// operation itself). Returns how many were classified again.
  Future<int> undoCreate(Session session, int loanId) async {
    final current = await _find(session, loanId, write: true);
    final n = await session.db.transaction((tx) async {
      await Loan.db.updateRow(
        session,
        current.copyWith(
          deletedAt: DateTime.now().toUtc(),
          scheduledId: null,
          ruleId: null,
        ),
        transaction: tx,
      );
      final sid = current.scheduledId;
      if (sid != null) {
        final linked = await BankTransaction.db.find(
          session,
          where: (t) => t.scheduledId.equals(sid),
          transaction: tx,
        );
        if (linked.isNotEmpty) {
          await BankTransaction.db.update(session, [
            for (final t in linked)
              t.copyWith(scheduledId: null, scheduledDueDate: null),
          ], transaction: tx);
        }
      }
      await _dropScheduled(session, current, tx);
      final rid = current.ruleId;
      if (rid == null) return 0;
      return ClassificationService.revertRule(
        session,
        current.groupId,
        rid,
        transaction: tx,
      );
    });
    await _afterChange(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'undo_create',
      entity: 'loan',
      rowId: loanId,
      before: current,
    );
    return n;
  }

  /// Moves the loan to the trash and stops its planned instalments.
  Future<void> delete(Session session, int loanId) async {
    final current = await _find(session, loanId, write: true);
    await session.db.transaction((tx) async {
      await _dropScheduled(session, current, tx);
      await Loan.db.updateRow(
        session,
        current.copyWith(
          deletedAt: DateTime.now().toUtc(),
          scheduledId: null,
          ruleId: null,
        ),
        transaction: tx,
      );
      // Operations already classified keep their category.
      if (current.ruleId != null) {
        await Rule.db.deleteWhere(
          session,
          where: (r) => r.id.equals(current.ruleId),
          transaction: tx,
        );
      }
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
    Transaction tx, {
    bool includePast = false,
  }) async {
    await _dropScheduled(session, loan, tx);
    final status = core.loanStatus(
      _terms(loan),
      core.amortize(_terms(loan)),
      _today(),
    );
    final next = status.next;
    if (loan.accountId == null || (next == null && !includePast)) {
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
        nextDue: (next?.date ?? _today().addDays(1)).toDb(),
        matchPattern:
            loan.matchPattern ??
            core.normalizeForMatch(loan.lender.toUpperCase()),
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

  /// Standard category of a loan kind, when the group has it.
  static Future<int?> _standardCategory(
    Session session,
    int groupId,
    LoanKind kind,
  ) async {
    final code = switch (kind) {
      LoanKind.mortgage => 'housing.mortgage',
      LoanKind.car => 'transport.vehicle_loan',
      LoanKind.installments => 'banking.installments',
      _ => 'banking.consumer_loan',
    };
    final c = await Category.db.findFirstRow(
      session,
      where: (c) =>
          c.groupId.equals(groupId) &
          c.standardCode.equals(code) &
          c.deletedAt.equals(null),
      orderBy: (c) => c.id,
    );
    return c?.id;
  }

  /// The loan's rule follows a change of its category.
  static Future<void> _followCategory(
    Session session,
    Loan loan,
    Transaction tx,
  ) async {
    final id = loan.ruleId;
    final categoryId = loan.categoryId;
    if (id == null || categoryId == null) return;
    final rule = await Rule.db.findById(session, id, transaction: tx);
    if (rule == null || rule.categoryId == categoryId) return;
    await Rule.db.updateRow(
      session,
      rule.copyWith(categoryId: categoryId),
      transaction: tx,
    );
  }

  /// Links the past debits of the loan's account that match an instalment
  /// (label, date and amount within the planned operation's tolerances) and
  /// are not linked to another planned operation. Returns how many.
  static Future<int> _linkPast(
    Session session,
    Loan loan,
    Set<int> replacedScheduledIds,
    Transaction tx, {
    int? force,
  }) async {
    final id = loan.scheduledId;
    if (id == null) return 0;
    var scheduled = (await ScheduledTransaction.db.findById(
      session,
      id,
      transaction: tx,
    ))!;
    final schedule = core.amortize(_terms(loan));
    final today = _today();
    final ops = await BankTransaction.db.find(
      session,
      where: (x) =>
          x.accountId.equals(loan.accountId!) &
          x.deletedAt.equals(null) &
          (x.amountCents < 0),
      orderBy: (x) => x.date,
      transaction: tx,
    );
    final used = <int>{};
    var count = 0;
    // The debit the user pointed at first, so it gets its own instalment.
    final ordered = [
      ...ops.where((x) => x.id == force),
      ...ops.where((x) => x.id != force),
    ];
    for (final x in ordered) {
      final forced = x.id == force;
      if (!forced &&
          x.scheduledId != null &&
          !replacedScheduledIds.contains(x.scheduledId)) {
        continue;
      }
      final day = x.date.toLocalDate();
      if (day > today && !forced) continue;
      final int i;
      if (forced) {
        // Nearest free instalment, within a month and a half.
        var best = -1;
        for (final (k, s) in schedule.indexed) {
          if (used.contains(s.number)) continue;
          final gap = s.date.daysUntil(day).abs();
          if (gap > 45) continue;
          if (best < 0 || gap < schedule[best].date.daysUntil(day).abs()) {
            best = k;
          }
        }
        i = best;
      } else {
        final label = ForecastService.realOf(x).label;
        if (!core.containsWords(label.full, scheduled.matchPattern)) continue;
        i = schedule.indexWhere(
          (s) =>
              !used.contains(s.number) &&
              (s.date.daysUntil(day)).abs() <= scheduled.dateToleranceDays &&
              (x.amountCents.abs() - s.totalCents).abs() * 100 <=
                  s.totalCents * scheduled.amountTolerancePercent,
        );
      }
      if (i < 0) continue;
      used.add(schedule[i].number);
      await ForecastService.link(
        session,
        scheduled,
        schedule[i].date,
        x,
        tx: tx,
      );
      scheduled = (await ScheduledTransaction.db.findById(
        session,
        id,
        transaction: tx,
      ))!;
      count++;
    }
    return count;
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
