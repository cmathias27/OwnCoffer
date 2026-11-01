import 'dart:convert';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../endpoints/analysis_endpoint.dart';
import '../endpoints/goal_endpoint.dart';
import '../endpoints/loan_endpoint.dart';
import '../endpoints/scheduled_endpoint.dart';
import '../finance/forecast_service.dart';
import '../finance/insights_service.dart';
import '../finance/proposal_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';

/// The functions an AI may call (décision 0008): read-only views computed by
/// the engine, limited to the accounts the user may see, and proposals that
/// only the user can accept (décision 0009). Shared by the assistant and the
/// MCP server. The AI never reads the database and never computes amounts.
class AiContext {
  final Session session;
  final int groupId;

  /// Who proposes: "ai" with its provider and model, or "mcp".
  final String origin;
  final String? provider;
  final String? model;

  /// Proposals made during the conversation.
  final List<ActionProposal> proposals = [];

  AiContext(
    this.session,
    this.groupId, {
    this.origin = 'ai',
    this.provider,
    this.model,
  });

  static const _maxTransactions = 100;

  /// Definitions in the OpenAI "tools" format (JSON Schema parameters).
  static List<Map<String, Object?>> get tools => [
    _tool(
      'get_account_overview',
      'Accounts the user can see, with their balance today (in cents).',
      {},
    ),
    _tool(
      'get_transactions',
      'Operations of the visible accounts, newest first. Amounts in cents, '
          'negative for spending.',
      {
        'from': {'type': 'string', 'description': 'First day, YYYY-MM-DD.'},
        'to': {'type': 'string', 'description': 'Last day, YYYY-MM-DD.'},
        'search': {'type': 'string', 'description': 'Text in the label.'},
        'unclassified': {
          'type': 'boolean',
          'description': 'Only the operations without a category.',
        },
        'limit': {'type': 'integer', 'description': 'At most 100.'},
      },
    ),
    _tool(
      'get_budget_status',
      'Income, spending and goals of the budget month containing a day: '
          'by category, with the previous month and the average.',
      {
        'date': {'type': 'string', 'description': 'A day, YYYY-MM-DD.'},
      },
    ),
    _tool(
      'get_upcoming_expenses',
      'Planned operations (subscriptions, loan instalments, bills) still to '
          'come in the current budget month.',
      {},
    ),
    _tool(
      'get_cashflow_forecast',
      'Forecast of each visible account over 30 days: balance today, lowest '
          'point and its date, first day below the alert threshold.',
      {},
    ),
    _tool(
      'get_financial_goals',
      'Monthly goals per category and what is spent this month.',
      {},
    ),
    _tool('get_categories', 'Categories of the group, with their id.', {}),
    _tool(
      'get_loans',
      'Loans and instalment payments of the visible accounts: lender, kind, '
          'rate, instalment, what is left to repay, interest left, next due '
          'date, end date; total monthly instalments and debt ratio.',
      {},
    ),
    _tool(
      'get_subscriptions',
      'Subscriptions (planned recurring debits marked as such): label, '
          'amount, frequency, monthly cost; monthly and yearly totals.',
      {},
    ),
    _tool(
      'get_insights',
      'Analyses computed by OwnCoffer: bank fees of the last 12 months (by '
          'month and by label), unusual debits (much more than usual, or '
          'charged twice), how reliable the forecasts were.',
      {},
    ),
    _tool(
      'get_advice',
      "OwnCoffer's own advice for the user, computed without AI: goals to "
          'set, raise or lower (with the months they come from), overdraft '
          'ahead, unusual or doubled debits, bank fees. Explain and '
          'prioritise them; the user accepts them in "Mon conseiller".',
      {},
    ),
    _tool(
      'simulate_purchase',
      'What a purchase would do to an account, computed by the forecast '
          'engine: balance on a target day, lowest point, overdraft risk, '
          'paid cash, in 3 or 4 instalments, or next month, next to not '
          'buying. Nothing is saved. Use it before advising on a purchase.',
      {
        'amount_cents': {'type': 'integer'},
        'account_id': {
          'type': 'integer',
          'description': 'Defaults to the first current account.',
        },
        'date': {'type': 'string', 'description': 'Purchase day, YYYY-MM-DD.'},
        'target': {
          'type': 'string',
          'description':
              'Day to know the balance on, YYYY-MM-DD; by '
              'default the 25th of next month.',
        },
      },
      required: ['amount_cents'],
    ),
    _tool(
      'simulate_contract_switch',
      'What replacing a contract (internet box, insurance, energy…) would '
          'save, computed by OwnCoffer: total over the years, per year, the '
          'month it pays off. Prices per month in cents; rises per year in '
          'thousandths (30 = 3 %). Nothing is saved.',
      {
        'current_monthly_cents': {'type': 'integer'},
        'new_monthly_cents': {'type': 'integer'},
        'switch_cost_cents': {'type': 'integer'},
        'years': {'type': 'integer', 'description': '1 to 10.'},
        'current_yearly_rise_per_mille': {'type': 'integer'},
        'new_yearly_rise_per_mille': {'type': 'integer'},
      },
      required: ['current_monthly_cents', 'new_monthly_cents'],
    ),
    _tool(
      'simulate_loan_change',
      'What renegotiating a loan would do, computed by the loan engine: '
          'instalment, interest left, instalments left and end date, before '
          'and after; saving with the fees; the month it pays off. Nothing '
          'is saved.',
      {
        'loan_id': {'type': 'integer'},
        'date': {'type': 'string', 'description': 'From, YYYY-MM-DD.'},
        'annual_rate_milli': {'type': 'integer'},
        'payment_cents': {'type': 'integer'},
        'remaining_months': {'type': 'integer'},
        'fees_cents': {'type': 'integer'},
      },
      required: ['loan_id'],
    ),
    _tool(
      'simulate_early_repayment',
      'What repaying part of a loan early would save, computed by the loan '
          'engine: interest saved, instalments left, new end date. Nothing '
          'is saved.',
      {
        'loan_id': {'type': 'integer'},
        'amount_cents': {'type': 'integer'},
      },
      required: ['loan_id', 'amount_cents'],
    ),
    _tool(
      'propose_category',
      'Propose a category for an operation. Nothing changes until the user '
          'accepts it in "Mon conseiller". When the same merchant will come '
          'back, also suggest a rule with rule_pattern: OwnCoffer checks it '
          'matches this operation, counts the operations it would classify, '
          'and proposes it separately.',
      {
        'transaction_id': {'type': 'integer'},
        'category_id': {'type': 'integer'},
        'reason': {'type': 'string', 'description': 'Why, in one sentence.'},
        'rule_pattern': {
          'type': 'string',
          'description':
              'Optional: the stable part of the label that names the '
              'merchant (no dates, card or reference numbers, amounts).',
        },
        'rule_match': {
          'type': 'string',
          'enum': ['startsWith', 'contains'],
          'description':
              'How the label must contain rule_pattern; '
              'startsWith by default.',
        },
      },
      required: ['transaction_id', 'category_id', 'reason'],
    ),
    _tool(
      'propose_loan',
      'Propose to create a loan read from a document (amortisation table, '
          'loan offer). Amounts in cents, rate in thousandths of a percent '
          '(3.45 % = 3450). The user checks and accepts it.',
      {
        'lender': {'type': 'string'},
        'label': {'type': 'string'},
        'kind': {
          'type': 'string',
          'enum': [for (final k in LoanKind.values) k.name],
        },
        'principal_cents': {'type': 'integer'},
        'annual_rate_milli': {'type': 'integer'},
        'duration_months': {'type': 'integer'},
        'payment_cents': {'type': 'integer'},
        'insurance_monthly_cents': {'type': 'integer'},
        'first_due_date': {'type': 'string', 'description': 'YYYY-MM-DD.'},
      },
      required: [
        'lender',
        'kind',
        'principal_cents',
        'annual_rate_milli',
        'duration_months',
        'first_due_date',
      ],
    ),
  ];

