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
import 'package:owncoffer_client/src/protocol/protocol.dart' as _iylp5nsw;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'ai_provider.dart' as _ibtxcndu;

/// What the AI page shows a user: the providers they may choose, their
/// choice, and their use this month.
abstract class AiStatus
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiStatus._({
    required this.providers,
    this.providerId,
    this.model,
    required this.enabled,
    required this.usedThisMonth,
    required this.canConfigure,
  });

  factory AiStatus({
    required List<_ibtxcndu.AiProvider> providers,
    int? providerId,
    String? model,
    required bool enabled,
    required int usedThisMonth,
    required bool canConfigure,
  }) = _AiStatusImpl;

  factory AiStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiStatus(
      providers: _iylp5nsw.Protocol().deserialize<List<_ibtxcndu.AiProvider>>(
        jsonSerialization['providers'],
      ),
      providerId: jsonSerialization['providerId'] as int?,
      model: jsonSerialization['model'] as String?,
      enabled: _isc.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      usedThisMonth: jsonSerialization['usedThisMonth'] as int,
      canConfigure: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['canConfigure'],
      ),
    );
  }

  List<_ibtxcndu.AiProvider> providers;

  int? providerId;

  String? model;

  bool enabled;

  int usedThisMonth;

  /// The user may set up providers (server administrator).
  bool canConfigure;

  /// Returns a shallow copy of this [AiStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiStatus copyWith({
    List<_ibtxcndu.AiProvider>? providers,
    int? providerId,
    String? model,
    bool? enabled,
    int? usedThisMonth,
    bool? canConfigure,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiStatus',
      'providers': providers.toJson(valueToJson: (v) => v.toJson()),
      if (providerId != null) 'providerId': providerId,
      if (model != null) 'model': model,
      'enabled': enabled,
      'usedThisMonth': usedThisMonth,
      'canConfigure': canConfigure,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiStatus',
      'providers': providers.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (providerId != null) 'providerId': providerId,
      if (model != null) 'model': model,
      'enabled': enabled,
      'usedThisMonth': usedThisMonth,
      'canConfigure': canConfigure,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiStatusImpl extends AiStatus {
  _AiStatusImpl({
    required List<_ibtxcndu.AiProvider> providers,
    int? providerId,
    String? model,
    required bool enabled,
    required int usedThisMonth,
    required bool canConfigure,
  }) : super._(
         providers: providers,
         providerId: providerId,
         model: model,
         enabled: enabled,
         usedThisMonth: usedThisMonth,
         canConfigure: canConfigure,
       );

  /// Returns a shallow copy of this [AiStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiStatus copyWith({
    List<_ibtxcndu.AiProvider>? providers,
    Object? providerId = _Undefined,
    Object? model = _Undefined,
    bool? enabled,
    int? usedThisMonth,
    bool? canConfigure,
  }) {
    return AiStatus(
      providers:
          providers ?? this.providers.map((e0) => e0.copyWith()).toList(),
      providerId: providerId is int? ? providerId : this.providerId,
      model: model is String? ? model : this.model,
      enabled: enabled ?? this.enabled,
      usedThisMonth: usedThisMonth ?? this.usedThisMonth,
      canConfigure: canConfigure ?? this.canConfigure,
    );
  }
}
