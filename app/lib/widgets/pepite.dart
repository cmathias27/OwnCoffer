import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../screens/apps_screen.dart';
import '../screens/pepite_ritual_screen.dart';
import '../screens/pepite_screen.dart';
import '../state/getting_started.dart';
import '../state/pepite.dart';
import '../state/pepite_advice.dart';
import '../state/pepite_messages.dart';
import '../state/start_device.dart';
import 'pepite_apps.dart';

/// A drawing of Pépite, wearing the accessory bought in the shop
/// (decision 0028, point 4): [wear], or else the one put on.
class PepiteImage extends StatelessWidget {
  final PepitePose pose;
  final double size;

  /// An accessory to show instead of the one worn (the shop's preview).
  final String? wear;

  /// Tests give their own; the app's otherwise.
  final Pepite? controller;

  const PepiteImage(
    this.pose, {
    super.key,
    this.size = 96,
    this.wear,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final p = controller ?? pepite;
    return ListenableBuilder(
      listenable: p,
      builder: (context, _) {
        final accessory = wear ?? p.accessory;
        final body = SvgPicture.asset(
          'assets/pepite/pepite_${pose.name}.svg',
          width: size,
          height: size,
          excludeFromSemantics: true,
        );
        if (accessory == null) return body;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              body,
              SvgPicture.asset(
                'assets/pepite/pepite_wear_$accessory.svg',
                width: size,
                height: size,
                excludeFromSemantics: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A burrow item of the shop (decision 0028, point 4).
class PepiteItemImage extends StatelessWidget {
  final String code;
  final double size;

  const PepiteItemImage(this.code, {super.key, this.size = 64});

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/pepite/pepite_item_$code.svg',
    width: size,
    height: size,
    excludeFromSemantics: true,
  );
}

/// Pépite at home: the burrow items on show around it.
class PepiteBurrow extends StatelessWidget {
  final PepitePose pose;
  final double size;

  /// An accessory tried on in the shop, instead of the one worn.
  final String? wear;
  final Pepite? controller;

  const PepiteBurrow(
    this.pose, {
    super.key,
    this.size = 140,
    this.wear,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final p = controller ?? pepite;
    return ListenableBuilder(
      listenable: p,
      builder: (context, _) {
        final items = p.burrow;
        final image = PepiteImage(pose, size: size, wear: wear, controller: p);
        if (items.isEmpty) return image;
        final small = size * 0.45;
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 4,
          children: [
            for (final code in items.take((items.length / 2).ceil()))
              PepiteItemImage(code, size: small),
            image,
            for (final code in items.skip((items.length / 2).ceil()))
              PepiteItemImage(code, size: small),
          ],
        );
      },
    );
  }
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
          Flexible(
            child: Text(AppLocalizations.of(context).pepiteSeeds(seeds)),
          ),
        ],
      ),
    );
  }
}

/// Pépite on the home page (decision 0026 and 0028): the single visual card
/// uniting the reminder of the week, « Le savais-tu ? » advice, and
/// « Bien démarrer » progress. Hidden when turned off, when the server cannot
/// say where the user stands, or when snoozed.
class PepiteCard extends StatefulWidget {
  final GroupMembership? membership;

  /// An account goes below zero: Pépite stays sober.
  final bool overdrawn;

  /// Opens a page of the app for a step of the ritual.
  final ValueChanged<PepiteStep> onStep;

  /// Opens « Bien démarrer » list.
  final VoidCallback? onOpenStart;

  /// Tests give their own; the app's otherwise.
  final Pepite? controller;
  final PepiteAdvice? adviceController;
  final Future<PepiteStart> Function(int groupId)? loadStart;
  final Future<StartDevice> Function()? device;
  final void Function(BuildContext context, HelpTopic topic)? openHelp;
  final bool? phone;

  const PepiteCard({
    super.key,
    this.membership,
    required this.overdrawn,
    required this.onStep,
    this.onOpenStart,
    this.controller,
    this.adviceController,
    this.loadStart,
    this.device,
    this.openHelp,
    this.phone,
  });

