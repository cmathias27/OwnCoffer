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
import 'package:owncoffer_server/src/generated/protocol.dart' as _itdod8fx;
import 'package:serverpod/serverpod.dart' as _is;

/// An expense paid by one member for several (split equally), or a
/// repayment between two members (decision 0050). Independent of the bank
/// operations: it records who owes whom.
abstract class SharedExpense
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SharedExpense._({
    this.id,
    required this.groupId,
    required this.label,
    required this.date,
    required this.amountCents,
    required this.paidBy,
    required this.participants,
    bool? repayment,
    required this.createdBy,
    DateTime? createdAt,
  }) : repayment = repayment ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory SharedExpense({
    int? id,
    required int groupId,
    required String label,
    required DateTime date,
    required int amountCents,
    required _is.UuidValue paidBy,
    required List<_is.UuidValue> participants,
    bool? repayment,
    required _is.UuidValue createdBy,
    DateTime? createdAt,
  }) = _SharedExpenseImpl;

  factory SharedExpense.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedExpense(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      label: jsonSerialization['label'] as String,
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amountCents: jsonSerialization['amountCents'] as int,
      paidBy: _is.UuidValueJsonExtension.fromJson(jsonSerialization['paidBy']),
      participants: _itdod8fx.Protocol().deserialize<List<_is.UuidValue>>(
        jsonSerialization['participants'],
      ),
      repayment: jsonSerialization['repayment'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['repayment']),
      createdBy: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SharedExpenseTable();

  static const db = SharedExpenseRepository._();

  @override
  int? id;

  int groupId;

  String label;

  DateTime date;

  int amountCents;

  _is.UuidValue paidBy;

  /// Members sharing it (user ids); a repayment has the one paid back.
  List<_is.UuidValue> participants;

  bool repayment;

  _is.UuidValue createdBy;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SharedExpense]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SharedExpense copyWith({
    int? id,
    int? groupId,
    String? label,
    DateTime? date,
    int? amountCents,
    _is.UuidValue? paidBy,
    List<_is.UuidValue>? participants,
    bool? repayment,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedExpense',
      if (id != null) 'id': id,
      'groupId': groupId,
      'label': label,
      'date': date.toJson(),
      'amountCents': amountCents,
      'paidBy': paidBy.toJson(),
      'participants': participants.toJson(valueToJson: (v) => v.toJson()),
      'repayment': repayment,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedExpense',
      if (id != null) 'id': id,
      'groupId': groupId,
      'label': label,
      'date': date.toJson(),
      'amountCents': amountCents,
      'paidBy': paidBy.toJson(),
      'participants': participants.toJson(valueToJson: (v) => v.toJson()),
      'repayment': repayment,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static SharedExpenseInclude include() {
    return SharedExpenseInclude._();
  }

  static SharedExpenseIncludeList includeList({
    _is.WhereExpressionBuilder<SharedExpenseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedExpenseTable>? orderBy,
    _is.OrderByListBuilder<SharedExpenseTable>? orderByList,
    SharedExpenseInclude? include,
  }) {
    return SharedExpenseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedExpense.t),
      orderByList: orderByList?.call(SharedExpense.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedExpenseImpl extends SharedExpense {
  _SharedExpenseImpl({
    int? id,
    required int groupId,
    required String label,
    required DateTime date,
    required int amountCents,
    required _is.UuidValue paidBy,
    required List<_is.UuidValue> participants,
    bool? repayment,
    required _is.UuidValue createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         label: label,
         date: date,
         amountCents: amountCents,
         paidBy: paidBy,
         participants: participants,
         repayment: repayment,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SharedExpense]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SharedExpense copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? label,
    DateTime? date,
    int? amountCents,
    _is.UuidValue? paidBy,
    List<_is.UuidValue>? participants,
    bool? repayment,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  }) {
    return SharedExpense(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      label: label ?? this.label,
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
      paidBy: paidBy ?? this.paidBy,
      participants: participants ?? this.participants.map((e0) => e0).toList(),
      repayment: repayment ?? this.repayment,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SharedExpenseUpdateTable extends _is.UpdateTable<SharedExpenseTable> {
  SharedExpenseUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<String, String> label(String value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> date(DateTime value) => _is.ColumnValue(
    table.date,
    value,
  );

  _is.ColumnValue<int, int> amountCents(int value) => _is.ColumnValue(
    table.amountCents,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> paidBy(_is.UuidValue value) =>
      _is.ColumnValue(
        table.paidBy,
        value,
      );

  _is.ColumnValue<List<_is.UuidValue>, List<_is.UuidValue>> participants(
    List<_is.UuidValue> value,
  ) => _is.ColumnValue(
    table.participants,
    value,
  );

  _is.ColumnValue<bool, bool> repayment(bool value) => _is.ColumnValue(
    table.repayment,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createdBy(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.createdBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SharedExpenseTable extends _is.Table<int?> {
  SharedExpenseTable({super.tableRelation})
    : super(tableName: 'shared_expenses') {
    updateTable = SharedExpenseUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    date = _is.ColumnDateTime(
      'date',
      this,
    );
    amountCents = _is.ColumnInt(
      'amountCents',
      this,
    );
    paidBy = _is.ColumnUuid(
      'paidBy',
      this,
    );
    participants = _is.ColumnSerializable<List<_is.UuidValue>>(
      'participants',
      this,
    );
    repayment = _is.ColumnBool(
      'repayment',
      this,
      hasDefault: true,
    );
    createdBy = _is.ColumnUuid(
      'createdBy',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final SharedExpenseUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnString label;

  late final _is.ColumnDateTime date;

  late final _is.ColumnInt amountCents;

  late final _is.ColumnUuid paidBy;

  /// Members sharing it (user ids); a repayment has the one paid back.
  late final _is.ColumnSerializable<List<_is.UuidValue>> participants;

  late final _is.ColumnBool repayment;

  late final _is.ColumnUuid createdBy;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    label,
    date,
    amountCents,
    paidBy,
    participants,
    repayment,
    createdBy,
    createdAt,
  ];
}

class SharedExpenseInclude extends _is.IncludeObject {
  SharedExpenseInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SharedExpense.t;
}

class SharedExpenseIncludeList extends _is.IncludeList {
  SharedExpenseIncludeList._({
    _is.WhereExpressionBuilder<SharedExpenseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SharedExpense.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SharedExpense.t;
}

class SharedExpenseRepository {
  const SharedExpenseRepository._();

  /// Returns a list of [SharedExpense]s matching the given query parameters.
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
  Future<List<SharedExpense>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedExpenseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedExpenseTable>? orderBy,
    _is.OrderByListBuilder<SharedExpenseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SharedExpense>(
      where: where?.call(SharedExpense.t),
      orderBy: orderBy?.call(SharedExpense.t),
      orderByList: orderByList?.call(SharedExpense.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SharedExpense] matching the given query parameters.
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
  Future<SharedExpense?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedExpenseTable>? where,
    int? offset,
    _is.OrderByBuilder<SharedExpenseTable>? orderBy,
    _is.OrderByListBuilder<SharedExpenseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SharedExpense>(
      where: where?.call(SharedExpense.t),
      orderBy: orderBy?.call(SharedExpense.t),
      orderByList: orderByList?.call(SharedExpense.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SharedExpense] by its [id] or null if no such row exists.
  Future<SharedExpense?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SharedExpense>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SharedExpense]s in the list and returns the inserted rows.
  ///
  /// The returned [SharedExpense]s will have their `id` fields set.
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
  Future<List<SharedExpense>> insert(
    _is.DatabaseSession session,
    List<SharedExpense> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SharedExpense>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SharedExpense] and returns the inserted row.
  ///
  /// The returned [SharedExpense] will have its `id` field set.
  Future<SharedExpense> insertRow(
    _is.DatabaseSession session,
    SharedExpense row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SharedExpense>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SharedExpense]s in the list and returns the resulting rows.
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
  /// The returned [SharedExpense]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedExpense>> upsert(
    _is.DatabaseSession session,
    List<SharedExpense> rows, {
    required _is.ColumnSelections<SharedExpenseTable> conflictColumns,
    _is.ColumnSelections<SharedExpenseTable>? updateColumns,
    _is.WhereExpressionBuilder<SharedExpenseTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SharedExpense>(
      rows,
      conflictColumns: conflictColumns(SharedExpense.t),
      updateColumns: updateColumns?.call(SharedExpense.t),
      updateWhere: updateWhere?.call(SharedExpense.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SharedExpense] and returns the resulting row.
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
  /// The returned [SharedExpense] will have its `id` field set.
  Future<SharedExpense?> upsertRow(
    _is.DatabaseSession session,
    SharedExpense row, {
    required _is.ColumnSelections<SharedExpenseTable> conflictColumns,
    _is.ColumnSelections<SharedExpenseTable>? updateColumns,
    _is.WhereExpressionBuilder<SharedExpenseTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SharedExpense>(
      row,
      conflictColumns: conflictColumns(SharedExpense.t),
      updateColumns: updateColumns?.call(SharedExpense.t),
      updateWhere: updateWhere?.call(SharedExpense.t),
      transaction: transaction,
    );
  }

  /// Updates all [SharedExpense]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedExpense>> update(
    _is.DatabaseSession session,
    List<SharedExpense> rows, {
    _is.ColumnSelections<SharedExpenseTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SharedExpense>(
      rows,
      columns: columns?.call(SharedExpense.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SharedExpense]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SharedExpense> updateRow(
    _is.DatabaseSession session,
    SharedExpense row, {
    _is.ColumnSelections<SharedExpenseTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SharedExpense>(
      row,
      columns: columns?.call(SharedExpense.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedExpense] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SharedExpense?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SharedExpenseUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SharedExpense>(
      id,
      columnValues: columnValues(SharedExpense.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SharedExpense]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedExpense>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SharedExpenseUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SharedExpenseTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedExpenseTable>? orderBy,
    _is.OrderByListBuilder<SharedExpenseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SharedExpense>(
      columnValues: columnValues(SharedExpense.t.updateTable),
      where: where(SharedExpense.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedExpense.t),
      orderByList: orderByList?.call(SharedExpense.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SharedExpense]s in the list and returns the deleted rows.
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
  Future<List<SharedExpense>> delete(
    _is.DatabaseSession session,
    List<SharedExpense> rows, {
    _is.OrderByBuilder<SharedExpenseTable>? orderBy,
    _is.OrderByListBuilder<SharedExpenseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SharedExpense>(
      rows,
      orderBy: orderBy?.call(SharedExpense.t),
      orderByList: orderByList?.call(SharedExpense.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SharedExpense].
  Future<SharedExpense> deleteRow(
    _is.DatabaseSession session,
    SharedExpense row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SharedExpense>(
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
  Future<List<SharedExpense>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SharedExpenseTable> where,
    _is.OrderByBuilder<SharedExpenseTable>? orderBy,
    _is.OrderByListBuilder<SharedExpenseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SharedExpense>(
      where: where(SharedExpense.t),
      orderBy: orderBy?.call(SharedExpense.t),
      orderByList: orderByList?.call(SharedExpense.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedExpenseTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SharedExpense>(
      where: where?.call(SharedExpense.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SharedExpense] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SharedExpenseTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SharedExpense>(
      where: where(SharedExpense.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
