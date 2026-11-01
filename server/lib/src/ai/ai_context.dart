import 'dart:convert';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../endpoints/analysis_endpoint.dart';
import '../endpoints/goal_endpoint.dart';
import '../endpoints/scheduled_endpoint.dart';
import '../finance/forecast_service.dart';
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
      'propose_category',
      'Propose a category for an operation. Nothing changes until the user '
          'accepts it in "Mon conseiller".',
      {
        'transaction_id': {'type': 'integer'},
        'category_id': {'type': 'integer'},
        'reason': {'type': 'string', 'description': 'Why, in one sentence.'},
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
    return {'proposed': p != null, 'note': 'The user accepts it or not.'};
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
