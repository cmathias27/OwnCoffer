import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../screens/pepite_ritual_screen.dart';
import '../screens/pepite_screen.dart';
import '../state/pepite.dart';
import '../state/pepite_messages.dart';

/// A drawing of Pépite.
class PepiteImage extends StatelessWidget {
  final PepitePose pose;
  final double size;

  const PepiteImage(this.pose, {super.key, this.size = 96});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/pepite/pepite_${pose.name}.svg',
    width: size,
    height: size,
    excludeFromSemantics: true,
  );
}

/// The seeds of the reserve, as a small chip.
class PepiteSeeds extends StatelessWidget {
  final int seeds;

  const PepiteSeeds(this.seeds, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9A04B).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grain, size: 16, color: scheme.onSurface),
          const SizedBox(width: 4),
          Text(AppLocalizations.of(context).pepiteSeeds(seeds)),
        ],
      ),
    );
  }
}

/// Pépite on the home page: the reminder of the week, or the
/// congratulations once it is done. Hidden when turned off, when the
/// server cannot say where the user stands, or until tomorrow after
/// "Plus tard".
class PepiteCard extends StatelessWidget {
  /// An account goes below zero: Pépite stays sober.
  final bool overdrawn;

  /// Opens a page of the app for a step of the ritual.
  final ValueChanged<PepiteStep> onStep;

  /// Tests give their own; the app's otherwise.
  final Pepite? controller;

  const PepiteCard({
    super.key,
    required this.overdrawn,
    required this.onStep,
    this.controller,
  });

  Pepite get _p => controller ?? pepite;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _p,
    builder: (context, _) {
      final s = _p.status;
      if (!_p.enabled || s == null) return const SizedBox.shrink();
      final line = pepiteLine(
        AppLocalizations.of(context),
        s,
        overdrawn: overdrawn,
        today: DateTime.now(),
      );
      if (line.remind && _p.snoozed) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _card(context, s, line),
      );
    },
  );

  Widget _card(BuildContext context, PepiteStatus s, PepiteLine line) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final done = _p.steps.where((step) => step != PepiteStep.celebrate).length;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PepiteImage(line.pose, size: 84),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(line.text, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PepiteSeeds(s.seeds),
                      Text(
                        l.pepiteWeeks(s.weeks),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (line.remind)
                        FilledButton.icon(
                          icon: const Icon(Icons.checklist),
                          label: Text(
                            done == 0 ? l.pepiteStart : l.pepiteContinue(done),
                          ),
                          onPressed: () => _ritual(context),
                        ),
                      if (line.remind)
                        TextButton(
                          onPressed: () => _later(context),
                          child: Text(l.pepiteLater),
                        ),
                      if (!line.remind)
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const PepiteScreen(),
                            ),
                          ),
                          child: Text(l.pepiteReserve),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ritual(BuildContext context) async {
    final step = await Navigator.of(context).push<PepiteStep>(
      MaterialPageRoute(builder: (_) => const PepiteRitualScreen()),
    );
    if (step != null) onStep(step);
  }

  Future<void> _later(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final text = AppLocalizations.of(context).pepiteLaterReply;
    await _p.later();
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }
}

/// The fourth step: the server counts the week, then Pépite cheers; in a
/// browser, she ends with a word about the apps (decision 0027, point 8).
/// True when the user then asked to see them.
Future<bool> celebrateWithPepite(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final PepiteStatus s;
  try {
    s = await pepite.celebrate();
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
    return false;
  }
  if (!context.mounted) return false;
  final apps = pepite.invitesApps;
  final see = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const PepiteImage(PepitePose.cheer, size: 120),
      title: Text(l.pepiteCelebrateTitle, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.pepiteEarned(s.earnedSeeds), textAlign: TextAlign.center),
          for (final code in s.newBadges) ...[
            const SizedBox(height: 8),
            Text(
              l.pepiteNewBadge(pepiteBadgeText(l, code).$1),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
          const SizedBox(height: 12),
          PepiteSeeds(s.seeds),
          if (apps) ...[
            const SizedBox(height: 12),
            Text(l.pepiteAppsRitualEnd, textAlign: TextAlign.center),
          ],
        ],
      ),
      actions: [
        if (apps)
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.pepiteAppsSee),
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.pepiteThanks),
        ),
      ],
    ),
  );
  return see ?? false;
}
