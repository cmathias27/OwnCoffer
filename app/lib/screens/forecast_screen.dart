import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/balance_chart.dart';
import '../widgets/category_field.dart';
import '../widgets/variable_estimate.dart';
import 'purchase_screen.dart';

/// Forecast balance of an account: the day-by-day curve, what is coming,
/// matches to confirm, planned operations that never arrived, and the
/// planned operations themselves. Every figure comes from the server's
/// deterministic engine.
class ForecastScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;

  /// Called after a change that moves balances, to refresh the other tabs.
  final VoidCallback onChanged;

  const ForecastScreen({
    super.key,
    required this.membership,
    required this.accounts,
    required this.onChanged,
  });

  @override
  State<ForecastScreen> createState() => ForecastScreenState();
}

class ForecastScreenState extends State<ForecastScreen> {
  static const _horizons = [30, 90, 365];
  late Account? _account = widget.accounts.firstOrNull;
  var _horizon = 30;

  /// Counts the estimated variable spending (groceries, fuel…).
  var _variable = true;
  ForecastResult? _forecast;
  List<ScheduledTransaction> _scheduled = [];
  Map<int, Category> _categories = {};
  String? _error;

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _reload();
  }

  @override
  void didUpdateWidget(ForecastScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membership.group.id != widget.membership.group.id) {
      _loadCategories();
      _account = null;
    }
    if (_account == null || !widget.accounts.any((a) => a.id == _account!.id)) {
      _account = widget.accounts.firstOrNull;
      _reload();
    }
  }

  Future<void> _loadCategories() async {
    final list = await client.category.list(widget.membership.group.id!);
    if (mounted) setState(() => _categories = {for (final c in list) c.id!: c});
  }

  Future<void> reload() => _reload();

  /// Shows the forecast of [accountId] (from a notification).
  void showAccount(int accountId) {
    final account = widget.accounts.where((a) => a.id == accountId).firstOrNull;
    if (account == null) return;
    setState(() {
      _account = account;
      _forecast = null;
      _scheduled = [];
    });
    _reload();
  }

  Future<void> _reload() async {
    final account = _account;
    if (account == null) return;
    try {
      final forecast = await client.scheduled.forecast(
        account.id!,
        todayUtcMidnight(),
        horizonDays: _horizon,
        includeVariable: _variable,
      );
      final scheduled = await client.scheduled.list(account.id!);
      if (!mounted || _account?.id != account.id) return;
      setState(() {
        _forecast = forecast;
        _scheduled = scheduled;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _act(Future<void> Function() call, String done) async {
    final l = AppLocalizations.of(context);
    try {
      await call();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      widget.onChanged();
      await _reload();
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    }
  }

  Future<void> _edit([ScheduledTransaction? s]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ScheduledDialog(
        accountId: _account!.id!,
        scheduled: s,
        categories: _categories,
      ),
    );
    if (saved == true) {
      widget.onChanged();
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final account = _account;
    if (account == null) return Center(child: Text(l.importNoAccount));
    final f = _forecast;
    final currency = account.currency;
    String money(int c) => context.money(c, currency: currency);
    final balanceOn = {
      for (final d in f?.days ?? <ForecastDay>[]) d.date: d.balanceCents,
    };
    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      child: Text(title, style: theme.textTheme.titleMedium),
    );

    return Scaffold(
      floatingActionButton: _canWrite
          ? FloatingActionButton.extended(
              onPressed: _edit,
              icon: const Icon(Icons.event_repeat),
              label: Text(l.scheduledAdd),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (widget.accounts.length > 1)
                  DropdownButton<int>(
                    value: account.id,
                    items: [
                      for (final a in widget.accounts)
                        DropdownMenuItem(value: a.id, child: Text(a.name)),
                    ],
                    onChanged: (id) {
                      setState(() {
                        _account = widget.accounts.firstWhere(
                          (a) => a.id == id,
                        );
                        _forecast = null;
                        _scheduled = [];
                      });
                      _reload();
                    },
                  ),
                SegmentedButton<int>(
                  segments: [
                    for (final h in _horizons)
                      ButtonSegment(
                        value: h,
                        label: Text(
                          h == 365 ? l.horizonYear : l.horizonDays(h),
                        ),
                      ),
                  ],
                  selected: {_horizon},
                  onSelectionChanged: (s) {
                    setState(() => _horizon = s.first);
                    _reload();
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.calculate_outlined, size: 18),
                  label: Text(l.purchaseTitle),
                  onPressed: () async {
                    final saved = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => PurchaseScreen(
                          membership: widget.membership,
                          account: account,
                          categories: _categories,
                        ),
                      ),
                    );
                    if (saved == true) {
                      widget.onChanged();
                      await _reload();
                    }
                  },
                ),
                Tooltip(
                  message: l.variableToggleHelp,
                  child: FilterChip(
                    avatar: _variable
                        ? null
                        : const Icon(Icons.shopping_cart_outlined, size: 18),
                    label: Text(l.variableToggle),
                    selected: _variable,
                    onSelected: (v) {
                      setState(() => _variable = v);
                      _reload();
                    },
                  ),
                ),
              ],
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            if (f == null && _error == null)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (f != null) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.forecastTitle, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(l.forecastCurrent(money(f.currentBalanceCents))),
                      Text(
                        l.forecastLowest(
                          money(f.lowestBalanceCents),
                          context.shortDay(f.lowestDate),
                        ),
                      ),
                      if (f.days.isNotEmpty)
                        Text(
                          l.forecastEnd(
                            context.day(f.days.last.date),
                            money(f.days.last.balanceCents),
                          ),
                        ),
                      if (f.firstBelowThresholdDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l.overdraftExpected(
                                    context.day(f.firstBelowThresholdDate!),
                                  ),
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      BalanceChart(
                        days: f.days,
                        thresholdCents: f.alertThresholdCents,
                        thresholdLabel: l.forecastThresholdLine(
                          money(f.alertThresholdCents),
                        ),
                        lowestLabel: l.forecastLowestMark,
                        semanticLabel: l.forecastChartLabel,
                        money: money,
                        axisMoney: (c) => money(c - c.remainder(100)),
                        day: context.shortDay,
                      ),
                      if (f.variable case final v?)
                        VariableEstimateCard(
                          estimate: v,
                          categories: _categories,
                          money: money,
                        ),
                      if (f.autoReconciledCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            l.forecastAutoReconciled(f.autoReconciledCount),
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (f.proposals.isNotEmpty) ...[
                section(l.forecastProposals),
                for (final p in f.proposals)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.link),
                      title: Text(
                        l.forecastProposalText(
                          '${p.label} (${money(p.amountCents)})',
                          context.shortDay(p.date),
                          _scheduledLabel(p.scheduledId),
                          context.shortDay(p.dueDate),
                        ),
                      ),
                      trailing: _canWrite
                          ? FilledButton.tonal(
                              onPressed: () => _act(
                                () => client.scheduled.confirmMatch(
                                  p.scheduledId,
                                  p.dueDate,
                                  p.transactionId,
                                ),
                                l.forecastMatched,
                              ),
                              child: Text(l.confirm),
                            )
                          : null,
                    ),
                  ),
              ],
              if (f.missed.isNotEmpty) ...[
                section(l.forecastMissed),
                for (final m in f.missed)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.event_busy,
                        color: theme.colorScheme.tertiary,
                      ),
                      title: Text(
                        '${m.label} · ${money(m.amountCents)}',
                      ),
                      subtitle: Text(
                        l.forecastMissedText(context.day(m.dueDate)),
                      ),
                      trailing: _canWrite
                          ? TextButton(
                              onPressed: () => _act(
                                () => client.scheduled.skipNext(m.scheduledId),
                                l.forecastSkipped,
                              ),
                              child: Text(l.forecastSkip),
                            )
                          : null,
                    ),
                  ),
              ],
              section(l.forecastUpcoming),
              if (f.events.isEmpty) Text(l.forecastNoUpcoming),
              for (final e in f.events)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(e.label),
                  subtitle: Text(
                    [
                      context.shortDay(e.date),
                      if (e.dueDate != null)
                        l.forecastLate(context.shortDay(e.dueDate!)),
                      if (balanceOn[e.date] != null)
                        l.forecastBalanceAfter(money(balanceOn[e.date]!)),
                    ].join(' · '),
                  ),
                  trailing: _Amount(e.amountCents, money(e.amountCents)),
                ),
            ],
            section(l.scheduledTitle),
            if (_scheduled.isEmpty) Text(l.scheduledEmpty),
            for (final s in _scheduled)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_repeat),
                title: Text(s.label),
                subtitle: Text(_describe(context, s)),
                trailing: _Amount(s.amountCents, money(s.amountCents)),
                onTap: _canWrite ? () => _edit(s) : null,
              ),
          ],
        ),
      ),
    );
  }

  String _scheduledLabel(int id) =>
      _scheduled.where((s) => s.id == id).firstOrNull?.label ?? '?';

  static String _describe(BuildContext context, ScheduledTransaction s) {
    final l = AppLocalizations.of(context);
    final start = context.day(s.startDate);
    if (s.frequency == ScheduleFrequency.once) return l.onceOn(start);
    final every = switch (s.frequency) {
      ScheduleFrequency.weekly => l.everyWeeks(s.interval),
      ScheduleFrequency.yearly => l.everyYears(s.interval),
      _ => l.everyMonths(s.interval),
    };
    return [
      every,
      l.fromDate(start),
      if (s.endDate != null) l.untilDate(context.day(s.endDate!)),
    ].join(' · ');
  }
}