  static Map<String, Object?> _tool(
    String name,
    String description,
    Map<String, Object?> properties, {
    List<String> required = const [],
  }) => {
    'type': 'function',
    'function': {
      'name': name,
      'description': description,
      'parameters': {
        'type': 'object',
        'properties': properties,
        'required': required,
      },
    },
  };

  static final names = {
    for (final t in tools) (t['function'] as Map)['name'] as String,
  };

  /// Runs [name] with [args]; the result as JSON text for the model. Errors
  /// are returned to the model as text, never thrown at it.
  Future<String> call(String name, Map<String, Object?> args) async {
    try {
      final result = switch (name) {
        'get_account_overview' => await _overview(),
        'get_transactions' => await _transactions(args),
        'get_budget_status' => await _budget(args),
        'get_upcoming_expenses' => await _upcoming(),
        'get_cashflow_forecast' => await _forecast(),
        'get_financial_goals' => await _goals(),
        'get_categories' => await _categories(),
        'get_loans' => await _loans(),
        'get_subscriptions' => await _subscriptions(),
        'get_insights' => await _insights(),
        'get_advice' => await _advice(),
        'simulate_purchase' => await _simulatePurchase(args),
        'simulate_early_repayment' => await _simulateRepayment(args),
        'simulate_contract_switch' => _simulateSwitch(args),
        'simulate_loan_change' => await _simulateLoanChange(args),
        'propose_category' => await _proposeCategory(args),
        'propose_loan' => await _proposeLoan(args),
        _ => {'error': 'unknown function'},
      };
      return jsonEncode(result);
    } on AccessDeniedException {
      return jsonEncode({'error': 'not allowed'});
    } on InvalidInputException catch (e) {
      return jsonEncode({'error': e.code});
    } on FormatException {
      return jsonEncode({'error': 'invalid arguments'});
    }
  }

