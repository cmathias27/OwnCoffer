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

/// An item acquired in Pépite's shop (decision 0028, points 4-5).
abstract class PepiteItem
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PepiteItem._({
    this.id,
    required this.authUserId,
    required this.code,
    DateTime? acquiredAt,
    bool? equipped,
  }) : acquiredAt = acquiredAt ?? DateTime.now(),
       equipped = equipped ?? false;

  factory PepiteItem({
    int? id,
    required _is.UuidValue authUserId,
    required String code,
    DateTime? acquiredAt,
    bool? equipped,
  }) = _PepiteItemImpl;

  factory PepiteItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteItem(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      code: jsonSerialization['code'] as String,
      acquiredAt: jsonSerialization['acquiredAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['acquiredAt']),
      equipped: jsonSerialization['equipped'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['equipped']),
    );
  }

  static final t = PepiteItemTable();

  static const db = PepiteItemRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String code;

  DateTime acquiredAt;

  bool equipped;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PepiteItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteItem copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? code,
    DateTime? acquiredAt,
    bool? equipped,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteItem',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'code': code,
      'acquiredAt': acquiredAt.toJson(),
      'equipped': equipped,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PepiteItemInclude include() {
    return PepiteItemInclude._();
  }

  static PepiteItemIncludeList includeList({
    _is.WhereExpressionBuilder<PepiteItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteItemTable>? orderBy,
    _is.OrderByListBuilder<PepiteItemTable>? orderByList,
    PepiteItemInclude? include,
  }) {
    return PepiteItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteItem.t),
      orderByList: orderByList?.call(PepiteItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteItemImpl extends PepiteItem {
  _PepiteItemImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String code,
    DateTime? acquiredAt,
    bool? equipped,
  }) : super._(
         id: id,
         authUserId: authUserId,
         code: code,
         acquiredAt: acquiredAt,
         equipped: equipped,
       );

  /// Returns a shallow copy of this [PepiteItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteItem copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? code,
    DateTime? acquiredAt,
    bool? equipped,
  }) {
    return PepiteItem(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      code: code ?? this.code,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      equipped: equipped ?? this.equipped,
    );
  }
}

class PepiteItemUpdateTable extends _is.UpdateTable<PepiteItemTable> {
  PepiteItemUpdateTable(super.table);

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

  _is.ColumnValue<DateTime, DateTime> acquiredAt(DateTime value) =>
      _is.ColumnValue(
        table.acquiredAt,
        value,
      );

  _is.ColumnValue<bool, bool> equipped(bool value) => _is.ColumnValue(
    table.equipped,
    value,
  );
}

class PepiteItemTable extends _is.Table<int?> {
  PepiteItemTable({super.tableRelation}) : super(tableName: 'pepite_items') {
    updateTable = PepiteItemUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    acquiredAt = _is.ColumnDateTime(
      'acquiredAt',
      this,
      hasDefault: true,
    );
    equipped = _is.ColumnBool(
      'equipped',
      this,
      hasDefault: true,
    );
  }

  late final PepiteItemUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString code;

  late final _is.ColumnDateTime acquiredAt;

  late final _is.ColumnBool equipped;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    code,
    acquiredAt,
    equipped,
  ];
}

class PepiteItemInclude extends _is.IncludeObject {
  PepiteItemInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PepiteItem.t;
}

