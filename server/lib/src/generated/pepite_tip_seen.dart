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

/// A « Le savais-tu ? » tip the user has seen (decision 0028, point 12),
/// kept on the server so that another device does not show it again.
abstract class PepiteTipSeen
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PepiteTipSeen._({
    this.id,
    required this.authUserId,
    required this.code,
    required this.seenAt,
  });

  factory PepiteTipSeen({
    int? id,
    required _is.UuidValue authUserId,
    required String code,
    required DateTime seenAt,
  }) = _PepiteTipSeenImpl;

  factory PepiteTipSeen.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteTipSeen(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      code: jsonSerialization['code'] as String,
      seenAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['seenAt']),
    );
  }

  static final t = PepiteTipSeenTable();

  static const db = PepiteTipSeenRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  /// Code of the tip, from the app's catalogue (assets/tips/).
  String code;

  DateTime seenAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PepiteTipSeen]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteTipSeen copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? code,
    DateTime? seenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteTipSeen',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'code': code,
      'seenAt': seenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PepiteTipSeenInclude include() {
    return PepiteTipSeenInclude._();
  }

  static PepiteTipSeenIncludeList includeList({
    _is.WhereExpressionBuilder<PepiteTipSeenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteTipSeenTable>? orderBy,
    _is.OrderByListBuilder<PepiteTipSeenTable>? orderByList,
    PepiteTipSeenInclude? include,
  }) {
    return PepiteTipSeenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteTipSeen.t),
      orderByList: orderByList?.call(PepiteTipSeen.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteTipSeenImpl extends PepiteTipSeen {
  _PepiteTipSeenImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String code,
    required DateTime seenAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         code: code,
         seenAt: seenAt,
       );

  /// Returns a shallow copy of this [PepiteTipSeen]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteTipSeen copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? code,
    DateTime? seenAt,
  }) {
    return PepiteTipSeen(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      code: code ?? this.code,
      seenAt: seenAt ?? this.seenAt,
    );
  }
}

class PepiteTipSeenUpdateTable extends _is.UpdateTable<PepiteTipSeenTable> {
  PepiteTipSeenUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> seenAt(DateTime value) => _is.ColumnValue(
    table.seenAt,
    value,
  );
}

class PepiteTipSeenTable extends _is.Table<int?> {
  PepiteTipSeenTable({super.tableRelation})
    : super(tableName: 'pepite_tips_seen') {
    updateTable = PepiteTipSeenUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    seenAt = _is.ColumnDateTime(
      'seenAt',
      this,
    );
  }

  late final PepiteTipSeenUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// Code of the tip, from the app's catalogue (assets/tips/).
  late final _is.ColumnString code;

  late final _is.ColumnDateTime seenAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    code,
    seenAt,
  ];
}

class PepiteTipSeenInclude extends _is.IncludeObject {
  PepiteTipSeenInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PepiteTipSeen.t;
}

