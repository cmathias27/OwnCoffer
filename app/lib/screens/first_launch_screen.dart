import 'package:flutter/material.dart';

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

/// While the embedded server starts (a second or two).
class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).startingStandalone),
        ],
      ),
    ),
  );
}
