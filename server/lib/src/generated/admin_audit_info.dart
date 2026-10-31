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

/// One line of the audit log for the server administrator: who did what
/// and when, without the before / after snapshots (they may hold a group's
/// data).
abstract class AdminAuditInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminAuditInfo._({
    required this.createdAt,
    required this.action,
    required this.entity,
    this.email,
    this.groupId,
  });

  factory AdminAuditInfo({
    required DateTime createdAt,
    required String action,
    required String entity,
    String? email,
    int? groupId,
  }) = _AdminAuditInfoImpl;

  factory AdminAuditInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditInfo(
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      action: jsonSerialization['action'] as String,
      entity: jsonSerialization['entity'] as String,
      email: jsonSerialization['email'] as String?,
      groupId: jsonSerialization['groupId'] as int?,
    );
  }

  DateTime createdAt;

  String action;

  String entity;

  String? email;

  int? groupId;

  /// Returns a shallow copy of this [AdminAuditInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminAuditInfo copyWith({
    DateTime? createdAt,
    String? action,
    String? entity,
    String? email,
    int? groupId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditInfo',
      'createdAt': createdAt.toJson(),
      'action': action,
      'entity': entity,
      if (email != null) 'email': email,
      if (groupId != null) 'groupId': groupId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAuditInfo',
      'createdAt': createdAt.toJson(),
      'action': action,
      'entity': entity,
      if (email != null) 'email': email,
      if (groupId != null) 'groupId': groupId,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditInfoImpl extends AdminAuditInfo {
  _AdminAuditInfoImpl({
    required DateTime createdAt,
    required String action,
    required String entity,
    String? email,
    int? groupId,
  }) : super._(
         createdAt: createdAt,
         action: action,
         entity: entity,
         email: email,
         groupId: groupId,
       );

  /// Returns a shallow copy of this [AdminAuditInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminAuditInfo copyWith({
    DateTime? createdAt,
    String? action,
    String? entity,
    Object? email = _Undefined,
    Object? groupId = _Undefined,
  }) {
    return AdminAuditInfo(
      createdAt: createdAt ?? this.createdAt,
      action: action ?? this.action,
      entity: entity ?? this.entity,
      email: email is String? ? email : this.email,
      groupId: groupId is int? ? groupId : this.groupId,
    );
  }
}
