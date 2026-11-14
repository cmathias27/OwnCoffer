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

/// Money expected back (health insurance, deposit, refund of a purchase),
/// settled by the first credit of the same amount (decision 0050).
abstract class ExpectedRefund
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ExpectedRefund._({
    this.id,
    required this.groupId,
    required this.createdBy,
    required this.label,
    required this.amountCents,
    required this.since,
    this.dueBy,
    this.accountId,
    this.transactionId,
    this.receivedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ExpectedRefund({
    int? id,
    required int groupId,
    required _is.UuidValue createdBy,
    required String label,
    required int amountCents,
    required DateTime since,
    DateTime? dueBy,
    int? accountId,
    int? transactionId,
    DateTime? receivedAt,
    DateTime? createdAt,
  }) = _ExpectedRefundImpl;

  factory ExpectedRefund.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExpectedRefund(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      createdBy: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      label: jsonSerialization['label'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      since: _is.DateTimeJsonExtension.fromJson(jsonSerialization['since']),
      dueBy: jsonSerialization['dueBy'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueBy']),
      accountId: jsonSerialization['accountId'] as int?,
      transactionId: jsonSerialization['transactionId'] as int?,
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ExpectedRefundTable();

  static const db = ExpectedRefundRepository._();

  @override
  int? id;

  int groupId;

  _is.UuidValue createdBy;

  String label;

  int amountCents;

  /// Credits from this day on may settle it.
  DateTime since;

  /// Late after this day.
  DateTime? dueBy;

  /// Account it should arrive on; null = any visible account.
  int? accountId;

  /// The credit that settled it.
  int? transactionId;

  DateTime? receivedAt;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ExpectedRefund]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ExpectedRefund copyWith({
    int? id,
    int? groupId,
    _is.UuidValue? createdBy,
    String? label,
    int? amountCents,
    DateTime? since,
    DateTime? dueBy,
    int? accountId,
    int? transactionId,
    DateTime? receivedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExpectedRefund',
      if (id != null) 'id': id,
      'groupId': groupId,
      'createdBy': createdBy.toJson(),
      'label': label,
      'amountCents': amountCents,
      'since': since.toJson(),
      if (dueBy != null) 'dueBy': dueBy?.toJson(),
      if (accountId != null) 'accountId': accountId,
      if (transactionId != null) 'transactionId': transactionId,
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExpectedRefund',
      if (id != null) 'id': id,
      'groupId': groupId,
      'createdBy': createdBy.toJson(),
      'label': label,
      'amountCents': amountCents,
      'since': since.toJson(),
      if (dueBy != null) 'dueBy': dueBy?.toJson(),
      if (accountId != null) 'accountId': accountId,
      if (transactionId != null) 'transactionId': transactionId,
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ExpectedRefundInclude include() {
    return ExpectedRefundInclude._();
  }

  static ExpectedRefundIncludeList includeList({
    _is.WhereExpressionBuilder<ExpectedRefundTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExpectedRefundTable>? orderBy,
    _is.OrderByListBuilder<ExpectedRefundTable>? orderByList,
    ExpectedRefundInclude? include,
  }) {
    return ExpectedRefundIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExpectedRefund.t),
      orderByList: orderByList?.call(ExpectedRefund.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExpectedRefundImpl extends ExpectedRefund {
  _ExpectedRefundImpl({
    int? id,
    required int groupId,
    required _is.UuidValue createdBy,
    required String label,
    required int amountCents,
    required DateTime since,
    DateTime? dueBy,
    int? accountId,
    int? transactionId,
    DateTime? receivedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         createdBy: createdBy,
         label: label,
         amountCents: amountCents,
         since: since,
         dueBy: dueBy,
         accountId: accountId,
         transactionId: transactionId,
         receivedAt: receivedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ExpectedRefund]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ExpectedRefund copyWith({
    Object? id = _Undefined,
    int? groupId,
    _is.UuidValue? createdBy,
    String? label,
    int? amountCents,
    DateTime? since,
    Object? dueBy = _Undefined,
    Object? accountId = _Undefined,
    Object? transactionId = _Undefined,
    Object? receivedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return ExpectedRefund(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      createdBy: createdBy ?? this.createdBy,
      label: label ?? this.label,
      amountCents: amountCents ?? this.amountCents,
      since: since ?? this.since,
      dueBy: dueBy is DateTime? ? dueBy : this.dueBy,
      accountId: accountId is int? ? accountId : this.accountId,
      transactionId: transactionId is int? ? transactionId : this.transactionId,
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ExpectedRefundUpdateTable extends _is.UpdateTable<ExpectedRefundTable> {
  ExpectedRefundUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createdBy(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.createdBy,
    value,
  );

  _is.ColumnValue<String, String> label(String value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<int, int> amountCents(int value) => _is.ColumnValue(
    table.amountCents,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> since(DateTime value) => _is.ColumnValue(
    table.since,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dueBy(DateTime? value) => _is.ColumnValue(
    table.dueBy,
    value,
  );

  _is.ColumnValue<int, int> accountId(int? value) => _is.ColumnValue(
    table.accountId,
    value,
  );

  _is.ColumnValue<int, int> transactionId(int? value) => _is.ColumnValue(
    table.transactionId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime? value) =>
      _is.ColumnValue(
        table.receivedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ExpectedRefundTable extends _is.Table<int?> {
  ExpectedRefundTable({super.tableRelation})
    : super(tableName: 'expected_refunds') {
    updateTable = ExpectedRefundUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    createdBy = _is.ColumnUuid(
      'createdBy',
      this,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    amountCents = _is.ColumnInt(
      'amountCents',
      this,
    );
    since = _is.ColumnDateTime(
      'since',
      this,
    );
    dueBy = _is.ColumnDateTime(
      'dueBy',
      this,
    );
    accountId = _is.ColumnInt(
      'accountId',
      this,
    );
    transactionId = _is.ColumnInt(
      'transactionId',
      this,
    );
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ExpectedRefundUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnUuid createdBy;

  late final _is.ColumnString label;

  late final _is.ColumnInt amountCents;

  /// Credits from this day on may settle it.
  late final _is.ColumnDateTime since;

  /// Late after this day.
  late final _is.ColumnDateTime dueBy;

  /// Account it should arrive on; null = any visible account.
  late final _is.ColumnInt accountId;

  /// The credit that settled it.
  late final _is.ColumnInt transactionId;

  late final _is.ColumnDateTime receivedAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    createdBy,
    label,
    amountCents,
    since,
    dueBy,
    accountId,
    transactionId,
    receivedAt,
    createdAt,
  ];
}

class ExpectedRefundInclude extends _is.IncludeObject {
  ExpectedRefundInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ExpectedRefund.t;
}

class ExpectedRefundIncludeList extends _is.IncludeList {
  ExpectedRefundIncludeList._({
    _is.WhereExpressionBuilder<ExpectedRefundTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ExpectedRefund.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ExpectedRefund.t;
}

class ExpectedRefundRepository {
  const ExpectedRefundRepository._();

  /// Returns a list of [ExpectedRefund]s matching the given query parameters.
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
  Future<List<ExpectedRefund>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExpectedRefundTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExpectedRefundTable>? orderBy,
    _is.OrderByListBuilder<ExpectedRefundTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ExpectedRefund>(
      where: where?.call(ExpectedRefund.t),
      orderBy: orderBy?.call(ExpectedRefund.t),
      orderByList: orderByList?.call(ExpectedRefund.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ExpectedRefund] matching the given query parameters.
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
  Future<ExpectedRefund?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExpectedRefundTable>? where,
    int? offset,
    _is.OrderByBuilder<ExpectedRefundTable>? orderBy,
    _is.OrderByListBuilder<ExpectedRefundTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ExpectedRefund>(
      where: where?.call(ExpectedRefund.t),
      orderBy: orderBy?.call(ExpectedRefund.t),
      orderByList: orderByList?.call(ExpectedRefund.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ExpectedRefund] by its [id] or null if no such row exists.
  Future<ExpectedRefund?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ExpectedRefund>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ExpectedRefund]s in the list and returns the inserted rows.
  ///
  /// The returned [ExpectedRefund]s will have their `id` fields set.
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
  Future<List<ExpectedRefund>> insert(
    _is.DatabaseSession session,
    List<ExpectedRefund> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ExpectedRefund>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ExpectedRefund] and returns the inserted row.
  ///
  /// The returned [ExpectedRefund] will have its `id` field set.
  Future<ExpectedRefund> insertRow(
    _is.DatabaseSession session,
    ExpectedRefund row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ExpectedRefund>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ExpectedRefund]s in the list and returns the resulting rows.
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
  /// The returned [ExpectedRefund]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExpectedRefund>> upsert(
    _is.DatabaseSession session,
    List<ExpectedRefund> rows, {
    required _is.ColumnSelections<ExpectedRefundTable> conflictColumns,
    _is.ColumnSelections<ExpectedRefundTable>? updateColumns,
    _is.WhereExpressionBuilder<ExpectedRefundTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ExpectedRefund>(
      rows,
      conflictColumns: conflictColumns(ExpectedRefund.t),
      updateColumns: updateColumns?.call(ExpectedRefund.t),
      updateWhere: updateWhere?.call(ExpectedRefund.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ExpectedRefund] and returns the resulting row.
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
  /// The returned [ExpectedRefund] will have its `id` field set.
  Future<ExpectedRefund?> upsertRow(
    _is.DatabaseSession session,
    ExpectedRefund row, {
    required _is.ColumnSelections<ExpectedRefundTable> conflictColumns,
    _is.ColumnSelections<ExpectedRefundTable>? updateColumns,
    _is.WhereExpressionBuilder<ExpectedRefundTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ExpectedRefund>(
      row,
      conflictColumns: conflictColumns(ExpectedRefund.t),
      updateColumns: updateColumns?.call(ExpectedRefund.t),
      updateWhere: updateWhere?.call(ExpectedRefund.t),
      transaction: transaction,
    );
  }

  /// Updates all [ExpectedRefund]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExpectedRefund>> update(
    _is.DatabaseSession session,
    List<ExpectedRefund> rows, {
    _is.ColumnSelections<ExpectedRefundTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ExpectedRefund>(
      rows,
      columns: columns?.call(ExpectedRefund.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ExpectedRefund]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ExpectedRefund> updateRow(
    _is.DatabaseSession session,
    ExpectedRefund row, {
    _is.ColumnSelections<ExpectedRefundTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ExpectedRefund>(
      row,
      columns: columns?.call(ExpectedRefund.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExpectedRefund] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ExpectedRefund?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ExpectedRefundUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ExpectedRefund>(
      id,
      columnValues: columnValues(ExpectedRefund.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ExpectedRefund]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExpectedRefund>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ExpectedRefundUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ExpectedRefundTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExpectedRefundTable>? orderBy,
    _is.OrderByListBuilder<ExpectedRefundTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ExpectedRefund>(
      columnValues: columnValues(ExpectedRefund.t.updateTable),
      where: where(ExpectedRefund.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExpectedRefund.t),
      orderByList: orderByList?.call(ExpectedRefund.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ExpectedRefund]s in the list and returns the deleted rows.
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
  Future<List<ExpectedRefund>> delete(
    _is.DatabaseSession session,
    List<ExpectedRefund> rows, {
    _is.OrderByBuilder<ExpectedRefundTable>? orderBy,
    _is.OrderByListBuilder<ExpectedRefundTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ExpectedRefund>(
      rows,
      orderBy: orderBy?.call(ExpectedRefund.t),
      orderByList: orderByList?.call(ExpectedRefund.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ExpectedRefund].
  Future<ExpectedRefund> deleteRow(
    _is.DatabaseSession session,
    ExpectedRefund row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ExpectedRefund>(
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
  Future<List<ExpectedRefund>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExpectedRefundTable> where,
    _is.OrderByBuilder<ExpectedRefundTable>? orderBy,
    _is.OrderByListBuilder<ExpectedRefundTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ExpectedRefund>(
      where: where(ExpectedRefund.t),
      orderBy: orderBy?.call(ExpectedRefund.t),
      orderByList: orderByList?.call(ExpectedRefund.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExpectedRefundTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ExpectedRefund>(
      where: where?.call(ExpectedRefund.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ExpectedRefund] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExpectedRefundTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ExpectedRefund>(
      where: where(ExpectedRefund.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
