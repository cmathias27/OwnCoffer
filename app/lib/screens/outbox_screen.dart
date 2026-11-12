import 'package:flutter/material.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';
import '../util/outbox.dart';

/// « À synchroniser » (decision 0038): the operations entered offline, still
/// waiting or refused by the server. Nothing is lost in silence: a refused
/// one stays here until it is sent again or dropped.
class OutboxScreen extends StatelessWidget {
  /// Tests replace the app-wide outbox.
  final Outbox? pending;

  const OutboxScreen({super.key, this.pending});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final box = pending ?? outbox;
    return Scaffold(
      appBar: AppBar(title: Text(l.outboxTitle)),
      body: ListenableBuilder(
        listenable: box,
        builder: (context, _) {
          final entries = box.entries;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.outboxIntro),
              const SizedBox(height: 8),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text(l.outboxEmpty)),
                ),
              if (box.waiting > 0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: Text(l.outboxSendNow),
                    onPressed: box.flush,
                  ),
                ),
              for (final e in entries) _EntryTile(entry: e, box: box),
            ],
          );
        },
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  final PendingEntry entry;
  final Outbox box;

  const _EntryTile({required this.entry, required this.box});

  Future<void> _drop(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l.outboxDropConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.outboxDrop),
          ),
        ],
      ),
    );
    if (sure == true) await box.drop(entry);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final error = entry.error;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              leading: Icon(
                error == null ? Icons.schedule_outlined : Icons.error_outline,
                color: error == null ? null : scheme.error,
              ),
              title: Text(
                entry.label.trim().isEmpty ? '—' : entry.label,
              ),
              subtitle: Text(
                [
                  '${entry.accountName} · ${context.day(entry.date)}',
                  error == null
                      ? l.outboxStateWaiting
                      : l.outboxStateRefused(serverErrorText(l, error)),
                ].join('\n'),
                style: error == null ? null : TextStyle(color: scheme.error),
              ),
              isThreeLine: true,
              trailing: Text(context.money(entry.amountCents)),
            ),
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => _drop(context),
                  child: Text(l.outboxDrop),
                ),
                if (error != null)
                  FilledButton.tonal(
                    onPressed: () => box.retry(entry),
                    child: Text(l.outboxRetry),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Leaves this server, after [confirmDropOutbox].
Future<void> changeServerAfterOutbox(BuildContext context) async {
  if (await confirmDropOutbox(context)) await changeServer();
}

/// Signs out with [signOut], after [confirmDropOutbox].
Future<void> signOutAfterOutbox(
  BuildContext context,
  Future<void> Function() signOut,
) async {
  if (await confirmDropOutbox(context)) await signOut();
}

/// Before the user leaves this server or account: entries not sent yet
/// would be lost, so they are named and the user decides.
Future<bool> confirmDropOutbox(BuildContext context, {Outbox? pending}) async {
  final box = pending ?? outbox;
  final count = await box.kept();
  if (count == 0) return true;
  if (!context.mounted) return false;
  final l = AppLocalizations.of(context);
  final sure = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.outboxLeaveTitle),
      content: Text(l.outboxLeaveBody(count)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l.outboxLeaveConfirm),
        ),
      ],
    ),
  );
  if (sure != true) return false;
  await box.clear();
  return true;
}
