import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../util/format.dart';

/// The estimated variable spending counted in the forecast, with its
/// calculation: the months used, each category's spending and median
/// (decision 0007: every figure shows where it comes from).
class VariableEstimateCard extends StatelessWidget {
  final VariableEstimateInfo estimate;
  final Map<int, Category> categories;
  final String Function(int cents) money;

  const VariableEstimateCard({
    super.key,
    required this.estimate,
    required this.categories,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final e = estimate;
    String month(DateTime start) => start.day == 1
        ? DateFormat.MMM(lang).format(DateTime(start.year, start.month))
        : context.shortDay(start);
    if (e.months.isEmpty || e.monthlyCents == 0) {
      return Text(
        e.months.isEmpty ? l.variableNoHistory : l.variableNone,
        style: theme.textTheme.bodySmall,
      );
    }
    final small = theme.textTheme.bodySmall;
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        leading: const Icon(Icons.shopping_cart_outlined),
        title: Text(l.variableIncluded(money(e.horizonCents))),
        subtitle: Text(
          l.variableMonthly(money(e.monthlyCents)),
          style: small,
        ),
        children: [
          Text(
            l.variableHow(e.months.map(month).join(', ')),
            style: small,
          ),
          const SizedBox(height: 8),
          for (final c in e.categories)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: c.categoryId == null
                                ? l.toClassify
                                : categories[c.categoryId] == null
                                ? '?'
                                : context.categoryName(
                                    categories[c.categoryId]!,
                                  ),
                          ),
                          TextSpan(
                            text: '\n${c.monthsCents.map(money).join(' · ')}',
                            style: small,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    money(c.monthlyCents),
                    style: const TextStyle(
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            l.variableThisMonth(
              money(e.spentThisMonthCents),
              money(e.leftThisMonthCents),
            ),
            style: small,
          ),
        ],
      ),
    );
  }
}
