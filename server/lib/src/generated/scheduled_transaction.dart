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
import 'frequency.dart' as _ixycnzxw;

/// A planned operation (rent, salary, subscription…).
abstract class ScheduledTransaction
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ScheduledTransaction._({
    this.id,
    required this.accountId,
    required this.amountCents,
    required this.label,
    this.categoryId,
    required this.frequency,
    int? interval,
    required this.startDate,
    this.endDate,
    this.occurrenceCount,
    this.nextDue,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    this.deletedAt,
  }) : interval = interval ?? 1,
       matchPattern = matchPattern ?? '',
       dateToleranceDays = dateToleranceDays ?? 5,
       amountTolerancePercent = amountTolerancePercent ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory ScheduledTransaction({
    int? id,
    required int accountId,
    required int amountCents,
    required String label,
    int? categoryId,
    required _ixycnzxw.ScheduleFrequency frequency,
    int? interval,
    required DateTime startDate,
    DateTime? endDate,
    int? occurrenceCount,
    DateTime? nextDue,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) = _ScheduledTransactionImpl;

  factory ScheduledTransaction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScheduledTransaction(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      label: jsonSerialization['label'] as String,
      categoryId: jsonSerialization['categoryId'] as int?,
      frequency: _ixycnzxw.ScheduleFrequency.fromJson(
        (jsonSerialization['frequency'] as String),
      ),
      interval: jsonSerialization['interval'] as int?,
      startDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      occurrenceCount: jsonSerialization['occurrenceCount'] as int?,
      nextDue: jsonSerialization['nextDue'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['nextDue']),
      matchPattern: jsonSerialization['matchPattern'] as String?,
      dateToleranceDays: jsonSerialization['dateToleranceDays'] as int?,
      amountTolerancePercent:
          jsonSerialization['amountTolerancePercent'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = ScheduledTransactionTable();

  static const db = ScheduledTransactionRepository._();

  @override
  int? id;

  int accountId;

  int amountCents;

  String label;

  int? categoryId;

  _ixycnzxw.ScheduleFrequency frequency;

  int interval;

  DateTime startDate;

  DateTime? endDate;

  int? occurrenceCount;

  /// First occurrence not yet realised; null = from startDate.
  DateTime? nextDue;

  String matchPattern;

  int dateToleranceDays;

  int amountTolerancePercent;

  DateTime createdAt;

  DateTime? deletedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScheduledTransaction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScheduledTransaction copyWith({
    int? id,
    int? accountId,
    int? amountCents,
    String? label,
    int? categoryId,
    _ixycnzxw.ScheduleFrequency? frequency,
    int? interval,
    DateTime? startDate,
    DateTime? endDate,
    int? occurrenceCount,
    DateTime? nextDue,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduledTransaction',
      if (id != null) 'id': id,
      'accountId': accountId,
      'amountCents': amountCents,
      'label': label,
      if (categoryId != null) 'categoryId': categoryId,
      'frequency': frequency.toJson(),
      'interval': interval,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (occurrenceCount != null) 'occurrenceCount': occurrenceCount,
      if (nextDue != null) 'nextDue': nextDue?.toJson(),
      'matchPattern': matchPattern,
      'dateToleranceDays': dateToleranceDays,
      'amountTolerancePercent': amountTolerancePercent,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduledTransaction',
      if (id != null) 'id': id,
      'accountId': accountId,
      'amountCents': amountCents,
      'label': label,
      if (categoryId != null) 'categoryId': categoryId,
      'frequency': frequency.toJson(),
      'interval': interval,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (occurrenceCount != null) 'occurrenceCount': occurrenceCount,
      if (nextDue != null) 'nextDue': nextDue?.toJson(),
      'matchPattern': matchPattern,
      'dateToleranceDays': dateToleranceDays,
      'amountTolerancePercent': amountTolerancePercent,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static ScheduledTransactionInclude include() {
    return ScheduledTransactionInclude._();
  }

  static ScheduledTransactionIncludeList includeList({
    _is.WhereExpressionBuilder<ScheduledTransactionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduledTransactionTable>? orderBy,
    _is.OrderByListBuilder<ScheduledTransactionTable>? orderByList,
    ScheduledTransactionInclude? include,
  }) {
    return ScheduledTransactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduledTransaction.t),
      orderByList: orderByList?.call(ScheduledTransaction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduledTransactionImpl extends ScheduledTransaction {
  _ScheduledTransactionImpl({
    int? id,
    required int accountId,
    required int amountCents,
    required String label,
    int? categoryId,
    required _ixycnzxw.ScheduleFrequency frequency,
    int? interval,
    required DateTime startDate,
    DateTime? endDate,
    int? occurrenceCount,
    DateTime? nextDue,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         accountId: accountId,
         amountCents: amountCents,
         label: label,
         categoryId: categoryId,
         frequency: frequency,
         interval: interval,
         startDate: startDate,
         endDate: endDate,
         occurrenceCount: occurrenceCount,
         nextDue: nextDue,
         matchPattern: matchPattern,
         dateToleranceDays: dateToleranceDays,
         amountTolerancePercent: amountTolerancePercent,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [ScheduledTransaction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ScheduledTransaction copyWith({
    Object? id = _Undefined,
    int? accountId,
    int? amountCents,
    String? label,
    Object? categoryId = _Undefined,
    _ixycnzxw.ScheduleFrequency? frequency,
    int? interval,
    DateTime? startDate,
    Object? endDate = _Undefined,
    Object? occurrenceCount = _Undefined,
    Object? nextDue = _Undefined,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return ScheduledTransaction(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      amountCents: amountCents ?? this.amountCents,
      label: label ?? this.label,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      occurrenceCount: occurrenceCount is int?
          ? occurrenceCount
          : this.occurrenceCount,
      nextDue: nextDue is DateTime? ? nextDue : this.nextDue,
      matchPattern: matchPattern ?? this.matchPattern,
      dateToleranceDays: dateToleranceDays ?? this.dateToleranceDays,
      amountTolerancePercent:
          amountTolerancePercent ?? this.amountTolerancePercent,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class ScheduledTransactionUpdateTable
    extends _is.UpdateTable<ScheduledTransactionTable> {
  ScheduledTransactionUpdateTable(super.table);

  _is.ColumnValue<int, int> accountId(int value) => _is.ColumnValue(
    table.accountId,
    value,
  );

  _is.ColumnValue<int, int> amountCents(int value) => _is.ColumnValue(
    table.amountCents,
    value,
  );

  _is.ColumnValue<String, String> label(String value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<int, int> categoryId(int? value) => _is.ColumnValue(
    table.categoryId,
    value,
  );

  _is.ColumnValue<_ixycnzxw.ScheduleFrequency, _ixycnzxw.ScheduleFrequency>
  frequency(_ixycnzxw.ScheduleFrequency value) => _is.ColumnValue(
    table.frequency,
    value,
  );

  _is.ColumnValue<int, int> interval(int value) => _is.ColumnValue(
    table.interval,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _is.ColumnValue(
        table.startDate,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _is.ColumnValue(
        table.endDate,
        value,
      );

  _is.ColumnValue<int, int> occurrenceCount(int? value) => _is.ColumnValue(
    table.occurrenceCount,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> nextDue(DateTime? value) =>
      _is.ColumnValue(
        table.nextDue,
        value,
      );

  _is.ColumnValue<String, String> matchPattern(String value) => _is.ColumnValue(
    table.matchPattern,
    value,
  );

  _is.ColumnValue<int, int> dateToleranceDays(int value) => _is.ColumnValue(
    table.dateToleranceDays,
    value,
  );

  _is.ColumnValue<int, int> amountTolerancePercent(int value) =>
      _is.ColumnValue(
        table.amountTolerancePercent,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _is.ColumnValue(
        table.deletedAt,
        value,
      );
}

class ScheduledTransactionTable extends _is.Table<int?> {
  ScheduledTransactionTable({super.tableRelation})
    : super(tableName: 'scheduled_transactions') {
    updateTable = ScheduledTransactionUpdateTable(this);
    accountId = _is.ColumnInt(
      'accountId',
      this,
    );
    amountCents = _is.ColumnInt(
      'amountCents',
      this,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    categoryId = _is.ColumnInt(
      'categoryId',
      this,
    );
    frequency = _is.ColumnEnum(
      'frequency',
      this,
      _is.EnumSerialization.byName,
    );
    interval = _is.ColumnInt(
      'interval',
      this,
      hasDefault: true,
    );
    startDate = _is.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _is.ColumnDateTime(
      'endDate',
      this,
    );
    occurrenceCount = _is.ColumnInt(
      'occurrenceCount',
      this,
    );
    nextDue = _is.ColumnDateTime(
      'nextDue',
      this,
    );
    matchPattern = _is.ColumnString(
      'matchPattern',
      this,
      hasDefault: true,
    );
    dateToleranceDays = _is.ColumnInt(
      'dateToleranceDays',
      this,
      hasDefault: true,
    );
    amountTolerancePercent = _is.ColumnInt(
      'amountTolerancePercent',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    deletedAt = _is.ColumnDateTime(
      'deletedAt',
      this,
    );
  }

  late final ScheduledTransactionUpdateTable updateTable;

  late final _is.ColumnInt accountId;

  late final _is.ColumnInt amountCents;

  late final _is.ColumnString label;

  late final _is.ColumnInt categoryId;

  late final _is.ColumnEnum<_ixycnzxw.ScheduleFrequency> frequency;

  late final _is.ColumnInt interval;

  late final _is.ColumnDateTime startDate;

  late final _is.ColumnDateTime endDate;

  late final _is.ColumnInt occurrenceCount;

  /// First occurrence not yet realised; null = from startDate.
  late final _is.ColumnDateTime nextDue;

  late final _is.ColumnString matchPattern;

  late final _is.ColumnInt dateToleranceDays;

  late final _is.ColumnInt amountTolerancePercent;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime deletedAt;

  @override
  List<_is.Column> get columns => [
    id,
    accountId,
    amountCents,
    label,
    categoryId,
    frequency,
    interval,
    startDate,
    endDate,
    occurrenceCount,
    nextDue,
    matchPattern,
    dateToleranceDays,
    amountTolerancePercent,
    createdAt,
    deletedAt,
  ];
}

class ScheduledTransactionInclude extends _is.IncludeObject {
  ScheduledTransactionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ScheduledTransaction.t;
}

class ScheduledTransactionIncludeList extends _is.IncludeList {
  ScheduledTransactionIncludeList._({
    _is.WhereExpressionBuilder<ScheduledTransactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScheduledTransaction.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ScheduledTransaction.t;
}

class ScheduledTransactionRepository {
  const ScheduledTransactionRepository._();

  /// Returns a list of [ScheduledTransaction]s matching the given query parameters.
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
  Future<List<ScheduledTransaction>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduledTransactionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduledTransactionTable>? orderBy,
    _is.OrderByListBuilder<ScheduledTransactionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ScheduledTransaction>(
      where: where?.call(ScheduledTransaction.t),
      orderBy: orderBy?.call(ScheduledTransaction.t),
      orderByList: orderByList?.call(ScheduledTransaction.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ScheduledTransaction] matching the given query parameters.
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
  Future<ScheduledTransaction?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduledTransactionTable>? where,
    int? offset,
    _is.OrderByBuilder<ScheduledTransactionTable>? orderBy,
    _is.OrderByListBuilder<ScheduledTransactionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ScheduledTransaction>(
      where: where?.call(ScheduledTransaction.t),
      orderBy: orderBy?.call(ScheduledTransaction.t),
      orderByList: orderByList?.call(ScheduledTransaction.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ScheduledTransaction] by its [id] or null if no such row exists.
  Future<ScheduledTransaction?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ScheduledTransaction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ScheduledTransaction]s in the list and returns the inserted rows.
  ///
  /// The returned [ScheduledTransaction]s will have their `id` fields set.
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
  Future<List<ScheduledTransaction>> insert(
    _is.DatabaseSession session,
    List<ScheduledTransaction> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ScheduledTransaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ScheduledTransaction] and returns the inserted row.
  ///
  /// The returned [ScheduledTransaction] will have its `id` field set.
  Future<ScheduledTransaction> insertRow(
    _is.DatabaseSession session,
    ScheduledTransaction row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScheduledTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ScheduledTransaction]s in the list and returns the resulting rows.
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
  /// The returned [ScheduledTransaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduledTransaction>> upsert(
    _is.DatabaseSession session,
    List<ScheduledTransaction> rows, {
    required _is.ColumnSelections<ScheduledTransactionTable> conflictColumns,
    _is.ColumnSelections<ScheduledTransactionTable>? updateColumns,
    _is.WhereExpressionBuilder<ScheduledTransactionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ScheduledTransaction>(
      rows,
      conflictColumns: conflictColumns(ScheduledTransaction.t),
      updateColumns: updateColumns?.call(ScheduledTransaction.t),
      updateWhere: updateWhere?.call(ScheduledTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ScheduledTransaction] and returns the resulting row.
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
  /// The returned [ScheduledTransaction] will have its `id` field set.
  Future<ScheduledTransaction?> upsertRow(
    _is.DatabaseSession session,
    ScheduledTransaction row, {
    required _is.ColumnSelections<ScheduledTransactionTable> conflictColumns,
    _is.ColumnSelections<ScheduledTransactionTable>? updateColumns,
    _is.WhereExpressionBuilder<ScheduledTransactionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ScheduledTransaction>(
      row,
      conflictColumns: conflictColumns(ScheduledTransaction.t),
      updateColumns: updateColumns?.call(ScheduledTransaction.t),
      updateWhere: updateWhere?.call(ScheduledTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduledTransaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduledTransaction>> update(
    _is.DatabaseSession session,
    List<ScheduledTransaction> rows, {
    _is.ColumnSelections<ScheduledTransactionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ScheduledTransaction>(
      rows,
      columns: columns?.call(ScheduledTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ScheduledTransaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScheduledTransaction> updateRow(
    _is.DatabaseSession session,
    ScheduledTransaction row, {
    _is.ColumnSelections<ScheduledTransactionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScheduledTransaction>(
      row,
      columns: columns?.call(ScheduledTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScheduledTransaction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScheduledTransaction?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ScheduledTransactionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ScheduledTransaction>(
      id,
      columnValues: columnValues(ScheduledTransaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduledTransaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduledTransaction>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ScheduledTransactionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ScheduledTransactionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduledTransactionTable>? orderBy,
    _is.OrderByListBuilder<ScheduledTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ScheduledTransaction>(
      columnValues: columnValues(ScheduledTransaction.t.updateTable),
      where: where(ScheduledTransaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduledTransaction.t),
      orderByList: orderByList?.call(ScheduledTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ScheduledTransaction]s in the list and returns the deleted rows.
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
  Future<List<ScheduledTransaction>> delete(
    _is.DatabaseSession session,
    List<ScheduledTransaction> rows, {
    _is.OrderByBuilder<ScheduledTransactionTable>? orderBy,
    _is.OrderByListBuilder<ScheduledTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ScheduledTransaction>(
      rows,
      orderBy: orderBy?.call(ScheduledTransaction.t),
      orderByList: orderByList?.call(ScheduledTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ScheduledTransaction].
  Future<ScheduledTransaction> deleteRow(
    _is.DatabaseSession session,
    ScheduledTransaction row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScheduledTransaction>(
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
  Future<List<ScheduledTransaction>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScheduledTransactionTable> where,
    _is.OrderByBuilder<ScheduledTransactionTable>? orderBy,
    _is.OrderByListBuilder<ScheduledTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ScheduledTransaction>(
      where: where(ScheduledTransaction.t),
      orderBy: orderBy?.call(ScheduledTransaction.t),
      orderByList: orderByList?.call(ScheduledTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduledTransactionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ScheduledTransaction>(
      where: where?.call(ScheduledTransaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ScheduledTransaction] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScheduledTransactionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ScheduledTransaction>(
      where: where(ScheduledTransaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