  static core.LocalDate _today() =>
      core.LocalDate.fromDateTime(DateTime.now().toUtc());

  static DateTime? _day(Object? v) {
    if (v is! String) return null;
    final d = DateTime.tryParse(v);
    return d == null ? null : DateTime.utc(d.year, d.month, d.day);
  }

  static String _iso(DateTime d) => d.toIso8601String().substring(0, 10);

  Future<List<Account>> _accounts() async {
    await Access.requireMember(session, groupId);
    return Access.visibleAccounts(session, groupId);
  }

  Future<Map<String, Object?>> _overview() async {
    final today = _today();
    return {
      'today': _iso(today.toDb()),
      'accounts': [
        for (final a in await _accounts())
          {
            'id': a.id,
            'name': a.name,
            'kind': a.kind.name,
            'currency': a.currency,
            'balance_cents': (await ForecastService.compute(
              session,
              a,
              today,
              horizonDays: 1,
            )).currentBalanceCents,
          },
      ],
    };
  }

  Future<Map<String, Object?>> _transactions(Map<String, Object?> a) async {
    final Set<int> ids = {for (final x in await _accounts()) x.id!};
    if (ids.isEmpty) return {'transactions': []};
    final from = _day(a['from']);
    final to = _day(a['to']);
    final search = (a['search'] as String?)?.trim();
    final limit = ((a['limit'] as num?)?.toInt() ?? 50).clamp(
      1,
      _maxTransactions,
    );
    final categories = {
      for (final c in await Category.db.find(
        session,
        where: (c) => c.groupId.equals(groupId),
      ))
        c.id!: c,
    };
    final rows = await BankTransaction.db.find(
      session,
      where: (t) {
        Expression e = t.accountId.inSet(ids) & t.deletedAt.equals(null);
        if (from != null) e = e & (t.date >= from);
        if (to != null) e = e & (t.date <= to);
        if (search != null && search.isNotEmpty) {
          final like = '%${search.replaceAll(RegExp(r'[%_\\]'), '')}%';
          e = e & t.cleanLabel.ilike(like);
        }
        if (a['unclassified'] == true) e = e & t.categoryId.equals(null);
        return e;
      },
      orderByList: (t) => [t.date.desc(), t.id.desc()],
      limit: limit,
    );
    return {
      'transactions': [
        for (final t in rows)
          {
            'id': t.id,
            'account_id': t.accountId,
            'date': _iso(t.date),
            'label': t.cleanLabel,
            'amount_cents': t.amountCents,
            'category': categories[t.categoryId]?.name,
            'category_id': t.categoryId,
          },
      ],
    };
  }

