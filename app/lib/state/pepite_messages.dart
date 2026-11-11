import 'package:owncoffer_client/owncoffer_client.dart';

import 'package:flutter/material.dart';

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
      'nomad' => (l.pepiteBadgeNomad, l.pepiteBadgeNomadHelp),
      'tidy' => (l.pepiteBadgeTidy, l.pepiteBadgeTidyHelp),
      'seer' => (l.pepiteBadgeSeer, l.pepiteBadgeSeerHelp),
      'archivist' => (l.pepiteBadgeArchivist, l.pepiteBadgeArchivistHelp),
      'loan_master' => (l.pepiteBadgeLoanMaster, l.pepiteBadgeLoanMasterHelp),
      'subscription_hunter' => (
        l.pepiteBadgeSubscriptionHunter,
        l.pepiteBadgeSubscriptionHunterHelp,
      ),
      'vault' => (l.pepiteBadgeVault, l.pepiteBadgeVaultHelp),
      'velvet' => (l.pepiteBadgeVelvet, l.pepiteBadgeVelvetHelp),
      'provident' => (l.pepiteBadgeProvident, l.pepiteBadgeProvidentHelp),
      'vigilant' => (l.pepiteBadgeVigilant, l.pepiteBadgeVigilantHelp),
      'to_the_cent' => (l.pepiteBadgeToTheCent, l.pepiteBadgeToTheCentHelp),
      'month_reviews' => (
        l.pepiteBadgeMonthReviews,
        l.pepiteBadgeMonthReviewsHelp,
      ),
      'first_goal' => (l.pepiteBadgeFirstGoal, l.pepiteBadgeFirstGoalHelp),
      'goal_half' => (l.pepiteBadgeGoalHalf, l.pepiteBadgeGoalHalfHelp),
      'goal_kept' => (l.pepiteBadgeGoalKept, l.pepiteBadgeGoalKeptHelp),
      'scissors' => (l.pepiteBadgeScissors, l.pepiteBadgeScissorsHelp),
      'team' => (l.pepiteBadgeTeam, l.pepiteBadgeTeamHelp),
      _ => (code, ''),
    };

/// Name and how to do each challenge of the month (decision 0030).
(String, String) pepiteChallengeText(AppLocalizations l, String code) =>
    switch (code) {
      'classify_20' => (
        l.pepiteChallengeClassify(20),
        l.pepiteChallengeClassifyHelp,
      ),
      'invoices_5' => (
        l.pepiteChallengeInvoices(5),
        l.pepiteChallengeInvoicesHelp,
      ),
      'rules_3' => (l.pepiteChallengeRules(3), l.pepiteChallengeRulesHelp),
      'subscriptions_2' => (
        l.pepiteChallengeSubscriptions(2),
        l.pepiteChallengeSubscriptionsHelp,
      ),
      'goal_1' => (l.pepiteChallengeGoal, l.pepiteChallengeGoalHelp),
      _ => (code, ''),
    };

/// The hint displayed on a locked badge silhouette (decision 0028, point 3).
String? pepiteBadgeHint(AppLocalizations l, String code) => switch (code) {
  'tidy' => l.pepiteBadgeTidyHint,
  'seer' => l.pepiteBadgeSeerHint,
  'archivist' => l.pepiteBadgeArchivistHint,
  'loan_master' => l.pepiteBadgeLoanMasterHint,
  'subscription_hunter' => l.pepiteBadgeSubscriptionHunterHint,
  'vault' => l.pepiteBadgeVaultHint,
  'velvet' => l.pepiteBadgeVelvetHint,
  'provident' => l.pepiteBadgeProvidentHint,
  'vigilant' => l.pepiteBadgeVigilantHint,
  'to_the_cent' => l.pepiteBadgeToTheCentHint,
  'month_reviews' => l.pepiteBadgeMonthReviewsHint,
  'first_goal' => l.pepiteBadgeFirstGoalHint,
  'goal_half' => l.pepiteBadgeGoalHalfHint,
  'goal_kept' => l.pepiteBadgeGoalKeptHint,
  'scissors' => l.pepiteBadgeScissorsHint,
  'team' => l.pepiteBadgeTeamHint,
  _ => null,
};

/// The distinctive icon of a badge (shown in silhouette when locked).
IconData pepiteBadgeIcon(String code) => switch (code) {
  'first_import' => Icons.file_download_outlined,
  'first_ritual' => Icons.check_circle_outline,
  'weeks_4' => Icons.calendar_today_outlined,
  'weeks_12' => Icons.date_range_outlined,
  'weeks_26' => Icons.event_repeat_outlined,
  'weeks_52' => Icons.calendar_month_outlined,
  'year_together' => Icons.cake_outlined,
  'nomad' => Icons.devices_outlined,
  'tidy' => Icons.auto_awesome_outlined,
  'seer' => Icons.visibility_outlined,
  'archivist' => Icons.receipt_long_outlined,
  'loan_master' => Icons.account_balance_outlined,
  'subscription_hunter' => Icons.repeat_on_outlined,
  'vault' => Icons.shield_outlined,
  'velvet' => Icons.fingerprint,
  'provident' => Icons.backup_outlined,
  'vigilant' => Icons.notifications_active_outlined,
  'to_the_cent' => Icons.price_check,
  'month_reviews' => Icons.assessment_outlined,
  'first_goal' => Icons.flag_outlined,
  'goal_half' => Icons.toll_outlined,
  'goal_kept' => Icons.task_alt,
  'scissors' => Icons.content_cut,
  'team' => Icons.group_add_outlined,
  _ => Icons.emoji_events,
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
  'nomad',
  'tidy',
  'seer',
  'archivist',
  'loan_master',
  'subscription_hunter',
  'vault',
  'velvet',
  'provident',
  'vigilant',
  'to_the_cent',
  'month_reviews',
  'first_goal',
  'goal_half',
  'goal_kept',
  'scissors',
  'team',
];

/// Seeds given by the server (PepiteEndpoint), shown in "How it works".
const pepiteRitualSeeds = 10;
const pepiteBadgeSeeds = 5;
