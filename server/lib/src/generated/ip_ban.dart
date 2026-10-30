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

/// Failed attempts and bans per client IP (roadbook phase 2): 5 failures in
/// 15 minutes ban the IP for 1 hour, doubled at each new ban.
abstract class IpBan implements _is.TableRow<int?>, _is.ProtocolSerialization {
  IpBan._({
    this.id,
    required this.ip,
    int? failures,
    required this.windowStart,
    required this.lastFailureAt,
    required this.lastFailureKind,
    this.bannedUntil,
    int? banCount,
  }) : failures = failures ?? 0,
       banCount = banCount ?? 0;

  factory IpBan({
    int? id,
    required String ip,
    int? failures,
    required DateTime windowStart,
    required DateTime lastFailureAt,
    required String lastFailureKind,
    DateTime? bannedUntil,
    int? banCount,
  }) = _IpBanImpl;

  factory IpBan.fromJson(Map<String, dynamic> jsonSerialization) {
    return IpBan(
      id: jsonSerialization['id'] as int?,
      ip: jsonSerialization['ip'] as String,
      failures: jsonSerialization['failures'] as int?,
      windowStart: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['windowStart'],
      ),
      lastFailureAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastFailureAt'],
      ),
      lastFailureKind: jsonSerialization['lastFailureKind'] as String,
      bannedUntil: jsonSerialization['bannedUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['bannedUntil'],
            ),
      banCount: jsonSerialization['banCount'] as int?,
    );
  }

  static final t = IpBanTable();

  static const db = IpBanRepository._();

  @override
  int? id;

  String ip;

  int failures;

  DateTime windowStart;

  DateTime lastFailureAt;

  String lastFailureKind;

  DateTime? bannedUntil;

  int banCount;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [IpBan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IpBan copyWith({
    int? id,
    String? ip,
    int? failures,
    DateTime? windowStart,
    DateTime? lastFailureAt,
    String? lastFailureKind,
    DateTime? bannedUntil,
    int? banCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IpBan',
      if (id != null) 'id': id,
      'ip': ip,
      'failures': failures,
      'windowStart': windowStart.toJson(),
      'lastFailureAt': lastFailureAt.toJson(),
      'lastFailureKind': lastFailureKind,
      if (bannedUntil != null) 'bannedUntil': bannedUntil?.toJson(),
      'banCount': banCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static IpBanInclude include() {
    return IpBanInclude._();
  }

  static IpBanIncludeList includeList({
    _is.WhereExpressionBuilder<IpBanTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IpBanTable>? orderBy,
    _is.OrderByListBuilder<IpBanTable>? orderByList,
    IpBanInclude? include,
  }) {
    return IpBanIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IpBan.t),
      orderByList: orderByList?.call(IpBan.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IpBanImpl extends IpBan {
  _IpBanImpl({
    int? id,
    required String ip,
    int? failures,
    required DateTime windowStart,
    required DateTime lastFailureAt,
    required String lastFailureKind,
    DateTime? bannedUntil,
    int? banCount,
  }) : super._(
         id: id,
         ip: ip,
         failures: failures,
         windowStart: windowStart,
         lastFailureAt: lastFailureAt,
         lastFailureKind: lastFailureKind,
         bannedUntil: bannedUntil,
         banCount: banCount,
       );

  /// Returns a shallow copy of this [IpBan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IpBan copyWith({
    Object? id = _Undefined,
    String? ip,
    int? failures,
    DateTime? windowStart,
    DateTime? lastFailureAt,
    String? lastFailureKind,
    Object? bannedUntil = _Undefined,
    int? banCount,
  }) {
    return IpBan(
      id: id is int? ? id : this.id,
      ip: ip ?? this.ip,
      failures: failures ?? this.failures,
      windowStart: windowStart ?? this.windowStart,
      lastFailureAt: lastFailureAt ?? this.lastFailureAt,
      lastFailureKind: lastFailureKind ?? this.lastFailureKind,
      bannedUntil: bannedUntil is DateTime? ? bannedUntil : this.bannedUntil,
      banCount: banCount ?? this.banCount,
    );
  }
}

class IpBanUpdateTable extends _is.UpdateTable<IpBanTable> {
  IpBanUpdateTable(super.table);

  _is.ColumnValue<String, String> ip(String value) => _is.ColumnValue(
    table.ip,
    value,
  );

  _is.ColumnValue<int, int> failures(int value) => _is.ColumnValue(
    table.failures,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> windowStart(DateTime value) =>
      _is.ColumnValue(
        table.windowStart,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastFailureAt(DateTime value) =>
      _is.ColumnValue(
        table.lastFailureAt,
        value,
      );

  _is.ColumnValue<String, String> lastFailureKind(String value) =>
      _is.ColumnValue(
        table.lastFailureKind,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> bannedUntil(DateTime? value) =>
      _is.ColumnValue(
        table.bannedUntil,
        value,
      );

  _is.ColumnValue<int, int> banCount(int value) => _is.ColumnValue(
    table.banCount,
    value,
  );
}

class IpBanTable extends _is.Table<int?> {
  IpBanTable({super.tableRelation}) : super(tableName: 'ip_bans') {
    updateTable = IpBanUpdateTable(this);
    ip = _is.ColumnString(
      'ip',
      this,
    );
    failures = _is.ColumnInt(
      'failures',
      this,
      hasDefault: true,
    );
    windowStart = _is.ColumnDateTime(
      'windowStart',
      this,
    );
    lastFailureAt = _is.ColumnDateTime(
      'lastFailureAt',
      this,
    );
    lastFailureKind = _is.ColumnString(
      'lastFailureKind',
      this,
    );
    bannedUntil = _is.ColumnDateTime(
      'bannedUntil',
      this,
    );
    banCount = _is.ColumnInt(
      'banCount',
      this,
      hasDefault: true,
    );
  }

  late final IpBanUpdateTable updateTable;

  late final _is.ColumnString ip;

  late final _is.ColumnInt failures;

  late final _is.ColumnDateTime windowStart;

  late final _is.ColumnDateTime lastFailureAt;

  late final _is.ColumnString lastFailureKind;

  late final _is.ColumnDateTime bannedUntil;

  late final _is.ColumnInt banCount;

  @override
  List<_is.Column> get columns => [
    id,
    ip,
    failures,
    windowStart,
    lastFailureAt,
    lastFailureKind,
    bannedUntil,
    banCount,
  ];
}

class IpBanInclude extends _is.IncludeObject {
  IpBanInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IpBan.t;
}

class IpBanIncludeList extends _is.IncludeList {
  IpBanIncludeList._({
    _is.WhereExpressionBuilder<IpBanTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IpBan.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IpBan.t;
}

class IpBanRepository {
  const IpBanRepository._();

  /// Returns a list of [IpBan]s matching the given query parameters.
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
  Future<List<IpBan>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IpBanTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IpBanTable>? orderBy,
    _is.OrderByListBuilder<IpBanTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IpBan>(
      where: where?.call(IpBan.t),
      orderBy: orderBy?.call(IpBan.t),
      orderByList: orderByList?.call(IpBan.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IpBan] matching the given query parameters.
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
  Future<IpBan?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IpBanTable>? where,
    int? offset,
    _is.OrderByBuilder<IpBanTable>? orderBy,
    _is.OrderByListBuilder<IpBanTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IpBan>(
      where: where?.call(IpBan.t),
      orderBy: orderBy?.call(IpBan.t),
      orderByList: orderByList?.call(IpBan.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IpBan] by its [id] or null if no such row exists.
  Future<IpBan?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IpBan>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IpBan]s in the list and returns the inserted rows.
  ///
  /// The returned [IpBan]s will have their `id` fields set.
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
  Future<List<IpBan>> insert(
    _is.DatabaseSession session,
    List<IpBan> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IpBan>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IpBan] and returns the inserted row.
  ///
  /// The returned [IpBan] will have its `id` field set.
  Future<IpBan> insertRow(
    _is.DatabaseSession session,
    IpBan row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<IpBan>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IpBan]s in the list and returns the resulting rows.
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
  /// The returned [IpBan]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IpBan>> upsert(
    _is.DatabaseSession session,
    List<IpBan> rows, {
    required _is.ColumnSelections<IpBanTable> conflictColumns,
    _is.ColumnSelections<IpBanTable>? updateColumns,
    _is.WhereExpressionBuilder<IpBanTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IpBan>(
      rows,
      conflictColumns: conflictColumns(IpBan.t),
      updateColumns: updateColumns?.call(IpBan.t),
      updateWhere: updateWhere?.call(IpBan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IpBan] and returns the resulting row.
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
  /// The returned [IpBan] will have its `id` field set.
  Future<IpBan?> upsertRow(
    _is.DatabaseSession session,
    IpBan row, {
    required _is.ColumnSelections<IpBanTable> conflictColumns,
    _is.ColumnSelections<IpBanTable>? updateColumns,
    _is.WhereExpressionBuilder<IpBanTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IpBan>(
      row,
      conflictColumns: conflictColumns(IpBan.t),
      updateColumns: updateColumns?.call(IpBan.t),
      updateWhere: updateWhere?.call(IpBan.t),
      transaction: transaction,
    );
  }

  /// Updates all [IpBan]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IpBan>> update(
    _is.DatabaseSession session,
    List<IpBan> rows, {
    _is.ColumnSelections<IpBanTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IpBan>(
      rows,
      columns: columns?.call(IpBan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IpBan]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IpBan> updateRow(
    _is.DatabaseSession session,
    IpBan row, {
    _is.ColumnSelections<IpBanTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<IpBan>(
      row,
      columns: columns?.call(IpBan.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IpBan] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IpBan?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IpBanUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<IpBan>(
      id,
      columnValues: columnValues(IpBan.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IpBan]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IpBan>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IpBanUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<IpBanTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IpBanTable>? orderBy,
    _is.OrderByListBuilder<IpBanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IpBan>(
      columnValues: columnValues(IpBan.t.updateTable),
      where: where(IpBan.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IpBan.t),
      orderByList: orderByList?.call(IpBan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IpBan]s in the list and returns the deleted rows.
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
  Future<List<IpBan>> delete(
    _is.DatabaseSession session,
    List<IpBan> rows, {
    _is.OrderByBuilder<IpBanTable>? orderBy,
    _is.OrderByListBuilder<IpBanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IpBan>(
      rows,
      orderBy: orderBy?.call(IpBan.t),
      orderByList: orderByList?.call(IpBan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IpBan].
  Future<IpBan> deleteRow(
    _is.DatabaseSession session,
    IpBan row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IpBan>(
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
  Future<List<IpBan>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IpBanTable> where,
    _is.OrderByBuilder<IpBanTable>? orderBy,
    _is.OrderByListBuilder<IpBanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IpBan>(
      where: where(IpBan.t),
      orderBy: orderBy?.call(IpBan.t),
      orderByList: orderByList?.call(IpBan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IpBanTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<IpBan>(
      where: where?.call(IpBan.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IpBan] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IpBanTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IpBan>(
      where: where(IpBan.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
