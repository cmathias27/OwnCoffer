import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/category_field.dart';
import '../widgets/soft.dart';
import '../help/help.dart';

/// "Mon conseiller", without AI: what the engine proposes, with its figures
/// and its calculation. Nothing changes until the user accepts; every
/// accepted change can be undone.
class AdvisorScreen extends StatefulWidget {
  final GroupMembership membership;
  const AdvisorScreen({super.key, required this.membership});

  @override
  State<AdvisorScreen> createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen> {
  List<ActionProposal>? _items;
  Map<int, Category> _categories = {};
  String? _error;
  final Set<int> _busy = {};

  int get _groupId => widget.membership.group.id!;
  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait<Object>([
        client.advisor.proposals(_groupId),
        client.category.list(_groupId),
      ]);
      if (!mounted) return;
      setState(() {
        _items = results[0] as List<ActionProposal>;
        _categories = {
          for (final c in results[1] as List<Category>) c.id!: c,
        };
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _act(
    ActionProposal p,
    Future<ActionProposal> Function(int) call,
    String done,
  ) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy.add(p.id!));
    try {
      await call(p.id!);
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    } finally {
      if (mounted) setState(() => _busy.remove(p.id));
      await _load();
    }
  }

  String _category(int id) {
    final c = _categories[id];
    return c == null ? '?' : categoryPath(context, c, _categories);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final items = _items;
    final open = [
      for (final p in items ?? const <ActionProposal>[])
        if (p.status == 'pending') p,
    ];
    final past = [
      for (final p in items ?? const <ActionProposal>[])
        if (p.status != 'pending') p,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l.advisorTitle),
        actions: const [HelpButton(HelpTopic.advisor)],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l.advisorIntro, style: theme.textTheme.bodyMedium),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(_error!, textAlign: TextAlign.center),
                      )
                    else if (items == null)
                      const Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      if (open.isEmpty)
                        SoftSection(
                          icon: Icons.thumb_up_alt_outlined,
                          title: l.advisorNothing,
                          children: [
                            Text(l.advisorNothingHelp),
                            const SizedBox(height: 8),
                          ],
                        ),
                      for (final p in open) _card(context, l, p),
                      if (past.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(l.advisorPast, style: theme.textTheme.titleSmall),
                        for (final p in past) _pastRow(context, l, p),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Object?> _data(ActionProposal p) {
    final d = jsonDecode(p.data);
    return d is Map<String, Object?> ? d : const {};
  }

  String _title(AppLocalizations l, ActionProposal p) {
    final name = _category(p.targetId);
    final to = context.money(p.proposedValue ?? 0);
    final d = _data(p);
    return switch (p.reason) {
      'ai_category' => l.advisorAiCategory(
        '${d['label'] ?? ''}',
        _category(p.proposedValue ?? 0),
      ),
      'ai_rule' => l.advisorAiRule(
        d['match_type'] == 'contains' ? l.matchContains : l.matchStartsWith,
        '${d['pattern'] ?? ''}',
        _category(p.proposedValue ?? 0),
      ),
      'ai_receipt_split' => l.advisorAiSplit('${d['label'] ?? ''}'),
      'ai_invoice_hints' => l.advisorAiInvoiceHints('${d['document'] ?? ''}'),
      'ai_loan_terms' => l.advisorAiLoanTerms('${d['lender'] ?? ''}'),
      'ai_loan' => l.advisorAiLoan(
        '${d['lender'] ?? ''}',
        context.money((d['principal_cents'] as num?)?.toInt() ?? 0),
        (d['duration_months'] as num?)?.toInt() ?? 0,
      ),
      'suggest_goal' => l.advisorSuggestGoal(name, to),
      'raise_goal' => l.advisorRaiseGoal(
        name,
        context.money(p.currentValue ?? 0),
        to,
      ),
      'lower_goal' => l.advisorLowerGoal(
        name,
        context.money(p.currentValue ?? 0),
        to,
      ),
      _ => l.advisorOther,
    };
  }

  Widget _card(BuildContext context, AppLocalizations l, ActionProposal p) {
    final theme = Theme.of(context);
    final d = _data(p);
    final months = switch (d) {
      {'months': final List<dynamic> m} => [for (final x in m) x as int],
      _ => const <int>[],
    };
    final ai = p.origin != 'engine';
    final busy = _busy.contains(p.id);
    return SoftSection(
      icon: Icons.lightbulb_outline,
      title: _title(l, p),
      children: [
        if (months.isNotEmpty)
          Text(
            l.advisorGoalWhy(
              months.map((c) => context.money(c)).join(' · '),
              context.money(p.proposedValue ?? 0),
            ),
          ),
        if (p.reason == 'ai_category')
          Text(
            l.advisorAiCategoryWhy(
              context.day(DateTime.tryParse('${d['date']}') ?? DateTime(2000)),
              context.money((d['amount_cents'] as num?)?.toInt() ?? 0),
              '${d['why'] ?? ''}',
            ),
          ),
        if (p.reason == 'ai_rule') ...[
          Text(
            l.advisorAiRuleWhy(
              (d['reclassified_count'] as num?)?.toInt() ?? 0,
              '${d['label'] ?? ''}',
              '${d['why'] ?? ''}',
            ),
          ),
          for (final e in switch (d['examples']) {
            final List<dynamic> x => x,
            _ => const [],
          })
            Text('· $e', style: theme.textTheme.bodySmall),
          Text(l.advisorAiRuleUndo, style: theme.textTheme.bodySmall),
        ],
        if (p.reason == 'ai_receipt_split') ..._splitDetails(l, p, d),
        if (p.reason == 'ai_invoice_hints')
          Text(
            [
              if (d['amount_cents'] != null)
                context.money((d['amount_cents'] as num).toInt()),
              if (d['date'] != null)
                context.day(
                  DateTime.tryParse('${d['date']}') ?? DateTime(2000),
                ),
              if (d['merchant'] != null) '${d['merchant']}',
            ].join(' · '),
          ),
        if (p.reason == 'ai_loan_terms') ..._loanTermsDetails(l, d),
        if (d['document'] != null && p.reason != 'ai_invoice_hints')
          Text(
            l.advisorReadIn('${d['document']}'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (p.reason == 'ai_loan')
          Text(
            l.advisorAiLoanWhy(
              rateTextFromMilli((d['annual_rate_milli'] as num?)?.toInt() ?? 0),
              context.money((d['payment_cents'] as num?)?.toInt() ?? 0),
              context.day(
                DateTime.tryParse('${d['first_due_date']}') ?? DateTime(2000),
              ),
            ),
          ),
        const SizedBox(height: 4),
        if (!ai)
          Text(
            switch (p.reason) {
              'raise_goal' => l.advisorRaiseWhy,
              'lower_goal' => l.advisorLowerWhy,
              _ => l.advisorSuggestWhy,
            },
            style: theme.textTheme.bodySmall,
          ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              ai ? Icons.auto_awesome_outlined : Icons.calculate_outlined,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                ai
                    ? l.advisorByAi(p.provider ?? '?', p.model ?? '?')
                    : l.advisorByEngine,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_canWrite)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: [
              TextButton(
                onPressed: busy
                    ? null
                    : () => _act(p, client.advisor.refuse, l.advisorRefused),
                child: Text(l.advisorRefuse),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.check),
                label: Text(l.advisorAccept),
                onPressed: busy
                    ? null
                    : () => _act(p, client.advisor.accept, l.advisorAccepted),
              ),
            ],
          )
        else
          Text(l.advisorReaderHelp, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
      ],
    );
  }

  /// The parts of a proposed split: category and amount, and what the
  /// lines left (computed by OwnCoffer).
  List<Widget> _splitDetails(
    AppLocalizations l,
    ActionProposal p,
    Map<String, Object?> d,
  ) {
    final f = jsonDecode(p.proposedData ?? '{}');
    final parts = f is Map && f['parts'] is List
        ? f['parts'] as List
        : const [];
    final rest = (d['rest_cents'] as num?)?.toInt() ?? 0;
    return [
      Text(
        l.advisorAiSplitWhy(
          context.money((d['amount_cents'] as num?)?.toInt() ?? 0),
          context.day(DateTime.tryParse('${d['date']}') ?? DateTime(2000)),
        ),
      ),
      for (final x in parts)
        if (x is Map)
          Text(
            '· ${x['category_id'] == null ? l.noCategory : _category((x['category_id'] as num).toInt())}'
            ' : ${context.money((x['amount_cents'] as num).toInt())}'
            '${x['note'] == null ? '' : ' (${x['note']})'}',
          ),
      if (rest > 0)
        Text(
          l.advisorAiSplitRest(context.money(rest)),
          style: Theme.of(context).textTheme.bodySmall,
        ),
    ];
  }

  /// What a loan document would change, before → after.
  List<Widget> _loanTermsDetails(AppLocalizations l, Map<String, Object?> d) {
    final changed = d['changed'] is Map ? d['changed'] as Map : const {};
    final before = d['before'] is Map ? d['before'] as Map : const {};
    String show(String k, Object? v) {
      if (v == null) return '—';
      return switch (k) {
        'annual_rate_milli' => rateTextFromMilli((v as num).toInt()),
        'duration_months' => l.loanMonths((v as num).toInt()),
        'first_due_date' => context.day(
          DateTime.tryParse('$v') ?? DateTime(2000),
        ),
        _ => context.money((v as num).toInt()),
      };
    }

    String name(String k) => switch (k) {
      'principal_cents' => l.loanPrincipal,
      'annual_rate_milli' => l.loanRate,
      'duration_months' => l.loanDuration,
      'payment_cents' => l.loanPaymentActual,
      'insurance_monthly_cents' => l.loanInsurance,
      'first_due_date' => l.loanFirstDue,
      _ => k,
    };
    return [
      for (final e in changed.entries)
        Text(
          '· ${name('${e.key}')} : ${show('${e.key}', before[e.key])} → '
          '${show('${e.key}', e.value)}',
        ),
    ];
  }

  Widget _pastRow(BuildContext context, AppLocalizations l, ActionProposal p) {
    final status = switch (p.status) {
      'executed' => l.advisorStatusExecuted,
      'refused' => l.advisorStatusRefused,
      'expired' => l.advisorStatusExpired,
      'undone' => l.advisorStatusUndone,
      _ => p.status,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(switch (p.status) {
        'executed' => Icons.check_circle_outline,
        'refused' => Icons.block,
        'expired' => Icons.history_toggle_off,
        _ => Icons.undo,
      }),
      title: Text(_title(l, p)),
      subtitle: Text(
        p.decidedAt == null ? status : '$status · ${context.day(p.decidedAt!)}',
      ),
      trailing: p.status == 'executed' && _canWrite
          ? TextButton(
              onPressed: _busy.contains(p.id)
                  ? null
                  : () => _act(p, client.advisor.undo, l.advisorUndone),
              child: Text(l.undo),
            )
          : null,
    );
  }
}

/// "3,45 %" from thousandths of a percent.
String rateTextFromMilli(int milli) {
  var s = '${milli ~/ 1000},${(milli % 1000).toString().padLeft(3, '0')}';
  while (s.endsWith('0')) {
    s = s.substring(0, s.length - 1);
  }
  if (s.endsWith(',')) s = s.substring(0, s.length - 1);
  return '$s %';
}
