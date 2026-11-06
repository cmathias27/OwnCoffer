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

/// What the app shows of Pépite (decision 0026).
abstract class PepiteStatus
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PepiteStatus._({
    required this.seeds,
    required this.weeks,
    required this.doneThisWeek,
    this.firstRitualAt,
    this.lastRitualAt,
    required this.badges,
    required this.earnedSeeds,
    required this.newBadges,
  });

  factory PepiteStatus({
    required int seeds,
    required int weeks,
    required bool doneThisWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
    required List<String> badges,
    required int earnedSeeds,
    required List<String> newBadges,
  }) = _PepiteStatusImpl;

  factory PepiteStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteStatus(
      seeds: jsonSerialization['seeds'] as int,
      weeks: jsonSerialization['weeks'] as int,
      doneThisWeek: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['doneThisWeek'],
      ),
      firstRitualAt: jsonSerialization['firstRitualAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstRitualAt'],
            ),
      lastRitualAt: jsonSerialization['lastRitualAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastRitualAt'],
            ),
      badges: _iylp5nsw.Protocol().deserialize<List<String>>(
        jsonSerialization['badges'],
      ),
      earnedSeeds: jsonSerialization['earnedSeeds'] as int,
      newBadges: _iylp5nsw.Protocol().deserialize<List<String>>(
        jsonSerialization['newBadges'],
      ),
    );
  }

  int seeds;

  int weeks;

  bool doneThisWeek;

  DateTime? firstRitualAt;

  DateTime? lastRitualAt;

  /// Codes of the badges earned, oldest first.
  List<String> badges;

  /// Just now: seeds added and badges earned by this call (to celebrate).
  int earnedSeeds;

  List<String> newBadges;

  /// Returns a shallow copy of this [PepiteStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PepiteStatus copyWith({
    int? seeds,
    int? weeks,
    bool? doneThisWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
    List<String>? badges,
    int? earnedSeeds,
    List<String>? newBadges,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteStatus',
      'seeds': seeds,
      'weeks': weeks,
      'doneThisWeek': doneThisWeek,
      if (firstRitualAt != null) 'firstRitualAt': firstRitualAt?.toJson(),
      if (lastRitualAt != null) 'lastRitualAt': lastRitualAt?.toJson(),
      'badges': badges.toJson(),
      'earnedSeeds': earnedSeeds,
      'newBadges': newBadges.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PepiteStatus',
      'seeds': seeds,
      'weeks': weeks,
      'doneThisWeek': doneThisWeek,
      if (firstRitualAt != null) 'firstRitualAt': firstRitualAt?.toJson(),
      if (lastRitualAt != null) 'lastRitualAt': lastRitualAt?.toJson(),
      'badges': badges.toJson(),
      'earnedSeeds': earnedSeeds,
      'newBadges': newBadges.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteStatusImpl extends PepiteStatus {
  _PepiteStatusImpl({
    required int seeds,
    required int weeks,
    required bool doneThisWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
    required List<String> badges,
    required int earnedSeeds,
    required List<String> newBadges,
  }) : super._(
         seeds: seeds,
         weeks: weeks,
         doneThisWeek: doneThisWeek,
         firstRitualAt: firstRitualAt,
         lastRitualAt: lastRitualAt,
         badges: badges,
         earnedSeeds: earnedSeeds,
         newBadges: newBadges,
       );

  /// Returns a shallow copy of this [PepiteStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PepiteStatus copyWith({
    int? seeds,
    int? weeks,
    bool? doneThisWeek,
    Object? firstRitualAt = _Undefined,
    Object? lastRitualAt = _Undefined,
    List<String>? badges,
    int? earnedSeeds,
    List<String>? newBadges,
  }) {
    return PepiteStatus(
      seeds: seeds ?? this.seeds,
      weeks: weeks ?? this.weeks,
      doneThisWeek: doneThisWeek ?? this.doneThisWeek,
      firstRitualAt: firstRitualAt is DateTime?
          ? firstRitualAt
          : this.firstRitualAt,
      lastRitualAt: lastRitualAt is DateTime?
          ? lastRitualAt
          : this.lastRitualAt,
      badges: badges ?? this.badges.map((e0) => e0).toList(),
      earnedSeeds: earnedSeeds ?? this.earnedSeeds,
      newBadges: newBadges ?? this.newBadges.map((e0) => e0).toList(),
    );
  }
}
