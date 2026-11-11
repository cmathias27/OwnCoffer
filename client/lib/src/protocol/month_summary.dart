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
import 'account_forecast_summary.dart' as _ids6osoa;
import 'action_proposal.dart' as _ius3n358;
import 'notification.dart' as _irt10kca;
import 'scheduled_transaction.dart' as _ifol8nrg;

/// Monthly summary on one page (decision 0035): the 30-day forecast of the
/// checking accounts the user may see, the alerts not read yet and the
/// proposals waiting for a decision. Computed by the engine, without AI.
abstract class MonthSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MonthSummary._({
    required this.today,
    required this.until,
    required this.forecasts,
    required this.alerts,
    required this.proposals,
    required this.priceRises,
  });

  factory MonthSummary({
    required DateTime today,
    required DateTime until,
    required List<_ids6osoa.AccountForecastSummary> forecasts,
    required List<_irt10kca.AppNotification> alerts,
    required List<_ius3n358.ActionProposal> proposals,
    required List<_ifol8nrg.ScheduledTransaction> priceRises,
  }) = _MonthSummaryImpl;

  factory MonthSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return MonthSummary(
      today: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['today']),
      until: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['until']),
      forecasts: _iylp5nsw.Protocol()
          .deserialize<List<_ids6osoa.AccountForecastSummary>>(
            jsonSerialization['forecasts'],
          ),
      alerts: _iylp5nsw.Protocol().deserialize<List<_irt10kca.AppNotification>>(
        jsonSerialization['alerts'],
      ),
      proposals: _iylp5nsw.Protocol()
          .deserialize<List<_ius3n358.ActionProposal>>(
            jsonSerialization['proposals'],
          ),
      priceRises: _iylp5nsw.Protocol()
          .deserialize<List<_ifol8nrg.ScheduledTransaction>>(
            jsonSerialization['priceRises'],
          ),
    );
  }

  DateTime today;

  /// Last day of the forecast (today + 30 days).
  DateTime until;

  List<_ids6osoa.AccountForecastSummary> forecasts;

  /// Unread alerts of this group for the user, newest first.
  List<_irt10kca.AppNotification> alerts;

  /// Proposals waiting for the user's decision in this group, newest first.
  List<_ius3n358.ActionProposal> proposals;

  /// Subscriptions whose announced price rise falls in the period (or is
  /// at most 7 days past and not applied yet), soonest first.
  List<_ifol8nrg.ScheduledTransaction> priceRises;

  /// Returns a shallow copy of this [MonthSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MonthSummary copyWith({
    DateTime? today,
    DateTime? until,
    List<_ids6osoa.AccountForecastSummary>? forecasts,
    List<_irt10kca.AppNotification>? alerts,
    List<_ius3n358.ActionProposal>? proposals,
    List<_ifol8nrg.ScheduledTransaction>? priceRises,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MonthSummary',
      'today': today.toJson(),
      'until': until.toJson(),
      'forecasts': forecasts.toJson(valueToJson: (v) => v.toJson()),
      'alerts': alerts.toJson(valueToJson: (v) => v.toJson()),
      'proposals': proposals.toJson(valueToJson: (v) => v.toJson()),
      'priceRises': priceRises.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MonthSummary',
      'today': today.toJson(),
      'until': until.toJson(),
      'forecasts': forecasts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'alerts': alerts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'proposals': proposals.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'priceRises': priceRises.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MonthSummaryImpl extends MonthSummary {
  _MonthSummaryImpl({
    required DateTime today,
    required DateTime until,
    required List<_ids6osoa.AccountForecastSummary> forecasts,
    required List<_irt10kca.AppNotification> alerts,
    required List<_ius3n358.ActionProposal> proposals,
    required List<_ifol8nrg.ScheduledTransaction> priceRises,
  }) : super._(
         today: today,
         until: until,
         forecasts: forecasts,
         alerts: alerts,
         proposals: proposals,
         priceRises: priceRises,
       );

  /// Returns a shallow copy of this [MonthSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MonthSummary copyWith({
    DateTime? today,
    DateTime? until,
    List<_ids6osoa.AccountForecastSummary>? forecasts,
    List<_irt10kca.AppNotification>? alerts,
    List<_ius3n358.ActionProposal>? proposals,
    List<_ifol8nrg.ScheduledTransaction>? priceRises,
  }) {
    return MonthSummary(
      today: today ?? this.today,
      until: until ?? this.until,
      forecasts:
          forecasts ?? this.forecasts.map((e0) => e0.copyWith()).toList(),
      alerts: alerts ?? this.alerts.map((e0) => e0.copyWith()).toList(),
      proposals:
          proposals ?? this.proposals.map((e0) => e0.copyWith()).toList(),
      priceRises:
          priceRises ?? this.priceRises.map((e0) => e0.copyWith()).toList(),
    );
  }
}
