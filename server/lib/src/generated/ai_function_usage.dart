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

/// What a user's AI requests cost, per provider, month (yyyymm) and
/// function (decision 0048): requests and tokens as the provider reports
/// them. Nothing of the content is kept.
abstract class AiFunctionUsage
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AiFunctionUsage._({
    this.id,
    required this.authUserId,
    required this.providerId,
    required this.month,
    required this.feature,
    required this.requests,
    required this.inputTokens,
    required this.outputTokens,
  });

  factory AiFunctionUsage({
    int? id,
    required _is.UuidValue authUserId,
    required int providerId,
    required int month,
    required String feature,
    required int requests,
    required int inputTokens,
    required int outputTokens,
  }) = _AiFunctionUsageImpl;

  factory AiFunctionUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiFunctionUsage(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      providerId: jsonSerialization['providerId'] as int,
      month: jsonSerialization['month'] as int,
      feature: jsonSerialization['feature'] as String,
      requests: jsonSerialization['requests'] as int,
      inputTokens: jsonSerialization['inputTokens'] as int,
      outputTokens: jsonSerialization['outputTokens'] as int,
    );
  }

  static final t = AiFunctionUsageTable();

  static const db = AiFunctionUsageRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  int providerId;

  int month;

  /// chat, invoice or loan.
  String feature;

  int requests;

  int inputTokens;

  int outputTokens;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AiFunctionUsage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiFunctionUsage copyWith({
    int? id,
    _is.UuidValue? authUserId,
    int? providerId,
    int? month,
    String? feature,
    int? requests,
    int? inputTokens,
    int? outputTokens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiFunctionUsage',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'providerId': providerId,
      'month': month,
      'feature': feature,
      'requests': requests,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiFunctionUsage',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'providerId': providerId,
      'month': month,
      'feature': feature,
      'requests': requests,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
    };
  }

  static AiFunctionUsageInclude include() {
    return AiFunctionUsageInclude._();
  }

  static AiFunctionUsageIncludeList includeList({
    _is.WhereExpressionBuilder<AiFunctionUsageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiFunctionUsageTable>? orderBy,
    _is.OrderByListBuilder<AiFunctionUsageTable>? orderByList,
    AiFunctionUsageInclude? include,
  }) {
    return AiFunctionUsageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiFunctionUsage.t),
      orderByList: orderByList?.call(AiFunctionUsage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiFunctionUsageImpl extends AiFunctionUsage {
  _AiFunctionUsageImpl({
    int? id,
    required _is.UuidValue authUserId,
    required int providerId,
    required int month,
    required String feature,
    required int requests,
    required int inputTokens,
    required int outputTokens,
  }) : super._(
         id: id,
         authUserId: authUserId,
         providerId: providerId,
         month: month,
         feature: feature,
         requests: requests,
         inputTokens: inputTokens,
         outputTokens: outputTokens,
       );

  /// Returns a shallow copy of this [AiFunctionUsage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiFunctionUsage copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    int? providerId,
    int? month,
    String? feature,
    int? requests,
    int? inputTokens,
    int? outputTokens,
  }) {
    return AiFunctionUsage(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      providerId: providerId ?? this.providerId,
      month: month ?? this.month,
      feature: feature ?? this.feature,
      requests: requests ?? this.requests,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
    );
  }
}

class AiFunctionUsageUpdateTable extends _is.UpdateTable<AiFunctionUsageTable> {
  AiFunctionUsageUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> providerId(int value) => _is.ColumnValue(
    table.providerId,
    value,
  );

  _is.ColumnValue<int, int> month(int value) => _is.ColumnValue(
    table.month,
    value,
  );

  _is.ColumnValue<String, String> feature(String value) => _is.ColumnValue(
    table.feature,
    value,
  );

  _is.ColumnValue<int, int> requests(int value) => _is.ColumnValue(
    table.requests,
    value,
  );

  _is.ColumnValue<int, int> inputTokens(int value) => _is.ColumnValue(
    table.inputTokens,
    value,
  );

  _is.ColumnValue<int, int> outputTokens(int value) => _is.ColumnValue(
    table.outputTokens,
    value,
  );
}

class AiFunctionUsageTable extends _is.Table<int?> {
  AiFunctionUsageTable({super.tableRelation})
    : super(tableName: 'ai_function_usage') {
    updateTable = AiFunctionUsageUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    providerId = _is.ColumnInt(
      'providerId',
      this,
    );
    month = _is.ColumnInt(
      'month',
      this,
    );
    feature = _is.ColumnString(
      'feature',
      this,
    );
    requests = _is.ColumnInt(
      'requests',
      this,
    );
    inputTokens = _is.ColumnInt(
      'inputTokens',
      this,
    );
    outputTokens = _is.ColumnInt(
      'outputTokens',
      this,
    );
  }

  late final AiFunctionUsageUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnInt providerId;

  late final _is.ColumnInt month;

  /// chat, invoice or loan.
  late final _is.ColumnString feature;

  late final _is.ColumnInt requests;

  late final _is.ColumnInt inputTokens;

  late final _is.ColumnInt outputTokens;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    providerId,
    month,
    feature,
    requests,
    inputTokens,
    outputTokens,
  ];
}

class AiFunctionUsageInclude extends _is.IncludeObject {
  AiFunctionUsageInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AiFunctionUsage.t;
}

