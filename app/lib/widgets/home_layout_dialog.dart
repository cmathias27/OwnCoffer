import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../state/home_layout.dart';

/// What the editor gives back: a layout, or null for the home page as it
/// comes.
class HomeLayoutChoice {
  final HomeLayout? layout;
  const HomeLayoutChoice(this.layout);
}

/// The editor of the home page (decision 0044): each card shown or hidden,
/// dragged to its place. Nothing is saved until « Enregistrer ».
class HomeLayoutDialog extends StatefulWidget {
  final HomeLayout layout;

  /// « Conseils du moment » only where the advisor exists.
  final bool advices;

  /// Simple mode: the defaults leave the spending ranking out.
  final bool simple;

  const HomeLayoutDialog({
    super.key,
    required this.layout,
    this.advices = true,
    this.simple = false,
  });

  @override
  State<HomeLayoutDialog> createState() => _HomeLayoutDialogState();
}

class _HomeLayoutDialogState extends State<HomeLayoutDialog> {
  late HomeLayout _layout = widget.layout;

  /// Back to the defaults is only saved as such when not changed after.
  var _reset = false;

  static String name(AppLocalizations l, HomeCard c) => switch (c) {
    HomeCard.pepite => l.homeCardPepite,
    HomeCard.summary => l.homeCardSummary,
    HomeCard.firstSteps => l.homeCardFirstSteps,
    HomeCard.status => l.homeCardStatus,
    HomeCard.advices => l.homeCardAdvices,
    HomeCard.balance => l.homeCardBalance,
    HomeCard.leftToLive => l.homeCardLeftToLive,
    HomeCard.monthBalance => l.homeCardMonthBalance,
    HomeCard.upcoming => l.homeCardUpcoming,
    HomeCard.topSpending => l.homeCardTopSpending,
  };

  static String help(AppLocalizations l, HomeCard c) => switch (c) {
    HomeCard.pepite => l.homeCardPepiteHelp,
    HomeCard.summary => l.homeCardSummaryHelp,
    HomeCard.firstSteps => l.homeCardFirstStepsHelp,
    HomeCard.status => l.homeCardStatusHelp,
    HomeCard.advices => l.homeCardAdvicesHelp,
    HomeCard.balance => l.homeCardBalanceHelp,
    HomeCard.leftToLive => l.homeCardLeftToLiveHelp,
    HomeCard.monthBalance => l.homeCardMonthBalanceHelp,
    HomeCard.upcoming => l.homeCardUpcomingHelp,
    HomeCard.topSpending => l.homeCardTopSpendingHelp,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cards = [
      for (final c in _layout.order)
        if (c != HomeCard.advices || widget.advices) c,
    ];
    return AlertDialog(
      title: Text(l.homeCustomizeTitle),
      content: SizedBox(
        width: 480,
        height: (MediaQuery.sizeOf(context).height * 0.6).clamp(240, 520),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.homeCustomizeHelp),
            const SizedBox(height: 8),
            Expanded(
              child: ReorderableListView.builder(
                key: const Key('home-layout-list'),
                buildDefaultDragHandles: false,
                itemCount: cards.length,
                onReorderItem: (from, to) => setState(() {
                  final shown = List.of(cards);
                  shown.insert(to, shown.removeAt(from));
                  _layout = _layout.reordered(shown);
                  _reset = false;
                }),
                itemBuilder: (context, i) {
                  final c = cards[i];
                  return CheckboxListTile(
                    key: ValueKey('home-card-${c.name}'),
                    value: _layout.shows(c),
                    onChanged: (v) => setState(() {
                      _layout = _layout.toggled(c, v ?? false);
                      _reset = false;
                    }),
                    title: Text(name(l, c)),
                    subtitle: Text(help(l, c)),
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: ReorderableDragStartListener(
                      index: i,
                      child: Tooltip(
                        message: l.homeCustomizeMove,
                        child: const Icon(Icons.drag_handle),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('home-layout-reset'),
          onPressed: () => setState(() {
            _layout = HomeLayout.defaults(simple: widget.simple);
            _reset = true;
          }),
          child: Text(l.homeCustomizeReset),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const Key('home-layout-save'),
          onPressed: () => Navigator.pop(
            context,
            HomeLayoutChoice(_reset ? null : _layout),
          ),
          child: Text(l.save),
        ),
      ],
    );
  }
}
