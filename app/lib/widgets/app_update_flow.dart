import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../util/app_update.dart';
import '../util/app_versions.dart';
import '../util/web_search.dart';

/// The updater of this device; tests give their own.
AppUpdater appUpdater = AppUpdater.platformUpdater();

/// Downloads, checks and installs [version] of this app (decision 0032):
/// the progress, Windows' confirmation before it restarts, and each failure
/// with « Télécharger à la main ».
Future<void> installAppUpdate(
  BuildContext context,
  String version, {
  AppUpdater? updater,
  void Function(Uri uri)? open,
}) async {
  final u = updater ?? appUpdater;
  final l = AppLocalizations.of(context);
  // The progress dialog is on the root navigator, like every dialog.
  final navigator = Navigator.of(context, rootNavigator: true);
  final messenger = ScaffoldMessenger.of(context);
  final progress = ValueNotifier<double?>(null);

  void failed(Object error) {
    if (!context.mounted) return;
    final code = error is AppUpdateException ? error.code : 'install';
    final manual = u.platform == null
        ? null
        : AppVersions.download(version, u.platform!);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.appsInstallFailed),
        content: Text(appUpdateErrorText(l, code)),
        actions: [
          if (manual != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                (open ?? openLink)(manual);
              },
              child: Text(l.appsInstallManual),
            ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          ),
        ],
      ),
    );
  }

  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          key: const Key('app-update-progress'),
          title: Text(l.appsInstallTitle(version)),
          content: ValueListenableBuilder<double?>(
            valueListenable: progress,
            builder: (context, f, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f == null
                      ? l.appsInstallDownloading
                      : l.appsInstallProgress((f * 100).floor()),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: f),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  AppUpdateReady ready;
  try {
    ready = await u.prepare(version, progress: (f) => progress.value = f);
  } catch (e) {
    navigator.pop();
    progress.dispose();
    failed(e);
    return;
  }
  navigator.pop();
  progress.dispose();
  if (!context.mounted) return;

  if (u.restarts) {
    final go = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.appsInstallTitle(version)),
        content: Text(l.appsInstallWindows(version)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            key: const Key('app-update-restart'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.appsInstallRestart),
          ),
        ],
      ),
    );
    if (go != true) return;
  }
  try {
    await u.install(ready);
  } catch (e) {
    failed(e);
    return;
  }
  if (!u.restarts) {
    messenger.showSnackBar(SnackBar(content: Text(l.appsInstallAndroid)));
  }
}

/// Text for an [AppUpdateException] code (decision 0032, point 6).
String appUpdateErrorText(AppLocalizations l, String code) => switch (code) {
  'network' => l.appsInstallErrorNetwork,
  'checksum' => l.appsInstallErrorChecksum,
  'too_large' => l.appsInstallErrorTooLarge,
  'permission' => l.appsInstallErrorPermission,
  'signature' => l.appsInstallErrorSignature,
  'package' || 'version' => l.appsInstallErrorVersion,
  'folder' => l.appsInstallErrorFolder,
  _ => l.appsInstallError,
};
