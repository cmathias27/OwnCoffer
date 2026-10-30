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

/// A group (household, association…) owning accounts, categories and rules.
abstract class FinanceGroup
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  FinanceGroup._({
    this.id,
    required this.name,
    bool? aiEnabled,
    required this.createdBy,
    DateTime? createdAt,
  }) : aiEnabled = aiEnabled ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory FinanceGroup({
    int? id,
    required String name,
    bool? aiEnabled,
    required _is.UuidValue createdBy,
    DateTime? createdAt,
  }) = _FinanceGroupImpl;

  factory FinanceGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return FinanceGroup(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      aiEnabled: jsonSerialization['aiEnabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['aiEnabled']),
      createdBy: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = FinanceGroupTable();

  static const db = FinanceGroupRepository._();

  @override
  int? id;

  String name;

  /// Optional AI (decision 0006): off by default.
  bool aiEnabled;

  _is.UuidValue createdBy;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FinanceGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FinanceGroup copyWith({
    int? id,
    String? name,
    bool? aiEnabled,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FinanceGroup',
      if (id != null) 'id': id,
      'name': name,
      'aiEnabled': aiEnabled,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FinanceGroup',
      if (id != null) 'id': id,
      'name': name,
      'aiEnabled': aiEnabled,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static FinanceGroupInclude include() {
    return FinanceGroupInclude._();
  }

  static FinanceGroupIncludeList includeList({
    _is.WhereExpressionBuilder<FinanceGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FinanceGroupTable>? orderBy,
    _is.OrderByListBuilder<FinanceGroupTable>? orderByList,
    FinanceGroupInclude? include,
  }) {
    return FinanceGroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FinanceGroup.t),
      orderByList: orderByList?.call(FinanceGroup.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FinanceGroupImpl extends FinanceGroup {
  _FinanceGroupImpl({
    int? id,
    required String name,
    bool? aiEnabled,
    required _is.UuidValue createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         aiEnabled: aiEnabled,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FinanceGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FinanceGroup copyWith({
    Object? id = _Undefined,
    String? name,
    bool? aiEnabled,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  }) {
    return FinanceGroup(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class FinanceGroupUpdateTable extends _is.UpdateTable<FinanceGroupTable> {
  FinanceGroupUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<bool, bool> aiEnabled(bool value) => _is.ColumnValue(
    table.aiEnabled,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createdBy(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.createdBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class FinanceGroupTable extends _is.Table<int?> {
  FinanceGroupTable({super.tableRelation}) : super(tableName: 'groups') {
    updateTable = FinanceGroupUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    aiEnabled = _is.ColumnBool(
      'aiEnabled',
      this,
      hasDefault: true,
    );
    createdBy = _is.ColumnUuid(
      'createdBy',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final FinanceGroupUpdateTable updateTable;

  late final _is.ColumnString name;

  /// Optional AI (decision 0006): off by default.
  late final _is.ColumnBool aiEnabled;

  late final _is.ColumnUuid createdBy;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    aiEnabled,
    createdBy,
    createdAt,
  ];
}

class FinanceGroupInclude extends _is.IncludeObject {
  FinanceGroupInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => FinanceGroup.t;
}

class FinanceGroupIncludeList extends _is.IncludeList {
  FinanceGroupIncludeList._({
    _is.WhereExpressionBuilder<FinanceGroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FinanceGroup.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FinanceGroup.t;
}

class FinanceGroupRepository {
  const FinanceGroupRepository._();

  /// Returns a list of [FinanceGroup]s matching the given query parameters.
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
  Future<List<FinanceGroup>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FinanceGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FinanceGroupTable>? orderBy,
    _is.OrderByListBuilder<FinanceGroupTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FinanceGroup>(
      where: where?.call(FinanceGroup.t),
      orderBy: orderBy?.call(FinanceGroup.t),
      orderByList: orderByList?.call(FinanceGroup.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FinanceGroup] matching the given query parameters.
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
  Future<FinanceGroup?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FinanceGroupTable>? where,
    int? offset,
    _is.OrderByBuilder<FinanceGroupTable>? orderBy,
    _is.OrderByListBuilder<FinanceGroupTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FinanceGroup>(
      where: where?.call(FinanceGroup.t),
      orderBy: orderBy?.call(FinanceGroup.t),
      orderByList: orderByList?.call(FinanceGroup.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FinanceGroup] by its [id] or null if no such row exists.
  Future<FinanceGroup?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FinanceGroup>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FinanceGroup]s in the list and returns the inserted rows.
  ///
  /// The returned [FinanceGroup]s will have their `id` fields set.
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
  Future<List<FinanceGroup>> insert(
    _is.DatabaseSession session,
    List<FinanceGroup> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FinanceGroup>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FinanceGroup] and returns the inserted row.
  ///
  /// The returned [FinanceGroup] will have its `id` field set.
  Future<FinanceGroup> insertRow(
    _is.DatabaseSession session,
    FinanceGroup row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FinanceGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FinanceGroup]s in the list and returns the resulting rows.
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
  /// The returned [FinanceGroup]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FinanceGroup>> upsert(
    _is.DatabaseSession session,
    List<FinanceGroup> rows, {
    required _is.ColumnSelections<FinanceGroupTable> conflictColumns,
    _is.ColumnSelections<FinanceGroupTable>? updateColumns,
    _is.WhereExpressionBuilder<FinanceGroupTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FinanceGroup>(
      rows,
      conflictColumns: conflictColumns(FinanceGroup.t),
      updateColumns: updateColumns?.call(FinanceGroup.t),
      updateWhere: updateWhere?.call(FinanceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FinanceGroup] and returns the resulting row.
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
  /// The returned [FinanceGroup] will have its `id` field set.
  Future<FinanceGroup?> upsertRow(
    _is.DatabaseSession session,
    FinanceGroup row, {
    required _is.ColumnSelections<FinanceGroupTable> conflictColumns,
    _is.ColumnSelections<FinanceGroupTable>? updateColumns,
    _is.WhereExpressionBuilder<FinanceGroupTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FinanceGroup>(
      row,
      conflictColumns: conflictColumns(FinanceGroup.t),
      updateColumns: updateColumns?.call(FinanceGroup.t),
      updateWhere: updateWhere?.call(FinanceGroup.t),
      transaction: transaction,
    );
  }

  /// Updates all [FinanceGroup]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FinanceGroup>> update(
    _is.DatabaseSession session,
    List<FinanceGroup> rows, {
    _is.ColumnSelections<FinanceGroupTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FinanceGroup>(
      rows,
      columns: columns?.call(FinanceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FinanceGroup]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FinanceGroup> updateRow(
    _is.DatabaseSession session,
    FinanceGroup row, {
    _is.ColumnSelections<FinanceGroupTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FinanceGroup>(
      row,
      columns: columns?.call(FinanceGroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FinanceGroup] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FinanceGroup?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FinanceGroupUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FinanceGroup>(
      id,
      columnValues: columnValues(FinanceGroup.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FinanceGroup]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FinanceGroup>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FinanceGroupUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FinanceGroupTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FinanceGroupTable>? orderBy,
    _is.OrderByListBuilder<FinanceGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FinanceGroup>(
      columnValues: columnValues(FinanceGroup.t.updateTable),
      where: where(FinanceGroup.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FinanceGroup.t),
      orderByList: orderByList?.call(FinanceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FinanceGroup]s in the list and returns the deleted rows.
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
  Future<List<FinanceGroup>> delete(
    _is.DatabaseSession session,
    List<FinanceGroup> rows, {
    _is.OrderByBuilder<FinanceGroupTable>? orderBy,
    _is.OrderByListBuilder<FinanceGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FinanceGroup>(
      rows,
      orderBy: orderBy?.call(FinanceGroup.t),
      orderByList: orderByList?.call(FinanceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FinanceGroup].
  Future<FinanceGroup> deleteRow(
    _is.DatabaseSession session,
    FinanceGroup row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FinanceGroup>(
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
  Future<List<FinanceGroup>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FinanceGroupTable> where,
    _is.OrderByBuilder<FinanceGroupTable>? orderBy,
    _is.OrderByListBuilder<FinanceGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FinanceGroup>(
      where: where(FinanceGroup.t),
      orderBy: orderBy?.call(FinanceGroup.t),
      orderByList: orderByList?.call(FinanceGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FinanceGroupTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FinanceGroup>(
      where: where?.call(FinanceGroup.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FinanceGroup] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FinanceGroupTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FinanceGroup>(
      where: where(FinanceGroup.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
