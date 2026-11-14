import 'package:serverpod/serverpod.dart';

import '../finance/plan_inputs.dart';
import '../finance/refund_service.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Money expected back (decision 0050): settled by the first credit of the
/// same amount, late after its day.
class RefundEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// The refunds of the group, open ones first; matches new credits of the
  /// visible accounts first.
  Future<List<ExpectedRefund>> list(Session session, int groupId) async {
    final visible = await Access.visibleAccounts(session, groupId);
    await RefundService.match(session, groupId, {
      for (final a in visible) a.id!,
    });
    final rows = await ExpectedRefund.db.find(
      session,
      where: (r) => r.groupId.equals(groupId),
      orderBy: (r) => r.since,
    );
    return [
      for (final r in rows)
        if (r.receivedAt == null) r,
      for (final r in rows.reversed)
        if (r.receivedAt != null) r,
    ];
  }

  /// Creates ([refund] without id) or changes an expected refund.
  Future<ExpectedRefund> save(
    Session session,
    int groupId,
    ExpectedRefund refund,
  ) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final current = refund.id == null
        ? null
        : await _find(session, refund.id!, groupId);
    if (refund.accountId != null) {
      final a = await Access.requireAccount(session, refund.accountId!);
      if (a.groupId != groupId) {
        throw AccessDeniedException(code: 'account_access_denied');
      }
    }
    final since = PlanInputs.day(refund.since);
    final dueBy = refund.dueBy == null ? null : PlanInputs.day(refund.dueBy!);
    if (dueBy != null && dueBy.isBefore(since)) {
      throw InvalidInputException(code: 'invalid_date', field: 'dueBy');
    }
    final clean = ExpectedRefund(
      groupId: groupId,
      createdBy: current?.createdBy ?? Access.userId(session),
      label: PlanInputs.text(refund.label, field: 'label'),
      amountCents: PlanInputs.cents(refund.amountCents),
      since: since,
      dueBy: dueBy,
      accountId: refund.accountId,
    );
    final saved = current == null
        ? await ExpectedRefund.db.insertRow(session, clean)
        : await ExpectedRefund.db.updateRow(
            session,
            // A change of amount or day looks for its credit again.
            clean.copyWith(id: current.id, createdAt: current.createdAt),
          );
    await Audit.log(
      session,
      groupId: groupId,
      action: current == null ? 'create' : 'update',
      entity: 'expected_refund',
      rowId: saved.id,
      before: current,
      after: saved,
    );
    return saved;
  }

  /// Received by other means (cash, cheque not imported yet), or open again.
  Future<ExpectedRefund> setReceived(
    Session session,
    int refundId,
    bool received,
  ) async {
    final current = await _find(session, refundId, null);
    await Access.requireMember(
      session,
      current.groupId,
      min: MemberRole.user,
    );
    final now = DateTime.now().toUtc();
    final saved = await ExpectedRefund.db.updateRow(
      session,
      current.copyWith(
        receivedAt: received
            ? DateTime.utc(now.year, now.month, now.day)
            : null,
        transactionId: null,
      ),
    );
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'update',
      entity: 'expected_refund',
      rowId: refundId,
      before: current,
      after: saved,
    );
    return saved;
  }

  Future<void> remove(Session session, int refundId) async {
    final current = await _find(session, refundId, null);
    await Access.requireMember(
      session,
      current.groupId,
      min: MemberRole.user,
    );
    await ExpectedRefund.db.deleteRow(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'delete',
      entity: 'expected_refund',
      rowId: refundId,
      before: current,
    );
  }

  static Future<ExpectedRefund> _find(
    Session session,
    int id,
    int? groupId,
  ) async {
    final r = await ExpectedRefund.db.findById(session, id);
    if (r == null || (groupId != null && r.groupId != groupId)) {
      throw AccessDeniedException(code: 'refund_access_denied');
    }
    return r;
  }
}
