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
import 'savings_project_info.dart' as _ihvqz8p6;
import 'smoothed_expense_info.dart' as _iz4y239i;

abstract class ProjectOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectOverview._({
    required this.projects,
    required this.smoothed,
    required this.smoothedMonthlyCents,
    required this.smoothedSetAsideCents,
    required this.projectsMonthlyCents,
  });

  factory ProjectOverview({
    required List<_ihvqz8p6.SavingsProjectInfo> projects,
    required List<_iz4y239i.SmoothedExpenseInfo> smoothed,
    required int smoothedMonthlyCents,
    required int smoothedSetAsideCents,
    required int projectsMonthlyCents,
  }) = _ProjectOverviewImpl;

  factory ProjectOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectOverview(
      projects: _iylp5nsw.Protocol()
          .deserialize<List<_ihvqz8p6.SavingsProjectInfo>>(
            jsonSerialization['projects'],
          ),
      smoothed: _iylp5nsw.Protocol()
          .deserialize<List<_iz4y239i.SmoothedExpenseInfo>>(
            jsonSerialization['smoothed'],
          ),
      smoothedMonthlyCents: jsonSerialization['smoothedMonthlyCents'] as int,
      smoothedSetAsideCents: jsonSerialization['smoothedSetAsideCents'] as int,
      projectsMonthlyCents: jsonSerialization['projectsMonthlyCents'] as int,
    );
  }

  List<_ihvqz8p6.SavingsProjectInfo> projects;

  List<_iz4y239i.SmoothedExpenseInfo> smoothed;

  /// Monthly provision of all the spread expenses.
  int smoothedMonthlyCents;

  /// What should be put aside already for them.
  int smoothedSetAsideCents;

  /// Monthly instalments of the projects with a date, not reached.
  int projectsMonthlyCents;

  /// Returns a shallow copy of this [ProjectOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectOverview copyWith({
    List<_ihvqz8p6.SavingsProjectInfo>? projects,
    List<_iz4y239i.SmoothedExpenseInfo>? smoothed,
    int? smoothedMonthlyCents,
    int? smoothedSetAsideCents,
    int? projectsMonthlyCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectOverview',
      'projects': projects.toJson(valueToJson: (v) => v.toJson()),
      'smoothed': smoothed.toJson(valueToJson: (v) => v.toJson()),
      'smoothedMonthlyCents': smoothedMonthlyCents,
      'smoothedSetAsideCents': smoothedSetAsideCents,
      'projectsMonthlyCents': projectsMonthlyCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectOverview',
      'projects': projects.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'smoothed': smoothed.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'smoothedMonthlyCents': smoothedMonthlyCents,
      'smoothedSetAsideCents': smoothedSetAsideCents,
      'projectsMonthlyCents': projectsMonthlyCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProjectOverviewImpl extends ProjectOverview {
  _ProjectOverviewImpl({
    required List<_ihvqz8p6.SavingsProjectInfo> projects,
    required List<_iz4y239i.SmoothedExpenseInfo> smoothed,
    required int smoothedMonthlyCents,
    required int smoothedSetAsideCents,
    required int projectsMonthlyCents,
  }) : super._(
         projects: projects,
         smoothed: smoothed,
         smoothedMonthlyCents: smoothedMonthlyCents,
         smoothedSetAsideCents: smoothedSetAsideCents,
         projectsMonthlyCents: projectsMonthlyCents,
       );

  /// Returns a shallow copy of this [ProjectOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectOverview copyWith({
    List<_ihvqz8p6.SavingsProjectInfo>? projects,
    List<_iz4y239i.SmoothedExpenseInfo>? smoothed,
    int? smoothedMonthlyCents,
    int? smoothedSetAsideCents,
    int? projectsMonthlyCents,
  }) {
    return ProjectOverview(
      projects: projects ?? this.projects.map((e0) => e0.copyWith()).toList(),
      smoothed: smoothed ?? this.smoothed.map((e0) => e0.copyWith()).toList(),
      smoothedMonthlyCents: smoothedMonthlyCents ?? this.smoothedMonthlyCents,
      smoothedSetAsideCents:
          smoothedSetAsideCents ?? this.smoothedSetAsideCents,
      projectsMonthlyCents: projectsMonthlyCents ?? this.projectsMonthlyCents,
    );
  }
}
