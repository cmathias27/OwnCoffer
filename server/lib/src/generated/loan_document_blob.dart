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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;

/// Content of a loan document, apart so that listing documents does not
/// read the files.
abstract class LoanDocumentBlob
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LoanDocumentBlob._({
    this.id,
    required this.documentId,
    required this.content,
  });

  factory LoanDocumentBlob({
    int? id,
    required int documentId,
    required _idt.ByteData content,
  }) = _LoanDocumentBlobImpl;

  factory LoanDocumentBlob.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanDocumentBlob(
      id: jsonSerialization['id'] as int?,
      documentId: jsonSerialization['documentId'] as int,
      content: _is.ByteDataJsonExtension.fromJson(jsonSerialization['content']),
    );
  }

  static final t = LoanDocumentBlobTable();

  static const db = LoanDocumentBlobRepository._();

  @override
  int? id;

  int documentId;

  _idt.ByteData content;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LoanDocumentBlob]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LoanDocumentBlob copyWith({
    int? id,
    int? documentId,
    _idt.ByteData? content,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanDocumentBlob',
      if (id != null) 'id': id,
      'documentId': documentId,
      'content': content.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanDocumentBlob',
      if (id != null) 'id': id,
      'documentId': documentId,
      'content': content.toJson(),
    };
  }

  static LoanDocumentBlobInclude include() {
    return LoanDocumentBlobInclude._();
  }

  static LoanDocumentBlobIncludeList includeList({
    _is.WhereExpressionBuilder<LoanDocumentBlobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanDocumentBlobTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentBlobTable>? orderByList,
    LoanDocumentBlobInclude? include,
  }) {
    return LoanDocumentBlobIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LoanDocumentBlob.t),
      orderByList: orderByList?.call(LoanDocumentBlob.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanDocumentBlobImpl extends LoanDocumentBlob {
  _LoanDocumentBlobImpl({
    int? id,
    required int documentId,
    required _idt.ByteData content,
  }) : super._(
         id: id,
         documentId: documentId,
         content: content,
       );

  /// Returns a shallow copy of this [LoanDocumentBlob]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LoanDocumentBlob copyWith({
    Object? id = _Undefined,
    int? documentId,
    _idt.ByteData? content,
  }) {
    return LoanDocumentBlob(
      id: id is int? ? id : this.id,
      documentId: documentId ?? this.documentId,
      content: content ?? this.content.clone(),
    );
  }
}

class LoanDocumentBlobUpdateTable
    extends _is.UpdateTable<LoanDocumentBlobTable> {
  LoanDocumentBlobUpdateTable(super.table);

  _is.ColumnValue<int, int> documentId(int value) => _is.ColumnValue(
    table.documentId,
    value,
  );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> content(_idt.ByteData value) =>
      _is.ColumnValue(
        table.content,
        value,
      );
}

class LoanDocumentBlobTable extends _is.Table<int?> {
  LoanDocumentBlobTable({super.tableRelation})
    : super(tableName: 'loan_document_blobs') {
    updateTable = LoanDocumentBlobUpdateTable(this);
    documentId = _is.ColumnInt(
      'documentId',
      this,
    );
    content = _is.ColumnByteData(
      'content',
      this,
    );
  }

  late final LoanDocumentBlobUpdateTable updateTable;

  late final _is.ColumnInt documentId;

  late final _is.ColumnByteData content;

  @override
  List<_is.Column> get columns => [
    id,
    documentId,
    content,
  ];
}

class LoanDocumentBlobInclude extends _is.IncludeObject {
  LoanDocumentBlobInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LoanDocumentBlob.t;
}

