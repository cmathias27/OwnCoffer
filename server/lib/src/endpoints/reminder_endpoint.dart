import 'package:serverpod/serverpod.dart';

import '../finance/plan_inputs.dart';
import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Free reminders of a member, notified on their day (decision 0050). Each
/// member sees only their own.
class ReminderEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  /// The user's reminders in the group: to do by date, then those done in
  /// the last 30 days.
  Future<List<Reminder>> list(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    final user = Access.userId(session);
    final rows = await Reminder.db.find(
      session,
      where: (r) => r.groupId.equals(groupId) & r.authUserId.equals(user),
      orderBy: (r) => r.dueDate,
    );
    final since = DateTime.now().toUtc().subtract(const Duration(days: 30));
    return [
      for (final r in rows)
        if (r.doneAt == null) r,
      for (final r in rows.reversed)
        if (r.doneAt != null && r.doneAt!.isAfter(since)) r,
    ];
  }

  /// Creates ([reminder] without id) or changes one of the user's.
  Future<Reminder> save(Session session, int groupId, Reminder reminder) async {
    await Access.requireMember(session, groupId);
    final current = reminder.id == null
        ? null
        : await _find(session, reminder.id!);
    if (current != null && current.groupId != groupId) {
      throw AccessDeniedException(code: 'reminder_access_denied');
    }
    final clean = Reminder(
      groupId: groupId,
      authUserId: Access.userId(session),
      text: PlanInputs.text(reminder.text, field: 'text', max: 200),
      dueDate: PlanInputs.day(reminder.dueDate),
      doneAt: current?.doneAt,
    );
    final saved = current == null
        ? await Reminder.db.insertRow(session, clean)
        : await Reminder.db.updateRow(
            session,
            clean.copyWith(id: current.id, createdAt: current.createdAt),
          );
    await Audit.log(
      session,
      groupId: groupId,
      action: current == null ? 'create' : 'update',
      entity: 'reminder',
      rowId: saved.id,
      before: current,
      after: saved,
    );
    return saved;
  }

  Future<Reminder> setDone(Session session, int reminderId, bool done) async {
    final current = await _find(session, reminderId);
    final saved = await Reminder.db.updateRow(
      session,
      current.copyWith(doneAt: done ? DateTime.now().toUtc() : null),
    );
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'update',
      entity: 'reminder',
      rowId: reminderId,
      before: current,
      after: saved,
    );
    return saved;
  }

  Future<void> remove(Session session, int reminderId) async {
    final current = await _find(session, reminderId);
    await Reminder.db.deleteRow(session, current);
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'delete',
      entity: 'reminder',
      rowId: reminderId,
      before: current,
    );
  }

  /// One of the user's reminders, in a group they still belong to.
  static Future<Reminder> _find(Session session, int id) async {
    final r = await Reminder.db.findById(session, id);
    if (r == null || r.authUserId != Access.userId(session)) {
      throw AccessDeniedException(code: 'reminder_access_denied');
    }
    await Access.requireMember(session, r.groupId);
    return r;
  }
}
