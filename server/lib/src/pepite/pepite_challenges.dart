import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Measures the challenge of the month (decision 0030) from the user's own
/// doings since they chose it, by count queries only: the audit log (who
/// did what) and the rules they wrote. Never an amount.
abstract final class PepiteChallenges {
  /// How many times [code] was done by [user] since [since], at most its
  /// target; 0 for an unknown code.
  static Future<int> progress(
    Session session,
    Transaction t,
    UuidValue user,
    String code,
    DateTime since,
  ) async {
    final challenge = core.pepiteChallengeByCode(code);
    if (challenge == null) return 0;
    Future<int> audited(
      String entity,
      Set<String> actions, [
      Expression Function(AuditEntryTable a)? more,
    ]) => AuditEntry.db.count(
      session,
      where: (a) {
        final e =
            a.authUserId.equals(user) &
            a.entity.equals(entity) &
            a.action.inSet(actions) &
            (a.createdAt >= since);
        return more == null ? e : e & more(a);
      },
      transaction: t,
    );
    // JSON snapshots of the audit log (null fields left out).
    const attached = '%"transactionId"%';
    const subscribed = '%"subscription":true%';
    final done = switch (code) {
      'classify_20' => await audited('transaction', {'set_category'}),
      'invoices_5' =>
        await audited(
              'invoice',
              {'upload_invoice'},
              (a) => a.after.like(attached),
            ) +
            await audited(
              'invoice',
              {'attach_invoice'},
              (a) => a.before.notLike(attached),
            ),
      'rules_3' => await Rule.db.count(
        session,
        where: (r) => r.createdBy.equals(user) & (r.createdAt >= since),
        transaction: t,
      ),
      'subscriptions_2' => await audited(
        'scheduled',
        {'create', 'subscribe_from', 'update'},
        (a) =>
            a.after.like(subscribed) &
            (a.before.equals(null) | a.before.like('%"subscription":false%')),
      ),
      'goal_1' => await audited('goal', {'create'}),
      _ => 0,
    };
    return done.clamp(0, challenge.target);
  }
}
