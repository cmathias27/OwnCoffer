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
import 'category_source.dart' as _idpjit5g;

/// What the classification would do for a label, without writing anything.
abstract class RuleTestResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RuleTestResult._({
    required this.cleanLabel,
    required this.operationKind,
    this.categoryId,
    required this.source,
    this.ruleRef,
  });

  factory RuleTestResult({
    required String cleanLabel,
    required String operationKind,
    int? categoryId,
    required _idpjit5g.CategorySource source,
    String? ruleRef,
  }) = _RuleTestResultImpl;

  factory RuleTestResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return RuleTestResult(
      cleanLabel: jsonSerialization['cleanLabel'] as String,
      operationKind: jsonSerialization['operationKind'] as String,
      categoryId: jsonSerialization['categoryId'] as int?,
      source: _idpjit5g.CategorySource.fromJson(
        (jsonSerialization['source'] as String),
      ),
      ruleRef: jsonSerialization['ruleRef'] as String?,
    );
  }

  String cleanLabel;

  String operationKind;

  int? categoryId;

  _idpjit5g.CategorySource source;

  /// Group rule id or community rule id, when a rule matched.
  String? ruleRef;

  /// Returns a shallow copy of this [RuleTestResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RuleTestResult copyWith({
    String? cleanLabel,
    String? operationKind,
    int? categoryId,
    _idpjit5g.CategorySource? source,
    String? ruleRef,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RuleTestResult',
      'cleanLabel': cleanLabel,
      'operationKind': operationKind,
      if (categoryId != null) 'categoryId': categoryId,
      'source': source.toJson(),
      if (ruleRef != null) 'ruleRef': ruleRef,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RuleTestResult',
      'cleanLabel': cleanLabel,
      'operationKind': operationKind,
      if (categoryId != null) 'categoryId': categoryId,
      'source': source.toJson(),
      if (ruleRef != null) 'ruleRef': ruleRef,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RuleTestResultImpl extends RuleTestResult {
  _RuleTestResultImpl({
    required String cleanLabel,
    required String operationKind,
    int? categoryId,
    required _idpjit5g.CategorySource source,
    String? ruleRef,
  }) : super._(
         cleanLabel: cleanLabel,
         operationKind: operationKind,
         categoryId: categoryId,
         source: source,
         ruleRef: ruleRef,
       );

  /// Returns a shallow copy of this [RuleTestResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RuleTestResult copyWith({
    String? cleanLabel,
    String? operationKind,
    Object? categoryId = _Undefined,
    _idpjit5g.CategorySource? source,
    Object? ruleRef = _Undefined,
  }) {
    return RuleTestResult(
      cleanLabel: cleanLabel ?? this.cleanLabel,
      operationKind: operationKind ?? this.operationKind,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      source: source ?? this.source,
      ruleRef: ruleRef is String? ? ruleRef : this.ruleRef,
    );
  }
}
