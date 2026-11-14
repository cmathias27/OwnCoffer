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
import 'regulated_kind.dart' as _ijnu36v8;

/// A regulated savings account: room left under the ceiling and the
/// interest under the fortnight rule (core.fortnightInterest).
abstract class RegulatedSavingsInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RegulatedSavingsInfo._({
    required this.accountId,
    required this.name,
    required this.kind,
    required this.balanceCents,
    required this.ceilingCents,
    required this.roomCents,
    this.rateBp,
    this.interestSoFarCents,
    this.interestYearCents,
  });

  factory RegulatedSavingsInfo({
    required int accountId,
    required String name,
    required _ijnu36v8.RegulatedKind kind,
    required int balanceCents,
    required int ceilingCents,
    required int roomCents,
    int? rateBp,
    int? interestSoFarCents,
    int? interestYearCents,
  }) = _RegulatedSavingsInfoImpl;

  factory RegulatedSavingsInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RegulatedSavingsInfo(
      accountId: jsonSerialization['accountId'] as int,
      name: jsonSerialization['name'] as String,
      kind: _ijnu36v8.RegulatedKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      balanceCents: jsonSerialization['balanceCents'] as int,
      ceilingCents: jsonSerialization['ceilingCents'] as int,
      roomCents: jsonSerialization['roomCents'] as int,
      rateBp: jsonSerialization['rateBp'] as int?,
      interestSoFarCents: jsonSerialization['interestSoFarCents'] as int?,
      interestYearCents: jsonSerialization['interestYearCents'] as int?,
    );
  }

  int accountId;

  String name;

  _ijnu36v8.RegulatedKind kind;

  int balanceCents;

  int ceilingCents;

  /// Deposits still possible, never negative.
  int roomCents;

  /// Yearly rate in hundredths of a percent; null = not entered.
  int? rateBp;

  /// Interest of the fortnights already over this year.
  int? interestSoFarCents;

  /// Interest of the whole year if nothing moves any more.
  int? interestYearCents;

  /// Returns a shallow copy of this [RegulatedSavingsInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RegulatedSavingsInfo copyWith({
    int? accountId,
    String? name,
    _ijnu36v8.RegulatedKind? kind,
    int? balanceCents,
    int? ceilingCents,
    int? roomCents,
    int? rateBp,
    int? interestSoFarCents,
    int? interestYearCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RegulatedSavingsInfo',
      'accountId': accountId,
      'name': name,
      'kind': kind.toJson(),
      'balanceCents': balanceCents,
      'ceilingCents': ceilingCents,
      'roomCents': roomCents,
      if (rateBp != null) 'rateBp': rateBp,
      if (interestSoFarCents != null) 'interestSoFarCents': interestSoFarCents,
      if (interestYearCents != null) 'interestYearCents': interestYearCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RegulatedSavingsInfo',
      'accountId': accountId,
      'name': name,
      'kind': kind.toJson(),
      'balanceCents': balanceCents,
      'ceilingCents': ceilingCents,
      'roomCents': roomCents,
      if (rateBp != null) 'rateBp': rateBp,
      if (interestSoFarCents != null) 'interestSoFarCents': interestSoFarCents,
      if (interestYearCents != null) 'interestYearCents': interestYearCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RegulatedSavingsInfoImpl extends RegulatedSavingsInfo {
  _RegulatedSavingsInfoImpl({
    required int accountId,
    required String name,
    required _ijnu36v8.RegulatedKind kind,
    required int balanceCents,
    required int ceilingCents,
    required int roomCents,
    int? rateBp,
    int? interestSoFarCents,
    int? interestYearCents,
  }) : super._(
         accountId: accountId,
         name: name,
         kind: kind,
         balanceCents: balanceCents,
         ceilingCents: ceilingCents,
         roomCents: roomCents,
         rateBp: rateBp,
         interestSoFarCents: interestSoFarCents,
         interestYearCents: interestYearCents,
       );

  /// Returns a shallow copy of this [RegulatedSavingsInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RegulatedSavingsInfo copyWith({
    int? accountId,
    String? name,
    _ijnu36v8.RegulatedKind? kind,
    int? balanceCents,
    int? ceilingCents,
    int? roomCents,
    Object? rateBp = _Undefined,
    Object? interestSoFarCents = _Undefined,
    Object? interestYearCents = _Undefined,
  }) {
    return RegulatedSavingsInfo(
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      balanceCents: balanceCents ?? this.balanceCents,
      ceilingCents: ceilingCents ?? this.ceilingCents,
      roomCents: roomCents ?? this.roomCents,
      rateBp: rateBp is int? ? rateBp : this.rateBp,
      interestSoFarCents: interestSoFarCents is int?
          ? interestSoFarCents
          : this.interestSoFarCents,
      interestYearCents: interestYearCents is int?
          ? interestYearCents
          : this.interestYearCents,
    );
  }
}
