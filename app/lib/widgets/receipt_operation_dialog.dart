import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import 'category_field.dart';

/// Accounts and categories of the receipt's group.
typedef ReceiptOperationChoices = ({
  List<Account> accounts,
  List<Category> categories,
});

/// Creates the operation and attaches the receipt (the server checks it all
/// again): invoice, account, day, total paid (positive), label, category.
typedef ReceiptOperationCreate =
    Future<InvoiceInfo> Function(
      int invoiceId,
      int accountId,
      DateTime date,
      int amountCents,
      String label,
      int? categoryId,
    );

/// Opens [ReceiptOperationDialog]; returns the receipt attached to its new
/// operation, or null if cancelled.
Future<InvoiceInfo?> showReceiptOperationDialog(
  BuildContext context,
  InvoiceInfo info,
) => showDialog<InvoiceInfo>(
  context: context,
  builder: (_) => ReceiptOperationDialog(info: info),
);

/// A waiting receipt whose operation is not on a statement (cash, an
/// account not imported): its operation, filled from what was read or typed
/// on the receipt, checked by the user, then created with the receipt
/// attached (decision 0036). Nothing is written before « Créer ».
class ReceiptOperationDialog extends StatefulWidget {
  final InvoiceInfo info;

  /// Tests replace the server calls.
  final Future<ReceiptOperationChoices> Function(int groupId)? load;
  final ReceiptOperationCreate? create;

  const ReceiptOperationDialog({
    super.key,
    required this.info,
    this.load,
    this.create,
  });

  @override
  State<ReceiptOperationDialog> createState() => _ReceiptOperationDialogState();
}

class _ReceiptOperationDialogState extends State<ReceiptOperationDialog> {
  late final Invoice _invoice = widget.info.invoice;
  late final _amount = TextEditingController();
  late final _label = TextEditingController(text: _invoice.hintMerchant);
  late DateTime _date = _invoice.hintDate ?? todayUtcMidnight();
  ReceiptOperationChoices? _choices;
  int? _accountId;
  int? _categoryId;
  String? _error;
  String? _amountError;
  String? _labelError;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _loadChoices();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cents = _invoice.hintAmountCents;
    if (cents != null && _amount.text.isEmpty) {
      final t = (cents / 100).toStringAsFixed(2);
      _amount.text = Localizations.localeOf(context).languageCode == 'fr'
          ? t.replaceAll('.', ',')
          : t;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _label.dispose();
    super.dispose();
  }

  static Future<ReceiptOperationChoices> _fetch(int groupId) async {
    final (accounts, categories) = await (
      client.account.list(groupId),
      client.category.list(groupId),
    ).wait;
    return (accounts: accounts, categories: categories);
  }

  static Future<InvoiceInfo> _send(
    int invoiceId,
    int accountId,
    DateTime date,
    int amountCents,
    String label,
    int? categoryId,
  ) => client.invoice.createOperation(
    invoiceId,
    accountId,
    date,
    amountCents,
    label,
    categoryId: categoryId,
  );

  Future<void> _loadChoices() async {
    try {
      final c = await (widget.load ?? _fetch)(_invoice.groupId);
      if (!mounted) return;
      // Checking accounts first: a receipt is usually paid from one.
      final accounts = [
        ...c.accounts.where((a) => a.kind == AccountKind.checking),
        ...c.accounts.where((a) => a.kind != AccountKind.checking),
      ];
      setState(() {
        _choices = (accounts: accounts, categories: c.categories);
        _accountId = accounts.isEmpty ? null : accounts.first.id;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _pickDate() async {
    final today = todayUtcMidnight();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_date.year, _date.month, _date.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year, today.month, today.day + 30),
    );
    if (picked != null) {
      setState(
        () => _date = DateTime.utc(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final cents = parseUserAmount(_amount.text.trim())?.abs();
    final label = _label.text.trim();
    setState(() {
      _amountError = cents == null || cents == 0 ? l.amountInvalid : null;
      _labelError = label.isEmpty ? l.receiptOperationLabelMissing : null;
      _error = null;
    });
    final accountId = _accountId;
    if (_amountError != null || _labelError != null || accountId == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      final info = await (widget.create ?? _send)(
        _invoice.id!,
        accountId,
        _date,
        cents!,
        label,
        _categoryId,
      );
      if (mounted) Navigator.pop(context, info);
    } on Object catch (e) {
      if (mounted) setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final choices = _choices;
    return AlertDialog(
      title: Text(l.receiptOperationTitle),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.receiptOperationHelp, style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),
              if (choices == null && _error == null)
                const LinearProgressIndicator()
              else if (choices != null && choices.accounts.isEmpty)
                Text(l.receiptOperationNoAccount)
              else if (choices != null) ...[
                DropdownButtonFormField<int>(
                  initialValue: _accountId,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l.chooseAccount),
                  items: [
                    for (final a in choices.accounts)
                      DropdownMenuItem(
                        value: a.id,
                        child: Text(a.name, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: _busy
                      ? null
                      : (v) => setState(() => _accountId = v),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event),
                  title: Text(l.dateValue(context.day(_date))),
                  onTap: _busy ? null : _pickDate,
                ),
                TextField(
                  key: const ValueKey('receipt-operation-amount'),
                  controller: _amount,
                  enabled: !_busy,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l.receiptOperationAmount,
                    errorText: _amountError,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey('receipt-operation-label'),
                  controller: _label,
                  enabled: !_busy,
                  decoration: InputDecoration(
                    labelText: l.labelLabel,
                    errorText: _labelError,
                  ),
                ),
                const SizedBox(height: 12),
                CategoryFormField(
                  categories: choices.categories,
                  label: l.categoryLabel,
                  noneLabel: l.receiptOperationByRules,
                  onChanged: _busy
                      ? null
                      : (v) => setState(() => _categoryId = v),
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _busy || choices == null || choices.accounts.isEmpty
              ? null
              : _save,
          child: Text(l.receiptOperationCreate),
        ),
      ],
    );
  }
}
