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
import 'purchase_scenario_info.dart' as _irvruma2;

/// Purchase simulator: the options side by side (nothing is saved).
abstract class PurchaseSimulation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PurchaseSimulation._({
    required this.accountId,
    required this.amountCents,
    required this.date,
    required this.target,
    required this.until,
    required this.alertThresholdCents,
    required this.variableIncluded,
    this.goalCents,
    this.goalSpentCents,
    required this.scenarios,
  });

  factory PurchaseSimulation({
    required int accountId,
    required int amountCents,
    required DateTime date,
    required DateTime target,
    required DateTime until,
    required int alertThresholdCents,
    required bool variableIncluded,
    int? goalCents,
    int? goalSpentCents,
    required List<_irvruma2.PurchaseScenarioInfo> scenarios,
  }) = _PurchaseSimulationImpl;

  factory PurchaseSimulation.fromJson(Map<String, dynamic> jsonSerialization) {
    return PurchaseSimulation(
      accountId: jsonSerialization['accountId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      target: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['target']),
      until: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['until']),
      alertThresholdCents: jsonSerialization['alertThresholdCents'] as int,
      variableIncluded: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['variableIncluded'],
      ),
      goalCents: jsonSerialization['goalCents'] as int?,
      goalSpentCents: jsonSerialization['goalSpentCents'] as int?,
      scenarios: _iylp5nsw.Protocol()
          .deserialize<List<_irvruma2.PurchaseScenarioInfo>>(
            jsonSerialization['scenarios'],
          ),
    );
  }

  int accountId;

  int amountCents;

  DateTime date;

  DateTime target;

  /// Last day computed: the target or the last instalment.
  DateTime until;

  int alertThresholdCents;

  bool variableIncluded;

  /// Monthly goal of the chosen category and what is spent of it.
  int? goalCents;

  int? goalSpentCents;

  List<_irvruma2.PurchaseScenarioInfo> scenarios;

  /// Returns a shallow copy of this [PurchaseSimulation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PurchaseSimulation copyWith({
    int? accountId,
    int? amountCents,
    DateTime? date,
    DateTime? target,
    DateTime? until,
    int? alertThresholdCents,
    bool? variableIncluded,
    int? goalCents,
    int? goalSpentCents,
    List<_irvruma2.PurchaseScenarioInfo>? scenarios,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PurchaseSimulation',
      'accountId': accountId,
      'amountCents': amountCents,
      'date': date.toJson(),
      'target': target.toJson(),
      'until': until.toJson(),
      'alertThresholdCents': alertThresholdCents,
      'variableIncluded': variableIncluded,
      if (goalCents != null) 'goalCents': goalCents,
      if (goalSpentCents != null) 'goalSpentCents': goalSpentCents,
      'scenarios': scenarios.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PurchaseSimulation',
      'accountId': accountId,
      'amountCents': amountCents,
      'date': date.toJson(),
      'target': target.toJson(),
      'until': until.toJson(),
      'alertThresholdCents': alertThresholdCents,
      'variableIncluded': variableIncluded,
      if (goalCents != null) 'goalCents': goalCents,
      if (goalSpentCents != null) 'goalSpentCents': goalSpentCents,
      'scenarios': scenarios.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PurchaseSimulationImpl extends PurchaseSimulation {
  _PurchaseSimulationImpl({
    required int accountId,
    required int amountCents,
    required DateTime date,
    required DateTime target,
    required DateTime until,
    required int alertThresholdCents,
    required bool variableIncluded,
    int? goalCents,
    int? goalSpentCents,
    required List<_irvruma2.PurchaseScenarioInfo> scenarios,
  }) : super._(
         accountId: accountId,
         amountCents: amountCents,
         date: date,
         target: target,
         until: until,
         alertThresholdCents: alertThresholdCents,
         variableIncluded: variableIncluded,
         goalCents: goalCents,
         goalSpentCents: goalSpentCents,
         scenarios: scenarios,
       );

  /// Returns a shallow copy of this [PurchaseSimulation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PurchaseSimulation copyWith({
    int? accountId,
    int? amountCents,
    DateTime? date,
    DateTime? target,
    DateTime? until,
    int? alertThresholdCents,
    bool? variableIncluded,
    Object? goalCents = _Undefined,
    Object? goalSpentCents = _Undefined,
    List<_irvruma2.PurchaseScenarioInfo>? scenarios,
  }) {
    return PurchaseSimulation(
      accountId: accountId ?? this.accountId,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
      target: target ?? this.target,
      until: until ?? this.until,
      alertThresholdCents: alertThresholdCents ?? this.alertThresholdCents,
      variableIncluded: variableIncluded ?? this.variableIncluded,
      goalCents: goalCents is int? ? goalCents : this.goalCents,
      goalSpentCents: goalSpentCents is int?
          ? goalSpentCents
          : this.goalSpentCents,
      scenarios:
          scenarios ?? this.scenarios.map((e0) => e0.copyWith()).toList(),
    );
  }
}
