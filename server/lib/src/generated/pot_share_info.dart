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

abstract class PotShareInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PotShareInfo._({
    required this.userId,
    this.email,
    required this.incomeCents,
    required this.shareCents,
  });

  factory PotShareInfo({
    required _is.UuidValue userId,
    String? email,
    required int incomeCents,
    required int shareCents,
  }) = _PotShareInfoImpl;

  factory PotShareInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return PotShareInfo(
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String?,
      incomeCents: jsonSerialization['incomeCents'] as int,
      shareCents: jsonSerialization['shareCents'] as int,
    );
  }

  _is.UuidValue userId;

  String? email;

  int incomeCents;

  int shareCents;

  /// Returns a shallow copy of this [PotShareInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PotShareInfo copyWith({
    _is.UuidValue? userId,
    String? email,
    int? incomeCents,
    int? shareCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PotShareInfo',
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'incomeCents': incomeCents,
      'shareCents': shareCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PotShareInfo',
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'incomeCents': incomeCents,
      'shareCents': shareCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PotShareInfoImpl extends PotShareInfo {
  _PotShareInfoImpl({
    required _is.UuidValue userId,
    String? email,
    required int incomeCents,
    required int shareCents,
  }) : super._(
         userId: userId,
         email: email,
         incomeCents: incomeCents,
         shareCents: shareCents,
       );

  /// Returns a shallow copy of this [PotShareInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PotShareInfo copyWith({
    _is.UuidValue? userId,
    Object? email = _Undefined,
    int? incomeCents,
    int? shareCents,
  }) {
    return PotShareInfo(
      userId: userId ?? this.userId,
      email: email is String? ? email : this.email,
      incomeCents: incomeCents ?? this.incomeCents,
      shareCents: shareCents ?? this.shareCents,
    );
  }
}
