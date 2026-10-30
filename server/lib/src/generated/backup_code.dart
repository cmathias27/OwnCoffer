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

/// One-time backup code, stored hashed.
abstract class BackupCode
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BackupCode._({
    this.id,
    required this.authUserId,
    required this.codeHash,
    this.usedAt,
  });

  factory BackupCode({
    int? id,
    required _is.UuidValue authUserId,
    required String codeHash,
    DateTime? usedAt,
  }) = _BackupCodeImpl;

  factory BackupCode.fromJson(Map<String, dynamic> jsonSerialization) {
    return BackupCode(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      codeHash: jsonSerialization['codeHash'] as String,
      usedAt: jsonSerialization['usedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['usedAt']),
    );
  }

  static final t = BackupCodeTable();

  static const db = BackupCodeRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String codeHash;

  DateTime? usedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BackupCode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BackupCode copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? codeHash,
    DateTime? usedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BackupCode',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'codeHash': codeHash,
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static BackupCodeInclude include() {
    return BackupCodeInclude._();
  }

  static BackupCodeIncludeList includeList({
    _is.WhereExpressionBuilder<BackupCodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupCodeTable>? orderBy,
    _is.OrderByListBuilder<BackupCodeTable>? orderByList,
    BackupCodeInclude? include,
  }) {
    return BackupCodeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BackupCode.t),
      orderByList: orderByList?.call(BackupCode.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BackupCodeImpl extends BackupCode {
  _BackupCodeImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String codeHash,
    DateTime? usedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         codeHash: codeHash,
         usedAt: usedAt,
       );

  /// Returns a shallow copy of this [BackupCode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BackupCode copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? codeHash,
    Object? usedAt = _Undefined,
  }) {
    return BackupCode(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      codeHash: codeHash ?? this.codeHash,
      usedAt: usedAt is DateTime? ? usedAt : this.usedAt,
    );
  }
}

class BackupCodeUpdateTable extends _is.UpdateTable<BackupCodeTable> {
  BackupCodeUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> codeHash(String value) => _is.ColumnValue(
    table.codeHash,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> usedAt(DateTime? value) =>
      _is.ColumnValue(
        table.usedAt,
        value,
      );
}

class BackupCodeTable extends _is.Table<int?> {
  BackupCodeTable({super.tableRelation})
    : super(tableName: 'totp_backup_codes') {
    updateTable = BackupCodeUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    codeHash = _is.ColumnString(
      'codeHash',
      this,
    );
    usedAt = _is.ColumnDateTime(
      'usedAt',
      this,
    );
  }

  late final BackupCodeUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString codeHash;

  late final _is.ColumnDateTime usedAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    codeHash,
    usedAt,
  ];
}

class BackupCodeInclude extends _is.IncludeObject {
  BackupCodeInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BackupCode.t;
}

class BackupCodeIncludeList extends _is.IncludeList {
  BackupCodeIncludeList._({
    _is.WhereExpressionBuilder<BackupCodeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BackupCode.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BackupCode.t;
}

class BackupCodeRepository {
  const BackupCodeRepository._();

  /// Returns a list of [BackupCode]s matching the given query parameters.
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
  Future<List<BackupCode>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupCodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupCodeTable>? orderBy,
    _is.OrderByListBuilder<BackupCodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BackupCode>(
      where: where?.call(BackupCode.t),
      orderBy: orderBy?.call(BackupCode.t),
      orderByList: orderByList?.call(BackupCode.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BackupCode] matching the given query parameters.
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
  Future<BackupCode?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupCodeTable>? where,
    int? offset,
    _is.OrderByBuilder<BackupCodeTable>? orderBy,
    _is.OrderByListBuilder<BackupCodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BackupCode>(
      where: where?.call(BackupCode.t),
      orderBy: orderBy?.call(BackupCode.t),
      orderByList: orderByList?.call(BackupCode.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BackupCode] by its [id] or null if no such row exists.
  Future<BackupCode?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BackupCode>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BackupCode]s in the list and returns the inserted rows.
  ///
  /// The returned [BackupCode]s will have their `id` fields set.
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
  Future<List<BackupCode>> insert(
    _is.DatabaseSession session,
    List<BackupCode> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BackupCode>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BackupCode] and returns the inserted row.
  ///
  /// The returned [BackupCode] will have its `id` field set.
  Future<BackupCode> insertRow(
    _is.DatabaseSession session,
    BackupCode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BackupCode>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BackupCode]s in the list and returns the resulting rows.
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
  /// The returned [BackupCode]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupCode>> upsert(
    _is.DatabaseSession session,
    List<BackupCode> rows, {
    required _is.ColumnSelections<BackupCodeTable> conflictColumns,
    _is.ColumnSelections<BackupCodeTable>? updateColumns,
    _is.WhereExpressionBuilder<BackupCodeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BackupCode>(
      rows,
      conflictColumns: conflictColumns(BackupCode.t),
      updateColumns: updateColumns?.call(BackupCode.t),
      updateWhere: updateWhere?.call(BackupCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BackupCode] and returns the resulting row.
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
  /// The returned [BackupCode] will have its `id` field set.
  Future<BackupCode?> upsertRow(
    _is.DatabaseSession session,
    BackupCode row, {
    required _is.ColumnSelections<BackupCodeTable> conflictColumns,
    _is.ColumnSelections<BackupCodeTable>? updateColumns,
    _is.WhereExpressionBuilder<BackupCodeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BackupCode>(
      row,
      conflictColumns: conflictColumns(BackupCode.t),
      updateColumns: updateColumns?.call(BackupCode.t),
      updateWhere: updateWhere?.call(BackupCode.t),
      transaction: transaction,
    );
  }

  /// Updates all [BackupCode]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupCode>> update(
    _is.DatabaseSession session,
    List<BackupCode> rows, {
    _is.ColumnSelections<BackupCodeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BackupCode>(
      rows,
      columns: columns?.call(BackupCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BackupCode]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BackupCode> updateRow(
    _is.DatabaseSession session,
    BackupCode row, {
    _is.ColumnSelections<BackupCodeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BackupCode>(
      row,
      columns: columns?.call(BackupCode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BackupCode] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BackupCode?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BackupCodeUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BackupCode>(
      id,
      columnValues: columnValues(BackupCode.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BackupCode]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupCode>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BackupCodeUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BackupCodeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupCodeTable>? orderBy,
    _is.OrderByListBuilder<BackupCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BackupCode>(
      columnValues: columnValues(BackupCode.t.updateTable),
      where: where(BackupCode.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BackupCode.t),
      orderByList: orderByList?.call(BackupCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BackupCode]s in the list and returns the deleted rows.
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
  Future<List<BackupCode>> delete(
    _is.DatabaseSession session,
    List<BackupCode> rows, {
    _is.OrderByBuilder<BackupCodeTable>? orderBy,
    _is.OrderByListBuilder<BackupCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BackupCode>(
      rows,
      orderBy: orderBy?.call(BackupCode.t),
      orderByList: orderByList?.call(BackupCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BackupCode].
  Future<BackupCode> deleteRow(
    _is.DatabaseSession session,
    BackupCode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BackupCode>(
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
  Future<List<BackupCode>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BackupCodeTable> where,
    _is.OrderByBuilder<BackupCodeTable>? orderBy,
    _is.OrderByListBuilder<BackupCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BackupCode>(
      where: where(BackupCode.t),
      orderBy: orderBy?.call(BackupCode.t),
      orderByList: orderByList?.call(BackupCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupCodeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BackupCode>(
      where: where?.call(BackupCode.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BackupCode] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BackupCodeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BackupCode>(
      where: where(BackupCode.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
