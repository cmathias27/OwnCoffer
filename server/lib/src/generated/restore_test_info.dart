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

/// Result of the last restore test of a backup into a throw-away database
/// (docker/restore-test.sh): a file name and counts, no bank data.
abstract class RestoreTestInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RestoreTestInfo._({
    required this.at,
    required this.ok,
    required this.file,
    this.tables,
    this.operations,
    this.seconds,
    this.message,
  });

  factory RestoreTestInfo({
    required DateTime at,
    required bool ok,
    required String file,
    int? tables,
    int? operations,
    int? seconds,
    String? message,
  }) = _RestoreTestInfoImpl;

  factory RestoreTestInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return RestoreTestInfo(
      at: _is.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      ok: _is.BoolJsonExtension.fromJson(jsonSerialization['ok']),
      file: jsonSerialization['file'] as String,
      tables: jsonSerialization['tables'] as int?,
      operations: jsonSerialization['operations'] as int?,
      seconds: jsonSerialization['seconds'] as int?,
      message: jsonSerialization['message'] as String?,
    );
  }

  DateTime at;

  bool ok;

  /// Backup tested.
  String file;

  int? tables;

  int? operations;

  int? seconds;

  String? message;

  /// Returns a shallow copy of this [RestoreTestInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RestoreTestInfo copyWith({
    DateTime? at,
    bool? ok,
    String? file,
    int? tables,
    int? operations,
    int? seconds,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RestoreTestInfo',
      'at': at.toJson(),
      'ok': ok,
      'file': file,
      if (tables != null) 'tables': tables,
      if (operations != null) 'operations': operations,
      if (seconds != null) 'seconds': seconds,
      if (message != null) 'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RestoreTestInfo',
      'at': at.toJson(),
      'ok': ok,
      'file': file,
      if (tables != null) 'tables': tables,
      if (operations != null) 'operations': operations,
      if (seconds != null) 'seconds': seconds,
      if (message != null) 'message': message,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestoreTestInfoImpl extends RestoreTestInfo {
  _RestoreTestInfoImpl({
    required DateTime at,
    required bool ok,
    required String file,
    int? tables,
    int? operations,
    int? seconds,
    String? message,
  }) : super._(
         at: at,
         ok: ok,
         file: file,
         tables: tables,
         operations: operations,
         seconds: seconds,
         message: message,
       );

  /// Returns a shallow copy of this [RestoreTestInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RestoreTestInfo copyWith({
    DateTime? at,
    bool? ok,
    String? file,
    Object? tables = _Undefined,
    Object? operations = _Undefined,
    Object? seconds = _Undefined,
    Object? message = _Undefined,
  }) {
    return RestoreTestInfo(
      at: at ?? this.at,
      ok: ok ?? this.ok,
      file: file ?? this.file,
      tables: tables is int? ? tables : this.tables,
      operations: operations is int? ? operations : this.operations,
      seconds: seconds is int? ? seconds : this.seconds,
      message: message is String? ? message : this.message,
    );
  }
}
