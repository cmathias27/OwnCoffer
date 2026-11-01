import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// Operations moved to the trash: restore them, or delete them for good.
class TrashScreen extends StatefulWidget {
  final GroupMembership membership;
  final List<Account> accounts;
  const TrashScreen({
    super.key,
    required this.membership,
    required this.accounts,
  });

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  List<BankTransaction>? _items;
  String? _error;
  var _changed = false;

  bool get _canWrite => widget.membership.role != MemberRole.reader;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await client.transaction.trashed(
        widget.membership.group.id!,
      );
      if (mounted) setState(() => (_items = items, _error = null));
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _run(Future<Object?> Function() call, String done) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await call();
      _changed = true;
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    }
    await _load();
  }

  Future<bool> _confirm(String text) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) {
          final l = AppLocalizations.of(context);
          return AlertDialog(
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l.trashDeleteForGood),
              ),
            ],
          );
        },
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = _items;
    final names = {for (final a in widget.accounts) a.id: a.name};
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_changed);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.trashTitle),
          actions: [
            if (_canWrite && (items?.isNotEmpty ?? false))
              TextButton.icon(
                icon: const Icon(Icons.delete_forever_outlined),
                label: Text(l.trashEmpty),
                onPressed: () async {
                  if (!await _confirm(l.trashEmptyConfirm(items!.length))) {
                    return;
                  }
                  await _run(
                    () => client.transaction.emptyTrash(
                      widget.membership.group.id!,
                    ),
                    l.trashEmptied,
                  );
                },
              ),
          ],
        ),
        body: _error != null
            ? Center(child: Text(_error!))
            : items == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                children: [
                  Text(l.trashHelp),
                  if (items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(child: Text(l.trashNone)),
                    ),
                  for (final t in items)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(t.cleanLabel),
                      subtitle: Text(
                        [
                          context.day(t.date),
                          ?names[t.accountId],
                          if (t.deletedAt != null)
                            l.trashSince(context.day(t.deletedAt!)),
                        ].join(' · '),
                      ),
                      trailing: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(context.money(t.amountCents)),
                          if (_canWrite) ...[
                            IconButton(
                              tooltip: l.trashRestore,
                              icon: const Icon(Icons.restore),
                              onPressed: () => _run(
                                () => client.transaction.restore(t.id!),
                                l.trashRestored,
                              ),
                            ),
                            IconButton(
                              tooltip: l.trashDeleteForGood,
                              icon: const Icon(Icons.delete_forever_outlined),
                              onPressed: () async {
                                if (!await _confirm(
                                  l.trashDeleteConfirm(t.cleanLabel),
                                )) {
                                  return;
                                }
                                await _run(
                                  () => client.transaction.purge(t.id!),
                                  l.trashDeleted,
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
