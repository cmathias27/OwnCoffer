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

/// TOTP secret of a user, encrypted (SecretBox). `enabled` is false until
/// the user has typed a first valid code.
abstract class TotpSecret
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TotpSecret._({
    this.id,
    required this.authUserId,
    required this.secretBox,
    bool? enabled,
    this.lastUsedStep,
    DateTime? createdAt,
    this.enabledAt,
  }) : enabled = enabled ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory TotpSecret({
    int? id,
    required _is.UuidValue authUserId,
    required String secretBox,
    bool? enabled,
    int? lastUsedStep,
    DateTime? createdAt,
    DateTime? enabledAt,
  }) = _TotpSecretImpl;

  factory TotpSecret.fromJson(Map<String, dynamic> jsonSerialization) {
    return TotpSecret(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      secretBox: jsonSerialization['secretBox'] as String,
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      lastUsedStep: jsonSerialization['lastUsedStep'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      enabledAt: jsonSerialization['enabledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['enabledAt']),
    );
  }

  static final t = TotpSecretTable();

  static const db = TotpSecretRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String secretBox;

  bool enabled;

  /// Last accepted time step: a code is accepted only once.
  int? lastUsedStep;

  DateTime createdAt;

  DateTime? enabledAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TotpSecret]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TotpSecret copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? secretBox,
    bool? enabled,
    int? lastUsedStep,
    DateTime? createdAt,
    DateTime? enabledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TotpSecret',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'secretBox': secretBox,
      'enabled': enabled,
      if (lastUsedStep != null) 'lastUsedStep': lastUsedStep,
      'createdAt': createdAt.toJson(),
      if (enabledAt != null) 'enabledAt': enabledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TotpSecretInclude include() {
    return TotpSecretInclude._();
  }

  static TotpSecretIncludeList includeList({
    _is.WhereExpressionBuilder<TotpSecretTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TotpSecretTable>? orderBy,
    _is.OrderByListBuilder<TotpSecretTable>? orderByList,
    TotpSecretInclude? include,
  }) {
    return TotpSecretIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TotpSecret.t),
      orderByList: orderByList?.call(TotpSecret.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TotpSecretImpl extends TotpSecret {
  _TotpSecretImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String secretBox,
    bool? enabled,
    int? lastUsedStep,
    DateTime? createdAt,
    DateTime? enabledAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         secretBox: secretBox,
         enabled: enabled,
         lastUsedStep: lastUsedStep,
         createdAt: createdAt,
         enabledAt: enabledAt,
       );

  /// Returns a shallow copy of this [TotpSecret]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TotpSecret copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? secretBox,
    bool? enabled,
    Object? lastUsedStep = _Undefined,
    DateTime? createdAt,
    Object? enabledAt = _Undefined,
  }) {
    return TotpSecret(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      secretBox: secretBox ?? this.secretBox,
      enabled: enabled ?? this.enabled,
      lastUsedStep: lastUsedStep is int? ? lastUsedStep : this.lastUsedStep,
      createdAt: createdAt ?? this.createdAt,
      enabledAt: enabledAt is DateTime? ? enabledAt : this.enabledAt,
    );
  }
}

class TotpSecretUpdateTable extends _is.UpdateTable<TotpSecretTable> {
  TotpSecretUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> secretBox(String value) => _is.ColumnValue(
    table.secretBox,
    value,
  );

  _is.ColumnValue<bool, bool> enabled(bool value) => _is.ColumnValue(
    table.enabled,
    value,
  );

