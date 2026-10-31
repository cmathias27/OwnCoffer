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

/// The balance the bank shows on a date, compared with the balance computed
/// from the operations: a gap points to a missing import or an operation not
/// passed yet.
abstract class BalanceCheck
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BalanceCheck._({
    this.id,
    required this.accountId,
    required this.date,
    required this.bankBalanceCents,
    required this.computedCents,
    required this.differenceCents,
    required this.unclearedManualCents,
    this.lastImportedDate,
    this.createdBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BalanceCheck({
    int? id,
    required int accountId,
    required DateTime date,
    required int bankBalanceCents,
    required int computedCents,
    required int differenceCents,
    required int unclearedManualCents,
    DateTime? lastImportedDate,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  }) = _BalanceCheckImpl;

  factory BalanceCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return BalanceCheck(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      bankBalanceCents: jsonSerialization['bankBalanceCents'] as int,
      computedCents: jsonSerialization['computedCents'] as int,
      differenceCents: jsonSerialization['differenceCents'] as int,
      unclearedManualCents: jsonSerialization['unclearedManualCents'] as int,
      lastImportedDate: jsonSerialization['lastImportedDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastImportedDate'],
            ),
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['createdBy'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int accountId;

  /// Calendar date (UTC midnight), end of day.
  DateTime date;

  int bankBalanceCents;

  int computedCents;

  /// computed − bank.
  int differenceCents;

  /// Manual operations up to the date not yet cleared (may not have reached
  /// the bank).
  int unclearedManualCents;

  /// Latest imported operation, for "an import may be missing".
  DateTime? lastImportedDate;

  _isc.UuidValue? createdBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [BalanceCheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BalanceCheck copyWith({
    int? id,
    int? accountId,
    DateTime? date,
    int? bankBalanceCents,
    int? computedCents,
    int? differenceCents,
    int? unclearedManualCents,
    DateTime? lastImportedDate,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BalanceCheck',
      if (id != null) 'id': id,
      'accountId': accountId,
      'date': date.toJson(),
      'bankBalanceCents': bankBalanceCents,
      'computedCents': computedCents,
      'differenceCents': differenceCents,
      'unclearedManualCents': unclearedManualCents,
      if (lastImportedDate != null)
        'lastImportedDate': lastImportedDate?.toJson(),
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BalanceCheck',
      if (id != null) 'id': id,
      'accountId': accountId,
      'date': date.toJson(),
      'bankBalanceCents': bankBalanceCents,
      'computedCents': computedCents,
      'differenceCents': differenceCents,
      'unclearedManualCents': unclearedManualCents,
      if (lastImportedDate != null)
        'lastImportedDate': lastImportedDate?.toJson(),
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BalanceCheckImpl extends BalanceCheck {
  _BalanceCheckImpl({
    int? id,
    required int accountId,
    required DateTime date,
    required int bankBalanceCents,
    required int computedCents,
    required int differenceCents,
    required int unclearedManualCents,
    DateTime? lastImportedDate,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         accountId: accountId,
         date: date,
         bankBalanceCents: bankBalanceCents,
         computedCents: computedCents,
         differenceCents: differenceCents,
         unclearedManualCents: unclearedManualCents,
         lastImportedDate: lastImportedDate,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BalanceCheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BalanceCheck copyWith({
    Object? id = _Undefined,
    int? accountId,
    DateTime? date,
    int? bankBalanceCents,
    int? computedCents,
    int? differenceCents,
    int? unclearedManualCents,
    Object? lastImportedDate = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
  }) {
    return BalanceCheck(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      bankBalanceCents: bankBalanceCents ?? this.bankBalanceCents,
      computedCents: computedCents ?? this.computedCents,
      differenceCents: differenceCents ?? this.differenceCents,
      unclearedManualCents: unclearedManualCents ?? this.unclearedManualCents,
      lastImportedDate: lastImportedDate is DateTime?
          ? lastImportedDate
          : this.lastImportedDate,
      createdBy: createdBy is _isc.UuidValue? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
