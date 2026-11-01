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

/// One message of a conversation with the assistant (user or assistant),
/// optionally with an image (a screenshot of a loan table, a receipt) for
/// a model that reads images.
abstract class AiMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiMessage._({
    required this.role,
    required this.content,
    this.imageBase64,
    this.imageMimeType,
  });

  factory AiMessage({
    required String role,
    required String content,
    String? imageBase64,
    String? imageMimeType,
  }) = _AiMessageImpl;

  factory AiMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiMessage(
      role: jsonSerialization['role'] as String,
      content: jsonSerialization['content'] as String,
      imageBase64: jsonSerialization['imageBase64'] as String?,
      imageMimeType: jsonSerialization['imageMimeType'] as String?,
    );
  }

  String role;

  String content;

  String? imageBase64;

  String? imageMimeType;

  /// Returns a shallow copy of this [AiMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiMessage copyWith({
    String? role,
    String? content,
    String? imageBase64,
    String? imageMimeType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiMessage',
      'role': role,
      'content': content,
      if (imageBase64 != null) 'imageBase64': imageBase64,
      if (imageMimeType != null) 'imageMimeType': imageMimeType,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiMessage',
      'role': role,
      'content': content,
      if (imageBase64 != null) 'imageBase64': imageBase64,
      if (imageMimeType != null) 'imageMimeType': imageMimeType,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiMessageImpl extends AiMessage {
  _AiMessageImpl({
    required String role,
    required String content,
    String? imageBase64,
    String? imageMimeType,
  }) : super._(
         role: role,
         content: content,
         imageBase64: imageBase64,
         imageMimeType: imageMimeType,
       );

  /// Returns a shallow copy of this [AiMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiMessage copyWith({
    String? role,
    String? content,
    Object? imageBase64 = _Undefined,
    Object? imageMimeType = _Undefined,
  }) {
    return AiMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      imageBase64: imageBase64 is String? ? imageBase64 : this.imageBase64,
      imageMimeType: imageMimeType is String?
          ? imageMimeType
          : this.imageMimeType,
    );
  }
}
