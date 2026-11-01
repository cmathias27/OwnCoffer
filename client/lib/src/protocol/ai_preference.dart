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

/// A user's choice of AI: off by default (décision 0006).
abstract class AiPreference
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiPreference._({
    this.id,
    required this.authUserId,
    this.providerId,
    this.model,
    required this.enabled,
  });

  factory AiPreference({
    int? id,
    required _isc.UuidValue authUserId,
    int? providerId,
    String? model,
    required bool enabled,
  }) = _AiPreferenceImpl;

  factory AiPreference.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiPreference(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      providerId: jsonSerialization['providerId'] as int?,
      model: jsonSerialization['model'] as String?,
      enabled: _isc.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int? providerId;

  String? model;

  bool enabled;

  /// Returns a shallow copy of this [AiPreference]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiPreference copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? providerId,
    String? model,
    bool? enabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiPreference',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (providerId != null) 'providerId': providerId,
      if (model != null) 'model': model,
      'enabled': enabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiPreference',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (providerId != null) 'providerId': providerId,
      if (model != null) 'model': model,
      'enabled': enabled,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiPreferenceImpl extends AiPreference {
  _AiPreferenceImpl({
    int? id,
    required _isc.UuidValue authUserId,
    int? providerId,
    String? model,
    required bool enabled,
  }) : super._(
         id: id,
         authUserId: authUserId,
         providerId: providerId,
         model: model,
         enabled: enabled,
       );

  /// Returns a shallow copy of this [AiPreference]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiPreference copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? providerId = _Undefined,
    Object? model = _Undefined,
    bool? enabled,
  }) {
    return AiPreference(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      providerId: providerId is int? ? providerId : this.providerId,
      model: model is String? ? model : this.model,
      enabled: enabled ?? this.enabled,
    );
  }
}
