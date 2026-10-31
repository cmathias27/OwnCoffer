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

/// One part of an operation split between categories (a supermarket
/// receipt: groceries, household, clothes). The parts add up to the
/// operation's amount; budgets count the parts instead of the operation.
abstract class TransactionSplit
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TransactionSplit._({
    this.id,
    required this.transactionId,
    this.categoryId,
    required this.amountCents,
    this.note,
  });

  factory TransactionSplit({
    int? id,
    required int transactionId,
    int? categoryId,
    required int amountCents,
    String? note,
  }) = _TransactionSplitImpl;

  factory TransactionSplit.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransactionSplit(
      id: jsonSerialization['id'] as int?,
      transactionId: jsonSerialization['transactionId'] as int,
      categoryId: jsonSerialization['categoryId'] as int?,
      amountCents: jsonSerialization['amountCents'] as int,
      note: jsonSerialization['note'] as String?,
    );
  }

  static final t = TransactionSplitTable();

  static const db = TransactionSplitRepository._();

  @override
  int? id;

  int transactionId;

  int? categoryId;

  /// Signed like the operation.
  int amountCents;

  String? note;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransactionSplit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransactionSplit copyWith({
    int? id,
    int? transactionId,
    int? categoryId,
    int? amountCents,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransactionSplit',
      if (id != null) 'id': id,
      'transactionId': transactionId,
      if (categoryId != null) 'categoryId': categoryId,
      'amountCents': amountCents,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransactionSplit',
      if (id != null) 'id': id,
      'transactionId': transactionId,
      if (categoryId != null) 'categoryId': categoryId,
      'amountCents': amountCents,
      if (note != null) 'note': note,
    };
  }

  static TransactionSplitInclude include() {
    return TransactionSplitInclude._();
  }

  static TransactionSplitIncludeList includeList({
    _is.WhereExpressionBuilder<TransactionSplitTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransactionSplitTable>? orderBy,
    _is.OrderByListBuilder<TransactionSplitTable>? orderByList,
    TransactionSplitInclude? include,
  }) {
    return TransactionSplitIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransactionSplit.t),
      orderByList: orderByList?.call(TransactionSplit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransactionSplitImpl extends TransactionSplit {
  _TransactionSplitImpl({
    int? id,
    required int transactionId,
    int? categoryId,
    required int amountCents,
    String? note,
  }) : super._(
         id: id,
         transactionId: transactionId,
         categoryId: categoryId,
         amountCents: amountCents,
         note: note,
       );

  /// Returns a shallow copy of this [TransactionSplit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransactionSplit copyWith({
    Object? id = _Undefined,
    int? transactionId,
    Object? categoryId = _Undefined,
    int? amountCents,
    Object? note = _Undefined,
  }) {
    return TransactionSplit(
      id: id is int? ? id : this.id,
      transactionId: transactionId ?? this.transactionId,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      note: note is String? ? note : this.note,
    );
  }
}

class TransactionSplitUpdateTable
    extends _is.UpdateTable<TransactionSplitTable> {
  TransactionSplitUpdateTable(super.table);

  _is.ColumnValue<int, int> transactionId(int value) => _is.ColumnValue(
    table.transactionId,
    value,
  );

  _is.ColumnValue<int, int> categoryId(int? value) => _is.ColumnValue(
    table.categoryId,
    value,
  );

  _is.ColumnValue<int, int> amountCents(int value) => _is.ColumnValue(
    table.amountCents,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );
}

