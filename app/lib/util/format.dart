import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' as core;

import '../l10n/app_localizations.dart';

/// Display helpers. Amounts stay integer cents: formatting never goes
/// through `double`.
extension Formatting on BuildContext {
  String get _lang => Localizations.localeOf(this).languageCode;

  /// `-1 234,56 €` in French, `-€1,234.56` in English.
  String money(int cents, {String currency = 'EUR'}) {
    final fr = _lang == 'fr';
    final body = core.formatCents(
      cents.abs(),
      decimalSeparator: fr ? ',' : '.',
      thousandsSeparator: fr ? ' ' : ',',
    );
    final symbol = currency == 'EUR' ? '€' : currency;
    final sign = cents < 0 ? '-' : '';
    return fr ? '$sign$body $symbol' : '$sign$symbol$body';
  }

  /// Operation dates are calendar dates stored at UTC midnight: they are
  /// formatted from their UTC fields, never converted to local time.
  String day(DateTime date) =>
      DateFormat.yMMMd(_lang).format(DateTime(date.year, date.month, date.day));

  /// "octobre 2026".
  String monthName(DateTime date) =>
      DateFormat.yMMMM(_lang).format(DateTime(date.year, date.month, 1));

  String shortDay(DateTime date) =>
      DateFormat.MMMd(_lang).format(DateTime(date.year, date.month, date.day));

  /// The group's name for a category, or the standard name in the user's
  /// language.
  String categoryName(Category c) {
    final custom = c.name;
    if (custom != null && custom.isNotEmpty) return custom;
    final def = core.standardCategoriesById[c.standardCode];
    return def?.name(_lang) ?? '?';
  }

  /// The standard catalogue's name of a category, in the user's language.
  String? standardName(Category c) =>
      core.standardCategoriesById[c.standardCode]?.name(_lang);

  String categorySourceName(CategorySource s) {
    final l = AppLocalizations.of(this);
    return switch (s) {
      CategorySource.manual => l.sourceManual,
      CategorySource.groupRule => l.sourceGroupRule,
      CategorySource.communityRule => l.sourceCommunityRule,
      CategorySource.history => l.sourceHistory,
      CategorySource.ai => l.sourceAi,
      CategorySource.none => l.toClassify,
    };
  }
}

/// Today's calendar date of the device, as the server expects it.
DateTime todayUtcMidnight() {
  final n = DateTime.now();
  return DateTime.utc(n.year, n.month, n.day);
}

/// Parses an amount typed by the user, with the same strict rules as bank
/// files (shared/money.dart). Returns null when ambiguous or unreadable.
int? parseUserAmount(String text) {
  try {
    return core.parseAmountCents(text);
  } on core.AmountFormatException {
    return null;
  }
}
