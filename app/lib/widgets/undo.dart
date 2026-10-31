import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';

/// Tells that an action was done, with an "Undo" button. [undo] puts things
/// back; [after] then refreshes what is shown. The messenger is passed in
/// (not looked up later) so it still works once a sheet or page is closed.
void showUndo(
  ScaffoldMessengerState messenger,
  AppLocalizations l,
  String message,
  Future<void> Function() undo, {
  VoidCallback? after,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 8),
        action: SnackBarAction(
          label: l.undo,
          onPressed: () async {
            try {
              await undo();
              messenger.showSnackBar(SnackBar(content: Text(l.undoDone)));
            } on Object catch (e) {
              messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
            }
            after?.call();
          },
        ),
      ),
    );
}
