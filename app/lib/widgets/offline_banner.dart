import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../util/offline.dart';
import '../util/outbox.dart';

/// Above every page while the server cannot be reached and kept answers
/// are shown (decision 0037): from when, and that only new operations can
/// be entered. Below it, the operations entered offline that are still to
/// be sent or were refused (decision 0038), which open « À synchroniser ».
class OfflineBanner extends StatelessWidget {
  final Widget child;

  /// Tests replace the app-wide state.
  final ValueNotifier<DateTime?>? since;
  final Outbox? pending;

  /// Opens « À synchroniser » (the banner is above the pages' navigator).
  final VoidCallback? onOpenOutbox;

  const OfflineBanner({
    super.key,
    required this.child,
    this.since,
    this.pending,
    this.onOpenOutbox,
  });

  @override
  Widget build(BuildContext context) {
    final offline = since ?? offlineSince;
    final box = pending ?? outbox;
    return ListenableBuilder(
      listenable: Listenable.merge([offline, box]),
      builder: (context, _) {
        final when = offline.value;
        final waiting = box.waiting;
        final refused = box.entries.length - waiting;
        if (when == null && waiting == 0 && refused == 0) return child;
        final l = AppLocalizations.of(context);
        final scheme = Theme.of(context).colorScheme;
        final locale = Localizations.localeOf(context).toLanguageTag();
        return Column(
          children: [
            Material(
              color: refused > 0
                  ? scheme.errorContainer
                  : scheme.tertiaryContainer,
              child: SafeArea(
                bottom: false,
                child: Semantics(
                  liveRegion: true,
                  child: Column(
                    children: [
                      if (when != null)
                        _Line(
                          icon: Icons.cloud_off_outlined,
                          text: l.offlineBanner(
                            DateFormat.MMMd(locale).add_Hm().format(when),
                          ),
                          color: refused > 0
                              ? scheme.onErrorContainer
                              : scheme.onTertiaryContainer,
                        ),
                      if (waiting > 0 || refused > 0)
                        _Line(
                          icon: refused > 0
                              ? Icons.sync_problem_outlined
                              : Icons.cloud_upload_outlined,
                          text: [
                            if (waiting > 0) l.outboxWaiting(waiting),
                            if (refused > 0) l.outboxRefused(refused),
                          ].join(' · '),
                          color: refused > 0
                              ? scheme.onErrorContainer
                              : scheme.onTertiaryContainer,
                          onTap: onOpenOutbox,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Line extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const _Line({
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: color)),
          ),
          if (onTap != null) Icon(Icons.chevron_right, size: 18, color: color),
        ],
      ),
    ),
  );
}
