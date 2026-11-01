import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../util/format.dart';

/// One operation in a list, the same everywhere (Operations, Budget):
/// checked mark, label, subscription and invoice marks, date and category,
/// amount.
class OperationTile extends StatelessWidget {
  final BankTransaction operation;
  final Category? category;

  /// Realises a subscription: marked with an icon and a word.
  final bool subscription;

  /// Has an invoice: marked with a clip.
  final bool hasInvoice;
  final String currency;

  /// Shown after the category when operations of several accounts are
  /// listed together (Budget).
  final String? accountName;
  final VoidCallback onTap;

  /// Touching the round checks or unchecks the operation (null: shown only).
  final VoidCallback? onToggleCleared;

  /// Starts selecting several operations.
  final VoidCallback? onLongPress;

  /// While selecting: whether this one is selected (null: not selecting).
  final bool? selected;

  const OperationTile({
    super.key,
    required this.operation,
    required this.category,
    required this.subscription,
    required this.hasInvoice,
    required this.currency,
    required this.onTap,
    this.accountName,
    this.onToggleCleared,
    this.onLongPress,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final t = operation;
    final c = category;
    final mark = Icon(
      t.cleared ? Icons.check_circle : Icons.radio_button_unchecked,
      color: t.cleared ? theme.colorScheme.primary : theme.disabledColor,
    );
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      selected: selected ?? false,
      leading: selected != null
          ? Checkbox(value: selected, onChanged: (_) => onTap())
          : onToggleCleared == null
          ? mark
          : IconButton(
              tooltip: t.cleared ? l.uncheckOne : l.checkOne,
              icon: mark,
              onPressed: onToggleCleared,
            ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              t.cleanLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (subscription) ...[
            const SizedBox(width: 6),
            Icon(
              Icons.autorenew,
              size: 16,
              color: theme.colorScheme.primary,
              semanticLabel: l.subscriptionBadge,
            ),
          ],
          if (hasInvoice) ...[
            const SizedBox(width: 6),
            Icon(
              Icons.attach_file,
              size: 16,
              color: theme.colorScheme.secondary,
              semanticLabel: l.invoiceBadge,
            ),
          ],
        ],
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text:
                  '${context.shortDay(t.date)} · ${c == null ? l.toClassify : context.categoryName(c)}'
                  '${accountName == null ? '' : ' · $accountName'}',
              style: c == null
                  ? TextStyle(color: theme.colorScheme.tertiary)
                  : null,
            ),
            if (subscription)
              TextSpan(
                text: ' · ${l.subscriptionBadge}',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
          ],
        ),
      ),
      trailing: Text(
        context.money(t.amountCents, currency: currency),
        style: theme.textTheme.titleSmall?.copyWith(
          fontFamily: 'Manrope',
          color: t.amountCents > 0 ? Colors.green.shade700 : null,
        ),
      ),
    );
  }
}
