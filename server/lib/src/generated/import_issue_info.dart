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

/// A problem found while reading a file (code translated by the app).
abstract class ImportIssueInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ImportIssueInfo._({
    required this.severity,
    required this.code,
    required this.line,
  });

  factory ImportIssueInfo({
    required String severity,
    required String code,
    required int line,
  }) = _ImportIssueInfoImpl;

  factory ImportIssueInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportIssueInfo(
      severity: jsonSerialization['severity'] as String,
      code: jsonSerialization['code'] as String,
      line: jsonSerialization['line'] as int,
    );
  }

  String severity;

  String code;

  int line;

  /// Returns a shallow copy of this [ImportIssueInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ImportIssueInfo copyWith({
    String? severity,
    String? code,
    int? line,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportIssueInfo',
      'severity': severity,
      'code': code,
      'line': line,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportIssueInfo',
      'severity': severity,
      'code': code,
      'line': line,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ImportIssueInfoImpl extends ImportIssueInfo {
  _ImportIssueInfoImpl({
    required String severity,
    required String code,
    required int line,
  }) : super._(
         severity: severity,
         code: code,
         line: line,
       );

  /// Returns a shallow copy of this [ImportIssueInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ImportIssueInfo copyWith({
    String? severity,
    String? code,
    int? line,
  }) {
    return ImportIssueInfo(
      severity: severity ?? this.severity,
      code: code ?? this.code,
      line: line ?? this.line,
    );
  }
}
