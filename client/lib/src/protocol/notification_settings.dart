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

/// What a user wants to be told, and how: one row per user, absent means
/// everything on (the default). An alert turned off in the app is not
/// created at all, so it is not emailed either.
abstract class NotificationSettings
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotificationSettings._({
    this.id,
    required this.authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  }) : overdraftApp = overdraftApp ?? true,
       overdraftEmail = overdraftEmail ?? true,
       goalWarning = goalWarning ?? true,
       goalOver = goalOver ?? true,
       goalForecast = goalForecast ?? true,
       warrantyApp = warrantyApp ?? true,
       warrantyEmail = warrantyEmail ?? true,
       updatedAt = updatedAt ?? DateTime.now();

  factory NotificationSettings({
    int? id,
    required _isc.UuidValue authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  }) = _NotificationSettingsImpl;

  factory NotificationSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationSettings(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      overdraftApp: jsonSerialization['overdraftApp'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['overdraftApp']),
      overdraftEmail: jsonSerialization['overdraftEmail'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['overdraftEmail'],
            ),
      goalWarning: jsonSerialization['goalWarning'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['goalWarning']),
      goalOver: jsonSerialization['goalOver'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['goalOver']),
      goalForecast: jsonSerialization['goalForecast'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['goalForecast']),
      warrantyApp: jsonSerialization['warrantyApp'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['warrantyApp']),
      warrantyEmail: jsonSerialization['warrantyEmail'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['warrantyEmail']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  /// Forecast overdraft of an account.
  bool overdraftApp;

  bool overdraftEmail;

  /// Goals: 80 %, 100 %, and overrun announced by the projection.
  bool goalWarning;

  bool goalOver;

  bool goalForecast;

  /// End of an invoice's warranty, a month before.
  bool warrantyApp;

  bool warrantyEmail;

  DateTime updatedAt;

  /// Returns a shallow copy of this [NotificationSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotificationSettings copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationSettings',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'overdraftApp': overdraftApp,
      'overdraftEmail': overdraftEmail,
      'goalWarning': goalWarning,
      'goalOver': goalOver,
      'goalForecast': goalForecast,
      'warrantyApp': warrantyApp,
      'warrantyEmail': warrantyEmail,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationSettings',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'overdraftApp': overdraftApp,
      'overdraftEmail': overdraftEmail,
      'goalWarning': goalWarning,
      'goalOver': goalOver,
      'goalForecast': goalForecast,
      'warrantyApp': warrantyApp,
      'warrantyEmail': warrantyEmail,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationSettingsImpl extends NotificationSettings {
  _NotificationSettingsImpl({
    int? id,
    required _isc.UuidValue authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         overdraftApp: overdraftApp,
         overdraftEmail: overdraftEmail,
         goalWarning: goalWarning,
         goalOver: goalOver,
         goalForecast: goalForecast,
         warrantyApp: warrantyApp,
         warrantyEmail: warrantyEmail,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotificationSettings copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    bool? overdraftApp,
    bool? overdraftEmail,
    bool? goalWarning,
    bool? goalOver,
    bool? goalForecast,
    bool? warrantyApp,
    bool? warrantyEmail,
    DateTime? updatedAt,
  }) {
    return NotificationSettings(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      overdraftApp: overdraftApp ?? this.overdraftApp,
      overdraftEmail: overdraftEmail ?? this.overdraftEmail,
      goalWarning: goalWarning ?? this.goalWarning,
      goalOver: goalOver ?? this.goalOver,
      goalForecast: goalForecast ?? this.goalForecast,
      warrantyApp: warrantyApp ?? this.warrantyApp,
      warrantyEmail: warrantyEmail ?? this.warrantyEmail,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
