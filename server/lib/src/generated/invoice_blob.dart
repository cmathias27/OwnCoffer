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

/// Content of an invoice, apart so that listing invoices does not read the
/// files.
abstract class InvoiceBlob
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  InvoiceBlob._({
    this.id,
    required this.invoiceId,
    required this.content,
  });

  factory InvoiceBlob({
    int? id,
    required int invoiceId,
    required _idt.ByteData content,
  }) = _InvoiceBlobImpl;

  factory InvoiceBlob.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvoiceBlob(
      id: jsonSerialization['id'] as int?,
      invoiceId: jsonSerialization['invoiceId'] as int,
      content: _is.ByteDataJsonExtension.fromJson(jsonSerialization['content']),
    );
  }

  static final t = InvoiceBlobTable();

  static const db = InvoiceBlobRepository._();

  @override
  int? id;

  int invoiceId;

  _idt.ByteData content;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [InvoiceBlob]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InvoiceBlob copyWith({
    int? id,
    int? invoiceId,
    _idt.ByteData? content,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvoiceBlob',
      if (id != null) 'id': id,
      'invoiceId': invoiceId,
      'content': content.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvoiceBlob',
      if (id != null) 'id': id,
      'invoiceId': invoiceId,
      'content': content.toJson(),
    };
  }

  static InvoiceBlobInclude include() {
    return InvoiceBlobInclude._();
  }

  static InvoiceBlobIncludeList includeList({
    _is.WhereExpressionBuilder<InvoiceBlobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvoiceBlobTable>? orderBy,
    _is.OrderByListBuilder<InvoiceBlobTable>? orderByList,
    InvoiceBlobInclude? include,
  }) {
    return InvoiceBlobIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InvoiceBlob.t),
      orderByList: orderByList?.call(InvoiceBlob.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InvoiceBlobImpl extends InvoiceBlob {
  _InvoiceBlobImpl({
    int? id,
    required int invoiceId,
    required _idt.ByteData content,
  }) : super._(
         id: id,
         invoiceId: invoiceId,
         content: content,
       );

  /// Returns a shallow copy of this [InvoiceBlob]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InvoiceBlob copyWith({
    Object? id = _Undefined,
    int? invoiceId,
    _idt.ByteData? content,
  }) {
    return InvoiceBlob(
      id: id is int? ? id : this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      content: content ?? this.content.clone(),
    );
  }
}

class InvoiceBlobUpdateTable extends _is.UpdateTable<InvoiceBlobTable> {
  InvoiceBlobUpdateTable(super.table);

  _is.ColumnValue<int, int> invoiceId(int value) => _is.ColumnValue(
    table.invoiceId,
    value,
  );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> content(_idt.ByteData value) =>
      _is.ColumnValue(
        table.content,
        value,
      );
}

class InvoiceBlobTable extends _is.Table<int?> {
  InvoiceBlobTable({super.tableRelation}) : super(tableName: 'invoice_blobs') {
    updateTable = InvoiceBlobUpdateTable(this);
    invoiceId = _is.ColumnInt(
      'invoiceId',
      this,
    );
    content = _is.ColumnByteData(
      'content',
      this,
    );
  }

  late final InvoiceBlobUpdateTable updateTable;

  late final _is.ColumnInt invoiceId;

  late final _is.ColumnByteData content;

  @override
  List<_is.Column> get columns => [
    id,
    invoiceId,
    content,
  ];
}

class InvoiceBlobInclude extends _is.IncludeObject {
  InvoiceBlobInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => InvoiceBlob.t;
}

