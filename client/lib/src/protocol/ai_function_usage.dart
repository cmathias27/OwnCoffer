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

/// What a user's AI requests cost, per provider, month (yyyymm) and
/// function (decision 0048): requests and tokens as the provider reports
/// them. Nothing of the content is kept.
abstract class AiFunctionUsage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiFunctionUsage._({
    this.id,
    required this.authUserId,
    required this.providerId,
    required this.month,
    required this.feature,
    required this.requests,
    required this.inputTokens,
    required this.outputTokens,
  });

  factory AiFunctionUsage({
    int? id,
    required _isc.UuidValue authUserId,
    required int providerId,
    required int month,
    required String feature,
    required int requests,
    required int inputTokens,
    required int outputTokens,
  }) = _AiFunctionUsageImpl;

  factory AiFunctionUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiFunctionUsage(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      providerId: jsonSerialization['providerId'] as int,
      month: jsonSerialization['month'] as int,
      feature: jsonSerialization['feature'] as String,
      requests: jsonSerialization['requests'] as int,
      inputTokens: jsonSerialization['inputTokens'] as int,
      outputTokens: jsonSerialization['outputTokens'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int providerId;

  int month;

  /// chat, invoice or loan.
  String feature;

  int requests;

  int inputTokens;

  int outputTokens;

  /// Returns a shallow copy of this [AiFunctionUsage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiFunctionUsage copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? providerId,
    int? month,
    String? feature,
    int? requests,
    int? inputTokens,
    int? outputTokens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiFunctionUsage',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'providerId': providerId,
      'month': month,
      'feature': feature,
      'requests': requests,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiFunctionUsage',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'providerId': providerId,
      'month': month,
      'feature': feature,
      'requests': requests,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiFunctionUsageImpl extends AiFunctionUsage {
  _AiFunctionUsageImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required int providerId,
    required int month,
    required String feature,
    required int requests,
    required int inputTokens,
    required int outputTokens,
  }) : super._(
         id: id,
         authUserId: authUserId,
         providerId: providerId,
         month: month,
         feature: feature,
         requests: requests,
         inputTokens: inputTokens,
         outputTokens: outputTokens,
       );

  /// Returns a shallow copy of this [AiFunctionUsage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiFunctionUsage copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? providerId,
    int? month,
    String? feature,
    int? requests,
    int? inputTokens,
    int? outputTokens,
  }) {
    return AiFunctionUsage(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      providerId: providerId ?? this.providerId,
      month: month ?? this.month,
      feature: feature ?? this.feature,
      requests: requests ?? this.requests,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
    );
  }
}
