import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import 'soft.dart';

/// The use of the AI per function (decision 0048): the user's own this
/// month and the previous one, or, for the server administrator
/// ([server]), the whole server over six months, never per user.
class AiUsageSection extends StatefulWidget {
  final bool server;

  /// Where the lines come from; the server by default (tests give theirs).
  final Future<List<AiUsageLine>> Function()? load;
  const AiUsageSection({super.key, this.server = false, this.load});

  @override
  State<AiUsageSection> createState() => _AiUsageSectionState();
}

class _AiUsageSectionState extends State<AiUsageSection> {
  List<AiUsageLine>? _lines;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final lines =
          await (widget.load?.call() ??
              (widget.server ? client.ai.serverUsage() : client.ai.usage()));
      if (mounted) setState(() => (_lines = lines, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lines = _lines;
    // Newest month first, as the server sorts them.
    final months = <int, List<AiUsageLine>>{};
    for (final line in lines ?? const <AiUsageLine>[]) {
      (months[line.month] ??= []).add(line);
    }
    return SoftSection(
      icon: Icons.data_usage_outlined,
      title: widget.server ? l.aiUsageServerTitle : l.aiUsageTitle,
      help: widget.server ? l.aiUsageServerHelp : l.aiUsageHelp,
      children: [
        if (_error != null)
          Text(_error!, style: TextStyle(color: theme.colorScheme.error))
        else if (lines == null)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (lines.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.aiUsageEmpty, style: theme.textTheme.bodySmall),
          )
        else
          for (final MapEntry(key: month, value: items) in months.entries) ...[
            _MonthHeader(month: month, lines: items),
            for (final line in items)
              _UsageTile(line: line, server: widget.server),
          ],
        const SizedBox(height: 8),
      ],
    );
  }
}

/// `202611` → November 2026, with the month's estimated cost when every
/// line of it has one.
class _MonthHeader extends StatelessWidget {
  final int month;
  final List<AiUsageLine> lines;
  const _MonthHeader({required this.month, required this.lines});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final date = DateTime(month ~/ 100, month % 100);
    final costs = [for (final x in lines) x.costCents];
    final total = costs.contains(null)
        ? null
        : costs.fold<int>(0, (a, b) => a + b!);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.monthName(date),
              style: theme.textTheme.labelLarge,
            ),
          ),
          if (total != null)
            Text(
              l.aiUsageCost(context.money(total)),
              style: theme.textTheme.labelLarge,
            ),
        ],
      ),
    );
  }
}

class _UsageTile extends StatelessWidget {
  final AiUsageLine line;
  final bool server;
  const _UsageTile({required this.line, required this.server});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final compact = NumberFormat.compact(locale: l.localeName);
    final noTokens = line.inputTokens == 0 && line.outputTokens == 0;
    final cost = line.costCents;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(switch (line.feature) {
        'invoice' => Icons.receipt_long_outlined,
        'loan' => Icons.account_balance_outlined,
        _ => Icons.chat_bubble_outline,
      }, size: 20),
      title: Text('${aiFeatureName(l, line.feature)} · ${line.providerName}'),
      subtitle: Text(
        [
          l.aiUsageRequests(line.requests),
          if (noTokens)
            l.aiUsageTokensUnknown
          else
            l.aiUsageTokens(
              compact.format(line.inputTokens),
              compact.format(line.outputTokens),
            ),
          if (server) l.aiUsageUsers(line.users),
        ].join(' · '),
      ),
      trailing: Text(
        cost == null ? l.aiUsageNoPrice : l.aiUsageCost(context.money(cost)),
        style: cost == null
            ? theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              )
            : theme.textTheme.bodyMedium,
      ),
    );
  }
}

/// The name of a function of the AI, as decision 0048 counts them.
String aiFeatureName(AppLocalizations l, String feature) => switch (feature) {
  'invoice' => l.aiFeatureInvoice,
  'loan' => l.aiFeatureLoan,
  _ => l.aiFeatureChat,
};
