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
import 'health_grade.dart' as _ifqi9prv;

abstract class HealthIndicatorInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  HealthIndicatorInfo._({
    required this.key,
    required this.grade,
    this.value,
  });

  factory HealthIndicatorInfo({
    required String key,
    required _ifqi9prv.HealthGrade grade,
    int? value,
  }) = _HealthIndicatorInfoImpl;

  factory HealthIndicatorInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthIndicatorInfo(
      key: jsonSerialization['key'] as String,
      grade: _ifqi9prv.HealthGrade.fromJson(
        (jsonSerialization['grade'] as String),
      ),
      value: jsonSerialization['value'] as int?,
    );
  }

  /// emergency, savingsRate, debt or regularity.
  String key;

  _ifqi9prv.HealthGrade grade;

  /// Tenths of a month (emergency), per mille (savingsRate, debt) or months
  /// without overspending (regularity).
  int? value;

  /// Returns a shallow copy of this [HealthIndicatorInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  HealthIndicatorInfo copyWith({
    String? key,
    _ifqi9prv.HealthGrade? grade,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthIndicatorInfo',
      'key': key,
      'grade': grade.toJson(),
      if (value != null) 'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthIndicatorInfo',
      'key': key,
      'grade': grade.toJson(),
      if (value != null) 'value': value,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthIndicatorInfoImpl extends HealthIndicatorInfo {
  _HealthIndicatorInfoImpl({
    required String key,
    required _ifqi9prv.HealthGrade grade,
    int? value,
  }) : super._(
         key: key,
         grade: grade,
         value: value,
       );

  /// Returns a shallow copy of this [HealthIndicatorInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  HealthIndicatorInfo copyWith({
    String? key,
    _ifqi9prv.HealthGrade? grade,
    Object? value = _Undefined,
  }) {
    return HealthIndicatorInfo(
      key: key ?? this.key,
      grade: grade ?? this.grade,
      value: value is int? ? value : this.value,
    );
  }
}
