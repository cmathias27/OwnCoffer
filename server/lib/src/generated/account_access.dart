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

/// Users allowed to see a `restricted` account.
abstract class AccountAccess
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AccountAccess._({
    this.id,
    required this.accountId,
    required this.authUserId,
  });

  factory AccountAccess({
    int? id,
    required int accountId,
    required _is.UuidValue authUserId,
  }) = _AccountAccessImpl;

  factory AccountAccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountAccess(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
    );
  }

  static final t = AccountAccessTable();

  static const db = AccountAccessRepository._();

  @override
  int? id;

  int accountId;

  _is.UuidValue authUserId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountAccess]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccountAccess copyWith({
    int? id,
    int? accountId,
    _is.UuidValue? authUserId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountAccess',
      if (id != null) 'id': id,
      'accountId': accountId,
      'authUserId': authUserId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountAccess',
      if (id != null) 'id': id,
      'accountId': accountId,
      'authUserId': authUserId.toJson(),
    };
  }

  static AccountAccessInclude include() {
    return AccountAccessInclude._();
  }

  static AccountAccessIncludeList includeList({
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    AccountAccessInclude? include,
  }) {
    return AccountAccessIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountAccessImpl extends AccountAccess {
  _AccountAccessImpl({
    int? id,
    required int accountId,
    required _is.UuidValue authUserId,
  }) : super._(
         id: id,
         accountId: accountId,
         authUserId: authUserId,
       );

  /// Returns a shallow copy of this [AccountAccess]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccountAccess copyWith({
    Object? id = _Undefined,
    int? accountId,
    _is.UuidValue? authUserId,
  }) {
    return AccountAccess(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      authUserId: authUserId ?? this.authUserId,
    );
  }
}

class AccountAccessUpdateTable extends _is.UpdateTable<AccountAccessTable> {
  AccountAccessUpdateTable(super.table);

  _is.ColumnValue<int, int> accountId(int value) => _is.ColumnValue(
    table.accountId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );
}

class AccountAccessTable extends _is.Table<int?> {
  AccountAccessTable({super.tableRelation})
    : super(tableName: 'account_access') {
    updateTable = AccountAccessUpdateTable(this);
    accountId = _is.ColumnInt(
      'accountId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
  }

  late final AccountAccessUpdateTable updateTable;

  late final _is.ColumnInt accountId;

  late final _is.ColumnUuid authUserId;

  @override
  List<_is.Column> get columns => [
    id,
    accountId,
    authUserId,
  ];
}

class AccountAccessInclude extends _is.IncludeObject {
  AccountAccessInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AccountAccess.t;
}

class AccountAccessIncludeList extends _is.IncludeList {
  AccountAccessIncludeList._({
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountAccess.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AccountAccess.t;
}

class AccountAccessRepository {
  const AccountAccessRepository._();

  /// Returns a list of [AccountAccess]s matching the given query parameters.
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
  Future<List<AccountAccess>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccountAccess>(
      where: where?.call(AccountAccess.t),
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccountAccess] matching the given query parameters.
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
  Future<AccountAccess?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    int? offset,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccountAccess>(
      where: where?.call(AccountAccess.t),
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccountAccess] by its [id] or null if no such row exists.
  Future<AccountAccess?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccountAccess>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccountAccess]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountAccess]s will have their `id` fields set.
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
  Future<List<AccountAccess>> insert(
    _is.DatabaseSession session,
    List<AccountAccess> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccountAccess>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccountAccess] and returns the inserted row.
  ///
  /// The returned [AccountAccess] will have its `id` field set.
  Future<AccountAccess> insertRow(
    _is.DatabaseSession session,
    AccountAccess row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountAccess>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccountAccess]s in the list and returns the resulting rows.
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
  /// The returned [AccountAccess]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountAccess>> upsert(
    _is.DatabaseSession session,
    List<AccountAccess> rows, {
    required _is.ColumnSelections<AccountAccessTable> conflictColumns,
    _is.ColumnSelections<AccountAccessTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountAccessTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccountAccess>(
      rows,
      conflictColumns: conflictColumns(AccountAccess.t),
      updateColumns: updateColumns?.call(AccountAccess.t),
      updateWhere: updateWhere?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccountAccess] and returns the resulting row.
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
  /// The returned [AccountAccess] will have its `id` field set.
  Future<AccountAccess?> upsertRow(
    _is.DatabaseSession session,
    AccountAccess row, {
    required _is.ColumnSelections<AccountAccessTable> conflictColumns,
    _is.ColumnSelections<AccountAccessTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountAccessTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccountAccess>(
      row,
      conflictColumns: conflictColumns(AccountAccess.t),
      updateColumns: updateColumns?.call(AccountAccess.t),
      updateWhere: updateWhere?.call(AccountAccess.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccountAccess]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountAccess>> update(
    _is.DatabaseSession session,
    List<AccountAccess> rows, {
    _is.ColumnSelections<AccountAccessTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccountAccess>(
      rows,
      columns: columns?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccountAccess]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountAccess> updateRow(
    _is.DatabaseSession session,
    AccountAccess row, {
    _is.ColumnSelections<AccountAccessTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountAccess>(
      row,
      columns: columns?.call(AccountAccess.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountAccess] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountAccess?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AccountAccessUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountAccess>(
      id,
      columnValues: columnValues(AccountAccess.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountAccess]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccountAccess>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccountAccessUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AccountAccessTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccountAccess>(
      columnValues: columnValues(AccountAccess.t.updateTable),
      where: where(AccountAccess.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccountAccess]s in the list and returns the deleted rows.
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
  Future<List<AccountAccess>> delete(
    _is.DatabaseSession session,
    List<AccountAccess> rows, {
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccountAccess>(
      rows,
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccountAccess].
  Future<AccountAccess> deleteRow(
    _is.DatabaseSession session,
    AccountAccess row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountAccess>(
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
  Future<List<AccountAccess>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountAccessTable> where,
    _is.OrderByBuilder<AccountAccessTable>? orderBy,
    _is.OrderByListBuilder<AccountAccessTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccountAccess>(
      where: where(AccountAccess.t),
      orderBy: orderBy?.call(AccountAccess.t),
      orderByList: orderByList?.call(AccountAccess.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountAccessTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccountAccess>(
      where: where?.call(AccountAccess.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccountAccess] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountAccessTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccountAccess>(
      where: where(AccountAccess.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
