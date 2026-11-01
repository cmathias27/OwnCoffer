import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';

/// "Read with the AI" for a stored document (receipt, invoice, loan
/// document): only with the user's own assistant on and a model that reads
/// images; with an online provider, the user first agrees to send it. What
/// is read becomes proposals in "Mon conseiller"; nothing changes here.
Future<void> readWithAi(
  BuildContext context, {
  required String mimeType,
  required Future<AiReply> Function() read,
}) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final AiStatus status;
  try {
    status = await client.ai.status();
  } on Object catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return;
  }
  final provider = status.providers
      .where((p) => p.id == status.providerId)
      .firstOrNull;
  if (!status.enabled || provider == null || !provider.vision) {
    messenger.showSnackBar(SnackBar(content: Text(l.aiReadNotReady)));
    return;
  }
  if (mimeType == 'application/pdf' && provider.kind != 'anthropic') {
    messenger.showSnackBar(SnackBar(content: Text(l.aiReadNoPdf)));
    return;
  }
  if (!context.mounted) return;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.aiReadTitle),
      content: Text(
        provider.kind == 'ollama'
            ? l.aiReadLocal(provider.name, status.model ?? '')
            : l.aiReadExternal(provider.name, status.model ?? ''),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.aiReadGo),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  messenger.showSnackBar(SnackBar(content: Text(l.aiReadRunning)));
  try {
    final reply = await read();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            reply.proposals.isEmpty
                ? l.aiReadNothingNew
                : l.aiReadDone(reply.proposals.length),
          ),
        ),
      );
  } on Object catch (e) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(errorText(l, e))));
  }
}
