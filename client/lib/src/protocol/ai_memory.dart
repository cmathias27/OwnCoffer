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

/// Something the user asked the assistant to keep in mind ("je suis payé
/// le 28", "ne me propose pas de changer de banque"). Written by the user
/// only, sent to the model with each question; seen by nobody else.
abstract class AiMemory
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiMemory._({
    this.id,
    required this.authUserId,
    required this.groupId,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AiMemory({
    int? id,
    required _isc.UuidValue authUserId,
    required int groupId,
    required String text,
    DateTime? createdAt,
  }) = _AiMemoryImpl;

  factory AiMemory.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiMemory(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      groupId: jsonSerialization['groupId'] as int,
      text: jsonSerialization['text'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int groupId;

  String text;

  DateTime createdAt;

  /// Returns a shallow copy of this [AiMemory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiMemory copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? groupId,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiMemory',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'groupId': groupId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiMemory',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'groupId': groupId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiMemoryImpl extends AiMemory {
  _AiMemoryImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required int groupId,
    required String text,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         groupId: groupId,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AiMemory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiMemory copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? groupId,
    String? text,
    DateTime? createdAt,
  }) {
    return AiMemory(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      groupId: groupId ?? this.groupId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
