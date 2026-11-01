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

/// Requests made by a user to a provider in a month (yyyymm), for the
/// monthly cap.
abstract class AiUsage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiUsage._({
    this.id,
    required this.authUserId,
    required this.providerId,
    required this.month,
    required this.requests,
  });

  factory AiUsage({
    int? id,
    required _isc.UuidValue authUserId,
    required int providerId,
    required int month,
    required int requests,
  }) = _AiUsageImpl;

  factory AiUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiUsage(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      providerId: jsonSerialization['providerId'] as int,
      month: jsonSerialization['month'] as int,
      requests: jsonSerialization['requests'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int providerId;

  int month;

  int requests;

  /// Returns a shallow copy of this [AiUsage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiUsage copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? providerId,
    int? month,
    int? requests,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiUsage',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'providerId': providerId,
      'month': month,
      'requests': requests,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiUsage',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'providerId': providerId,
      'month': month,
      'requests': requests,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiUsageImpl extends AiUsage {
  _AiUsageImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required int providerId,
    required int month,
    required int requests,
  }) : super._(
         id: id,
         authUserId: authUserId,
         providerId: providerId,
         month: month,
         requests: requests,
       );

  /// Returns a shallow copy of this [AiUsage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiUsage copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? providerId,
    int? month,
    int? requests,
  }) {
    return AiUsage(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      providerId: providerId ?? this.providerId,
      month: month ?? this.month,
      requests: requests ?? this.requests,
    );
  }
}
