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

/// A personal token letting an MCP client (an assistant on the user's
/// computer) use OwnCoffer's functions for one group, as this user
/// (décision 0018). Only its hash is kept; it can be revoked.
abstract class McpToken
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  McpToken._({
    this.id,
    required this.authUserId,
    required this.groupId,
    required this.name,
    required this.prefix,
    DateTime? createdAt,
    this.lastUsedAt,
    this.revokedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory McpToken({
    int? id,
    required _isc.UuidValue authUserId,
    required int groupId,
    required String name,
    required String prefix,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? revokedAt,
  }) = _McpTokenImpl;

  factory McpToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return McpToken(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      groupId: jsonSerialization['groupId'] as int,
      name: jsonSerialization['name'] as String,
      prefix: jsonSerialization['prefix'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastUsedAt: jsonSerialization['lastUsedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastUsedAt'],
            ),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int groupId;

  String name;

  /// The first characters, to recognise it in the list.
  String prefix;

  DateTime createdAt;

  DateTime? lastUsedAt;

  DateTime? revokedAt;

  /// Returns a shallow copy of this [McpToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  McpToken copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? groupId,
    String? name,
    String? prefix,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'McpToken',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'groupId': groupId,
      'name': name,
      'prefix': prefix,
      'createdAt': createdAt.toJson(),
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'McpToken',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'groupId': groupId,
      'name': name,
      'prefix': prefix,
      'createdAt': createdAt.toJson(),
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _McpTokenImpl extends McpToken {
  _McpTokenImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required int groupId,
    required String name,
    required String prefix,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         groupId: groupId,
         name: name,
         prefix: prefix,
         createdAt: createdAt,
         lastUsedAt: lastUsedAt,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [McpToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  McpToken copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? groupId,
    String? name,
    String? prefix,
    DateTime? createdAt,
    Object? lastUsedAt = _Undefined,
    Object? revokedAt = _Undefined,
  }) {
    return McpToken(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      prefix: prefix ?? this.prefix,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt is DateTime? ? lastUsedAt : this.lastUsedAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}
