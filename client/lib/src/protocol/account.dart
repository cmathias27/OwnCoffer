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
import 'account_kind.dart' as _ifkquxga;
import 'account_visibility.dart' as _ioxxcdxl;

/// A bank account. Amounts are integer cents.
abstract class Account
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Account._({
    this.id,
    required this.groupId,
    required this.name,
    required this.kind,
    this.bank,
    String? currency,
    int? initialBalanceCents,
    this.initialBalanceDate,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    this.color,
    DateTime? createdAt,
    this.deletedAt,
  }) : currency = currency ?? 'EUR',
       initialBalanceCents = initialBalanceCents ?? 0,
       alertThresholdCents = alertThresholdCents ?? 0,
       visibility = visibility ?? _ioxxcdxl.AccountVisibility.shared,
       createdAt = createdAt ?? DateTime.now();

  factory Account({
    int? id,
    required int groupId,
    required String name,
    required _ifkquxga.AccountKind kind,
    String? bank,
    String? currency,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) = _AccountImpl;

  factory Account.fromJson(Map<String, dynamic> jsonSerialization) {
    return Account(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      name: jsonSerialization['name'] as String,
      kind: _ifkquxga.AccountKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      bank: jsonSerialization['bank'] as String?,
      currency: jsonSerialization['currency'] as String?,
      initialBalanceCents: jsonSerialization['initialBalanceCents'] as int?,
      initialBalanceDate: jsonSerialization['initialBalanceDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['initialBalanceDate'],
            ),
      alertThresholdCents: jsonSerialization['alertThresholdCents'] as int?,
      visibility: jsonSerialization['visibility'] == null
          ? null
          : _ioxxcdxl.AccountVisibility.fromJson(
              (jsonSerialization['visibility'] as String),
            ),
      color: jsonSerialization['color'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  String name;

  _ifkquxga.AccountKind kind;

  String? bank;

  String currency;

  int initialBalanceCents;

  /// Date of the initial balance (UTC midnight, see LocalDate conversion).
  DateTime? initialBalanceDate;

  /// Alert when the forecast goes below this balance (0 = any overdraft;
  /// negative = authorised overdraft).
  int alertThresholdCents;

  _ioxxcdxl.AccountVisibility visibility;

  String? color;

  DateTime createdAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [Account]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Account copyWith({
    int? id,
    int? groupId,
    String? name,
    _ifkquxga.AccountKind? kind,
    String? bank,
    String? currency,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Account',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'kind': kind.toJson(),
      if (bank != null) 'bank': bank,
      'currency': currency,
      'initialBalanceCents': initialBalanceCents,
      if (initialBalanceDate != null)
        'initialBalanceDate': initialBalanceDate?.toJson(),
      'alertThresholdCents': alertThresholdCents,
      'visibility': visibility.toJson(),
      if (color != null) 'color': color,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Account',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'kind': kind.toJson(),
      if (bank != null) 'bank': bank,
      'currency': currency,
      'initialBalanceCents': initialBalanceCents,
      if (initialBalanceDate != null)
        'initialBalanceDate': initialBalanceDate?.toJson(),
      'alertThresholdCents': alertThresholdCents,
      'visibility': visibility.toJson(),
      if (color != null) 'color': color,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountImpl extends Account {
  _AccountImpl({
    int? id,
    required int groupId,
    required String name,
    required _ifkquxga.AccountKind kind,
    String? bank,
    String? currency,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         name: name,
         kind: kind,
         bank: bank,
         currency: currency,
         initialBalanceCents: initialBalanceCents,
         initialBalanceDate: initialBalanceDate,
         alertThresholdCents: alertThresholdCents,
         visibility: visibility,
         color: color,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Account]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Account copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? name,
    _ifkquxga.AccountKind? kind,
    Object? bank = _Undefined,
    String? currency,
    int? initialBalanceCents,
    Object? initialBalanceDate = _Undefined,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    Object? color = _Undefined,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return Account(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      bank: bank is String? ? bank : this.bank,
      currency: currency ?? this.currency,
      initialBalanceCents: initialBalanceCents ?? this.initialBalanceCents,
      initialBalanceDate: initialBalanceDate is DateTime?
          ? initialBalanceDate
          : this.initialBalanceDate,
      alertThresholdCents: alertThresholdCents ?? this.alertThresholdCents,
      visibility: visibility ?? this.visibility,
      color: color is String? ? color : this.color,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
