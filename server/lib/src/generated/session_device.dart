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

/// Where and on what a session is used (decision 0027): one row per session
/// (JWT refresh token), told by the app at start and when it comes back to
/// the foreground. Kept 30 days after the session ends, then deleted.
abstract class SessionDevice
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SessionDevice._({
    this.id,
    required this.sessionId,
    required this.authUserId,
    required this.platform,
    this.appVersion,
    this.deviceLabel,
    this.ip,
    this.city,
    this.country,
    required this.firstSeenAt,
    required this.lastSeenAt,
    this.endedAt,
  });

  factory SessionDevice({
    int? id,
    required String sessionId,
    required _is.UuidValue authUserId,
    required String platform,
    String? appVersion,
    String? deviceLabel,
    String? ip,
    String? city,
    String? country,
    required DateTime firstSeenAt,
    required DateTime lastSeenAt,
    DateTime? endedAt,
  }) = _SessionDeviceImpl;

  factory SessionDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionDevice(
      id: jsonSerialization['id'] as int?,
      sessionId: jsonSerialization['sessionId'] as String,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      platform: jsonSerialization['platform'] as String,
      appVersion: jsonSerialization['appVersion'] as String?,
      deviceLabel: jsonSerialization['deviceLabel'] as String?,
      ip: jsonSerialization['ip'] as String?,
      city: jsonSerialization['city'] as String?,
      country: jsonSerialization['country'] as String?,
      firstSeenAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstSeenAt'],
      ),
      lastSeenAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeenAt'],
      ),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
    );
  }

  static final t = SessionDeviceTable();

  static const db = SessionDeviceRepository._();

  @override
  int? id;

  /// The refresh token id (the `authId` of every access token).
  String sessionId;

  _is.UuidValue authUserId;

  /// `web`, `android`, `windows`, `ios`, `macos`, `linux` or `other`.
  String platform;

  String? appVersion;

  /// Name given by the person (« Téléphone de Camille »).
  String? deviceLabel;

  String? ip;

  String? city;

  String? country;

  DateTime firstSeenAt;

  DateTime lastSeenAt;

  /// When the session was seen gone (signed out, closed, expired).
  DateTime? endedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SessionDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionDevice copyWith({
    int? id,
    String? sessionId,
    _is.UuidValue? authUserId,
    String? platform,
    String? appVersion,
    String? deviceLabel,
    String? ip,
    String? city,
    String? country,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
    DateTime? endedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionDevice',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'authUserId': authUserId.toJson(),
      'platform': platform,
      if (appVersion != null) 'appVersion': appVersion,
      if (deviceLabel != null) 'deviceLabel': deviceLabel,
      if (ip != null) 'ip': ip,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      'firstSeenAt': firstSeenAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SessionDeviceInclude include() {
    return SessionDeviceInclude._();
  }

  static SessionDeviceIncludeList includeList({
    _is.WhereExpressionBuilder<SessionDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionDeviceTable>? orderBy,
    _is.OrderByListBuilder<SessionDeviceTable>? orderByList,
    SessionDeviceInclude? include,
  }) {
    return SessionDeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionDevice.t),
      orderByList: orderByList?.call(SessionDevice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionDeviceImpl extends SessionDevice {
  _SessionDeviceImpl({
    int? id,
    required String sessionId,
    required _is.UuidValue authUserId,
    required String platform,
    String? appVersion,
    String? deviceLabel,
    String? ip,
    String? city,
    String? country,
    required DateTime firstSeenAt,
    required DateTime lastSeenAt,
    DateTime? endedAt,
  }) : super._(
         id: id,
         sessionId: sessionId,
         authUserId: authUserId,
         platform: platform,
         appVersion: appVersion,
         deviceLabel: deviceLabel,
         ip: ip,
         city: city,
         country: country,
         firstSeenAt: firstSeenAt,
         lastSeenAt: lastSeenAt,
         endedAt: endedAt,
       );

  /// Returns a shallow copy of this [SessionDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionDevice copyWith({
    Object? id = _Undefined,
    String? sessionId,
    _is.UuidValue? authUserId,
    String? platform,
    Object? appVersion = _Undefined,
    Object? deviceLabel = _Undefined,
    Object? ip = _Undefined,
    Object? city = _Undefined,
    Object? country = _Undefined,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
    Object? endedAt = _Undefined,
  }) {
    return SessionDevice(
      id: id is int? ? id : this.id,
      sessionId: sessionId ?? this.sessionId,
      authUserId: authUserId ?? this.authUserId,
      platform: platform ?? this.platform,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      deviceLabel: deviceLabel is String? ? deviceLabel : this.deviceLabel,
      ip: ip is String? ? ip : this.ip,
      city: city is String? ? city : this.city,
      country: country is String? ? country : this.country,
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
    );
  }
}

class SessionDeviceUpdateTable extends _is.UpdateTable<SessionDeviceTable> {
  SessionDeviceUpdateTable(super.table);

  _is.ColumnValue<String, String> sessionId(String value) => _is.ColumnValue(
    table.sessionId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> platform(String value) => _is.ColumnValue(
    table.platform,
    value,
  );

  _is.ColumnValue<String, String> appVersion(String? value) => _is.ColumnValue(
    table.appVersion,
    value,
  );

  _is.ColumnValue<String, String> deviceLabel(String? value) => _is.ColumnValue(
    table.deviceLabel,
    value,
  );

  _is.ColumnValue<String, String> ip(String? value) => _is.ColumnValue(
    table.ip,
    value,
  );

  _is.ColumnValue<String, String> city(String? value) => _is.ColumnValue(
    table.city,
    value,
  );

  _is.ColumnValue<String, String> country(String? value) => _is.ColumnValue(
    table.country,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> firstSeenAt(DateTime value) =>
      _is.ColumnValue(
        table.firstSeenAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime value) =>
      _is.ColumnValue(
        table.lastSeenAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endedAt(DateTime? value) =>
      _is.ColumnValue(
        table.endedAt,
        value,
      );
}

class SessionDeviceTable extends _is.Table<int?> {
  SessionDeviceTable({super.tableRelation})
    : super(tableName: 'session_device') {
    updateTable = SessionDeviceUpdateTable(this);
    sessionId = _is.ColumnString(
      'sessionId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    platform = _is.ColumnString(
      'platform',
      this,
    );
    appVersion = _is.ColumnString(
      'appVersion',
      this,
    );
    deviceLabel = _is.ColumnString(
      'deviceLabel',
      this,
    );
    ip = _is.ColumnString(
      'ip',
      this,
    );
    city = _is.ColumnString(
      'city',
      this,
    );
    country = _is.ColumnString(
      'country',
      this,
    );
    firstSeenAt = _is.ColumnDateTime(
      'firstSeenAt',
      this,
    );
    lastSeenAt = _is.ColumnDateTime(
      'lastSeenAt',
      this,
    );
    endedAt = _is.ColumnDateTime(
      'endedAt',
      this,
    );
  }

  late final SessionDeviceUpdateTable updateTable;

  /// The refresh token id (the `authId` of every access token).
  late final _is.ColumnString sessionId;

  late final _is.ColumnUuid authUserId;

  /// `web`, `android`, `windows`, `ios`, `macos`, `linux` or `other`.
  late final _is.ColumnString platform;

  late final _is.ColumnString appVersion;

  /// Name given by the person (« Téléphone de Camille »).
  late final _is.ColumnString deviceLabel;

  late final _is.ColumnString ip;

  late final _is.ColumnString city;

  late final _is.ColumnString country;

  late final _is.ColumnDateTime firstSeenAt;

  late final _is.ColumnDateTime lastSeenAt;

  /// When the session was seen gone (signed out, closed, expired).
  late final _is.ColumnDateTime endedAt;

  @override
  List<_is.Column> get columns => [
    id,
    sessionId,
    authUserId,
    platform,
    appVersion,
    deviceLabel,
    ip,
    city,
    country,
    firstSeenAt,
    lastSeenAt,
    endedAt,
  ];
}

class SessionDeviceInclude extends _is.IncludeObject {
  SessionDeviceInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SessionDevice.t;
}

class SessionDeviceIncludeList extends _is.IncludeList {
  SessionDeviceIncludeList._({
    _is.WhereExpressionBuilder<SessionDeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SessionDevice.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SessionDevice.t;
}

class SessionDeviceRepository {
  const SessionDeviceRepository._();

  /// Returns a list of [SessionDevice]s matching the given query parameters.
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
  Future<List<SessionDevice>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionDeviceTable>? orderBy,
    _is.OrderByListBuilder<SessionDeviceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SessionDevice>(
      where: where?.call(SessionDevice.t),
      orderBy: orderBy?.call(SessionDevice.t),
      orderByList: orderByList?.call(SessionDevice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SessionDevice] matching the given query parameters.
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
  Future<SessionDevice?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionDeviceTable>? where,
    int? offset,
    _is.OrderByBuilder<SessionDeviceTable>? orderBy,
    _is.OrderByListBuilder<SessionDeviceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SessionDevice>(
      where: where?.call(SessionDevice.t),
      orderBy: orderBy?.call(SessionDevice.t),
      orderByList: orderByList?.call(SessionDevice.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SessionDevice] by its [id] or null if no such row exists.
  Future<SessionDevice?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SessionDevice>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SessionDevice]s in the list and returns the inserted rows.
  ///
  /// The returned [SessionDevice]s will have their `id` fields set.
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
  Future<List<SessionDevice>> insert(
    _is.DatabaseSession session,
    List<SessionDevice> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SessionDevice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SessionDevice] and returns the inserted row.
  ///
  /// The returned [SessionDevice] will have its `id` field set.
  Future<SessionDevice> insertRow(
    _is.DatabaseSession session,
    SessionDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SessionDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SessionDevice]s in the list and returns the resulting rows.
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
  /// The returned [SessionDevice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionDevice>> upsert(
    _is.DatabaseSession session,
    List<SessionDevice> rows, {
    required _is.ColumnSelections<SessionDeviceTable> conflictColumns,
    _is.ColumnSelections<SessionDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionDeviceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SessionDevice>(
      rows,
      conflictColumns: conflictColumns(SessionDevice.t),
      updateColumns: updateColumns?.call(SessionDevice.t),
      updateWhere: updateWhere?.call(SessionDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SessionDevice] and returns the resulting row.
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
  /// The returned [SessionDevice] will have its `id` field set.
  Future<SessionDevice?> upsertRow(
    _is.DatabaseSession session,
    SessionDevice row, {
    required _is.ColumnSelections<SessionDeviceTable> conflictColumns,
    _is.ColumnSelections<SessionDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionDeviceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SessionDevice>(
      row,
      conflictColumns: conflictColumns(SessionDevice.t),
      updateColumns: updateColumns?.call(SessionDevice.t),
      updateWhere: updateWhere?.call(SessionDevice.t),
      transaction: transaction,
    );
  }

  /// Updates all [SessionDevice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionDevice>> update(
    _is.DatabaseSession session,
    List<SessionDevice> rows, {
    _is.ColumnSelections<SessionDeviceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SessionDevice>(
      rows,
      columns: columns?.call(SessionDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SessionDevice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SessionDevice> updateRow(
    _is.DatabaseSession session,
    SessionDevice row, {
    _is.ColumnSelections<SessionDeviceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SessionDevice>(
      row,
      columns: columns?.call(SessionDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SessionDevice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SessionDevice?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SessionDeviceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SessionDevice>(
      id,
      columnValues: columnValues(SessionDevice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SessionDevice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionDevice>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SessionDeviceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SessionDeviceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionDeviceTable>? orderBy,
    _is.OrderByListBuilder<SessionDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SessionDevice>(
      columnValues: columnValues(SessionDevice.t.updateTable),
      where: where(SessionDevice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionDevice.t),
      orderByList: orderByList?.call(SessionDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SessionDevice]s in the list and returns the deleted rows.
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
  Future<List<SessionDevice>> delete(
    _is.DatabaseSession session,
    List<SessionDevice> rows, {
    _is.OrderByBuilder<SessionDeviceTable>? orderBy,
    _is.OrderByListBuilder<SessionDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SessionDevice>(
      rows,
      orderBy: orderBy?.call(SessionDevice.t),
      orderByList: orderByList?.call(SessionDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SessionDevice].
  Future<SessionDevice> deleteRow(
    _is.DatabaseSession session,
    SessionDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SessionDevice>(
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
  Future<List<SessionDevice>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionDeviceTable> where,
    _is.OrderByBuilder<SessionDeviceTable>? orderBy,
    _is.OrderByListBuilder<SessionDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SessionDevice>(
      where: where(SessionDevice.t),
      orderBy: orderBy?.call(SessionDevice.t),
      orderByList: orderByList?.call(SessionDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionDeviceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SessionDevice>(
      where: where?.call(SessionDevice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SessionDevice] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionDeviceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SessionDevice>(
      where: where(SessionDevice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
