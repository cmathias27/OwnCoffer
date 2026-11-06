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

/// A badge earned with Pépite (decision 0026), once per user.
abstract class PepiteBadge
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PepiteBadge._({
    this.id,
    required this.authUserId,
    required this.code,
    required this.earnedAt,
  });

  factory PepiteBadge({
    int? id,
    required _is.UuidValue authUserId,
    required String code,
    required DateTime earnedAt,
  }) = _PepiteBadgeImpl;

  factory PepiteBadge.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteBadge(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      code: jsonSerialization['code'] as String,
      earnedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['earnedAt'],
      ),
    );
  }

  static final t = PepiteBadgeTable();

  static const db = PepiteBadgeRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  String code;

  DateTime earnedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PepiteBadge]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteBadge copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? code,
    DateTime? earnedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteBadge',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'code': code,
      'earnedAt': earnedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PepiteBadgeInclude include() {
    return PepiteBadgeInclude._();
  }

  static PepiteBadgeIncludeList includeList({
    _is.WhereExpressionBuilder<PepiteBadgeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteBadgeTable>? orderBy,
    _is.OrderByListBuilder<PepiteBadgeTable>? orderByList,
    PepiteBadgeInclude? include,
  }) {
    return PepiteBadgeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteBadge.t),
      orderByList: orderByList?.call(PepiteBadge.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteBadgeImpl extends PepiteBadge {
  _PepiteBadgeImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String code,
    required DateTime earnedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         code: code,
         earnedAt: earnedAt,
       );

  /// Returns a shallow copy of this [PepiteBadge]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteBadge copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? code,
    DateTime? earnedAt,
  }) {
    return PepiteBadge(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      code: code ?? this.code,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }
}

class PepiteBadgeUpdateTable extends _is.UpdateTable<PepiteBadgeTable> {
  PepiteBadgeUpdateTable(super.table);

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

  _is.ColumnValue<DateTime, DateTime> earnedAt(DateTime value) =>
      _is.ColumnValue(
        table.earnedAt,
        value,
      );
}

class PepiteBadgeTable extends _is.Table<int?> {
  PepiteBadgeTable({super.tableRelation}) : super(tableName: 'pepite_badges') {
    updateTable = PepiteBadgeUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    earnedAt = _is.ColumnDateTime(
      'earnedAt',
      this,
    );
  }

  late final PepiteBadgeUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString code;

  late final _is.ColumnDateTime earnedAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    code,
    earnedAt,
  ];
}

class PepiteBadgeInclude extends _is.IncludeObject {
  PepiteBadgeInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PepiteBadge.t;
}

