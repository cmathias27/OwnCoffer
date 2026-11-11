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

/// What the app shows of Pépite (decision 0026, 0028).
abstract class PepiteStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PepiteStatus._({
    required this.seeds,
    int? spentSeeds,
    required this.weeks,
    required this.doneThisWeek,
    this.firstRitualAt,
    this.lastRitualAt,
    required this.badges,
    required this.earnedSeeds,
    required this.newBadges,
    required this.items,
    required this.equipped,
    this.weekSteps,
  }) : spentSeeds = spentSeeds ?? 0;

  factory PepiteStatus({
    required int seeds,
    int? spentSeeds,
    required int weeks,
    required bool doneThisWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
    required List<String> badges,
    required int earnedSeeds,
    required List<String> newBadges,
    required List<String> items,
    required List<String> equipped,
    List<String>? weekSteps,
  }) = _PepiteStatusImpl;

  factory PepiteStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteStatus(
      seeds: jsonSerialization['seeds'] as int,
      spentSeeds: jsonSerialization['spentSeeds'] as int?,
      weeks: jsonSerialization['weeks'] as int,
      doneThisWeek: _is.BoolJsonExtension.fromJson(
        jsonSerialization['doneThisWeek'],
      ),
      firstRitualAt: jsonSerialization['firstRitualAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstRitualAt'],
            ),
      lastRitualAt: jsonSerialization['lastRitualAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastRitualAt'],
            ),
      badges: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['badges'],
      ),
      earnedSeeds: jsonSerialization['earnedSeeds'] as int,
      newBadges: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['newBadges'],
      ),
      items: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['items'],
      ),
      equipped: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['equipped'],
      ),
      weekSteps: jsonSerialization['weekSteps'] == null
          ? null
          : _itdod8fx.Protocol().deserialize<List<String>>(
              jsonSerialization['weekSteps'],
            ),
    );
  }

  int seeds;

  /// Seeds spent in the shop; available seeds = seeds - spentSeeds.
  int spentSeeds;

  int weeks;

  bool doneThisWeek;

  DateTime? firstRitualAt;

  DateTime? lastRitualAt;

  /// Codes of the badges earned, oldest first.
  List<String> badges;

  /// Just now: seeds added and badges earned by this call (to celebrate).
  int earnedSeeds;

  List<String> newBadges;

  /// Codes of acquired items in Pépite's shop.
  List<String> items;

  /// Codes of currently equipped items (accessory and/or burrow).
  List<String> equipped;

  /// Steps of this week's ritual seen in the data (decision 0029):
  /// `statements` (a statement imported by the user), `check` (an
  /// operation they changed). Null from an older server.
  List<String>? weekSteps;

  /// Returns a shallow copy of this [PepiteStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteStatus copyWith({
    int? seeds,
    int? spentSeeds,
    int? weeks,
    bool? doneThisWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
    List<String>? badges,
    int? earnedSeeds,
    List<String>? newBadges,
    List<String>? items,
    List<String>? equipped,
    List<String>? weekSteps,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteStatus',
      'seeds': seeds,
      'spentSeeds': spentSeeds,
      'weeks': weeks,
      'doneThisWeek': doneThisWeek,
      if (firstRitualAt != null) 'firstRitualAt': firstRitualAt?.toJson(),
      if (lastRitualAt != null) 'lastRitualAt': lastRitualAt?.toJson(),
      'badges': badges.toJson(),
      'earnedSeeds': earnedSeeds,
      'newBadges': newBadges.toJson(),
      'items': items.toJson(),
      'equipped': equipped.toJson(),
      if (weekSteps != null) 'weekSteps': weekSteps?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PepiteStatus',
      'seeds': seeds,
      'spentSeeds': spentSeeds,
      'weeks': weeks,
      'doneThisWeek': doneThisWeek,
      if (firstRitualAt != null) 'firstRitualAt': firstRitualAt?.toJson(),
      if (lastRitualAt != null) 'lastRitualAt': lastRitualAt?.toJson(),
      'badges': badges.toJson(),
      'earnedSeeds': earnedSeeds,
      'newBadges': newBadges.toJson(),
      'items': items.toJson(),
      'equipped': equipped.toJson(),
      if (weekSteps != null) 'weekSteps': weekSteps?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteStatusImpl extends PepiteStatus {
  _PepiteStatusImpl({
    required int seeds,
    int? spentSeeds,
    required int weeks,
    required bool doneThisWeek,
    DateTime? firstRitualAt,
    DateTime? lastRitualAt,
    required List<String> badges,
    required int earnedSeeds,
    required List<String> newBadges,
    required List<String> items,
    required List<String> equipped,
    List<String>? weekSteps,
  }) : super._(
         seeds: seeds,
         spentSeeds: spentSeeds,
         weeks: weeks,
         doneThisWeek: doneThisWeek,
         firstRitualAt: firstRitualAt,
         lastRitualAt: lastRitualAt,
         badges: badges,
         earnedSeeds: earnedSeeds,
         newBadges: newBadges,
         items: items,
         equipped: equipped,
         weekSteps: weekSteps,
       );

  /// Returns a shallow copy of this [PepiteStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteStatus copyWith({
    int? seeds,
    int? spentSeeds,
    int? weeks,
    bool? doneThisWeek,
    Object? firstRitualAt = _Undefined,
    Object? lastRitualAt = _Undefined,
    List<String>? badges,
    int? earnedSeeds,
    List<String>? newBadges,
    List<String>? items,
    List<String>? equipped,
    Object? weekSteps = _Undefined,
  }) {
    return PepiteStatus(
      seeds: seeds ?? this.seeds,
      spentSeeds: spentSeeds ?? this.spentSeeds,
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
      items: items ?? this.items.map((e0) => e0).toList(),
      equipped: equipped ?? this.equipped.map((e0) => e0).toList(),
      weekSteps: weekSteps is List<String>?
          ? weekSteps
          : this.weekSteps?.map((e0) => e0).toList(),
    );
  }
}
