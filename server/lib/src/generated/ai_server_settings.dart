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

/// Server-wide AI settings configured by the server administrator.
abstract class AiServerSettings
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AiServerSettings._({
    this.id,
    int? autonomyLevel,
    DateTime? updatedAt,
  }) : autonomyLevel = autonomyLevel ?? 3,
       updatedAt = updatedAt ?? DateTime.now();

  factory AiServerSettings({
    int? id,
    int? autonomyLevel,
    DateTime? updatedAt,
  }) = _AiServerSettingsImpl;

  factory AiServerSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiServerSettings(
      id: jsonSerialization['id'] as int?,
      autonomyLevel: jsonSerialization['autonomyLevel'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AiServerSettingsTable();

  static const db = AiServerSettingsRepository._();

  @override
  int? id;

  /// Autonomy level allowed on this server (1 to 5):
  /// 1: Read-only (context queries only, no proposals or document analysis)
  /// 2: Document consultation (reads receipts/invoices and loan documents)
  /// 3: Proposals (propose actions in "Mon conseiller" requiring user confirmation)
  /// 4: Limited automation (reversible operations with audit trail)
  /// 5: Full internal control (autonomous internal actions, never external bank operations)
  int autonomyLevel;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AiServerSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiServerSettings copyWith({
    int? id,
    int? autonomyLevel,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiServerSettings',
      if (id != null) 'id': id,
      'autonomyLevel': autonomyLevel,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiServerSettings',
      if (id != null) 'id': id,
      'autonomyLevel': autonomyLevel,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AiServerSettingsInclude include() {
    return AiServerSettingsInclude._();
  }

  static AiServerSettingsIncludeList includeList({
    _is.WhereExpressionBuilder<AiServerSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiServerSettingsTable>? orderBy,
    _is.OrderByListBuilder<AiServerSettingsTable>? orderByList,
    AiServerSettingsInclude? include,
  }) {
    return AiServerSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiServerSettings.t),
      orderByList: orderByList?.call(AiServerSettings.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiServerSettingsImpl extends AiServerSettings {
  _AiServerSettingsImpl({
    int? id,
    int? autonomyLevel,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         autonomyLevel: autonomyLevel,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AiServerSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiServerSettings copyWith({
    Object? id = _Undefined,
    int? autonomyLevel,
    DateTime? updatedAt,
  }) {
    return AiServerSettings(
      id: id is int? ? id : this.id,
      autonomyLevel: autonomyLevel ?? this.autonomyLevel,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AiServerSettingsUpdateTable
    extends _is.UpdateTable<AiServerSettingsTable> {
  AiServerSettingsUpdateTable(super.table);

  _is.ColumnValue<int, int> autonomyLevel(int value) => _is.ColumnValue(
    table.autonomyLevel,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class AiServerSettingsTable extends _is.Table<int?> {
  AiServerSettingsTable({super.tableRelation})
    : super(tableName: 'ai_server_settings') {
    updateTable = AiServerSettingsUpdateTable(this);
    autonomyLevel = _is.ColumnInt(
      'autonomyLevel',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final AiServerSettingsUpdateTable updateTable;

  /// Autonomy level allowed on this server (1 to 5):
  /// 1: Read-only (context queries only, no proposals or document analysis)
  /// 2: Document consultation (reads receipts/invoices and loan documents)
  /// 3: Proposals (propose actions in "Mon conseiller" requiring user confirmation)
  /// 4: Limited automation (reversible operations with audit trail)
  /// 5: Full internal control (autonomous internal actions, never external bank operations)
  late final _is.ColumnInt autonomyLevel;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    autonomyLevel,
    updatedAt,
  ];
}

class AiServerSettingsInclude extends _is.IncludeObject {
  AiServerSettingsInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AiServerSettings.t;
}

class AiServerSettingsIncludeList extends _is.IncludeList {
  AiServerSettingsIncludeList._({
    _is.WhereExpressionBuilder<AiServerSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiServerSettings.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AiServerSettings.t;
}

class AiServerSettingsRepository {
  const AiServerSettingsRepository._();

  /// Returns a list of [AiServerSettings]s matching the given query parameters.
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
  Future<List<AiServerSettings>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiServerSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiServerSettingsTable>? orderBy,
    _is.OrderByListBuilder<AiServerSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiServerSettings>(
      where: where?.call(AiServerSettings.t),
      orderBy: orderBy?.call(AiServerSettings.t),
      orderByList: orderByList?.call(AiServerSettings.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiServerSettings] matching the given query parameters.
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
  Future<AiServerSettings?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiServerSettingsTable>? where,
    int? offset,
    _is.OrderByBuilder<AiServerSettingsTable>? orderBy,
    _is.OrderByListBuilder<AiServerSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiServerSettings>(
      where: where?.call(AiServerSettings.t),
      orderBy: orderBy?.call(AiServerSettings.t),
      orderByList: orderByList?.call(AiServerSettings.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiServerSettings] by its [id] or null if no such row exists.
  Future<AiServerSettings?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiServerSettings>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiServerSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [AiServerSettings]s will have their `id` fields set.
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
  Future<List<AiServerSettings>> insert(
    _is.DatabaseSession session,
    List<AiServerSettings> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiServerSettings>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiServerSettings] and returns the inserted row.
  ///
  /// The returned [AiServerSettings] will have its `id` field set.
  Future<AiServerSettings> insertRow(
    _is.DatabaseSession session,
    AiServerSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiServerSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiServerSettings]s in the list and returns the resulting rows.
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
  /// The returned [AiServerSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiServerSettings>> upsert(
    _is.DatabaseSession session,
    List<AiServerSettings> rows, {
    required _is.ColumnSelections<AiServerSettingsTable> conflictColumns,
    _is.ColumnSelections<AiServerSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<AiServerSettingsTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiServerSettings>(
      rows,
      conflictColumns: conflictColumns(AiServerSettings.t),
      updateColumns: updateColumns?.call(AiServerSettings.t),
      updateWhere: updateWhere?.call(AiServerSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiServerSettings] and returns the resulting row.
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
  /// The returned [AiServerSettings] will have its `id` field set.
  Future<AiServerSettings?> upsertRow(
    _is.DatabaseSession session,
    AiServerSettings row, {
    required _is.ColumnSelections<AiServerSettingsTable> conflictColumns,
    _is.ColumnSelections<AiServerSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<AiServerSettingsTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiServerSettings>(
      row,
      conflictColumns: conflictColumns(AiServerSettings.t),
      updateColumns: updateColumns?.call(AiServerSettings.t),
      updateWhere: updateWhere?.call(AiServerSettings.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiServerSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiServerSettings>> update(
    _is.DatabaseSession session,
    List<AiServerSettings> rows, {
    _is.ColumnSelections<AiServerSettingsTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiServerSettings>(
      rows,
      columns: columns?.call(AiServerSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiServerSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiServerSettings> updateRow(
    _is.DatabaseSession session,
    AiServerSettings row, {
    _is.ColumnSelections<AiServerSettingsTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiServerSettings>(
      row,
      columns: columns?.call(AiServerSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiServerSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiServerSettings?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AiServerSettingsUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiServerSettings>(
      id,
      columnValues: columnValues(AiServerSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiServerSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiServerSettings>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiServerSettingsUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AiServerSettingsTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiServerSettingsTable>? orderBy,
    _is.OrderByListBuilder<AiServerSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiServerSettings>(
      columnValues: columnValues(AiServerSettings.t.updateTable),
      where: where(AiServerSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiServerSettings.t),
      orderByList: orderByList?.call(AiServerSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiServerSettings]s in the list and returns the deleted rows.
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
  Future<List<AiServerSettings>> delete(
    _is.DatabaseSession session,
    List<AiServerSettings> rows, {
    _is.OrderByBuilder<AiServerSettingsTable>? orderBy,
    _is.OrderByListBuilder<AiServerSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiServerSettings>(
      rows,
      orderBy: orderBy?.call(AiServerSettings.t),
      orderByList: orderByList?.call(AiServerSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiServerSettings].
  Future<AiServerSettings> deleteRow(
    _is.DatabaseSession session,
    AiServerSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiServerSettings>(
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
  Future<List<AiServerSettings>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiServerSettingsTable> where,
    _is.OrderByBuilder<AiServerSettingsTable>? orderBy,
    _is.OrderByListBuilder<AiServerSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiServerSettings>(
      where: where(AiServerSettings.t),
      orderBy: orderBy?.call(AiServerSettings.t),
      orderByList: orderByList?.call(AiServerSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiServerSettingsTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiServerSettings>(
      where: where?.call(AiServerSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiServerSettings] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiServerSettingsTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiServerSettings>(
      where: where(AiServerSettings.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
