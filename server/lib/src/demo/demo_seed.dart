import 'dart:io';

import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';
import '../endpoints/account_endpoint.dart';
import '../endpoints/goal_endpoint.dart';
import '../endpoints/loan_endpoint.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';

/// The demonstration instance (OWNCOFFER_DEMO=true): a fictitious household
/// can be loaded into an empty group, to show OwnCoffer without any real
/// data. Never available on a normal instance.
abstract final class DemoSeed {
  /// For tests.
  static bool? enabledOverride;

  static bool get enabled =>
      enabledOverride ??
      Platform.environment['OWNCOFFER_DEMO']?.toLowerCase() == 'true';

  /// Fills the empty group [groupId] with the demo household (accounts,
  /// 12 months of operations, planned operations and subscriptions, goals,
  /// a car loan). Server administrator of a demo instance only.
  static Future<void> fill(Session session, int groupId) async {
    if (!enabled) throw AccessDeniedException(code: 'demo_only');
    await Access.requireMember(session, groupId, min: MemberRole.admin);
    if (await Account.db.count(
          session,
          where: (a) => a.groupId.equals(groupId),
        ) >
        0) {
      throw InvalidInputException(code: 'demo_group_not_empty');
    }
    final today = core.LocalDate.fromDateTime(DateTime.now().toUtc());
    final h = core.DemoHousehold.generate(today);
    final categories = {
      for (final c in await Category.db.find(
        session,
        where: (c) => c.groupId.equals(groupId) & c.deletedAt.equals(null),
      ))
        if (c.standardCode != null) c.standardCode!: c.id!,
    };
    final start = h.operations.first.date.addDays(-1).toDb();
    final accounts = [
      for (final (i, a) in h.accounts.indexed)
        await AccountEndpoint().create(
          session,
          groupId,
          a.name,
          i == 2 ? AccountKind.savings : AccountKind.checking,
          bank: 'Banque Exemple',
          initialBalanceCents: a.initialCents,
          initialBalanceDate: start,
        ),
    ];
    await BankTransaction.db.insert(session, [
      for (final o in h.operations)
        BankTransaction(
          accountId: accounts[o.account].id!,
          date: o.date.toDb(),
          amountCents: o.amountCents,
          rawLabel: o.label,
          cleanLabel: o.label.replaceFirst(
            RegExp(r'^(CB|PRLV|VIR|PAIEMENT CB \d+) '),
            '',
          ),
          operationKind: o.label.startsWith('CB')
              ? 'card'
              : o.label.startsWith('PRLV')
              ? 'directDebit'
              : 'transfer',
          categoryId: o.category == null ? null : categories[o.category],
          categorySource: o.category == null
              ? CategorySource.none
              : CategorySource.communityRule,
          cleared: o.date.isBefore(today.addDays(-5)),
        ),
    ]);
    final next = core.LocalDate(today.year, today.month, 1);
    await ScheduledTransaction.db.insert(session, [
      for (final p in h.planned)
        ScheduledTransaction(
          accountId: accounts[p.account].id!,
          amountCents: p.amountCents,
          label: p.label,
          categoryId: categories[p.category],
          frequency: ScheduleFrequency.monthly,
          startDate: core.LocalDate(
            next.year,
            next.month,
            p.dayOfMonth,
          ).addMonths(today.day >= p.dayOfMonth ? 1 : 0).toDb(),
          matchPattern: core.normalizeForMatch(p.label),
          subscription: p.subscription,
        ),
    ]);
    for (final MapEntry(key: code, value: cents) in h.goals.entries) {
      final id = categories[code];
      if (id != null) await GoalEndpoint().set(session, groupId, id, cents);
    }
    await LoanEndpoint().create(
      session,
      groupId,
      Loan(
        groupId: groupId,
        accountId: accounts[0].id,
        kind: LoanKind.car,
        lender: 'Banque Exemple',
        label: 'Voiture',
        principalCents: 1500000,
        annualRateMilli: 3450,
        durationMonths: 48,
        paymentCents: 33500,
        firstDueDate: next.addMonths(-14).addDays(4).toDb(),
      ),
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'demo_fill',
      entity: 'group',
      rowId: groupId,
    );
  }
}