class LoanDocumentBlobIncludeList extends _is.IncludeList {
  LoanDocumentBlobIncludeList._({
    _is.WhereExpressionBuilder<LoanDocumentBlobTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LoanDocumentBlob.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LoanDocumentBlob.t;
}

class LoanDocumentBlobRepository {
  const LoanDocumentBlobRepository._();

  /// Returns a list of [LoanDocumentBlob]s matching the given query parameters.
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
  Future<List<LoanDocumentBlob>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanDocumentBlobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanDocumentBlobTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentBlobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LoanDocumentBlob>(
      where: where?.call(LoanDocumentBlob.t),
      orderBy: orderBy?.call(LoanDocumentBlob.t),
      orderByList: orderByList?.call(LoanDocumentBlob.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LoanDocumentBlob] matching the given query parameters.
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
  Future<LoanDocumentBlob?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanDocumentBlobTable>? where,
    int? offset,
    _is.OrderByBuilder<LoanDocumentBlobTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentBlobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LoanDocumentBlob>(
      where: where?.call(LoanDocumentBlob.t),
      orderBy: orderBy?.call(LoanDocumentBlob.t),
      orderByList: orderByList?.call(LoanDocumentBlob.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LoanDocumentBlob] by its [id] or null if no such row exists.
  Future<LoanDocumentBlob?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LoanDocumentBlob>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LoanDocumentBlob]s in the list and returns the inserted rows.
  ///
  /// The returned [LoanDocumentBlob]s will have their `id` fields set.
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
  Future<List<LoanDocumentBlob>> insert(
    _is.DatabaseSession session,
    List<LoanDocumentBlob> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LoanDocumentBlob>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LoanDocumentBlob] and returns the inserted row.
  ///
  /// The returned [LoanDocumentBlob] will have its `id` field set.
  Future<LoanDocumentBlob> insertRow(
    _is.DatabaseSession session,
    LoanDocumentBlob row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LoanDocumentBlob>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LoanDocumentBlob]s in the list and returns the resulting rows.
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
  /// The returned [LoanDocumentBlob]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LoanDocumentBlob>> upsert(
    _is.DatabaseSession session,
    List<LoanDocumentBlob> rows, {
    required _is.ColumnSelections<LoanDocumentBlobTable> conflictColumns,
    _is.ColumnSelections<LoanDocumentBlobTable>? updateColumns,
    _is.WhereExpressionBuilder<LoanDocumentBlobTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LoanDocumentBlob>(
      rows,
      conflictColumns: conflictColumns(LoanDocumentBlob.t),
      updateColumns: updateColumns?.call(LoanDocumentBlob.t),
      updateWhere: updateWhere?.call(LoanDocumentBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LoanDocumentBlob] and returns the resulting row.
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
  /// The returned [LoanDocumentBlob] will have its `id` field set.
  Future<LoanDocumentBlob?> upsertRow(
    _is.DatabaseSession session,
    LoanDocumentBlob row, {
    required _is.ColumnSelections<LoanDocumentBlobTable> conflictColumns,
    _is.ColumnSelections<LoanDocumentBlobTable>? updateColumns,
    _is.WhereExpressionBuilder<LoanDocumentBlobTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LoanDocumentBlob>(
      row,
      conflictColumns: conflictColumns(LoanDocumentBlob.t),
      updateColumns: updateColumns?.call(LoanDocumentBlob.t),
      updateWhere: updateWhere?.call(LoanDocumentBlob.t),
      transaction: transaction,
    );
  }

  /// Updates all [LoanDocumentBlob]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LoanDocumentBlob>> update(
    _is.DatabaseSession session,
    List<LoanDocumentBlob> rows, {
    _is.ColumnSelections<LoanDocumentBlobTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LoanDocumentBlob>(
      rows,
      columns: columns?.call(LoanDocumentBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LoanDocumentBlob]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LoanDocumentBlob> updateRow(
    _is.DatabaseSession session,
    LoanDocumentBlob row, {
    _is.ColumnSelections<LoanDocumentBlobTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LoanDocumentBlob>(
      row,
      columns: columns?.call(LoanDocumentBlob.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LoanDocumentBlob] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LoanDocumentBlob?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LoanDocumentBlobUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LoanDocumentBlob>(
      id,
      columnValues: columnValues(LoanDocumentBlob.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LoanDocumentBlob]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LoanDocumentBlob>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LoanDocumentBlobUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<LoanDocumentBlobTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanDocumentBlobTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentBlobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LoanDocumentBlob>(
      columnValues: columnValues(LoanDocumentBlob.t.updateTable),
      where: where(LoanDocumentBlob.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LoanDocumentBlob.t),
      orderByList: orderByList?.call(LoanDocumentBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LoanDocumentBlob]s in the list and returns the deleted rows.
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
  Future<List<LoanDocumentBlob>> delete(
    _is.DatabaseSession session,
    List<LoanDocumentBlob> rows, {
    _is.OrderByBuilder<LoanDocumentBlobTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentBlobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LoanDocumentBlob>(
      rows,
      orderBy: orderBy?.call(LoanDocumentBlob.t),
      orderByList: orderByList?.call(LoanDocumentBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LoanDocumentBlob].
  Future<LoanDocumentBlob> deleteRow(
    _is.DatabaseSession session,
    LoanDocumentBlob row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LoanDocumentBlob>(
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
  Future<List<LoanDocumentBlob>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LoanDocumentBlobTable> where,
    _is.OrderByBuilder<LoanDocumentBlobTable>? orderBy,
    _is.OrderByListBuilder<LoanDocumentBlobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LoanDocumentBlob>(
      where: where(LoanDocumentBlob.t),
      orderBy: orderBy?.call(LoanDocumentBlob.t),
      orderByList: orderByList?.call(LoanDocumentBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanDocumentBlobTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LoanDocumentBlob>(
      where: where?.call(LoanDocumentBlob.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LoanDocumentBlob] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LoanDocumentBlobTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LoanDocumentBlob>(
      where: where(LoanDocumentBlob.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
