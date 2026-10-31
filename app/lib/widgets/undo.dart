import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';

/// How long the "Undo" bar stays on screen.
const undoDuration = Duration(seconds: 10);

/// Tells that an action was done, with an "Undo" button. [undo] puts things
/// back; [after] then refreshes what is shown. The messenger is passed in
/// (not looked up later) so it still works once a sheet or page is closed.
///
/// The bar floats and goes away by itself after [undoDuration]: since
/// Flutter 3.38 a bar with an action stays until closed unless `persist` is
/// false, and it then hid the buttons at the bottom of the screen.
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
        duration: undoDuration,
        persist: false,
        behavior: SnackBarBehavior.floating,
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