  Future<Map<String, Object?>> _budget(Map<String, Object?> a) async {
    await _accounts();
    final r = await AnalysisEndpoint().report(
      session,
      groupId,
      BudgetPeriod.month,
      _day(a['date']) ?? _today().toDb(),
    );
    final names = await _names();
    return {
      'first_day': _iso(r.start),
      'last_day': _iso(r.last),
      'income_cents': r.incomeCents,
      'expense_cents': r.expenseCents,
      'savings_cents': r.savingsCents,
      'unclassified_count': r.unclassifiedCount,
      'categories': [
        for (final f in r.categories)
          if (f.amountCents != 0 || f.goalCents != null)
            {
              'category': names[f.categoryId],
              'category_id': f.categoryId,
              'amount_cents': f.amountCents,
              'previous_month_cents': f.previousCents,
              'average_3_months_cents': f.averageCents,
              'goal_cents': f.goalCents,
              'projected_cents': f.projectedCents,
            },
      ],
    };
  }

  Future<Map<String, Object?>> _upcoming() async {
    await _accounts();
    final c = await ScheduledEndpoint().calendar(
      session,
      groupId,
      _today().toDb(),
    );
    return {
      'items': [
        for (final i in c.items)
          if (i.status == OccurrenceStatus.upcoming ||
              i.status == OccurrenceStatus.late)
            {
              'date': _iso(i.date),
              'label': i.label,
              'amount_cents': i.amountCents,
              'subscription': i.subscription,
              'loan': i.loanId != null,
              'late': i.status == OccurrenceStatus.late,
            },
      ],
      'upcoming_debits_cents': c.upcomingDebitsCents,
      'upcoming_credits_cents': c.upcomingCreditsCents,
    };
  }

  Future<Map<String, Object?>> _forecast() async {
    final today = _today();
    return {
      'accounts': [
        for (final a in await _accounts())
          await () async {
            final f = await ForecastService.compute(
              session,
              a,
              today,
              horizonDays: 30,
            );
            return {
              'account': a.name,
              'balance_today_cents': f.currentBalanceCents,
              'lowest_cents': f.lowestBalanceCents,
              'lowest_date': _iso(f.lowestDate),
              'alert_threshold_cents': f.alertThresholdCents,
              'first_day_below_threshold': f.firstBelowThresholdDate == null
                  ? null
                  : _iso(f.firstBelowThresholdDate!),
              'note':
                  'Planned operations only; variable spending is not '
                  'included. An estimate, not a certainty.',
            };
          }(),
      ],
    };
  }

  Future<Map<String, Object?>> _goals() async {
    final goals = await GoalEndpoint().list(session, groupId);
    final r = await AnalysisEndpoint().report(
      session,
      groupId,
      BudgetPeriod.month,
      _today().toDb(),
    );
    final spent = {for (final f in r.categories) f.categoryId: f.amountCents};
    final names = await _names();
    return {
      'goals': [
        for (final g in goals)
          {
            'category': names[g.categoryId],
            'category_id': g.categoryId,
            'goal_cents': g.amountCents,
            'spent_this_month_cents': spent[g.categoryId] ?? 0,
          },
      ],
    };
  }

