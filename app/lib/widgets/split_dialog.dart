import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import 'category_field.dart';

/// Splits an operation between categories: parts of its sign adding up to
/// its amount. Pops with the saved operation, or null.
class SplitDialog extends StatefulWidget {
  final BankTransaction operation;
  final List<TransactionSplit> current;
  final List<Category> categories;
  final String currency;

  const SplitDialog({
    super.key,
    required this.operation,
    required this.current,
    required this.categories,
    required this.currency,
  });

  @override
  State<SplitDialog> createState() => _SplitDialogState();
}

class _Part {
  int? categoryId;
  final TextEditingController amount;
  final TextEditingController note;
  _Part(this.categoryId, String amount, String? note)
    : amount = TextEditingController(text: amount),
      note = TextEditingController(text: note);
}

class _SplitDialogState extends State<SplitDialog> {
  late final int _sign = widget.operation.amountCents < 0 ? -1 : 1;
  late final List<_Part> _parts = widget.current.isEmpty
      ? [
          _Part(
            widget.operation.categoryId,
            _input(widget.operation.amountCents.abs()),
            null,
          ),
          _Part(null, '', null),
        ]
      : [
          for (final s in widget.current)
            _Part(s.categoryId, _input(s.amountCents.abs()), s.note),
        ];
  String? _error;
  var _busy = false;

  static String _input(int cents) =>
      '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    for (final p in _parts) {
      p.amount.dispose();
      p.note.dispose();
    }
    super.dispose();
  }

  /// Signed cents of each part (null when not a valid amount).
  List<int?> get _amounts => [
    for (final p in _parts)
      switch (parseUserAmount(p.amount.text)) {
        final c? when c > 0 => c * _sign,
        _ => null,
      },
  ];

  int get _remaining =>
      widget.operation.amountCents - _amounts.fold(0, (a, b) => a + (b ?? 0));

  Future<void> _save(List<TransactionSplit> parts) async {
    setState(() => (_busy = true, _error = null));
    try {
      final t = await client.transaction.setSplits(
        widget.operation.id!,
        parts,
      );
      if (mounted) Navigator.of(context).pop(t);
    } on Object catch (e) {
      if (mounted) {
        setState(
          () => (
            _busy = false,
            _error = errorText(AppLocalizations.of(context), e),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final amounts = _amounts;
    final valid =
        amounts.every((a) => a != null) &&
        core.isValidSplit(widget.operation.amountCents, [
          for (final a in amounts) a!,
        ]);
    final remaining = _remaining;
    return AlertDialog(
      title: Text(l.splitTitle),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.operation.cleanLabel} · ${context.money(widget.operation.amountCents, currency: widget.currency)}',
                style: theme.textTheme.titleSmall,
              ),
              for (final (i, p) in _parts.indexed) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.splitPartLabel(i + 1),
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                    if (_parts.length > 2)
                      IconButton(
                        tooltip: l.splitRemovePart,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => setState(() => _parts.removeAt(i)),
                      ),
                  ],
                ),
                CategoryFormField(
                  key: ObjectKey(p),
                  categories: widget.categories,
                  initialValue: p.categoryId,
                  label: l.categoryLabel,
                  noneLabel: l.noCategory,
                  onChanged: (v) => p.categoryId = v,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: p.amount,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l.amountLabel,
                          suffixText: widget.currency == 'EUR'
                              ? '€'
                              : widget.currency,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: p.note,
                        maxLength: 200,
                        decoration: InputDecoration(
                          labelText: l.splitNoteLabel,
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(l.splitAddPart),
                  onPressed: _parts.length >= 20
                      ? null
                      : () => setState(
                          () => _parts.add(
                            _Part(
                              null,
                              remaining * _sign > 0
                                  ? _input(remaining.abs())
                                  : '',
                              null,
                            ),
                          ),
                        ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    valid ? Icons.check_circle : Icons.info_outline,
                    size: 18,
                    color: valid ? theme.colorScheme.primary : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      valid
                          ? l.splitBalanced
                          : l.splitRemaining(
                              context.money(
                                remaining,
                                currency: widget.currency,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
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
        if (widget.current.isNotEmpty)
          TextButton(
            onPressed: _busy ? null : () => _save(const []),
            child: Text(l.splitRemove),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _busy || !valid
              ? null
              : () => _save([
                  for (final (i, p) in _parts.indexed)
                    TransactionSplit(
                      transactionId: widget.operation.id!,
                      categoryId: p.categoryId,
                      amountCents: amounts[i]!,
                      note: p.note.text.trim().isEmpty
                          ? null
                          : p.note.text.trim(),
                    ),
                ]),
          child: Text(l.save),
        ),
      ],
    );
  }
}
