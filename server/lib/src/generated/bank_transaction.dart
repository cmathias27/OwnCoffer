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
import 'category_source.dart' as _idpjit5g;

/// A real operation. `date` is a calendar date stored as UTC midnight;
/// `amountCents` is signed (negative = debit).
abstract class BankTransaction
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BankTransaction._({
    this.id,
    required this.accountId,
    required this.date,
    required this.amountCents,
    required this.rawLabel,
    this.memo,
    this.note,
    required this.cleanLabel,
    required this.operationKind,
    this.reference,
    this.bankId,
    this.fingerprint,
    this.trashedFingerprint,
    this.importId,
    this.categoryId,
    _idpjit5g.CategorySource? categorySource,
    this.categoryRuleRef,
    bool? cleared,
    this.scheduledId,
    this.scheduledDueDate,
    this.transferPairId,
    this.createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
  }) : categorySource = categorySource ?? _idpjit5g.CategorySource.none,
       cleared = cleared ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory BankTransaction({
    int? id,
    required int accountId,
    required DateTime date,
    required int amountCents,
    required String rawLabel,
    String? memo,
    String? note,
    required String cleanLabel,
    required String operationKind,
    String? reference,
    String? bankId,
    String? fingerprint,
    String? trashedFingerprint,
    int? importId,
    int? categoryId,
    _idpjit5g.CategorySource? categorySource,
    String? categoryRuleRef,
    bool? cleared,
    int? scheduledId,
    DateTime? scheduledDueDate,
    int? transferPairId,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _BankTransactionImpl;

  factory BankTransaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return BankTransaction(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amountCents: jsonSerialization['amountCents'] as int,
      rawLabel: jsonSerialization['rawLabel'] as String,
      memo: jsonSerialization['memo'] as String?,
      note: jsonSerialization['note'] as String?,
      cleanLabel: jsonSerialization['cleanLabel'] as String,
      operationKind: jsonSerialization['operationKind'] as String,
      reference: jsonSerialization['reference'] as String?,
      bankId: jsonSerialization['bankId'] as String?,
      fingerprint: jsonSerialization['fingerprint'] as String?,
      trashedFingerprint: jsonSerialization['trashedFingerprint'] as String?,
      importId: jsonSerialization['importId'] as int?,
      categoryId: jsonSerialization['categoryId'] as int?,
      categorySource: jsonSerialization['categorySource'] == null
          ? null
          : _idpjit5g.CategorySource.fromJson(
              (jsonSerialization['categorySource'] as String),
            ),
      categoryRuleRef: jsonSerialization['categoryRuleRef'] as String?,
      cleared: jsonSerialization['cleared'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['cleared']),
      scheduledId: jsonSerialization['scheduledId'] as int?,
      scheduledDueDate: jsonSerialization['scheduledDueDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledDueDate'],
            ),
      transferPairId: jsonSerialization['transferPairId'] as int?,
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['createdBy']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = BankTransactionTable();

  static const db = BankTransactionRepository._();

  @override
  int? id;

  int accountId;

  DateTime date;

  int amountCents;

  String rawLabel;

  /// Details written by the bank (QIF M, OFX NAME/MEMO), never edited.
  String? memo;

  /// The user's own note.
  String? note;

  /// Cleaned, normalised label (e.g. `EDF`), used by the history.
  String cleanLabel;

  /// OperationKind from the label cleaner (card, directDebit…).
  String operationKind;

  String? reference;

  /// Unique id given by the bank (OFX FITID).
  String? bankId;

  /// Duplicate fingerprint; null for manual entries. Unique per account, so
  /// it is moved to `trashedFingerprint` when the operation goes to the trash
  /// (and moved back on restore) — a cancelled import can be re-imported.
  String? fingerprint;

  String? trashedFingerprint;

  int? importId;

  int? categoryId;

  _idpjit5g.CategorySource categorySource;

  /// Group rule id or community rule key that set the category.
  String? categoryRuleRef;

  bool cleared;

  /// Scheduled operation this one realises (reconciliation).
  int? scheduledId;

  DateTime? scheduledDueDate;

  /// Other side of a transfer between two accounts of the group.
  int? transferPairId;

  _is.UuidValue? createdBy;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BankTransaction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BankTransaction copyWith({
    int? id,
    int? accountId,
    DateTime? date,
    int? amountCents,
    String? rawLabel,
    String? memo,
    String? note,
    String? cleanLabel,
    String? operationKind,
    String? reference,
    String? bankId,
    String? fingerprint,
    String? trashedFingerprint,
    int? importId,
    int? categoryId,
    _idpjit5g.CategorySource? categorySource,
    String? categoryRuleRef,
    bool? cleared,
    int? scheduledId,
    DateTime? scheduledDueDate,
    int? transferPairId,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BankTransaction',
      if (id != null) 'id': id,
      'accountId': accountId,
      'date': date.toJson(),
      'amountCents': amountCents,
      'rawLabel': rawLabel,
      if (memo != null) 'memo': memo,
      if (note != null) 'note': note,
      'cleanLabel': cleanLabel,
      'operationKind': operationKind,
      if (reference != null) 'reference': reference,
      if (bankId != null) 'bankId': bankId,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (trashedFingerprint != null) 'trashedFingerprint': trashedFingerprint,
      if (importId != null) 'importId': importId,
      if (categoryId != null) 'categoryId': categoryId,
      'categorySource': categorySource.toJson(),
      if (categoryRuleRef != null) 'categoryRuleRef': categoryRuleRef,
      'cleared': cleared,
      if (scheduledId != null) 'scheduledId': scheduledId,
      if (scheduledDueDate != null)
        'scheduledDueDate': scheduledDueDate?.toJson(),
      if (transferPairId != null) 'transferPairId': transferPairId,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BankTransaction',
      if (id != null) 'id': id,
      'accountId': accountId,
      'date': date.toJson(),
      'amountCents': amountCents,
      'rawLabel': rawLabel,
      if (memo != null) 'memo': memo,
      if (note != null) 'note': note,
      'cleanLabel': cleanLabel,
      'operationKind': operationKind,
      if (reference != null) 'reference': reference,
      if (bankId != null) 'bankId': bankId,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (trashedFingerprint != null) 'trashedFingerprint': trashedFingerprint,
      if (importId != null) 'importId': importId,
      if (categoryId != null) 'categoryId': categoryId,
      'categorySource': categorySource.toJson(),
      if (categoryRuleRef != null) 'categoryRuleRef': categoryRuleRef,
      'cleared': cleared,
      if (scheduledId != null) 'scheduledId': scheduledId,
      if (scheduledDueDate != null)
        'scheduledDueDate': scheduledDueDate?.toJson(),
      if (transferPairId != null) 'transferPairId': transferPairId,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static BankTransactionInclude include() {
    return BankTransactionInclude._();
  }

  static BankTransactionIncludeList includeList({
    _is.WhereExpressionBuilder<BankTransactionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BankTransactionTable>? orderBy,
    _is.OrderByListBuilder<BankTransactionTable>? orderByList,
    BankTransactionInclude? include,
  }) {
    return BankTransactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BankTransaction.t),
      orderByList: orderByList?.call(BankTransaction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BankTransactionImpl extends BankTransaction {
  _BankTransactionImpl({
    int? id,
    required int accountId,
    required DateTime date,
    required int amountCents,
    required String rawLabel,
    String? memo,
    String? note,
    required String cleanLabel,
    required String operationKind,
    String? reference,
    String? bankId,
    String? fingerprint,
    String? trashedFingerprint,
    int? importId,
    int? categoryId,
    _idpjit5g.CategorySource? categorySource,
    String? categoryRuleRef,
    bool? cleared,
    int? scheduledId,
    DateTime? scheduledDueDate,
    int? transferPairId,
    _is.UuidValue? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         accountId: accountId,
         date: date,
         amountCents: amountCents,
         rawLabel: rawLabel,
         memo: memo,
         note: note,
         cleanLabel: cleanLabel,
         operationKind: operationKind,
         reference: reference,
         bankId: bankId,
         fingerprint: fingerprint,
         trashedFingerprint: trashedFingerprint,
         importId: importId,
         categoryId: categoryId,
         categorySource: categorySource,
         categoryRuleRef: categoryRuleRef,
         cleared: cleared,
         scheduledId: scheduledId,
         scheduledDueDate: scheduledDueDate,
         transferPairId: transferPairId,
         createdBy: createdBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [BankTransaction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BankTransaction copyWith({
    Object? id = _Undefined,
    int? accountId,
    DateTime? date,
    int? amountCents,
    String? rawLabel,
    Object? memo = _Undefined,
    Object? note = _Undefined,
    String? cleanLabel,
    String? operationKind,
    Object? reference = _Undefined,
    Object? bankId = _Undefined,
    Object? fingerprint = _Undefined,
    Object? trashedFingerprint = _Undefined,
    Object? importId = _Undefined,
    Object? categoryId = _Undefined,
    _idpjit5g.CategorySource? categorySource,
    Object? categoryRuleRef = _Undefined,
    bool? cleared,
    Object? scheduledId = _Undefined,
    Object? scheduledDueDate = _Undefined,
    Object? transferPairId = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
  }) {
    return BankTransaction(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
      rawLabel: rawLabel ?? this.rawLabel,
      memo: memo is String? ? memo : this.memo,
      note: note is String? ? note : this.note,
      cleanLabel: cleanLabel ?? this.cleanLabel,
      operationKind: operationKind ?? this.operationKind,
      reference: reference is String? ? reference : this.reference,
      bankId: bankId is String? ? bankId : this.bankId,
      fingerprint: fingerprint is String? ? fingerprint : this.fingerprint,
      trashedFingerprint: trashedFingerprint is String?
          ? trashedFingerprint
          : this.trashedFingerprint,
      importId: importId is int? ? importId : this.importId,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      categorySource: categorySource ?? this.categorySource,
      categoryRuleRef: categoryRuleRef is String?
          ? categoryRuleRef
          : this.categoryRuleRef,
      cleared: cleared ?? this.cleared,
      scheduledId: scheduledId is int? ? scheduledId : this.scheduledId,
      scheduledDueDate: scheduledDueDate is DateTime?
          ? scheduledDueDate
          : this.scheduledDueDate,
      transferPairId: transferPairId is int?
          ? transferPairId
          : this.transferPairId,
      createdBy: createdBy is _is.UuidValue? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class BankTransactionUpdateTable extends _is.UpdateTable<BankTransactionTable> {
  BankTransactionUpdateTable(super.table);

  _is.ColumnValue<int, int> accountId(int value) => _is.ColumnValue(
    table.accountId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> date(DateTime value) => _is.ColumnValue(
    table.date,
    value,
  );

  _is.ColumnValue<int, int> amountCents(int value) => _is.ColumnValue(
    table.amountCents,
    value,
  );

  _is.ColumnValue<String, String> rawLabel(String value) => _is.ColumnValue(
    table.rawLabel,
    value,
  );

  _is.ColumnValue<String, String> memo(String? value) => _is.ColumnValue(
    table.memo,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<String, String> cleanLabel(String value) => _is.ColumnValue(
    table.cleanLabel,
    value,
  );

  _is.ColumnValue<String, String> operationKind(String value) =>
      _is.ColumnValue(
        table.operationKind,
        value,
      );

  _is.ColumnValue<String, String> reference(String? value) => _is.ColumnValue(
    table.reference,
    value,
  );

  _is.ColumnValue<String, String> bankId(String? value) => _is.ColumnValue(
    table.bankId,
    value,
  );

  _is.ColumnValue<String, String> fingerprint(String? value) => _is.ColumnValue(
    table.fingerprint,
    value,
  );

  _is.ColumnValue<String, String> trashedFingerprint(String? value) =>
      _is.ColumnValue(
        table.trashedFingerprint,
        value,
      );

  _is.ColumnValue<int, int> importId(int? value) => _is.ColumnValue(
    table.importId,
    value,
  );

  _is.ColumnValue<int, int> categoryId(int? value) => _is.ColumnValue(
    table.categoryId,
    value,
  );

  _is.ColumnValue<_idpjit5g.CategorySource, _idpjit5g.CategorySource>
  categorySource(_idpjit5g.CategorySource value) => _is.ColumnValue(
    table.categorySource,
    value,
  );

  _is.ColumnValue<String, String> categoryRuleRef(String? value) =>
      _is.ColumnValue(
        table.categoryRuleRef,
        value,
      );

  _is.ColumnValue<bool, bool> cleared(bool value) => _is.ColumnValue(
    table.cleared,
    value,
  );

  _is.ColumnValue<int, int> scheduledId(int? value) => _is.ColumnValue(
    table.scheduledId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> scheduledDueDate(DateTime? value) =>
      _is.ColumnValue(
        table.scheduledDueDate,
        value,
      );

  _is.ColumnValue<int, int> transferPairId(int? value) => _is.ColumnValue(
    table.transferPairId,
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

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _is.ColumnValue(
        table.deletedAt,
        value,
      );
}

class BankTransactionTable extends _is.Table<int?> {
  BankTransactionTable({super.tableRelation})
    : super(tableName: 'transactions') {
    updateTable = BankTransactionUpdateTable(this);
    accountId = _is.ColumnInt(
      'accountId',
      this,
    );
    date = _is.ColumnDateTime(
      'date',
      this,
    );
    amountCents = _is.ColumnInt(
      'amountCents',
      this,
    );
    rawLabel = _is.ColumnString(
      'rawLabel',
      this,
    );
    memo = _is.ColumnString(
      'memo',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    cleanLabel = _is.ColumnString(
      'cleanLabel',
      this,
    );
    operationKind = _is.ColumnString(
      'operationKind',
      this,
    );
    reference = _is.ColumnString(
      'reference',
      this,
    );
    bankId = _is.ColumnString(
      'bankId',
      this,
    );
    fingerprint = _is.ColumnString(
      'fingerprint',
      this,
    );
    trashedFingerprint = _is.ColumnString(
      'trashedFingerprint',
      this,
    );
    importId = _is.ColumnInt(
      'importId',
      this,
    );
    categoryId = _is.ColumnInt(
      'categoryId',
      this,
    );
    categorySource = _is.ColumnEnum(
      'categorySource',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    categoryRuleRef = _is.ColumnString(
      'categoryRuleRef',
      this,
    );
    cleared = _is.ColumnBool(
      'cleared',
      this,
      hasDefault: true,
    );
    scheduledId = _is.ColumnInt(
      'scheduledId',
      this,
    );
    scheduledDueDate = _is.ColumnDateTime(
      'scheduledDueDate',
      this,
    );
    transferPairId = _is.ColumnInt(
      'transferPairId',
      this,
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
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
    deletedAt = _is.ColumnDateTime(
      'deletedAt',
      this,
    );
  }

  late final BankTransactionUpdateTable updateTable;

  late final _is.ColumnInt accountId;

  late final _is.ColumnDateTime date;

  late final _is.ColumnInt amountCents;

  late final _is.ColumnString rawLabel;

  /// Details written by the bank (QIF M, OFX NAME/MEMO), never edited.
  late final _is.ColumnString memo;

  /// The user's own note.
  late final _is.ColumnString note;

  /// Cleaned, normalised label (e.g. `EDF`), used by the history.
  late final _is.ColumnString cleanLabel;

  /// OperationKind from the label cleaner (card, directDebit…).
  late final _is.ColumnString operationKind;

  late final _is.ColumnString reference;

  /// Unique id given by the bank (OFX FITID).
  late final _is.ColumnString bankId;

  /// Duplicate fingerprint; null for manual entries. Unique per account, so
  /// it is moved to `trashedFingerprint` when the operation goes to the trash
  /// (and moved back on restore) — a cancelled import can be re-imported.
  late final _is.ColumnString fingerprint;

  late final _is.ColumnString trashedFingerprint;

  late final _is.ColumnInt importId;

  late final _is.ColumnInt categoryId;

  late final _is.ColumnEnum<_idpjit5g.CategorySource> categorySource;

  /// Group rule id or community rule key that set the category.
  late final _is.ColumnString categoryRuleRef;

  late final _is.ColumnBool cleared;

  /// Scheduled operation this one realises (reconciliation).
  late final _is.ColumnInt scheduledId;

  late final _is.ColumnDateTime scheduledDueDate;

  /// Other side of a transfer between two accounts of the group.
  late final _is.ColumnInt transferPairId;

  late final _is.ColumnUuid createdBy;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime deletedAt;

  @override
  List<_is.Column> get columns => [
    id,
    accountId,
    date,
    amountCents,
    rawLabel,
    memo,
    note,
    cleanLabel,
    operationKind,
    reference,
    bankId,
    fingerprint,
    trashedFingerprint,
    importId,
    categoryId,
    categorySource,
    categoryRuleRef,
    cleared,
    scheduledId,
    scheduledDueDate,
    transferPairId,
    createdBy,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

class BankTransactionInclude extends _is.IncludeObject {
  BankTransactionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BankTransaction.t;
}

class BankTransactionIncludeList extends _is.IncludeList {
  BankTransactionIncludeList._({
    _is.WhereExpressionBuilder<BankTransactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BankTransaction.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BankTransaction.t;
}

class BankTransactionRepository {
  const BankTransactionRepository._();

  /// Returns a list of [BankTransaction]s matching the given query parameters.
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
  Future<List<BankTransaction>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BankTransactionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BankTransactionTable>? orderBy,
    _is.OrderByListBuilder<BankTransactionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BankTransaction>(
      where: where?.call(BankTransaction.t),
      orderBy: orderBy?.call(BankTransaction.t),
      orderByList: orderByList?.call(BankTransaction.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BankTransaction] matching the given query parameters.
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
  Future<BankTransaction?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BankTransactionTable>? where,
    int? offset,
    _is.OrderByBuilder<BankTransactionTable>? orderBy,
    _is.OrderByListBuilder<BankTransactionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BankTransaction>(
      where: where?.call(BankTransaction.t),
      orderBy: orderBy?.call(BankTransaction.t),
      orderByList: orderByList?.call(BankTransaction.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BankTransaction] by its [id] or null if no such row exists.
  Future<BankTransaction?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BankTransaction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BankTransaction]s in the list and returns the inserted rows.
  ///
  /// The returned [BankTransaction]s will have their `id` fields set.
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
  Future<List<BankTransaction>> insert(
    _is.DatabaseSession session,
    List<BankTransaction> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BankTransaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BankTransaction] and returns the inserted row.
  ///
  /// The returned [BankTransaction] will have its `id` field set.
  Future<BankTransaction> insertRow(
    _is.DatabaseSession session,
    BankTransaction row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BankTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BankTransaction]s in the list and returns the resulting rows.
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
  /// The returned [BankTransaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BankTransaction>> upsert(
    _is.DatabaseSession session,
    List<BankTransaction> rows, {
    required _is.ColumnSelections<BankTransactionTable> conflictColumns,
    _is.ColumnSelections<BankTransactionTable>? updateColumns,
    _is.WhereExpressionBuilder<BankTransactionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BankTransaction>(
      rows,
      conflictColumns: conflictColumns(BankTransaction.t),
      updateColumns: updateColumns?.call(BankTransaction.t),
      updateWhere: updateWhere?.call(BankTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BankTransaction] and returns the resulting row.
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
  /// The returned [BankTransaction] will have its `id` field set.
  Future<BankTransaction?> upsertRow(
    _is.DatabaseSession session,
    BankTransaction row, {
    required _is.ColumnSelections<BankTransactionTable> conflictColumns,
    _is.ColumnSelections<BankTransactionTable>? updateColumns,
    _is.WhereExpressionBuilder<BankTransactionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BankTransaction>(
      row,
      conflictColumns: conflictColumns(BankTransaction.t),
      updateColumns: updateColumns?.call(BankTransaction.t),
      updateWhere: updateWhere?.call(BankTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates all [BankTransaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BankTransaction>> update(
    _is.DatabaseSession session,
    List<BankTransaction> rows, {
    _is.ColumnSelections<BankTransactionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BankTransaction>(
      rows,
      columns: columns?.call(BankTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BankTransaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BankTransaction> updateRow(
    _is.DatabaseSession session,
    BankTransaction row, {
    _is.ColumnSelections<BankTransactionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BankTransaction>(
      row,
      columns: columns?.call(BankTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BankTransaction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BankTransaction?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BankTransactionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BankTransaction>(
      id,
      columnValues: columnValues(BankTransaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BankTransaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BankTransaction>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BankTransactionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<BankTransactionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BankTransactionTable>? orderBy,
    _is.OrderByListBuilder<BankTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BankTransaction>(
      columnValues: columnValues(BankTransaction.t.updateTable),
      where: where(BankTransaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BankTransaction.t),
      orderByList: orderByList?.call(BankTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BankTransaction]s in the list and returns the deleted rows.
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
  Future<List<BankTransaction>> delete(
    _is.DatabaseSession session,
    List<BankTransaction> rows, {
    _is.OrderByBuilder<BankTransactionTable>? orderBy,
    _is.OrderByListBuilder<BankTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BankTransaction>(
      rows,
      orderBy: orderBy?.call(BankTransaction.t),
      orderByList: orderByList?.call(BankTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BankTransaction].
  Future<BankTransaction> deleteRow(
    _is.DatabaseSession session,
    BankTransaction row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BankTransaction>(
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
  Future<List<BankTransaction>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BankTransactionTable> where,
    _is.OrderByBuilder<BankTransactionTable>? orderBy,
    _is.OrderByListBuilder<BankTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BankTransaction>(
      where: where(BankTransaction.t),
      orderBy: orderBy?.call(BankTransaction.t),
      orderByList: orderByList?.call(BankTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BankTransactionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BankTransaction>(
      where: where?.call(BankTransaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BankTransaction] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BankTransactionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BankTransaction>(
      where: where(BankTransaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
