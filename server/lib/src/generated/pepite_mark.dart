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

/// Something done that leaves no other trace, for a badge of Pépite
/// (decision 0028, point 1): a month review looked at, an unlock by
/// fingerprint or Windows Hello, a backup of the standalone app.
abstract class PepiteMark
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PepiteMark._({
    this.id,
    required this.authUserId,
    required this.code,
    required this.key,
    required this.markedAt,
  });

  factory PepiteMark({
    int? id,
    required _is.UuidValue authUserId,
    required String code,
    required String key,
    required DateTime markedAt,
  }) = _PepiteMarkImpl;

  factory PepiteMark.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteMark(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      code: jsonSerialization['code'] as String,
      key: jsonSerialization['key'] as String,
      markedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['markedAt'],
      ),
    );
  }

  static final t = PepiteMarkTable();

  static const db = PepiteMarkRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  /// What was done: `month_review`, `device_unlock`, `backup`.
  String code;

  /// Which one (the month of a review); '' when only once matters.
  String key;

  DateTime markedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PepiteMark]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteMark copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? code,
    String? key,
    DateTime? markedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteMark',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'code': code,
      'key': key,
      'markedAt': markedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PepiteMarkInclude include() {
    return PepiteMarkInclude._();
  }

  static PepiteMarkIncludeList includeList({
    _is.WhereExpressionBuilder<PepiteMarkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteMarkTable>? orderBy,
    _is.OrderByListBuilder<PepiteMarkTable>? orderByList,
    PepiteMarkInclude? include,
  }) {
    return PepiteMarkIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteMark.t),
      orderByList: orderByList?.call(PepiteMark.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteMarkImpl extends PepiteMark {
  _PepiteMarkImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String code,
    required String key,
    required DateTime markedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         code: code,
         key: key,
         markedAt: markedAt,
       );

  /// Returns a shallow copy of this [PepiteMark]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteMark copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? code,
    String? key,
    DateTime? markedAt,
  }) {
    return PepiteMark(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      code: code ?? this.code,
      key: key ?? this.key,
      markedAt: markedAt ?? this.markedAt,
    );
  }
}

class PepiteMarkUpdateTable extends _is.UpdateTable<PepiteMarkTable> {
  PepiteMarkUpdateTable(super.table);

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

  _is.ColumnValue<String, String> key(String value) => _is.ColumnValue(
    table.key,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> markedAt(DateTime value) =>
      _is.ColumnValue(
        table.markedAt,
        value,
      );
}

class PepiteMarkTable extends _is.Table<int?> {
  PepiteMarkTable({super.tableRelation}) : super(tableName: 'pepite_marks') {
    updateTable = PepiteMarkUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    key = _is.ColumnString(
      'key',
      this,
    );
    markedAt = _is.ColumnDateTime(
      'markedAt',
      this,
    );
  }

  late final PepiteMarkUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// What was done: `month_review`, `device_unlock`, `backup`.
  late final _is.ColumnString code;

  /// Which one (the month of a review); '' when only once matters.
  late final _is.ColumnString key;

  late final _is.ColumnDateTime markedAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    code,
    key,
    markedAt,
  ];
}

class PepiteMarkInclude extends _is.IncludeObject {
  PepiteMarkInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PepiteMark.t;
}

