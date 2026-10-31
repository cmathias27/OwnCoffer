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

/// Monthly spending goal of a category (its sub-categories included).
abstract class Goal implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Goal._({
    this.id,
    required this.groupId,
    required this.categoryId,
    required this.amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Goal({
    int? id,
    required int groupId,
    required int categoryId,
    required int amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GoalImpl;

  factory Goal.fromJson(Map<String, dynamic> jsonSerialization) {
    return Goal(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      categoryId: jsonSerialization['categoryId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = GoalTable();

  static const db = GoalRepository._();

  @override
  int? id;

  int groupId;

  int categoryId;

  int amountCents;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Goal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Goal copyWith({
    int? id,
    int? groupId,
    int? categoryId,
    int? amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Goal',
      if (id != null) 'id': id,
      'groupId': groupId,
      'categoryId': categoryId,
      'amountCents': amountCents,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Goal',
      if (id != null) 'id': id,
      'groupId': groupId,
      'categoryId': categoryId,
      'amountCents': amountCents,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static GoalInclude include() {
    return GoalInclude._();
  }

  static GoalIncludeList includeList({
    _is.WhereExpressionBuilder<GoalTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GoalTable>? orderBy,
    _is.OrderByListBuilder<GoalTable>? orderByList,
    GoalInclude? include,
  }) {
    return GoalIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Goal.t),
      orderByList: orderByList?.call(Goal.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoalImpl extends Goal {
  _GoalImpl({
    int? id,
    required int groupId,
    required int categoryId,
    required int amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         categoryId: categoryId,
         amountCents: amountCents,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Goal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Goal copyWith({
    Object? id = _Undefined,
    int? groupId,
    int? categoryId,
    int? amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      categoryId: categoryId ?? this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class GoalUpdateTable extends _is.UpdateTable<GoalTable> {
  GoalUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<int, int> categoryId(int value) => _is.ColumnValue(
    table.categoryId,
    value,
  );

  _is.ColumnValue<int, int> amountCents(int value) => _is.ColumnValue(
    table.amountCents,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class GoalTable extends _is.Table<int?> {
  GoalTable({super.tableRelation}) : super(tableName: 'goals') {
    updateTable = GoalUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    categoryId = _is.ColumnInt(
      'categoryId',
      this,
    );
    amountCents = _is.ColumnInt(
      'amountCents',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final GoalUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnInt categoryId;

  late final _is.ColumnInt amountCents;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    categoryId,
    amountCents,
    createdAt,
    updatedAt,
  ];
}

class GoalInclude extends _is.IncludeObject {
  GoalInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Goal.t;
}

class GoalIncludeList extends _is.IncludeList {
  GoalIncludeList._({
    _is.WhereExpressionBuilder<GoalTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Goal.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Goal.t;
}

class GoalRepository {
  const GoalRepository._();

  /// Returns a list of [Goal]s matching the given query parameters.
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
  Future<List<Goal>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GoalTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GoalTable>? orderBy,
    _is.OrderByListBuilder<GoalTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Goal>(
      where: where?.call(Goal.t),
      orderBy: orderBy?.call(Goal.t),
      orderByList: orderByList?.call(Goal.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Goal] matching the given query parameters.
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
  Future<Goal?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GoalTable>? where,
    int? offset,
    _is.OrderByBuilder<GoalTable>? orderBy,
    _is.OrderByListBuilder<GoalTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Goal>(
      where: where?.call(Goal.t),
      orderBy: orderBy?.call(Goal.t),
      orderByList: orderByList?.call(Goal.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Goal] by its [id] or null if no such row exists.
  Future<Goal?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Goal>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Goal]s in the list and returns the inserted rows.
  ///
  /// The returned [Goal]s will have their `id` fields set.
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
  Future<List<Goal>> insert(
    _is.DatabaseSession session,
    List<Goal> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Goal>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Goal] and returns the inserted row.
  ///
  /// The returned [Goal] will have its `id` field set.
  Future<Goal> insertRow(
    _is.DatabaseSession session,
    Goal row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Goal>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Goal]s in the list and returns the resulting rows.
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
  /// The returned [Goal]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Goal>> upsert(
    _is.DatabaseSession session,
    List<Goal> rows, {
    required _is.ColumnSelections<GoalTable> conflictColumns,
    _is.ColumnSelections<GoalTable>? updateColumns,
    _is.WhereExpressionBuilder<GoalTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Goal>(
      rows,
      conflictColumns: conflictColumns(Goal.t),
      updateColumns: updateColumns?.call(Goal.t),
      updateWhere: updateWhere?.call(Goal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Goal] and returns the resulting row.
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
  /// The returned [Goal] will have its `id` field set.
  Future<Goal?> upsertRow(
    _is.DatabaseSession session,
    Goal row, {
    required _is.ColumnSelections<GoalTable> conflictColumns,
    _is.ColumnSelections<GoalTable>? updateColumns,
    _is.WhereExpressionBuilder<GoalTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Goal>(
      row,
      conflictColumns: conflictColumns(Goal.t),
      updateColumns: updateColumns?.call(Goal.t),
      updateWhere: updateWhere?.call(Goal.t),
      transaction: transaction,
    );
  }

  /// Updates all [Goal]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Goal>> update(
    _is.DatabaseSession session,
    List<Goal> rows, {
    _is.ColumnSelections<GoalTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Goal>(
      rows,
      columns: columns?.call(Goal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Goal]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Goal> updateRow(
    _is.DatabaseSession session,
    Goal row, {
    _is.ColumnSelections<GoalTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Goal>(
      row,
      columns: columns?.call(Goal.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Goal] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Goal?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<GoalUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Goal>(
      id,
      columnValues: columnValues(Goal.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Goal]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Goal>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<GoalUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<GoalTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GoalTable>? orderBy,
    _is.OrderByListBuilder<GoalTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Goal>(
      columnValues: columnValues(Goal.t.updateTable),
      where: where(Goal.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Goal.t),
      orderByList: orderByList?.call(Goal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Goal]s in the list and returns the deleted rows.
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
  Future<List<Goal>> delete(
    _is.DatabaseSession session,
    List<Goal> rows, {
    _is.OrderByBuilder<GoalTable>? orderBy,
    _is.OrderByListBuilder<GoalTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Goal>(
      rows,
      orderBy: orderBy?.call(Goal.t),
      orderByList: orderByList?.call(Goal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Goal].
  Future<Goal> deleteRow(
    _is.DatabaseSession session,
    Goal row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Goal>(
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
  Future<List<Goal>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GoalTable> where,
    _is.OrderByBuilder<GoalTable>? orderBy,
    _is.OrderByListBuilder<GoalTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Goal>(
      where: where(Goal.t),
      orderBy: orderBy?.call(Goal.t),
      orderByList: orderByList?.call(Goal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GoalTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Goal>(
      where: where?.call(Goal.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Goal] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GoalTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Goal>(
      where: where(Goal.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