  @override
  State<PepiteCard> createState() => _PepiteCardState();
}

class _PepiteCardState extends State<PepiteCard> {
  Future<List<StartStep>>? _startSteps;

  Pepite get _p => widget.controller ?? pepite;
  PepiteAdvice get _advice => widget.adviceController ?? pepiteAdvice;

  @override
  void initState() {
    super.initState();
    _loadStart();
  }

  @override
  void didUpdateWidget(PepiteCard old) {
    super.didUpdateWidget(old);
    if (old.membership?.group.id != widget.membership?.group.id) {
      _loadStart();
    }
  }

  void _loadStart() {
    final m = widget.membership;
    if (m == null || m.group.id == null) {
      _startSteps = null;
      return;
    }
    _startSteps = _fetchStart(m.group.id!);
  }

  Future<List<StartStep>> _fetchStart(int groupId) async {
    final server = await (widget.loadStart ?? client.pepiteAdvice.start)(
      groupId,
    );
    return startSteps(server, await (widget.device ?? startDevice)());
  }

  @override
  Widget build(BuildContext context) {
    _advice.prepare(Localizations.localeOf(context).languageCode);
    return ListenableBuilder(
      listenable: Listenable.merge([_p, _advice]),
      builder: (context, _) {
        final s = _p.status;
        if (!_p.enabled || s == null) return const SizedBox.shrink();
        final line = pepiteLine(
          AppLocalizations.of(context),
          s,
          overdrawn: widget.overdrawn,
          today: DateTime.now(),
        );
        final showRitual = !(line.remind && _p.snoozed);
        final showApps = !((widget.phone ?? onPhoneBrowser)) && _p.appsCardDue;
        if (showApps) {
          unawaited(_p.appsCardShown());
        }
        final tip = _advice.tipsOn ? _advice.tipFor(HelpTopic.home) : null;
        final showTip = tip != null;

        final showStartEligible =
            widget.membership != null &&
            _advice.tipsOn &&
            !_advice.startHidden &&
            _startSteps != null;

        if (showStartEligible) {
          return FutureBuilder<List<StartStep>>(
            future: _startSteps,
            builder: (context, snap) {
              final steps = snap.data;
              final done = steps?.where((st) => st.done).length ?? 0;
              final showStart = steps != null && done < steps.length;
              if (!showRitual && !showApps && !showTip && !showStart) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _card(
                  context,
                  s,
                  line,
                  showRitual: showRitual,
                  showApps: showApps,
                  tip: tip,
                  startSteps: showStart ? steps : null,
                  startDone: done,
                ),
              );
            },
          );
        }

        if (!showRitual && !showApps && !showTip) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _card(
            context,
            s,
            line,
            showRitual: showRitual,
            showApps: showApps,
            tip: tip,
            startSteps: null,
            startDone: 0,
          ),
        );
      },
    );
  }

  Widget _card(
    BuildContext context,
    PepiteStatus s,
    PepiteLine line, {
    required bool showRitual,
    required bool showApps,
    required PepiteTip? tip,
    required List<StartStep>? startSteps,
    required int startDone,
  }) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final done = _p.steps.where((step) => step != PepiteStep.celebrate).length;
    final pose = showRitual ? line.pose : PepitePose.wave;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PepiteImage(pose, size: 84),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showRitual) ...[
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
                              done == 0
                                  ? l.pepiteStart
                                  : l.pepiteContinue(done),
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
                  if (showApps) ...[
                    if (showRitual) const SizedBox(height: 12),
                    _buildAppsSection(context, l, theme),
                  ],
                  if (tip != null) ...[
                    if (showRitual || showApps) const SizedBox(height: 12),
                    _buildTipSection(context, l, theme, tip),
                  ],
                  if (startSteps != null) ...[
                    if (showRitual || showApps || tip != null)
                      const SizedBox(height: 12),
                    _buildStartSection(
                      context,
                      l,
                      theme,
                      startSteps,
                      startDone,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipSection(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
    PepiteTip tip,
  ) {
    final color = theme.colorScheme.onSecondaryContainer;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${l.pepiteTipTitle} ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: tip.text),
                    ],
                  ),
                  style: TextStyle(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () {
                    _advice.seen(tip);
                    (widget.openHelp ?? _help)(context, tip.topic);
                  },
                  child: Text(l.pepiteTipMore),
                ),
                FilledButton.tonal(
                  onPressed: () => _advice.seen(tip),
                  child: Text(l.pepiteTipGotIt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartSection(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
    List<StartStep> steps,
    int done,
  ) {
    final text = widget.overdrawn
        ? l.startCardSober(done, steps.length)
        : l.startCard(done, steps.length);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: done / steps.length),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: widget.onOpenStart,
                child: Text(l.startSee),
              ),
              TextButton(
                onPressed: () async {
                  await _advice.hideStart();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.startNotNowReply)),
                    );
                  }
                },
                child: Text(l.startNotNow),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppsSection(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
  ) {
    Future<void> reply(Future<void> Function() action, String text) async {
      final messenger = ScaffoldMessenger.of(context);
      await action();
      messenger.showSnackBar(SnackBar(content: Text(text)));
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.pepiteAppsCard, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.install_mobile),
                label: Text(l.pepiteAppsSee),
                onPressed: () => openApps(context),
              ),
              TextButton(
                onPressed: () => reply(_p.appsLater, l.pepiteAppsLaterReply),
                child: Text(l.pepiteLater),
              ),
              TextButton(
                onPressed: () => reply(_p.appsNever, l.pepiteAppsNeverReply),
                child: Text(l.pepiteAppsNever),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _help(BuildContext context, HelpTopic topic) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => HelpPage(topic: topic)),
      );

  Future<void> _ritual(BuildContext context) async {
    final step = await Navigator.of(context).push<PepiteStep>(
      MaterialPageRoute(builder: (_) => const PepiteRitualScreen()),
    );
    if (step != null) widget.onStep(step);
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
  return _cheerDialog(
    context,
    seeds: s.earnedSeeds,
    badges: s.newBadges,
    reserve: s.seeds,
  );
}

