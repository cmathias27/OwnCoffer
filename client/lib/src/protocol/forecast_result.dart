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
import 'forecast_day.dart' as _ids0ngao;
import 'forecast_event_info.dart' as _iuscnr1n;
import 'missed_occurrence_info.dart' as _ifjtpr6l;
import 'reconciliation_proposal.dart' as _i7qmkh8w;

/// Forecast of one account. Every figure comes from the deterministic
/// engine (shared/forecast); nothing is estimated by an AI.
abstract class ForecastResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ForecastResult._({
    required this.accountId,
    required this.today,
    required this.until,
    required this.currentBalanceCents,
    required this.clearedBalanceCents,
    required this.alertThresholdCents,
    required this.days,
    required this.events,
    required this.lowestDate,
    required this.lowestBalanceCents,
    this.firstBelowThresholdDate,
    required this.missed,
    required this.proposals,
    required this.autoReconciledCount,
  });

  factory ForecastResult({
    required int accountId,
    required DateTime today,
    required DateTime until,
    required int currentBalanceCents,
    required int clearedBalanceCents,
    required int alertThresholdCents,
    required List<_ids0ngao.ForecastDay> days,
    required List<_iuscnr1n.ForecastEventInfo> events,
    required DateTime lowestDate,
    required int lowestBalanceCents,
    DateTime? firstBelowThresholdDate,
    required List<_ifjtpr6l.MissedOccurrenceInfo> missed,
    required List<_i7qmkh8w.ReconciliationProposal> proposals,
    required int autoReconciledCount,
  }) = _ForecastResultImpl;

  factory ForecastResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ForecastResult(
      accountId: jsonSerialization['accountId'] as int,
      today: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['today']),
      until: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['until']),
      currentBalanceCents: jsonSerialization['currentBalanceCents'] as int,
      clearedBalanceCents: jsonSerialization['clearedBalanceCents'] as int,
      alertThresholdCents: jsonSerialization['alertThresholdCents'] as int,
      days: _iylp5nsw.Protocol().deserialize<List<_ids0ngao.ForecastDay>>(
        jsonSerialization['days'],
      ),
      events: _iylp5nsw.Protocol()
          .deserialize<List<_iuscnr1n.ForecastEventInfo>>(
            jsonSerialization['events'],
          ),
      lowestDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lowestDate'],
      ),
      lowestBalanceCents: jsonSerialization['lowestBalanceCents'] as int,
      firstBelowThresholdDate:
          jsonSerialization['firstBelowThresholdDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstBelowThresholdDate'],
            ),
      missed: _iylp5nsw.Protocol()
          .deserialize<List<_ifjtpr6l.MissedOccurrenceInfo>>(
            jsonSerialization['missed'],
          ),
      proposals: _iylp5nsw.Protocol()
          .deserialize<List<_i7qmkh8w.ReconciliationProposal>>(
            jsonSerialization['proposals'],
          ),
      autoReconciledCount: jsonSerialization['autoReconciledCount'] as int,
    );
  }

  int accountId;

  DateTime today;

  DateTime until;

  /// Initial balance + operations dated today or earlier.
  int currentBalanceCents;

  /// Initial balance + checked operations.
  int clearedBalanceCents;

  int alertThresholdCents;

  List<_ids0ngao.ForecastDay> days;

  List<_iuscnr1n.ForecastEventInfo> events;

  DateTime lowestDate;

  int lowestBalanceCents;

  /// First day below the alert threshold, if any.
  DateTime? firstBelowThresholdDate;

  List<_ifjtpr6l.MissedOccurrenceInfo> missed;

  List<_i7qmkh8w.ReconciliationProposal> proposals;

  /// Operations linked automatically to their planned occurrence.
  int autoReconciledCount;

  /// Returns a shallow copy of this [ForecastResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ForecastResult copyWith({
    int? accountId,
    DateTime? today,
    DateTime? until,
    int? currentBalanceCents,
    int? clearedBalanceCents,
    int? alertThresholdCents,
    List<_ids0ngao.ForecastDay>? days,
    List<_iuscnr1n.ForecastEventInfo>? events,
    DateTime? lowestDate,
    int? lowestBalanceCents,
    DateTime? firstBelowThresholdDate,
    List<_ifjtpr6l.MissedOccurrenceInfo>? missed,
    List<_i7qmkh8w.ReconciliationProposal>? proposals,
    int? autoReconciledCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ForecastResult',
      'accountId': accountId,
      'today': today.toJson(),
      'until': until.toJson(),
      'currentBalanceCents': currentBalanceCents,
      'clearedBalanceCents': clearedBalanceCents,
      'alertThresholdCents': alertThresholdCents,
      'days': days.toJson(valueToJson: (v) => v.toJson()),
      'events': events.toJson(valueToJson: (v) => v.toJson()),
      'lowestDate': lowestDate.toJson(),
      'lowestBalanceCents': lowestBalanceCents,
      if (firstBelowThresholdDate != null)
        'firstBelowThresholdDate': firstBelowThresholdDate?.toJson(),
      'missed': missed.toJson(valueToJson: (v) => v.toJson()),
      'proposals': proposals.toJson(valueToJson: (v) => v.toJson()),
      'autoReconciledCount': autoReconciledCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ForecastResult',
      'accountId': accountId,
      'today': today.toJson(),
      'until': until.toJson(),
      'currentBalanceCents': currentBalanceCents,
      'clearedBalanceCents': clearedBalanceCents,
      'alertThresholdCents': alertThresholdCents,
      'days': days.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'events': events.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'lowestDate': lowestDate.toJson(),
      'lowestBalanceCents': lowestBalanceCents,
      if (firstBelowThresholdDate != null)
        'firstBelowThresholdDate': firstBelowThresholdDate?.toJson(),
      'missed': missed.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'proposals': proposals.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'autoReconciledCount': autoReconciledCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ForecastResultImpl extends ForecastResult {
  _ForecastResultImpl({
    required int accountId,
    required DateTime today,
    required DateTime until,
    required int currentBalanceCents,
    required int clearedBalanceCents,
    required int alertThresholdCents,
    required List<_ids0ngao.ForecastDay> days,
    required List<_iuscnr1n.ForecastEventInfo> events,
    required DateTime lowestDate,
    required int lowestBalanceCents,
    DateTime? firstBelowThresholdDate,
    required List<_ifjtpr6l.MissedOccurrenceInfo> missed,
    required List<_i7qmkh8w.ReconciliationProposal> proposals,
    required int autoReconciledCount,
  }) : super._(
         accountId: accountId,
         today: today,
         until: until,
         currentBalanceCents: currentBalanceCents,
         clearedBalanceCents: clearedBalanceCents,
         alertThresholdCents: alertThresholdCents,
         days: days,
         events: events,
         lowestDate: lowestDate,
         lowestBalanceCents: lowestBalanceCents,
         firstBelowThresholdDate: firstBelowThresholdDate,
         missed: missed,
         proposals: proposals,
         autoReconciledCount: autoReconciledCount,
       );

  /// Returns a shallow copy of this [ForecastResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ForecastResult copyWith({
    int? accountId,
    DateTime? today,
    DateTime? until,
    int? currentBalanceCents,
    int? clearedBalanceCents,
    int? alertThresholdCents,
    List<_ids0ngao.ForecastDay>? days,
    List<_iuscnr1n.ForecastEventInfo>? events,
    DateTime? lowestDate,
    int? lowestBalanceCents,
    Object? firstBelowThresholdDate = _Undefined,
    List<_ifjtpr6l.MissedOccurrenceInfo>? missed,
    List<_i7qmkh8w.ReconciliationProposal>? proposals,
    int? autoReconciledCount,
  }) {
    return ForecastResult(
      accountId: accountId ?? this.accountId,
      today: today ?? this.today,
      until: until ?? this.until,
      currentBalanceCents: currentBalanceCents ?? this.currentBalanceCents,
      clearedBalanceCents: clearedBalanceCents ?? this.clearedBalanceCents,
      alertThresholdCents: alertThresholdCents ?? this.alertThresholdCents,
      days: days ?? this.days.map((e0) => e0.copyWith()).toList(),
      events: events ?? this.events.map((e0) => e0.copyWith()).toList(),
      lowestDate: lowestDate ?? this.lowestDate,
      lowestBalanceCents: lowestBalanceCents ?? this.lowestBalanceCents,
      firstBelowThresholdDate: firstBelowThresholdDate is DateTime?
          ? firstBelowThresholdDate
          : this.firstBelowThresholdDate,
      missed: missed ?? this.missed.map((e0) => e0.copyWith()).toList(),
      proposals:
          proposals ?? this.proposals.map((e0) => e0.copyWith()).toList(),
      autoReconciledCount: autoReconciledCount ?? this.autoReconciledCount,
    );
  }
}
