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

/// A past conversation with the assistant, kept on this server for its
/// user only (the latest 30), to read again or go on with. Text only.
abstract class AiConversation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiConversation._({
    this.id,
    required this.authUserId,
    required this.groupId,
    required this.title,
    required this.messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory AiConversation({
    int? id,
    required _isc.UuidValue authUserId,
    required int groupId,
    required String title,
    required String messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AiConversationImpl;

  factory AiConversation.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiConversation(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      groupId: jsonSerialization['groupId'] as int,
      title: jsonSerialization['title'] as String,
      messages: jsonSerialization['messages'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int groupId;

  String title;

  /// The messages as JSON: [{"role": "user" | "assistant", "content": …}].
  String messages;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AiConversation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiConversation copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? groupId,
    String? title,
    String? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiConversation',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'groupId': groupId,
      'title': title,
      'messages': messages,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiConversation',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'groupId': groupId,
      'title': title,
      'messages': messages,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiConversationImpl extends AiConversation {
  _AiConversationImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required int groupId,
    required String title,
    required String messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         groupId: groupId,
         title: title,
         messages: messages,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AiConversation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiConversation copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? groupId,
    String? title,
    String? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AiConversation(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
