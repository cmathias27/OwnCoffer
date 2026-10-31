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
import 'package:owncoffer_server/src/generated/protocol.dart' as _itdod8fx;
import 'package:serverpod/serverpod.dart' as _is;
import 'backup_info.dart' as _i73uehc4;

/// Backups as reported by the host scripts through docker/state/.
abstract class BackupOverview
    implements _is.SerializableModel, _is.ProtocolSerialization {
  BackupOverview._({
    required this.available,
    required this.backups,
    this.lastAt,
    this.lastLabel,
    this.lastOk,
    this.lastMessage,
    this.lastDailyAt,
    required this.requestPending,
  });

  factory BackupOverview({
    required bool available,
    required List<_i73uehc4.BackupInfo> backups,
    DateTime? lastAt,
    String? lastLabel,
    bool? lastOk,
    String? lastMessage,
    DateTime? lastDailyAt,
    required bool requestPending,
  }) = _BackupOverviewImpl;

  factory BackupOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return BackupOverview(
      available: _is.BoolJsonExtension.fromJson(jsonSerialization['available']),
      backups: _itdod8fx.Protocol().deserialize<List<_i73uehc4.BackupInfo>>(
        jsonSerialization['backups'],
      ),
      lastAt: jsonSerialization['lastAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastAt']),
      lastLabel: jsonSerialization['lastLabel'] as String?,
      lastOk: jsonSerialization['lastOk'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['lastOk']),
      lastMessage: jsonSerialization['lastMessage'] as String?,
      lastDailyAt: jsonSerialization['lastDailyAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastDailyAt'],
            ),
      requestPending: _is.BoolJsonExtension.fromJson(
        jsonSerialization['requestPending'],
      ),
    );
  }

  /// The shared folder is mounted (false: older installation, or a
  /// development server).
  bool available;

  /// Newest first.
  List<_i73uehc4.BackupInfo> backups;

  DateTime? lastAt;

  String? lastLabel;

  bool? lastOk;

  String? lastMessage;

  /// Newest nightly backup.
  DateTime? lastDailyAt;

  /// A manual backup was asked for and not yet carried out.
  bool requestPending;

  /// Returns a shallow copy of this [BackupOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BackupOverview copyWith({
    bool? available,
    List<_i73uehc4.BackupInfo>? backups,
    DateTime? lastAt,
    String? lastLabel,
    bool? lastOk,
    String? lastMessage,
    DateTime? lastDailyAt,
    bool? requestPending,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BackupOverview',
      'available': available,
      'backups': backups.toJson(valueToJson: (v) => v.toJson()),
      if (lastAt != null) 'lastAt': lastAt?.toJson(),
      if (lastLabel != null) 'lastLabel': lastLabel,
      if (lastOk != null) 'lastOk': lastOk,
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastDailyAt != null) 'lastDailyAt': lastDailyAt?.toJson(),
      'requestPending': requestPending,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BackupOverview',
      'available': available,
      'backups': backups.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (lastAt != null) 'lastAt': lastAt?.toJson(),
      if (lastLabel != null) 'lastLabel': lastLabel,
      if (lastOk != null) 'lastOk': lastOk,
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastDailyAt != null) 'lastDailyAt': lastDailyAt?.toJson(),
      'requestPending': requestPending,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BackupOverviewImpl extends BackupOverview {
  _BackupOverviewImpl({
    required bool available,
    required List<_i73uehc4.BackupInfo> backups,
    DateTime? lastAt,
    String? lastLabel,
    bool? lastOk,
    String? lastMessage,
    DateTime? lastDailyAt,
    required bool requestPending,
  }) : super._(
         available: available,
         backups: backups,
         lastAt: lastAt,
         lastLabel: lastLabel,
         lastOk: lastOk,
         lastMessage: lastMessage,
         lastDailyAt: lastDailyAt,
         requestPending: requestPending,
       );

  /// Returns a shallow copy of this [BackupOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BackupOverview copyWith({
    bool? available,
    List<_i73uehc4.BackupInfo>? backups,
    Object? lastAt = _Undefined,
    Object? lastLabel = _Undefined,
    Object? lastOk = _Undefined,
    Object? lastMessage = _Undefined,
    Object? lastDailyAt = _Undefined,
    bool? requestPending,
  }) {
    return BackupOverview(
      available: available ?? this.available,
      backups: backups ?? this.backups.map((e0) => e0.copyWith()).toList(),
      lastAt: lastAt is DateTime? ? lastAt : this.lastAt,
      lastLabel: lastLabel is String? ? lastLabel : this.lastLabel,
      lastOk: lastOk is bool? ? lastOk : this.lastOk,
      lastMessage: lastMessage is String? ? lastMessage : this.lastMessage,
      lastDailyAt: lastDailyAt is DateTime? ? lastDailyAt : this.lastDailyAt,
      requestPending: requestPending ?? this.requestPending,
    );
  }
}