  Future<Map<int, String>> _names() async => {
    for (final c in await Category.db.find(
      session,
      where: (c) => c.groupId.equals(groupId) & c.deletedAt.equals(null),
    ))
      c.id!: c.name ?? c.standardCode ?? '',
  };

  Future<Map<String, Object?>> _categories() async {
    await Access.requireMember(session, groupId);
    return {
      'categories': [
        for (final c in await Category.db.find(
          session,
          where: (c) => c.groupId.equals(groupId) & c.deletedAt.equals(null),
          orderBy: (c) => c.id,
        ))
          {
            'id': c.id,
            'name': c.name,
            'kind': c.kind.name,
            'parent_id': c.parentId,
          },
      ],
    };
  }

  Future<Map<String, Object?>> _loans() async {
    final o = await LoanEndpoint().overview(session, groupId);
    return {
      'loans': [
        for (final i in o.loans)
          {
            'id': i.loan.id,
            'lender': i.loan.lender,
            'label': i.loan.label,
            'kind': i.loan.kind.name,
            'annual_rate_milli': i.loan.annualRateMilli,
            'instalment_cents': i.paymentCents,
            'insurance_monthly_cents': i.loan.insuranceMonthlyCents,
            'instalment_is_the_debited_one': i.paymentIsActual,
            'principal_cents': i.loan.principalCents,
            'remaining_cents': i.remainingCents,
            'interest_left_cents': i.interestRemainingCents,
            'paid_count': i.paidCount,
            'total_count': i.totalCount,
            'next_due_date': i.nextDueDate == null
                ? null
                : _iso(i.nextDueDate!),
            'end_date': _iso(i.endDate),
            'credit_limit_cents': i.loan.creditLimitCents,
            'changes': i.loan.events?.length ?? 0,
          },
      ],
      'total_remaining_cents': o.totalRemainingCents,
      'total_monthly_cents': o.totalMonthlyCents,
      'average_monthly_income_cents': o.monthlyIncomeCents,
      'debt_ratio_per_mille': o.debtRatioPerMille,
      'note': 'Estimates from the loan engine; the bank table prevails.',
    };
  }

  Future<Map<String, Object?>> _subscriptions() async {
    await _accounts();
    final o = await ScheduledEndpoint().subscriptions(session, groupId);
    return {
      'subscriptions': [
        for (final (k, x) in o.items.indexed)
          {
            'label': x.label,
            'amount_cents': x.amountCents,
            'frequency': x.frequency.name,
            'monthly_cents': o.monthlyCents[k],
            'next_due': x.nextDue == null ? null : _iso(x.nextDue!),
          },
      ],
      'monthly_total_cents': o.monthlyTotalCents,
      'yearly_total_cents': o.yearlyTotalCents,
    };
  }

  Future<Map<String, Object?>> _insights() async {
    await _accounts();
    final i = await InsightsService.compute(session, groupId, _today());
    return {
      'bank_fees_12_months_cents': i.feeTotalCents,
      'bank_fees_by_month': [
        for (final (k, m) in i.feeMonths.indexed)
          {'month': _iso(m).substring(0, 7), 'cents': i.feePerMonthCents[k]},
      ],
      'bank_fees_by_label': [
        for (final f in i.feeLines)
          {'label': f.label, 'cents': f.cents, 'count': f.count},
      ],
      'unusual_debits': [
        for (final u in i.unusual)
          {
            'kind': u.kind,
            'label': u.transaction.cleanLabel,
            'amount_cents': u.transaction.amountCents,
            'date': _iso(u.transaction.date),
            'usual_cents': u.usualCents,
          },
      ],
      'planned_due_3_months': i.plannedDue,
      'planned_came_3_months': i.plannedPaid,
      'variable_estimate_last_month_cents': i.variableEstimateCents,
      'variable_actual_last_month_cents': i.variableActualCents,
    };
  }