/// Pépite cheers about what she noticed by herself (decision 0029): the
/// week completed, in the dialog of the ritual; badges alone, in a short
/// message. True when the user then asked to see the apps.
Future<bool> showPepiteCheer(BuildContext context, PepiteCheer cheer) async {
  final l = AppLocalizations.of(context);
  if (!cheer.week) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const PepiteImage(PepitePose.cheer, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                [
                  for (final code in cheer.badges)
                    l.pepiteNewBadge(pepiteBadgeText(l, code).$1),
                  l.pepiteEarned(cheer.seeds),
                ].join('\n'),
              ),
            ),
          ],
        ),
      ),
    );
    return false;
  }
  return _cheerDialog(
    context,
    seeds: cheer.seeds,
    badges: cheer.badges,
    reserve: cheer.status.seeds,
    noticed: true,
  );
}

Future<bool> _cheerDialog(
  BuildContext context, {
  required int seeds,
  required List<String> badges,
  required int reserve,
  bool noticed = false,
}) async {
  final l = AppLocalizations.of(context);
  final apps = pepite.invitesApps;
  final see = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const PepiteImage(PepitePose.cheer, size: 120),
      title: Text(l.pepiteCelebrateTitle, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (noticed) ...[
            Text(l.pepiteNoticedWeek, textAlign: TextAlign.center),
            const SizedBox(height: 8),
          ],
          Text(l.pepiteEarned(seeds), textAlign: TextAlign.center),
          for (final code in badges) ...[
            const SizedBox(height: 8),
            Text(
              l.pepiteNewBadge(pepiteBadgeText(l, code).$1),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
          const SizedBox(height: 12),
          PepiteSeeds(reserve),
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
