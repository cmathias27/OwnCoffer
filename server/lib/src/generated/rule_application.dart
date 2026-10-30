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
import 'package:owncoffer_server/src/generated/protocol.dart' as _itdod8fx;
import 'package:serverpod/serverpod.dart' as _is;
import 'rule.dart' as _ivw87pdb;

/// Result of creating a rule from a correction.
abstract class RuleApplication
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RuleApplication._({
    required this.rule,
    required this.reclassifiedCount,
  });

  factory RuleApplication({
    required _ivw87pdb.Rule rule,
    required int reclassifiedCount,
  }) = _RuleApplicationImpl;

  factory RuleApplication.fromJson(Map<String, dynamic> jsonSerialization) {
    return RuleApplication(
      rule: _itdod8fx.Protocol().deserialize<_ivw87pdb.Rule>(
        jsonSerialization['rule'],
      ),
      reclassifiedCount: jsonSerialization['reclassifiedCount'] as int,
    );
  }

  _ivw87pdb.Rule rule;

  /// Existing operations reclassified by the new rule (manual choices are
  /// never overwritten).
  int reclassifiedCount;

  /// Returns a shallow copy of this [RuleApplication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RuleApplication copyWith({
    _ivw87pdb.Rule? rule,
    int? reclassifiedCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RuleApplication',
      'rule': rule.toJson(),
      'reclassifiedCount': reclassifiedCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RuleApplication',
      'rule': rule.toJsonForProtocol(),
      'reclassifiedCount': reclassifiedCount,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _RuleApplicationImpl extends RuleApplication {
  _RuleApplicationImpl({
    required _ivw87pdb.Rule rule,
    required int reclassifiedCount,
  }) : super._(
         rule: rule,
         reclassifiedCount: reclassifiedCount,
       );

  /// Returns a shallow copy of this [RuleApplication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RuleApplication copyWith({
    _ivw87pdb.Rule? rule,
    int? reclassifiedCount,
  }) {
    return RuleApplication(
      rule: rule ?? this.rule.copyWith(),
      reclassifiedCount: reclassifiedCount ?? this.reclassifiedCount,
    );
  }
}
