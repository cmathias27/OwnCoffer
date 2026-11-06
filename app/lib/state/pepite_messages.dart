import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';

/// The drawings of Pépite (assets/pepite/).
enum PepitePose { happy, cheer, sleep, wave }

/// What Pépite shows and says.
class PepiteLine {
  final PepitePose pose;
  final String text;

  /// The weekly ritual is still to do.
  final bool remind;

  const PepiteLine(this.pose, this.text, {this.remind = false});
}

/// What Pépite says, decided from the facts only, never by an AI
/// (decision 0026). Always kind, never a reproach; sober when an account
/// goes below zero. The wording changes with the week, the same all week.
PepiteLine pepiteLine(
  AppLocalizations l,
  PepiteStatus s, {
  required bool overdrawn,
  required DateTime today,
}) {
  final week = _weekNumber(today);
  if (overdrawn) {
    return PepiteLine(PepitePose.happy, l.pepiteSober, remind: !s.doneThisWeek);
  }
  if (s.doneThisWeek) {
    final texts = [l.pepiteDone0, l.pepiteDone1, l.pepiteDone2];
    return PepiteLine(PepitePose.cheer, texts[week % texts.length]);
  }
  if (s.weeks == 0) {
    return PepiteLine(PepitePose.wave, l.pepiteWelcome, remind: true);
  }
  final last = s.lastRitualAt;
  if (last != null && today.difference(last) > const Duration(days: 21)) {
    return PepiteLine(PepitePose.wave, l.pepiteWelcomeBack, remind: true);
  }
  final texts = [l.pepiteRemind0, l.pepiteRemind1, l.pepiteRemind2];
  return PepiteLine(PepitePose.happy, texts[week % texts.length], remind: true);
}

/// Weeks since a fixed Monday, to vary the wording from one week to the
/// next.
int _weekNumber(DateTime today) =>
    DateTime.utc(
      today.year,
      today.month,
      today.day,
    ).difference(DateTime.utc(2024, 1, 1)).inDays ~/
    7;

/// Name and how to earn each badge of the server (PepiteEndpoint).
(String, String) pepiteBadgeText(AppLocalizations l, String code) =>
    switch (code) {
      'first_import' => (
        l.pepiteBadgeFirstImport,
        l.pepiteBadgeFirstImportHelp,
      ),
      'first_ritual' => (
        l.pepiteBadgeFirstRitual,
        l.pepiteBadgeFirstRitualHelp,
      ),
      'weeks_4' => (l.pepiteBadgeWeeks(4), l.pepiteBadgeWeeksHelp(4)),
      'weeks_12' => (l.pepiteBadgeWeeks(12), l.pepiteBadgeWeeksHelp(12)),
      'weeks_26' => (l.pepiteBadgeWeeks(26), l.pepiteBadgeWeeksHelp(26)),
      'weeks_52' => (l.pepiteBadgeWeeks(52), l.pepiteBadgeWeeksHelp(52)),
      'year_together' => (l.pepiteBadgeYear, l.pepiteBadgeYearHelp),
      _ => (code, ''),
    };

/// Every badge, in the order of the server.
const pepiteBadges = [
  'first_import',
  'first_ritual',
  'weeks_4',
  'weeks_12',
  'weeks_26',
  'weeks_52',
  'year_together',
];

/// Seeds given by the server (PepiteEndpoint), shown in "How it works".
const pepiteRitualSeeds = 10;
const pepiteBadgeSeeds = 5;
