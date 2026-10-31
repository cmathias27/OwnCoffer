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

/// The balance the bank shows on a date, compared with the balance computed
/// from the operations: a gap points to a missing import or an operation not
/// passed yet.
abstract class BalanceCheck
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BalanceCheck._({
    this.id,
    required this.accountId,
    required this.date,
    required this.bankBalanceCents,
    required this.computedCents,
    required this.differenceCents,
    required this.unclearedManualCents,
    this.lastImportedDate,
    this.createdBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BalanceCheck({
    int? id,
    required int accountId,
    required DateTime date,
    required int bankBalanceCents,
    required int computedCents,
    required int differenceCents,
    required int unclearedManualCents,
    DateTime? lastImportedDate,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  }) = _BalanceCheckImpl;

  factory BalanceCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return BalanceCheck(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      bankBalanceCents: jsonSerialization['bankBalanceCents'] as int,
      computedCents: jsonSerialization['computedCents'] as int,
      differenceCents: jsonSerialization['differenceCents'] as int,
      unclearedManualCents: jsonSerialization['unclearedManualCents'] as int,
      lastImportedDate: jsonSerialization['lastImportedDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastImportedDate'],
            ),
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['createdBy']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = BalanceCheckTable();

  static const db = BalanceCheckRepository._();

  @override
  int? id;

  int accountId;

  /// Calendar date (UTC midnight), end of day.
  DateTime date;

  int bankBalanceCents;

  int computedCents;

  /// computed − bank.
  int differenceCents;

  /// Manual operations up to the date not yet cleared (may not have reached
  /// the bank).
  int unclearedManualCents;

  /// Latest imported operation, for "an import may be missing".
  DateTime? lastImportedDate;

  _is.UuidValue? createdBy;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BalanceCheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BalanceCheck copyWith({
    int? id,
    int? accountId,
    DateTime? date,
    int? bankBalanceCents,
    int? computedCents,
    int? differenceCents,
    int? unclearedManualCents,
    DateTime? lastImportedDate,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BalanceCheck',
      if (id != null) 'id': id,
      'accountId': accountId,
      'date': date.toJson(),
      'bankBalanceCents': bankBalanceCents,
      'computedCents': computedCents,
      'differenceCents': differenceCents,
      'unclearedManualCents': unclearedManualCents,
      if (lastImportedDate != null)
        'lastImportedDate': lastImportedDate?.toJson(),
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BalanceCheck',
      if (id != null) 'id': id,
      'accountId': accountId,
      'date': date.toJson(),
      'bankBalanceCents': bankBalanceCents,
      'computedCents': computedCents,
      'differenceCents': differenceCents,
      'unclearedManualCents': unclearedManualCents,
      if (lastImportedDate != null)
        'lastImportedDate': lastImportedDate?.toJson(),
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static BalanceCheckInclude include() {
    return BalanceCheckInclude._();
  }

  static BalanceCheckIncludeList includeList({
    _is.WhereExpressionBuilder<BalanceCheckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BalanceCheckTable>? orderBy,
    _is.OrderByListBuilder<BalanceCheckTable>? orderByList,
    BalanceCheckInclude? include,
  }) {
    return BalanceCheckIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BalanceCheck.t),
      orderByList: orderByList?.call(BalanceCheck.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BalanceCheckImpl extends BalanceCheck {
  _BalanceCheckImpl({
    int? id,
    required int accountId,
    required DateTime date,
    required int bankBalanceCents,
    required int computedCents,
    required int differenceCents,
    required int unclearedManualCents,
    DateTime? lastImportedDate,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         accountId: accountId,
         date: date,
         bankBalanceCents: bankBalanceCents,
         computedCents: computedCents,
         differenceCents: differenceCents,
         unclearedManualCents: unclearedManualCents,
         lastImportedDate: lastImportedDate,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BalanceCheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BalanceCheck copyWith({
    Object? id = _Undefined,
    int? accountId,
    DateTime? date,
    int? bankBalanceCents,
    int? computedCents,
    int? differenceCents,
    int? unclearedManualCents,
    Object? lastImportedDate = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
  }) {
    return BalanceCheck(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      bankBalanceCents: bankBalanceCents ?? this.bankBalanceCents,
      computedCents: computedCents ?? this.computedCents,
      differenceCents: differenceCents ?? this.differenceCents,
      unclearedManualCents: unclearedManualCents ?? this.unclearedManualCents,
      lastImportedDate: lastImportedDate is DateTime?
          ? lastImportedDate
          : this.lastImportedDate,
      createdBy: createdBy is _is.UuidValue? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class BalanceCheckUpdateTable extends _is.UpdateTable<BalanceCheckTable> {
  BalanceCheckUpdateTable(super.table);

  _is.ColumnValue<int, int> accountId(int value) => _is.ColumnValue(
    table.accountId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> date(DateTime value) => _is.ColumnValue(
    table.date,
    value,
  );

  _is.ColumnValue<int, int> bankBalanceCents(int value) => _is.ColumnValue(
    table.bankBalanceCents,
    value,
  );

  _is.ColumnValue<int, int> computedCents(int value) => _is.ColumnValue(
    table.computedCents,
    value,
  );

  _is.ColumnValue<int, int> differenceCents(int value) => _is.ColumnValue(
    table.differenceCents,
    value,
  );

  _is.ColumnValue<int, int> unclearedManualCents(int value) => _is.ColumnValue(
    table.unclearedManualCents,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastImportedDate(DateTime? value) =>
      _is.ColumnValue(
        table.lastImportedDate,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createdBy(
    _is.UuidValue? value,
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

class BalanceCheckTable extends _is.Table<int?> {
  BalanceCheckTable({super.tableRelation})
    : super(tableName: 'balance_checks') {
    updateTable = BalanceCheckUpdateTable(this);
    accountId = _is.ColumnInt(
      'accountId',
      this,
    );
    date = _is.ColumnDateTime(
      'date',
      this,
    );
    bankBalanceCents = _is.ColumnInt(
      'bankBalanceCents',
      this,
    );
    computedCents = _is.ColumnInt(
      'computedCents',
      this,
    );
    differenceCents = _is.ColumnInt(
      'differenceCents',
      this,
    );
    unclearedManualCents = _is.ColumnInt(
      'unclearedManualCents',
      this,
    );
    lastImportedDate = _is.ColumnDateTime(
      'lastImportedDate',
      this,
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

  late final BalanceCheckUpdateTable updateTable;

  late final _is.ColumnInt accountId;

  /// Calendar date (UTC midnight), end of day.
  late final _is.ColumnDateTime date;

  late final _is.ColumnInt bankBalanceCents;

  late final _is.ColumnInt computedCents;

  /// computed − bank.
  late final _is.ColumnInt differenceCents;

  /// Manual operations up to the date not yet cleared (may not have reached
  /// the bank).
  late final _is.ColumnInt unclearedManualCents;

  /// Latest imported operation, for "an import may be missing".
  late final _is.ColumnDateTime lastImportedDate;

  late final _is.ColumnUuid createdBy;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    accountId,
    date,
    bankBalanceCents,
    computedCents,
    differenceCents,
    unclearedManualCents,
    lastImportedDate,
    createdBy,
    createdAt,
  ];
}

class BalanceCheckInclude extends _is.IncludeObject {
  BalanceCheckInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BalanceCheck.t;
}

class BalanceCheckIncludeList extends _is.IncludeList {
  BalanceCheckIncludeList._({
    _is.WhereExpressionBuilder<BalanceCheckTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BalanceCheck.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BalanceCheck.t;
}

class BalanceCheckRepository {
  const BalanceCheckRepository._();

  /// Returns a list of [BalanceCheck]s matching the given query parameters.
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
  Future<List<BalanceCheck>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BalanceCheckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BalanceCheckTable>? orderBy,
    _is.OrderByListBuilder<BalanceCheckTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BalanceCheck>(
      where: where?.call(BalanceCheck.t),
      orderBy: orderBy?.call(BalanceCheck.t),
      orderByList: orderByList?.call(BalanceCheck.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BalanceCheck] matching the given query parameters.
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
  Future<BalanceCheck?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BalanceCheckTable>? where,
    int? offset,
    _is.OrderByBuilder<BalanceCheckTable>? orderBy,
    _is.OrderByListBuilder<BalanceCheckTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BalanceCheck>(
      where: where?.call(BalanceCheck.t),
      orderBy: orderBy?.call(BalanceCheck.t),
      orderByList: orderByList?.call(BalanceCheck.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BalanceCheck] by its [id] or null if no such row exists.
  Future<BalanceCheck?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BalanceCheck>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BalanceCheck]s in the list and returns the inserted rows.
  ///
  /// The returned [BalanceCheck]s will have their `id` fields set.
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
  Future<List<BalanceCheck>> insert(
    _is.DatabaseSession session,
    List<BalanceCheck> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BalanceCheck>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BalanceCheck] and returns the inserted row.
  ///
  /// The returned [BalanceCheck] will have its `id` field set.
  Future<BalanceCheck> insertRow(
    _is.DatabaseSession session,
    BalanceCheck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BalanceCheck>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BalanceCheck]s in the list and returns the resulting rows.
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
  /// The returned [BalanceCheck]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BalanceCheck>> upsert(
    _is.DatabaseSession session,
    List<BalanceCheck> rows, {
    required _is.ColumnSelections<BalanceCheckTable> conflictColumns,
    _is.ColumnSelections<BalanceCheckTable>? updateColumns,
    _is.WhereExpressionBuilder<BalanceCheckTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BalanceCheck>(
      rows,
      conflictColumns: conflictColumns(BalanceCheck.t),
      updateColumns: updateColumns?.call(BalanceCheck.t),
      updateWhere: updateWhere?.call(BalanceCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BalanceCheck] and returns the resulting row.
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
  /// The returned [BalanceCheck] will have its `id` field set.
  Future<BalanceCheck?> upsertRow(
    _is.DatabaseSession session,
    BalanceCheck row, {
    required _is.ColumnSelections<BalanceCheckTable> conflictColumns,
    _is.ColumnSelections<BalanceCheckTable>? updateColumns,
    _is.WhereExpressionBuilder<BalanceCheckTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BalanceCheck>(
      row,
      conflictColumns: conflictColumns(BalanceCheck.t),
      updateColumns: updateColumns?.call(BalanceCheck.t),
      updateWhere: updateWhere?.call(BalanceCheck.t),
      transaction: transaction,
    );
  }

  /// Updates all [BalanceCheck]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BalanceCheck>> update(
    _is.DatabaseSession session,
    List<BalanceCheck> rows, {
    _is.ColumnSelections<BalanceCheckTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BalanceCheck>(
      rows,
      columns: columns?.call(BalanceCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BalanceCheck]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BalanceCheck> updateRow(
    _is.DatabaseSession session,
    BalanceCheck row, {
    _is.ColumnSelections<BalanceCheckTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BalanceCheck>(
      row,
      columns: columns?.call(BalanceCheck.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BalanceCheck] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BalanceCheck?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BalanceCheckUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BalanceCheck>(
      id,
      columnValues: columnValues(BalanceCheck.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BalanceCheck]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BalanceCheck>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BalanceCheckUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BalanceCheckTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BalanceCheckTable>? orderBy,
    _is.OrderByListBuilder<BalanceCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BalanceCheck>(
      columnValues: columnValues(BalanceCheck.t.updateTable),
      where: where(BalanceCheck.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BalanceCheck.t),
      orderByList: orderByList?.call(BalanceCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BalanceCheck]s in the list and returns the deleted rows.
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
  Future<List<BalanceCheck>> delete(
    _is.DatabaseSession session,
    List<BalanceCheck> rows, {
    _is.OrderByBuilder<BalanceCheckTable>? orderBy,
    _is.OrderByListBuilder<BalanceCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BalanceCheck>(
      rows,
      orderBy: orderBy?.call(BalanceCheck.t),
      orderByList: orderByList?.call(BalanceCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BalanceCheck].
  Future<BalanceCheck> deleteRow(
    _is.DatabaseSession session,
    BalanceCheck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BalanceCheck>(
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
  Future<List<BalanceCheck>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BalanceCheckTable> where,
    _is.OrderByBuilder<BalanceCheckTable>? orderBy,
    _is.OrderByListBuilder<BalanceCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BalanceCheck>(
      where: where(BalanceCheck.t),
      orderBy: orderBy?.call(BalanceCheck.t),
      orderByList: orderByList?.call(BalanceCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BalanceCheckTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BalanceCheck>(
      where: where?.call(BalanceCheck.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BalanceCheck] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BalanceCheckTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BalanceCheck>(
      where: where(BalanceCheck.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
