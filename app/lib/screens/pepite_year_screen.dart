import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../state/pepite_messages.dart';
import '../util/format.dart';
import '../widgets/pepite.dart';

/// « Ton année avec Pépite » (decision 0031): what the user did in [year],
/// told without judgement nor comparison with anyone.
class PepiteYearScreen extends StatefulWidget {
  final int year;

  /// Tests give their own; the server's otherwise.
  final Future<PepiteYear> Function(int year)? load;

  const PepiteYearScreen({super.key, required this.year, this.load});

  @override
  State<PepiteYearScreen> createState() => _PepiteYearScreenState();
}

class _PepiteYearScreenState extends State<PepiteYearScreen> {
  late final Future<PepiteYear> _year =
      (widget.load ?? (year) => client.pepite.year(year, DateTime.now()))(
        widget.year,
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.pepiteYearTitle(widget.year))),
      body: FutureBuilder<PepiteYear>(
        future: _year,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(errorText(l, snap.error!)),
              ),
            );
          }
          final y = snap.data;
          if (y == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: _story(context, l, y),
          );
        },
      ),
    );
  }

  List<Widget> _story(BuildContext context, AppLocalizations l, PepiteYear y) {
    final theme = Theme.of(context);
    final best = y.bestCategory;
    final empty =
        y.weeks == 0 &&
        y.badges.isEmpty &&
        y.challenges == 0 &&
        y.goalMonthsTracked == 0 &&
        y.subscriptionsStopped == 0;
    Widget fact(IconData icon, String title, [String? detail]) => Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: detail == null ? null : Text(detail),
      ),
    );
    return [
      const Center(child: PepiteImage(PepitePose.cheer, size: 140)),
      const SizedBox(height: 12),
      Text(
        empty ? l.pepiteYearEmpty(y.year) : l.pepiteYearIntro(y.year),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyLarge,
      ),
      if (!empty) ...[
        const SizedBox(height: 16),
        fact(
          Icons.event_available_outlined,
          l.pepiteYearWeeks(y.weeks),
          l.pepiteYearSeeds(y.seeds),
        ),
        fact(
          Icons.emoji_events_outlined,
          l.pepiteYearBadges(y.badges.length),
          y.badges.isEmpty
              ? null
              : [
                  for (final b in y.badges) pepiteBadgeText(l, b).$1,
                ].join(' · '),
        ),
        if (y.challenges > 0)
          fact(Icons.flag_outlined, l.pepiteYearChallenges(y.challenges)),
        if (y.goalMonthsTracked > 0)
          fact(
            Icons.track_changes_outlined,
            l.pepiteYearGoals(
              (y.goalMonthsKept * 100 / y.goalMonthsTracked).round(),
            ),
            l.pepiteYearGoalsDetail(y.goalMonthsKept, y.goalMonthsTracked),
          ),
        if (best != null && (y.bestCategoryMonths ?? 0) > 0)
          fact(
            Icons.star_outline,
            l.pepiteYearBestCategory(context.categoryName(best)),
            l.pepiteYearBestCategoryDetail(y.bestCategoryMonths!),
          ),
        if (y.subscriptionsStopped > 0)
          fact(
            Icons.content_cut,
            l.pepiteYearSubscriptions(y.subscriptionsStopped),
            y.subscriptionsMonthlyCents > 0
                ? l.pepiteYearSubscriptionsSaved(
                    context.money(y.subscriptionsMonthlyCents),
                    context.money(y.subscriptionsMonthlyCents * 12),
                  )
                : null,
          ),
        const SizedBox(height: 16),
        Text(
          l.pepiteYearHow,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    ];
  }
}
