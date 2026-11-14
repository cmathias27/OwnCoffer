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
import 'savings_project.dart' as _infuthxz;

/// A savings project and where it stands (core.projectPlan).
abstract class SavingsProjectInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SavingsProjectInfo._({
    required this.project,
    required this.remainingCents,
    this.monthsLeft,
    this.monthlyCents,
    required this.progressPerMille,
    required this.reached,
    required this.overdue,
  });

  factory SavingsProjectInfo({
    required _infuthxz.SavingsProject project,
    required int remainingCents,
    int? monthsLeft,
    int? monthlyCents,
    required int progressPerMille,
    required bool reached,
    required bool overdue,
  }) = _SavingsProjectInfoImpl;

  factory SavingsProjectInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SavingsProjectInfo(
      project: _iylp5nsw.Protocol().deserialize<_infuthxz.SavingsProject>(
        jsonSerialization['project'],
      ),
      remainingCents: jsonSerialization['remainingCents'] as int,
      monthsLeft: jsonSerialization['monthsLeft'] as int?,
      monthlyCents: jsonSerialization['monthlyCents'] as int?,
      progressPerMille: jsonSerialization['progressPerMille'] as int,
      reached: _isc.BoolJsonExtension.fromJson(jsonSerialization['reached']),
      overdue: _isc.BoolJsonExtension.fromJson(jsonSerialization['overdue']),
    );
  }

  _infuthxz.SavingsProject project;

  int remainingCents;

  int? monthsLeft;

  int? monthlyCents;

  int progressPerMille;

  bool reached;

  bool overdue;

  /// Returns a shallow copy of this [SavingsProjectInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SavingsProjectInfo copyWith({
    _infuthxz.SavingsProject? project,
    int? remainingCents,
    int? monthsLeft,
    int? monthlyCents,
    int? progressPerMille,
    bool? reached,
    bool? overdue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SavingsProjectInfo',
      'project': project.toJson(),
      'remainingCents': remainingCents,
      if (monthsLeft != null) 'monthsLeft': monthsLeft,
      if (monthlyCents != null) 'monthlyCents': monthlyCents,
      'progressPerMille': progressPerMille,
      'reached': reached,
      'overdue': overdue,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SavingsProjectInfo',
      'project': project.toJsonForProtocol(),
      'remainingCents': remainingCents,
      if (monthsLeft != null) 'monthsLeft': monthsLeft,
      if (monthlyCents != null) 'monthlyCents': monthlyCents,
      'progressPerMille': progressPerMille,
      'reached': reached,
      'overdue': overdue,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SavingsProjectInfoImpl extends SavingsProjectInfo {
  _SavingsProjectInfoImpl({
    required _infuthxz.SavingsProject project,
    required int remainingCents,
    int? monthsLeft,
    int? monthlyCents,
    required int progressPerMille,
    required bool reached,
    required bool overdue,
  }) : super._(
         project: project,
         remainingCents: remainingCents,
         monthsLeft: monthsLeft,
         monthlyCents: monthlyCents,
         progressPerMille: progressPerMille,
         reached: reached,
         overdue: overdue,
       );

  /// Returns a shallow copy of this [SavingsProjectInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SavingsProjectInfo copyWith({
    _infuthxz.SavingsProject? project,
    int? remainingCents,
    Object? monthsLeft = _Undefined,
    Object? monthlyCents = _Undefined,
    int? progressPerMille,
    bool? reached,
    bool? overdue,
  }) {
    return SavingsProjectInfo(
      project: project ?? this.project.copyWith(),
      remainingCents: remainingCents ?? this.remainingCents,
      monthsLeft: monthsLeft is int? ? monthsLeft : this.monthsLeft,
      monthlyCents: monthlyCents is int? ? monthlyCents : this.monthlyCents,
      progressPerMille: progressPerMille ?? this.progressPerMille,
      reached: reached ?? this.reached,
      overdue: overdue ?? this.overdue,
    );
  }
}
