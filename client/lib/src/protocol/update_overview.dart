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
import 'package:owncoffer_client/src/protocol/protocol.dart' as _iylp5nsw;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'release_notes.dart' as _idndmjo8;
import 'update_history_entry.dart' as _idu38kh6;

/// Versions and updates, as reported by the host scripts through
/// docker/state/ (server administrator only).
abstract class UpdateOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UpdateOverview._({
    required this.available,
    required this.runningVersion,
    this.current,
    this.latest,
    this.checkedAt,
    required this.auto,
    this.failedVersion,
    this.message,
    required this.requestPending,
    required this.history,
    required this.releases,
  });

  factory UpdateOverview({
    required bool available,
    required String runningVersion,
    String? current,
    String? latest,
    DateTime? checkedAt,
    required bool auto,
    String? failedVersion,
    String? message,
    required bool requestPending,
    required List<_idu38kh6.UpdateHistoryEntry> history,
    required List<_idndmjo8.ReleaseNotes> releases,
  }) = _UpdateOverviewImpl;

  factory UpdateOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return UpdateOverview(
      available: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['available'],
      ),
      runningVersion: jsonSerialization['runningVersion'] as String,
      current: jsonSerialization['current'] as String?,
      latest: jsonSerialization['latest'] as String?,
      checkedAt: jsonSerialization['checkedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['checkedAt']),
      auto: _isc.BoolJsonExtension.fromJson(jsonSerialization['auto']),
      failedVersion: jsonSerialization['failedVersion'] as String?,
      message: jsonSerialization['message'] as String?,
      requestPending: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['requestPending'],
      ),
      history: _iylp5nsw.Protocol()
          .deserialize<List<_idu38kh6.UpdateHistoryEntry>>(
            jsonSerialization['history'],
          ),
      releases: _iylp5nsw.Protocol().deserialize<List<_idndmjo8.ReleaseNotes>>(
        jsonSerialization['releases'],
      ),
    );
  }

  /// The shared folder is mounted and the update script wrote its state.
  bool available;

  /// Version running now (the app bundled in the image).
  String runningVersion;

  /// Installed and newest published versions seen by the host (vX.Y.Z).
  String? current;

  String? latest;

  DateTime? checkedAt;

  /// Automatic updates on (the page's choice; on by default).
  bool auto;

  /// A version that failed and was rolled back; not retried automatically.
  String? failedVersion;

  /// Why nothing was installed at the last check, if anything to say.
  String? message;

  /// A check or an installation was asked for and not yet carried out.
  bool requestPending;

  /// Newest first.
  List<_idu38kh6.UpdateHistoryEntry> history;

  /// Release notes, newest first (from the newest version's CHANGELOG).
  List<_idndmjo8.ReleaseNotes> releases;

  /// Returns a shallow copy of this [UpdateOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UpdateOverview copyWith({
    bool? available,
    String? runningVersion,
    String? current,
    String? latest,
    DateTime? checkedAt,
    bool? auto,
    String? failedVersion,
    String? message,
    bool? requestPending,
    List<_idu38kh6.UpdateHistoryEntry>? history,
    List<_idndmjo8.ReleaseNotes>? releases,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpdateOverview',
      'available': available,
      'runningVersion': runningVersion,
      if (current != null) 'current': current,
      if (latest != null) 'latest': latest,
      if (checkedAt != null) 'checkedAt': checkedAt?.toJson(),
      'auto': auto,
      if (failedVersion != null) 'failedVersion': failedVersion,
      if (message != null) 'message': message,
      'requestPending': requestPending,
      'history': history.toJson(valueToJson: (v) => v.toJson()),
      'releases': releases.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UpdateOverview',
      'available': available,
      'runningVersion': runningVersion,
      if (current != null) 'current': current,
      if (latest != null) 'latest': latest,
      if (checkedAt != null) 'checkedAt': checkedAt?.toJson(),
      'auto': auto,
      if (failedVersion != null) 'failedVersion': failedVersion,
      if (message != null) 'message': message,
      'requestPending': requestPending,
      'history': history.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'releases': releases.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UpdateOverviewImpl extends UpdateOverview {
  _UpdateOverviewImpl({
    required bool available,
    required String runningVersion,
    String? current,
    String? latest,
    DateTime? checkedAt,
    required bool auto,
    String? failedVersion,
    String? message,
    required bool requestPending,
    required List<_idu38kh6.UpdateHistoryEntry> history,
    required List<_idndmjo8.ReleaseNotes> releases,
  }) : super._(
         available: available,
         runningVersion: runningVersion,
         current: current,
         latest: latest,
         checkedAt: checkedAt,
         auto: auto,
         failedVersion: failedVersion,
         message: message,
         requestPending: requestPending,
         history: history,
         releases: releases,
       );

  /// Returns a shallow copy of this [UpdateOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UpdateOverview copyWith({
    bool? available,
    String? runningVersion,
    Object? current = _Undefined,
    Object? latest = _Undefined,
    Object? checkedAt = _Undefined,
    bool? auto,
    Object? failedVersion = _Undefined,
    Object? message = _Undefined,
    bool? requestPending,
    List<_idu38kh6.UpdateHistoryEntry>? history,
    List<_idndmjo8.ReleaseNotes>? releases,
  }) {
    return UpdateOverview(
      available: available ?? this.available,
      runningVersion: runningVersion ?? this.runningVersion,
      current: current is String? ? current : this.current,
      latest: latest is String? ? latest : this.latest,
      checkedAt: checkedAt is DateTime? ? checkedAt : this.checkedAt,
      auto: auto ?? this.auto,
      failedVersion: failedVersion is String?
          ? failedVersion
          : this.failedVersion,
      message: message is String? ? message : this.message,
      requestPending: requestPending ?? this.requestPending,
      history: history ?? this.history.map((e0) => e0.copyWith()).toList(),
      releases: releases ?? this.releases.map((e0) => e0.copyWith()).toList(),
    );
  }
}
