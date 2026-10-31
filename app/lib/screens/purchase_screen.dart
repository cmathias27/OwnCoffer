import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/category_field.dart';

/// Purchase simulator: "if I buy this for 600 € now, what will my balance
/// be on the 25th of next month?". Cash, 3 or 4 instalments and a month
/// later side by side, next to not buying; the chosen one is saved as a
/// planned operation (or a payment in several instalments) in one click.
/// Every figure comes from the server's forecast engine.
class PurchaseScreen extends StatefulWidget {
  final GroupMembership membership;
  final Account account;
  final Map<int, Category> categories;

  const PurchaseScreen({
    super.key,
    required this.membership,
    required this.account,
    required this.categories,
  });

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _label = TextEditingController();
  late DateTime _date = todayUtcMidnight();

  /// The 25th of next month, as in the cahier des charges' example.
  late DateTime _target = DateTime.utc(_date.year, _date.month + 1, 25);
  int? _categoryId;
  var _variable = true;
  var _busy = false;
  String? _error;
  PurchaseSimulation? _result;

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void dispose() {
    _amount.dispose();
    _label.dispose();
    super.dispose();
  }

  Future<DateTime?> _pick(DateTime initial) async {
    final today = todayUtcMidnight();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year, today.month, today.day + 366),
    );
    return picked == null
        ? null
        : DateTime.utc(picked.year, picked.month, picked.day);
  }

  Future<void> _simulate() async {
    if (!_form.currentState!.validate()) return;
    final l = AppLocalizations.of(context);
    setState(() => (_busy = true, _error = null));
    try {
      final r = await client.scheduled.simulatePurchase(
        widget.account.id!,
        todayUtcMidnight(),
        parseUserAmount(_amount.text)!,
        _date,
        _target,
        categoryId: _categoryId,
        includeVariable: _variable,
      );
      if (mounted) setState(() => _result = r);
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _label0(AppLocalizations l) =>
      _label.text.trim().isEmpty ? l.purchaseDefaultLabel : _label.text.trim();

  Future<void> _save(PurchaseScenarioInfo s) async {
    final l = AppLocalizations.of(context);
    final r = _result!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => (_busy = true, _error = null));
    try {
      final label = _label0(l);
      switch (s.option) {
        case PurchaseOption.threeTimes || PurchaseOption.fourTimes:
          await client.loan.create(
            widget.membership.group.id!,
            Loan(
              groupId: widget.membership.group.id!,
              accountId: widget.account.id,
              kind: LoanKind.installments,
              lender: label,
              principalCents: r.amountCents,
              annualRateMilli: 0,
              durationMonths: s.payments.length,
              firstDueDate: s.payments.first.date,
              categoryId: _categoryId,
            ),
          );
        default:
          await client.scheduled.create(
            widget.account.id!,
            -r.amountCents,
            label,
            ScheduleFrequency.once,
            s.payments.first.date,
            categoryId: _categoryId,
          );
      }
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l.purchaseSaved)));
      Navigator.of(context).pop(true);
    } on Object catch (e) {
      if (mounted) setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = _result;
    return Scaffold(
      appBar: AppBar(title: Text(l.purchaseTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l.purchaseHelp(widget.account.name),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Form(
            key: _form,
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 160,
                  child: TextFormField(
                    controller: _amount,
                    decoration: InputDecoration(
                      labelText: l.purchaseAmount,
                      suffixText: widget.account.currency == 'EUR'
                          ? '€'
                          : widget.account.currency,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      final c = parseUserAmount(v ?? '');
                      return c == null || c <= 0
                          ? l.purchaseAmountInvalid
                          : null;
                    },
                    onFieldSubmitted: (_) => _simulate(),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextFormField(
                    controller: _label,
                    decoration: InputDecoration(
                      labelText: l.purchaseLabel,
                      hintText: l.purchaseDefaultLabel,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(l.purchaseDate(context.day(_date))),
                  onPressed: () async {
                    final d = await _pick(_date);
                    if (d != null) setState(() => _date = d);
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.event),
                  label: Text(l.purchaseTarget(context.day(_target))),
                  onPressed: () async {
                    final d = await _pick(_target);
                    if (d != null) setState(() => _target = d);
                  },
                ),
                SizedBox(
                  width: 260,
                  child: CategoryFormField(
                    categories: widget.categories.values
                        .where((c) => c.kind == CategoryKind.expense)
                        .toList(),
                    initialValue: _categoryId,
                    label: l.categoryLabel,
                    noneLabel: l.noCategory,
                    helperText: l.purchaseCategoryHelp,
                    onChanged: (v) => setState(() => _categoryId = v),
                  ),
                ),
                FilterChip(
                  label: Text(l.variableToggle),
                  tooltip: l.variableToggleHelp,
                  selected: _variable,
                  onSelected: (v) => setState(() => _variable = v),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.calculate_outlined),
                  label: Text(l.purchaseSimulate),
                  onPressed: _busy ? null : _simulate,
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          if (r != null) ...[
            const SizedBox(height: 16),
            if (r.goalCents != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l.purchaseGoal(
                    context.money(r.goalSpentCents ?? 0),
                    context.money(r.goalCents!),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final s in r.scenarios)
                  PurchaseScenarioCard(
                    scenario: s,
                    simulation: r,
                    currency: widget.account.currency,
                    onSave:
                        _canWrite && !_busy && s.option != PurchaseOption.none
                        ? () => _save(s)
                        : null,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              r.variableIncluded ? l.purchaseHowVariable : l.purchaseHowPlanned,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

/// One option: the payments, the balance on the chosen day, the low point
/// and the warnings (overdraft, goal).
class PurchaseScenarioCard extends StatelessWidget {
  final PurchaseScenarioInfo scenario;
  final PurchaseSimulation simulation;
  final String currency;
  final VoidCallback? onSave;

  const PurchaseScenarioCard({
    super.key,
    required this.scenario,
    required this.simulation,
    required this.currency,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = scenario;
    String money(int c) => context.money(c, currency: currency);
    final overdraft = s.firstBelowThresholdDate;
    final none = s.option == PurchaseOption.none;
    final title = switch (s.option) {
      PurchaseOption.none => l.purchaseNone,
      PurchaseOption.cash => l.purchaseCash,
      PurchaseOption.threeTimes => l.purchaseTimes(3),
      PurchaseOption.fourTimes => l.purchaseTimes(4),
      PurchaseOption.nextMonth => l.purchaseNextMonth,
    };
    Widget warn(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return SizedBox(
      width: 250,
      child: Card(
        color: none ? theme.colorScheme.surfaceContainerHighest : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              if (none)
                Text(l.purchaseNoneHelp, style: theme.textTheme.bodySmall)
              else
                for (final p in s.payments)
                  Text(
                    '${context.shortDay(p.date)} · ${money(p.amountCents)}',
                    style: theme.textTheme.bodySmall,
                  ),
              const SizedBox(height: 8),
              Text(
                l.purchaseBalanceOn(context.shortDay(simulation.target)),
                style: theme.textTheme.labelMedium,
              ),
              Text(
                money(s.balanceOnTargetCents),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Manrope',
                  color: s.balanceOnTargetCents < simulation.alertThresholdCents
                      ? theme.colorScheme.error
                      : null,
                ),
              ),
              Text(
                l.purchaseLowest(
                  money(s.lowestBalanceCents),
                  context.shortDay(s.lowestDate),
                ),
                style: theme.textTheme.bodySmall,
              ),
              if (overdraft != null)
                warn(
                  Icons.warning_amber,
                  l.overdraftExpected(context.day(overdraft)),
                ),
              if (s.goalOverCents != null)
                warn(Icons.flag, l.purchaseGoalOver(money(s.goalOverCents!))),
              if (onSave != null) ...[
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: onSave,
                  child: Text(l.purchaseChoose),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
