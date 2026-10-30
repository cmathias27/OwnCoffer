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
import 'category_kind.dart' as _i7kso3nf;

/// Catalogue of standard categories (docs/data/standard_categories.yaml).
/// `code` is stable (e.g. `food.groceries`) and never reused.
abstract class StandardCategory
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StandardCategory._({
    this.id,
    required this.code,
    this.parentCode,
    required this.kind,
    required this.nameFr,
    required this.nameEn,
    this.icon,
    bool? deprecated,
    required this.catalogVersion,
  }) : deprecated = deprecated ?? false;

  factory StandardCategory({
    int? id,
    required String code,
    String? parentCode,
    required _i7kso3nf.CategoryKind kind,
    required String nameFr,
    required String nameEn,
    String? icon,
    bool? deprecated,
    required int catalogVersion,
  }) = _StandardCategoryImpl;

  factory StandardCategory.fromJson(Map<String, dynamic> jsonSerialization) {
    return StandardCategory(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      parentCode: jsonSerialization['parentCode'] as String?,
      kind: _i7kso3nf.CategoryKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      nameFr: jsonSerialization['nameFr'] as String,
      nameEn: jsonSerialization['nameEn'] as String,
      icon: jsonSerialization['icon'] as String?,
      deprecated: jsonSerialization['deprecated'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['deprecated']),
      catalogVersion: jsonSerialization['catalogVersion'] as int,
    );
  }

  static final t = StandardCategoryTable();

  static const db = StandardCategoryRepository._();

  @override
  int? id;

  String code;

  String? parentCode;

  _i7kso3nf.CategoryKind kind;

  String nameFr;

  String nameEn;

  String? icon;

  bool deprecated;

  int catalogVersion;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StandardCategory]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StandardCategory copyWith({
    int? id,
    String? code,
    String? parentCode,
    _i7kso3nf.CategoryKind? kind,
    String? nameFr,
    String? nameEn,
    String? icon,
    bool? deprecated,
    int? catalogVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StandardCategory',
      if (id != null) 'id': id,
      'code': code,
      if (parentCode != null) 'parentCode': parentCode,
      'kind': kind.toJson(),
      'nameFr': nameFr,
      'nameEn': nameEn,
      if (icon != null) 'icon': icon,
      'deprecated': deprecated,
      'catalogVersion': catalogVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StandardCategory',
      if (id != null) 'id': id,
      'code': code,
      if (parentCode != null) 'parentCode': parentCode,
      'kind': kind.toJson(),
      'nameFr': nameFr,
      'nameEn': nameEn,
      if (icon != null) 'icon': icon,
      'deprecated': deprecated,
      'catalogVersion': catalogVersion,
    };
  }

  static StandardCategoryInclude include() {
    return StandardCategoryInclude._();
  }

  static StandardCategoryIncludeList includeList({
    _is.WhereExpressionBuilder<StandardCategoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StandardCategoryTable>? orderBy,
    _is.OrderByListBuilder<StandardCategoryTable>? orderByList,
    StandardCategoryInclude? include,
  }) {
    return StandardCategoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StandardCategory.t),
      orderByList: orderByList?.call(StandardCategory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StandardCategoryImpl extends StandardCategory {
  _StandardCategoryImpl({
    int? id,
    required String code,
    String? parentCode,
    required _i7kso3nf.CategoryKind kind,
    required String nameFr,
    required String nameEn,
    String? icon,
    bool? deprecated,
    required int catalogVersion,
  }) : super._(
         id: id,
         code: code,
         parentCode: parentCode,
         kind: kind,
         nameFr: nameFr,
         nameEn: nameEn,
         icon: icon,
         deprecated: deprecated,
         catalogVersion: catalogVersion,
       );

  /// Returns a shallow copy of this [StandardCategory]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StandardCategory copyWith({
    Object? id = _Undefined,
    String? code,
    Object? parentCode = _Undefined,
    _i7kso3nf.CategoryKind? kind,
    String? nameFr,
    String? nameEn,
    Object? icon = _Undefined,
    bool? deprecated,
    int? catalogVersion,
  }) {
    return StandardCategory(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      parentCode: parentCode is String? ? parentCode : this.parentCode,
      kind: kind ?? this.kind,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      icon: icon is String? ? icon : this.icon,
      deprecated: deprecated ?? this.deprecated,
      catalogVersion: catalogVersion ?? this.catalogVersion,
    );
  }
}

