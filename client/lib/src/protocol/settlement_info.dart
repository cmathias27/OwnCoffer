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

abstract class SettlementInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SettlementInfo._({
    required this.fromUserId,
    required this.toUserId,
    required this.amountCents,
  });

  factory SettlementInfo({
    required _isc.UuidValue fromUserId,
    required _isc.UuidValue toUserId,
    required int amountCents,
  }) = _SettlementInfoImpl;

  factory SettlementInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SettlementInfo(
      fromUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['fromUserId'],
      ),
      toUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['toUserId'],
      ),
      amountCents: jsonSerialization['amountCents'] as int,
    );
  }

  _isc.UuidValue fromUserId;

  _isc.UuidValue toUserId;

  int amountCents;

  /// Returns a shallow copy of this [SettlementInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SettlementInfo copyWith({
    _isc.UuidValue? fromUserId,
    _isc.UuidValue? toUserId,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _SettlementInfoImpl extends SettlementInfo {
  _SettlementInfoImpl({
    required _isc.UuidValue fromUserId,
    required _isc.UuidValue toUserId,
    required int amountCents,
  }) : super._(
         fromUserId: fromUserId,
         toUserId: toUserId,
         amountCents: amountCents,
       );

  /// Returns a shallow copy of this [SettlementInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SettlementInfo copyWith({
    _isc.UuidValue? fromUserId,
    _isc.UuidValue? toUserId,
    int? amountCents,
  }) {
    return SettlementInfo(
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      amountCents: amountCents ?? this.amountCents,
    );
  }
}
