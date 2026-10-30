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

/// Invitation as shown to group admins (no token).
abstract class InvitationInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InvitationInfo._({
    required this.id,
    required this.groupId,
    required this.email,
    required this.role,
    required this.expiresAt,
    required this.createdAt,
  });

  factory InvitationInfo({
    required int id,
    required int groupId,
    required String email,
    required _insyygng.MemberRole role,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _InvitationInfoImpl;

  factory InvitationInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvitationInfo(
      id: jsonSerialization['id'] as int,
      groupId: jsonSerialization['groupId'] as int,
      email: jsonSerialization['email'] as String,
      role: _insyygng.MemberRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int groupId;

  String email;

  _insyygng.MemberRole role;

  DateTime expiresAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [InvitationInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InvitationInfo copyWith({
    int? id,
    int? groupId,
    String? email,
    _insyygng.MemberRole? role,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvitationInfo',
      'id': id,
      'groupId': groupId,
      'email': email,
      'role': role.toJson(),
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvitationInfo',
      'id': id,
      'groupId': groupId,
      'email': email,
      'role': role.toJson(),
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _InvitationInfoImpl extends InvitationInfo {
  _InvitationInfoImpl({
    required int id,
    required int groupId,
    required String email,
    required _insyygng.MemberRole role,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         email: email,
         role: role,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [InvitationInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InvitationInfo copyWith({
    int? id,
    int? groupId,
    String? email,
    _insyygng.MemberRole? role,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return InvitationInfo(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      email: email ?? this.email,
      role: role ?? this.role,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
