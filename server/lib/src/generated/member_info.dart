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
import 'member_role.dart' as _insyygng;

/// A group member as shown in the app.
abstract class MemberInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MemberInfo._({
    required this.userId,
    this.email,
    required this.role,
    required this.joinedAt,
  });

  factory MemberInfo({
    required _is.UuidValue userId,
    String? email,
    required _insyygng.MemberRole role,
    required DateTime joinedAt,
  }) = _MemberInfoImpl;

  factory MemberInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberInfo(
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String?,
      role: _insyygng.MemberRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      joinedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
      ),
    );
  }

  _is.UuidValue userId;

  String? email;

  _insyygng.MemberRole role;

  DateTime joinedAt;

  /// Returns a shallow copy of this [MemberInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MemberInfo copyWith({
    _is.UuidValue? userId,
    String? email,
    _insyygng.MemberRole? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberInfo',
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'role': role.toJson(),
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberInfo',
      'userId': userId.toJson(),
      if (email != null) 'email': email,
      'role': role.toJson(),
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberInfoImpl extends MemberInfo {
  _MemberInfoImpl({
    required _is.UuidValue userId,
    String? email,
    required _insyygng.MemberRole role,
    required DateTime joinedAt,
  }) : super._(
         userId: userId,
         email: email,
         role: role,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [MemberInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MemberInfo copyWith({
    _is.UuidValue? userId,
    Object? email = _Undefined,
    _insyygng.MemberRole? role,
    DateTime? joinedAt,
  }) {
    return MemberInfo(
      userId: userId ?? this.userId,
      email: email is String? ? email : this.email,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
