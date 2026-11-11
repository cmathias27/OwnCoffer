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

/// The challenge of the month chosen by a user (decision 0028, point 8;
/// decision 0030). One per month; dropped = row deleted (unless done).
abstract class PepiteChallengeRow
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PepiteChallengeRow._({
    this.id,
    required this.authUserId,
    required this.month,
    required this.code,
    required this.chosenAt,
    this.doneAt,
  });

  factory PepiteChallengeRow({
    int? id,
    required _is.UuidValue authUserId,
    required String month,
    required String code,
    required DateTime chosenAt,
    DateTime? doneAt,
  }) = _PepiteChallengeRowImpl;

  factory PepiteChallengeRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteChallengeRow(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      month: jsonSerialization['month'] as String,
      code: jsonSerialization['code'] as String,
      chosenAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['chosenAt'],
      ),
      doneAt: jsonSerialization['doneAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['doneAt']),
    );
  }

  static final t = PepiteChallengeRowTable();

  static const db = PepiteChallengeRowRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  /// `2026-11`.
  String month;

  /// A code of `pepiteChallenges` (shared).
  String code;

  DateTime chosenAt;

  DateTime? doneAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PepiteChallengeRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteChallengeRow copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? month,
    String? code,
    DateTime? chosenAt,
    DateTime? doneAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteChallengeRow',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'month': month,
      'code': code,
      'chosenAt': chosenAt.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PepiteChallengeRowInclude include() {
    return PepiteChallengeRowInclude._();
  }

  static PepiteChallengeRowIncludeList includeList({
    _is.WhereExpressionBuilder<PepiteChallengeRowTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteChallengeRowTable>? orderBy,
    _is.OrderByListBuilder<PepiteChallengeRowTable>? orderByList,
    PepiteChallengeRowInclude? include,
  }) {
    return PepiteChallengeRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteChallengeRow.t),
      orderByList: orderByList?.call(PepiteChallengeRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteChallengeRowImpl extends PepiteChallengeRow {
  _PepiteChallengeRowImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String month,
    required String code,
    required DateTime chosenAt,
    DateTime? doneAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         month: month,
         code: code,
         chosenAt: chosenAt,
         doneAt: doneAt,
       );

  /// Returns a shallow copy of this [PepiteChallengeRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteChallengeRow copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? month,
    String? code,
    DateTime? chosenAt,
    Object? doneAt = _Undefined,
  }) {
    return PepiteChallengeRow(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      month: month ?? this.month,
      code: code ?? this.code,
      chosenAt: chosenAt ?? this.chosenAt,
      doneAt: doneAt is DateTime? ? doneAt : this.doneAt,
    );
  }
}