  Future<Map<String, Object?>> _advice() async {
    await _accounts();
    await ProposalService.refreshAdvice(session, groupId);
    final open = await ActionProposal.db.find(
      session,
      where: (p) =>
          p.authUserId.equals(Access.userId(session)) &
          p.groupId.equals(groupId) &
          p.status.equals('pending'),
      orderByList: (p) => [p.createdAt.desc()],
      limit: 30,
    );
    final names = await _names();
    return {
      'advice': [
        for (final p in open)
          {
            'kind': p.kind,
            'reason': p.reason,
            if (p.kind == 'set_goal') 'category': names[p.targetId],
            'current_cents': p.currentValue,
            'proposed_cents': p.proposedValue,
            'figures': jsonDecode(p.data),
            'from': p.origin,
          },
      ],
    };
  }

  Future<Map<String, Object?>> _simulatePurchase(Map<String, Object?> a) async {
    final amount = (a['amount_cents'] as num?)?.toInt();
    if (amount == null || amount <= 0) throw const FormatException();
    final accounts = await _accounts();
    final id = (a['account_id'] as num?)?.toInt();
    final account = id == null
        ? (accounts.where((x) => x.kind == AccountKind.checking).firstOrNull ??
              accounts.firstOrNull)
        : accounts.where((x) => x.id == id).firstOrNull;
    if (account == null) {
      throw AccessDeniedException(code: 'account_access_denied');
    }
    final today = _today().toDb();
    final date = _day(a['date']) ?? today;
    final next = DateTime.utc(today.year, today.month + 1, 25);
    final r = await ScheduledEndpoint().simulatePurchase(
      session,
      account.id!,
      today,
      amount,
      date,
      _day(a['target']) ?? next,
    );
    return {
      'account': account.name,
      'alert_threshold_cents': r.alertThresholdCents,
      'variable_spending_included': r.variableIncluded,
      'target_day': _iso(r.target),
      'scenarios': [
        for (final x in r.scenarios)
          {
            'option': x.option.name,
            'payments': [
              for (final p in x.payments)
                {'date': _iso(p.date), 'amount_cents': p.amountCents},
            ],
            'balance_on_target_cents': x.balanceOnTargetCents,
            'lowest_cents': x.lowestBalanceCents,
            'lowest_date': _iso(x.lowestDate),
            'first_day_below_threshold': x.firstBelowThresholdDate == null
                ? null
                : _iso(x.firstBelowThresholdDate!),
          },
      ],
      'note': 'Computed by the forecast engine; an estimate.',
    };
  }

  Map<String, Object?> _simulateSwitch(Map<String, Object?> a) {
    int n(String k) => (a[k] as num?)?.toInt() ?? 0;
    final years = n('years') == 0 ? 5 : n('years').clamp(1, 10);
    try {
      final r = core.simulateContractSwitch(
        currentMonthlyCents: n('current_monthly_cents'),
        newMonthlyCents: n('new_monthly_cents'),
        months: years * 12,
        switchCostCents: n('switch_cost_cents'),
        currentYearlyIncreasePerMille: n('current_yearly_rise_per_mille'),
        newYearlyIncreasePerMille: n('new_yearly_rise_per_mille'),
      );
      return {
        'years': years,
        'total_saving_cents': r.totalSavingCents,
        'yearly_saving_cents': r.yearlySavingCents,
        'break_even_month': r.breakEvenMonth,
        'kept_total_cents': r.keepCents.last,
        'switched_total_cents': r.switchCents.last,
      };
    } on ArgumentError {
      throw const FormatException();
    }
  }

