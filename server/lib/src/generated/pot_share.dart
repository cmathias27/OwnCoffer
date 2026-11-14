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

/// Monthly income declared by a member, to split the common pot in
/// proportion (decision 0050).
abstract class PotShare
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PotShare._({
    this.id,
    required this.groupId,
    required this.authUserId,
    required this.incomeCents,
  });

  factory PotShare({
    int? id,
    required int groupId,
    required _is.UuidValue authUserId,
    required int incomeCents,
  }) = _PotShareImpl;

  factory PotShare.fromJson(Map<String, dynamic> jsonSerialization) {
    return PotShare(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      incomeCents: jsonSerialization['incomeCents'] as int,
    );
  }

  static final t = PotShareTable();

  static const db = PotShareRepository._();

  @override
  int? id;

  int groupId;

  _is.UuidValue authUserId;

  int incomeCents;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PotShare]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PotShare copyWith({
    int? id,
    int? groupId,
    _is.UuidValue? authUserId,
    int? incomeCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PotShare',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'incomeCents': incomeCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PotShare',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'incomeCents': incomeCents,
    };
  }

  static PotShareInclude include() {
    return PotShareInclude._();
  }

  static PotShareIncludeList includeList({
    _is.WhereExpressionBuilder<PotShareTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PotShareTable>? orderBy,
    _is.OrderByListBuilder<PotShareTable>? orderByList,
    PotShareInclude? include,
  }) {
    return PotShareIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PotShare.t),
      orderByList: orderByList?.call(PotShare.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PotShareImpl extends PotShare {
  _PotShareImpl({
    int? id,
    required int groupId,
    required _is.UuidValue authUserId,
    required int incomeCents,
  }) : super._(
         id: id,
         groupId: groupId,
         authUserId: authUserId,
         incomeCents: incomeCents,
       );

  /// Returns a shallow copy of this [PotShare]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PotShare copyWith({
    Object? id = _Undefined,
    int? groupId,
    _is.UuidValue? authUserId,
    int? incomeCents,
  }) {
    return PotShare(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      authUserId: authUserId ?? this.authUserId,
      incomeCents: incomeCents ?? this.incomeCents,
    );
  }
}

class PotShareUpdateTable extends _is.UpdateTable<PotShareTable> {
  PotShareUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> incomeCents(int value) => _is.ColumnValue(
    table.incomeCents,
    value,
  );
}

class PotShareTable extends _is.Table<int?> {
  PotShareTable({super.tableRelation}) : super(tableName: 'pot_shares') {
    updateTable = PotShareUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    incomeCents = _is.ColumnInt(
      'incomeCents',
      this,
    );
  }

  late final PotShareUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnInt incomeCents;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    authUserId,
    incomeCents,
  ];
}

class PotShareInclude extends _is.IncludeObject {
  PotShareInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PotShare.t;
}

class PotShareIncludeList extends _is.IncludeList {
  PotShareIncludeList._({
    _is.WhereExpressionBuilder<PotShareTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PotShare.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PotShare.t;
}

class PotShareRepository {
  const PotShareRepository._();

  /// Returns a list of [PotShare]s matching the given query parameters.
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
  Future<List<PotShare>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PotShareTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PotShareTable>? orderBy,
    _is.OrderByListBuilder<PotShareTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PotShare>(
      where: where?.call(PotShare.t),
      orderBy: orderBy?.call(PotShare.t),
      orderByList: orderByList?.call(PotShare.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PotShare] matching the given query parameters.
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
  Future<PotShare?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PotShareTable>? where,
    int? offset,
    _is.OrderByBuilder<PotShareTable>? orderBy,
    _is.OrderByListBuilder<PotShareTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PotShare>(
      where: where?.call(PotShare.t),
      orderBy: orderBy?.call(PotShare.t),
      orderByList: orderByList?.call(PotShare.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PotShare] by its [id] or null if no such row exists.
  Future<PotShare?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PotShare>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PotShare]s in the list and returns the inserted rows.
  ///
  /// The returned [PotShare]s will have their `id` fields set.
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
  Future<List<PotShare>> insert(
    _is.DatabaseSession session,
    List<PotShare> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PotShare>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PotShare] and returns the inserted row.
  ///
  /// The returned [PotShare] will have its `id` field set.
  Future<PotShare> insertRow(
    _is.DatabaseSession session,
    PotShare row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PotShare>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PotShare]s in the list and returns the resulting rows.
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
  /// The returned [PotShare]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PotShare>> upsert(
    _is.DatabaseSession session,
    List<PotShare> rows, {
    required _is.ColumnSelections<PotShareTable> conflictColumns,
    _is.ColumnSelections<PotShareTable>? updateColumns,
    _is.WhereExpressionBuilder<PotShareTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PotShare>(
      rows,
      conflictColumns: conflictColumns(PotShare.t),
      updateColumns: updateColumns?.call(PotShare.t),
      updateWhere: updateWhere?.call(PotShare.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PotShare] and returns the resulting row.
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
  /// The returned [PotShare] will have its `id` field set.
  Future<PotShare?> upsertRow(
    _is.DatabaseSession session,
    PotShare row, {
    required _is.ColumnSelections<PotShareTable> conflictColumns,
    _is.ColumnSelections<PotShareTable>? updateColumns,
    _is.WhereExpressionBuilder<PotShareTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PotShare>(
      row,
      conflictColumns: conflictColumns(PotShare.t),
      updateColumns: updateColumns?.call(PotShare.t),
      updateWhere: updateWhere?.call(PotShare.t),
      transaction: transaction,
    );
  }

  /// Updates all [PotShare]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PotShare>> update(
    _is.DatabaseSession session,
    List<PotShare> rows, {
    _is.ColumnSelections<PotShareTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PotShare>(
      rows,
      columns: columns?.call(PotShare.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PotShare]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PotShare> updateRow(
    _is.DatabaseSession session,
    PotShare row, {
    _is.ColumnSelections<PotShareTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PotShare>(
      row,
      columns: columns?.call(PotShare.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PotShare] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PotShare?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PotShareUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PotShare>(
      id,
      columnValues: columnValues(PotShare.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PotShare]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PotShare>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PotShareUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PotShareTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PotShareTable>? orderBy,
    _is.OrderByListBuilder<PotShareTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PotShare>(
      columnValues: columnValues(PotShare.t.updateTable),
      where: where(PotShare.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PotShare.t),
      orderByList: orderByList?.call(PotShare.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PotShare]s in the list and returns the deleted rows.
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
  Future<List<PotShare>> delete(
    _is.DatabaseSession session,
    List<PotShare> rows, {
    _is.OrderByBuilder<PotShareTable>? orderBy,
    _is.OrderByListBuilder<PotShareTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PotShare>(
      rows,
      orderBy: orderBy?.call(PotShare.t),
      orderByList: orderByList?.call(PotShare.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PotShare].
  Future<PotShare> deleteRow(
    _is.DatabaseSession session,
    PotShare row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PotShare>(
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
  Future<List<PotShare>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PotShareTable> where,
    _is.OrderByBuilder<PotShareTable>? orderBy,
    _is.OrderByListBuilder<PotShareTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PotShare>(
      where: where(PotShare.t),
      orderBy: orderBy?.call(PotShare.t),
      orderByList: orderByList?.call(PotShare.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PotShareTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PotShare>(
      where: where?.call(PotShare.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PotShare] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PotShareTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PotShare>(
      where: where(PotShare.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