class StandardCategoryUpdateTable
    extends _is.UpdateTable<StandardCategoryTable> {
  StandardCategoryUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> parentCode(String? value) => _is.ColumnValue(
    table.parentCode,
    value,
  );

  _is.ColumnValue<_i7kso3nf.CategoryKind, _i7kso3nf.CategoryKind> kind(
    _i7kso3nf.CategoryKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> nameFr(String value) => _is.ColumnValue(
    table.nameFr,
    value,
  );

  _is.ColumnValue<String, String> nameEn(String value) => _is.ColumnValue(
    table.nameEn,
    value,
  );

  _is.ColumnValue<String, String> icon(String? value) => _is.ColumnValue(
    table.icon,
    value,
  );

  _is.ColumnValue<bool, bool> deprecated(bool value) => _is.ColumnValue(
    table.deprecated,
    value,
  );

  _is.ColumnValue<int, int> catalogVersion(int value) => _is.ColumnValue(
    table.catalogVersion,
    value,
  );
}

class StandardCategoryTable extends _is.Table<int?> {
  StandardCategoryTable({super.tableRelation})
    : super(tableName: 'standard_categories') {
    updateTable = StandardCategoryUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    parentCode = _is.ColumnString(
      'parentCode',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    nameFr = _is.ColumnString(
      'nameFr',
      this,
    );
    nameEn = _is.ColumnString(
      'nameEn',
      this,
    );
    icon = _is.ColumnString(
      'icon',
      this,
    );
    deprecated = _is.ColumnBool(
      'deprecated',
      this,
      hasDefault: true,
    );
    catalogVersion = _is.ColumnInt(
      'catalogVersion',
      this,
    );
  }

  late final StandardCategoryUpdateTable updateTable;

  late final _is.ColumnString code;

  late final _is.ColumnString parentCode;

  late final _is.ColumnEnum<_i7kso3nf.CategoryKind> kind;

  late final _is.ColumnString nameFr;

  late final _is.ColumnString nameEn;

  late final _is.ColumnString icon;

  late final _is.ColumnBool deprecated;

  late final _is.ColumnInt catalogVersion;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    parentCode,
    kind,
    nameFr,
    nameEn,
    icon,
    deprecated,
    catalogVersion,
  ];
}

class StandardCategoryInclude extends _is.IncludeObject {
  StandardCategoryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StandardCategory.t;
}

class StandardCategoryIncludeList extends _is.IncludeList {
  StandardCategoryIncludeList._({
    _is.WhereExpressionBuilder<StandardCategoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StandardCategory.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StandardCategory.t;
}

class StandardCategoryRepository {
  const StandardCategoryRepository._();

  /// Returns a list of [StandardCategory]s matching the given query parameters.
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
  Future<List<StandardCategory>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StandardCategoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StandardCategoryTable>? orderBy,
    _is.OrderByListBuilder<StandardCategoryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StandardCategory>(
      where: where?.call(StandardCategory.t),
      orderBy: orderBy?.call(StandardCategory.t),
      orderByList: orderByList?.call(StandardCategory.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StandardCategory] matching the given query parameters.
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
  Future<StandardCategory?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StandardCategoryTable>? where,
    int? offset,
    _is.OrderByBuilder<StandardCategoryTable>? orderBy,
    _is.OrderByListBuilder<StandardCategoryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StandardCategory>(
      where: where?.call(StandardCategory.t),
      orderBy: orderBy?.call(StandardCategory.t),
      orderByList: orderByList?.call(StandardCategory.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StandardCategory] by its [id] or null if no such row exists.
  Future<StandardCategory?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StandardCategory>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StandardCategory]s in the list and returns the inserted rows.
  ///
  /// The returned [StandardCategory]s will have their `id` fields set.
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
  Future<List<StandardCategory>> insert(
    _is.DatabaseSession session,
    List<StandardCategory> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StandardCategory>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StandardCategory] and returns the inserted row.
  ///
  /// The returned [StandardCategory] will have its `id` field set.
  Future<StandardCategory> insertRow(
    _is.DatabaseSession session,
    StandardCategory row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StandardCategory>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StandardCategory]s in the list and returns the resulting rows.
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
  /// The returned [StandardCategory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StandardCategory>> upsert(
    _is.DatabaseSession session,
    List<StandardCategory> rows, {
    required _is.ColumnSelections<StandardCategoryTable> conflictColumns,
    _is.ColumnSelections<StandardCategoryTable>? updateColumns,
    _is.WhereExpressionBuilder<StandardCategoryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StandardCategory>(
      rows,
      conflictColumns: conflictColumns(StandardCategory.t),
      updateColumns: updateColumns?.call(StandardCategory.t),
      updateWhere: updateWhere?.call(StandardCategory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StandardCategory] and returns the resulting row.
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
  /// The returned [StandardCategory] will have its `id` field set.
  Future<StandardCategory?> upsertRow(
    _is.DatabaseSession session,
    StandardCategory row, {
    required _is.ColumnSelections<StandardCategoryTable> conflictColumns,
    _is.ColumnSelections<StandardCategoryTable>? updateColumns,
    _is.WhereExpressionBuilder<StandardCategoryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StandardCategory>(
      row,
      conflictColumns: conflictColumns(StandardCategory.t),
      updateColumns: updateColumns?.call(StandardCategory.t),
      updateWhere: updateWhere?.call(StandardCategory.t),
      transaction: transaction,
    );
  }

  /// Updates all [StandardCategory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StandardCategory>> update(
    _is.DatabaseSession session,
    List<StandardCategory> rows, {
    _is.ColumnSelections<StandardCategoryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StandardCategory>(
      rows,
      columns: columns?.call(StandardCategory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StandardCategory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StandardCategory> updateRow(
    _is.DatabaseSession session,
    StandardCategory row, {
    _is.ColumnSelections<StandardCategoryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StandardCategory>(
      row,
      columns: columns?.call(StandardCategory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StandardCategory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StandardCategory?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StandardCategoryUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StandardCategory>(
      id,
      columnValues: columnValues(StandardCategory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StandardCategory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StandardCategory>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StandardCategoryUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<StandardCategoryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StandardCategoryTable>? orderBy,
    _is.OrderByListBuilder<StandardCategoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StandardCategory>(
      columnValues: columnValues(StandardCategory.t.updateTable),
      where: where(StandardCategory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StandardCategory.t),
      orderByList: orderByList?.call(StandardCategory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StandardCategory]s in the list and returns the deleted rows.
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
  Future<List<StandardCategory>> delete(
    _is.DatabaseSession session,
    List<StandardCategory> rows, {
    _is.OrderByBuilder<StandardCategoryTable>? orderBy,
    _is.OrderByListBuilder<StandardCategoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StandardCategory>(
      rows,
      orderBy: orderBy?.call(StandardCategory.t),
      orderByList: orderByList?.call(StandardCategory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StandardCategory].
  Future<StandardCategory> deleteRow(
    _is.DatabaseSession session,
    StandardCategory row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StandardCategory>(
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
  Future<List<StandardCategory>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StandardCategoryTable> where,
    _is.OrderByBuilder<StandardCategoryTable>? orderBy,
    _is.OrderByListBuilder<StandardCategoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StandardCategory>(
      where: where(StandardCategory.t),
      orderBy: orderBy?.call(StandardCategory.t),
      orderByList: orderByList?.call(StandardCategory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StandardCategoryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StandardCategory>(
      where: where?.call(StandardCategory.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StandardCategory] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StandardCategoryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StandardCategory>(
      where: where(StandardCategory.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