class PepiteChallengeRowUpdateTable
    extends _is.UpdateTable<PepiteChallengeRowTable> {
  PepiteChallengeRowUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> month(String value) => _is.ColumnValue(
    table.month,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> chosenAt(DateTime value) =>
      _is.ColumnValue(
        table.chosenAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> doneAt(DateTime? value) =>
      _is.ColumnValue(
        table.doneAt,
        value,
      );
}

class PepiteChallengeRowTable extends _is.Table<int?> {
  PepiteChallengeRowTable({super.tableRelation})
    : super(tableName: 'pepite_challenges') {
    updateTable = PepiteChallengeRowUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    month = _is.ColumnString(
      'month',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    chosenAt = _is.ColumnDateTime(
      'chosenAt',
      this,
    );
    doneAt = _is.ColumnDateTime(
      'doneAt',
      this,
    );
  }

  late final PepiteChallengeRowUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// `2026-11`.
  late final _is.ColumnString month;

  /// A code of `pepiteChallenges` (shared).
  late final _is.ColumnString code;

  late final _is.ColumnDateTime chosenAt;

  late final _is.ColumnDateTime doneAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    month,
    code,
    chosenAt,
    doneAt,
  ];
}

class PepiteChallengeRowInclude extends _is.IncludeObject {
  PepiteChallengeRowInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PepiteChallengeRow.t;
}

class PepiteChallengeRowIncludeList extends _is.IncludeList {
  PepiteChallengeRowIncludeList._({
    _is.WhereExpressionBuilder<PepiteChallengeRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PepiteChallengeRow.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PepiteChallengeRow.t;
}

class PepiteChallengeRowRepository {
  const PepiteChallengeRowRepository._();

  /// Returns a list of [PepiteChallengeRow]s matching the given query parameters.
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
  Future<List<PepiteChallengeRow>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteChallengeRowTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteChallengeRowTable>? orderBy,
    _is.OrderByListBuilder<PepiteChallengeRowTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PepiteChallengeRow>(
      where: where?.call(PepiteChallengeRow.t),
      orderBy: orderBy?.call(PepiteChallengeRow.t),
      orderByList: orderByList?.call(PepiteChallengeRow.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PepiteChallengeRow] matching the given query parameters.
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
  Future<PepiteChallengeRow?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteChallengeRowTable>? where,
    int? offset,
    _is.OrderByBuilder<PepiteChallengeRowTable>? orderBy,
    _is.OrderByListBuilder<PepiteChallengeRowTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PepiteChallengeRow>(
      where: where?.call(PepiteChallengeRow.t),
      orderBy: orderBy?.call(PepiteChallengeRow.t),
      orderByList: orderByList?.call(PepiteChallengeRow.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PepiteChallengeRow] by its [id] or null if no such row exists.
  Future<PepiteChallengeRow?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PepiteChallengeRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PepiteChallengeRow]s in the list and returns the inserted rows.
  ///
  /// The returned [PepiteChallengeRow]s will have their `id` fields set.
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
  Future<List<PepiteChallengeRow>> insert(
    _is.DatabaseSession session,
    List<PepiteChallengeRow> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PepiteChallengeRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PepiteChallengeRow] and returns the inserted row.
  ///
  /// The returned [PepiteChallengeRow] will have its `id` field set.
  Future<PepiteChallengeRow> insertRow(
    _is.DatabaseSession session,
    PepiteChallengeRow row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PepiteChallengeRow>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PepiteChallengeRow]s in the list and returns the resulting rows.
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
  /// The returned [PepiteChallengeRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteChallengeRow>> upsert(
    _is.DatabaseSession session,
    List<PepiteChallengeRow> rows, {
    required _is.ColumnSelections<PepiteChallengeRowTable> conflictColumns,
    _is.ColumnSelections<PepiteChallengeRowTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteChallengeRowTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PepiteChallengeRow>(
      rows,
      conflictColumns: conflictColumns(PepiteChallengeRow.t),
      updateColumns: updateColumns?.call(PepiteChallengeRow.t),
      updateWhere: updateWhere?.call(PepiteChallengeRow.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PepiteChallengeRow] and returns the resulting row.
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
  /// The returned [PepiteChallengeRow] will have its `id` field set.
  Future<PepiteChallengeRow?> upsertRow(
    _is.DatabaseSession session,
    PepiteChallengeRow row, {
    required _is.ColumnSelections<PepiteChallengeRowTable> conflictColumns,
    _is.ColumnSelections<PepiteChallengeRowTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteChallengeRowTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PepiteChallengeRow>(
      row,
      conflictColumns: conflictColumns(PepiteChallengeRow.t),
      updateColumns: updateColumns?.call(PepiteChallengeRow.t),
      updateWhere: updateWhere?.call(PepiteChallengeRow.t),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteChallengeRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteChallengeRow>> update(
    _is.DatabaseSession session,
    List<PepiteChallengeRow> rows, {
    _is.ColumnSelections<PepiteChallengeRowTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PepiteChallengeRow>(
      rows,
      columns: columns?.call(PepiteChallengeRow.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PepiteChallengeRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PepiteChallengeRow> updateRow(
    _is.DatabaseSession session,
    PepiteChallengeRow row, {
    _is.ColumnSelections<PepiteChallengeRowTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PepiteChallengeRow>(
      row,
      columns: columns?.call(PepiteChallengeRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PepiteChallengeRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PepiteChallengeRow?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PepiteChallengeRowUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PepiteChallengeRow>(
      id,
      columnValues: columnValues(PepiteChallengeRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteChallengeRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteChallengeRow>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PepiteChallengeRowUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<PepiteChallengeRowTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteChallengeRowTable>? orderBy,
    _is.OrderByListBuilder<PepiteChallengeRowTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PepiteChallengeRow>(
      columnValues: columnValues(PepiteChallengeRow.t.updateTable),
      where: where(PepiteChallengeRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteChallengeRow.t),
      orderByList: orderByList?.call(PepiteChallengeRow.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PepiteChallengeRow]s in the list and returns the deleted rows.
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
  Future<List<PepiteChallengeRow>> delete(
    _is.DatabaseSession session,
    List<PepiteChallengeRow> rows, {
    _is.OrderByBuilder<PepiteChallengeRowTable>? orderBy,
    _is.OrderByListBuilder<PepiteChallengeRowTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PepiteChallengeRow>(
      rows,
      orderBy: orderBy?.call(PepiteChallengeRow.t),
      orderByList: orderByList?.call(PepiteChallengeRow.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PepiteChallengeRow].
  Future<PepiteChallengeRow> deleteRow(
    _is.DatabaseSession session,
    PepiteChallengeRow row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PepiteChallengeRow>(
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
  Future<List<PepiteChallengeRow>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteChallengeRowTable> where,
    _is.OrderByBuilder<PepiteChallengeRowTable>? orderBy,
    _is.OrderByListBuilder<PepiteChallengeRowTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PepiteChallengeRow>(
      where: where(PepiteChallengeRow.t),
      orderBy: orderBy?.call(PepiteChallengeRow.t),
      orderByList: orderByList?.call(PepiteChallengeRow.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteChallengeRowTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PepiteChallengeRow>(
      where: where?.call(PepiteChallengeRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PepiteChallengeRow] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteChallengeRowTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PepiteChallengeRow>(
      where: where(PepiteChallengeRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
