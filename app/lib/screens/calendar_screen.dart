import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/budget_charts.dart';
import '../widgets/month_nav.dart';

/// Due dates of a budget month: every occurrence of the planned operations
/// (rent, subscriptions, loan instalments…), paid, late or to come.
class CalendarScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;
  final int? accountId;

  const CalendarScreen({
    super.key,
    required this.membership,
    required this.accounts,
    this.accountId,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  var _date = todayUtcMidnight();
  DueCalendar? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await client.scheduled.calendar(
        widget.membership.group.id!,
        _date,
        accountId: widget.accountId,
      );
      if (mounted) setState(() => (_data = d, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  void _shift(int months) {
    final start = _data?.start ?? _date;
    setState(() => (_date = shiftBudgetMonth(start, months), _data = null));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final d = _data;
    final accounts = {for (final a in widget.accounts) a.id!: a};
    final days = <DateTime, List<CalendarItem>>{};
    for (final i in d?.items ?? const <CalendarItem>[]) {
      days.putIfAbsent(i.date, () => []).add(i);
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.calendarTitle)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Center(
              child: MonthNav(start: d?.start, last: d?.last, onShift: _shift),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, textAlign: TextAlign.center),
              )
            else if (d == null)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l.calendarUpcoming(
                    context.money(d.upcomingDebitsCents),
                    context.money(d.upcomingCreditsCents),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (d.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(l.calendarEmpty, textAlign: TextAlign.center),
                ),
              for (final MapEntry(key: day, value: items) in days.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
                  child: Text(
                    context.day(day),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final i in items)
                        _CalendarTile(
                          item: i,
                          account: accounts[i.accountId],
                          showAccount: accounts.length > 1,
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _CalendarTile extends StatelessWidget {
  final CalendarItem item;
  final Account? account;
  final bool showAccount;

  const _CalendarTile({
    required this.item,
    required this.account,
    required this.showAccount,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currency = account?.currency ?? 'EUR';
    // Status: colour always with an icon and a word.
    final (icon, color, text) = switch (item.status) {
      OccurrenceStatus.paid => (
        Icons.check_circle,
        ChartColors.good,
        item.transactionAmountCents != null &&
                item.transactionAmountCents != item.amountCents
            ? l.statusPaidOther(
                context.money(item.transactionAmountCents!, currency: currency),
              )
            : l.statusPaid,
      ),
      OccurrenceStatus.late => (
        Icons.warning_amber,
        ChartColors.warning,
        l.statusLate,
      ),
      OccurrenceStatus.skipped => (
        Icons.redo,
        theme.colorScheme.onSurfaceVariant,
        l.statusSkipped,
      ),
      OccurrenceStatus.upcoming => (
        Icons.schedule,
        theme.colorScheme.primary,
        l.statusUpcoming,
      ),
    };
    final tags = [
      text,
      if (item.loanId != null) l.calendarLoan,
      if (item.subscription) l.calendarSubscription,
      if (showAccount && account != null) account!.name,
    ];
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(item.label),
      subtitle: Text(tags.join(' · ')),
      trailing: Text(
        context.money(item.amountCents, currency: currency),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
