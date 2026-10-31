import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import 'budget_charts.dart';

/// Balance check: the balance shown by the bank on a date against the one
/// computed from the operations, with what may explain a gap.
class BalanceCheckDialog extends StatefulWidget {
  final Account account;
  const BalanceCheckDialog({super.key, required this.account});

  @override
  State<BalanceCheckDialog> createState() => _BalanceCheckDialogState();
}

class _BalanceCheckDialogState extends State<BalanceCheckDialog> {
  var _date = todayUtcMidnight();
  final _amount = TextEditingController();
  BalanceCheck? _result;
  List<BalanceCheck> _history = [];
  String? _error;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    client.account.balanceChecks(widget.account.id!).then((h) {
      if (mounted) setState(() => _history = h);
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    final l = AppLocalizations.of(context);
    final cents = parseUserAmount(_amount.text);
    if (cents == null) {
      setState(() => _error = l.amountInvalid);
      return;
    }
    setState(() => (_busy = true, _error = null));
    try {
      final r = await client.account.checkBalance(
        widget.account.id!,
        _date,
        cents,
      );
      if (mounted) {
        setState(
          () => (_result = r, _history = [r, ..._history], _busy = false),
        );
      }
    } on Object catch (e) {
      if (mounted) setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currency = widget.account.currency;
    String money(int c) => context.money(c, currency: currency);
    final r = _result;
    return AlertDialog(
      title: Text('${l.balanceCheckAction} · ${widget.account.name}'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.balanceCheckHelp),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: Text(l.balanceCheckDate),
                subtitle: Text(context.day(_date)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(_date.year, _date.month, _date.day),
                    firstDate: DateTime(1970),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(
                      () => _date = DateTime.utc(
                        picked.year,
                        picked.month,
                        picked.day,
                      ),
                    );
                  }
                },
              ),
              TextField(
                controller: _amount,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: InputDecoration(
                  labelText: l.balanceCheckAmount,
                  suffixText: currency == 'EUR' ? '€' : currency,
                ),
                onSubmitted: (_) => _check(),
              ),
              if (r != null) ...[
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      r.differenceCents == 0
                          ? Icons.check_circle
                          : Icons.warning_amber,
                      color: r.differenceCents == 0
                          ? ChartColors.good
                          : ChartColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.differenceCents == 0
                                ? l.balanceCheckOk
                                : l.balanceCheckGap(
                                    money(r.differenceCents),
                                    money(r.computedCents),
                                  ),
                            style: theme.textTheme.bodyLarge,
                          ),
                          if (r.differenceCents != 0 &&
                              r.unclearedManualCents != 0)
                            Text(
                              l.balanceCheckUncleared(
                                money(r.unclearedManualCents),
                              ),
                            ),
                          if (r.differenceCents != 0 &&
                              r.lastImportedDate != null &&
                              r.lastImportedDate!.isBefore(
                                r.date.subtract(const Duration(days: 3)),
                              ))
                            Text(
                              l.balanceCheckLastImport(
                                context.day(r.lastImportedDate!),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              if (_history.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l.balanceCheckHistory, style: theme.textTheme.titleSmall),
                for (final h in _history.take(5))
                  Text(
                    l.balanceCheckRow(
                      context.day(h.date),
                      money(h.bankBalanceCents),
                      money(h.differenceCents),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.close),
        ),
        FilledButton(
          onPressed: _busy ? null : _check,
          child: Text(l.balanceCheckAction),
        ),
      ],
    );
  }
}
