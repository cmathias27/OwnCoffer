import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// Dialog to schedule or clear an upcoming price rise on a subscription
/// (e.g. promotional offer ending in 3 months, or price hike announced).
class PriceRiseDialog extends StatefulWidget {
  final ScheduledTransaction subscription;

  const PriceRiseDialog({super.key, required this.subscription});

  @override
  State<PriceRiseDialog> createState() => _PriceRiseDialogState();
}

class _PriceRiseDialogState extends State<PriceRiseDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late DateTime _date;
  var _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final s = widget.subscription;
    final cents = s.priceRiseAmountCents?.abs();
    _amount = TextEditingController(
      text: cents == null
          ? ''
          : '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}',
    );
    final now = DateTime.now();
    _date = s.priceRiseDate != null
        ? DateTime(
            s.priceRiseDate!.year,
            s.priceRiseDate!.month,
            s.priceRiseDate!.day,
          )
        : DateTime(now.year, now.month + 1, 1);
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final parsed = parseUserAmount(_amount.text);
    if (parsed == null || parsed <= 0) return;
    setState(() => (_busy = true, _error = null));
    try {
      final updated = await client.scheduled.setPriceRise(
        widget.subscription.id!,
        date: DateTime.utc(_date.year, _date.month, _date.day),
        amountCents: parsed,
      );
      if (mounted) Navigator.of(context).pop(updated);
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = errorText(AppLocalizations.of(context), e);
        });
      }
    }
  }

  Future<void> _clear() async {
    setState(() => (_busy = true, _error = null));
    try {
      final updated = await client.scheduled.setPriceRise(
        widget.subscription.id!,
        date: null,
        amountCents: null,
      );
      if (mounted) Navigator.of(context).pop(updated);
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = errorText(AppLocalizations.of(context), e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = widget.subscription;
    final hasExisting =
        s.priceRiseDate != null && s.priceRiseAmountCents != null;

    return AlertDialog(
      title: Text(l.subscriptionPriceRiseDialogTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.subscriptionPriceRiseDialogHelp,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: Text(l.subscriptionPriceRiseDate),
                subtitle: Text(context.day(_date)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _busy ? null : _pickDate,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amount,
                enabled: !_busy,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.subscriptionPriceRiseNewAmount,
                  prefixIcon: const Icon(Icons.euro),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  final val = parseUserAmount(v ?? '');
                  if (val == null || val <= 0) return l.fieldRequired;
                  return null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (hasExisting)
          TextButton(
            onPressed: _busy ? null : _clear,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(l.subscriptionPriceRiseClear),
          ),
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: _busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l.subscriptionPriceRiseSave),
        ),
      ],
    );
  }
}

Future<ScheduledTransaction?> showPriceRiseDialog({
  required BuildContext context,
  required ScheduledTransaction subscription,
}) {
  return showDialog<ScheduledTransaction>(
    context: context,
    builder: (context) => PriceRiseDialog(subscription: subscription),
  );
}