class TransactionSplitTable extends _is.Table<int?> {
  TransactionSplitTable({super.tableRelation})
    : super(tableName: 'transaction_splits') {
    updateTable = TransactionSplitUpdateTable(this);
    transactionId = _is.ColumnInt(
      'transactionId',
      this,
    );
    categoryId = _is.ColumnInt(
      'categoryId',
      this,
    );
    amountCents = _is.ColumnInt(
      'amountCents',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
  }

  late final TransactionSplitUpdateTable updateTable;

  late final _is.ColumnInt transactionId;

  late final _is.ColumnInt categoryId;

  /// Signed like the operation.
  late final _is.ColumnInt amountCents;

  late final _is.ColumnString note;

  @override
  List<_is.Column> get columns => [
    id,
    transactionId,
    categoryId,
    amountCents,
    note,
  ];
}

class TransactionSplitInclude extends _is.IncludeObject {
  TransactionSplitInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TransactionSplit.t;
}

class TransactionSplitIncludeList extends _is.IncludeList {
  TransactionSplitIncludeList._({
    _is.WhereExpressionBuilder<TransactionSplitTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransactionSplit.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TransactionSplit.t;
}

class TransactionSplitRepository {
  const TransactionSplitRepository._();

  /// Returns a list of [TransactionSplit]s matching the given query parameters.
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
  Future<List<TransactionSplit>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransactionSplitTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransactionSplitTable>? orderBy,
    _is.OrderByListBuilder<TransactionSplitTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TransactionSplit>(
      where: where?.call(TransactionSplit.t),
      orderBy: orderBy?.call(TransactionSplit.t),
      orderByList: orderByList?.call(TransactionSplit.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TransactionSplit] matching the given query parameters.
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
  Future<TransactionSplit?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransactionSplitTable>? where,
    int? offset,
    _is.OrderByBuilder<TransactionSplitTable>? orderBy,
    _is.OrderByListBuilder<TransactionSplitTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TransactionSplit>(
      where: where?.call(TransactionSplit.t),
      orderBy: orderBy?.call(TransactionSplit.t),
      orderByList: orderByList?.call(TransactionSplit.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TransactionSplit] by its [id] or null if no such row exists.
  Future<TransactionSplit?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TransactionSplit>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TransactionSplit]s in the list and returns the inserted rows.
  ///
  /// The returned [TransactionSplit]s will have their `id` fields set.
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
  Future<List<TransactionSplit>> insert(
    _is.DatabaseSession session,
    List<TransactionSplit> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TransactionSplit>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TransactionSplit] and returns the inserted row.
  ///
  /// The returned [TransactionSplit] will have its `id` field set.
  Future<TransactionSplit> insertRow(
    _is.DatabaseSession session,
    TransactionSplit row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransactionSplit>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TransactionSplit]s in the list and returns the resulting rows.
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
  /// The returned [TransactionSplit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransactionSplit>> upsert(
    _is.DatabaseSession session,
    List<TransactionSplit> rows, {
    required _is.ColumnSelections<TransactionSplitTable> conflictColumns,
    _is.ColumnSelections<TransactionSplitTable>? updateColumns,
    _is.WhereExpressionBuilder<TransactionSplitTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TransactionSplit>(
      rows,
      conflictColumns: conflictColumns(TransactionSplit.t),
      updateColumns: updateColumns?.call(TransactionSplit.t),
      updateWhere: updateWhere?.call(TransactionSplit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TransactionSplit] and returns the resulting row.
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
  /// The returned [TransactionSplit] will have its `id` field set.
  Future<TransactionSplit?> upsertRow(
    _is.DatabaseSession session,
    TransactionSplit row, {
    required _is.ColumnSelections<TransactionSplitTable> conflictColumns,
    _is.ColumnSelections<TransactionSplitTable>? updateColumns,
    _is.WhereExpressionBuilder<TransactionSplitTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TransactionSplit>(
      row,
      conflictColumns: conflictColumns(TransactionSplit.t),
      updateColumns: updateColumns?.call(TransactionSplit.t),
      updateWhere: updateWhere?.call(TransactionSplit.t),
      transaction: transaction,
    );
  }

  /// Updates all [TransactionSplit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransactionSplit>> update(
    _is.DatabaseSession session,
    List<TransactionSplit> rows, {
    _is.ColumnSelections<TransactionSplitTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TransactionSplit>(
      rows,
      columns: columns?.call(TransactionSplit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TransactionSplit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransactionSplit> updateRow(
    _is.DatabaseSession session,
    TransactionSplit row, {
    _is.ColumnSelections<TransactionSplitTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransactionSplit>(
      row,
      columns: columns?.call(TransactionSplit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransactionSplit] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TransactionSplit?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TransactionSplitUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TransactionSplit>(
      id,
      columnValues: columnValues(TransactionSplit.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TransactionSplit]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TransactionSplit>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TransactionSplitUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<TransactionSplitTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TransactionSplitTable>? orderBy,
    _is.OrderByListBuilder<TransactionSplitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TransactionSplit>(
      columnValues: columnValues(TransactionSplit.t.updateTable),
      where: where(TransactionSplit.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransactionSplit.t),
      orderByList: orderByList?.call(TransactionSplit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TransactionSplit]s in the list and returns the deleted rows.
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
  Future<List<TransactionSplit>> delete(
    _is.DatabaseSession session,
    List<TransactionSplit> rows, {
    _is.OrderByBuilder<TransactionSplitTable>? orderBy,
    _is.OrderByListBuilder<TransactionSplitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TransactionSplit>(
      rows,
      orderBy: orderBy?.call(TransactionSplit.t),
      orderByList: orderByList?.call(TransactionSplit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TransactionSplit].
  Future<TransactionSplit> deleteRow(
    _is.DatabaseSession session,
    TransactionSplit row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransactionSplit>(
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
  Future<List<TransactionSplit>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransactionSplitTable> where,
    _is.OrderByBuilder<TransactionSplitTable>? orderBy,
    _is.OrderByListBuilder<TransactionSplitTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TransactionSplit>(
      where: where(TransactionSplit.t),
      orderBy: orderBy?.call(TransactionSplit.t),
      orderByList: orderByList?.call(TransactionSplit.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TransactionSplitTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TransactionSplit>(
      where: where?.call(TransactionSplit.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TransactionSplit] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TransactionSplitTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TransactionSplit>(
      where: where(TransactionSplit.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