  Future<Map<String, Object?>> _simulateLoanChange(
    Map<String, Object?> a,
  ) async {
    final id = (a['loan_id'] as num?)?.toInt();
    if (id == null) throw const FormatException();
    await _accounts();
    final n = DateTime.now().toUtc();
    final r = await LoanEndpoint().simulateChange(
      session,
      id,
      LoanEvent(
        date: _day(a['date']) ?? DateTime.utc(n.year, n.month + 1, 1),
        annualRateMilli: (a['annual_rate_milli'] as num?)?.toInt(),
        paymentCents: (a['payment_cents'] as num?)?.toInt(),
        remainingMonths: (a['remaining_months'] as num?)?.toInt(),
      ),
      feesCents: (a['fees_cents'] as num?)?.toInt(),
    );
    return {
      'instalment_before_cents': r.paymentBeforeCents,
      'instalment_after_cents': r.paymentAfterCents,
      'interest_left_before_cents': r.interestBeforeCents,
      'interest_left_after_cents': r.interestAfterCents,
      'instalments_left_before': r.instalmentsBefore,
      'instalments_left_after': r.instalmentsAfter,
      'end_before': _iso(r.endBefore),
      'end_after': _iso(r.endAfter),
      'fees_cents': r.feesCents,
      'saving_cents': r.savingCents,
      'break_even_month': r.breakEvenMonth,
      'note': 'Computed by the loan engine; the bank offer prevails.',
    };
  }

  Future<Map<String, Object?>> _simulateRepayment(
    Map<String, Object?> a,
  ) async {
    final id = (a['loan_id'] as num?)?.toInt();
    final amount = (a['amount_cents'] as num?)?.toInt();
    if (id == null || amount == null) throw const FormatException();
    await _accounts();
    final r = await LoanEndpoint().simulate(session, id, amount);
    return {
      'amount_cents': r.amountCents,
      'interest_saved_cents': r.interestSavedCents,
      'instalments_left': r.installmentsLeft,
      'new_end_date': r.endDate == null ? null : _iso(r.endDate!),
      'note': 'Computed by the loan engine, keeping the instalment.',
    };
  }

  Future<Map<String, Object?>> _proposeCategory(Map<String, Object?> a) async {
    final txId = (a['transaction_id'] as num?)?.toInt();
    final catId = (a['category_id'] as num?)?.toInt();
    if (txId == null || catId == null) throw const FormatException();
    final Set<int> ids = {for (final x in await _accounts()) x.id!};
    final t = await BankTransaction.db.findById(session, txId);
    if (t == null || t.deletedAt != null || !ids.contains(t.accountId)) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    final c = await Category.db.findById(session, catId);
    if (c == null || c.groupId != groupId || c.deletedAt != null) {
      throw AccessDeniedException(code: 'category_access_denied');
    }
    final p = await ProposalService.propose(
      session,
      groupId: groupId,
      kind: 'set_category',
      targetId: txId,
      currentValue: t.categoryId,
      proposedValue: catId,
      reason: 'ai_category',
      data: {
        'label': t.cleanLabel,
        'amount_cents': t.amountCents,
        'date': _iso(t.date),
        'why': _short(a['reason']),
      },
      origin: origin,
      provider: provider,
      model: model,
    );
    if (p != null) proposals.add(p);
    final rule = a['rule_pattern'] is String
        ? await _proposeRule(t, c, a)
        : null;
    return {
      'proposed': p != null,
      'rule': ?rule,
      'note': 'The user accepts it or not.',
    };
  }

  static const _minPattern = 3;

