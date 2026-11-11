import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../util/offline.dart';

/// Above every page while the server cannot be reached and kept answers
/// are shown (decision 0037): from when, and that nothing can be changed.
class OfflineBanner extends StatelessWidget {
  final Widget child;

  /// Tests replace the app-wide state.
  final ValueNotifier<DateTime?>? since;

  const OfflineBanner({super.key, required this.child, this.since});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<DateTime?>(
    valueListenable: since ?? offlineSince,
    builder: (context, when, _) {
      if (when == null) return child;
      final l = AppLocalizations.of(context);
      final scheme = Theme.of(context).colorScheme;
      final locale = Localizations.localeOf(context).toLanguageTag();
      final text = l.offlineBanner(
        DateFormat.MMMd(locale).add_Hm().format(when),
      );
      return Column(
        children: [
          Material(
            color: scheme.tertiaryContainer,
            child: SafeArea(
              bottom: false,
              child: Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 18,
                        color: scheme.onTertiaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(color: scheme.onTertiaryContainer),
                        ),
                      ),
                    ],
                  ),
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
