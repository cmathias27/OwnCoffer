import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../assistant/chat_controller.dart';
import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../widgets/category_field.dart';
import '../widgets/soft.dart';
import 'advisor_screen.dart';
import 'notifications_screen.dart';

/// Monthly summary on one page (decision 0035): the 30-day forecast of the
/// checking accounts, the unread alerts and the proposals waiting, with the
/// announced subscription rises. Every figure comes from the engine; the AI
/// only explains, on demand, when one is set up.
class MonthSummaryScreen extends StatefulWidget {
  final GroupMembership membership;

  /// Opens the forecast page (on the account, when one is given).
  final void Function(int? accountId) onOpenForecast;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenAdvisor;

  /// Loads the summary and the group's categories (tests replace it).
  final Future<(MonthSummary, List<Category>)> Function(int groupId)? load;

  const MonthSummaryScreen({
    super.key,
    required this.membership,
    required this.onOpenForecast,
    required this.onOpenNotifications,
    required this.onOpenAdvisor,
    this.load,
  });

  @override
  State<MonthSummaryScreen> createState() => _MonthSummaryScreenState();
}

class _MonthSummaryScreenState extends State<MonthSummaryScreen> {
  MonthSummary? _data;
  Map<int, Category> _categories = {};
  String? _error;

  int get _groupId => widget.membership.group.id!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final (summary, categories) = await (widget.load ?? _fetch)(_groupId);
      if (!mounted) return;
      setState(() {
        _data = summary;
        _categories = {for (final c in categories) c.id!: c};
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  static Future<(MonthSummary, List<Category>)> _fetch(int groupId) => (
    client.analysis.summary(groupId, todayUtcMidnight()),
    client.category.list(groupId),
  ).wait;

  String _category(int id) {
    final c = _categories[id];
    return c == null ? '?' : categoryPath(context, c, _categories);
  }

  /// The chat bubble lives on the home page: close this page, open the chat
  /// and ask for an explanation of the figures computed by the engine.
  Future<void> _askAi(AppLocalizations l) async {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    chat.setOpen(true);
    final error = await chat.send(l.summaryAiQuestion);
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final d = _data;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.summaryTitle),
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : d == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                            child: Text(
                              l.summaryHelp(context.day(d.until)),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          ListenableBuilder(
                            listenable: chat,
                            builder: (context, _) => chat.hasAi
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: OutlinedButton.icon(
                                        icon: const Icon(
                                          Icons.auto_awesome_outlined,
                                        ),
                                        label: Text(l.summaryAskAi),
                                        onPressed: chat.sending
                                            ? null
                                            : () => _askAi(l),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          for (final s in _sections(context, l, d))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: s,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<Widget> _sections(
    BuildContext context,
    AppLocalizations l,
    MonthSummary d,
  ) {
    final theme = Theme.of(context);
    final warn = theme.colorScheme.error;
    TextStyle? strong(bool bad) => theme.textTheme.bodyMedium?.copyWith(
      color: bad ? warn : null,
      fontWeight: bad ? FontWeight.w600 : null,
    );
    return [
      SoftSection(
        icon: Icons.show_chart,
        title: l.summaryForecastTitle,
        children: [
          if (d.forecasts.isEmpty) Text(l.summaryNoAccount),
          for (final f in d.forecasts) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                f.accountName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.summaryToday(
                      context.money(
                        f.currentBalanceCents,
                        currency: f.currency,
                      ),
                    ),
                  ),
                  Text(
                    l.summaryEnd(
                      context.day(d.until),
                      context.money(f.endBalanceCents, currency: f.currency),
                    ),
                    style: strong(f.endBalanceCents < 0),
                  ),
                  Text(
                    l.summaryLowest(
                      context.money(
                        f.lowestBalanceCents,
                        currency: f.currency,
                      ),
                      context.day(f.lowestDate),
                    ),
                    style: strong(f.lowestBalanceCents < 0),
                  ),
                  if (f.firstBelowThresholdDate case final below?)
                    Text(
                      l.summaryBelow(
                        context.money(
                          f.alertThresholdCents,
                          currency: f.currency,
                        ),
                        context.day(below),
                      ),
                      style: strong(true),
                    ),
                  Text(
                    l.summaryPlanned(
                      context.money(
                        f.plannedDebitsCents,
                        currency: f.currency,
                      ),
                      context.money(
                        f.plannedCreditsCents,
                        currency: f.currency,
                      ),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  if (f.missedCount > 0)
                    Text(l.summaryMissed(f.missedCount), style: strong(true)),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => widget.onOpenForecast(f.accountId),
            ),
          ],
        ],
      ),
      if (d.priceRises.isNotEmpty)
        SoftSection(
          icon: Icons.campaign_outlined,
          title: l.summaryPriceRisesTitle,
          children: [
            for (final s in d.priceRises)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  l.summaryPriceRise(
                    s.label,
                    context.money(s.priceRiseAmountCents!.abs()),
                    context.day(s.priceRiseDate!),
                  ),
                ),
              ),
          ],
        ),
      SoftSection(
        icon: Icons.notifications_active_outlined,
        title: l.summaryAlertsTitle,
        children: [
          if (d.alerts.isEmpty) Text(l.summaryNoAlert),
          for (final n in d.alerts)
            Builder(
              builder: (context) {
                final (title, body) = NotificationsScreen.texts(context, n);
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(title),
                  subtitle: body == null ? null : Text(body),
                );
              },
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: widget.onOpenNotifications,
              child: Text(l.summaryOpenNotifications),
            ),
          ),
        ],
      ),
      SoftSection(
        icon: Icons.lightbulb_outline,
        title: l.summaryProposalsTitle,
        children: [
          if (d.proposals.isEmpty) Text(l.summaryNoProposal),
          for (final p in d.proposals)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.pending_actions_outlined),
              title: Text(proposalTitle(context, p, _category)),
              onTap: widget.onOpenAdvisor,
            ),
          if (d.proposals.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: widget.onOpenAdvisor,
                child: Text(l.summaryOpenAdvisor),
              ),
            ),
        ],
      ),
    ];
  }
}
