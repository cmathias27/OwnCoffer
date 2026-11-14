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

/// A free reminder of a member ("call the bank", "send the form"), notified
/// on its day (decision 0050).
abstract class Reminder
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Reminder._({
    this.id,
    required this.groupId,
    required this.authUserId,
    required this.text,
    required this.dueDate,
    this.doneAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Reminder({
    int? id,
    required int groupId,
    required _is.UuidValue authUserId,
    required String text,
    required DateTime dueDate,
    DateTime? doneAt,
    DateTime? createdAt,
  }) = _ReminderImpl;

  factory Reminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reminder(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      text: jsonSerialization['text'] as String,
      dueDate: _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      doneAt: jsonSerialization['doneAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['doneAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ReminderTable();

  static const db = ReminderRepository._();

  @override
  int? id;

  int groupId;

  _is.UuidValue authUserId;

  String text;

  DateTime dueDate;

  DateTime? doneAt;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Reminder copyWith({
    int? id,
    int? groupId,
    _is.UuidValue? authUserId,
    String? text,
    DateTime? dueDate,
    DateTime? doneAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reminder',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'text': text,
      'dueDate': dueDate.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reminder',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'text': text,
      'dueDate': dueDate.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ReminderInclude include() {
    return ReminderInclude._();
  }

  static ReminderIncludeList includeList({
    _is.WhereExpressionBuilder<ReminderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderTable>? orderBy,
    _is.OrderByListBuilder<ReminderTable>? orderByList,
    ReminderInclude? include,
  }) {
    return ReminderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reminder.t),
      orderByList: orderByList?.call(Reminder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderImpl extends Reminder {
  _ReminderImpl({
    int? id,
    required int groupId,
    required _is.UuidValue authUserId,
    required String text,
    required DateTime dueDate,
    DateTime? doneAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         authUserId: authUserId,
         text: text,
         dueDate: dueDate,
         doneAt: doneAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Reminder copyWith({
    Object? id = _Undefined,
    int? groupId,
    _is.UuidValue? authUserId,
    String? text,
    DateTime? dueDate,
    Object? doneAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      authUserId: authUserId ?? this.authUserId,
      text: text ?? this.text,
      dueDate: dueDate ?? this.dueDate,
      doneAt: doneAt is DateTime? ? doneAt : this.doneAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReminderUpdateTable extends _is.UpdateTable<ReminderTable> {
  ReminderUpdateTable(super.table);

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

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dueDate(DateTime value) =>
      _is.ColumnValue(
        table.dueDate,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> doneAt(DateTime? value) =>
      _is.ColumnValue(
        table.doneAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReminderTable extends _is.Table<int?> {
  ReminderTable({super.tableRelation}) : super(tableName: 'reminders') {
    updateTable = ReminderUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
    );
    dueDate = _is.ColumnDateTime(
      'dueDate',
      this,
    );
    doneAt = _is.ColumnDateTime(
      'doneAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ReminderUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString text;

  late final _is.ColumnDateTime dueDate;

  late final _is.ColumnDateTime doneAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    authUserId,
    text,
    dueDate,
    doneAt,
    createdAt,
  ];
}

class ReminderInclude extends _is.IncludeObject {
  ReminderInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Reminder.t;
}

class ReminderIncludeList extends _is.IncludeList {
  ReminderIncludeList._({
    _is.WhereExpressionBuilder<ReminderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Reminder.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Reminder.t;
}

class ReminderRepository {
  const ReminderRepository._();

  /// Returns a list of [Reminder]s matching the given query parameters.
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
  Future<List<Reminder>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderTable>? orderBy,
    _is.OrderByListBuilder<ReminderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Reminder>(
      where: where?.call(Reminder.t),
      orderBy: orderBy?.call(Reminder.t),
      orderByList: orderByList?.call(Reminder.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Reminder] matching the given query parameters.
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
  Future<Reminder?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderTable>? where,
    int? offset,
    _is.OrderByBuilder<ReminderTable>? orderBy,
    _is.OrderByListBuilder<ReminderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Reminder>(
      where: where?.call(Reminder.t),
      orderBy: orderBy?.call(Reminder.t),
      orderByList: orderByList?.call(Reminder.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Reminder] by its [id] or null if no such row exists.
  Future<Reminder?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Reminder>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Reminder]s in the list and returns the inserted rows.
  ///
  /// The returned [Reminder]s will have their `id` fields set.
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
  Future<List<Reminder>> insert(
    _is.DatabaseSession session,
    List<Reminder> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Reminder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Reminder] and returns the inserted row.
  ///
  /// The returned [Reminder] will have its `id` field set.
  Future<Reminder> insertRow(
    _is.DatabaseSession session,
    Reminder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Reminder>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Reminder]s in the list and returns the resulting rows.
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
  /// The returned [Reminder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reminder>> upsert(
    _is.DatabaseSession session,
    List<Reminder> rows, {
    required _is.ColumnSelections<ReminderTable> conflictColumns,
    _is.ColumnSelections<ReminderTable>? updateColumns,
    _is.WhereExpressionBuilder<ReminderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Reminder>(
      rows,
      conflictColumns: conflictColumns(Reminder.t),
      updateColumns: updateColumns?.call(Reminder.t),
      updateWhere: updateWhere?.call(Reminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Reminder] and returns the resulting row.
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
  /// The returned [Reminder] will have its `id` field set.
  Future<Reminder?> upsertRow(
    _is.DatabaseSession session,
    Reminder row, {
    required _is.ColumnSelections<ReminderTable> conflictColumns,
    _is.ColumnSelections<ReminderTable>? updateColumns,
    _is.WhereExpressionBuilder<ReminderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Reminder>(
      row,
      conflictColumns: conflictColumns(Reminder.t),
      updateColumns: updateColumns?.call(Reminder.t),
      updateWhere: updateWhere?.call(Reminder.t),
      transaction: transaction,
    );
  }

  /// Updates all [Reminder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reminder>> update(
    _is.DatabaseSession session,
    List<Reminder> rows, {
    _is.ColumnSelections<ReminderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Reminder>(
      rows,
      columns: columns?.call(Reminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Reminder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Reminder> updateRow(
    _is.DatabaseSession session,
    Reminder row, {
    _is.ColumnSelections<ReminderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Reminder>(
      row,
      columns: columns?.call(Reminder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reminder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Reminder?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ReminderUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Reminder>(
      id,
      columnValues: columnValues(Reminder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Reminder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reminder>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReminderUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReminderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReminderTable>? orderBy,
    _is.OrderByListBuilder<ReminderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Reminder>(
      columnValues: columnValues(Reminder.t.updateTable),
      where: where(Reminder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reminder.t),
      orderByList: orderByList?.call(Reminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Reminder]s in the list and returns the deleted rows.
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
  Future<List<Reminder>> delete(
    _is.DatabaseSession session,
    List<Reminder> rows, {
    _is.OrderByBuilder<ReminderTable>? orderBy,
    _is.OrderByListBuilder<ReminderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Reminder>(
      rows,
      orderBy: orderBy?.call(Reminder.t),
      orderByList: orderByList?.call(Reminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Reminder].
  Future<Reminder> deleteRow(
    _is.DatabaseSession session,
    Reminder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Reminder>(
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
  Future<List<Reminder>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReminderTable> where,
    _is.OrderByBuilder<ReminderTable>? orderBy,
    _is.OrderByListBuilder<ReminderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Reminder>(
      where: where(Reminder.t),
      orderBy: orderBy?.call(Reminder.t),
      orderByList: orderByList?.call(Reminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReminderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Reminder>(
      where: where?.call(Reminder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Reminder] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReminderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Reminder>(
      where: where(Reminder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
