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

/// A classification rule of the group. `pattern` is normalised
/// (upper case, no accents) when saved.
abstract class Rule
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Rule._({
    this.id,
    required this.groupId,
    required this.categoryId,
    required this.matchType,
    required this.pattern,
    _i13yq1r7.RuleDirection? direction,
    this.minAbsCents,
    this.maxAbsCents,
    int? priority,
    bool? enabled,
    this.createdBy,
    DateTime? createdAt,
  }) : direction = direction ?? _i13yq1r7.RuleDirection.any,
       priority = priority ?? 100,
       enabled = enabled ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory Rule({
    int? id,
    required int groupId,
    required int categoryId,
    required _ibgrh3pe.RuleMatchType matchType,
    required String pattern,
    _i13yq1r7.RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    int? priority,
    bool? enabled,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  }) = _RuleImpl;

  factory Rule.fromJson(Map<String, dynamic> jsonSerialization) {
    return Rule(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      categoryId: jsonSerialization['categoryId'] as int,
      matchType: _ibgrh3pe.RuleMatchType.fromJson(
        (jsonSerialization['matchType'] as String),
      ),
      pattern: jsonSerialization['pattern'] as String,
      direction: jsonSerialization['direction'] == null
          ? null
          : _i13yq1r7.RuleDirection.fromJson(
              (jsonSerialization['direction'] as String),
            ),
      minAbsCents: jsonSerialization['minAbsCents'] as int?,
      maxAbsCents: jsonSerialization['maxAbsCents'] as int?,
      priority: jsonSerialization['priority'] as int?,
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      createdBy: jsonSerialization['createdBy'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['createdBy'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  int categoryId;

  _ibgrh3pe.RuleMatchType matchType;

  String pattern;

  _i13yq1r7.RuleDirection direction;

  int? minAbsCents;

  int? maxAbsCents;

  int priority;

  bool enabled;

  _isc.UuidValue? createdBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [Rule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Rule copyWith({
    int? id,
    int? groupId,
    int? categoryId,
    _ibgrh3pe.RuleMatchType? matchType,
    String? pattern,
    _i13yq1r7.RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    int? priority,
    bool? enabled,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Rule',
      if (id != null) 'id': id,
      'groupId': groupId,
      'categoryId': categoryId,
      'matchType': matchType.toJson(),
      'pattern': pattern,
      'direction': direction.toJson(),
      if (minAbsCents != null) 'minAbsCents': minAbsCents,
      if (maxAbsCents != null) 'maxAbsCents': maxAbsCents,
      'priority': priority,
      'enabled': enabled,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Rule',
      if (id != null) 'id': id,
      'groupId': groupId,
      'categoryId': categoryId,
      'matchType': matchType.toJson(),
      'pattern': pattern,
      'direction': direction.toJson(),
      if (minAbsCents != null) 'minAbsCents': minAbsCents,
      if (maxAbsCents != null) 'maxAbsCents': maxAbsCents,
      'priority': priority,
      'enabled': enabled,
      if (createdBy != null) 'createdBy': createdBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RuleImpl extends Rule {
  _RuleImpl({
    int? id,
    required int groupId,
    required int categoryId,
    required _ibgrh3pe.RuleMatchType matchType,
    required String pattern,
    _i13yq1r7.RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    int? priority,
    bool? enabled,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         categoryId: categoryId,
         matchType: matchType,
         pattern: pattern,
         direction: direction,
         minAbsCents: minAbsCents,
         maxAbsCents: maxAbsCents,
         priority: priority,
         enabled: enabled,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Rule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Rule copyWith({
    Object? id = _Undefined,
    int? groupId,
    int? categoryId,
    _ibgrh3pe.RuleMatchType? matchType,
    String? pattern,
    _i13yq1r7.RuleDirection? direction,
    Object? minAbsCents = _Undefined,
    Object? maxAbsCents = _Undefined,
    int? priority,
    bool? enabled,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
  }) {
    return Rule(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      categoryId: categoryId ?? this.categoryId,
      matchType: matchType ?? this.matchType,
      pattern: pattern ?? this.pattern,
      direction: direction ?? this.direction,
      minAbsCents: minAbsCents is int? ? minAbsCents : this.minAbsCents,
      maxAbsCents: maxAbsCents is int? ? maxAbsCents : this.maxAbsCents,
      priority: priority ?? this.priority,
      enabled: enabled ?? this.enabled,
      createdBy: createdBy is _isc.UuidValue? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