class PepiteItemIncludeList extends _is.IncludeList {
  PepiteItemIncludeList._({
    _is.WhereExpressionBuilder<PepiteItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PepiteItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PepiteItem.t;
}

class PepiteItemRepository {
  const PepiteItemRepository._();

  /// Returns a list of [PepiteItem]s matching the given query parameters.
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
  Future<List<PepiteItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteItemTable>? orderBy,
    _is.OrderByListBuilder<PepiteItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PepiteItem>(
      where: where?.call(PepiteItem.t),
      orderBy: orderBy?.call(PepiteItem.t),
      orderByList: orderByList?.call(PepiteItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PepiteItem] matching the given query parameters.
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
  Future<PepiteItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteItemTable>? where,
    int? offset,
    _is.OrderByBuilder<PepiteItemTable>? orderBy,
    _is.OrderByListBuilder<PepiteItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PepiteItem>(
      where: where?.call(PepiteItem.t),
      orderBy: orderBy?.call(PepiteItem.t),
      orderByList: orderByList?.call(PepiteItem.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PepiteItem] by its [id] or null if no such row exists.
  Future<PepiteItem?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PepiteItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PepiteItem]s in the list and returns the inserted rows.
  ///
  /// The returned [PepiteItem]s will have their `id` fields set.
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
  Future<List<PepiteItem>> insert(
    _is.DatabaseSession session,
    List<PepiteItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PepiteItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PepiteItem] and returns the inserted row.
  ///
  /// The returned [PepiteItem] will have its `id` field set.
  Future<PepiteItem> insertRow(
    _is.DatabaseSession session,
    PepiteItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PepiteItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PepiteItem]s in the list and returns the resulting rows.
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
  /// The returned [PepiteItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteItem>> upsert(
    _is.DatabaseSession session,
    List<PepiteItem> rows, {
    required _is.ColumnSelections<PepiteItemTable> conflictColumns,
    _is.ColumnSelections<PepiteItemTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PepiteItem>(
      rows,
      conflictColumns: conflictColumns(PepiteItem.t),
      updateColumns: updateColumns?.call(PepiteItem.t),
      updateWhere: updateWhere?.call(PepiteItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PepiteItem] and returns the resulting row.
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
  /// The returned [PepiteItem] will have its `id` field set.
  Future<PepiteItem?> upsertRow(
    _is.DatabaseSession session,
    PepiteItem row, {
    required _is.ColumnSelections<PepiteItemTable> conflictColumns,
    _is.ColumnSelections<PepiteItemTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PepiteItem>(
      row,
      conflictColumns: conflictColumns(PepiteItem.t),
      updateColumns: updateColumns?.call(PepiteItem.t),
      updateWhere: updateWhere?.call(PepiteItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteItem>> update(
    _is.DatabaseSession session,
    List<PepiteItem> rows, {
    _is.ColumnSelections<PepiteItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PepiteItem>(
      rows,
      columns: columns?.call(PepiteItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PepiteItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PepiteItem> updateRow(
    _is.DatabaseSession session,
    PepiteItem row, {
    _is.ColumnSelections<PepiteItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PepiteItem>(
      row,
      columns: columns?.call(PepiteItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PepiteItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PepiteItem?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PepiteItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PepiteItem>(
      id,
      columnValues: columnValues(PepiteItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PepiteItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PepiteItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteItemTable>? orderBy,
    _is.OrderByListBuilder<PepiteItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PepiteItem>(
      columnValues: columnValues(PepiteItem.t.updateTable),
      where: where(PepiteItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteItem.t),
      orderByList: orderByList?.call(PepiteItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PepiteItem]s in the list and returns the deleted rows.
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
  Future<List<PepiteItem>> delete(
    _is.DatabaseSession session,
    List<PepiteItem> rows, {
    _is.OrderByBuilder<PepiteItemTable>? orderBy,
    _is.OrderByListBuilder<PepiteItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PepiteItem>(
      rows,
      orderBy: orderBy?.call(PepiteItem.t),
      orderByList: orderByList?.call(PepiteItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PepiteItem].
  Future<PepiteItem> deleteRow(
    _is.DatabaseSession session,
    PepiteItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PepiteItem>(
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
  Future<List<PepiteItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteItemTable> where,
    _is.OrderByBuilder<PepiteItemTable>? orderBy,
    _is.OrderByListBuilder<PepiteItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PepiteItem>(
      where: where(PepiteItem.t),
      orderBy: orderBy?.call(PepiteItem.t),
      orderByList: orderByList?.call(PepiteItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PepiteItem>(
      where: where?.call(PepiteItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PepiteItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PepiteItem>(
      where: where(PepiteItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
