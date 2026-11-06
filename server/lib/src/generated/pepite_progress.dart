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

/// Pépite, the mascot (decision 0026): a user's seed reserve and weekly
/// accounts rituals. The reserve only grows; a missed week resets nothing.
abstract class PepiteProgress
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PepiteProgress._({
    this.id,
    required this.authUserId,
    required this.seeds,
    required this.weeks,
    this.lastWeek,
    this.firstRitualAt,
    this.lastRitualAt,
  });

  factory PepiteProgress({
    int? id,
    required _is.UuidValue authUserId,
    required int seeds,
    required int weeks,
    DateTime? lastWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
  }) = _PepiteProgressImpl;

  factory PepiteProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteProgress(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      seeds: jsonSerialization['seeds'] as int,
      weeks: jsonSerialization['weeks'] as int,
      lastWeek: jsonSerialization['lastWeek'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastWeek']),
      firstRitualAt: jsonSerialization['firstRitualAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstRitualAt'],
            ),
      lastRitualAt: jsonSerialization['lastRitualAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastRitualAt'],
            ),
    );
  }

  static final t = PepiteProgressTable();

  static const db = PepiteProgressRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  int seeds;

  /// Weeks with a ritual done, in all (not in a row).
  int weeks;

  /// Monday of the last week with a ritual (a date, no time zone).
  DateTime? lastWeek;

  DateTime? firstRitualAt;

  DateTime? lastRitualAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PepiteProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteProgress copyWith({
    int? id,
    _is.UuidValue? authUserId,
    int? seeds,
    int? weeks,
    DateTime? lastWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteProgress',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'seeds': seeds,
      'weeks': weeks,
      if (lastWeek != null) 'lastWeek': lastWeek?.toJson(),
      if (firstRitualAt != null) 'firstRitualAt': firstRitualAt?.toJson(),
      if (lastRitualAt != null) 'lastRitualAt': lastRitualAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PepiteProgressInclude include() {
    return PepiteProgressInclude._();
  }

  static PepiteProgressIncludeList includeList({
    _is.WhereExpressionBuilder<PepiteProgressTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteProgressTable>? orderBy,
    _is.OrderByListBuilder<PepiteProgressTable>? orderByList,
    PepiteProgressInclude? include,
  }) {
    return PepiteProgressIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteProgress.t),
      orderByList: orderByList?.call(PepiteProgress.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteProgressImpl extends PepiteProgress {
  _PepiteProgressImpl({
    int? id,
    required _is.UuidValue authUserId,
    required int seeds,
    required int weeks,
    DateTime? lastWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         seeds: seeds,
         weeks: weeks,
         lastWeek: lastWeek,
         firstRitualAt: firstRitualAt,
         lastRitualAt: lastRitualAt,
       );

  /// Returns a shallow copy of this [PepiteProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteProgress copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    int? seeds,
    int? weeks,
    Object? lastWeek = _Undefined,
    Object? firstRitualAt = _Undefined,
    Object? lastRitualAt = _Undefined,
  }) {
    return PepiteProgress(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      seeds: seeds ?? this.seeds,
      weeks: weeks ?? this.weeks,
      lastWeek: lastWeek is DateTime? ? lastWeek : this.lastWeek,
      firstRitualAt: firstRitualAt is DateTime?
          ? firstRitualAt
          : this.firstRitualAt,
      lastRitualAt: lastRitualAt is DateTime?
          ? lastRitualAt
          : this.lastRitualAt,
    );
  }
}

class PepiteProgressUpdateTable extends _is.UpdateTable<PepiteProgressTable> {
  PepiteProgressUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> seeds(int value) => _is.ColumnValue(
    table.seeds,
    value,
  );

  _is.ColumnValue<int, int> weeks(int value) => _is.ColumnValue(
    table.weeks,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastWeek(DateTime? value) =>
      _is.ColumnValue(
        table.lastWeek,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> firstRitualAt(DateTime? value) =>
      _is.ColumnValue(
        table.firstRitualAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastRitualAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastRitualAt,
        value,
      );
}

class PepiteProgressTable extends _is.Table<int?> {
  PepiteProgressTable({super.tableRelation})
    : super(tableName: 'pepite_progress') {
    updateTable = PepiteProgressUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    seeds = _is.ColumnInt(
      'seeds',
      this,
    );
    weeks = _is.ColumnInt(
      'weeks',
      this,
    );
    lastWeek = _is.ColumnDateTime(
      'lastWeek',
      this,
    );
    firstRitualAt = _is.ColumnDateTime(
      'firstRitualAt',
      this,
    );
    lastRitualAt = _is.ColumnDateTime(
      'lastRitualAt',
      this,
    );
  }

  late final PepiteProgressUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnInt seeds;

  /// Weeks with a ritual done, in all (not in a row).
  late final _is.ColumnInt weeks;

  /// Monday of the last week with a ritual (a date, no time zone).
  late final _is.ColumnDateTime lastWeek;

  late final _is.ColumnDateTime firstRitualAt;

  late final _is.ColumnDateTime lastRitualAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    seeds,
    weeks,
    lastWeek,
    firstRitualAt,
    lastRitualAt,
  ];
}

class PepiteProgressInclude extends _is.IncludeObject {
  PepiteProgressInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PepiteProgress.t;
}

class PepiteProgressIncludeList extends _is.IncludeList {
  PepiteProgressIncludeList._({
    _is.WhereExpressionBuilder<PepiteProgressTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PepiteProgress.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PepiteProgress.t;
}

class PepiteProgressRepository {
  const PepiteProgressRepository._();

  /// Returns a list of [PepiteProgress]s matching the given query parameters.
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
  Future<List<PepiteProgress>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteProgressTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteProgressTable>? orderBy,
    _is.OrderByListBuilder<PepiteProgressTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PepiteProgress>(
      where: where?.call(PepiteProgress.t),
      orderBy: orderBy?.call(PepiteProgress.t),
      orderByList: orderByList?.call(PepiteProgress.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PepiteProgress] matching the given query parameters.
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
  Future<PepiteProgress?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteProgressTable>? where,
    int? offset,
    _is.OrderByBuilder<PepiteProgressTable>? orderBy,
    _is.OrderByListBuilder<PepiteProgressTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PepiteProgress>(
      where: where?.call(PepiteProgress.t),
      orderBy: orderBy?.call(PepiteProgress.t),
      orderByList: orderByList?.call(PepiteProgress.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PepiteProgress] by its [id] or null if no such row exists.
  Future<PepiteProgress?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PepiteProgress>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PepiteProgress]s in the list and returns the inserted rows.
  ///
  /// The returned [PepiteProgress]s will have their `id` fields set.
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
  Future<List<PepiteProgress>> insert(
    _is.DatabaseSession session,
    List<PepiteProgress> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PepiteProgress>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PepiteProgress] and returns the inserted row.
  ///
  /// The returned [PepiteProgress] will have its `id` field set.
  Future<PepiteProgress> insertRow(
    _is.DatabaseSession session,
    PepiteProgress row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PepiteProgress>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PepiteProgress]s in the list and returns the resulting rows.
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
  /// The returned [PepiteProgress]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteProgress>> upsert(
    _is.DatabaseSession session,
    List<PepiteProgress> rows, {
    required _is.ColumnSelections<PepiteProgressTable> conflictColumns,
    _is.ColumnSelections<PepiteProgressTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteProgressTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PepiteProgress>(
      rows,
      conflictColumns: conflictColumns(PepiteProgress.t),
      updateColumns: updateColumns?.call(PepiteProgress.t),
      updateWhere: updateWhere?.call(PepiteProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PepiteProgress] and returns the resulting row.
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
  /// The returned [PepiteProgress] will have its `id` field set.
  Future<PepiteProgress?> upsertRow(
    _is.DatabaseSession session,
    PepiteProgress row, {
    required _is.ColumnSelections<PepiteProgressTable> conflictColumns,
    _is.ColumnSelections<PepiteProgressTable>? updateColumns,
    _is.WhereExpressionBuilder<PepiteProgressTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PepiteProgress>(
      row,
      conflictColumns: conflictColumns(PepiteProgress.t),
      updateColumns: updateColumns?.call(PepiteProgress.t),
      updateWhere: updateWhere?.call(PepiteProgress.t),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteProgress]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteProgress>> update(
    _is.DatabaseSession session,
    List<PepiteProgress> rows, {
    _is.ColumnSelections<PepiteProgressTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PepiteProgress>(
      rows,
      columns: columns?.call(PepiteProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PepiteProgress]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PepiteProgress> updateRow(
    _is.DatabaseSession session,
    PepiteProgress row, {
    _is.ColumnSelections<PepiteProgressTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PepiteProgress>(
      row,
      columns: columns?.call(PepiteProgress.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PepiteProgress] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PepiteProgress?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PepiteProgressUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PepiteProgress>(
      id,
      columnValues: columnValues(PepiteProgress.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PepiteProgress]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PepiteProgress>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PepiteProgressUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PepiteProgressTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PepiteProgressTable>? orderBy,
    _is.OrderByListBuilder<PepiteProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PepiteProgress>(
      columnValues: columnValues(PepiteProgress.t.updateTable),
      where: where(PepiteProgress.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PepiteProgress.t),
      orderByList: orderByList?.call(PepiteProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PepiteProgress]s in the list and returns the deleted rows.
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
  Future<List<PepiteProgress>> delete(
    _is.DatabaseSession session,
    List<PepiteProgress> rows, {
    _is.OrderByBuilder<PepiteProgressTable>? orderBy,
    _is.OrderByListBuilder<PepiteProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PepiteProgress>(
      rows,
      orderBy: orderBy?.call(PepiteProgress.t),
      orderByList: orderByList?.call(PepiteProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PepiteProgress].
  Future<PepiteProgress> deleteRow(
    _is.DatabaseSession session,
    PepiteProgress row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PepiteProgress>(
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
  Future<List<PepiteProgress>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteProgressTable> where,
    _is.OrderByBuilder<PepiteProgressTable>? orderBy,
    _is.OrderByListBuilder<PepiteProgressTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PepiteProgress>(
      where: where(PepiteProgress.t),
      orderBy: orderBy?.call(PepiteProgress.t),
      orderByList: orderByList?.call(PepiteProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PepiteProgressTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PepiteProgress>(
      where: where?.call(PepiteProgress.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PepiteProgress] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PepiteProgressTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PepiteProgress>(
      where: where(PepiteProgress.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
