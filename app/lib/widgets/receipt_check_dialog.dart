import 'package:flutter/material.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart';

import '../l10n/app_localizations.dart';
import '../util/format.dart';

/// Values confirmed by the user in [ReceiptCheckDialog].
class ReceiptCheckResult {
  final int? amountCents;
  final DateTime? date;
  final String? merchant;

  const ReceiptCheckResult({this.amountCents, this.date, this.merchant});
}

/// Opens a dialog to check the fields recognized on a receipt.
///
/// Returns [ReceiptCheckResult] when the user validates, or `null` if cancelled.
/// Nothing is ever saved automatically from this alone.
Future<ReceiptCheckResult?> showReceiptCheckDialog(
  BuildContext context,
  ReceiptReading reading,
) => showDialog<ReceiptCheckResult>(
  context: context,
  builder: (_) => ReceiptCheckDialog(reading: reading),
);

/// Dialog where the user reviews and corrects what was read on a till receipt.
/// Fields flagged uncertain are highlighted.
class ReceiptCheckDialog extends StatefulWidget {
  final ReceiptReading reading;

  const ReceiptCheckDialog({super.key, required this.reading});

  @override
  State<ReceiptCheckDialog> createState() => _ReceiptCheckDialogState();
}

class _ReceiptCheckDialogState extends State<ReceiptCheckDialog> {
  late final _amount = TextEditingController();
  late final _merchant = TextEditingController(
    text: widget.reading.merchant?.value,
  );
  late DateTime? _date;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    final d = widget.reading.date?.value;
    _date = d == null ? null : DateTime.utc(d.year, d.month, d.day);

    final a = widget.reading.totalCents?.value;
    if (a != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final fr = Localizations.localeOf(context).languageCode == 'fr';
        final t = (a / 100).toStringAsFixed(2);
        _amount.text = fr ? t.replaceAll('.', ',') : t;
      });
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = todayUtcMidnight();
    final initial = _date ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(today.year - 10),
      lastDate: DateTime(today.year, today.month, today.day + 30),
    );
    if (picked != null) {
      setState(
        () => _date = DateTime.utc(picked.year, picked.month, picked.day),
      );
    }
  }

  void _done() {
    final l = AppLocalizations.of(context);
    final text = _amount.text.trim();
    int? cents;
    if (text.isNotEmpty) {
      cents = parseUserAmount(text)?.abs();
      if (cents == null || cents == 0) {
        setState(() => _amountError = l.invoiceHintAmountInvalid);
        return;
      }
    }
    final m = _merchant.text.trim();
    Navigator.pop<ReceiptCheckResult>(
      context,
      ReceiptCheckResult(
        amountCents: cents,
        date: _date,
        merchant: m.isEmpty ? null : m,
      ),
    );
  }

  Widget _uncertainBadge(BuildContext context, bool certain) {
    if (certain) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.help_outline,
            size: 14,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 4),
          Text(
            l.receiptCheckUncertain,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = widget.reading;
    final date = _date;

    return AlertDialog(
      title: Text(l.receiptCheckTitle),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.receiptCheckIntro, style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              // Amount field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.receiptCheckAmount, style: theme.textTheme.titleSmall),
                  if (r.totalCents != null)
                    _uncertainBadge(context, r.totalCents!.certain),
                ],
              ),
              TextField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.receiptCheckAmount,
                  errorText: _amountError,
                  helperText: r.totalCents != null
                      ? l.receiptCheckSource(r.totalCents!.source)
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              // Merchant field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.receiptCheckMerchant,
                    style: theme.textTheme.titleSmall,
                  ),
                  if (r.merchant != null)
                    _uncertainBadge(context, r.merchant!.certain),
                ],
              ),
              TextField(
                controller: _merchant,
                maxLength: 80,
                decoration: InputDecoration(
                  labelText: l.receiptCheckMerchant,
                  helperText: r.merchant != null
                      ? l.receiptCheckSource(r.merchant!.source)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              // Date field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.receiptCheckDate, style: theme.textTheme.titleSmall),
                  if (r.date != null) _uncertainBadge(context, r.date!.certain),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    date == null ? l.receiptCheckNoValue : context.day(date),
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(l.invoiceWarrantyPick),
                    onPressed: _pickDate,
                  ),
                  if (date != null)
                    TextButton(
                      child: Text(l.invoiceWarrantyClear),
                      onPressed: () => setState(() => _date = null),
                    ),
                ],
              ),
              if (r.date != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l.receiptCheckSource(r.date!.source),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(l.receiptCheckCancel),
        ),
        FilledButton(
          onPressed: _done,
          child: Text(l.receiptCheckConfirm),
        ),
      ],
    );
  }
}
