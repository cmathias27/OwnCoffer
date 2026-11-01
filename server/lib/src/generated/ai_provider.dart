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

/// An AI provider set up by the server administrator (décision 0017): the
/// users choose among them. Its key is encrypted and never sent back.
abstract class AiProvider
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AiProvider._({
    this.id,
    required this.name,
    required this.kind,
    required this.baseUrl,
    this.apiKeyBox,
    this.hasKey,
    required this.models,
    required this.toolCalling,
    required this.vision,
    required this.monthlyCap,
    required this.enabled,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AiProvider({
    int? id,
    required String name,
    required String kind,
    required String baseUrl,
    String? apiKeyBox,
    bool? hasKey,
    required String models,
    required bool toolCalling,
    required bool vision,
    required int monthlyCap,
    required bool enabled,
    DateTime? createdAt,
  }) = _AiProviderImpl;

  factory AiProvider.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiProvider(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      kind: jsonSerialization['kind'] as String,
      baseUrl: jsonSerialization['baseUrl'] as String,
      apiKeyBox: jsonSerialization['apiKeyBox'] as String?,
      hasKey: jsonSerialization['hasKey'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['hasKey']),
      models: jsonSerialization['models'] as String,
      toolCalling: _is.BoolJsonExtension.fromJson(
        jsonSerialization['toolCalling'],
      ),
      vision: _is.BoolJsonExtension.fromJson(jsonSerialization['vision']),
      monthlyCap: jsonSerialization['monthlyCap'] as int,
      enabled: _is.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AiProviderTable();

  static const db = AiProviderRepository._();

  @override
  int? id;

  String name;

  /// openai (any API compatible with OpenAI's, external) or ollama (a
  /// model on this server or the local network).
  String kind;

  /// Base of the API, e.g. https://api.mistral.ai/v1 or
  /// http://192.168.1.10:11434/v1.
  String baseUrl;

  String? apiKeyBox;

  /// The key is set (the key itself never leaves the server).
  bool? hasKey;

  /// Models offered to the users, comma-separated.
  String models;

  /// Capabilities of its models (décision 0008): calling the engine's
  /// functions, reading images.
  bool toolCalling;

  bool vision;

  /// Requests per user and month; 0 means no limit.
  int monthlyCap;

  bool enabled;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AiProvider]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiProvider copyWith({
    int? id,
    String? name,
    String? kind,
    String? baseUrl,
    String? apiKeyBox,
    bool? hasKey,
    String? models,
    bool? toolCalling,
    bool? vision,
    int? monthlyCap,
    bool? enabled,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiProvider',
      if (id != null) 'id': id,
      'name': name,
      'kind': kind,
      'baseUrl': baseUrl,
      if (apiKeyBox != null) 'apiKeyBox': apiKeyBox,
      if (hasKey != null) 'hasKey': hasKey,
      'models': models,
      'toolCalling': toolCalling,
      'vision': vision,
      'monthlyCap': monthlyCap,
      'enabled': enabled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiProvider',
      if (id != null) 'id': id,
      'name': name,
      'kind': kind,
      'baseUrl': baseUrl,
      if (hasKey != null) 'hasKey': hasKey,
      'models': models,
      'toolCalling': toolCalling,
      'vision': vision,
      'monthlyCap': monthlyCap,
      'enabled': enabled,
      'createdAt': createdAt.toJson(),
    };
  }

  static AiProviderInclude include() {
    return AiProviderInclude._();
  }

  static AiProviderIncludeList includeList({
    _is.WhereExpressionBuilder<AiProviderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiProviderTable>? orderBy,
    _is.OrderByListBuilder<AiProviderTable>? orderByList,
    AiProviderInclude? include,
  }) {
    return AiProviderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiProvider.t),
      orderByList: orderByList?.call(AiProvider.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiProviderImpl extends AiProvider {
  _AiProviderImpl({
    int? id,
    required String name,
    required String kind,
    required String baseUrl,
    String? apiKeyBox,
    bool? hasKey,
    required String models,
    required bool toolCalling,
    required bool vision,
    required int monthlyCap,
    required bool enabled,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         kind: kind,
         baseUrl: baseUrl,
         apiKeyBox: apiKeyBox,
         hasKey: hasKey,
         models: models,
         toolCalling: toolCalling,
         vision: vision,
         monthlyCap: monthlyCap,
         enabled: enabled,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AiProvider]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiProvider copyWith({
    Object? id = _Undefined,
    String? name,
    String? kind,
    String? baseUrl,
    Object? apiKeyBox = _Undefined,
    Object? hasKey = _Undefined,
    String? models,
    bool? toolCalling,
    bool? vision,
    int? monthlyCap,
    bool? enabled,
    DateTime? createdAt,
  }) {
    return AiProvider(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKeyBox: apiKeyBox is String? ? apiKeyBox : this.apiKeyBox,
      hasKey: hasKey is bool? ? hasKey : this.hasKey,
      models: models ?? this.models,
      toolCalling: toolCalling ?? this.toolCalling,
      vision: vision ?? this.vision,
      monthlyCap: monthlyCap ?? this.monthlyCap,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AiProviderUpdateTable extends _is.UpdateTable<AiProviderTable> {
  AiProviderUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> baseUrl(String value) => _is.ColumnValue(
    table.baseUrl,
    value,
  );

  _is.ColumnValue<String, String> apiKeyBox(String? value) => _is.ColumnValue(
    table.apiKeyBox,
    value,
  );

  _is.ColumnValue<String, String> models(String value) => _is.ColumnValue(
    table.models,
    value,
  );

  _is.ColumnValue<bool, bool> toolCalling(bool value) => _is.ColumnValue(
    table.toolCalling,
    value,
  );

  _is.ColumnValue<bool, bool> vision(bool value) => _is.ColumnValue(
    table.vision,
    value,
  );

  _is.ColumnValue<int, int> monthlyCap(int value) => _is.ColumnValue(
    table.monthlyCap,
    value,
  );

  _is.ColumnValue<bool, bool> enabled(bool value) => _is.ColumnValue(
    table.enabled,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AiProviderTable extends _is.Table<int?> {
  AiProviderTable({super.tableRelation}) : super(tableName: 'ai_providers') {
    updateTable = AiProviderUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    baseUrl = _is.ColumnString(
      'baseUrl',
      this,
    );
    apiKeyBox = _is.ColumnString(
      'apiKeyBox',
      this,
    );
    models = _is.ColumnString(
      'models',
      this,
    );
    toolCalling = _is.ColumnBool(
      'toolCalling',
      this,
    );
    vision = _is.ColumnBool(
      'vision',
      this,
    );
    monthlyCap = _is.ColumnInt(
      'monthlyCap',
      this,
    );
    enabled = _is.ColumnBool(
      'enabled',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final AiProviderUpdateTable updateTable;

  late final _is.ColumnString name;

  /// openai (any API compatible with OpenAI's, external) or ollama (a
  /// model on this server or the local network).
  late final _is.ColumnString kind;

  /// Base of the API, e.g. https://api.mistral.ai/v1 or
  /// http://192.168.1.10:11434/v1.
  late final _is.ColumnString baseUrl;

  late final _is.ColumnString apiKeyBox;

  /// Models offered to the users, comma-separated.
  late final _is.ColumnString models;

  /// Capabilities of its models (décision 0008): calling the engine's
  /// functions, reading images.
  late final _is.ColumnBool toolCalling;

  late final _is.ColumnBool vision;

  /// Requests per user and month; 0 means no limit.
  late final _is.ColumnInt monthlyCap;

  late final _is.ColumnBool enabled;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    kind,
    baseUrl,
    apiKeyBox,
    models,
    toolCalling,
    vision,
    monthlyCap,
    enabled,
    createdAt,
  ];
}

class AiProviderInclude extends _is.IncludeObject {
  AiProviderInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AiProvider.t;
}

class AiProviderIncludeList extends _is.IncludeList {
  AiProviderIncludeList._({
    _is.WhereExpressionBuilder<AiProviderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiProvider.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AiProvider.t;
}

class AiProviderRepository {
  const AiProviderRepository._();

  /// Returns a list of [AiProvider]s matching the given query parameters.
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
  Future<List<AiProvider>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiProviderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiProviderTable>? orderBy,
    _is.OrderByListBuilder<AiProviderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiProvider>(
      where: where?.call(AiProvider.t),
      orderBy: orderBy?.call(AiProvider.t),
      orderByList: orderByList?.call(AiProvider.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiProvider] matching the given query parameters.
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
  Future<AiProvider?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiProviderTable>? where,
    int? offset,
    _is.OrderByBuilder<AiProviderTable>? orderBy,
    _is.OrderByListBuilder<AiProviderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiProvider>(
      where: where?.call(AiProvider.t),
      orderBy: orderBy?.call(AiProvider.t),
      orderByList: orderByList?.call(AiProvider.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiProvider] by its [id] or null if no such row exists.
  Future<AiProvider?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiProvider>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiProvider]s in the list and returns the inserted rows.
  ///
  /// The returned [AiProvider]s will have their `id` fields set.
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
  Future<List<AiProvider>> insert(
    _is.DatabaseSession session,
    List<AiProvider> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiProvider>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiProvider] and returns the inserted row.
  ///
  /// The returned [AiProvider] will have its `id` field set.
  Future<AiProvider> insertRow(
    _is.DatabaseSession session,
    AiProvider row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiProvider>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiProvider]s in the list and returns the resulting rows.
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
  /// The returned [AiProvider]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiProvider>> upsert(
    _is.DatabaseSession session,
    List<AiProvider> rows, {
    required _is.ColumnSelections<AiProviderTable> conflictColumns,
    _is.ColumnSelections<AiProviderTable>? updateColumns,
    _is.WhereExpressionBuilder<AiProviderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiProvider>(
      rows,
      conflictColumns: conflictColumns(AiProvider.t),
      updateColumns: updateColumns?.call(AiProvider.t),
      updateWhere: updateWhere?.call(AiProvider.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiProvider] and returns the resulting row.
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
  /// The returned [AiProvider] will have its `id` field set.
  Future<AiProvider?> upsertRow(
    _is.DatabaseSession session,
    AiProvider row, {
    required _is.ColumnSelections<AiProviderTable> conflictColumns,
    _is.ColumnSelections<AiProviderTable>? updateColumns,
    _is.WhereExpressionBuilder<AiProviderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiProvider>(
      row,
      conflictColumns: conflictColumns(AiProvider.t),
      updateColumns: updateColumns?.call(AiProvider.t),
      updateWhere: updateWhere?.call(AiProvider.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiProvider]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiProvider>> update(
    _is.DatabaseSession session,
    List<AiProvider> rows, {
    _is.ColumnSelections<AiProviderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiProvider>(
      rows,
      columns: columns?.call(AiProvider.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiProvider]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiProvider> updateRow(
    _is.DatabaseSession session,
    AiProvider row, {
    _is.ColumnSelections<AiProviderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiProvider>(
      row,
      columns: columns?.call(AiProvider.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiProvider] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiProvider?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AiProviderUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiProvider>(
      id,
      columnValues: columnValues(AiProvider.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiProvider]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiProvider>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiProviderUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AiProviderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiProviderTable>? orderBy,
    _is.OrderByListBuilder<AiProviderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiProvider>(
      columnValues: columnValues(AiProvider.t.updateTable),
      where: where(AiProvider.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiProvider.t),
      orderByList: orderByList?.call(AiProvider.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiProvider]s in the list and returns the deleted rows.
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
  Future<List<AiProvider>> delete(
    _is.DatabaseSession session,
    List<AiProvider> rows, {
    _is.OrderByBuilder<AiProviderTable>? orderBy,
    _is.OrderByListBuilder<AiProviderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiProvider>(
      rows,
      orderBy: orderBy?.call(AiProvider.t),
      orderByList: orderByList?.call(AiProvider.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiProvider].
  Future<AiProvider> deleteRow(
    _is.DatabaseSession session,
    AiProvider row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiProvider>(
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
  Future<List<AiProvider>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiProviderTable> where,
    _is.OrderByBuilder<AiProviderTable>? orderBy,
    _is.OrderByListBuilder<AiProviderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiProvider>(
      where: where(AiProvider.t),
      orderBy: orderBy?.call(AiProvider.t),
      orderByList: orderByList?.call(AiProvider.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiProviderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiProvider>(
      where: where?.call(AiProvider.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiProvider] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiProviderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiProvider>(
      where: where(AiProvider.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
