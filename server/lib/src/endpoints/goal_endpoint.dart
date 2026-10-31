import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Monthly spending goals per category.
class GoalEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  static const _maxCents = 100000000000;

  Future<List<Goal>> list(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    return Goal.db.find(
      session,
      where: (g) => g.groupId.equals(groupId),
      orderBy: (g) => g.id,
    );
  }

  /// Creates or changes the goal of an expense category.
  Future<Goal> set(
    Session session,
    int groupId,
    int categoryId,
    int amountCents,
  ) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final category = await Category.db.findById(session, categoryId);
    if (category == null ||
        category.groupId != groupId ||
        category.deletedAt != null) {
      throw AccessDeniedException(code: 'category_access_denied');
    }
    if (category.kind != CategoryKind.expense) {
      throw InvalidInputException(code: 'goal_expense_only');
    }
    if (amountCents <= 0 || amountCents > _maxCents) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    final current = await Goal.db.findFirstRow(
      session,
      where: (g) => g.categoryId.equals(categoryId),
    );
    final saved = current == null
        ? await Goal.db.insertRow(
            session,
            Goal(
              groupId: groupId,
              categoryId: categoryId,
              amountCents: amountCents,
            ),
          )
        : await Goal.db.updateRow(
            session,
            current.copyWith(
              amountCents: amountCents,
              updatedAt: DateTime.now().toUtc(),
            ),
          );
    await Audit.log(
      session,
      groupId: groupId,
      action: current == null ? 'create' : 'update',
      entity: 'goal',
      rowId: saved.id,
      before: current,
      after: saved,
    );
    return saved;
  }

  Future<void> remove(Session session, int groupId, int categoryId) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final current = await Goal.db.findFirstRow(
      session,
      where: (g) => g.categoryId.equals(categoryId) & g.groupId.equals(groupId),
    );
    if (current == null) return;
    await Goal.db.deleteRow(session, current);
    await Audit.log(
      session,
      groupId: groupId,
      action: 'delete',
      entity: 'goal',
      rowId: current.id,
      before: current,
    );
  }
}
