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

/// An AI provider set up by the server administrator (décision 0017): the
/// users choose among them. Its key is encrypted and never sent back.
abstract class AiProvider
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiProvider._({
    this.id,
    required this.name,
    required this.kind,
    required this.baseUrl,
    this.hasKey,
    required this.models,
    required this.toolCalling,
    required this.vision,
    required this.monthlyCap,
    required this.enabled,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AiProvider({
    int? id,
    required String name,
    required String kind,
    required String baseUrl,
    bool? hasKey,
    required String models,
    required bool toolCalling,
    required bool vision,
    required int monthlyCap,
    required bool enabled,
    DateTime? createdAt,
  }) = _AiProviderImpl;

  factory AiProvider.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiProvider(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      kind: jsonSerialization['kind'] as String,
      baseUrl: jsonSerialization['baseUrl'] as String,
      hasKey: jsonSerialization['hasKey'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['hasKey']),
      models: jsonSerialization['models'] as String,
      toolCalling: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['toolCalling'],
      ),
      vision: _isc.BoolJsonExtension.fromJson(jsonSerialization['vision']),
      monthlyCap: jsonSerialization['monthlyCap'] as int,
      enabled: _isc.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  /// openai (any API compatible with OpenAI's, external) or ollama (a
  /// model on this server or the local network).
  String kind;

  /// Base of the API, e.g. https://api.mistral.ai/v1 or
  /// http://192.168.1.10:11434/v1.
  String baseUrl;

  /// The key is set (the key itself never leaves the server).
  bool? hasKey;

  /// Models offered to the users, comma-separated.
  String models;

  /// Capabilities of its models (décision 0008): calling the engine's
  /// functions, reading images.
  bool toolCalling;

  bool vision;

  /// Requests per user and month; 0 means no limit.
  int monthlyCap;

  bool enabled;

  DateTime createdAt;

  /// Returns a shallow copy of this [AiProvider]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiProvider copyWith({
    int? id,
    String? name,
    String? kind,
    String? baseUrl,
    bool? hasKey,
    String? models,
    bool? toolCalling,
    bool? vision,
    int? monthlyCap,
    bool? enabled,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiProvider',
      if (id != null) 'id': id,
      'name': name,
      'kind': kind,
      'baseUrl': baseUrl,
      if (hasKey != null) 'hasKey': hasKey,
      'models': models,
      'toolCalling': toolCalling,
      'vision': vision,
      'monthlyCap': monthlyCap,
      'enabled': enabled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiProvider',
      if (id != null) 'id': id,
      'name': name,
      'kind': kind,
      'baseUrl': baseUrl,
      if (hasKey != null) 'hasKey': hasKey,
      'models': models,
      'toolCalling': toolCalling,
      'vision': vision,
      'monthlyCap': monthlyCap,
      'enabled': enabled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiProviderImpl extends AiProvider {
  _AiProviderImpl({
    int? id,
    required String name,
    required String kind,
    required String baseUrl,
    bool? hasKey,
    required String models,
    required bool toolCalling,
    required bool vision,
    required int monthlyCap,
    required bool enabled,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         kind: kind,
         baseUrl: baseUrl,
         hasKey: hasKey,
         models: models,
         toolCalling: toolCalling,
         vision: vision,
         monthlyCap: monthlyCap,
         enabled: enabled,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AiProvider]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiProvider copyWith({
    Object? id = _Undefined,
    String? name,
    String? kind,
    String? baseUrl,
    Object? hasKey = _Undefined,
    String? models,
    bool? toolCalling,
    bool? vision,
    int? monthlyCap,
    bool? enabled,
    DateTime? createdAt,
  }) {
    return AiProvider(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      baseUrl: baseUrl ?? this.baseUrl,
      hasKey: hasKey is bool? ? hasKey : this.hasKey,
      models: models ?? this.models,
      toolCalling: toolCalling ?? this.toolCalling,
      vision: vision ?? this.vision,
      monthlyCap: monthlyCap ?? this.monthlyCap,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
