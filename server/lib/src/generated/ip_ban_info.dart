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

/// A banned IP as shown to the server administrator.
abstract class IpBanInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  IpBanInfo._({
    required this.ip,
    required this.bannedUntil,
    required this.banCount,
    required this.lastFailureKind,
  });

  factory IpBanInfo({
    required String ip,
    required DateTime bannedUntil,
    required int banCount,
    required String lastFailureKind,
  }) = _IpBanInfoImpl;

  factory IpBanInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return IpBanInfo(
      ip: jsonSerialization['ip'] as String,
      bannedUntil: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['bannedUntil'],
      ),
      banCount: jsonSerialization['banCount'] as int,
      lastFailureKind: jsonSerialization['lastFailureKind'] as String,
    );
  }

  String ip;

  DateTime bannedUntil;

  int banCount;

  String lastFailureKind;

  /// Returns a shallow copy of this [IpBanInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IpBanInfo copyWith({
    String? ip,
    DateTime? bannedUntil,
    int? banCount,
    String? lastFailureKind,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IpBanInfo',
      'ip': ip,
      'bannedUntil': bannedUntil.toJson(),
      'banCount': banCount,
      'lastFailureKind': lastFailureKind,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IpBanInfo',
      'ip': ip,
      'bannedUntil': bannedUntil.toJson(),
      'banCount': banCount,
      'lastFailureKind': lastFailureKind,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _IpBanInfoImpl extends IpBanInfo {
  _IpBanInfoImpl({
    required String ip,
    required DateTime bannedUntil,
    required int banCount,
    required String lastFailureKind,
  }) : super._(
         ip: ip,
         bannedUntil: bannedUntil,
         banCount: banCount,
         lastFailureKind: lastFailureKind,
       );

  /// Returns a shallow copy of this [IpBanInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IpBanInfo copyWith({
    String? ip,
    DateTime? bannedUntil,
    int? banCount,
    String? lastFailureKind,
  }) {
    return IpBanInfo(
      ip: ip ?? this.ip,
      bannedUntil: bannedUntil ?? this.bannedUntil,
      banCount: banCount ?? this.banCount,
      lastFailureKind: lastFailureKind ?? this.lastFailureKind,
    );
  }
}
