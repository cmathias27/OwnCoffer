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

/// An invoice or receipt kept on the server: PDF or photo, attached to an
/// operation (or waiting to be, `transactionId` null). Stored in the
/// database (so in the backups), never sent anywhere unless a member emails
/// it.
abstract class Invoice
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Invoice._({
    this.id,
    required this.groupId,
    this.transactionId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.label,
    this.warrantyUntil,
    this.hintAmountCents,
    this.hintDate,
    this.hintMerchant,
    this.uploadedBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Invoice({
    int? id,
    required int groupId,
    int? transactionId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? label,
    DateTime? warrantyUntil,
    int? hintAmountCents,
    DateTime? hintDate,
    String? hintMerchant,
    _is.UuidValue? uploadedBy,
    DateTime? createdAt,
  }) = _InvoiceImpl;

  factory Invoice.fromJson(Map<String, dynamic> jsonSerialization) {
    return Invoice(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      transactionId: jsonSerialization['transactionId'] as int?,
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      label: jsonSerialization['label'] as String?,
      warrantyUntil: jsonSerialization['warrantyUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['warrantyUntil'],
            ),
      hintAmountCents: jsonSerialization['hintAmountCents'] as int?,
      hintDate: jsonSerialization['hintDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['hintDate']),
      hintMerchant: jsonSerialization['hintMerchant'] as String?,
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

  static final t = InvoiceTable();

  static const db = InvoiceRepository._();

  @override
  int? id;

  int groupId;

  /// The operation it justifies; null while it waits to be attached.
  /// Deleted with the operation (when deleted for good, not when in the
  /// trash): never left visible to the whole group when it was only seen
  /// through a restricted account.
  int? transactionId;

  /// Name of the file as it was sent.
  String fileName;

  String mimeType;

  int sizeBytes;

  /// What it is for (e.g. `Lave-linge`), part of its name.
  String? label;

  /// End of the warranty: a reminder comes a month before.
  DateTime? warrantyUntil;

  /// What is known of an invoice waiting for its operation, to propose
  /// the right one: total paid (positive cents), date, merchant.
  int? hintAmountCents;

  DateTime? hintDate;

  String? hintMerchant;

  _is.UuidValue? uploadedBy;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Invoice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Invoice copyWith({
    int? id,
    int? groupId,
    int? transactionId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? label,
    DateTime? warrantyUntil,
    int? hintAmountCents,
    DateTime? hintDate,
    String? hintMerchant,
    _is.UuidValue? uploadedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Invoice',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (transactionId != null) 'transactionId': transactionId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (label != null) 'label': label,
      if (warrantyUntil != null) 'warrantyUntil': warrantyUntil?.toJson(),
      if (hintAmountCents != null) 'hintAmountCents': hintAmountCents,
      if (hintDate != null) 'hintDate': hintDate?.toJson(),
      if (hintMerchant != null) 'hintMerchant': hintMerchant,
      if (uploadedBy != null) 'uploadedBy': uploadedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Invoice',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (transactionId != null) 'transactionId': transactionId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (label != null) 'label': label,
      if (warrantyUntil != null) 'warrantyUntil': warrantyUntil?.toJson(),
      if (hintAmountCents != null) 'hintAmountCents': hintAmountCents,
      if (hintDate != null) 'hintDate': hintDate?.toJson(),
      if (hintMerchant != null) 'hintMerchant': hintMerchant,
      if (uploadedBy != null) 'uploadedBy': uploadedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static InvoiceInclude include() {
    return InvoiceInclude._();
  }

  static InvoiceIncludeList includeList({
    _is.WhereExpressionBuilder<InvoiceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvoiceTable>? orderBy,
    _is.OrderByListBuilder<InvoiceTable>? orderByList,
    InvoiceInclude? include,
  }) {
    return InvoiceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Invoice.t),
      orderByList: orderByList?.call(Invoice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InvoiceImpl extends Invoice {
  _InvoiceImpl({
    int? id,
    required int groupId,
    int? transactionId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? label,
    DateTime? warrantyUntil,
    int? hintAmountCents,
    DateTime? hintDate,
    String? hintMerchant,
    _is.UuidValue? uploadedBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         transactionId: transactionId,
         fileName: fileName,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         label: label,
         warrantyUntil: warrantyUntil,
         hintAmountCents: hintAmountCents,
         hintDate: hintDate,
         hintMerchant: hintMerchant,
         uploadedBy: uploadedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Invoice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Invoice copyWith({
    Object? id = _Undefined,
    int? groupId,
    Object? transactionId = _Undefined,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    Object? label = _Undefined,
    Object? warrantyUntil = _Undefined,
    Object? hintAmountCents = _Undefined,
    Object? hintDate = _Undefined,
    Object? hintMerchant = _Undefined,
    Object? uploadedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return Invoice(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      transactionId: transactionId is int? ? transactionId : this.transactionId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      label: label is String? ? label : this.label,
      warrantyUntil: warrantyUntil is DateTime?
          ? warrantyUntil
          : this.warrantyUntil,
      hintAmountCents: hintAmountCents is int?
          ? hintAmountCents
          : this.hintAmountCents,
      hintDate: hintDate is DateTime? ? hintDate : this.hintDate,
      hintMerchant: hintMerchant is String? ? hintMerchant : this.hintMerchant,
      uploadedBy: uploadedBy is _is.UuidValue? ? uploadedBy : this.uploadedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class InvoiceUpdateTable extends _is.UpdateTable<InvoiceTable> {
  InvoiceUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<int, int> transactionId(int? value) => _is.ColumnValue(
    table.transactionId,
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

  _is.ColumnValue<String, String> label(String? value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> warrantyUntil(DateTime? value) =>
      _is.ColumnValue(
        table.warrantyUntil,
        value,
      );

  _is.ColumnValue<int, int> hintAmountCents(int? value) => _is.ColumnValue(
    table.hintAmountCents,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> hintDate(DateTime? value) =>
      _is.ColumnValue(
        table.hintDate,
        value,
      );

  _is.ColumnValue<String, String> hintMerchant(String? value) =>
      _is.ColumnValue(
        table.hintMerchant,
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

class InvoiceTable extends _is.Table<int?> {
  InvoiceTable({super.tableRelation}) : super(tableName: 'invoices') {
    updateTable = InvoiceUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    transactionId = _is.ColumnInt(
      'transactionId',
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
    label = _is.ColumnString(
      'label',
      this,
    );
    warrantyUntil = _is.ColumnDateTime(
      'warrantyUntil',
      this,
    );
    hintAmountCents = _is.ColumnInt(
      'hintAmountCents',
      this,
    );
    hintDate = _is.ColumnDateTime(
      'hintDate',
      this,
    );
    hintMerchant = _is.ColumnString(
      'hintMerchant',
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

  late final InvoiceUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  /// The operation it justifies; null while it waits to be attached.
  /// Deleted with the operation (when deleted for good, not when in the
  /// trash): never left visible to the whole group when it was only seen
  /// through a restricted account.
  late final _is.ColumnInt transactionId;

  /// Name of the file as it was sent.
  late final _is.ColumnString fileName;

  late final _is.ColumnString mimeType;

  late final _is.ColumnInt sizeBytes;

  /// What it is for (e.g. `Lave-linge`), part of its name.
  late final _is.ColumnString label;

  /// End of the warranty: a reminder comes a month before.
  late final _is.ColumnDateTime warrantyUntil;

  /// What is known of an invoice waiting for its operation, to propose
  /// the right one: total paid (positive cents), date, merchant.
  late final _is.ColumnInt hintAmountCents;

  late final _is.ColumnDateTime hintDate;

  late final _is.ColumnString hintMerchant;

  late final _is.ColumnUuid uploadedBy;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    transactionId,
    fileName,
    mimeType,
    sizeBytes,
    label,
    warrantyUntil,
    hintAmountCents,
    hintDate,
    hintMerchant,
    uploadedBy,
    createdAt,
  ];
}

class InvoiceInclude extends _is.IncludeObject {
  InvoiceInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Invoice.t;
}

class InvoiceIncludeList extends _is.IncludeList {
  InvoiceIncludeList._({
    _is.WhereExpressionBuilder<InvoiceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Invoice.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Invoice.t;
}

class InvoiceRepository {
  const InvoiceRepository._();

  /// Returns a list of [Invoice]s matching the given query parameters.
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
  Future<List<Invoice>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvoiceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvoiceTable>? orderBy,
    _is.OrderByListBuilder<InvoiceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Invoice>(
      where: where?.call(Invoice.t),
      orderBy: orderBy?.call(Invoice.t),
      orderByList: orderByList?.call(Invoice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Invoice] matching the given query parameters.
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
  Future<Invoice?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvoiceTable>? where,
    int? offset,
    _is.OrderByBuilder<InvoiceTable>? orderBy,
    _is.OrderByListBuilder<InvoiceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Invoice>(
      where: where?.call(Invoice.t),
      orderBy: orderBy?.call(Invoice.t),
      orderByList: orderByList?.call(Invoice.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Invoice] by its [id] or null if no such row exists.
  Future<Invoice?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Invoice>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Invoice]s in the list and returns the inserted rows.
  ///
  /// The returned [Invoice]s will have their `id` fields set.
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
  Future<List<Invoice>> insert(
    _is.DatabaseSession session,
    List<Invoice> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Invoice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Invoice] and returns the inserted row.
  ///
  /// The returned [Invoice] will have its `id` field set.
  Future<Invoice> insertRow(
    _is.DatabaseSession session,
    Invoice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Invoice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Invoice]s in the list and returns the resulting rows.
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
  /// The returned [Invoice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Invoice>> upsert(
    _is.DatabaseSession session,
    List<Invoice> rows, {
    required _is.ColumnSelections<InvoiceTable> conflictColumns,
    _is.ColumnSelections<InvoiceTable>? updateColumns,
    _is.WhereExpressionBuilder<InvoiceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Invoice>(
      rows,
      conflictColumns: conflictColumns(Invoice.t),
      updateColumns: updateColumns?.call(Invoice.t),
      updateWhere: updateWhere?.call(Invoice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Invoice] and returns the resulting row.
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
  /// The returned [Invoice] will have its `id` field set.
  Future<Invoice?> upsertRow(
    _is.DatabaseSession session,
    Invoice row, {
    required _is.ColumnSelections<InvoiceTable> conflictColumns,
    _is.ColumnSelections<InvoiceTable>? updateColumns,
    _is.WhereExpressionBuilder<InvoiceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Invoice>(
      row,
      conflictColumns: conflictColumns(Invoice.t),
      updateColumns: updateColumns?.call(Invoice.t),
      updateWhere: updateWhere?.call(Invoice.t),
      transaction: transaction,
    );
  }

  /// Updates all [Invoice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Invoice>> update(
    _is.DatabaseSession session,
    List<Invoice> rows, {
    _is.ColumnSelections<InvoiceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Invoice>(
      rows,
      columns: columns?.call(Invoice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Invoice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Invoice> updateRow(
    _is.DatabaseSession session,
    Invoice row, {
    _is.ColumnSelections<InvoiceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Invoice>(
      row,
      columns: columns?.call(Invoice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Invoice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Invoice?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<InvoiceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Invoice>(
      id,
      columnValues: columnValues(Invoice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Invoice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Invoice>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<InvoiceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<InvoiceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvoiceTable>? orderBy,
    _is.OrderByListBuilder<InvoiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Invoice>(
      columnValues: columnValues(Invoice.t.updateTable),
      where: where(Invoice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Invoice.t),
      orderByList: orderByList?.call(Invoice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Invoice]s in the list and returns the deleted rows.
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
  Future<List<Invoice>> delete(
    _is.DatabaseSession session,
    List<Invoice> rows, {
    _is.OrderByBuilder<InvoiceTable>? orderBy,
    _is.OrderByListBuilder<InvoiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Invoice>(
      rows,
      orderBy: orderBy?.call(Invoice.t),
      orderByList: orderByList?.call(Invoice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Invoice].
  Future<Invoice> deleteRow(
    _is.DatabaseSession session,
    Invoice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Invoice>(
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
  Future<List<Invoice>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<InvoiceTable> where,
    _is.OrderByBuilder<InvoiceTable>? orderBy,
    _is.OrderByListBuilder<InvoiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Invoice>(
      where: where(Invoice.t),
      orderBy: orderBy?.call(Invoice.t),
      orderByList: orderByList?.call(Invoice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvoiceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Invoice>(
      where: where?.call(Invoice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Invoice] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<InvoiceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Invoice>(
      where: where(Invoice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
