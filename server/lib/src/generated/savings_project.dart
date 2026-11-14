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

/// A savings project (holiday, car, works…): a target, an optional date and
/// what is already saved, entered by hand (decision 0050).
abstract class SavingsProject
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SavingsProject._({
    this.id,
    required this.groupId,
    required this.name,
    required this.targetCents,
    int? savedCents,
    this.targetDate,
    this.accountId,
    DateTime? createdAt,
    this.archivedAt,
  }) : savedCents = savedCents ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory SavingsProject({
    int? id,
    required int groupId,
    required String name,
    required int targetCents,
    int? savedCents,
    DateTime? targetDate,
    int? accountId,
    DateTime? createdAt,
    DateTime? archivedAt,
  }) = _SavingsProjectImpl;

  factory SavingsProject.fromJson(Map<String, dynamic> jsonSerialization) {
    return SavingsProject(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      name: jsonSerialization['name'] as String,
      targetCents: jsonSerialization['targetCents'] as int,
      savedCents: jsonSerialization['savedCents'] as int?,
      targetDate: jsonSerialization['targetDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['targetDate']),
      accountId: jsonSerialization['accountId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      archivedAt: jsonSerialization['archivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['archivedAt']),
    );
  }

  static final t = SavingsProjectTable();

  static const db = SavingsProjectRepository._();

  @override
  int? id;

  int groupId;

  String name;

  int targetCents;

  int savedCents;

  DateTime? targetDate;

  /// Account the money is kept on, for information.
  int? accountId;

  DateTime createdAt;

  DateTime? archivedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SavingsProject]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SavingsProject copyWith({
    int? id,
    int? groupId,
    String? name,
    int? targetCents,
    int? savedCents,
    DateTime? targetDate,
    int? accountId,
    DateTime? createdAt,
    DateTime? archivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SavingsProject',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'targetCents': targetCents,
      'savedCents': savedCents,
      if (targetDate != null) 'targetDate': targetDate?.toJson(),
      if (accountId != null) 'accountId': accountId,
      'createdAt': createdAt.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SavingsProject',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'targetCents': targetCents,
      'savedCents': savedCents,
      if (targetDate != null) 'targetDate': targetDate?.toJson(),
      if (accountId != null) 'accountId': accountId,
      'createdAt': createdAt.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
    };
  }

  static SavingsProjectInclude include() {
    return SavingsProjectInclude._();
  }

  static SavingsProjectIncludeList includeList({
    _is.WhereExpressionBuilder<SavingsProjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SavingsProjectTable>? orderBy,
    _is.OrderByListBuilder<SavingsProjectTable>? orderByList,
    SavingsProjectInclude? include,
  }) {
    return SavingsProjectIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SavingsProject.t),
      orderByList: orderByList?.call(SavingsProject.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SavingsProjectImpl extends SavingsProject {
  _SavingsProjectImpl({
    int? id,
    required int groupId,
    required String name,
    required int targetCents,
    int? savedCents,
    DateTime? targetDate,
    int? accountId,
    DateTime? createdAt,
    DateTime? archivedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         name: name,
         targetCents: targetCents,
         savedCents: savedCents,
         targetDate: targetDate,
         accountId: accountId,
         createdAt: createdAt,
         archivedAt: archivedAt,
       );

  /// Returns a shallow copy of this [SavingsProject]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SavingsProject copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? name,
    int? targetCents,
    int? savedCents,
    Object? targetDate = _Undefined,
    Object? accountId = _Undefined,
    DateTime? createdAt,
    Object? archivedAt = _Undefined,
  }) {
    return SavingsProject(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      targetCents: targetCents ?? this.targetCents,
      savedCents: savedCents ?? this.savedCents,
      targetDate: targetDate is DateTime? ? targetDate : this.targetDate,
      accountId: accountId is int? ? accountId : this.accountId,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt is DateTime? ? archivedAt : this.archivedAt,
    );
  }
}

class SavingsProjectUpdateTable extends _is.UpdateTable<SavingsProjectTable> {
  SavingsProjectUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> targetCents(int value) => _is.ColumnValue(
    table.targetCents,
    value,
  );

