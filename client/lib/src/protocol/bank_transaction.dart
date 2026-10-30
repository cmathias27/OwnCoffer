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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'category_source.dart' as _idpjit5g;

/// A real operation. `date` is a calendar date stored as UTC midnight;
/// `amountCents` is signed (negative = debit).
abstract class BankTransaction
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _BankTransactionImpl;

  factory BankTransaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return BankTransaction(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
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
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['cleared']),
      scheduledId: jsonSerialization['scheduledId'] as int?,
      scheduledDueDate: jsonSerialization['scheduledDueDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledDueDate'],
            ),
      transferPairId: jsonSerialization['transferPairId'] as int?,
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['createdBy'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  _isc.UuidValue? createdBy;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [BankTransaction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
    _isc.UuidValue? createdBy,
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
    _isc.UuidValue? createdBy,
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
  @_isc.useResult
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
      createdBy: createdBy is _isc.UuidValue? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
