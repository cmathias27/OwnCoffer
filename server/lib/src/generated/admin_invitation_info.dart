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

/// A pending invitation of any group, for the server administrator (no
/// token).
abstract class AdminInvitationInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminInvitationInfo._({
    required this.id,
    this.groupId,
    this.groupName,
    required this.email,
    required this.role,
    required this.serverAdmin,
    required this.createdAt,
    required this.expiresAt,
    this.invitedBy,
  });

  factory AdminInvitationInfo({
    required int id,
    int? groupId,
    String? groupName,
    required String email,
    required _insyygng.MemberRole role,
    required bool serverAdmin,
    required DateTime createdAt,
    required DateTime expiresAt,
    String? invitedBy,
  }) = _AdminInvitationInfoImpl;

  factory AdminInvitationInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminInvitationInfo(
      id: jsonSerialization['id'] as int,
      groupId: jsonSerialization['groupId'] as int?,
      groupName: jsonSerialization['groupName'] as String?,
      email: jsonSerialization['email'] as String,
      role: _insyygng.MemberRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      serverAdmin: _is.BoolJsonExtension.fromJson(
        jsonSerialization['serverAdmin'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      invitedBy: jsonSerialization['invitedBy'] as String?,
    );
  }

  int id;

  int? groupId;

  String? groupName;

  String email;

  _insyygng.MemberRole role;

  bool serverAdmin;

  DateTime createdAt;

  DateTime expiresAt;

  String? invitedBy;

  /// Returns a shallow copy of this [AdminInvitationInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminInvitationInfo copyWith({
    int? id,
    int? groupId,
    String? groupName,
    String? email,
    _insyygng.MemberRole? role,
    bool? serverAdmin,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? invitedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminInvitationInfo',
      'id': id,
      if (groupId != null) 'groupId': groupId,
      if (groupName != null) 'groupName': groupName,
      'email': email,
      'role': role.toJson(),
      'serverAdmin': serverAdmin,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (invitedBy != null) 'invitedBy': invitedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminInvitationInfo',
      'id': id,
      if (groupId != null) 'groupId': groupId,
      if (groupName != null) 'groupName': groupName,
      'email': email,
      'role': role.toJson(),
      'serverAdmin': serverAdmin,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (invitedBy != null) 'invitedBy': invitedBy,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminInvitationInfoImpl extends AdminInvitationInfo {
  _AdminInvitationInfoImpl({
    required int id,
    int? groupId,
    String? groupName,
    required String email,
    required _insyygng.MemberRole role,
    required bool serverAdmin,
    required DateTime createdAt,
    required DateTime expiresAt,
    String? invitedBy,
  }) : super._(
         id: id,
         groupId: groupId,
         groupName: groupName,
         email: email,
         role: role,
         serverAdmin: serverAdmin,
         createdAt: createdAt,
         expiresAt: expiresAt,
         invitedBy: invitedBy,
       );

  /// Returns a shallow copy of this [AdminInvitationInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminInvitationInfo copyWith({
    int? id,
    Object? groupId = _Undefined,
    Object? groupName = _Undefined,
    String? email,
    _insyygng.MemberRole? role,
    bool? serverAdmin,
    DateTime? createdAt,
    DateTime? expiresAt,
    Object? invitedBy = _Undefined,
  }) {
    return AdminInvitationInfo(
      id: id ?? this.id,
      groupId: groupId is int? ? groupId : this.groupId,
      groupName: groupName is String? ? groupName : this.groupName,
      email: email ?? this.email,
      role: role ?? this.role,
      serverAdmin: serverAdmin ?? this.serverAdmin,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      invitedBy: invitedBy is String? ? invitedBy : this.invitedBy,
    );
  }
}