class _Amount extends StatelessWidget {
  final int cents;
  final String text;
  const _Amount(this.cents, this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.titleSmall?.copyWith(
      fontFamily: 'Manrope',
      color: cents > 0 ? Colors.green.shade700 : null,
    ),
  );
}

/// Creates or edits a planned operation. Frequency and first occurrence are
/// fixed once created (the server keeps its realised occurrences).
class _ScheduledDialog extends StatefulWidget {
  final int accountId;
  final ScheduledTransaction? scheduled;
  final Map<int, Category> categories;

  const _ScheduledDialog({
    required this.accountId,
    required this.scheduled,
    required this.categories,
  });

  @override
  State<_ScheduledDialog> createState() => _ScheduledDialogState();
}

class _ScheduledDialogState extends State<_ScheduledDialog> {
  late final ScheduledTransaction? _s = widget.scheduled;
  late final _label = TextEditingController(text: _s?.label);
  late final _amount = TextEditingController(
    text: _s == null ? '' : _formatInput(_s.amountCents),
  );
  late final _interval = TextEditingController(text: '${_s?.interval ?? 1}');
  late final _pattern = TextEditingController(text: _s?.matchPattern);
  late final _dateTolerance = TextEditingController(
    text: '${_s?.dateToleranceDays ?? 5}',
  );
  late final _amountTolerance = TextEditingController(
    text: '${_s?.amountTolerancePercent ?? 0}',
  );
  late var _frequency = _s?.frequency ?? ScheduleFrequency.monthly;
  late var _start = _s?.startDate ?? todayUtcMidnight();
  late DateTime? _end = _s?.endDate;
  late int? _category = _s?.categoryId;
  late var _subscription = _s?.subscription ?? false;
  final _form = GlobalKey<FormState>();
  var _busy = false;
  String? _error;

