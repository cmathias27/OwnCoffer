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

/// Local copy of the community rules base (CC0, decision 0013).
abstract class CommunityRule
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CommunityRule._({
    this.id,
    required this.ruleKey,
    required this.pattern,
    required this.matchType,
    _i13yq1r7.RuleDirection? direction,
    required this.standardCode,
    String? country,
    int? confidence,
    required this.baseVersion,
  }) : direction = direction ?? _i13yq1r7.RuleDirection.any,
       country = country ?? 'FR',
       confidence = confidence ?? 50;

  factory CommunityRule({
    int? id,
    required String ruleKey,
    required String pattern,
    required _ibgrh3pe.RuleMatchType matchType,
    _i13yq1r7.RuleDirection? direction,
    required String standardCode,
    String? country,
    int? confidence,
    required int baseVersion,
  }) = _CommunityRuleImpl;

  factory CommunityRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityRule(
      id: jsonSerialization['id'] as int?,
      ruleKey: jsonSerialization['ruleKey'] as String,
      pattern: jsonSerialization['pattern'] as String,
      matchType: _ibgrh3pe.RuleMatchType.fromJson(
        (jsonSerialization['matchType'] as String),
      ),
      direction: jsonSerialization['direction'] == null
          ? null
          : _i13yq1r7.RuleDirection.fromJson(
              (jsonSerialization['direction'] as String),
            ),
      standardCode: jsonSerialization['standardCode'] as String,
      country: jsonSerialization['country'] as String?,
      confidence: jsonSerialization['confidence'] as int?,
      baseVersion: jsonSerialization['baseVersion'] as int,
    );
  }

  static final t = CommunityRuleTable();

  static const db = CommunityRuleRepository._();

  @override
  int? id;

  String ruleKey;

  String pattern;

  _ibgrh3pe.RuleMatchType matchType;

  _i13yq1r7.RuleDirection direction;

  String standardCode;

  String country;

  int confidence;

  int baseVersion;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CommunityRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CommunityRule copyWith({
    int? id,
    String? ruleKey,
    String? pattern,
    _ibgrh3pe.RuleMatchType? matchType,
    _i13yq1r7.RuleDirection? direction,
    String? standardCode,
    String? country,
    int? confidence,
    int? baseVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CommunityRule',
      if (id != null) 'id': id,
      'ruleKey': ruleKey,
      'pattern': pattern,
      'matchType': matchType.toJson(),
      'direction': direction.toJson(),
      'standardCode': standardCode,
      'country': country,
      'confidence': confidence,
      'baseVersion': baseVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CommunityRule',
      if (id != null) 'id': id,
      'ruleKey': ruleKey,
      'pattern': pattern,
      'matchType': matchType.toJson(),
      'direction': direction.toJson(),
      'standardCode': standardCode,
      'country': country,
      'confidence': confidence,
      'baseVersion': baseVersion,
    };
  }

  static CommunityRuleInclude include() {
    return CommunityRuleInclude._();
  }

  static CommunityRuleIncludeList includeList({
    _is.WhereExpressionBuilder<CommunityRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityRuleTable>? orderBy,
    _is.OrderByListBuilder<CommunityRuleTable>? orderByList,
    CommunityRuleInclude? include,
  }) {
    return CommunityRuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommunityRule.t),
      orderByList: orderByList?.call(CommunityRule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommunityRuleImpl extends CommunityRule {
  _CommunityRuleImpl({
    int? id,
    required String ruleKey,
    required String pattern,
    required _ibgrh3pe.RuleMatchType matchType,
    _i13yq1r7.RuleDirection? direction,
    required String standardCode,
    String? country,
    int? confidence,
    required int baseVersion,
  }) : super._(
         id: id,
         ruleKey: ruleKey,
         pattern: pattern,
         matchType: matchType,
         direction: direction,
         standardCode: standardCode,
         country: country,
         confidence: confidence,
         baseVersion: baseVersion,
       );

  /// Returns a shallow copy of this [CommunityRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CommunityRule copyWith({
    Object? id = _Undefined,
    String? ruleKey,
    String? pattern,
    _ibgrh3pe.RuleMatchType? matchType,
    _i13yq1r7.RuleDirection? direction,
    String? standardCode,
    String? country,
    int? confidence,
    int? baseVersion,
  }) {
    return CommunityRule(
      id: id is int? ? id : this.id,
      ruleKey: ruleKey ?? this.ruleKey,
      pattern: pattern ?? this.pattern,
      matchType: matchType ?? this.matchType,
      direction: direction ?? this.direction,
      standardCode: standardCode ?? this.standardCode,
      country: country ?? this.country,
      confidence: confidence ?? this.confidence,
      baseVersion: baseVersion ?? this.baseVersion,
    );
  }
}