class PepiteMarkIncludeList extends _is.IncludeList {
  PepiteMarkIncludeList._({
    _is.WhereExpressionBuilder<PepiteMarkTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PepiteMark.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PepiteMark.t;
}

class PepiteMarkRepository {
  const PepiteMarkRepository._();

  /// Returns a list of [PepiteMark]s matching the given query parameters.
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
  Future<List<PepiteMark>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteMarkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteMarkTable>? orderBy,
    _is.OrderByListBuilder<PepiteMarkTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PepiteMark>(
      where: where?.call(PepiteMark.t),
      orderBy: orderBy?.call(PepiteMark.t),
      orderByList: orderByList?.call(PepiteMark.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PepiteMark] matching the given query parameters.
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
  Future<PepiteMark?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteMarkTable>? where,
    int? offset,
    _is.OrderByBuilder<PepiteMarkTable>? orderBy,
    _is.OrderByListBuilder<PepiteMarkTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PepiteMark>(
      where: where?.call(PepiteMark.t),
      orderBy: orderBy?.call(PepiteMark.t),
      orderByList: orderByList?.call(PepiteMark.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PepiteMark] by its [id] or null if no such row exists.
  Future<PepiteMark?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PepiteMark>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PepiteMark]s in the list and returns the inserted rows.
  ///
  /// The returned [PepiteMark]s will have their `id` fields set.
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
  Future<List<PepiteMark>> insert(
    _is.DatabaseSession session,
    List<PepiteMark> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PepiteMark>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PepiteMark] and returns the inserted row.
  ///
  /// The returned [PepiteMark] will have its `id` field set.
  Future<PepiteMark> insertRow(
    _is.DatabaseSession session,
    PepiteMark row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PepiteMark>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PepiteMark]s in the list and returns the resulting rows.
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
  /// The returned [PepiteMark]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteMark>> upsert(
    _is.DatabaseSession session,
    List<PepiteMark> rows, {
    required _is.ColumnSelections<PepiteMarkTable> conflictColumns,
    _is.ColumnSelections<PepiteMarkTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteMarkTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PepiteMark>(
      rows,
      conflictColumns: conflictColumns(PepiteMark.t),
      updateColumns: updateColumns?.call(PepiteMark.t),
      updateWhere: updateWhere?.call(PepiteMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PepiteMark] and returns the resulting row.
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
  /// The returned [PepiteMark] will have its `id` field set.
  Future<PepiteMark?> upsertRow(
    _is.DatabaseSession session,
    PepiteMark row, {
    required _is.ColumnSelections<PepiteMarkTable> conflictColumns,
    _is.ColumnSelections<PepiteMarkTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteMarkTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PepiteMark>(
      row,
      conflictColumns: conflictColumns(PepiteMark.t),
      updateColumns: updateColumns?.call(PepiteMark.t),
      updateWhere: updateWhere?.call(PepiteMark.t),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteMark]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteMark>> update(
    _is.DatabaseSession session,
    List<PepiteMark> rows, {
    _is.ColumnSelections<PepiteMarkTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PepiteMark>(
      rows,
      columns: columns?.call(PepiteMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PepiteMark]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PepiteMark> updateRow(
    _is.DatabaseSession session,
    PepiteMark row, {
    _is.ColumnSelections<PepiteMarkTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PepiteMark>(
      row,
      columns: columns?.call(PepiteMark.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PepiteMark] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PepiteMark?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PepiteMarkUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PepiteMark>(
      id,
      columnValues: columnValues(PepiteMark.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteMark]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteMark>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PepiteMarkUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PepiteMarkTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteMarkTable>? orderBy,
    _is.OrderByListBuilder<PepiteMarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PepiteMark>(
      columnValues: columnValues(PepiteMark.t.updateTable),
      where: where(PepiteMark.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteMark.t),
      orderByList: orderByList?.call(PepiteMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PepiteMark]s in the list and returns the deleted rows.
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
  Future<List<PepiteMark>> delete(
    _is.DatabaseSession session,
    List<PepiteMark> rows, {
    _is.OrderByBuilder<PepiteMarkTable>? orderBy,
    _is.OrderByListBuilder<PepiteMarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PepiteMark>(
      rows,
      orderBy: orderBy?.call(PepiteMark.t),
      orderByList: orderByList?.call(PepiteMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PepiteMark].
  Future<PepiteMark> deleteRow(
    _is.DatabaseSession session,
    PepiteMark row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PepiteMark>(
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
  Future<List<PepiteMark>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteMarkTable> where,
    _is.OrderByBuilder<PepiteMarkTable>? orderBy,
    _is.OrderByListBuilder<PepiteMarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PepiteMark>(
      where: where(PepiteMark.t),
      orderBy: orderBy?.call(PepiteMark.t),
      orderByList: orderByList?.call(PepiteMark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteMarkTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PepiteMark>(
      where: where?.call(PepiteMark.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PepiteMark] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteMarkTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PepiteMark>(
      where: where(PepiteMark.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
