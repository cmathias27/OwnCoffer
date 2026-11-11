import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../widgets/form_card.dart';

/// First launch of the Windows or Android app: alone on this device
/// (standalone mode, decision 0022) or with an OwnCoffer server.
class FirstLaunchScreen extends StatefulWidget {
  /// This build carries the embedded server.
  final bool standalone;
  final Future<void> Function() onStandalone;
  final Future<void> Function() onServer;

  const FirstLaunchScreen({
    super.key,
    required this.standalone,
    required this.onStandalone,
    required this.onServer,
  });

  @override
  State<FirstLaunchScreen> createState() => _FirstLaunchScreenState();
}

class _FirstLaunchScreenState extends State<FirstLaunchScreen> {
  @override
  void initState() {
    super.initState();
    // Nothing to choose without the embedded server.
    if (!widget.standalone) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onServer());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget choice(
      IconData icon,
      String title,
      String help,
      Future<void> Function() onTap, {
      bool primary = false,
    }) => Card(
      color: primary ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(help, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
    return FormCard(
      title: l.firstLaunchTitle,
      intro: l.firstLaunchIntro,
      children: [
        choice(
          Icons.smartphone_outlined,
          l.firstLaunchStandalone,
          l.firstLaunchStandaloneHelp,
          widget.onStandalone,
          primary: true,
        ),
        const SizedBox(height: 12),
        choice(
          Icons.dns_outlined,
          l.firstLaunchServer,
          l.firstLaunchServerHelp,
          widget.onServer,
        ),
      ],
    );
  }
}

/// While the embedded server starts (a second or two); if it fails, the
/// reason, to retry or go back to the first launch choice.
class StartingScreen extends StatelessWidget {
  /// What failed (step and error), shown so it can be reported.
  final String? error;
  final Future<void> Function()? onRetry;
  final Future<void> Function()? onBack;

  /// The database's key is gone (decision 0033): start again empty, the
  /// file kept aside, then restore a backup.
  final Future<void> Function()? onSetAside;

  const StartingScreen({
    super.key,
    this.error,
    this.onRetry,
    this.onBack,
    this.onSetAside,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final error = this.error;
    if (error == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l.startingStandalone),
            ],
          ),
        ),
      );
    }
    final onSetAside = this.onSetAside;
    return FormCard(
      title: l.standaloneStartFailed,
      intro: onSetAside == null
          ? l.standaloneStartFailedHelp
          : l.standaloneKeyLost,
      children: [
        SelectableText(
          error,
          key: const Key('standalone-error'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.copy_outlined),
            label: Text(l.copy),
            onPressed: () => Clipboard.setData(ClipboardData(text: error)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onBack != null)
              TextButton(onPressed: onBack, child: Text(l.back)),
            const SizedBox(width: 8),
            if (onRetry != null)
              FilledButton(onPressed: onRetry, child: Text(l.retry)),
          ],
        ),
        if (onSetAside != null) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              key: const Key('standalone-set-aside'),
              onPressed: onSetAside,
              child: Text(l.standaloneSetAside),
            ),
          ),
        ],
      ],
    );
  }
}