class CommunityRuleUpdateTable extends _is.UpdateTable<CommunityRuleTable> {
  CommunityRuleUpdateTable(super.table);

  _is.ColumnValue<String, String> ruleKey(String value) => _is.ColumnValue(
    table.ruleKey,
    value,
  );

  _is.ColumnValue<String, String> pattern(String value) => _is.ColumnValue(
    table.pattern,
    value,
  );

  _is.ColumnValue<_ibgrh3pe.RuleMatchType, _ibgrh3pe.RuleMatchType> matchType(
    _ibgrh3pe.RuleMatchType value,
  ) => _is.ColumnValue(
    table.matchType,
    value,
  );

  _is.ColumnValue<_i13yq1r7.RuleDirection, _i13yq1r7.RuleDirection> direction(
    _i13yq1r7.RuleDirection value,
  ) => _is.ColumnValue(
    table.direction,
    value,
  );

  _is.ColumnValue<String, String> standardCode(String value) => _is.ColumnValue(
    table.standardCode,
    value,
  );

  _is.ColumnValue<String, String> country(String value) => _is.ColumnValue(
    table.country,
    value,
  );

  _is.ColumnValue<int, int> confidence(int value) => _is.ColumnValue(
    table.confidence,
    value,
  );

  _is.ColumnValue<int, int> baseVersion(int value) => _is.ColumnValue(
    table.baseVersion,
    value,
  );
}

