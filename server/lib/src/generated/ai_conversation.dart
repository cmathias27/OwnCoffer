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

/// A past conversation with the assistant, kept on this server for its
/// user only (the latest 30), to read again or go on with. Text only.
abstract class AiConversation
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AiConversation._({
    this.id,
    required this.authUserId,
    required this.groupId,
    required this.title,
    required this.messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory AiConversation({
    int? id,
    required _is.UuidValue authUserId,
    required int groupId,
    required String title,
    required String messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AiConversationImpl;

  factory AiConversation.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiConversation(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      groupId: jsonSerialization['groupId'] as int,
      title: jsonSerialization['title'] as String,
      messages: jsonSerialization['messages'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AiConversationTable();

  static const db = AiConversationRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  int groupId;

  String title;

  /// The messages as JSON: [{"role": "user" | "assistant", "content": …}].
  String messages;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AiConversation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiConversation copyWith({
    int? id,
    _is.UuidValue? authUserId,
    int? groupId,
    String? title,
    String? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiConversation',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'groupId': groupId,
      'title': title,
      'messages': messages,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiConversation',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'groupId': groupId,
      'title': title,
      'messages': messages,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AiConversationInclude include() {
    return AiConversationInclude._();
  }

  static AiConversationIncludeList includeList({
    _is.WhereExpressionBuilder<AiConversationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiConversationTable>? orderBy,
    _is.OrderByListBuilder<AiConversationTable>? orderByList,
    AiConversationInclude? include,
  }) {
    return AiConversationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiConversation.t),
      orderByList: orderByList?.call(AiConversation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiConversationImpl extends AiConversation {
  _AiConversationImpl({
    int? id,
    required _is.UuidValue authUserId,
    required int groupId,
    required String title,
    required String messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         groupId: groupId,
         title: title,
         messages: messages,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AiConversation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiConversation copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    int? groupId,
    String? title,
    String? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AiConversation(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AiConversationUpdateTable extends _is.UpdateTable<AiConversationTable> {
  AiConversationUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> messages(String value) => _is.ColumnValue(
    table.messages,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class AiConversationTable extends _is.Table<int?> {
  AiConversationTable({super.tableRelation})
    : super(tableName: 'ai_conversations') {
    updateTable = AiConversationUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    messages = _is.ColumnString(
      'messages',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final AiConversationUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnInt groupId;

  late final _is.ColumnString title;

  /// The messages as JSON: [{"role": "user" | "assistant", "content": …}].
  late final _is.ColumnString messages;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    groupId,
    title,
    messages,
    createdAt,
    updatedAt,
  ];
}

class AiConversationInclude extends _is.IncludeObject {
  AiConversationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AiConversation.t;
}

class AiConversationIncludeList extends _is.IncludeList {
  AiConversationIncludeList._({
    _is.WhereExpressionBuilder<AiConversationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiConversation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AiConversation.t;
}

class AiConversationRepository {
  const AiConversationRepository._();

  /// Returns a list of [AiConversation]s matching the given query parameters.
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
  Future<List<AiConversation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiConversationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiConversationTable>? orderBy,
    _is.OrderByListBuilder<AiConversationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiConversation>(
      where: where?.call(AiConversation.t),
      orderBy: orderBy?.call(AiConversation.t),
      orderByList: orderByList?.call(AiConversation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiConversation] matching the given query parameters.
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
  Future<AiConversation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiConversationTable>? where,
    int? offset,
    _is.OrderByBuilder<AiConversationTable>? orderBy,
    _is.OrderByListBuilder<AiConversationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiConversation>(
      where: where?.call(AiConversation.t),
      orderBy: orderBy?.call(AiConversation.t),
      orderByList: orderByList?.call(AiConversation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiConversation] by its [id] or null if no such row exists.
  Future<AiConversation?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiConversation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiConversation]s in the list and returns the inserted rows.
  ///
  /// The returned [AiConversation]s will have their `id` fields set.
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
  Future<List<AiConversation>> insert(
    _is.DatabaseSession session,
    List<AiConversation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiConversation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiConversation] and returns the inserted row.
  ///
  /// The returned [AiConversation] will have its `id` field set.
  Future<AiConversation> insertRow(
    _is.DatabaseSession session,
    AiConversation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiConversation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiConversation]s in the list and returns the resulting rows.
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
  /// The returned [AiConversation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiConversation>> upsert(
    _is.DatabaseSession session,
    List<AiConversation> rows, {
    required _is.ColumnSelections<AiConversationTable> conflictColumns,
    _is.ColumnSelections<AiConversationTable>? updateColumns,
    _is.WhereExpressionBuilder<AiConversationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiConversation>(
      rows,
      conflictColumns: conflictColumns(AiConversation.t),
      updateColumns: updateColumns?.call(AiConversation.t),
      updateWhere: updateWhere?.call(AiConversation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiConversation] and returns the resulting row.
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
  /// The returned [AiConversation] will have its `id` field set.
  Future<AiConversation?> upsertRow(
    _is.DatabaseSession session,
    AiConversation row, {
    required _is.ColumnSelections<AiConversationTable> conflictColumns,
    _is.ColumnSelections<AiConversationTable>? updateColumns,
    _is.WhereExpressionBuilder<AiConversationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiConversation>(
      row,
      conflictColumns: conflictColumns(AiConversation.t),
      updateColumns: updateColumns?.call(AiConversation.t),
      updateWhere: updateWhere?.call(AiConversation.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiConversation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiConversation>> update(
    _is.DatabaseSession session,
    List<AiConversation> rows, {
    _is.ColumnSelections<AiConversationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiConversation>(
      rows,
      columns: columns?.call(AiConversation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiConversation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiConversation> updateRow(
    _is.DatabaseSession session,
    AiConversation row, {
    _is.ColumnSelections<AiConversationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiConversation>(
      row,
      columns: columns?.call(AiConversation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiConversation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiConversation?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AiConversationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiConversation>(
      id,
      columnValues: columnValues(AiConversation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiConversation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiConversation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiConversationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AiConversationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiConversationTable>? orderBy,
    _is.OrderByListBuilder<AiConversationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiConversation>(
      columnValues: columnValues(AiConversation.t.updateTable),
      where: where(AiConversation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiConversation.t),
      orderByList: orderByList?.call(AiConversation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiConversation]s in the list and returns the deleted rows.
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
  Future<List<AiConversation>> delete(
    _is.DatabaseSession session,
    List<AiConversation> rows, {
    _is.OrderByBuilder<AiConversationTable>? orderBy,
    _is.OrderByListBuilder<AiConversationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiConversation>(
      rows,
      orderBy: orderBy?.call(AiConversation.t),
      orderByList: orderByList?.call(AiConversation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiConversation].
  Future<AiConversation> deleteRow(
    _is.DatabaseSession session,
    AiConversation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiConversation>(
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
  Future<List<AiConversation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiConversationTable> where,
    _is.OrderByBuilder<AiConversationTable>? orderBy,
    _is.OrderByListBuilder<AiConversationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiConversation>(
      where: where(AiConversation.t),
      orderBy: orderBy?.call(AiConversation.t),
      orderByList: orderByList?.call(AiConversation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiConversationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiConversation>(
      where: where?.call(AiConversation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiConversation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiConversationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiConversation>(
      where: where(AiConversation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
