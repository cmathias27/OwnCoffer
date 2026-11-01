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

/// A remark sent from the app to the server administrator (bug, idea,
/// question). Never sent outside the server; no bank data is joined.
abstract class UserFeedback
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserFeedback._({
    this.id,
    this.authUserId,
    required this.kind,
    required this.text,
    this.page,
    this.appVersion,
    required this.status,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserFeedback({
    int? id,
    _isc.UuidValue? authUserId,
    required String kind,
    required String text,
    String? page,
    String? appVersion,
    required String status,
    DateTime? createdAt,
  }) = _UserFeedbackImpl;

  factory UserFeedback.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserFeedback(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['authUserId'],
            ),
      kind: jsonSerialization['kind'] as String,
      text: jsonSerialization['text'] as String,
      page: jsonSerialization['page'] as String?,
      appVersion: jsonSerialization['appVersion'] as String?,
      status: jsonSerialization['status'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue? authUserId;

  /// bug, idea or question.
  String kind;

  String text;

  /// The page it was sent from, and the app's version.
  String? page;

  String? appVersion;

  /// open or done.
  String status;

  DateTime createdAt;

  /// Returns a shallow copy of this [UserFeedback]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserFeedback copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? kind,
    String? text,
    String? page,
    String? appVersion,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserFeedback',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      'kind': kind,
      'text': text,
      if (page != null) 'page': page,
      if (appVersion != null) 'appVersion': appVersion,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserFeedback',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      'kind': kind,
      'text': text,
      if (page != null) 'page': page,
      if (appVersion != null) 'appVersion': appVersion,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserFeedbackImpl extends UserFeedback {
  _UserFeedbackImpl({
    int? id,
    _isc.UuidValue? authUserId,
    required String kind,
    required String text,
    String? page,
    String? appVersion,
    required String status,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         kind: kind,
         text: text,
         page: page,
         appVersion: appVersion,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserFeedback]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserFeedback copyWith({
    Object? id = _Undefined,
    Object? authUserId = _Undefined,
    String? kind,
    String? text,
    Object? page = _Undefined,
    Object? appVersion = _Undefined,
    String? status,
    DateTime? createdAt,
  }) {
    return UserFeedback(
      id: id is int? ? id : this.id,
      authUserId: authUserId is _isc.UuidValue? ? authUserId : this.authUserId,
      kind: kind ?? this.kind,
      text: text ?? this.text,
      page: page is String? ? page : this.page,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
