import 'dart:convert';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../finance/spending_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import 'pepite_badges.dart';

/// « Ton année avec Pépite » (decision 0031): a deterministic summary of a
/// year, from the user's own doings and the accounts they may see.
abstract final class PepiteYears {
  /// The mark of a week of the ritual counted in [year], keyed by its
  /// Monday (`PepiteBadges.mark`), since 1.16.0.
  static String weekMark(int year) => 'week_$year';

  static Future<void> markWeek(
    Session session,
    UuidValue user,
    DateTime monday, {
    Transaction? transaction,
  }) => PepiteBadges.mark(
    session,
    user,
    weekMark(monday.year),
    core.LocalDate(monday.year, monday.month, monday.day).toString(),
    transaction: transaction,
  );

  static Future<PepiteYear> of(
    Session session,
    UuidValue user,
    int year,
    core.LocalDate today,
  ) async {
    final from = DateTime.utc(year);
    final to = DateTime.utc(year + 1);
    bool inYear(DateTime? d) =>
        d != null && !d.isBefore(from) && d.isBefore(to);

    // Weeks: those marked in the year; the weeks counted before the marks
    // existed belong to the year of the first ritual.
    final weeks = await PepiteMark.db.count(
      session,
      where: (m) => m.authUserId.equals(user) & m.code.equals(weekMark(year)),
    );
    final progress = await PepiteProgress.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(user),
    );
    final allMarked = await PepiteMark.db.count(
      session,
      where: (m) => m.authUserId.equals(user) & m.code.like('week_%'),
    );
    final unmarked = ((progress?.weeks ?? 0) - allMarked).clamp(0, 5000);
    final legacy = inYear(progress?.firstRitualAt) ? unmarked : 0;

    final badges = await PepiteBadge.db.find(
      session,
      where: (b) =>
          b.authUserId.equals(user) & (b.earnedAt >= from) & (b.earnedAt < to),
      orderBy: (b) => b.earnedAt,
    );
    final challenges = await PepiteChallengeRow.db.count(
      session,
      where: (c) =>
          c.authUserId.equals(user) & (c.doneAt >= from) & (c.doneAt < to),
    );
    final allWeeks = weeks + legacy;

    final goals = await _goals(session, user, year, today);
    final stopped = await _stopped(session, user, from, to);
    return PepiteYear(
      year: year,
      weeks: allWeeks,
      badges: [for (final b in badges) b.code],
      challenges: challenges,
      seeds:
          allWeeks * 10 +
          badges.length * 5 +
          challenges * core.pepiteChallengeSeeds,
      goalMonthsKept: goals.kept,
      goalMonthsTracked: goals.tracked,
      bestCategory: goals.best,
      bestCategoryMonths: goals.best == null ? null : goals.bestMonths,
      subscriptionsStopped: stopped.$1,
      subscriptionsMonthlyCents: stopped.$2,
    );
  }

  /// Budget months of [year] ended within each goal of the user's groups,
  /// spending read on the accounts they may see. Only goals set before the
  /// month began, and months already over.
  static Future<({int kept, int tracked, Category? best, int bestMonths})>
  _goals(
    Session session,
    UuidValue user,
    int year,
    core.LocalDate today,
  ) async {
    var kept = 0, tracked = 0, bestMonths = 0;
    var bestRatio = 0.0;
    Category? best;
    for (final member in await GroupMember.db.find(
      session,
      where: (m) => m.authUserId.equals(user),
    )) {
      final groupId = member.groupId;
      final goals = await Goal.db.find(
        session,
        where: (g) => g.groupId.equals(groupId) & g.amountCents.notEquals(0),
      );
      if (goals.isEmpty) continue;
      final Set<int> ids = {
        for (final a in await Access.visibleAccountsOf(session, member)) a.id!,
      };
      if (ids.isEmpty) continue;
      final months = <core.Period>[
        for (var m = 1; m <= 12; m++)
          await SpendingService.period(
            session,
            groupId,
            core.PeriodKind.month,
            core.LocalDate(year, m, 15),
          ),
      ].where((p) => p.end <= today).toList();
      if (months.isEmpty) continue;
      final cats = await SpendingService.categories(session, groupId);
      final ops = await SpendingService.operations(
        session,
        ids,
        months.first.start,
        months.last.end,
      );
      final keptBy = <int, int>{}, trackedBy = <int, int>{};
      for (final month in months) {
        final begun = month.start.toDb();
        final active = goals.where((g) => g.createdAt.isBefore(begun));
        if (active.isEmpty) continue;
        final summary = core.summarizeSpending(
          cats,
          ops.where((o) => month.contains(o.date)),
        );
        for (final g in active) {
          final spent = summary.totals[g.categoryId] ?? 0;
          trackedBy[g.categoryId] = (trackedBy[g.categoryId] ?? 0) + 1;
          if (spent <= g.amountCents) {
            keptBy[g.categoryId] = (keptBy[g.categoryId] ?? 0) + 1;
          }
        }
      }
      for (final MapEntry(key: categoryId, value: n) in trackedBy.entries) {
        final k = keptBy[categoryId] ?? 0;
        tracked += n;
        kept += k;
        final ratio = k / n;
        if (k > bestMonths || (k == bestMonths && k > 0 && ratio > bestRatio)) {
          final category = await Category.db.findById(session, categoryId);
          if (category == null || category.deletedAt != null) continue;
          best = category;
          bestMonths = k;
          bestRatio = ratio;
        }
      }
    }
    return (kept: kept, tracked: tracked, best: best, bestMonths: bestMonths);
  }

  /// Subscriptions the user stopped in the year: deleted, or given an end;
  /// what they cost a month, from the audit snapshot before.
  static Future<(int, int)> _stopped(
    Session session,
    UuidValue user,
    DateTime from,
    DateTime to,
  ) async {
    const subscribed = '%"subscription":true%';
    const ends = '%"endDate"%';
    final rows = await AuditEntry.db.find(
      session,
      where: (a) =>
          a.authUserId.equals(user) &
          a.entity.equals('scheduled') &
          (a.createdAt >= from) &
          (a.createdAt < to) &
          a.before.like(subscribed) &
          (a.action.equals('delete') |
              (a.action.equals('update') &
                  a.before.notLike(ends) &
                  a.after.like(ends))),
    );
    var count = 0, monthly = 0;
    final seen = <int>{};
    for (final row in rows) {
      final before = row.before;
      if (before == null) continue;
      final ScheduledTransaction s;
      try {
        s = ScheduledTransaction.fromJson(
          jsonDecode(before) as Map<String, dynamic>,
        );
      } on Object {
        continue;
      }
      // Given an end, then deleted: once.
      if (s.id != null && !seen.add(s.id!)) continue;
      count++;
      if (s.amountCents < 0) {
        monthly += core.monthlyEquivalentCents(
          -s.amountCents,
          core.Frequency.values.byName(s.frequency.name),
          s.interval < 1 ? 1 : s.interval,
        );
      }
    }
    return (count, monthly);
  }
}
