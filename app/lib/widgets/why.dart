import 'package:flutter/material.dart';

import '../help/help.dart';
import '../l10n/app_localizations.dart';
import '../util/format.dart';

/// One line of a calculation: a label and an amount; [total] lines are
/// bold, under a rule.
class WhyLine {
  final String label;
  final int? cents;
  final String? text;
  final bool total;
  const WhyLine(this.label, int this.cents, {this.total = false}) : text = null;
  const WhyLine.text(this.label, String this.text, {this.total = false})
    : cents = null;
}

/// « Pourquoi ce chiffre ? » (decision 0041, point 11): the lines of the
/// calculation behind a key figure, then how it is made, in words.
class WhyButton extends StatelessWidget {
  final String title;
  final List<WhyLine> lines;
  final String explanation;
  final Color? color;
  final String? currency;

  const WhyButton({
    super.key,
    required this.title,
    required this.lines,
    required this.explanation,
    this.color,
    this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () => showWhy(context),
      icon: const Icon(Icons.help_outline, size: 18),
      label: Text(l.whyThisFigure),
    );
  }

  Future<void> showWhy(BuildContext context) {
    final l = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        const figures = TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
        );
        return AlertDialog(
          key: const Key('why-dialog'),
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final line in lines) ...[
                  if (line.total) const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            line.label,
                            style: line.total
                                ? theme.textTheme.titleSmall
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          line.text ??
                              context.money(
                                line.cents!,
                                currency: currency ?? 'EUR',
                              ),
                          style: line.total
                              ? theme.textTheme.titleSmall?.merge(figures)
                              : figures,
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(explanation, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.close),
            ),
          ],
        );
      },
    );
  }
}

/// The small « ? » of a card (decision 0041, point 14): what the card shows,
/// in a few sentences.
class CardHelp extends StatelessWidget {
  final String title;
  final String text;

  /// The help page this card belongs to, opened from the dialog.
  final HelpTopic? topic;
  const CardHelp({
    super.key,
    required this.title,
    required this.text,
    this.topic,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return IconButton(
      tooltip: l.cardHelpTooltip,
      visualDensity: VisualDensity.compact,
      iconSize: 18,
      icon: const Icon(Icons.help_outline),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          key: const Key('card-help-dialog'),
          title: Text(title),
          content: Text(text),
          actions: [
            if (topic case final t?)
              TextButton(
                key: const Key('card-help-open'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => HelpPage(topic: t)),
                  );
                },
                child: Text(l.cardHelpOpen),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.close),
            ),
          ],
        ),
      ),
    );
  }
}
