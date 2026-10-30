import 'package:owncoffer_shared/owncoffer_shared.dart' as core;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// Categories of a group, linked to the standard catalogue.
class CategoryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  Future<List<Category>> list(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    return Category.db.find(
      session,
      where: (c) => c.groupId.equals(groupId) & c.deletedAt.equals(null),
      orderBy: (c) => c.id,
    );
  }

  Future<Category> create(
    Session session,
    int groupId,
    String name,
    CategoryKind kind, {
    int? parentId,
    String? standardCode,
  }) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    if (parentId != null) await _own(session, groupId, parentId);
    final category = await Category.db.insertRow(
      session,
      Category(
        groupId: groupId,
        parentId: parentId,
        name: _name(name),
        kind: kind,
        standardCode: _standard(standardCode),
      ),
    );
    await Audit.log(
      session,
      groupId: groupId,
      action: 'create',
      entity: 'category',
      rowId: category.id,
      after: category,
    );
    return category;
  }

  /// Renames (empty name = back to the standard name) and relinks to the
  /// standard catalogue.
  Future<Category> update(
    Session session,
    int categoryId, {
    String? name,
    bool? resetName,
    String? standardCode,
    String? color,
  }) async {
    final current = await _find(session, categoryId);
    await Access.requireMember(session, current.groupId, min: MemberRole.user);
    final updated = await Category.db.updateRow(
      session,
      current.copyWith(
        name: resetName == true
            ? null
            : (name == null ? current.name : _name(name)),
        standardCode: standardCode == null
            ? current.standardCode
            : _standard(standardCode),
        color: color ?? current.color,
      ),
    );
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'update',
      entity: 'category',
      rowId: categoryId,
      before: current,
      after: updated,
    );
    return updated;
  }

  /// Moves the category to the trash; its operations become "to classify"
  /// only if the user chooses so (they keep the link until purge).
  Future<void> archive(Session session, int categoryId) async {
    final current = await _find(session, categoryId);
    await Access.requireMember(session, current.groupId, min: MemberRole.user);
    await Category.db.updateRow(
      session,
      current.copyWith(deletedAt: DateTime.now().toUtc()),
    );
    await Audit.log(
      session,
      groupId: current.groupId,
      action: 'archive',
      entity: 'category',
      rowId: categoryId,
      before: current,
    );
  }

  static Future<Category> _find(Session session, int id) async {
    final c = await Category.db.findById(session, id);
    if (c == null || c.deletedAt != null) {
      throw AccessDeniedException(code: 'category_access_denied');
    }
    try {
      await Access.requireMember(session, c.groupId);
    } on AccessDeniedException {
      throw AccessDeniedException(code: 'category_access_denied');
    }
    return c;
  }

  static Future<void> _own(Session session, int groupId, int categoryId) async {
    final c = await Category.db.findById(session, categoryId);
    if (c == null || c.groupId != groupId || c.deletedAt != null) {
      throw AccessDeniedException(code: 'category_access_denied');
    }
  }

  static String _name(String name) {
    final t = name.trim();
    if (t.isEmpty || t.length > 80) {
      throw InvalidInputException(code: 'invalid_name', field: 'name');
    }
    return t;
  }

  static String? _standard(String? code) {
    if (code == null || code.isEmpty) return null;
    if (!core.standardCategoriesById.containsKey(code)) {
      throw InvalidInputException(code: 'unknown_standard_category');
    }
    return code;
  }
}

/// Creates the categories of a new group from the standard catalogue.
Future<void> createDefaultCategories(
  Session session,
  int groupId, {
  Transaction? transaction,
}) async {
  final idOf = <String, int>{};
  for (final def in core.standardCategories.where((c) => !c.deprecated)) {
    final row = await Category.db.insertRow(
      session,
      Category(
        groupId: groupId,
        parentId: def.parent == null ? null : idOf[def.parent],
        kind: CategoryKind.values.byName(def.kind.name),
        standardCode: def.id,
        icon: def.icon,
      ),
      transaction: transaction,
    );
    idOf[def.id] = row.id!;
  }
}
