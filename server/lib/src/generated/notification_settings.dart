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

/// What a user wants to be told, and how: one row per user, absent means
/// everything on (the default). An alert turned off in the app is not
/// created at all, so it is not emailed either.
abstract class NotificationSettings
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  NotificationSettings._({
    this.id,
    required this.authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  }) : overdraftApp = overdraftApp ?? true,
       overdraftEmail = overdraftEmail ?? true,
       goalWarning = goalWarning ?? true,
       goalOver = goalOver ?? true,
       goalForecast = goalForecast ?? true,
       warrantyApp = warrantyApp ?? true,
       warrantyEmail = warrantyEmail ?? true,
       updatedAt = updatedAt ?? DateTime.now();

  factory NotificationSettings({
    int? id,
    required _is.UuidValue authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  }) = _NotificationSettingsImpl;

  factory NotificationSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationSettings(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      overdraftApp: jsonSerialization['overdraftApp'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['overdraftApp']),
      overdraftEmail: jsonSerialization['overdraftEmail'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['overdraftEmail']),
      goalWarning: jsonSerialization['goalWarning'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['goalWarning']),
      goalOver: jsonSerialization['goalOver'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['goalOver']),
      goalForecast: jsonSerialization['goalForecast'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['goalForecast']),
      warrantyApp: jsonSerialization['warrantyApp'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['warrantyApp']),
      warrantyEmail: jsonSerialization['warrantyEmail'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['warrantyEmail']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NotificationSettingsTable();

  static const db = NotificationSettingsRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  /// Forecast overdraft of an account.
  bool overdraftApp;

  bool overdraftEmail;

  /// Goals: 80 %, 100 %, and overrun announced by the projection.
  bool goalWarning;

  bool goalOver;

  bool goalForecast;

  /// End of an invoice's warranty, a month before.
  bool warrantyApp;

  bool warrantyEmail;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [NotificationSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotificationSettings copyWith({
    int? id,
    _is.UuidValue? authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationSettings',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'overdraftApp': overdraftApp,
      'overdraftEmail': overdraftEmail,
      'goalWarning': goalWarning,
      'goalOver': goalOver,
      'goalForecast': goalForecast,
      'warrantyApp': warrantyApp,
      'warrantyEmail': warrantyEmail,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationSettings',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'overdraftApp': overdraftApp,
      'overdraftEmail': overdraftEmail,
      'goalWarning': goalWarning,
      'goalOver': goalOver,
      'goalForecast': goalForecast,
      'warrantyApp': warrantyApp,
      'warrantyEmail': warrantyEmail,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static NotificationSettingsInclude include() {
    return NotificationSettingsInclude._();
  }

  static NotificationSettingsIncludeList includeList({
    _is.WhereExpressionBuilder<NotificationSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationSettingsTable>? orderBy,
    _is.OrderByListBuilder<NotificationSettingsTable>? orderByList,
    NotificationSettingsInclude? include,
  }) {
    return NotificationSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationSettings.t),
      orderByList: orderByList?.call(NotificationSettings.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationSettingsImpl extends NotificationSettings {
  _NotificationSettingsImpl({
    int? id,
    required _is.UuidValue authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         overdraftApp: overdraftApp,
         overdraftEmail: overdraftEmail,
         goalWarning: goalWarning,
         goalOver: goalOver,
         goalForecast: goalForecast,
         warrantyApp: warrantyApp,
         warrantyEmail: warrantyEmail,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotificationSettings copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  }) {
    return NotificationSettings(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      overdraftApp: overdraftApp ?? this.overdraftApp,
      overdraftEmail: overdraftEmail ?? this.overdraftEmail,
      goalWarning: goalWarning ?? this.goalWarning,
      goalOver: goalOver ?? this.goalOver,
      goalForecast: goalForecast ?? this.goalForecast,
      warrantyApp: warrantyApp ?? this.warrantyApp,
      warrantyEmail: warrantyEmail ?? this.warrantyEmail,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationSettingsUpdateTable
    extends _is.UpdateTable<NotificationSettingsTable> {
  NotificationSettingsUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<bool, bool> overdraftApp(bool value) => _is.ColumnValue(
    table.overdraftApp,
    value,
  );

  _is.ColumnValue<bool, bool> overdraftEmail(bool value) => _is.ColumnValue(
    table.overdraftEmail,
    value,
  );

  _is.ColumnValue<bool, bool> goalWarning(bool value) => _is.ColumnValue(
    table.goalWarning,
    value,
  );

  _is.ColumnValue<bool, bool> goalOver(bool value) => _is.ColumnValue(
    table.goalOver,
    value,
  );

  _is.ColumnValue<bool, bool> goalForecast(bool value) => _is.ColumnValue(
    table.goalForecast,
    value,
  );

  _is.ColumnValue<bool, bool> warrantyApp(bool value) => _is.ColumnValue(
    table.warrantyApp,
    value,
  );

  _is.ColumnValue<bool, bool> warrantyEmail(bool value) => _is.ColumnValue(
    table.warrantyEmail,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class NotificationSettingsTable extends _is.Table<int?> {
  NotificationSettingsTable({super.tableRelation})
    : super(tableName: 'notification_settings') {
    updateTable = NotificationSettingsUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    overdraftApp = _is.ColumnBool(
      'overdraftApp',
      this,
      hasDefault: true,
    );
    overdraftEmail = _is.ColumnBool(
      'overdraftEmail',
      this,
      hasDefault: true,
    );
    goalWarning = _is.ColumnBool(
      'goalWarning',
      this,
      hasDefault: true,
    );
    goalOver = _is.ColumnBool(
      'goalOver',
      this,
      hasDefault: true,
    );
    goalForecast = _is.ColumnBool(
      'goalForecast',
      this,
      hasDefault: true,
    );
    warrantyApp = _is.ColumnBool(
      'warrantyApp',
      this,
      hasDefault: true,
    );
    warrantyEmail = _is.ColumnBool(
      'warrantyEmail',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final NotificationSettingsUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// Forecast overdraft of an account.
  late final _is.ColumnBool overdraftApp;

  late final _is.ColumnBool overdraftEmail;

  /// Goals: 80 %, 100 %, and overrun announced by the projection.
  late final _is.ColumnBool goalWarning;

  late final _is.ColumnBool goalOver;

  late final _is.ColumnBool goalForecast;

  /// End of an invoice's warranty, a month before.
  late final _is.ColumnBool warrantyApp;

  late final _is.ColumnBool warrantyEmail;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    overdraftApp,
    overdraftEmail,
    goalWarning,
    goalOver,
    goalForecast,
    warrantyApp,
    warrantyEmail,
    updatedAt,
  ];
}

class NotificationSettingsInclude extends _is.IncludeObject {
  NotificationSettingsInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => NotificationSettings.t;
}

class NotificationSettingsIncludeList extends _is.IncludeList {
  NotificationSettingsIncludeList._({
    _is.WhereExpressionBuilder<NotificationSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationSettings.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => NotificationSettings.t;
}

class NotificationSettingsRepository {
  const NotificationSettingsRepository._();

  /// Returns a list of [NotificationSettings]s matching the given query parameters.
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
  Future<List<NotificationSettings>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationSettingsTable>? orderBy,
    _is.OrderByListBuilder<NotificationSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationSettings>(
      where: where?.call(NotificationSettings.t),
      orderBy: orderBy?.call(NotificationSettings.t),
      orderByList: orderByList?.call(NotificationSettings.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotificationSettings] matching the given query parameters.
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
  Future<NotificationSettings?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationSettingsTable>? where,
    int? offset,
    _is.OrderByBuilder<NotificationSettingsTable>? orderBy,
    _is.OrderByListBuilder<NotificationSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationSettings>(
      where: where?.call(NotificationSettings.t),
      orderBy: orderBy?.call(NotificationSettings.t),
      orderByList: orderByList?.call(NotificationSettings.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationSettings] by its [id] or null if no such row exists.
  Future<NotificationSettings?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationSettings>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationSettings]s will have their `id` fields set.
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
  Future<List<NotificationSettings>> insert(
    _is.DatabaseSession session,
    List<NotificationSettings> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotificationSettings>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotificationSettings] and returns the inserted row.
  ///
  /// The returned [NotificationSettings] will have its `id` field set.
  Future<NotificationSettings> insertRow(
    _is.DatabaseSession session,
    NotificationSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotificationSettings]s in the list and returns the resulting rows.
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
  /// The returned [NotificationSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationSettings>> upsert(
    _is.DatabaseSession session,
    List<NotificationSettings> rows, {
    required _is.ColumnSelections<NotificationSettingsTable> conflictColumns,
    _is.ColumnSelections<NotificationSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<NotificationSettingsTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotificationSettings>(
      rows,
      conflictColumns: conflictColumns(NotificationSettings.t),
      updateColumns: updateColumns?.call(NotificationSettings.t),
      updateWhere: updateWhere?.call(NotificationSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotificationSettings] and returns the resulting row.
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
  /// The returned [NotificationSettings] will have its `id` field set.
  Future<NotificationSettings?> upsertRow(
    _is.DatabaseSession session,
    NotificationSettings row, {
    required _is.ColumnSelections<NotificationSettingsTable> conflictColumns,
    _is.ColumnSelections<NotificationSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<NotificationSettingsTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotificationSettings>(
      row,
      conflictColumns: conflictColumns(NotificationSettings.t),
      updateColumns: updateColumns?.call(NotificationSettings.t),
      updateWhere: updateWhere?.call(NotificationSettings.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationSettings>> update(
    _is.DatabaseSession session,
    List<NotificationSettings> rows, {
    _is.ColumnSelections<NotificationSettingsTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotificationSettings>(
      rows,
      columns: columns?.call(NotificationSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotificationSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationSettings> updateRow(
    _is.DatabaseSession session,
    NotificationSettings row, {
    _is.ColumnSelections<NotificationSettingsTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationSettings>(
      row,
      columns: columns?.call(NotificationSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationSettings?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<NotificationSettingsUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationSettings>(
      id,
      columnValues: columnValues(NotificationSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationSettings>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotificationSettingsUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotificationSettingsTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationSettingsTable>? orderBy,
    _is.OrderByListBuilder<NotificationSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotificationSettings>(
      columnValues: columnValues(NotificationSettings.t.updateTable),
      where: where(NotificationSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationSettings.t),
      orderByList: orderByList?.call(NotificationSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotificationSettings]s in the list and returns the deleted rows.
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
  Future<List<NotificationSettings>> delete(
    _is.DatabaseSession session,
    List<NotificationSettings> rows, {
    _is.OrderByBuilder<NotificationSettingsTable>? orderBy,
    _is.OrderByListBuilder<NotificationSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotificationSettings>(
      rows,
      orderBy: orderBy?.call(NotificationSettings.t),
      orderByList: orderByList?.call(NotificationSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotificationSettings].
  Future<NotificationSettings> deleteRow(
    _is.DatabaseSession session,
    NotificationSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationSettings>(
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
  Future<List<NotificationSettings>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotificationSettingsTable> where,
    _is.OrderByBuilder<NotificationSettingsTable>? orderBy,
    _is.OrderByListBuilder<NotificationSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotificationSettings>(
      where: where(NotificationSettings.t),
      orderBy: orderBy?.call(NotificationSettings.t),
      orderByList: orderByList?.call(NotificationSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationSettingsTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotificationSettings>(
      where: where?.call(NotificationSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationSettings] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotificationSettingsTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationSettings>(
      where: where(NotificationSettings.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
