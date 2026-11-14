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

/// A life event (wedding, move, holiday) gathering its operations, with an
/// optional budget (decision 0050).
abstract class LifeEvent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LifeEvent._({
    this.id,
    required this.groupId,
    required this.name,
    required this.startDate,
    this.endDate,
    this.budgetCents,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LifeEvent({
    int? id,
    required int groupId,
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    int? budgetCents,
    DateTime? createdAt,
  }) = _LifeEventImpl;

  factory LifeEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return LifeEvent(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      name: jsonSerialization['name'] as String,
      startDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      budgetCents: jsonSerialization['budgetCents'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = LifeEventTable();

  static const db = LifeEventRepository._();

  @override
  int? id;

  int groupId;

  String name;

  DateTime startDate;

  DateTime? endDate;

  int? budgetCents;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LifeEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LifeEvent copyWith({
    int? id,
    int? groupId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? budgetCents,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LifeEvent',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (budgetCents != null) 'budgetCents': budgetCents,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LifeEvent',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (budgetCents != null) 'budgetCents': budgetCents,
      'createdAt': createdAt.toJson(),
    };
  }

  static LifeEventInclude include() {
    return LifeEventInclude._();
  }

  static LifeEventIncludeList includeList({
    _is.WhereExpressionBuilder<LifeEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LifeEventTable>? orderBy,
    _is.OrderByListBuilder<LifeEventTable>? orderByList,
    LifeEventInclude? include,
  }) {
    return LifeEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LifeEvent.t),
      orderByList: orderByList?.call(LifeEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LifeEventImpl extends LifeEvent {
  _LifeEventImpl({
    int? id,
    required int groupId,
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    int? budgetCents,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         name: name,
         startDate: startDate,
         endDate: endDate,
         budgetCents: budgetCents,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LifeEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LifeEvent copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? name,
    DateTime? startDate,
    Object? endDate = _Undefined,
    Object? budgetCents = _Undefined,
    DateTime? createdAt,
  }) {
    return LifeEvent(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      budgetCents: budgetCents is int? ? budgetCents : this.budgetCents,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LifeEventUpdateTable extends _is.UpdateTable<LifeEventTable> {
  LifeEventUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _is.ColumnValue(
        table.startDate,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _is.ColumnValue(
        table.endDate,
        value,
      );

  _is.ColumnValue<int, int> budgetCents(int? value) => _is.ColumnValue(
    table.budgetCents,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class LifeEventTable extends _is.Table<int?> {
  LifeEventTable({super.tableRelation}) : super(tableName: 'life_events') {
    updateTable = LifeEventUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    startDate = _is.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _is.ColumnDateTime(
      'endDate',
      this,
    );
    budgetCents = _is.ColumnInt(
      'budgetCents',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final LifeEventUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnString name;

  late final _is.ColumnDateTime startDate;

  late final _is.ColumnDateTime endDate;

  late final _is.ColumnInt budgetCents;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    name,
    startDate,
    endDate,
    budgetCents,
    createdAt,
  ];
}

class LifeEventInclude extends _is.IncludeObject {
  LifeEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LifeEvent.t;
}

class LifeEventIncludeList extends _is.IncludeList {
  LifeEventIncludeList._({
    _is.WhereExpressionBuilder<LifeEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LifeEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LifeEvent.t;
}

class LifeEventRepository {
  const LifeEventRepository._();

  /// Returns a list of [LifeEvent]s matching the given query parameters.
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
  Future<List<LifeEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LifeEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LifeEventTable>? orderBy,
    _is.OrderByListBuilder<LifeEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LifeEvent>(
      where: where?.call(LifeEvent.t),
      orderBy: orderBy?.call(LifeEvent.t),
      orderByList: orderByList?.call(LifeEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LifeEvent] matching the given query parameters.
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
  Future<LifeEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LifeEventTable>? where,
    int? offset,
    _is.OrderByBuilder<LifeEventTable>? orderBy,
    _is.OrderByListBuilder<LifeEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LifeEvent>(
      where: where?.call(LifeEvent.t),
      orderBy: orderBy?.call(LifeEvent.t),
      orderByList: orderByList?.call(LifeEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LifeEvent] by its [id] or null if no such row exists.
  Future<LifeEvent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LifeEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LifeEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [LifeEvent]s will have their `id` fields set.
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
  Future<List<LifeEvent>> insert(
    _is.DatabaseSession session,
    List<LifeEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LifeEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LifeEvent] and returns the inserted row.
  ///
  /// The returned [LifeEvent] will have its `id` field set.
  Future<LifeEvent> insertRow(
    _is.DatabaseSession session,
    LifeEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LifeEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LifeEvent]s in the list and returns the resulting rows.
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
  /// The returned [LifeEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LifeEvent>> upsert(
    _is.DatabaseSession session,
    List<LifeEvent> rows, {
    required _is.ColumnSelections<LifeEventTable> conflictColumns,
    _is.ColumnSelections<LifeEventTable>? updateColumns,
    _is.WhereExpressionBuilder<LifeEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LifeEvent>(
      rows,
      conflictColumns: conflictColumns(LifeEvent.t),
      updateColumns: updateColumns?.call(LifeEvent.t),
      updateWhere: updateWhere?.call(LifeEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LifeEvent] and returns the resulting row.
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
  /// The returned [LifeEvent] will have its `id` field set.
  Future<LifeEvent?> upsertRow(
    _is.DatabaseSession session,
    LifeEvent row, {
    required _is.ColumnSelections<LifeEventTable> conflictColumns,
    _is.ColumnSelections<LifeEventTable>? updateColumns,
    _is.WhereExpressionBuilder<LifeEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LifeEvent>(
      row,
      conflictColumns: conflictColumns(LifeEvent.t),
      updateColumns: updateColumns?.call(LifeEvent.t),
      updateWhere: updateWhere?.call(LifeEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [LifeEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LifeEvent>> update(
    _is.DatabaseSession session,
    List<LifeEvent> rows, {
    _is.ColumnSelections<LifeEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LifeEvent>(
      rows,
      columns: columns?.call(LifeEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LifeEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LifeEvent> updateRow(
    _is.DatabaseSession session,
    LifeEvent row, {
    _is.ColumnSelections<LifeEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LifeEvent>(
      row,
      columns: columns?.call(LifeEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LifeEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LifeEvent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LifeEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LifeEvent>(
      id,
      columnValues: columnValues(LifeEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LifeEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LifeEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LifeEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LifeEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LifeEventTable>? orderBy,
    _is.OrderByListBuilder<LifeEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LifeEvent>(
      columnValues: columnValues(LifeEvent.t.updateTable),
      where: where(LifeEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LifeEvent.t),
      orderByList: orderByList?.call(LifeEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LifeEvent]s in the list and returns the deleted rows.
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
  Future<List<LifeEvent>> delete(
    _is.DatabaseSession session,
    List<LifeEvent> rows, {
    _is.OrderByBuilder<LifeEventTable>? orderBy,
    _is.OrderByListBuilder<LifeEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LifeEvent>(
      rows,
      orderBy: orderBy?.call(LifeEvent.t),
      orderByList: orderByList?.call(LifeEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LifeEvent].
  Future<LifeEvent> deleteRow(
    _is.DatabaseSession session,
    LifeEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LifeEvent>(
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
  Future<List<LifeEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LifeEventTable> where,
    _is.OrderByBuilder<LifeEventTable>? orderBy,
    _is.OrderByListBuilder<LifeEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LifeEvent>(
      where: where(LifeEvent.t),
      orderBy: orderBy?.call(LifeEvent.t),
      orderByList: orderByList?.call(LifeEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LifeEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LifeEvent>(
      where: where?.call(LifeEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LifeEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LifeEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LifeEvent>(
      where: where(LifeEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
