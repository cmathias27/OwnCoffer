import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../core/dates.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/scopes.dart';
import '../security/audit.dart';

/// Bank accounts of a group. Only the fields below can be set by the client;
/// group, ids and dates always come from the server.
class AccountEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Password-only sessions of users with two-factor authentication lack
  /// this scope until they type their code.
  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<List<Account>> list(Session session, int groupId) =>
      Access.visibleAccounts(session, groupId);

  Future<Account> create(
    Session session,
    int groupId,
    String name,
    AccountKind kind, {
    String? bank,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    AccountVisibility? visibility,
  }) async {
    await Access.requireMember(session, groupId, min: MemberRole.admin);
    final account = await Account.db.insertRow(
      session,
      Account(
        groupId: groupId,
        name: _name(name),
        kind: kind,
        bank: bank?.trim(),
        initialBalanceCents: _cents(initialBalanceCents ?? 0),
        initialBalanceDate: initialBalanceDate,
        alertThresholdCents: _cents(alertThresholdCents ?? 0),
        visibility: visibility ?? AccountVisibility.shared,
      ),
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'create',
      entity: 'account',
      rowId: account.id,
      after: account,
    );
    return account;
  }

  Future<Account> update(
    Session session,
    int accountId, {
    String? name,
    String? bank,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    AccountVisibility? visibility,
    String? color,
  }) async {
    final current = await Access.requireAccount(session, accountId);
    await Access.requireMember(session, current.groupId, min: MemberRole.admin);
    final updated = await Account.db.updateRow(
      session,
      current.copyWith(
        name: name == null ? null : _name(name),
        bank: bank?.trim(),
        initialBalanceCents: initialBalanceCents == null
            ? null
            : _cents(initialBalanceCents),
        initialBalanceDate: initialBalanceDate,
        alertThresholdCents: alertThresholdCents == null
            ? null
            : _cents(alertThresholdCents),
        visibility: visibility,
        color: color,
      ),
    );
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'update',
      entity: 'account',
      rowId: accountId,
      before: current,
      after: updated,
    );
    return updated;
  }

  /// Moves the account to the trash (kept 30 days).
  Future<void> archive(Session session, int accountId) async {
    final current = await Access.requireAccount(session, accountId);
    await Access.requireMember(session, current.groupId, min: MemberRole.admin);
    final updated = await Account.db.updateRow(
      session,
      current.copyWith(deletedAt: DateTime.now().toUtc()),
    );
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'archive',
      entity: 'account',
      rowId: accountId,
      before: current,
      after: updated,
    );
  }

  /// Gives or removes access to a restricted account (admins).
  Future<void> setAccess(
    Session session,
    int accountId,
    UuidValue userId,
    bool allowed,
  ) async {
    final account = await Access.requireAccount(session, accountId);
    await Access.requireMember(session, account.groupId, min: MemberRole.admin);
    final target = await GroupMember.db.findFirstRow(
      session,
      where: (m) =>
          m.groupId.equals(account.groupId) & m.authUserId.equals(userId),
    );
    if (target == null) throw InvalidInputException(code: 'not_a_member');
    await AccountAccess.db.deleteWhere(
      session,
      where: (a) => a.accountId.equals(accountId) & a.authUserId.equals(userId),
    );
    if (allowed) {
      await AccountAccess.db.insertRow(
        session,
        AccountAccess(accountId: accountId, authUserId: userId),
      );
    }
    await Audit.log(
      session,
      groupId: account.groupId,
      action: allowed ? 'grant_access' : 'revoke_access',
      entity: 'account',
      rowId: accountId,
    );
  }

  static String _name(String name) {
    final t = name.trim();
    if (t.isEmpty || t.length > 80) {
      throw InvalidInputException(code: 'invalid_name', field: 'name');
    }
    return t;
  }

  static int _cents(int cents) {
    if (cents.abs() > 100000000000000) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    return cents;
  }

  /// Balance check: the balance the bank shows at the end of [date],
  /// compared with the one computed from the operations. Saved, so the last
  /// checks can be seen again.
  Future<BalanceCheck> checkBalance(
    Session session,
    int accountId,
    DateTime date,
    int bankBalanceCents,
  ) async {
    final account = await Access.requireAccount(
      session,
      accountId,
      write: true,
    );
    if (bankBalanceCents.abs() > 100000000000000) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    final u = date.toUtc();
    final day = core.LocalDate(u.year, u.month, u.day);
    final today = core.LocalDate.fromDateTime(DateTime.now().toUtc());
    if (day > today.addDays(1)) {
      throw InvalidInputException(code: 'invalid_date', field: 'date');
    }
    final ops = await BankTransaction.db.find(
      session,
      where: (t) =>
          t.accountId.equals(accountId) &
          t.deletedAt.equals(null) &
          (t.date <= day.toDb()),
    );
    var computed = account.initialBalanceCents, uncleared = 0;
    DateTime? lastImported;
    for (final t in ops) {
      computed += t.amountCents;
      if (t.importId == null && !t.cleared) uncleared += t.amountCents;
      if (t.importId != null &&
          (lastImported == null || t.date.isAfter(lastImported))) {
        lastImported = t.date;
      }
    }
    final saved = await BalanceCheck.db.insertRow(
      session,
      BalanceCheck(
        accountId: accountId,
        date: day.toDb(),
        bankBalanceCents: bankBalanceCents,
        computedCents: computed,
        differenceCents: computed - bankBalanceCents,
        unclearedManualCents: uncleared,
        lastImportedDate: lastImported,
        createdBy: Access.userId(session),
      ),
    );
    await Audit.log(
      session,
      groupId: account.groupId,
      action: 'check_balance',
      entity: 'account',
      rowId: accountId,
      after: saved,
    );
    return saved;
  }

  /// The last balance checks of the account, newest first.
  Future<List<BalanceCheck>> balanceChecks(
    Session session,
    int accountId,
  ) async {
    await Access.requireAccount(session, accountId);
    return BalanceCheck.db.find(
      session,
      where: (c) => c.accountId.equals(accountId),
      orderByList: (c) => [c.createdAt.desc(), c.id.desc()],
      limit: 10,
    );
  }
}