class AiFunctionUsageIncludeList extends _is.IncludeList {
  AiFunctionUsageIncludeList._({
    _is.WhereExpressionBuilder<AiFunctionUsageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiFunctionUsage.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AiFunctionUsage.t;
}

class AiFunctionUsageRepository {
  const AiFunctionUsageRepository._();

  /// Returns a list of [AiFunctionUsage]s matching the given query parameters.
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
  Future<List<AiFunctionUsage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiFunctionUsageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiFunctionUsageTable>? orderBy,
    _is.OrderByListBuilder<AiFunctionUsageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiFunctionUsage>(
      where: where?.call(AiFunctionUsage.t),
      orderBy: orderBy?.call(AiFunctionUsage.t),
      orderByList: orderByList?.call(AiFunctionUsage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiFunctionUsage] matching the given query parameters.
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
  Future<AiFunctionUsage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiFunctionUsageTable>? where,
    int? offset,
    _is.OrderByBuilder<AiFunctionUsageTable>? orderBy,
    _is.OrderByListBuilder<AiFunctionUsageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiFunctionUsage>(
      where: where?.call(AiFunctionUsage.t),
      orderBy: orderBy?.call(AiFunctionUsage.t),
      orderByList: orderByList?.call(AiFunctionUsage.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiFunctionUsage] by its [id] or null if no such row exists.
  Future<AiFunctionUsage?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiFunctionUsage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiFunctionUsage]s in the list and returns the inserted rows.
  ///
  /// The returned [AiFunctionUsage]s will have their `id` fields set.
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
  Future<List<AiFunctionUsage>> insert(
    _is.DatabaseSession session,
    List<AiFunctionUsage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiFunctionUsage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiFunctionUsage] and returns the inserted row.
  ///
  /// The returned [AiFunctionUsage] will have its `id` field set.
  Future<AiFunctionUsage> insertRow(
    _is.DatabaseSession session,
    AiFunctionUsage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiFunctionUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiFunctionUsage]s in the list and returns the resulting rows.
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
  /// The returned [AiFunctionUsage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiFunctionUsage>> upsert(
    _is.DatabaseSession session,
    List<AiFunctionUsage> rows, {
    required _is.ColumnSelections<AiFunctionUsageTable> conflictColumns,
    _is.ColumnSelections<AiFunctionUsageTable>? updateColumns,
    _is.WhereExpressionBuilder<AiFunctionUsageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiFunctionUsage>(
      rows,
      conflictColumns: conflictColumns(AiFunctionUsage.t),
      updateColumns: updateColumns?.call(AiFunctionUsage.t),
      updateWhere: updateWhere?.call(AiFunctionUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiFunctionUsage] and returns the resulting row.
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
  /// The returned [AiFunctionUsage] will have its `id` field set.
  Future<AiFunctionUsage?> upsertRow(
    _is.DatabaseSession session,
    AiFunctionUsage row, {
    required _is.ColumnSelections<AiFunctionUsageTable> conflictColumns,
    _is.ColumnSelections<AiFunctionUsageTable>? updateColumns,
    _is.WhereExpressionBuilder<AiFunctionUsageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiFunctionUsage>(
      row,
      conflictColumns: conflictColumns(AiFunctionUsage.t),
      updateColumns: updateColumns?.call(AiFunctionUsage.t),
      updateWhere: updateWhere?.call(AiFunctionUsage.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiFunctionUsage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiFunctionUsage>> update(
    _is.DatabaseSession session,
    List<AiFunctionUsage> rows, {
    _is.ColumnSelections<AiFunctionUsageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiFunctionUsage>(
      rows,
      columns: columns?.call(AiFunctionUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiFunctionUsage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiFunctionUsage> updateRow(
    _is.DatabaseSession session,
    AiFunctionUsage row, {
    _is.ColumnSelections<AiFunctionUsageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiFunctionUsage>(
      row,
      columns: columns?.call(AiFunctionUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiFunctionUsage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiFunctionUsage?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AiFunctionUsageUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiFunctionUsage>(
      id,
      columnValues: columnValues(AiFunctionUsage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiFunctionUsage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiFunctionUsage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiFunctionUsageUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AiFunctionUsageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiFunctionUsageTable>? orderBy,
    _is.OrderByListBuilder<AiFunctionUsageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiFunctionUsage>(
      columnValues: columnValues(AiFunctionUsage.t.updateTable),
      where: where(AiFunctionUsage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiFunctionUsage.t),
      orderByList: orderByList?.call(AiFunctionUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiFunctionUsage]s in the list and returns the deleted rows.
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
  Future<List<AiFunctionUsage>> delete(
    _is.DatabaseSession session,
    List<AiFunctionUsage> rows, {
    _is.OrderByBuilder<AiFunctionUsageTable>? orderBy,
    _is.OrderByListBuilder<AiFunctionUsageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiFunctionUsage>(
      rows,
      orderBy: orderBy?.call(AiFunctionUsage.t),
      orderByList: orderByList?.call(AiFunctionUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiFunctionUsage].
  Future<AiFunctionUsage> deleteRow(
    _is.DatabaseSession session,
    AiFunctionUsage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiFunctionUsage>(
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
  Future<List<AiFunctionUsage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiFunctionUsageTable> where,
    _is.OrderByBuilder<AiFunctionUsageTable>? orderBy,
    _is.OrderByListBuilder<AiFunctionUsageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiFunctionUsage>(
      where: where(AiFunctionUsage.t),
      orderBy: orderBy?.call(AiFunctionUsage.t),
      orderByList: orderByList?.call(AiFunctionUsage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiFunctionUsageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiFunctionUsage>(
      where: where?.call(AiFunctionUsage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiFunctionUsage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiFunctionUsageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiFunctionUsage>(
      where: where(AiFunctionUsage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