class CommunityRuleTable extends _is.Table<int?> {
  CommunityRuleTable({super.tableRelation})
    : super(tableName: 'community_rules') {
    updateTable = CommunityRuleUpdateTable(this);
    ruleKey = _is.ColumnString(
      'ruleKey',
      this,
    );
    pattern = _is.ColumnString(
      'pattern',
      this,
    );
    matchType = _is.ColumnEnum(
      'matchType',
      this,
      _is.EnumSerialization.byName,
    );
    direction = _is.ColumnEnum(
      'direction',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    standardCode = _is.ColumnString(
      'standardCode',
      this,
    );
    country = _is.ColumnString(
      'country',
      this,
      hasDefault: true,
    );
    confidence = _is.ColumnInt(
      'confidence',
      this,
      hasDefault: true,
    );
    baseVersion = _is.ColumnInt(
      'baseVersion',
      this,
    );
  }

  late final CommunityRuleUpdateTable updateTable;

  late final _is.ColumnString ruleKey;

  late final _is.ColumnString pattern;

  late final _is.ColumnEnum<_ibgrh3pe.RuleMatchType> matchType;

  late final _is.ColumnEnum<_i13yq1r7.RuleDirection> direction;

  late final _is.ColumnString standardCode;

  late final _is.ColumnString country;

  late final _is.ColumnInt confidence;

  late final _is.ColumnInt baseVersion;

  @override
  List<_is.Column> get columns => [
    id,
    ruleKey,
    pattern,
    matchType,
    direction,
    standardCode,
    country,
    confidence,
    baseVersion,
  ];
}

class CommunityRuleInclude extends _is.IncludeObject {
  CommunityRuleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CommunityRule.t;
}

class CommunityRuleIncludeList extends _is.IncludeList {
  CommunityRuleIncludeList._({
    _is.WhereExpressionBuilder<CommunityRuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CommunityRule.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CommunityRule.t;
}

class CommunityRuleRepository {
  const CommunityRuleRepository._();

  /// Returns a list of [CommunityRule]s matching the given query parameters.
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
  Future<List<CommunityRule>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityRuleTable>? orderBy,
    _is.OrderByListBuilder<CommunityRuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CommunityRule>(
      where: where?.call(CommunityRule.t),
      orderBy: orderBy?.call(CommunityRule.t),
      orderByList: orderByList?.call(CommunityRule.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CommunityRule] matching the given query parameters.
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
  Future<CommunityRule?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityRuleTable>? where,
    int? offset,
    _is.OrderByBuilder<CommunityRuleTable>? orderBy,
    _is.OrderByListBuilder<CommunityRuleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CommunityRule>(
      where: where?.call(CommunityRule.t),
      orderBy: orderBy?.call(CommunityRule.t),
      orderByList: orderByList?.call(CommunityRule.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CommunityRule] by its [id] or null if no such row exists.
  Future<CommunityRule?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CommunityRule>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CommunityRule]s in the list and returns the inserted rows.
  ///
  /// The returned [CommunityRule]s will have their `id` fields set.
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
  Future<List<CommunityRule>> insert(
    _is.DatabaseSession session,
    List<CommunityRule> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CommunityRule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CommunityRule] and returns the inserted row.
  ///
  /// The returned [CommunityRule] will have its `id` field set.
  Future<CommunityRule> insertRow(
    _is.DatabaseSession session,
    CommunityRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CommunityRule>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CommunityRule]s in the list and returns the resulting rows.
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
  /// The returned [CommunityRule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityRule>> upsert(
    _is.DatabaseSession session,
    List<CommunityRule> rows, {
    required _is.ColumnSelections<CommunityRuleTable> conflictColumns,
    _is.ColumnSelections<CommunityRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<CommunityRuleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CommunityRule>(
      rows,
      conflictColumns: conflictColumns(CommunityRule.t),
      updateColumns: updateColumns?.call(CommunityRule.t),
      updateWhere: updateWhere?.call(CommunityRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CommunityRule] and returns the resulting row.
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
  /// The returned [CommunityRule] will have its `id` field set.
  Future<CommunityRule?> upsertRow(
    _is.DatabaseSession session,
    CommunityRule row, {
    required _is.ColumnSelections<CommunityRuleTable> conflictColumns,
    _is.ColumnSelections<CommunityRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<CommunityRuleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CommunityRule>(
      row,
      conflictColumns: conflictColumns(CommunityRule.t),
      updateColumns: updateColumns?.call(CommunityRule.t),
      updateWhere: updateWhere?.call(CommunityRule.t),
      transaction: transaction,
    );
  }

  /// Updates all [CommunityRule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityRule>> update(
    _is.DatabaseSession session,
    List<CommunityRule> rows, {
    _is.ColumnSelections<CommunityRuleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CommunityRule>(
      rows,
      columns: columns?.call(CommunityRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CommunityRule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CommunityRule> updateRow(
    _is.DatabaseSession session,
    CommunityRule row, {
    _is.ColumnSelections<CommunityRuleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CommunityRule>(
      row,
      columns: columns?.call(CommunityRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CommunityRule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CommunityRule?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CommunityRuleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CommunityRule>(
      id,
      columnValues: columnValues(CommunityRule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CommunityRule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommunityRule>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CommunityRuleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CommunityRuleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommunityRuleTable>? orderBy,
    _is.OrderByListBuilder<CommunityRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CommunityRule>(
      columnValues: columnValues(CommunityRule.t.updateTable),
      where: where(CommunityRule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommunityRule.t),
      orderByList: orderByList?.call(CommunityRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CommunityRule]s in the list and returns the deleted rows.
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
  Future<List<CommunityRule>> delete(
    _is.DatabaseSession session,
    List<CommunityRule> rows, {
    _is.OrderByBuilder<CommunityRuleTable>? orderBy,
    _is.OrderByListBuilder<CommunityRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CommunityRule>(
      rows,
      orderBy: orderBy?.call(CommunityRule.t),
      orderByList: orderByList?.call(CommunityRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CommunityRule].
  Future<CommunityRule> deleteRow(
    _is.DatabaseSession session,
    CommunityRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CommunityRule>(
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
  Future<List<CommunityRule>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CommunityRuleTable> where,
    _is.OrderByBuilder<CommunityRuleTable>? orderBy,
    _is.OrderByListBuilder<CommunityRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CommunityRule>(
      where: where(CommunityRule.t),
      orderBy: orderBy?.call(CommunityRule.t),
      orderByList: orderByList?.call(CommunityRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommunityRuleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CommunityRule>(
      where: where?.call(CommunityRule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CommunityRule] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CommunityRuleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CommunityRule>(
      where: where(CommunityRule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
