/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'member_role.dart' as _insyygng;

abstract class GroupMember
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  GroupMember._({
    this.id,
    required this.groupId,
    required this.authUserId,
    required this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory GroupMember({
    int? id,
    required int groupId,
    required _is.UuidValue authUserId,
    required _insyygng.MemberRole role,
    DateTime? createdAt,
  }) = _GroupMemberImpl;

  factory GroupMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return GroupMember(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      role: _insyygng.MemberRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = GroupMemberTable();

  static const db = GroupMemberRepository._();

  @override
  int? id;

  int groupId;

  _is.UuidValue authUserId;

  _insyygng.MemberRole role;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [GroupMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  GroupMember copyWith({
    int? id,
    int? groupId,
    _is.UuidValue? authUserId,
    _insyygng.MemberRole? role,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GroupMember',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GroupMember',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static GroupMemberInclude include() {
    return GroupMemberInclude._();
  }

  static GroupMemberIncludeList includeList({
    _is.WhereExpressionBuilder<GroupMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GroupMemberTable>? orderBy,
    _is.OrderByListBuilder<GroupMemberTable>? orderByList,
    GroupMemberInclude? include,
  }) {
    return GroupMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GroupMember.t),
      orderByList: orderByList?.call(GroupMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GroupMemberImpl extends GroupMember {
  _GroupMemberImpl({
    int? id,
    required int groupId,
    required _is.UuidValue authUserId,
    required _insyygng.MemberRole role,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         authUserId: authUserId,
         role: role,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [GroupMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  GroupMember copyWith({
    Object? id = _Undefined,
    int? groupId,
    _is.UuidValue? authUserId,
    _insyygng.MemberRole? role,
    DateTime? createdAt,
  }) {
    return GroupMember(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      authUserId: authUserId ?? this.authUserId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GroupMemberUpdateTable extends _is.UpdateTable<GroupMemberTable> {
  GroupMemberUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<_insyygng.MemberRole, _insyygng.MemberRole> role(
    _insyygng.MemberRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class GroupMemberTable extends _is.Table<int?> {
  GroupMemberTable({super.tableRelation}) : super(tableName: 'group_members') {
    updateTable = GroupMemberUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final GroupMemberUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnEnum<_insyygng.MemberRole> role;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    authUserId,
    role,
    createdAt,
  ];
}

class GroupMemberInclude extends _is.IncludeObject {
  GroupMemberInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => GroupMember.t;
}

class GroupMemberIncludeList extends _is.IncludeList {
  GroupMemberIncludeList._({
    _is.WhereExpressionBuilder<GroupMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GroupMember.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => GroupMember.t;
}

class GroupMemberRepository {
  const GroupMemberRepository._();

  /// Returns a list of [GroupMember]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<GroupMember>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GroupMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GroupMemberTable>? orderBy,
    _is.OrderByListBuilder<GroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GroupMember>(
      where: where?.call(GroupMember.t),
      orderBy: orderBy?.call(GroupMember.t),
      orderByList: orderByList?.call(GroupMember.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GroupMember] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<GroupMember?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GroupMemberTable>? where,
    int? offset,
    _is.OrderByBuilder<GroupMemberTable>? orderBy,
    _is.OrderByListBuilder<GroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GroupMember>(
      where: where?.call(GroupMember.t),
      orderBy: orderBy?.call(GroupMember.t),
      orderByList: orderByList?.call(GroupMember.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GroupMember] by its [id] or null if no such row exists.
  Future<GroupMember?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GroupMember>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GroupMember]s in the list and returns the inserted rows.
  ///
  /// The returned [GroupMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GroupMember>> insert(
    _is.DatabaseSession session,
    List<GroupMember> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<GroupMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [GroupMember] and returns the inserted row.
  ///
  /// The returned [GroupMember] will have its `id` field set.
  Future<GroupMember> insertRow(
    _is.DatabaseSession session,
    GroupMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<GroupMember>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [GroupMember]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [GroupMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GroupMember>> upsert(
    _is.DatabaseSession session,
    List<GroupMember> rows, {
    required _is.ColumnSelections<GroupMemberTable> conflictColumns,
    _is.ColumnSelections<GroupMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<GroupMemberTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<GroupMember>(
      rows,
      conflictColumns: conflictColumns(GroupMember.t),
      updateColumns: updateColumns?.call(GroupMember.t),
      updateWhere: updateWhere?.call(GroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [GroupMember] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [GroupMember] will have its `id` field set.
  Future<GroupMember?> upsertRow(
    _is.DatabaseSession session,
    GroupMember row, {
    required _is.ColumnSelections<GroupMemberTable> conflictColumns,
    _is.ColumnSelections<GroupMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<GroupMemberTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<GroupMember>(
      row,
      conflictColumns: conflictColumns(GroupMember.t),
      updateColumns: updateColumns?.call(GroupMember.t),
      updateWhere: updateWhere?.call(GroupMember.t),
      transaction: transaction,
    );
  }

  /// Updates all [GroupMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GroupMember>> update(
    _is.DatabaseSession session,
    List<GroupMember> rows, {
    _is.ColumnSelections<GroupMemberTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<GroupMember>(
      rows,
      columns: columns?.call(GroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [GroupMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GroupMember> updateRow(
    _is.DatabaseSession session,
    GroupMember row, {
    _is.ColumnSelections<GroupMemberTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<GroupMember>(
      row,
      columns: columns?.call(GroupMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GroupMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GroupMember?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<GroupMemberUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<GroupMember>(
      id,
      columnValues: columnValues(GroupMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GroupMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GroupMember>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<GroupMemberUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<GroupMemberTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GroupMemberTable>? orderBy,
    _is.OrderByListBuilder<GroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<GroupMember>(
      columnValues: columnValues(GroupMember.t.updateTable),
      where: where(GroupMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GroupMember.t),
      orderByList: orderByList?.call(GroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [GroupMember]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GroupMember>> delete(
    _is.DatabaseSession session,
    List<GroupMember> rows, {
    _is.OrderByBuilder<GroupMemberTable>? orderBy,
    _is.OrderByListBuilder<GroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<GroupMember>(
      rows,
      orderBy: orderBy?.call(GroupMember.t),
      orderByList: orderByList?.call(GroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [GroupMember].
  Future<GroupMember> deleteRow(
    _is.DatabaseSession session,
    GroupMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GroupMember>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GroupMember>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GroupMemberTable> where,
    _is.OrderByBuilder<GroupMemberTable>? orderBy,
    _is.OrderByListBuilder<GroupMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<GroupMember>(
      where: where(GroupMember.t),
      orderBy: orderBy?.call(GroupMember.t),
      orderByList: orderByList?.call(GroupMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GroupMemberTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<GroupMember>(
      where: where?.call(GroupMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GroupMember] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GroupMemberTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GroupMember>(
      where: where(GroupMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
