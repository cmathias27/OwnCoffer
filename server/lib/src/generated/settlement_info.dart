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

abstract class SettlementInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SettlementInfo._({
    required this.fromUserId,
    required this.toUserId,
    required this.amountCents,
  });

  factory SettlementInfo({
    required _is.UuidValue fromUserId,
    required _is.UuidValue toUserId,
    required int amountCents,
  }) = _SettlementInfoImpl;

  factory SettlementInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SettlementInfo(
      fromUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['fromUserId'],
      ),
      toUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['toUserId'],
      ),
      amountCents: jsonSerialization['amountCents'] as int,
    );
  }

  _is.UuidValue fromUserId;

  _is.UuidValue toUserId;

  int amountCents;

  /// Returns a shallow copy of this [SettlementInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SettlementInfo copyWith({
    _is.UuidValue? fromUserId,
    _is.UuidValue? toUserId,
    int? amountCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SettlementInfo',
      'fromUserId': fromUserId.toJson(),
      'toUserId': toUserId.toJson(),
      'amountCents': amountCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SettlementInfo',
      'fromUserId': fromUserId.toJson(),
      'toUserId': toUserId.toJson(),
      'amountCents': amountCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SettlementInfoImpl extends SettlementInfo {
  _SettlementInfoImpl({
    required _is.UuidValue fromUserId,
    required _is.UuidValue toUserId,
    required int amountCents,
  }) : super._(
         fromUserId: fromUserId,
         toUserId: toUserId,
         amountCents: amountCents,
       );

  /// Returns a shallow copy of this [SettlementInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SettlementInfo copyWith({
    _is.UuidValue? fromUserId,
    _is.UuidValue? toUserId,
    int? amountCents,
  }) {
    return SettlementInfo(
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      amountCents: amountCents ?? this.amountCents,
    );
  }
}
