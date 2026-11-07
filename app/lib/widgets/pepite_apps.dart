import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../screens/apps_screen.dart';
import '../state/pepite.dart';
import '../state/pepite_messages.dart';
import 'pepite.dart';

/// A browser on an Android phone, told by the browser itself: nothing is
/// sent to know it.
bool get onPhoneBrowser =>
    kIsWeb && defaultTargetPlatform == TargetPlatform.android;

/// Pépite invites to install the apps (decision 0027, point 8): the card of
/// the home page, in a computer's browser. A phone's browser shows
/// [PepiteAppsBanner] instead.
class PepiteAppsCard extends StatelessWidget {
  /// Tests give their own; the app's otherwise.
  final Pepite? controller;

  /// Tests say where the page is shown; the browser says otherwise.
  final bool? phone;

  const PepiteAppsCard({super.key, this.controller, this.phone});

  Pepite get _p => controller ?? pepite;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _p,
    builder: (context, _) {
      if ((phone ?? onPhoneBrowser) || !_p.appsCardDue) {
        return const SizedBox.shrink();
      }
      unawaited(_p.appsCardShown());
      final l = AppLocalizations.of(context);
      final theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PepiteImage(PepitePose.wave, size: 64),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.pepiteAppsCard, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      _Actions(_p),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// The same invitation as a banner, on top of every page of a phone's
/// browser (only Android: there is no iPhone app).
class PepiteAppsBanner extends StatelessWidget {
  final Pepite? controller;
  final bool? phone;

  const PepiteAppsBanner({super.key, this.controller, this.phone});

  Pepite get _p => controller ?? pepite;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _p,
    builder: (context, _) {
      if (!(phone ?? onPhoneBrowser) || !_p.appsCardDue) {
        return const SizedBox.shrink();
      }
      unawaited(_p.appsCardShown());
      final l = AppLocalizations.of(context);
      final scheme = Theme.of(context).colorScheme;
      return Material(
        color: scheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PepiteImage(PepitePose.wave, size: 40),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.pepiteAppsBanner,
                      style: TextStyle(color: scheme.onSecondaryContainer),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _Actions(_p, dense: true),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// « Voir les applications », « Plus tard », « Ne plus proposer ».
class _Actions extends StatelessWidget {
  final Pepite p;
  final bool dense;

  const _Actions(this.p, {this.dense = false});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Future<void> reply(Future<void> Function() action, String text) async {
      final messenger = ScaffoldMessenger.of(context);
      await action();
      messenger.showSnackBar(SnackBar(content: Text(text)));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      alignment: dense ? WrapAlignment.end : WrapAlignment.start,
      children: [
        FilledButton.icon(
          icon: const Icon(Icons.install_mobile),
          label: Text(l.pepiteAppsSee),
          onPressed: () => openApps(context),
        ),
        TextButton(
          onPressed: () => reply(p.appsLater, l.pepiteAppsLaterReply),
          child: Text(l.pepiteLater),
        ),
        TextButton(
          onPressed: () => reply(p.appsNever, l.pepiteAppsNeverReply),
          child: Text(l.pepiteAppsNever),
        ),
      ],
    );
  }
}
