import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../screens/getting_started_screen.dart';
import '../state/getting_started.dart';
import '../state/pepite.dart';
import '../state/pepite_advice.dart';
import '../state/pepite_messages.dart';
import 'pepite.dart';

/// « Le savais-tu ? » (decision 0028, point 12): the tip of the open page,
/// on top of it, until « Compris » or « En savoir plus » (its help page).
class PepiteTipBanner extends StatelessWidget {
  final HelpTopic topic;

  /// Tests give their own; the app's otherwise.
  final PepiteAdvice? controller;
  final Pepite? pepiteController;

  /// Opens the help page (tests check it).
  final void Function(BuildContext context, HelpTopic topic)? openHelp;

  const PepiteTipBanner({
    super.key,
    required this.topic,
    this.controller,
    this.pepiteController,
    this.openHelp,
  });

  @override
  Widget build(BuildContext context) {
    final advice = controller ?? pepiteAdvice;
    final mascot = pepiteController ?? pepite;
    advice.prepare(Localizations.localeOf(context).languageCode);
    return ListenableBuilder(
      listenable: Listenable.merge([advice, mascot]),
      builder: (context, _) {
        final tip = advice.tipFor(topic);
        if (tip == null) return const SizedBox.shrink();
        final l = AppLocalizations.of(context);
        final scheme = Theme.of(context).colorScheme;
        final color = scheme.onSecondaryContainer;
        return Material(
          color: scheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (mascot.enabled) ...[
                      const PepiteImage(PepitePose.happy, size: 40),
                      const SizedBox(width: 8),
                    ] else ...[
                      Icon(Icons.lightbulb_outline, color: color),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${l.pepiteTipTitle} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: tip.text),
                          ],
                        ),
                        style: TextStyle(color: color),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Wrap(
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () {
                          advice.seen(tip);
                          (openHelp ?? _help)(context, tip.topic);
                        },
                        child: Text(l.pepiteTipMore),
                      ),
                      FilledButton.tonal(
                        onPressed: () => advice.seen(tip),
                        child: Text(l.pepiteTipGotIt),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _help(BuildContext context, HelpTopic topic) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => HelpPage(topic: topic)),
      );
}

/// The card of « Bien démarrer » on the home page, while steps are left:
/// « Voir la liste » or « Pas maintenant », which never comes back (the
/// list stays in Pépite's page).
class PepiteStartCard extends StatefulWidget {
  final GroupMembership membership;

  /// An account goes below zero: a sober sentence.
  final bool overdrawn;
  final VoidCallback onOpen;

  /// Tests give their own; the server's, the device's and the app's
  /// otherwise.
  final Future<PepiteStart> Function(int groupId)? load;
  final Future<StartDevice> Function()? device;
  final PepiteAdvice? controller;
  final Pepite? pepiteController;

  const PepiteStartCard({
    super.key,
    required this.membership,
    required this.overdrawn,
    required this.onOpen,
    this.load,
    this.device,
    this.controller,
    this.pepiteController,
  });

  @override
  State<PepiteStartCard> createState() => _PepiteStartCardState();
}

class _PepiteStartCardState extends State<PepiteStartCard> {
  Future<List<StartStep>>? _steps;

  PepiteAdvice get _advice => widget.controller ?? pepiteAdvice;
  Pepite get _pepite => widget.pepiteController ?? pepite;

  @override
  void initState() {
    super.initState();
    _steps = _fetch();
  }

  Future<List<StartStep>> _fetch() async {
    final server = await (widget.load ?? client.pepiteAdvice.start)(
      widget.membership.group.id!,
    );
    return startSteps(server, await (widget.device ?? startDevice)());
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([_advice, _pepite]),
    builder: (context, _) {
      if (!_advice.tipsOn || _advice.startHidden) {
        return const SizedBox.shrink();
      }
      return FutureBuilder(
        future: _steps,
        builder: (context, snap) {
          final steps = snap.data;
          if (steps == null) return const SizedBox.shrink();
          final done = steps.where((s) => s.done).length;
          if (done == steps.length) return const SizedBox.shrink();
          final l = AppLocalizations.of(context);
          final theme = Theme.of(context);
          final text = widget.overdrawn || !_pepite.enabled
              ? l.startCardSober(done, steps.length)
              : l.startCard(done, steps.length);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_pepite.enabled && !widget.overdrawn) ...[
                      const PepiteImage(PepitePose.wave, size: 56),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(text, style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: done / steps.length),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              FilledButton.icon(
                                icon: const Icon(Icons.checklist),
                                label: Text(l.startSee),
                                onPressed: widget.onOpen,
                              ),
                              TextButton(
                                onPressed: () async {
                                  final messenger = ScaffoldMessenger.of(
                                    context,
                                  );
                                  await _advice.hideStart();
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(l.startNotNowReply),
                                    ),
                                  );
                                },
                                child: Text(l.startNotNow),
                              ),
                            ],
                          ),
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
    },
  );
}
