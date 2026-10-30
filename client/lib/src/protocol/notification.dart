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

/// Notification shown in the app (and sent by email when relevant).
/// `data` holds the figures as JSON; texts are built by the app from `type`.
abstract class AppNotification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppNotification._({
    this.id,
    required this.authUserId,
    this.groupId,
    this.accountId,
    required this.type,
    required this.data,
    required this.dedupKey,
    DateTime? createdAt,
    this.readAt,
    this.emailedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AppNotification({
    int? id,
    required _isc.UuidValue authUserId,
    int? groupId,
    int? accountId,
    required String type,
    required String data,
    required String dedupKey,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? emailedAt,
  }) = _AppNotificationImpl;

  factory AppNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppNotification(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      groupId: jsonSerialization['groupId'] as int?,
      accountId: jsonSerialization['accountId'] as int?,
      type: jsonSerialization['type'] as String,
      data: jsonSerialization['data'] as String,
      dedupKey: jsonSerialization['dedupKey'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      emailedAt: jsonSerialization['emailedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['emailedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int? groupId;

  int? accountId;

  String type;

  String data;

  /// One notification per user and event (e.g. overdraft of an account on a
  /// given date), however often the forecast is recomputed.
  String dedupKey;

  DateTime createdAt;

  DateTime? readAt;

  DateTime? emailedAt;

  /// Returns a shallow copy of this [AppNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppNotification copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? groupId,
    int? accountId,
    String? type,
    String? data,
    String? dedupKey,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? emailedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppNotification',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (groupId != null) 'groupId': groupId,
      if (accountId != null) 'accountId': accountId,
      'type': type,
      'data': data,
      'dedupKey': dedupKey,
      'createdAt': createdAt.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (emailedAt != null) 'emailedAt': emailedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppNotification',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (groupId != null) 'groupId': groupId,
      if (accountId != null) 'accountId': accountId,
      'type': type,
      'data': data,
      'dedupKey': dedupKey,
      'createdAt': createdAt.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (emailedAt != null) 'emailedAt': emailedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppNotificationImpl extends AppNotification {
  _AppNotificationImpl({
    int? id,
    required _isc.UuidValue authUserId,
    int? groupId,
    int? accountId,
    required String type,
    required String data,
    required String dedupKey,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? emailedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         groupId: groupId,
         accountId: accountId,
         type: type,
         data: data,
         dedupKey: dedupKey,
         createdAt: createdAt,
         readAt: readAt,
         emailedAt: emailedAt,
       );

  /// Returns a shallow copy of this [AppNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppNotification copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? groupId = _Undefined,
    Object? accountId = _Undefined,
    String? type,
    String? data,
    String? dedupKey,
    DateTime? createdAt,
    Object? readAt = _Undefined,
    Object? emailedAt = _Undefined,
  }) {
    return AppNotification(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      groupId: groupId is int? ? groupId : this.groupId,
      accountId: accountId is int? ? accountId : this.accountId,
      type: type ?? this.type,
      data: data ?? this.data,
      dedupKey: dedupKey ?? this.dedupKey,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      emailedAt: emailedAt is DateTime? ? emailedAt : this.emailedAt,
    );
  }
}
