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

/// One line of the AI's use (decision 0048): a month, a provider and a
/// function, with the requests, the tokens and the estimated cost.
abstract class AiUsageLine
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AiUsageLine._({
    required this.month,
    required this.providerId,
    required this.providerName,
    required this.feature,
    required this.requests,
    required this.inputTokens,
    required this.outputTokens,
    this.costCents,
    required this.users,
  });

  factory AiUsageLine({
    required int month,
    required int providerId,
    required String providerName,
    required String feature,
    required int requests,
    required int inputTokens,
    required int outputTokens,
    int? costCents,
    required int users,
  }) = _AiUsageLineImpl;

  factory AiUsageLine.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiUsageLine(
      month: jsonSerialization['month'] as int,
      providerId: jsonSerialization['providerId'] as int,
      providerName: jsonSerialization['providerName'] as String,
      feature: jsonSerialization['feature'] as String,
      requests: jsonSerialization['requests'] as int,
      inputTokens: jsonSerialization['inputTokens'] as int,
      outputTokens: jsonSerialization['outputTokens'] as int,
      costCents: jsonSerialization['costCents'] as int?,
      users: jsonSerialization['users'] as int,
    );
  }

  /// yyyymm.
  int month;

  int providerId;

  String providerName;

  /// chat, invoice or loan.
  String feature;

  int requests;

  int inputTokens;

  int outputTokens;

  /// Estimated cost in cents; null when the provider has no price.
  int? costCents;

  /// How many users made these requests (server view only; 1 otherwise).
  int users;

  /// Returns a shallow copy of this [AiUsageLine]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiUsageLine copyWith({
    int? month,
    int? providerId,
    String? providerName,
    String? feature,
    int? requests,
    int? inputTokens,
    int? outputTokens,
    int? costCents,
    int? users,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiUsageLine',
      'month': month,
      'providerId': providerId,
      'providerName': providerName,
      'feature': feature,
      'requests': requests,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
      if (costCents != null) 'costCents': costCents,
      'users': users,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiUsageLine',
      'month': month,
      'providerId': providerId,
      'providerName': providerName,
      'feature': feature,
      'requests': requests,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
      if (costCents != null) 'costCents': costCents,
      'users': users,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiUsageLineImpl extends AiUsageLine {
  _AiUsageLineImpl({
    required int month,
    required int providerId,
    required String providerName,
    required String feature,
    required int requests,
    required int inputTokens,
    required int outputTokens,
    int? costCents,
    required int users,
  }) : super._(
         month: month,
         providerId: providerId,
         providerName: providerName,
         feature: feature,
         requests: requests,
         inputTokens: inputTokens,
         outputTokens: outputTokens,
         costCents: costCents,
         users: users,
       );

  /// Returns a shallow copy of this [AiUsageLine]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiUsageLine copyWith({
    int? month,
    int? providerId,
    String? providerName,
    String? feature,
    int? requests,
    int? inputTokens,
    int? outputTokens,
    Object? costCents = _Undefined,
    int? users,
  }) {
    return AiUsageLine(
      month: month ?? this.month,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      feature: feature ?? this.feature,
      requests: requests ?? this.requests,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
      costCents: costCents is int? ? costCents : this.costCents,
      users: users ?? this.users,
    );
  }
}
