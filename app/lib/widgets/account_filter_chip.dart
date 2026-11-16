import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';

/// Chip opening a dialog to select multiple accounts for budget / analysis (decision 0052).
class AccountFilterChip extends StatelessWidget {
  final List<Account> accounts;
  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onChanged;

  const AccountFilterChip({
    super.key,
    required this.accounts,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final String label;
    final bool hasSelection =
        selectedIds.isNotEmpty && selectedIds.length < accounts.length;

    if (!hasSelection ||
        selectedIds.isEmpty ||
        selectedIds.length == accounts.length) {
      label = l.accountFilterAll;
    } else if (selectedIds.length == 1) {
      final first = accounts
          .where((a) => a.id == selectedIds.first)
          .firstOrNull;
      label = first?.name ?? l.accountFilterMultiple(1);
    } else {
      label = l.accountFilterMultiple(selectedIds.length);
    }

    return FilterChip(
      avatar: const Icon(Icons.account_balance_outlined, size: 18),
      label: Text(label),
      selected: hasSelection,
      showCheckmark: false,
      onSelected: (_) => _openDialog(context),
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final initial = selectedIds.isEmpty
        ? {for (final a in accounts) a.id!}
        : Set<int>.from(selectedIds);

    final res = await showDialog<Set<int>>(
      context: context,
      builder: (ctx) {
        var current = Set<int>.from(initial);
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(l.accountFilterDialogTitle),
              content: SizedBox(
                width: 380,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                current = {for (final a in accounts) a.id!};
                              });
                            },
                            child: Text(l.accountFilterSelectAll),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                current.clear();
                              });
                            },
                            child: Text(l.accountFilterSelectNone),
                          ),
                        ],
                      ),
                      const Divider(),
                      for (final a in accounts)
                        CheckboxListTile(
                          value: current.contains(a.id),
                          title: Text(a.name),
                          subtitle: a.bank != null ? Text(a.bank!) : null,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                current.add(a.id!);
                              } else {
                                current.remove(a.id);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(l.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(current),
                  child: Text(l.accountFilterApply),
                ),
              ],
            );
          },
        );
      },
    );

    if (res != null) {
      if (res.isEmpty || res.length == accounts.length) {
        onChanged({});
      } else {
        onChanged(res);
      }
    }
  }
}