class InvoiceBlobIncludeList extends _is.IncludeList {
  InvoiceBlobIncludeList._({
    _is.WhereExpressionBuilder<InvoiceBlobTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(InvoiceBlob.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => InvoiceBlob.t;
}

class InvoiceBlobRepository {
  const InvoiceBlobRepository._();

  /// Returns a list of [InvoiceBlob]s matching the given query parameters.
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
  Future<List<InvoiceBlob>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvoiceBlobTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvoiceBlobTable>? orderBy,
    _is.OrderByListBuilder<InvoiceBlobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<InvoiceBlob>(
      where: where?.call(InvoiceBlob.t),
      orderBy: orderBy?.call(InvoiceBlob.t),
      orderByList: orderByList?.call(InvoiceBlob.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [InvoiceBlob] matching the given query parameters.
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
  Future<InvoiceBlob?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvoiceBlobTable>? where,
    int? offset,
    _is.OrderByBuilder<InvoiceBlobTable>? orderBy,
    _is.OrderByListBuilder<InvoiceBlobTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<InvoiceBlob>(
      where: where?.call(InvoiceBlob.t),
      orderBy: orderBy?.call(InvoiceBlob.t),
      orderByList: orderByList?.call(InvoiceBlob.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [InvoiceBlob] by its [id] or null if no such row exists.
  Future<InvoiceBlob?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<InvoiceBlob>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [InvoiceBlob]s in the list and returns the inserted rows.
  ///
  /// The returned [InvoiceBlob]s will have their `id` fields set.
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
  Future<List<InvoiceBlob>> insert(
    _is.DatabaseSession session,
    List<InvoiceBlob> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<InvoiceBlob>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [InvoiceBlob] and returns the inserted row.
  ///
  /// The returned [InvoiceBlob] will have its `id` field set.
  Future<InvoiceBlob> insertRow(
    _is.DatabaseSession session,
    InvoiceBlob row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<InvoiceBlob>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [InvoiceBlob]s in the list and returns the resulting rows.
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
  /// The returned [InvoiceBlob]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InvoiceBlob>> upsert(
    _is.DatabaseSession session,
    List<InvoiceBlob> rows, {
    required _is.ColumnSelections<InvoiceBlobTable> conflictColumns,
    _is.ColumnSelections<InvoiceBlobTable>? updateColumns,
    _is.WhereExpressionBuilder<InvoiceBlobTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<InvoiceBlob>(
      rows,
      conflictColumns: conflictColumns(InvoiceBlob.t),
      updateColumns: updateColumns?.call(InvoiceBlob.t),
      updateWhere: updateWhere?.call(InvoiceBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [InvoiceBlob] and returns the resulting row.
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
  /// The returned [InvoiceBlob] will have its `id` field set.
  Future<InvoiceBlob?> upsertRow(
    _is.DatabaseSession session,
    InvoiceBlob row, {
    required _is.ColumnSelections<InvoiceBlobTable> conflictColumns,
    _is.ColumnSelections<InvoiceBlobTable>? updateColumns,
    _is.WhereExpressionBuilder<InvoiceBlobTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<InvoiceBlob>(
      row,
      conflictColumns: conflictColumns(InvoiceBlob.t),
      updateColumns: updateColumns?.call(InvoiceBlob.t),
      updateWhere: updateWhere?.call(InvoiceBlob.t),
      transaction: transaction,
    );
  }

  /// Updates all [InvoiceBlob]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InvoiceBlob>> update(
    _is.DatabaseSession session,
    List<InvoiceBlob> rows, {
    _is.ColumnSelections<InvoiceBlobTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<InvoiceBlob>(
      rows,
      columns: columns?.call(InvoiceBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [InvoiceBlob]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<InvoiceBlob> updateRow(
    _is.DatabaseSession session,
    InvoiceBlob row, {
    _is.ColumnSelections<InvoiceBlobTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<InvoiceBlob>(
      row,
      columns: columns?.call(InvoiceBlob.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InvoiceBlob] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<InvoiceBlob?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<InvoiceBlobUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<InvoiceBlob>(
      id,
      columnValues: columnValues(InvoiceBlob.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [InvoiceBlob]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InvoiceBlob>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<InvoiceBlobUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<InvoiceBlobTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvoiceBlobTable>? orderBy,
    _is.OrderByListBuilder<InvoiceBlobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<InvoiceBlob>(
      columnValues: columnValues(InvoiceBlob.t.updateTable),
      where: where(InvoiceBlob.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InvoiceBlob.t),
      orderByList: orderByList?.call(InvoiceBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [InvoiceBlob]s in the list and returns the deleted rows.
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
  Future<List<InvoiceBlob>> delete(
    _is.DatabaseSession session,
    List<InvoiceBlob> rows, {
    _is.OrderByBuilder<InvoiceBlobTable>? orderBy,
    _is.OrderByListBuilder<InvoiceBlobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<InvoiceBlob>(
      rows,
      orderBy: orderBy?.call(InvoiceBlob.t),
      orderByList: orderByList?.call(InvoiceBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [InvoiceBlob].
  Future<InvoiceBlob> deleteRow(
    _is.DatabaseSession session,
    InvoiceBlob row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<InvoiceBlob>(
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
  Future<List<InvoiceBlob>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<InvoiceBlobTable> where,
    _is.OrderByBuilder<InvoiceBlobTable>? orderBy,
    _is.OrderByListBuilder<InvoiceBlobTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<InvoiceBlob>(
      where: where(InvoiceBlob.t),
      orderBy: orderBy?.call(InvoiceBlob.t),
      orderByList: orderByList?.call(InvoiceBlob.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvoiceBlobTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<InvoiceBlob>(
      where: where?.call(InvoiceBlob.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [InvoiceBlob] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<InvoiceBlobTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<InvoiceBlob>(
      where: where(InvoiceBlob.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
