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

/// An operation counted in a life event.
abstract class EventOperation
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EventOperation._({
    this.id,
    required this.eventId,
    required this.transactionId,
  });

  factory EventOperation({
    int? id,
    required int eventId,
    required int transactionId,
  }) = _EventOperationImpl;

  factory EventOperation.fromJson(Map<String, dynamic> jsonSerialization) {
    return EventOperation(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int,
      transactionId: jsonSerialization['transactionId'] as int,
    );
  }

  static final t = EventOperationTable();

  static const db = EventOperationRepository._();

  @override
  int? id;

  int eventId;

  int transactionId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EventOperation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EventOperation copyWith({
    int? id,
    int? eventId,
    int? transactionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EventOperation',
      if (id != null) 'id': id,
      'eventId': eventId,
      'transactionId': transactionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EventOperation',
      if (id != null) 'id': id,
      'eventId': eventId,
      'transactionId': transactionId,
    };
  }

  static EventOperationInclude include() {
    return EventOperationInclude._();
  }

  static EventOperationIncludeList includeList({
    _is.WhereExpressionBuilder<EventOperationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EventOperationTable>? orderBy,
    _is.OrderByListBuilder<EventOperationTable>? orderByList,
    EventOperationInclude? include,
  }) {
    return EventOperationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EventOperation.t),
      orderByList: orderByList?.call(EventOperation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventOperationImpl extends EventOperation {
  _EventOperationImpl({
    int? id,
    required int eventId,
    required int transactionId,
  }) : super._(
         id: id,
         eventId: eventId,
         transactionId: transactionId,
       );

  /// Returns a shallow copy of this [EventOperation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EventOperation copyWith({
    Object? id = _Undefined,
    int? eventId,
    int? transactionId,
  }) {
    return EventOperation(
      id: id is int? ? id : this.id,
      eventId: eventId ?? this.eventId,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}

class EventOperationUpdateTable extends _is.UpdateTable<EventOperationTable> {
  EventOperationUpdateTable(super.table);

  _is.ColumnValue<int, int> eventId(int value) => _is.ColumnValue(
    table.eventId,
    value,
  );

  _is.ColumnValue<int, int> transactionId(int value) => _is.ColumnValue(
    table.transactionId,
    value,
  );
}

class EventOperationTable extends _is.Table<int?> {
  EventOperationTable({super.tableRelation})
    : super(tableName: 'event_operations') {
    updateTable = EventOperationUpdateTable(this);
    eventId = _is.ColumnInt(
      'eventId',
      this,
    );
    transactionId = _is.ColumnInt(
      'transactionId',
      this,
    );
  }

  late final EventOperationUpdateTable updateTable;

  late final _is.ColumnInt eventId;

  late final _is.ColumnInt transactionId;

  @override
  List<_is.Column> get columns => [
    id,
    eventId,
    transactionId,
  ];
}

class EventOperationInclude extends _is.IncludeObject {
  EventOperationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EventOperation.t;
}

class EventOperationIncludeList extends _is.IncludeList {
  EventOperationIncludeList._({
    _is.WhereExpressionBuilder<EventOperationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EventOperation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EventOperation.t;
}

class EventOperationRepository {
  const EventOperationRepository._();

  /// Returns a list of [EventOperation]s matching the given query parameters.
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
  Future<List<EventOperation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EventOperationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EventOperationTable>? orderBy,
    _is.OrderByListBuilder<EventOperationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EventOperation>(
      where: where?.call(EventOperation.t),
      orderBy: orderBy?.call(EventOperation.t),
      orderByList: orderByList?.call(EventOperation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EventOperation] matching the given query parameters.
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
  Future<EventOperation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EventOperationTable>? where,
    int? offset,
    _is.OrderByBuilder<EventOperationTable>? orderBy,
    _is.OrderByListBuilder<EventOperationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EventOperation>(
      where: where?.call(EventOperation.t),
      orderBy: orderBy?.call(EventOperation.t),
      orderByList: orderByList?.call(EventOperation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EventOperation] by its [id] or null if no such row exists.
  Future<EventOperation?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EventOperation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EventOperation]s in the list and returns the inserted rows.
  ///
  /// The returned [EventOperation]s will have their `id` fields set.
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
  Future<List<EventOperation>> insert(
    _is.DatabaseSession session,
    List<EventOperation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EventOperation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EventOperation] and returns the inserted row.
  ///
  /// The returned [EventOperation] will have its `id` field set.
  Future<EventOperation> insertRow(
    _is.DatabaseSession session,
    EventOperation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EventOperation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EventOperation]s in the list and returns the resulting rows.
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
  /// The returned [EventOperation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EventOperation>> upsert(
    _is.DatabaseSession session,
    List<EventOperation> rows, {
    required _is.ColumnSelections<EventOperationTable> conflictColumns,
    _is.ColumnSelections<EventOperationTable>? updateColumns,
    _is.WhereExpressionBuilder<EventOperationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EventOperation>(
      rows,
      conflictColumns: conflictColumns(EventOperation.t),
      updateColumns: updateColumns?.call(EventOperation.t),
      updateWhere: updateWhere?.call(EventOperation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EventOperation] and returns the resulting row.
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
  /// The returned [EventOperation] will have its `id` field set.
  Future<EventOperation?> upsertRow(
    _is.DatabaseSession session,
    EventOperation row, {
    required _is.ColumnSelections<EventOperationTable> conflictColumns,
    _is.ColumnSelections<EventOperationTable>? updateColumns,
    _is.WhereExpressionBuilder<EventOperationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EventOperation>(
      row,
      conflictColumns: conflictColumns(EventOperation.t),
      updateColumns: updateColumns?.call(EventOperation.t),
      updateWhere: updateWhere?.call(EventOperation.t),
      transaction: transaction,
    );
  }

  /// Updates all [EventOperation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EventOperation>> update(
    _is.DatabaseSession session,
    List<EventOperation> rows, {
    _is.ColumnSelections<EventOperationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EventOperation>(
      rows,
      columns: columns?.call(EventOperation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EventOperation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EventOperation> updateRow(
    _is.DatabaseSession session,
    EventOperation row, {
    _is.ColumnSelections<EventOperationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EventOperation>(
      row,
      columns: columns?.call(EventOperation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EventOperation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EventOperation?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EventOperationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EventOperation>(
      id,
      columnValues: columnValues(EventOperation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EventOperation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EventOperation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EventOperationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EventOperationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EventOperationTable>? orderBy,
    _is.OrderByListBuilder<EventOperationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EventOperation>(
      columnValues: columnValues(EventOperation.t.updateTable),
      where: where(EventOperation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EventOperation.t),
      orderByList: orderByList?.call(EventOperation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EventOperation]s in the list and returns the deleted rows.
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
  Future<List<EventOperation>> delete(
    _is.DatabaseSession session,
    List<EventOperation> rows, {
    _is.OrderByBuilder<EventOperationTable>? orderBy,
    _is.OrderByListBuilder<EventOperationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EventOperation>(
      rows,
      orderBy: orderBy?.call(EventOperation.t),
      orderByList: orderByList?.call(EventOperation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EventOperation].
  Future<EventOperation> deleteRow(
    _is.DatabaseSession session,
    EventOperation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EventOperation>(
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
  Future<List<EventOperation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EventOperationTable> where,
    _is.OrderByBuilder<EventOperationTable>? orderBy,
    _is.OrderByListBuilder<EventOperationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EventOperation>(
      where: where(EventOperation.t),
      orderBy: orderBy?.call(EventOperation.t),
      orderByList: orderByList?.call(EventOperation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EventOperationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EventOperation>(
      where: where?.call(EventOperation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EventOperation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EventOperationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EventOperation>(
      where: where(EventOperation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