  _is.ColumnValue<int, int> lastUsedStep(int? value) => _is.ColumnValue(
    table.lastUsedStep,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> enabledAt(DateTime? value) =>
      _is.ColumnValue(
        table.enabledAt,
        value,
      );
}

class TotpSecretTable extends _is.Table<int?> {
  TotpSecretTable({super.tableRelation}) : super(tableName: 'totp_secrets') {
    updateTable = TotpSecretUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    secretBox = _is.ColumnString(
      'secretBox',
      this,
    );
    enabled = _is.ColumnBool(
      'enabled',
      this,
      hasDefault: true,
    );
    lastUsedStep = _is.ColumnInt(
      'lastUsedStep',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    enabledAt = _is.ColumnDateTime(
      'enabledAt',
      this,
    );
  }

  late final TotpSecretUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString secretBox;

  late final _is.ColumnBool enabled;

  /// Last accepted time step: a code is accepted only once.
  late final _is.ColumnInt lastUsedStep;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime enabledAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    secretBox,
    enabled,
    lastUsedStep,
    createdAt,
    enabledAt,
  ];
}

class TotpSecretInclude extends _is.IncludeObject {
  TotpSecretInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TotpSecret.t;
}

class TotpSecretIncludeList extends _is.IncludeList {
  TotpSecretIncludeList._({
    _is.WhereExpressionBuilder<TotpSecretTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TotpSecret.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TotpSecret.t;
}

class TotpSecretRepository {
  const TotpSecretRepository._();

  /// Returns a list of [TotpSecret]s matching the given query parameters.
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
  Future<List<TotpSecret>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TotpSecretTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TotpSecretTable>? orderBy,
    _is.OrderByListBuilder<TotpSecretTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TotpSecret>(
      where: where?.call(TotpSecret.t),
      orderBy: orderBy?.call(TotpSecret.t),
      orderByList: orderByList?.call(TotpSecret.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TotpSecret] matching the given query parameters.
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
  Future<TotpSecret?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TotpSecretTable>? where,
    int? offset,
    _is.OrderByBuilder<TotpSecretTable>? orderBy,
    _is.OrderByListBuilder<TotpSecretTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TotpSecret>(
      where: where?.call(TotpSecret.t),
      orderBy: orderBy?.call(TotpSecret.t),
      orderByList: orderByList?.call(TotpSecret.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TotpSecret] by its [id] or null if no such row exists.
  Future<TotpSecret?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TotpSecret>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TotpSecret]s in the list and returns the inserted rows.
  ///
  /// The returned [TotpSecret]s will have their `id` fields set.
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
  Future<List<TotpSecret>> insert(
    _is.DatabaseSession session,
    List<TotpSecret> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TotpSecret>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TotpSecret] and returns the inserted row.
  ///
  /// The returned [TotpSecret] will have its `id` field set.
  Future<TotpSecret> insertRow(
    _is.DatabaseSession session,
    TotpSecret row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TotpSecret>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TotpSecret]s in the list and returns the resulting rows.
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
  /// The returned [TotpSecret]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TotpSecret>> upsert(
    _is.DatabaseSession session,
    List<TotpSecret> rows, {
    required _is.ColumnSelections<TotpSecretTable> conflictColumns,
    _is.ColumnSelections<TotpSecretTable>? updateColumns,
    _is.WhereExpressionBuilder<TotpSecretTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TotpSecret>(
      rows,
      conflictColumns: conflictColumns(TotpSecret.t),
      updateColumns: updateColumns?.call(TotpSecret.t),
      updateWhere: updateWhere?.call(TotpSecret.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TotpSecret] and returns the resulting row.
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
  /// The returned [TotpSecret] will have its `id` field set.
  Future<TotpSecret?> upsertRow(
    _is.DatabaseSession session,
    TotpSecret row, {
    required _is.ColumnSelections<TotpSecretTable> conflictColumns,
    _is.ColumnSelections<TotpSecretTable>? updateColumns,
    _is.WhereExpressionBuilder<TotpSecretTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TotpSecret>(
      row,
      conflictColumns: conflictColumns(TotpSecret.t),
      updateColumns: updateColumns?.call(TotpSecret.t),
      updateWhere: updateWhere?.call(TotpSecret.t),
      transaction: transaction,
    );
  }

  /// Updates all [TotpSecret]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TotpSecret>> update(
    _is.DatabaseSession session,
    List<TotpSecret> rows, {
    _is.ColumnSelections<TotpSecretTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TotpSecret>(
      rows,
      columns: columns?.call(TotpSecret.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TotpSecret]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TotpSecret> updateRow(
    _is.DatabaseSession session,
    TotpSecret row, {
    _is.ColumnSelections<TotpSecretTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TotpSecret>(
      row,
      columns: columns?.call(TotpSecret.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TotpSecret] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TotpSecret?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TotpSecretUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TotpSecret>(
      id,
      columnValues: columnValues(TotpSecret.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TotpSecret]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TotpSecret>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TotpSecretUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TotpSecretTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TotpSecretTable>? orderBy,
    _is.OrderByListBuilder<TotpSecretTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TotpSecret>(
      columnValues: columnValues(TotpSecret.t.updateTable),
      where: where(TotpSecret.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TotpSecret.t),
      orderByList: orderByList?.call(TotpSecret.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TotpSecret]s in the list and returns the deleted rows.
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
  Future<List<TotpSecret>> delete(
    _is.DatabaseSession session,
    List<TotpSecret> rows, {
    _is.OrderByBuilder<TotpSecretTable>? orderBy,
    _is.OrderByListBuilder<TotpSecretTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TotpSecret>(
      rows,
      orderBy: orderBy?.call(TotpSecret.t),
      orderByList: orderByList?.call(TotpSecret.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TotpSecret].
  Future<TotpSecret> deleteRow(
    _is.DatabaseSession session,
    TotpSecret row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TotpSecret>(
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
  Future<List<TotpSecret>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TotpSecretTable> where,
    _is.OrderByBuilder<TotpSecretTable>? orderBy,
    _is.OrderByListBuilder<TotpSecretTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TotpSecret>(
      where: where(TotpSecret.t),
      orderBy: orderBy?.call(TotpSecret.t),
      orderByList: orderByList?.call(TotpSecret.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TotpSecretTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TotpSecret>(
      where: where?.call(TotpSecret.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TotpSecret] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TotpSecretTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TotpSecret>(
      where: where(TotpSecret.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
