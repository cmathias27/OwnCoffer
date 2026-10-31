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
import 'package:owncoffer_server/src/generated/protocol.dart' as _itdod8fx;
import 'package:serverpod/serverpod.dart' as _is;
import 'member_role.dart' as _insyygng;

/// An account of the server, as shown to the server administrator (no
/// financial data).
abstract class AdminUserInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminUserInfo._({
    required this.authUserId,
    this.email,
    required this.createdAt,
    this.lastActiveAt,
    required this.twoFactor,
    required this.blocked,
    required this.serverAdmin,
    required this.groupNames,
    required this.roles,
  });

  factory AdminUserInfo({
    required _is.UuidValue authUserId,
    String? email,
    required DateTime createdAt,
    DateTime? lastActiveAt,
    required bool twoFactor,
    required bool blocked,
    required bool serverAdmin,
    required List<String> groupNames,
    required List<_insyygng.MemberRole> roles,
  }) = _AdminUserInfoImpl;

  factory AdminUserInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUserInfo(
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      email: jsonSerialization['email'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastActiveAt: jsonSerialization['lastActiveAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastActiveAt'],
            ),
      twoFactor: _is.BoolJsonExtension.fromJson(jsonSerialization['twoFactor']),
      blocked: _is.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
      serverAdmin: _is.BoolJsonExtension.fromJson(
        jsonSerialization['serverAdmin'],
      ),
      groupNames: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['groupNames'],
      ),
      roles: _itdod8fx.Protocol().deserialize<List<_insyygng.MemberRole>>(
        jsonSerialization['roles'],
      ),
    );
  }

  _is.UuidValue authUserId;

  String? email;

  DateTime createdAt;

  /// Last session refresh (sign-in or use of the app), if any.
  DateTime? lastActiveAt;

  bool twoFactor;

  bool blocked;

  bool serverAdmin;

  /// Groups and roles, same order.
  List<String> groupNames;

  List<_insyygng.MemberRole> roles;

  /// Returns a shallow copy of this [AdminUserInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUserInfo copyWith({
    _is.UuidValue? authUserId,
    String? email,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    bool? twoFactor,
    bool? blocked,
    bool? serverAdmin,
    List<String>? groupNames,
    List<_insyygng.MemberRole>? roles,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserInfo',
      'authUserId': authUserId.toJson(),
      if (email != null) 'email': email,
      'createdAt': createdAt.toJson(),
      if (lastActiveAt != null) 'lastActiveAt': lastActiveAt?.toJson(),
      'twoFactor': twoFactor,
      'blocked': blocked,
      'serverAdmin': serverAdmin,
      'groupNames': groupNames.toJson(),
      'roles': roles.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserInfo',
      'authUserId': authUserId.toJson(),
      if (email != null) 'email': email,
      'createdAt': createdAt.toJson(),
      if (lastActiveAt != null) 'lastActiveAt': lastActiveAt?.toJson(),
      'twoFactor': twoFactor,
      'blocked': blocked,
      'serverAdmin': serverAdmin,
      'groupNames': groupNames.toJson(),
      'roles': roles.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserInfoImpl extends AdminUserInfo {
  _AdminUserInfoImpl({
    required _is.UuidValue authUserId,
    String? email,
    required DateTime createdAt,
    DateTime? lastActiveAt,
    required bool twoFactor,
    required bool blocked,
    required bool serverAdmin,
    required List<String> groupNames,
    required List<_insyygng.MemberRole> roles,
  }) : super._(
         authUserId: authUserId,
         email: email,
         createdAt: createdAt,
         lastActiveAt: lastActiveAt,
         twoFactor: twoFactor,
         blocked: blocked,
         serverAdmin: serverAdmin,
         groupNames: groupNames,
         roles: roles,
       );

  /// Returns a shallow copy of this [AdminUserInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUserInfo copyWith({
    _is.UuidValue? authUserId,
    Object? email = _Undefined,
    DateTime? createdAt,
    Object? lastActiveAt = _Undefined,
    bool? twoFactor,
    bool? blocked,
    bool? serverAdmin,
    List<String>? groupNames,
    List<_insyygng.MemberRole>? roles,
  }) {
    return AdminUserInfo(
      authUserId: authUserId ?? this.authUserId,
      email: email is String? ? email : this.email,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt is DateTime?
          ? lastActiveAt
          : this.lastActiveAt,
      twoFactor: twoFactor ?? this.twoFactor,
      blocked: blocked ?? this.blocked,
      serverAdmin: serverAdmin ?? this.serverAdmin,
      groupNames: groupNames ?? this.groupNames.map((e0) => e0).toList(),
      roles: roles ?? this.roles.map((e0) => e0).toList(),
    );
  }
}
