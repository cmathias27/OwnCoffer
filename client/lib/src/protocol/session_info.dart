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

/// An open session, as shown in « Mes sessions » or to the server
/// administrator (decision 0027).
abstract class SessionInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SessionInfo._({
    required this.id,
    this.platform,
    this.appVersion,
    this.deviceLabel,
    this.ip,
    this.city,
    this.country,
    required this.connectedSince,
    required this.lastActiveAt,
    required this.current,
  });

  factory SessionInfo({
    required String id,
    String? platform,
    String? appVersion,
    String? deviceLabel,
    String? ip,
    String? city,
    String? country,
    required DateTime connectedSince,
    required DateTime lastActiveAt,
    required bool current,
  }) = _SessionInfoImpl;

  factory SessionInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionInfo(
      id: jsonSerialization['id'] as String,
      platform: jsonSerialization['platform'] as String?,
      appVersion: jsonSerialization['appVersion'] as String?,
      deviceLabel: jsonSerialization['deviceLabel'] as String?,
      ip: jsonSerialization['ip'] as String?,
      city: jsonSerialization['city'] as String?,
      country: jsonSerialization['country'] as String?,
      connectedSince: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['connectedSince'],
      ),
      lastActiveAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastActiveAt'],
      ),
      current: _isc.BoolJsonExtension.fromJson(jsonSerialization['current']),
    );
  }

  String id;

  /// Null when the app never said (older app, or not yet).
  String? platform;

  String? appVersion;

  String? deviceLabel;

  /// Whole for the person, masked (`82.64.x.x`) for the administrator.
  String? ip;

  String? city;

  String? country;

  /// When the session was opened (sign-in).
  DateTime connectedSince;

  DateTime lastActiveAt;

  /// The session this list is shown in.
  bool current;

  /// Returns a shallow copy of this [SessionInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SessionInfo copyWith({
    String? id,
    String? platform,
    String? appVersion,
    String? deviceLabel,
    String? ip,
    String? city,
    String? country,
    DateTime? connectedSince,
    DateTime? lastActiveAt,
    bool? current,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionInfo',
      'id': id,
      if (platform != null) 'platform': platform,
      if (appVersion != null) 'appVersion': appVersion,
      if (deviceLabel != null) 'deviceLabel': deviceLabel,
      if (ip != null) 'ip': ip,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      'connectedSince': connectedSince.toJson(),
      'lastActiveAt': lastActiveAt.toJson(),
      'current': current,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionInfo',
      'id': id,
      if (platform != null) 'platform': platform,
      if (appVersion != null) 'appVersion': appVersion,
      if (deviceLabel != null) 'deviceLabel': deviceLabel,
      if (ip != null) 'ip': ip,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      'connectedSince': connectedSince.toJson(),
      'lastActiveAt': lastActiveAt.toJson(),
      'current': current,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionInfoImpl extends SessionInfo {
  _SessionInfoImpl({
    required String id,
    String? platform,
    String? appVersion,
    String? deviceLabel,
    String? ip,
    String? city,
    String? country,
    required DateTime connectedSince,
    required DateTime lastActiveAt,
    required bool current,
  }) : super._(
         id: id,
         platform: platform,
         appVersion: appVersion,
         deviceLabel: deviceLabel,
         ip: ip,
         city: city,
         country: country,
         connectedSince: connectedSince,
         lastActiveAt: lastActiveAt,
         current: current,
       );

  /// Returns a shallow copy of this [SessionInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SessionInfo copyWith({
    String? id,
    Object? platform = _Undefined,
    Object? appVersion = _Undefined,
    Object? deviceLabel = _Undefined,
    Object? ip = _Undefined,
    Object? city = _Undefined,
    Object? country = _Undefined,
    DateTime? connectedSince,
    DateTime? lastActiveAt,
    bool? current,
  }) {
    return SessionInfo(
      id: id ?? this.id,
      platform: platform is String? ? platform : this.platform,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      deviceLabel: deviceLabel is String? ? deviceLabel : this.deviceLabel,
      ip: ip is String? ? ip : this.ip,
      city: city is String? ? city : this.city,
      country: country is String? ? country : this.country,
      connectedSince: connectedSince ?? this.connectedSince,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      current: current ?? this.current,
    );
  }
}
