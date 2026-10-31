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

/// One update attempt: installed, rollback, rollback-failed, refused.
abstract class UpdateHistoryEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UpdateHistoryEntry._({
    required this.at,
    required this.fromVersion,
    required this.toVersion,
    required this.result,
    this.message,
  });

  factory UpdateHistoryEntry({
    required DateTime at,
    required String fromVersion,
    required String toVersion,
    required String result,
    String? message,
  }) = _UpdateHistoryEntryImpl;

  factory UpdateHistoryEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return UpdateHistoryEntry(
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      fromVersion: jsonSerialization['fromVersion'] as String,
      toVersion: jsonSerialization['toVersion'] as String,
      result: jsonSerialization['result'] as String,
      message: jsonSerialization['message'] as String?,
    );
  }

  DateTime at;

  String fromVersion;

  String toVersion;

  String result;

  String? message;

  /// Returns a shallow copy of this [UpdateHistoryEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UpdateHistoryEntry copyWith({
    DateTime? at,
    String? fromVersion,
    String? toVersion,
    String? result,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpdateHistoryEntry',
      'at': at.toJson(),
      'fromVersion': fromVersion,
      'toVersion': toVersion,
      'result': result,
      if (message != null) 'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UpdateHistoryEntry',
      'at': at.toJson(),
      'fromVersion': fromVersion,
      'toVersion': toVersion,
      'result': result,
      if (message != null) 'message': message,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UpdateHistoryEntryImpl extends UpdateHistoryEntry {
  _UpdateHistoryEntryImpl({
    required DateTime at,
    required String fromVersion,
    required String toVersion,
    required String result,
    String? message,
  }) : super._(
         at: at,
         fromVersion: fromVersion,
         toVersion: toVersion,
         result: result,
         message: message,
       );

  /// Returns a shallow copy of this [UpdateHistoryEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UpdateHistoryEntry copyWith({
    DateTime? at,
    String? fromVersion,
    String? toVersion,
    String? result,
    Object? message = _Undefined,
  }) {
    return UpdateHistoryEntry(
      at: at ?? this.at,
      fromVersion: fromVersion ?? this.fromVersion,
      toVersion: toVersion ?? this.toVersion,
      result: result ?? this.result,
      message: message is String? ? message : this.message,
    );
  }
}
