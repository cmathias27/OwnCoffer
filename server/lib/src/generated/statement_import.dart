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

/// One imported bank file. Cancelling an import soft-deletes its operations.
abstract class StatementImport
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StatementImport._({
    this.id,
    required this.accountId,
    required this.format,
    required this.fileName,
    required this.fileHash,
    required this.encoding,
    required this.readCount,
    required this.addedCount,
    required this.duplicateCount,
    required this.possibleDuplicateCount,
    required this.errorCount,
    required this.classifiedCount,
    required this.authorId,
    DateTime? createdAt,
    this.cancelledAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory StatementImport({
    int? id,
    required int accountId,
    required String format,
    required String fileName,
    required String fileHash,
    required String encoding,
    required int readCount,
    required int addedCount,
    required int duplicateCount,
    required int possibleDuplicateCount,
    required int errorCount,
    required int classifiedCount,
    required _is.UuidValue authorId,
    DateTime? createdAt,
    DateTime? cancelledAt,
  }) = _StatementImportImpl;

  factory StatementImport.fromJson(Map<String, dynamic> jsonSerialization) {
    return StatementImport(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      format: jsonSerialization['format'] as String,
      fileName: jsonSerialization['fileName'] as String,
      fileHash: jsonSerialization['fileHash'] as String,
      encoding: jsonSerialization['encoding'] as String,
      readCount: jsonSerialization['readCount'] as int,
      addedCount: jsonSerialization['addedCount'] as int,
      duplicateCount: jsonSerialization['duplicateCount'] as int,
      possibleDuplicateCount:
          jsonSerialization['possibleDuplicateCount'] as int,
      errorCount: jsonSerialization['errorCount'] as int,
      classifiedCount: jsonSerialization['classifiedCount'] as int,
      authorId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authorId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['cancelledAt'],
            ),
    );
  }

  static final t = StatementImportTable();

  static const db = StatementImportRepository._();

  @override
  int? id;

  int accountId;

  String format;

  String fileName;

  /// SHA-256 of the file, to warn when the same file is imported twice.
  String fileHash;

  String encoding;

  int readCount;

  int addedCount;

  int duplicateCount;

  int possibleDuplicateCount;

  int errorCount;

  int classifiedCount;

  _is.UuidValue authorId;

  DateTime createdAt;

  DateTime? cancelledAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StatementImport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StatementImport copyWith({
    int? id,
    int? accountId,
    String? format,
    String? fileName,
    String? fileHash,
    String? encoding,
    int? readCount,
    int? addedCount,
    int? duplicateCount,
    int? possibleDuplicateCount,
    int? errorCount,
    int? classifiedCount,
    _is.UuidValue? authorId,
    DateTime? createdAt,
    DateTime? cancelledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StatementImport',
      if (id != null) 'id': id,
      'accountId': accountId,
      'format': format,
      'fileName': fileName,
      'fileHash': fileHash,
      'encoding': encoding,
      'readCount': readCount,
      'addedCount': addedCount,
      'duplicateCount': duplicateCount,
      'possibleDuplicateCount': possibleDuplicateCount,
      'errorCount': errorCount,
      'classifiedCount': classifiedCount,
      'authorId': authorId.toJson(),
      'createdAt': createdAt.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StatementImport',
      if (id != null) 'id': id,
      'accountId': accountId,
      'format': format,
      'fileName': fileName,
      'fileHash': fileHash,
      'encoding': encoding,
      'readCount': readCount,
      'addedCount': addedCount,
      'duplicateCount': duplicateCount,
      'possibleDuplicateCount': possibleDuplicateCount,
      'errorCount': errorCount,
      'classifiedCount': classifiedCount,
      'authorId': authorId.toJson(),
      'createdAt': createdAt.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  static StatementImportInclude include() {
    return StatementImportInclude._();
  }

  static StatementImportIncludeList includeList({
    _is.WhereExpressionBuilder<StatementImportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StatementImportTable>? orderBy,
    _is.OrderByListBuilder<StatementImportTable>? orderByList,
    StatementImportInclude? include,
  }) {
    return StatementImportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StatementImport.t),
      orderByList: orderByList?.call(StatementImport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StatementImportImpl extends StatementImport {
  _StatementImportImpl({
    int? id,
    required int accountId,
    required String format,
    required String fileName,
    required String fileHash,
    required String encoding,
    required int readCount,
    required int addedCount,
    required int duplicateCount,
    required int possibleDuplicateCount,
    required int errorCount,
    required int classifiedCount,
    required _is.UuidValue authorId,
    DateTime? createdAt,
    DateTime? cancelledAt,
  }) : super._(
         id: id,
         accountId: accountId,
         format: format,
         fileName: fileName,
         fileHash: fileHash,
         encoding: encoding,
         readCount: readCount,
         addedCount: addedCount,
         duplicateCount: duplicateCount,
         possibleDuplicateCount: possibleDuplicateCount,
         errorCount: errorCount,
         classifiedCount: classifiedCount,
         authorId: authorId,
         createdAt: createdAt,
         cancelledAt: cancelledAt,
       );

  /// Returns a shallow copy of this [StatementImport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StatementImport copyWith({
    Object? id = _Undefined,
    int? accountId,
    String? format,
    String? fileName,
    String? fileHash,
    String? encoding,
    int? readCount,
    int? addedCount,
    int? duplicateCount,
    int? possibleDuplicateCount,
    int? errorCount,
    int? classifiedCount,
    _is.UuidValue? authorId,
    DateTime? createdAt,
    Object? cancelledAt = _Undefined,
  }) {
    return StatementImport(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      format: format ?? this.format,
      fileName: fileName ?? this.fileName,
      fileHash: fileHash ?? this.fileHash,
      encoding: encoding ?? this.encoding,
      readCount: readCount ?? this.readCount,
      addedCount: addedCount ?? this.addedCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
      possibleDuplicateCount:
          possibleDuplicateCount ?? this.possibleDuplicateCount,
      errorCount: errorCount ?? this.errorCount,
      classifiedCount: classifiedCount ?? this.classifiedCount,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt is DateTime? ? cancelledAt : this.cancelledAt,
    );
  }
}

class StatementImportUpdateTable extends _is.UpdateTable<StatementImportTable> {
  StatementImportUpdateTable(super.table);

  _is.ColumnValue<int, int> accountId(int value) => _is.ColumnValue(
    table.accountId,
    value,
  );

  _is.ColumnValue<String, String> format(String value) => _is.ColumnValue(
    table.format,
    value,
  );

  _is.ColumnValue<String, String> fileName(String value) => _is.ColumnValue(
    table.fileName,
    value,
  );

  _is.ColumnValue<String, String> fileHash(String value) => _is.ColumnValue(
    table.fileHash,
    value,
  );

  _is.ColumnValue<String, String> encoding(String value) => _is.ColumnValue(
    table.encoding,
    value,
  );

  _is.ColumnValue<int, int> readCount(int value) => _is.ColumnValue(
    table.readCount,
    value,
  );

  _is.ColumnValue<int, int> addedCount(int value) => _is.ColumnValue(
    table.addedCount,
    value,
  );

  _is.ColumnValue<int, int> duplicateCount(int value) => _is.ColumnValue(
    table.duplicateCount,
    value,
  );

  _is.ColumnValue<int, int> possibleDuplicateCount(int value) =>
      _is.ColumnValue(
        table.possibleDuplicateCount,
        value,
      );

  _is.ColumnValue<int, int> errorCount(int value) => _is.ColumnValue(
    table.errorCount,
    value,
  );

  _is.ColumnValue<int, int> classifiedCount(int value) => _is.ColumnValue(
    table.classifiedCount,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authorId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.authorId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> cancelledAt(DateTime? value) =>
      _is.ColumnValue(
        table.cancelledAt,
        value,
      );
}

class StatementImportTable extends _is.Table<int?> {
  StatementImportTable({super.tableRelation}) : super(tableName: 'imports') {
    updateTable = StatementImportUpdateTable(this);
    accountId = _is.ColumnInt(
      'accountId',
      this,
    );
    format = _is.ColumnString(
      'format',
      this,
    );
    fileName = _is.ColumnString(
      'fileName',
      this,
    );
    fileHash = _is.ColumnString(
      'fileHash',
      this,
    );
    encoding = _is.ColumnString(
      'encoding',
      this,
    );
    readCount = _is.ColumnInt(
      'readCount',
      this,
    );
    addedCount = _is.ColumnInt(
      'addedCount',
      this,
    );
    duplicateCount = _is.ColumnInt(
      'duplicateCount',
      this,
    );
    possibleDuplicateCount = _is.ColumnInt(
      'possibleDuplicateCount',
      this,
    );
    errorCount = _is.ColumnInt(
      'errorCount',
      this,
    );
    classifiedCount = _is.ColumnInt(
      'classifiedCount',
      this,
    );
    authorId = _is.ColumnUuid(
      'authorId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    cancelledAt = _is.ColumnDateTime(
      'cancelledAt',
      this,
    );
  }

  late final StatementImportUpdateTable updateTable;

  late final _is.ColumnInt accountId;

  late final _is.ColumnString format;

  late final _is.ColumnString fileName;

  /// SHA-256 of the file, to warn when the same file is imported twice.
  late final _is.ColumnString fileHash;

  late final _is.ColumnString encoding;

  late final _is.ColumnInt readCount;

  late final _is.ColumnInt addedCount;

  late final _is.ColumnInt duplicateCount;

  late final _is.ColumnInt possibleDuplicateCount;

  late final _is.ColumnInt errorCount;

  late final _is.ColumnInt classifiedCount;

  late final _is.ColumnUuid authorId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime cancelledAt;

  @override
  List<_is.Column> get columns => [
    id,
    accountId,
    format,
    fileName,
    fileHash,
    encoding,
    readCount,
    addedCount,
    duplicateCount,
    possibleDuplicateCount,
    errorCount,
    classifiedCount,
    authorId,
    createdAt,
    cancelledAt,
  ];
}

class StatementImportInclude extends _is.IncludeObject {
  StatementImportInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StatementImport.t;
}

class StatementImportIncludeList extends _is.IncludeList {
  StatementImportIncludeList._({
    _is.WhereExpressionBuilder<StatementImportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StatementImport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StatementImport.t;
}

class StatementImportRepository {
  const StatementImportRepository._();

  /// Returns a list of [StatementImport]s matching the given query parameters.
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
  Future<List<StatementImport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StatementImportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StatementImportTable>? orderBy,
    _is.OrderByListBuilder<StatementImportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StatementImport>(
      where: where?.call(StatementImport.t),
      orderBy: orderBy?.call(StatementImport.t),
      orderByList: orderByList?.call(StatementImport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StatementImport] matching the given query parameters.
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
  Future<StatementImport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StatementImportTable>? where,
    int? offset,
    _is.OrderByBuilder<StatementImportTable>? orderBy,
    _is.OrderByListBuilder<StatementImportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StatementImport>(
      where: where?.call(StatementImport.t),
      orderBy: orderBy?.call(StatementImport.t),
      orderByList: orderByList?.call(StatementImport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StatementImport] by its [id] or null if no such row exists.
  Future<StatementImport?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StatementImport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StatementImport]s in the list and returns the inserted rows.
  ///
  /// The returned [StatementImport]s will have their `id` fields set.
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
  Future<List<StatementImport>> insert(
    _is.DatabaseSession session,
    List<StatementImport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StatementImport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StatementImport] and returns the inserted row.
  ///
  /// The returned [StatementImport] will have its `id` field set.
  Future<StatementImport> insertRow(
    _is.DatabaseSession session,
    StatementImport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StatementImport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StatementImport]s in the list and returns the resulting rows.
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
  /// The returned [StatementImport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StatementImport>> upsert(
    _is.DatabaseSession session,
    List<StatementImport> rows, {
    required _is.ColumnSelections<StatementImportTable> conflictColumns,
    _is.ColumnSelections<StatementImportTable>? updateColumns,
    _is.WhereExpressionBuilder<StatementImportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StatementImport>(
      rows,
      conflictColumns: conflictColumns(StatementImport.t),
      updateColumns: updateColumns?.call(StatementImport.t),
      updateWhere: updateWhere?.call(StatementImport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StatementImport] and returns the resulting row.
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
  /// The returned [StatementImport] will have its `id` field set.
  Future<StatementImport?> upsertRow(
    _is.DatabaseSession session,
    StatementImport row, {
    required _is.ColumnSelections<StatementImportTable> conflictColumns,
    _is.ColumnSelections<StatementImportTable>? updateColumns,
    _is.WhereExpressionBuilder<StatementImportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StatementImport>(
      row,
      conflictColumns: conflictColumns(StatementImport.t),
      updateColumns: updateColumns?.call(StatementImport.t),
      updateWhere: updateWhere?.call(StatementImport.t),
      transaction: transaction,
    );
  }

  /// Updates all [StatementImport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StatementImport>> update(
    _is.DatabaseSession session,
    List<StatementImport> rows, {
    _is.ColumnSelections<StatementImportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StatementImport>(
      rows,
      columns: columns?.call(StatementImport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StatementImport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StatementImport> updateRow(
    _is.DatabaseSession session,
    StatementImport row, {
    _is.ColumnSelections<StatementImportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StatementImport>(
      row,
      columns: columns?.call(StatementImport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StatementImport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StatementImport?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StatementImportUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StatementImport>(
      id,
      columnValues: columnValues(StatementImport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StatementImport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StatementImport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StatementImportUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<StatementImportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StatementImportTable>? orderBy,
    _is.OrderByListBuilder<StatementImportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StatementImport>(
      columnValues: columnValues(StatementImport.t.updateTable),
      where: where(StatementImport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StatementImport.t),
      orderByList: orderByList?.call(StatementImport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StatementImport]s in the list and returns the deleted rows.
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
  Future<List<StatementImport>> delete(
    _is.DatabaseSession session,
    List<StatementImport> rows, {
    _is.OrderByBuilder<StatementImportTable>? orderBy,
    _is.OrderByListBuilder<StatementImportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StatementImport>(
      rows,
      orderBy: orderBy?.call(StatementImport.t),
      orderByList: orderByList?.call(StatementImport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StatementImport].
  Future<StatementImport> deleteRow(
    _is.DatabaseSession session,
    StatementImport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StatementImport>(
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
  Future<List<StatementImport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StatementImportTable> where,
    _is.OrderByBuilder<StatementImportTable>? orderBy,
    _is.OrderByListBuilder<StatementImportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StatementImport>(
      where: where(StatementImport.t),
      orderBy: orderBy?.call(StatementImport.t),
      orderByList: orderByList?.call(StatementImport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StatementImportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StatementImport>(
      where: where?.call(StatementImport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StatementImport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StatementImportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StatementImport>(
      where: where(StatementImport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
