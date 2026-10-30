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
import 'rule_direction.dart' as _i13yq1r7;
import 'rule_match_type.dart' as _ibgrh3pe;

/// A classification rule of the group. `pattern` is normalised
/// (upper case, no accents) when saved.
abstract class Rule implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Rule._({
    this.id,
    required this.groupId,
    required this.categoryId,
    required this.matchType,
    required this.pattern,
    _i13yq1r7.RuleDirection? direction,
    this.minAbsCents,
    this.maxAbsCents,
    int? priority,
    bool? enabled,
    this.createdBy,
    DateTime? createdAt,
  }) : direction = direction ?? _i13yq1r7.RuleDirection.any,
       priority = priority ?? 100,
       enabled = enabled ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory Rule({
    int? id,
    required int groupId,
    required int categoryId,
    required _ibgrh3pe.RuleMatchType matchType,
    required String pattern,
    _i13yq1r7.RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    int? priority,
    bool? enabled,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  }) = _RuleImpl;

  factory Rule.fromJson(Map<String, dynamic> jsonSerialization) {
    return Rule(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      categoryId: jsonSerialization['categoryId'] as int,
      matchType: _ibgrh3pe.RuleMatchType.fromJson(
        (jsonSerialization['matchType'] as String),
      ),
      pattern: jsonSerialization['pattern'] as String,
      direction: jsonSerialization['direction'] == null
          ? null
          : _i13yq1r7.RuleDirection.fromJson(
              (jsonSerialization['direction'] as String),
            ),
      minAbsCents: jsonSerialization['minAbsCents'] as int?,
      maxAbsCents: jsonSerialization['maxAbsCents'] as int?,
      priority: jsonSerialization['priority'] as int?,
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['createdBy']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = RuleTable();

  static const db = RuleRepository._();

  @override
  int? id;

  int groupId;

  int categoryId;

  _ibgrh3pe.RuleMatchType matchType;

  String pattern;

  _i13yq1r7.RuleDirection direction;

  int? minAbsCents;

  int? maxAbsCents;

  int priority;

  bool enabled;

  _is.UuidValue? createdBy;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Rule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Rule copyWith({
    int? id,
    int? groupId,
    int? categoryId,
    _ibgrh3pe.RuleMatchType? matchType,
    String? pattern,
    _i13yq1r7.RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    int? priority,
    bool? enabled,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Rule',
      if (id != null) 'id': id,
      'groupId': groupId,
      'categoryId': categoryId,
      'matchType': matchType.toJson(),
      'pattern': pattern,
      'direction': direction.toJson(),
      if (minAbsCents != null) 'minAbsCents': minAbsCents,
      if (maxAbsCents != null) 'maxAbsCents': maxAbsCents,
      'priority': priority,
      'enabled': enabled,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Rule',
      if (id != null) 'id': id,
      'groupId': groupId,
      'categoryId': categoryId,
      'matchType': matchType.toJson(),
      'pattern': pattern,
      'direction': direction.toJson(),
      if (minAbsCents != null) 'minAbsCents': minAbsCents,
      if (maxAbsCents != null) 'maxAbsCents': maxAbsCents,
      'priority': priority,
      'enabled': enabled,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static RuleInclude include() {
    return RuleInclude._();
  }

  static RuleIncludeList includeList({
    _is.WhereExpressionBuilder<RuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RuleTable>? orderBy,
    _is.OrderByListBuilder<RuleTable>? orderByList,
    RuleInclude? include,
  }) {
    return RuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Rule.t),
      orderByList: orderByList?.call(Rule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RuleImpl extends Rule {
  _RuleImpl({
    int? id,
    required int groupId,
    required int categoryId,
    required _ibgrh3pe.RuleMatchType matchType,
    required String pattern,
    _i13yq1r7.RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    int? priority,
    bool? enabled,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         categoryId: categoryId,
         matchType: matchType,
         pattern: pattern,
         direction: direction,
         minAbsCents: minAbsCents,
         maxAbsCents: maxAbsCents,
         priority: priority,
         enabled: enabled,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Rule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Rule copyWith({
    Object? id = _Undefined,
    int? groupId,
    int? categoryId,
    _ibgrh3pe.RuleMatchType? matchType,
    String? pattern,
    _i13yq1r7.RuleDirection? direction,
    Object? minAbsCents = _Undefined,
    Object? maxAbsCents = _Undefined,
    int? priority,
    bool? enabled,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
  }) {
    return Rule(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      categoryId: categoryId ?? this.categoryId,
      matchType: matchType ?? this.matchType,
      pattern: pattern ?? this.pattern,
      direction: direction ?? this.direction,
      minAbsCents: minAbsCents is int? ? minAbsCents : this.minAbsCents,
      maxAbsCents: maxAbsCents is int? ? maxAbsCents : this.maxAbsCents,
      priority: priority ?? this.priority,
      enabled: enabled ?? this.enabled,
      createdBy: createdBy is _is.UuidValue? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RuleUpdateTable extends _is.UpdateTable<RuleTable> {
  RuleUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<int, int> categoryId(int value) => _is.ColumnValue(
    table.categoryId,
    value,
  );

  _is.ColumnValue<_ibgrh3pe.RuleMatchType, _ibgrh3pe.RuleMatchType> matchType(
    _ibgrh3pe.RuleMatchType value,
  ) => _is.ColumnValue(
    table.matchType,
    value,
  );

  _is.ColumnValue<String, String> pattern(String value) => _is.ColumnValue(
    table.pattern,
    value,
  );

  _is.ColumnValue<_i13yq1r7.RuleDirection, _i13yq1r7.RuleDirection> direction(
    _i13yq1r7.RuleDirection value,
  ) => _is.ColumnValue(
    table.direction,
    value,
  );

  _is.ColumnValue<int, int> minAbsCents(int? value) => _is.ColumnValue(
    table.minAbsCents,
    value,
  );

  _is.ColumnValue<int, int> maxAbsCents(int? value) => _is.ColumnValue(
    table.maxAbsCents,
    value,
  );

  _is.ColumnValue<int, int> priority(int value) => _is.ColumnValue(
    table.priority,
    value,
  );

  _is.ColumnValue<bool, bool> enabled(bool value) => _is.ColumnValue(
    table.enabled,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> createdBy(
    _is.UuidValue? value,
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

class RuleTable extends _is.Table<int?> {
  RuleTable({super.tableRelation}) : super(tableName: 'rules') {
    updateTable = RuleUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    categoryId = _is.ColumnInt(
      'categoryId',
      this,
    );
    matchType = _is.ColumnEnum(
      'matchType',
      this,
      _is.EnumSerialization.byName,
    );
    pattern = _is.ColumnString(
      'pattern',
      this,
    );
    direction = _is.ColumnEnum(
      'direction',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    minAbsCents = _is.ColumnInt(
      'minAbsCents',
      this,
    );
    maxAbsCents = _is.ColumnInt(
      'maxAbsCents',
      this,
    );
    priority = _is.ColumnInt(
      'priority',
      this,
      hasDefault: true,
    );
    enabled = _is.ColumnBool(
      'enabled',
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

  late final RuleUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnInt categoryId;

  late final _is.ColumnEnum<_ibgrh3pe.RuleMatchType> matchType;

  late final _is.ColumnString pattern;

  late final _is.ColumnEnum<_i13yq1r7.RuleDirection> direction;

  late final _is.ColumnInt minAbsCents;

  late final _is.ColumnInt maxAbsCents;

  late final _is.ColumnInt priority;

  late final _is.ColumnBool enabled;

  late final _is.ColumnUuid createdBy;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    categoryId,
    matchType,
    pattern,
    direction,
    minAbsCents,
    maxAbsCents,
    priority,
    enabled,
    createdBy,
    createdAt,
  ];
}

class RuleInclude extends _is.IncludeObject {
  RuleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Rule.t;
}

class RuleIncludeList extends _is.IncludeList {
  RuleIncludeList._({
    _is.WhereExpressionBuilder<RuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Rule.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Rule.t;
}

class RuleRepository {
  const RuleRepository._();

  /// Returns a list of [Rule]s matching the given query parameters.
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
  Future<List<Rule>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RuleTable>? orderBy,
    _is.OrderByListBuilder<RuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Rule>(
      where: where?.call(Rule.t),
      orderBy: orderBy?.call(Rule.t),
      orderByList: orderByList?.call(Rule.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Rule] matching the given query parameters.
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
  Future<Rule?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RuleTable>? where,
    int? offset,
    _is.OrderByBuilder<RuleTable>? orderBy,
    _is.OrderByListBuilder<RuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Rule>(
      where: where?.call(Rule.t),
      orderBy: orderBy?.call(Rule.t),
      orderByList: orderByList?.call(Rule.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Rule] by its [id] or null if no such row exists.
  Future<Rule?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Rule>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Rule]s in the list and returns the inserted rows.
  ///
  /// The returned [Rule]s will have their `id` fields set.
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
  Future<List<Rule>> insert(
    _is.DatabaseSession session,
    List<Rule> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Rule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Rule] and returns the inserted row.
  ///
  /// The returned [Rule] will have its `id` field set.
  Future<Rule> insertRow(
    _is.DatabaseSession session,
    Rule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Rule>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Rule]s in the list and returns the resulting rows.
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
  /// The returned [Rule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Rule>> upsert(
    _is.DatabaseSession session,
    List<Rule> rows, {
    required _is.ColumnSelections<RuleTable> conflictColumns,
    _is.ColumnSelections<RuleTable>? updateColumns,
    _is.WhereExpressionBuilder<RuleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Rule>(
      rows,
      conflictColumns: conflictColumns(Rule.t),
      updateColumns: updateColumns?.call(Rule.t),
      updateWhere: updateWhere?.call(Rule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Rule] and returns the resulting row.
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
  /// The returned [Rule] will have its `id` field set.
  Future<Rule?> upsertRow(
    _is.DatabaseSession session,
    Rule row, {
    required _is.ColumnSelections<RuleTable> conflictColumns,
    _is.ColumnSelections<RuleTable>? updateColumns,
    _is.WhereExpressionBuilder<RuleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Rule>(
      row,
      conflictColumns: conflictColumns(Rule.t),
      updateColumns: updateColumns?.call(Rule.t),
      updateWhere: updateWhere?.call(Rule.t),
      transaction: transaction,
    );
  }

  /// Updates all [Rule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Rule>> update(
    _is.DatabaseSession session,
    List<Rule> rows, {
    _is.ColumnSelections<RuleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Rule>(
      rows,
      columns: columns?.call(Rule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Rule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Rule> updateRow(
    _is.DatabaseSession session,
    Rule row, {
    _is.ColumnSelections<RuleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Rule>(
      row,
      columns: columns?.call(Rule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Rule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Rule?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RuleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Rule>(
      id,
      columnValues: columnValues(Rule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Rule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Rule>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RuleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RuleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RuleTable>? orderBy,
    _is.OrderByListBuilder<RuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Rule>(
      columnValues: columnValues(Rule.t.updateTable),
      where: where(Rule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Rule.t),
      orderByList: orderByList?.call(Rule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Rule]s in the list and returns the deleted rows.
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
  Future<List<Rule>> delete(
    _is.DatabaseSession session,
    List<Rule> rows, {
    _is.OrderByBuilder<RuleTable>? orderBy,
    _is.OrderByListBuilder<RuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Rule>(
      rows,
      orderBy: orderBy?.call(Rule.t),
      orderByList: orderByList?.call(Rule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Rule].
  Future<Rule> deleteRow(
    _is.DatabaseSession session,
    Rule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Rule>(
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
  Future<List<Rule>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RuleTable> where,
    _is.OrderByBuilder<RuleTable>? orderBy,
    _is.OrderByListBuilder<RuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Rule>(
      where: where(Rule.t),
      orderBy: orderBy?.call(Rule.t),
      orderByList: orderByList?.call(Rule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RuleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Rule>(
      where: where?.call(Rule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Rule] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RuleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Rule>(
      where: where(Rule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
