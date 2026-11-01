import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../widgets/soft.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// Subscriptions of the group (planned operations marked as such), with
/// what they cost per month and per year.
class SubscriptionsScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;

  const SubscriptionsScreen({
    super.key,
    required this.membership,
    required this.accounts,
  });

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  SubscriptionOverview? _data;
  String? _error;

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await client.scheduled.subscriptions(
        widget.membership.group.id!,
      );
      if (mounted) setState(() => (_data = d, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  String _frequency(AppLocalizations l, ScheduledTransaction s) =>
      switch (s.frequency) {
        ScheduleFrequency.weekly => l.frequencyWeekly,
        ScheduleFrequency.monthly => l.frequencyMonthly,
        ScheduleFrequency.yearly => l.frequencyYearly,
        ScheduleFrequency.once => l.frequencyOnce,
      };

  Future<void> _actions(ScheduledTransaction s) async {
    final l = AppLocalizations.of(context);
    final action = await showSoftSheet<int>(
      context,
      builder: (context, _) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                s.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.label_off_outlined),
              title: Text(l.subscriptionUnmark),
              subtitle: Text(l.subscriptionUnmarkHelp),
              onTap: () => Navigator.of(context).pop(0),
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: Text(l.subscriptionStop),
              subtitle: Text(l.subscriptionStopHelp),
              onTap: () => Navigator.of(context).pop(1),
            ),
          ],
        ),
      ),
    );
    if (action == null) return;
    try {
      if (action == 0) {
        await client.scheduled.update(s.id!, subscription: false);
      } else {
        await client.scheduled.delete(s.id!);
      }
      await _load();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorText(l, e))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final d = _data;
    final accounts = {for (final a in widget.accounts) a.id!: a};
    return Scaffold(
      appBar: AppBar(title: Text(l.subscriptionsTitle)),
      body: _error != null
          ? Center(child: Text(_error!))
          : d == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.subscriptionsMonthly,
                                style: theme.textTheme.labelMedium,
                              ),
                              Text(
                                context.money(-d.monthlyTotalCents),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.subscriptionsYearly,
                                style: theme.textTheme.labelMedium,
                              ),
                              Text(
                                context.money(-d.yearlyTotalCents),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(l.subscriptionsHelp, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                if (d.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l.subscriptionsEmpty,
                      textAlign: TextAlign.center,
                    ),
                  ),
                for (final (i, s) in d.items.indexed)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.autorenew),
                    title: Text(s.label),
                    subtitle: Text(
                      [
                        _frequency(l, s),
                        if (s.nextDue != null)
                          l.subscriptionNext(context.day(s.nextDue!)),
                        if (accounts.length > 1 &&
                            accounts[s.accountId] != null)
                          accounts[s.accountId]!.name,
                      ].join(' · '),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          context.money(s.amountCents),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontFamily: 'Manrope',
                          ),
                        ),
                        if (s.frequency != ScheduleFrequency.monthly ||
                            s.interval != 1)
                          Text(
                            l.subscriptionPerMonth(
                              context.money(d.monthlyCents[i]),
                            ),
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                    onTap: _canWrite ? () => _actions(s) : null,
                  ),
              ],
            ),
    );
  }
}
