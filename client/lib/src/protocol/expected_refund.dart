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

/// Money expected back (health insurance, deposit, refund of a purchase),
/// settled by the first credit of the same amount (decision 0050).
abstract class ExpectedRefund
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ExpectedRefund._({
    this.id,
    required this.groupId,
    required this.createdBy,
    required this.label,
    required this.amountCents,
    required this.since,
    this.dueBy,
    this.accountId,
    this.transactionId,
    this.receivedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ExpectedRefund({
    int? id,
    required int groupId,
    required _isc.UuidValue createdBy,
    required String label,
    required int amountCents,
    required DateTime since,
    DateTime? dueBy,
    int? accountId,
    int? transactionId,
    DateTime? receivedAt,
    DateTime? createdAt,
  }) = _ExpectedRefundImpl;

  factory ExpectedRefund.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExpectedRefund(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      createdBy: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      label: jsonSerialization['label'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      since: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['since']),
      dueBy: jsonSerialization['dueBy'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueBy']),
      accountId: jsonSerialization['accountId'] as int?,
      transactionId: jsonSerialization['transactionId'] as int?,
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['receivedAt'],
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

  int groupId;

  _isc.UuidValue createdBy;

  String label;

  int amountCents;

  /// Credits from this day on may settle it.
  DateTime since;

  /// Late after this day.
  DateTime? dueBy;

  /// Account it should arrive on; null = any visible account.
  int? accountId;

  /// The credit that settled it.
  int? transactionId;

  DateTime? receivedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [ExpectedRefund]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ExpectedRefund copyWith({
    int? id,
    int? groupId,
    _isc.UuidValue? createdBy,
    String? label,
    int? amountCents,
    DateTime? since,
    DateTime? dueBy,
    int? accountId,
    int? transactionId,
    DateTime? receivedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExpectedRefund',
      if (id != null) 'id': id,
      'groupId': groupId,
      'createdBy': createdBy.toJson(),
      'label': label,
      'amountCents': amountCents,
      'since': since.toJson(),
      if (dueBy != null) 'dueBy': dueBy?.toJson(),
      if (accountId != null) 'accountId': accountId,
      if (transactionId != null) 'transactionId': transactionId,
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExpectedRefund',
      if (id != null) 'id': id,
      'groupId': groupId,
      'createdBy': createdBy.toJson(),
      'label': label,
      'amountCents': amountCents,
      'since': since.toJson(),
      if (dueBy != null) 'dueBy': dueBy?.toJson(),
      if (accountId != null) 'accountId': accountId,
      if (transactionId != null) 'transactionId': transactionId,
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExpectedRefundImpl extends ExpectedRefund {
  _ExpectedRefundImpl({
    int? id,
    required int groupId,
    required _isc.UuidValue createdBy,
    required String label,
    required int amountCents,
    required DateTime since,
    DateTime? dueBy,
    int? accountId,
    int? transactionId,
    DateTime? receivedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         createdBy: createdBy,
         label: label,
         amountCents: amountCents,
         since: since,
         dueBy: dueBy,
         accountId: accountId,
         transactionId: transactionId,
         receivedAt: receivedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ExpectedRefund]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ExpectedRefund copyWith({
    Object? id = _Undefined,
    int? groupId,
    _isc.UuidValue? createdBy,
    String? label,
    int? amountCents,
    DateTime? since,
    Object? dueBy = _Undefined,
    Object? accountId = _Undefined,
    Object? transactionId = _Undefined,
    Object? receivedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return ExpectedRefund(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      createdBy: createdBy ?? this.createdBy,
      label: label ?? this.label,
      amountCents: amountCents ?? this.amountCents,
      since: since ?? this.since,
      dueBy: dueBy is DateTime? ? dueBy : this.dueBy,
      accountId: accountId is int? ? accountId : this.accountId,
      transactionId: transactionId is int? ? transactionId : this.transactionId,
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
