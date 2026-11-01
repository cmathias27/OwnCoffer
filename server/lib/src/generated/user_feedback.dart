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

/// A remark sent from the app to the server administrator (bug, idea,
/// question). Never sent outside the server; no bank data is joined.
abstract class UserFeedback
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserFeedback._({
    this.id,
    this.authUserId,
    required this.kind,
    required this.text,
    this.page,
    this.appVersion,
    required this.status,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserFeedback({
    int? id,
    _is.UuidValue? authUserId,
    required String kind,
    required String text,
    String? page,
    String? appVersion,
    required String status,
    DateTime? createdAt,
  }) = _UserFeedbackImpl;

  factory UserFeedback.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserFeedback(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['authUserId'],
            ),
      kind: jsonSerialization['kind'] as String,
      text: jsonSerialization['text'] as String,
      page: jsonSerialization['page'] as String?,
      appVersion: jsonSerialization['appVersion'] as String?,
      status: jsonSerialization['status'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = UserFeedbackTable();

  static const db = UserFeedbackRepository._();

  @override
  int? id;

  _is.UuidValue? authUserId;

  /// bug, idea or question.
  String kind;

  String text;

  /// The page it was sent from, and the app's version.
  String? page;

  String? appVersion;

  /// open or done.
  String status;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserFeedback]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserFeedback copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? kind,
    String? text,
    String? page,
    String? appVersion,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserFeedback',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      'kind': kind,
      'text': text,
      if (page != null) 'page': page,
      if (appVersion != null) 'appVersion': appVersion,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserFeedback',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      'kind': kind,
      'text': text,
      if (page != null) 'page': page,
      if (appVersion != null) 'appVersion': appVersion,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  static UserFeedbackInclude include() {
    return UserFeedbackInclude._();
  }

  static UserFeedbackIncludeList includeList({
    _is.WhereExpressionBuilder<UserFeedbackTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserFeedbackTable>? orderBy,
    _is.OrderByListBuilder<UserFeedbackTable>? orderByList,
    UserFeedbackInclude? include,
  }) {
    return UserFeedbackIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserFeedback.t),
      orderByList: orderByList?.call(UserFeedback.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserFeedbackImpl extends UserFeedback {
  _UserFeedbackImpl({
    int? id,
    _is.UuidValue? authUserId,
    required String kind,
    required String text,
    String? page,
    String? appVersion,
    required String status,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         kind: kind,
         text: text,
         page: page,
         appVersion: appVersion,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserFeedback]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserFeedback copyWith({
    Object? id = _Undefined,
    Object? authUserId = _Undefined,
    String? kind,
    String? text,
    Object? page = _Undefined,
    Object? appVersion = _Undefined,
    String? status,
    DateTime? createdAt,
  }) {
    return UserFeedback(
      id: id is int? ? id : this.id,
      authUserId: authUserId is _is.UuidValue? ? authUserId : this.authUserId,
      kind: kind ?? this.kind,
      text: text ?? this.text,
      page: page is String? ? page : this.page,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserFeedbackUpdateTable extends _is.UpdateTable<UserFeedbackTable> {
  UserFeedbackUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );

  _is.ColumnValue<String, String> page(String? value) => _is.ColumnValue(
    table.page,
    value,
  );

  _is.ColumnValue<String, String> appVersion(String? value) => _is.ColumnValue(
    table.appVersion,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class UserFeedbackTable extends _is.Table<int?> {
  UserFeedbackTable({super.tableRelation})
    : super(tableName: 'user_feedbacks') {
    updateTable = UserFeedbackUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
    );
    page = _is.ColumnString(
      'page',
      this,
    );
    appVersion = _is.ColumnString(
      'appVersion',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final UserFeedbackUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// bug, idea or question.
  late final _is.ColumnString kind;

  late final _is.ColumnString text;

  /// The page it was sent from, and the app's version.
  late final _is.ColumnString page;

  late final _is.ColumnString appVersion;

  /// open or done.
  late final _is.ColumnString status;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    kind,
    text,
    page,
    appVersion,
    status,
    createdAt,
  ];
}

class UserFeedbackInclude extends _is.IncludeObject {
  UserFeedbackInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UserFeedback.t;
}

class UserFeedbackIncludeList extends _is.IncludeList {
  UserFeedbackIncludeList._({
    _is.WhereExpressionBuilder<UserFeedbackTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserFeedback.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserFeedback.t;
}

class UserFeedbackRepository {
  const UserFeedbackRepository._();

  /// Returns a list of [UserFeedback]s matching the given query parameters.
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
  Future<List<UserFeedback>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserFeedbackTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserFeedbackTable>? orderBy,
    _is.OrderByListBuilder<UserFeedbackTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserFeedback>(
      where: where?.call(UserFeedback.t),
      orderBy: orderBy?.call(UserFeedback.t),
      orderByList: orderByList?.call(UserFeedback.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserFeedback] matching the given query parameters.
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
  Future<UserFeedback?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserFeedbackTable>? where,
    int? offset,
    _is.OrderByBuilder<UserFeedbackTable>? orderBy,
    _is.OrderByListBuilder<UserFeedbackTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserFeedback>(
      where: where?.call(UserFeedback.t),
      orderBy: orderBy?.call(UserFeedback.t),
      orderByList: orderByList?.call(UserFeedback.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserFeedback] by its [id] or null if no such row exists.
  Future<UserFeedback?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserFeedback>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserFeedback]s in the list and returns the inserted rows.
  ///
  /// The returned [UserFeedback]s will have their `id` fields set.
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
  Future<List<UserFeedback>> insert(
    _is.DatabaseSession session,
    List<UserFeedback> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserFeedback>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserFeedback] and returns the inserted row.
  ///
  /// The returned [UserFeedback] will have its `id` field set.
  Future<UserFeedback> insertRow(
    _is.DatabaseSession session,
    UserFeedback row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserFeedback>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserFeedback]s in the list and returns the resulting rows.
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
  /// The returned [UserFeedback]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserFeedback>> upsert(
    _is.DatabaseSession session,
    List<UserFeedback> rows, {
    required _is.ColumnSelections<UserFeedbackTable> conflictColumns,
    _is.ColumnSelections<UserFeedbackTable>? updateColumns,
    _is.WhereExpressionBuilder<UserFeedbackTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserFeedback>(
      rows,
      conflictColumns: conflictColumns(UserFeedback.t),
      updateColumns: updateColumns?.call(UserFeedback.t),
      updateWhere: updateWhere?.call(UserFeedback.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserFeedback] and returns the resulting row.
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
  /// The returned [UserFeedback] will have its `id` field set.
  Future<UserFeedback?> upsertRow(
    _is.DatabaseSession session,
    UserFeedback row, {
    required _is.ColumnSelections<UserFeedbackTable> conflictColumns,
    _is.ColumnSelections<UserFeedbackTable>? updateColumns,
    _is.WhereExpressionBuilder<UserFeedbackTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserFeedback>(
      row,
      conflictColumns: conflictColumns(UserFeedback.t),
      updateColumns: updateColumns?.call(UserFeedback.t),
      updateWhere: updateWhere?.call(UserFeedback.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserFeedback]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserFeedback>> update(
    _is.DatabaseSession session,
    List<UserFeedback> rows, {
    _is.ColumnSelections<UserFeedbackTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserFeedback>(
      rows,
      columns: columns?.call(UserFeedback.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserFeedback]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserFeedback> updateRow(
    _is.DatabaseSession session,
    UserFeedback row, {
    _is.ColumnSelections<UserFeedbackTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserFeedback>(
      row,
      columns: columns?.call(UserFeedback.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserFeedback] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserFeedback?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserFeedbackUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserFeedback>(
      id,
      columnValues: columnValues(UserFeedback.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserFeedback]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserFeedback>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserFeedbackUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserFeedbackTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserFeedbackTable>? orderBy,
    _is.OrderByListBuilder<UserFeedbackTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserFeedback>(
      columnValues: columnValues(UserFeedback.t.updateTable),
      where: where(UserFeedback.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserFeedback.t),
      orderByList: orderByList?.call(UserFeedback.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserFeedback]s in the list and returns the deleted rows.
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
  Future<List<UserFeedback>> delete(
    _is.DatabaseSession session,
    List<UserFeedback> rows, {
    _is.OrderByBuilder<UserFeedbackTable>? orderBy,
    _is.OrderByListBuilder<UserFeedbackTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserFeedback>(
      rows,
      orderBy: orderBy?.call(UserFeedback.t),
      orderByList: orderByList?.call(UserFeedback.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserFeedback].
  Future<UserFeedback> deleteRow(
    _is.DatabaseSession session,
    UserFeedback row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserFeedback>(
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
  Future<List<UserFeedback>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserFeedbackTable> where,
    _is.OrderByBuilder<UserFeedbackTable>? orderBy,
    _is.OrderByListBuilder<UserFeedbackTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserFeedback>(
      where: where(UserFeedback.t),
      orderBy: orderBy?.call(UserFeedback.t),
      orderByList: orderByList?.call(UserFeedback.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserFeedbackTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserFeedback>(
      where: where?.call(UserFeedback.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserFeedback] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserFeedbackTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserFeedback>(
      where: where(UserFeedback.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
