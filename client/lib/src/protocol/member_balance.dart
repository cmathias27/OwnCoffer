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

abstract class MemberBalance
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MemberBalance._({
    required this.userId,
    this.email,
    required this.balanceCents,
  });

  factory MemberBalance({
    required _isc.UuidValue userId,
    String? email,
    required int balanceCents,
  }) = _MemberBalanceImpl;

  factory MemberBalance.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberBalance(
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String?,
      balanceCents: jsonSerialization['balanceCents'] as int,
    );
  }

  _isc.UuidValue userId;

  String? email;

  /// Owed to the member (positive) or owed by them (negative).
  int balanceCents;

  /// Returns a shallow copy of this [MemberBalance]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MemberBalance copyWith({
    _isc.UuidValue? userId,
    String? email,
    int? balanceCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberBalance',
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'balanceCents': balanceCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberBalance',
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'balanceCents': balanceCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberBalanceImpl extends MemberBalance {
  _MemberBalanceImpl({
    required _isc.UuidValue userId,
    String? email,
    required int balanceCents,
  }) : super._(
         userId: userId,
         email: email,
         balanceCents: balanceCents,
       );

  /// Returns a shallow copy of this [MemberBalance]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MemberBalance copyWith({
    _isc.UuidValue? userId,
    Object? email = _Undefined,
    int? balanceCents,
  }) {
    return MemberBalance(
      userId: userId ?? this.userId,
      email: email is String? ? email : this.email,
      balanceCents: balanceCents ?? this.balanceCents,
    );
  }
}
