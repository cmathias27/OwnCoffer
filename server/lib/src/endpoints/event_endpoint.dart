import 'package:serverpod/serverpod.dart';

import '../finance/plan_inputs.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Life events (wedding, move, holiday) gathering their operations, with an
/// optional budget (decision 0050). Totals count the visible accounts only.
class EventEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// The events, the latest first, with the total of their operations.
  Future<List<LifeEventInfo>> list(Session session, int groupId) async {
    final visible = await Access.visibleAccounts(session, groupId);
    final events = await LifeEvent.db.find(
      session,
      where: (e) => e.groupId.equals(groupId),
      orderByList: (e) => [e.startDate.desc(), e.id.desc()],
    );
    if (events.isEmpty) return [];
    final Set<int> eventIds = {for (final e in events) e.id!};
    final links = await EventOperation.db.find(
      session,
      where: (l) => l.eventId.inSet(eventIds),
    );
    final Set<int> accountIds = {for (final a in visible) a.id!};
    final Set<int> txIds = {for (final l in links) l.transactionId};
    final txs = txIds.isEmpty || accountIds.isEmpty
        ? <BankTransaction>[]
        : await BankTransaction.db.find(
            session,
            where: (t) =>
                t.id.inSet(txIds) &
                t.accountId.inSet(accountIds) &
                t.deletedAt.equals(null),
          );
    final amount = {for (final t in txs) t.id!: t.amountCents};
    return [
      for (final e in events)
        () {
          final mine = [
            for (final l in links)
              if (l.eventId == e.id && amount.containsKey(l.transactionId))
                amount[l.transactionId]!,
          ];
          return LifeEventInfo(
            event: e,
            totalCents: mine.fold(0, (a, b) => a + b),
            count: mine.length,
          );
        }(),
    ];
  }

  /// Creates ([event] without id) or changes an event.
  Future<LifeEvent> save(Session session, int groupId, LifeEvent event) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final current = event.id == null
        ? null
        : await _find(session, event.id!, groupId);
    final start = PlanInputs.day(event.startDate);
    final end = event.endDate == null ? null : PlanInputs.day(event.endDate!);
    if (end != null && end.isBefore(start)) {
      throw InvalidInputException(code: 'invalid_date', field: 'endDate');
    }
    final clean = LifeEvent(
      groupId: groupId,
      name: PlanInputs.text(event.name),
      startDate: start,
      endDate: end,
      budgetCents: event.budgetCents == null
          ? null
          : PlanInputs.cents(event.budgetCents!),
    );
    final saved = current == null
        ? await LifeEvent.db.insertRow(session, clean)
        : await LifeEvent.db.updateRow(
            session,
            clean.copyWith(id: current.id, createdAt: current.createdAt),
          );
    await Audit.log(
      session,
      groupId: groupId,
      action: current == null ? 'create' : 'update',
      entity: 'life_event',
      rowId: saved.id,
      before: current,
      after: saved,
    );
    return saved;
  }

  Future<void> remove(Session session, int eventId) async {
    final current = await _find(session, eventId, null);
    await Access.requireMember(
      session,
      current.groupId,
      min: MemberRole.user,
    );
    await LifeEvent.db.deleteRow(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'delete',
      entity: 'life_event',
      rowId: eventId,
      before: current,
    );
  }

  /// Operations of the event on the visible accounts, by date.
  Future<List<BankTransaction>> operations(
    Session session,
    int eventId,
  ) async {
    final event = await _find(session, eventId, null);
    final visible = await Access.visibleAccounts(session, event.groupId);
    final Set<int> txIds = {
      for (final l in await EventOperation.db.find(
        session,
        where: (l) => l.eventId.equals(eventId),
      ))
        l.transactionId,
    };
    final Set<int> accountIds = {for (final a in visible) a.id!};
    if (txIds.isEmpty || accountIds.isEmpty) return [];
    return BankTransaction.db.find(
      session,
      where: (t) =>
          t.id.inSet(txIds) &
          t.accountId.inSet(accountIds) &
          t.deletedAt.equals(null),
      orderBy: (t) => t.date,
    );
  }

  /// Adds operations of visible accounts of the group to the event; those
  /// already in are left alone. Returns how many were added.
  Future<int> attach(
    Session session,
    int eventId,
    List<int> transactionIds,
  ) async {
    final event = await _find(session, eventId, null);
    await Access.requireMember(session, event.groupId, min: MemberRole.user);
    if (transactionIds.isEmpty) return 0;
    if (transactionIds.length > 500) {
      throw InvalidInputException(code: 'too_many', field: 'transactionIds');
    }
    final visible = await Access.visibleAccounts(session, event.groupId);
    final Set<int> accountIds = {for (final a in visible) a.id!};
    final Set<int> wanted = {...transactionIds};
    final found = await BankTransaction.db.find(
      session,
      where: (t) => t.id.inSet(wanted) & t.deletedAt.equals(null),
    );
    if (found.length != wanted.length ||
        found.any((t) => !accountIds.contains(t.accountId))) {
      throw AccessDeniedException(code: 'transaction_access_denied');
    }
    final already = {
      for (final l in await EventOperation.db.find(
        session,
        where: (l) => l.eventId.equals(eventId) & l.transactionId.inSet(wanted),
      ))
        l.transactionId,
    };
    final added = [
      for (final id in wanted)
        if (!already.contains(id))
          EventOperation(eventId: eventId, transactionId: id),
    ];
    if (added.isEmpty) return 0;
    final saved = await EventOperation.db.insert(session, added);
    for (final link in saved) {
      await Audit.log(
        session,
        groupId: event.groupId,
        action: 'create',
        entity: 'event_operation',
        rowId: link.id,
        after: link,
      );
    }
    return saved.length;
  }

  Future<void> detach(Session session, int eventId, int transactionId) async {
    final event = await _find(session, eventId, null);
    await Access.requireMember(session, event.groupId, min: MemberRole.user);
    final link = await EventOperation.db.findFirstRow(
      session,
      where: (l) =>
          l.eventId.equals(eventId) & l.transactionId.equals(transactionId),
    );
    if (link == null) return;
    await EventOperation.db.deleteRow(session, link);
    await Audit.log(
      session,
      groupId: event.groupId,
      action: 'delete',
      entity: 'event_operation',
      rowId: link.id,
      before: link,
    );
  }

  static Future<LifeEvent> _find(Session session, int id, int? groupId) async {
    final e = await LifeEvent.db.findById(session, id);
    if (e == null || (groupId != null && e.groupId != groupId)) {
      throw AccessDeniedException(code: 'event_access_denied');
    }
    return e;
  }
}
