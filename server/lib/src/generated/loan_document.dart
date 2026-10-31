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

/// A document of a loan kept on the server: amortisation table, offer,
/// screenshot… Stored in the database (so in the backups), never sent
/// anywhere else.
abstract class LoanDocument
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LoanDocument._({
    this.id,
    required this.loanId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.uploadedBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LoanDocument({
    int? id,
    required int loanId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    _is.UuidValue? uploadedBy,
    DateTime? createdAt,
  }) = _LoanDocumentImpl;

  factory LoanDocument.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanDocument(
      id: jsonSerialization['id'] as int?,
      loanId: jsonSerialization['loanId'] as int,
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      uploadedBy: jsonSerialization['uploadedBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uploadedBy'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = LoanDocumentTable();

  static const db = LoanDocumentRepository._();

  @override
  int? id;

  int loanId;

  String fileName;

  String mimeType;

  int sizeBytes;

  _is.UuidValue? uploadedBy;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LoanDocument]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LoanDocument copyWith({
    int? id,
    int? loanId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    _is.UuidValue? uploadedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanDocument',
      if (id != null) 'id': id,
      'loanId': loanId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (uploadedBy != null) 'uploadedBy': uploadedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanDocument',
      if (id != null) 'id': id,
      'loanId': loanId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (uploadedBy != null) 'uploadedBy': uploadedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static LoanDocumentInclude include() {
    return LoanDocumentInclude._();
  }

  static LoanDocumentIncludeList includeList({
    _is.WhereExpressionBuilder<LoanDocumentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanDocumentTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentTable>? orderByList,
    LoanDocumentInclude? include,
  }) {
    return LoanDocumentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LoanDocument.t),
      orderByList: orderByList?.call(LoanDocument.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanDocumentImpl extends LoanDocument {
  _LoanDocumentImpl({
    int? id,
    required int loanId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    _is.UuidValue? uploadedBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         loanId: loanId,
         fileName: fileName,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         uploadedBy: uploadedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LoanDocument]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LoanDocument copyWith({
    Object? id = _Undefined,
    int? loanId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    Object? uploadedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return LoanDocument(
      id: id is int? ? id : this.id,
      loanId: loanId ?? this.loanId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      uploadedBy: uploadedBy is _is.UuidValue? ? uploadedBy : this.uploadedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LoanDocumentUpdateTable extends _is.UpdateTable<LoanDocumentTable> {
  LoanDocumentUpdateTable(super.table);

  _is.ColumnValue<int, int> loanId(int value) => _is.ColumnValue(
    table.loanId,
    value,
  );

  _is.ColumnValue<String, String> fileName(String value) => _is.ColumnValue(
    table.fileName,
    value,
  );

  _is.ColumnValue<String, String> mimeType(String value) => _is.ColumnValue(
    table.mimeType,
    value,
  );

  _is.ColumnValue<int, int> sizeBytes(int value) => _is.ColumnValue(
    table.sizeBytes,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uploadedBy(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uploadedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class LoanDocumentTable extends _is.Table<int?> {
  LoanDocumentTable({super.tableRelation})
    : super(tableName: 'loan_documents') {
    updateTable = LoanDocumentUpdateTable(this);
    loanId = _is.ColumnInt(
      'loanId',
      this,
    );
    fileName = _is.ColumnString(
      'fileName',
      this,
    );
    mimeType = _is.ColumnString(
      'mimeType',
      this,
    );
    sizeBytes = _is.ColumnInt(
      'sizeBytes',
      this,
    );
    uploadedBy = _is.ColumnUuid(
      'uploadedBy',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final LoanDocumentUpdateTable updateTable;

  late final _is.ColumnInt loanId;

  late final _is.ColumnString fileName;

  late final _is.ColumnString mimeType;

  late final _is.ColumnInt sizeBytes;

  late final _is.ColumnUuid uploadedBy;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    loanId,
    fileName,
    mimeType,
    sizeBytes,
    uploadedBy,
    createdAt,
  ];
}

class LoanDocumentInclude extends _is.IncludeObject {
  LoanDocumentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LoanDocument.t;
}

class LoanDocumentIncludeList extends _is.IncludeList {
  LoanDocumentIncludeList._({
    _is.WhereExpressionBuilder<LoanDocumentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LoanDocument.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LoanDocument.t;
}

class LoanDocumentRepository {
  const LoanDocumentRepository._();

  /// Returns a list of [LoanDocument]s matching the given query parameters.
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
  Future<List<LoanDocument>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanDocumentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanDocumentTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LoanDocument>(
      where: where?.call(LoanDocument.t),
      orderBy: orderBy?.call(LoanDocument.t),
      orderByList: orderByList?.call(LoanDocument.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LoanDocument] matching the given query parameters.
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
  Future<LoanDocument?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanDocumentTable>? where,
    int? offset,
    _is.OrderByBuilder<LoanDocumentTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LoanDocument>(
      where: where?.call(LoanDocument.t),
      orderBy: orderBy?.call(LoanDocument.t),
      orderByList: orderByList?.call(LoanDocument.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LoanDocument] by its [id] or null if no such row exists.
  Future<LoanDocument?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LoanDocument>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LoanDocument]s in the list and returns the inserted rows.
  ///
  /// The returned [LoanDocument]s will have their `id` fields set.
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
  Future<List<LoanDocument>> insert(
    _is.DatabaseSession session,
    List<LoanDocument> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LoanDocument>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LoanDocument] and returns the inserted row.
  ///
  /// The returned [LoanDocument] will have its `id` field set.
  Future<LoanDocument> insertRow(
    _is.DatabaseSession session,
    LoanDocument row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LoanDocument>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LoanDocument]s in the list and returns the resulting rows.
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
  /// The returned [LoanDocument]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LoanDocument>> upsert(
    _is.DatabaseSession session,
    List<LoanDocument> rows, {
    required _is.ColumnSelections<LoanDocumentTable> conflictColumns,
    _is.ColumnSelections<LoanDocumentTable>? updateColumns,
    _is.WhereExpressionBuilder<LoanDocumentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LoanDocument>(
      rows,
      conflictColumns: conflictColumns(LoanDocument.t),
      updateColumns: updateColumns?.call(LoanDocument.t),
      updateWhere: updateWhere?.call(LoanDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LoanDocument] and returns the resulting row.
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
  /// The returned [LoanDocument] will have its `id` field set.
  Future<LoanDocument?> upsertRow(
    _is.DatabaseSession session,
    LoanDocument row, {
    required _is.ColumnSelections<LoanDocumentTable> conflictColumns,
    _is.ColumnSelections<LoanDocumentTable>? updateColumns,
    _is.WhereExpressionBuilder<LoanDocumentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LoanDocument>(
      row,
      conflictColumns: conflictColumns(LoanDocument.t),
      updateColumns: updateColumns?.call(LoanDocument.t),
      updateWhere: updateWhere?.call(LoanDocument.t),
      transaction: transaction,
    );
  }

  /// Updates all [LoanDocument]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LoanDocument>> update(
    _is.DatabaseSession session,
    List<LoanDocument> rows, {
    _is.ColumnSelections<LoanDocumentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LoanDocument>(
      rows,
      columns: columns?.call(LoanDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LoanDocument]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LoanDocument> updateRow(
    _is.DatabaseSession session,
    LoanDocument row, {
    _is.ColumnSelections<LoanDocumentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LoanDocument>(
      row,
      columns: columns?.call(LoanDocument.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LoanDocument] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LoanDocument?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LoanDocumentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LoanDocument>(
      id,
      columnValues: columnValues(LoanDocument.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LoanDocument]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LoanDocument>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LoanDocumentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LoanDocumentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanDocumentTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LoanDocument>(
      columnValues: columnValues(LoanDocument.t.updateTable),
      where: where(LoanDocument.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LoanDocument.t),
      orderByList: orderByList?.call(LoanDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LoanDocument]s in the list and returns the deleted rows.
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
  Future<List<LoanDocument>> delete(
    _is.DatabaseSession session,
    List<LoanDocument> rows, {
    _is.OrderByBuilder<LoanDocumentTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LoanDocument>(
      rows,
      orderBy: orderBy?.call(LoanDocument.t),
      orderByList: orderByList?.call(LoanDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LoanDocument].
  Future<LoanDocument> deleteRow(
    _is.DatabaseSession session,
    LoanDocument row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LoanDocument>(
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
  Future<List<LoanDocument>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LoanDocumentTable> where,
    _is.OrderByBuilder<LoanDocumentTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LoanDocument>(
      where: where(LoanDocument.t),
      orderBy: orderBy?.call(LoanDocument.t),
      orderByList: orderByList?.call(LoanDocument.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanDocumentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LoanDocument>(
      where: where?.call(LoanDocument.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LoanDocument] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LoanDocumentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LoanDocument>(
      where: where(LoanDocument.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