  _is.ColumnValue<int, int> savedCents(int value) => _is.ColumnValue(
    table.savedCents,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> targetDate(DateTime? value) =>
      _is.ColumnValue(
        table.targetDate,
        value,
      );

  _is.ColumnValue<int, int> accountId(int? value) => _is.ColumnValue(
    table.accountId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> archivedAt(DateTime? value) =>
      _is.ColumnValue(
        table.archivedAt,
        value,
      );
}

class SavingsProjectTable extends _is.Table<int?> {
  SavingsProjectTable({super.tableRelation})
    : super(tableName: 'savings_projects') {
    updateTable = SavingsProjectUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    targetCents = _is.ColumnInt(
      'targetCents',
      this,
    );
    savedCents = _is.ColumnInt(
      'savedCents',
      this,
      hasDefault: true,
    );
    targetDate = _is.ColumnDateTime(
      'targetDate',
      this,
    );
    accountId = _is.ColumnInt(
      'accountId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    archivedAt = _is.ColumnDateTime(
      'archivedAt',
      this,
    );
  }

  late final SavingsProjectUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnString name;

  late final _is.ColumnInt targetCents;

  late final _is.ColumnInt savedCents;

  late final _is.ColumnDateTime targetDate;

  /// Account the money is kept on, for information.
  late final _is.ColumnInt accountId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime archivedAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    name,
    targetCents,
    savedCents,
    targetDate,
    accountId,
    createdAt,
    archivedAt,
  ];
}

class SavingsProjectInclude extends _is.IncludeObject {
  SavingsProjectInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SavingsProject.t;
}

class SavingsProjectIncludeList extends _is.IncludeList {
  SavingsProjectIncludeList._({
    _is.WhereExpressionBuilder<SavingsProjectTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SavingsProject.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SavingsProject.t;
}

class SavingsProjectRepository {
  const SavingsProjectRepository._();

  /// Returns a list of [SavingsProject]s matching the given query parameters.
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
  Future<List<SavingsProject>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SavingsProjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SavingsProjectTable>? orderBy,
    _is.OrderByListBuilder<SavingsProjectTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SavingsProject>(
      where: where?.call(SavingsProject.t),
      orderBy: orderBy?.call(SavingsProject.t),
      orderByList: orderByList?.call(SavingsProject.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SavingsProject] matching the given query parameters.
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
  Future<SavingsProject?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SavingsProjectTable>? where,
    int? offset,
    _is.OrderByBuilder<SavingsProjectTable>? orderBy,
    _is.OrderByListBuilder<SavingsProjectTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SavingsProject>(
      where: where?.call(SavingsProject.t),
      orderBy: orderBy?.call(SavingsProject.t),
      orderByList: orderByList?.call(SavingsProject.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SavingsProject] by its [id] or null if no such row exists.
  Future<SavingsProject?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SavingsProject>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SavingsProject]s in the list and returns the inserted rows.
  ///
  /// The returned [SavingsProject]s will have their `id` fields set.
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
  Future<List<SavingsProject>> insert(
    _is.DatabaseSession session,
    List<SavingsProject> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SavingsProject>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SavingsProject] and returns the inserted row.
  ///
  /// The returned [SavingsProject] will have its `id` field set.
  Future<SavingsProject> insertRow(
    _is.DatabaseSession session,
    SavingsProject row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SavingsProject>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SavingsProject]s in the list and returns the resulting rows.
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
  /// The returned [SavingsProject]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SavingsProject>> upsert(
    _is.DatabaseSession session,
    List<SavingsProject> rows, {
    required _is.ColumnSelections<SavingsProjectTable> conflictColumns,
    _is.ColumnSelections<SavingsProjectTable>? updateColumns,
    _is.WhereExpressionBuilder<SavingsProjectTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SavingsProject>(
      rows,
      conflictColumns: conflictColumns(SavingsProject.t),
      updateColumns: updateColumns?.call(SavingsProject.t),
      updateWhere: updateWhere?.call(SavingsProject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SavingsProject] and returns the resulting row.
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
  /// The returned [SavingsProject] will have its `id` field set.
  Future<SavingsProject?> upsertRow(
    _is.DatabaseSession session,
    SavingsProject row, {
    required _is.ColumnSelections<SavingsProjectTable> conflictColumns,
    _is.ColumnSelections<SavingsProjectTable>? updateColumns,
    _is.WhereExpressionBuilder<SavingsProjectTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SavingsProject>(
      row,
      conflictColumns: conflictColumns(SavingsProject.t),
      updateColumns: updateColumns?.call(SavingsProject.t),
      updateWhere: updateWhere?.call(SavingsProject.t),
      transaction: transaction,
    );
  }

  /// Updates all [SavingsProject]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SavingsProject>> update(
    _is.DatabaseSession session,
    List<SavingsProject> rows, {
    _is.ColumnSelections<SavingsProjectTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SavingsProject>(
      rows,
      columns: columns?.call(SavingsProject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SavingsProject]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SavingsProject> updateRow(
    _is.DatabaseSession session,
    SavingsProject row, {
    _is.ColumnSelections<SavingsProjectTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SavingsProject>(
      row,
      columns: columns?.call(SavingsProject.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SavingsProject] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SavingsProject?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SavingsProjectUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SavingsProject>(
      id,
      columnValues: columnValues(SavingsProject.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SavingsProject]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SavingsProject>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SavingsProjectUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SavingsProjectTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SavingsProjectTable>? orderBy,
    _is.OrderByListBuilder<SavingsProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SavingsProject>(
      columnValues: columnValues(SavingsProject.t.updateTable),
      where: where(SavingsProject.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SavingsProject.t),
      orderByList: orderByList?.call(SavingsProject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SavingsProject]s in the list and returns the deleted rows.
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
  Future<List<SavingsProject>> delete(
    _is.DatabaseSession session,
    List<SavingsProject> rows, {
    _is.OrderByBuilder<SavingsProjectTable>? orderBy,
    _is.OrderByListBuilder<SavingsProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SavingsProject>(
      rows,
      orderBy: orderBy?.call(SavingsProject.t),
      orderByList: orderByList?.call(SavingsProject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SavingsProject].
  Future<SavingsProject> deleteRow(
    _is.DatabaseSession session,
    SavingsProject row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SavingsProject>(
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
  Future<List<SavingsProject>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SavingsProjectTable> where,
    _is.OrderByBuilder<SavingsProjectTable>? orderBy,
    _is.OrderByListBuilder<SavingsProjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SavingsProject>(
      where: where(SavingsProject.t),
      orderBy: orderBy?.call(SavingsProject.t),
      orderByList: orderByList?.call(SavingsProject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SavingsProjectTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SavingsProject>(
      where: where?.call(SavingsProject.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SavingsProject] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SavingsProjectTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SavingsProject>(
      where: where(SavingsProject.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
