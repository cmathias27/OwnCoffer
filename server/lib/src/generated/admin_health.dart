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

/// State of the server (server administrator only).
abstract class AdminHealth
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminHealth._({
    required this.version,
    required this.startedAt,
    required this.serverTime,
    required this.databaseOk,
    this.databaseBytes,
    required this.documentsBytes,
    required this.smtpConfigured,
    required this.publicUrl,
    this.alertsRunAt,
    this.alertsRunOk,
    this.diskTotalBytes,
    this.diskFreeBytes,
    this.diskAt,
  });

  factory AdminHealth({
    required String version,
    required DateTime startedAt,
    required DateTime serverTime,
    required bool databaseOk,
    int? databaseBytes,
    required int documentsBytes,
    required bool smtpConfigured,
    required String publicUrl,
    DateTime? alertsRunAt,
    bool? alertsRunOk,
    int? diskTotalBytes,
    int? diskFreeBytes,
    DateTime? diskAt,
  }) = _AdminHealthImpl;

  factory AdminHealth.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminHealth(
      version: jsonSerialization['version'] as String,
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      serverTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      databaseOk: _is.BoolJsonExtension.fromJson(
        jsonSerialization['databaseOk'],
      ),
      databaseBytes: jsonSerialization['databaseBytes'] as int?,
      documentsBytes: jsonSerialization['documentsBytes'] as int,
      smtpConfigured: _is.BoolJsonExtension.fromJson(
        jsonSerialization['smtpConfigured'],
      ),
      publicUrl: jsonSerialization['publicUrl'] as String,
      alertsRunAt: jsonSerialization['alertsRunAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['alertsRunAt'],
            ),
      alertsRunOk: jsonSerialization['alertsRunOk'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['alertsRunOk']),
      diskTotalBytes: jsonSerialization['diskTotalBytes'] as int?,
      diskFreeBytes: jsonSerialization['diskFreeBytes'] as int?,
      diskAt: jsonSerialization['diskAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['diskAt']),
    );
  }

  /// Installed version ("dev" outside a published image).
  String version;

  DateTime startedAt;

  DateTime serverTime;

  bool databaseOk;

  int? databaseBytes;

  /// Files kept in the database (loan documents and invoices).
  int documentsBytes;

  bool smtpConfigured;

  String publicUrl;

  /// Last run of the hourly alert job, and whether it went through.
  DateTime? alertsRunAt;

  bool? alertsRunOk;

  /// Disk holding the installation, as the host saw it at its last run
  /// (every 15 minutes); null without the shared folder.
  int? diskTotalBytes;

  int? diskFreeBytes;

  DateTime? diskAt;

  /// Returns a shallow copy of this [AdminHealth]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminHealth copyWith({
    String? version,
    DateTime? startedAt,
    DateTime? serverTime,
    bool? databaseOk,
    int? databaseBytes,
    int? documentsBytes,
    bool? smtpConfigured,
    String? publicUrl,
    DateTime? alertsRunAt,
    bool? alertsRunOk,
    int? diskTotalBytes,
    int? diskFreeBytes,
    DateTime? diskAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminHealth',
      'version': version,
      'startedAt': startedAt.toJson(),
      'serverTime': serverTime.toJson(),
      'databaseOk': databaseOk,
      if (databaseBytes != null) 'databaseBytes': databaseBytes,
      'documentsBytes': documentsBytes,
      'smtpConfigured': smtpConfigured,
      'publicUrl': publicUrl,
      if (alertsRunAt != null) 'alertsRunAt': alertsRunAt?.toJson(),
      if (alertsRunOk != null) 'alertsRunOk': alertsRunOk,
      if (diskTotalBytes != null) 'diskTotalBytes': diskTotalBytes,
      if (diskFreeBytes != null) 'diskFreeBytes': diskFreeBytes,
      if (diskAt != null) 'diskAt': diskAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminHealth',
      'version': version,
      'startedAt': startedAt.toJson(),
      'serverTime': serverTime.toJson(),
      'databaseOk': databaseOk,
      if (databaseBytes != null) 'databaseBytes': databaseBytes,
      'documentsBytes': documentsBytes,
      'smtpConfigured': smtpConfigured,
      'publicUrl': publicUrl,
      if (alertsRunAt != null) 'alertsRunAt': alertsRunAt?.toJson(),
      if (alertsRunOk != null) 'alertsRunOk': alertsRunOk,
      if (diskTotalBytes != null) 'diskTotalBytes': diskTotalBytes,
      if (diskFreeBytes != null) 'diskFreeBytes': diskFreeBytes,
      if (diskAt != null) 'diskAt': diskAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminHealthImpl extends AdminHealth {
  _AdminHealthImpl({
    required String version,
    required DateTime startedAt,
    required DateTime serverTime,
    required bool databaseOk,
    int? databaseBytes,
    required int documentsBytes,
    required bool smtpConfigured,
    required String publicUrl,
    DateTime? alertsRunAt,
    bool? alertsRunOk,
    int? diskTotalBytes,
    int? diskFreeBytes,
    DateTime? diskAt,
  }) : super._(
         version: version,
         startedAt: startedAt,
         serverTime: serverTime,
         databaseOk: databaseOk,
         databaseBytes: databaseBytes,
         documentsBytes: documentsBytes,
         smtpConfigured: smtpConfigured,
         publicUrl: publicUrl,
         alertsRunAt: alertsRunAt,
         alertsRunOk: alertsRunOk,
         diskTotalBytes: diskTotalBytes,
         diskFreeBytes: diskFreeBytes,
         diskAt: diskAt,
       );

  /// Returns a shallow copy of this [AdminHealth]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminHealth copyWith({
    String? version,
    DateTime? startedAt,
    DateTime? serverTime,
    bool? databaseOk,
    Object? databaseBytes = _Undefined,
    int? documentsBytes,
    bool? smtpConfigured,
    String? publicUrl,
    Object? alertsRunAt = _Undefined,
    Object? alertsRunOk = _Undefined,
    Object? diskTotalBytes = _Undefined,
    Object? diskFreeBytes = _Undefined,
    Object? diskAt = _Undefined,
  }) {
    return AdminHealth(
      version: version ?? this.version,
      startedAt: startedAt ?? this.startedAt,
      serverTime: serverTime ?? this.serverTime,
      databaseOk: databaseOk ?? this.databaseOk,
      databaseBytes: databaseBytes is int? ? databaseBytes : this.databaseBytes,
      documentsBytes: documentsBytes ?? this.documentsBytes,
      smtpConfigured: smtpConfigured ?? this.smtpConfigured,
      publicUrl: publicUrl ?? this.publicUrl,
      alertsRunAt: alertsRunAt is DateTime? ? alertsRunAt : this.alertsRunAt,
      alertsRunOk: alertsRunOk is bool? ? alertsRunOk : this.alertsRunOk,
      diskTotalBytes: diskTotalBytes is int?
          ? diskTotalBytes
          : this.diskTotalBytes,
      diskFreeBytes: diskFreeBytes is int? ? diskFreeBytes : this.diskFreeBytes,
      diskAt: diskAt is DateTime? ? diskAt : this.diskAt,
    );
  }
}