  /// The rule suggested with a category: checked and counted by the engine
  /// on the visible accounts, proposed apart (the user may want one and not
  /// the other). Returns what the model is told.
  Future<Map<String, Object?>> _proposeRule(
    BankTransaction t,
    Category c,
    Map<String, Object?> a,
  ) async {
    final pattern = core.normalizeForMatch(_short(a['rule_pattern']));
    if (pattern.length < _minPattern || pattern.length > 100) {
      return {'proposed': false, 'error': 'pattern too short or too long'};
    }
    final match = a['rule_match'] == 'contains'
        ? RuleMatchType.contains
        : RuleMatchType.startsWith;
    final direction = t.amountCents < 0
        ? RuleDirection.debit
        : RuleDirection.credit;
    final matcher = core.GroupRule<int>(
      id: 0,
      categoryId: c.id!,
      pattern: pattern,
      matchType: core.MatchType.values.byName(match.name),
      direction: core.Direction.values.byName(direction.name),
    );
    core.CleanedLabel label(BankTransaction x) => core.CleanedLabel(
      x.cleanLabel,
      core.normalizeForMatch('${x.rawLabel} ${x.memo ?? ''}'),
      core.OperationKind.other,
    );
    if (!matcher.matches(label(t), t.amountCents)) {
      return {'proposed': false, 'error': 'pattern does not match the label'};
    }
    final exists = await Rule.db.count(
      session,
      where: (r) =>
          r.groupId.equals(groupId) &
          r.pattern.equals(pattern) &
          r.matchType.equals(match) &
          r.direction.equals(direction),
    );
    if (exists > 0) return {'proposed': false, 'error': 'rule exists'};
    // What accepting would change, on the accounts this user may see (the
    // same set the rule is applied to): manual choices are never changed.
    final Set<int> ids = {for (final x in await _accounts()) x.id!};
    final reached = [
      for (final x in await BankTransaction.db.find(
        session,
        where: (x) =>
            x.accountId.inSet(ids) &
            x.deletedAt.equals(null) &
            x.categorySource.notEquals(CategorySource.manual),
        orderByList: (x) => [x.date.desc(), x.id.desc()],
      ))
        if (x.categoryId != c.id && matcher.matches(label(x), x.amountCents)) x,
    ];
    final fields = {
      'pattern': pattern,
      'match_type': match.name,
      'direction': direction.name,
    };
    final p = await ProposalService.propose(
      session,
      groupId: groupId,
      kind: 'create_rule',
      targetId: t.id!,
      currentValue: null,
      proposedValue: c.id,
      proposedData: jsonEncode(fields),
      reason: 'ai_rule',
      data: {
        ...fields,
        'label': t.cleanLabel,
        'reclassified_count': reached.length,
        'examples': [
          for (final x in reached.take(3)) '${_iso(x.date)} ${x.cleanLabel}',
        ],
        'why': _short(a['reason']),
      },
      origin: origin,
      provider: provider,
      model: model,
    );
    if (p != null) proposals.add(p);
    return {
      'proposed': p != null,
      'operations_it_would_classify': reached.length,
    };
  }

  Future<Map<String, Object?>> _proposeLoan(Map<String, Object?> a) async {
    await Access.requireMember(session, groupId);
    final kind = LoanKind.values.where((k) => k.name == a['kind']).firstOrNull;
    final first = _day(a['first_due_date']);
    int? cents(String k) => (a[k] as num?)?.toInt();
    final lender = _short(a['lender']);
    if (kind == null || first == null || lender.isEmpty) {
      throw const FormatException();
    }
    final fields = {
      'lender': lender,
      'label': _short(a['label']),
      'kind': kind.name,
      'principal_cents': cents('principal_cents'),
      'annual_rate_milli': cents('annual_rate_milli'),
      'duration_months': cents('duration_months'),
      'payment_cents': cents('payment_cents'),
      'insurance_monthly_cents': cents('insurance_monthly_cents') ?? 0,
      'first_due_date': _iso(first),
    };
    final p = await ProposalService.propose(
      session,
      groupId: groupId,
      kind: 'create_loan',
      targetId: groupId,
      currentValue: null,
      proposedValue: null,
      proposedData: jsonEncode(fields),
      reason: 'ai_loan',
      data: fields,
      origin: origin,
      provider: provider,
      model: model,
    );
    if (p != null) proposals.add(p);
    return {'proposed': p != null, 'note': 'The user checks and accepts it.'};
  }

  static String _short(Object? v) {
    final s = (v is String ? v : '').trim();
    return s.length > 200 ? s.substring(0, 200) : s;
  }
}
