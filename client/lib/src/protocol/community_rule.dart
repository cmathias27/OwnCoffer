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
import 'rule_direction.dart' as _i13yq1r7;
import 'rule_match_type.dart' as _ibgrh3pe;

/// Local copy of the community rules base (CC0, decision 0013).
abstract class CommunityRule
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CommunityRule._({
    this.id,
    required this.ruleKey,
    required this.pattern,
    required this.matchType,
    _i13yq1r7.RuleDirection? direction,
    required this.standardCode,
    String? country,
    int? confidence,
    required this.baseVersion,
  }) : direction = direction ?? _i13yq1r7.RuleDirection.any,
       country = country ?? 'FR',
       confidence = confidence ?? 50;

  factory CommunityRule({
    int? id,
    required String ruleKey,
    required String pattern,
    required _ibgrh3pe.RuleMatchType matchType,
    _i13yq1r7.RuleDirection? direction,
    required String standardCode,
    String? country,
    int? confidence,
    required int baseVersion,
  }) = _CommunityRuleImpl;

  factory CommunityRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommunityRule(
      id: jsonSerialization['id'] as int?,
      ruleKey: jsonSerialization['ruleKey'] as String,
      pattern: jsonSerialization['pattern'] as String,
      matchType: _ibgrh3pe.RuleMatchType.fromJson(
        (jsonSerialization['matchType'] as String),
      ),
      direction: jsonSerialization['direction'] == null
          ? null
          : _i13yq1r7.RuleDirection.fromJson(
              (jsonSerialization['direction'] as String),
            ),
      standardCode: jsonSerialization['standardCode'] as String,
      country: jsonSerialization['country'] as String?,
      confidence: jsonSerialization['confidence'] as int?,
      baseVersion: jsonSerialization['baseVersion'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String ruleKey;

  String pattern;

  _ibgrh3pe.RuleMatchType matchType;

  _i13yq1r7.RuleDirection direction;

  String standardCode;

  String country;

  int confidence;

  int baseVersion;

  /// Returns a shallow copy of this [CommunityRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CommunityRule copyWith({
    int? id,
    String? ruleKey,
    String? pattern,
    _ibgrh3pe.RuleMatchType? matchType,
    _i13yq1r7.RuleDirection? direction,
    String? standardCode,
    String? country,
    int? confidence,
    int? baseVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CommunityRule',
      if (id != null) 'id': id,
      'ruleKey': ruleKey,
      'pattern': pattern,
      'matchType': matchType.toJson(),
      'direction': direction.toJson(),
      'standardCode': standardCode,
      'country': country,
      'confidence': confidence,
      'baseVersion': baseVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CommunityRule',
      if (id != null) 'id': id,
      'ruleKey': ruleKey,
      'pattern': pattern,
      'matchType': matchType.toJson(),
      'direction': direction.toJson(),
      'standardCode': standardCode,
      'country': country,
      'confidence': confidence,
      'baseVersion': baseVersion,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommunityRuleImpl extends CommunityRule {
  _CommunityRuleImpl({
    int? id,
    required String ruleKey,
    required String pattern,
    required _ibgrh3pe.RuleMatchType matchType,
    _i13yq1r7.RuleDirection? direction,
    required String standardCode,
    String? country,
    int? confidence,
    required int baseVersion,
  }) : super._(
         id: id,
         ruleKey: ruleKey,
         pattern: pattern,
         matchType: matchType,
         direction: direction,
         standardCode: standardCode,
         country: country,
         confidence: confidence,
         baseVersion: baseVersion,
       );

  /// Returns a shallow copy of this [CommunityRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CommunityRule copyWith({
    Object? id = _Undefined,
    String? ruleKey,
    String? pattern,
    _ibgrh3pe.RuleMatchType? matchType,
    _i13yq1r7.RuleDirection? direction,
    String? standardCode,
    String? country,
    int? confidence,
    int? baseVersion,
  }) {
    return CommunityRule(
      id: id is int? ? id : this.id,
      ruleKey: ruleKey ?? this.ruleKey,
      pattern: pattern ?? this.pattern,
      matchType: matchType ?? this.matchType,
      direction: direction ?? this.direction,
      standardCode: standardCode ?? this.standardCode,
      country: country ?? this.country,
      confidence: confidence ?? this.confidence,
      baseVersion: baseVersion ?? this.baseVersion,
    );
  }
}