  bool get _editing => _s != null;

  @override
  void dispose() {
    for (final c in [
      _label,
      _amount,
      _interval,
      _pattern,
      _dateTolerance,
      _amountTolerance,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Cents to an editable text without going through double: -1250 → -12,50.
  static String _formatInput(int cents) {
    final sign = cents < 0 ? '-' : '';
    final a = cents.abs();
    return '$sign${a ~/ 100},${(a % 100).toString().padLeft(2, '0')}';
  }

  Future<DateTime?> _pickDate(DateTime initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return picked == null
        ? null
        : DateTime.utc(picked.year, picked.month, picked.day);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final amount = parseUserAmount(_amount.text)!;
    final dateTolerance = int.parse(_dateTolerance.text.trim());
    final amountTolerance = int.parse(_amountTolerance.text.trim());
    setState(() => (_busy = true, _error = null));
    try {
      final s = _s;
      if (s == null) {
        await client.scheduled.create(
          widget.accountId,
          amount,
          _label.text,
          _frequency,
          _start,
          interval: int.parse(_interval.text.trim()),
          endDate: _frequency == ScheduleFrequency.once ? null : _end,
          categoryId: _category,
          matchPattern: _pattern.text,
          dateToleranceDays: dateTolerance,
          amountTolerancePercent: amountTolerance,
          subscription: _subscription,
        );
      } else {
        await client.scheduled.update(
          s.id!,
          amountCents: amount,
          label: _label.text,
          categoryId: _category,
          endDate: _end,
          matchPattern: _pattern.text,
          dateToleranceDays: dateTolerance,
          amountTolerancePercent: amountTolerance,
          subscription: _subscription,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    final s = _s!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.scheduledDeleteConfirm(s.label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.scheduledDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await client.scheduled.delete(s.id!);
      if (mounted) Navigator.pop(context, true);
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    }
  }

  String? _wholeNumber(String? v, AppLocalizations l, {int min = 0}) {
    final n = int.tryParse(v?.trim() ?? '');
    return n == null || n < min ? l.toleranceInvalid : null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const gap = SizedBox(height: 12);
    final categories = widget.categories.values.toList()
      ..sort(
        (a, b) => context.categoryName(a).compareTo(context.categoryName(b)),
      );
    return AlertDialog(
      title: Text(_editing ? l.scheduledEdit : l.scheduledAdd),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _label,
                  autofocus: !_editing,
                  maxLength: 80,
                  decoration: InputDecoration(labelText: l.labelLabel),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l.error_invalid_name
                      : null,
                ),
                TextFormField(
                  controller: _amount,
                  decoration: InputDecoration(
                    labelText: l.amountLabel,
                    helperText: l.amountHelp,
                  ),
                  validator: (v) {
                    final c = parseUserAmount(v ?? '');
                    return c == null || c == 0 ? l.amountInvalid : null;
                  },
                ),
                gap,
                DropdownButtonFormField<ScheduleFrequency>(
                  isExpanded: true,
                  initialValue: _frequency,
                  decoration: InputDecoration(labelText: l.frequencyLabel),
                  items: [
                    for (final (f, text) in [
                      (ScheduleFrequency.once, l.frequencyOnce),
                      (ScheduleFrequency.weekly, l.frequencyWeekly),
                      (ScheduleFrequency.monthly, l.frequencyMonthly),
                      (ScheduleFrequency.yearly, l.frequencyYearly),
                    ])
                      DropdownMenuItem(value: f, child: Text(text)),
                  ],
                  onChanged: _editing
                      ? null
                      : (v) => setState(() => _frequency = v!),
                ),
                if (_frequency != ScheduleFrequency.once) ...[
                  gap,
                  TextFormField(
                    controller: _interval,
                    enabled: !_editing,
                    decoration: InputDecoration(
                      labelText: l.intervalLabel,
                      helperText: l.intervalHelp,
                    ),
                    validator: (v) => _wholeNumber(v, l, min: 1),
                  ),
                ],
                gap,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  enabled: !_editing,
                  title: Text(l.startDateLabel),
                  subtitle: Text(context.day(_start)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final d = await _pickDate(_start);
                    if (d != null) setState(() => _start = d);
                  },
                ),
                if (_frequency != ScheduleFrequency.once)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.endDateLabel),
                    subtitle: Text(
                      _end == null ? l.noEndDate : context.day(_end!),
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final d = await _pickDate(_end ?? _start);
                      if (d != null) setState(() => _end = d);
                    },
                  ),
                if (_editing)
                  Text(l.scheduledLockedHelp, style: theme.textTheme.bodySmall),
                gap,
                CategoryFormField(
                  categories: categories,
                  initialValue: _category,
                  label: l.categoryLabel,
                  noneLabel: l.noCategory,
                  onChanged: (v) => _category = v,
                ),
                gap,
                TextFormField(
                  controller: _pattern,
                  decoration: InputDecoration(
                    labelText: l.matchPatternLabel,
                    helperText: l.matchPatternHelp,
                    helperMaxLines: 2,
                  ),
                ),
                gap,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateTolerance,
                        decoration: InputDecoration(
                          labelText: l.dateToleranceLabel,
                        ),
                        validator: (v) => _wholeNumber(v, l),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _amountTolerance,
                        decoration: InputDecoration(
                          labelText: l.amountToleranceLabel,
                        ),
                        validator: (v) => _wholeNumber(v, l),
                      ),
                    ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.subscriptionSwitch),
                  subtitle: Text(l.subscriptionSwitchHelp),
                  value: _subscription,
                  onChanged: (v) => setState(() => _subscription = v),
                ),
                if (_error != null) ...[
                  gap,
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (_editing)
          TextButton(
            onPressed: _busy ? null : _delete,
            child: Text(l.scheduledDelete),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: Text(l.save),
        ),
      ],
    );
  }
}