class PepiteTipSeenIncludeList extends _is.IncludeList {
  PepiteTipSeenIncludeList._({
    _is.WhereExpressionBuilder<PepiteTipSeenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PepiteTipSeen.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PepiteTipSeen.t;
}

class PepiteTipSeenRepository {
  const PepiteTipSeenRepository._();

  /// Returns a list of [PepiteTipSeen]s matching the given query parameters.
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
  Future<List<PepiteTipSeen>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteTipSeenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteTipSeenTable>? orderBy,
    _is.OrderByListBuilder<PepiteTipSeenTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PepiteTipSeen>(
      where: where?.call(PepiteTipSeen.t),
      orderBy: orderBy?.call(PepiteTipSeen.t),
      orderByList: orderByList?.call(PepiteTipSeen.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PepiteTipSeen] matching the given query parameters.
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
  Future<PepiteTipSeen?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteTipSeenTable>? where,
    int? offset,
    _is.OrderByBuilder<PepiteTipSeenTable>? orderBy,
    _is.OrderByListBuilder<PepiteTipSeenTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PepiteTipSeen>(
      where: where?.call(PepiteTipSeen.t),
      orderBy: orderBy?.call(PepiteTipSeen.t),
      orderByList: orderByList?.call(PepiteTipSeen.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PepiteTipSeen] by its [id] or null if no such row exists.
  Future<PepiteTipSeen?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PepiteTipSeen>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PepiteTipSeen]s in the list and returns the inserted rows.
  ///
  /// The returned [PepiteTipSeen]s will have their `id` fields set.
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
  Future<List<PepiteTipSeen>> insert(
    _is.DatabaseSession session,
    List<PepiteTipSeen> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PepiteTipSeen>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PepiteTipSeen] and returns the inserted row.
  ///
  /// The returned [PepiteTipSeen] will have its `id` field set.
  Future<PepiteTipSeen> insertRow(
    _is.DatabaseSession session,
    PepiteTipSeen row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PepiteTipSeen>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PepiteTipSeen]s in the list and returns the resulting rows.
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
  /// The returned [PepiteTipSeen]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteTipSeen>> upsert(
    _is.DatabaseSession session,
    List<PepiteTipSeen> rows, {
    required _is.ColumnSelections<PepiteTipSeenTable> conflictColumns,
    _is.ColumnSelections<PepiteTipSeenTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteTipSeenTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PepiteTipSeen>(
      rows,
      conflictColumns: conflictColumns(PepiteTipSeen.t),
      updateColumns: updateColumns?.call(PepiteTipSeen.t),
      updateWhere: updateWhere?.call(PepiteTipSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PepiteTipSeen] and returns the resulting row.
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
  /// The returned [PepiteTipSeen] will have its `id` field set.
  Future<PepiteTipSeen?> upsertRow(
    _is.DatabaseSession session,
    PepiteTipSeen row, {
    required _is.ColumnSelections<PepiteTipSeenTable> conflictColumns,
    _is.ColumnSelections<PepiteTipSeenTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteTipSeenTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PepiteTipSeen>(
      row,
      conflictColumns: conflictColumns(PepiteTipSeen.t),
      updateColumns: updateColumns?.call(PepiteTipSeen.t),
      updateWhere: updateWhere?.call(PepiteTipSeen.t),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteTipSeen]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteTipSeen>> update(
    _is.DatabaseSession session,
    List<PepiteTipSeen> rows, {
    _is.ColumnSelections<PepiteTipSeenTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PepiteTipSeen>(
      rows,
      columns: columns?.call(PepiteTipSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PepiteTipSeen]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PepiteTipSeen> updateRow(
    _is.DatabaseSession session,
    PepiteTipSeen row, {
    _is.ColumnSelections<PepiteTipSeenTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PepiteTipSeen>(
      row,
      columns: columns?.call(PepiteTipSeen.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PepiteTipSeen] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PepiteTipSeen?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PepiteTipSeenUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PepiteTipSeen>(
      id,
      columnValues: columnValues(PepiteTipSeen.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteTipSeen]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteTipSeen>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PepiteTipSeenUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PepiteTipSeenTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteTipSeenTable>? orderBy,
    _is.OrderByListBuilder<PepiteTipSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PepiteTipSeen>(
      columnValues: columnValues(PepiteTipSeen.t.updateTable),
      where: where(PepiteTipSeen.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteTipSeen.t),
      orderByList: orderByList?.call(PepiteTipSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PepiteTipSeen]s in the list and returns the deleted rows.
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
  Future<List<PepiteTipSeen>> delete(
    _is.DatabaseSession session,
    List<PepiteTipSeen> rows, {
    _is.OrderByBuilder<PepiteTipSeenTable>? orderBy,
    _is.OrderByListBuilder<PepiteTipSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PepiteTipSeen>(
      rows,
      orderBy: orderBy?.call(PepiteTipSeen.t),
      orderByList: orderByList?.call(PepiteTipSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PepiteTipSeen].
  Future<PepiteTipSeen> deleteRow(
    _is.DatabaseSession session,
    PepiteTipSeen row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PepiteTipSeen>(
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
  Future<List<PepiteTipSeen>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteTipSeenTable> where,
    _is.OrderByBuilder<PepiteTipSeenTable>? orderBy,
    _is.OrderByListBuilder<PepiteTipSeenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PepiteTipSeen>(
      where: where(PepiteTipSeen.t),
      orderBy: orderBy?.call(PepiteTipSeen.t),
      orderByList: orderByList?.call(PepiteTipSeen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteTipSeenTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PepiteTipSeen>(
      where: where?.call(PepiteTipSeen.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PepiteTipSeen] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteTipSeenTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PepiteTipSeen>(
      where: where(PepiteTipSeen.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