class PepiteBadgeIncludeList extends _is.IncludeList {
  PepiteBadgeIncludeList._({
    _is.WhereExpressionBuilder<PepiteBadgeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PepiteBadge.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PepiteBadge.t;
}

class PepiteBadgeRepository {
  const PepiteBadgeRepository._();

  /// Returns a list of [PepiteBadge]s matching the given query parameters.
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
  Future<List<PepiteBadge>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteBadgeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteBadgeTable>? orderBy,
    _is.OrderByListBuilder<PepiteBadgeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PepiteBadge>(
      where: where?.call(PepiteBadge.t),
      orderBy: orderBy?.call(PepiteBadge.t),
      orderByList: orderByList?.call(PepiteBadge.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PepiteBadge] matching the given query parameters.
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
  Future<PepiteBadge?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteBadgeTable>? where,
    int? offset,
    _is.OrderByBuilder<PepiteBadgeTable>? orderBy,
    _is.OrderByListBuilder<PepiteBadgeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PepiteBadge>(
      where: where?.call(PepiteBadge.t),
      orderBy: orderBy?.call(PepiteBadge.t),
      orderByList: orderByList?.call(PepiteBadge.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PepiteBadge] by its [id] or null if no such row exists.
  Future<PepiteBadge?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PepiteBadge>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PepiteBadge]s in the list and returns the inserted rows.
  ///
  /// The returned [PepiteBadge]s will have their `id` fields set.
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
  Future<List<PepiteBadge>> insert(
    _is.DatabaseSession session,
    List<PepiteBadge> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PepiteBadge>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PepiteBadge] and returns the inserted row.
  ///
  /// The returned [PepiteBadge] will have its `id` field set.
  Future<PepiteBadge> insertRow(
    _is.DatabaseSession session,
    PepiteBadge row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PepiteBadge>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PepiteBadge]s in the list and returns the resulting rows.
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
  /// The returned [PepiteBadge]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteBadge>> upsert(
    _is.DatabaseSession session,
    List<PepiteBadge> rows, {
    required _is.ColumnSelections<PepiteBadgeTable> conflictColumns,
    _is.ColumnSelections<PepiteBadgeTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteBadgeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PepiteBadge>(
      rows,
      conflictColumns: conflictColumns(PepiteBadge.t),
      updateColumns: updateColumns?.call(PepiteBadge.t),
      updateWhere: updateWhere?.call(PepiteBadge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PepiteBadge] and returns the resulting row.
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
  /// The returned [PepiteBadge] will have its `id` field set.
  Future<PepiteBadge?> upsertRow(
    _is.DatabaseSession session,
    PepiteBadge row, {
    required _is.ColumnSelections<PepiteBadgeTable> conflictColumns,
    _is.ColumnSelections<PepiteBadgeTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteBadgeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PepiteBadge>(
      row,
      conflictColumns: conflictColumns(PepiteBadge.t),
      updateColumns: updateColumns?.call(PepiteBadge.t),
      updateWhere: updateWhere?.call(PepiteBadge.t),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteBadge]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteBadge>> update(
    _is.DatabaseSession session,
    List<PepiteBadge> rows, {
    _is.ColumnSelections<PepiteBadgeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PepiteBadge>(
      rows,
      columns: columns?.call(PepiteBadge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PepiteBadge]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PepiteBadge> updateRow(
    _is.DatabaseSession session,
    PepiteBadge row, {
    _is.ColumnSelections<PepiteBadgeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PepiteBadge>(
      row,
      columns: columns?.call(PepiteBadge.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PepiteBadge] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PepiteBadge?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PepiteBadgeUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PepiteBadge>(
      id,
      columnValues: columnValues(PepiteBadge.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteBadge]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteBadge>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PepiteBadgeUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PepiteBadgeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteBadgeTable>? orderBy,
    _is.OrderByListBuilder<PepiteBadgeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PepiteBadge>(
      columnValues: columnValues(PepiteBadge.t.updateTable),
      where: where(PepiteBadge.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteBadge.t),
      orderByList: orderByList?.call(PepiteBadge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PepiteBadge]s in the list and returns the deleted rows.
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
  Future<List<PepiteBadge>> delete(
    _is.DatabaseSession session,
    List<PepiteBadge> rows, {
    _is.OrderByBuilder<PepiteBadgeTable>? orderBy,
    _is.OrderByListBuilder<PepiteBadgeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PepiteBadge>(
      rows,
      orderBy: orderBy?.call(PepiteBadge.t),
      orderByList: orderByList?.call(PepiteBadge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PepiteBadge].
  Future<PepiteBadge> deleteRow(
    _is.DatabaseSession session,
    PepiteBadge row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PepiteBadge>(
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
  Future<List<PepiteBadge>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteBadgeTable> where,
    _is.OrderByBuilder<PepiteBadgeTable>? orderBy,
    _is.OrderByListBuilder<PepiteBadgeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PepiteBadge>(
      where: where(PepiteBadge.t),
      orderBy: orderBy?.call(PepiteBadge.t),
      orderByList: orderByList?.call(PepiteBadge.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteBadgeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PepiteBadge>(
      where: where?.call(PepiteBadge.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PepiteBadge] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteBadgeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PepiteBadge>(
      where: where(PepiteBadge.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
