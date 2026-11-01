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
import 'bank_transaction.dart' as _i0mjlwv3;
import 'fee_line.dart' as _ip53xvp1;
import 'unusual_info.dart' as _iapfk8x9;

/// Analyses computed without AI (cahier des charges : analyses, frais
/// bancaires, anomalies, fiabilité des prévisions), on the accounts the
/// user may see. Every figure comes with what it is made of.
abstract class Insights
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Insights._({
    required this.feeMonths,
    required this.feePerMonthCents,
    required this.feeTotalCents,
    required this.feeLines,
    required this.feeOperations,
    required this.unusual,
    required this.plannedDue,
    required this.plannedPaid,
    required this.plannedLate,
    this.variableMonth,
    this.variableEstimateCents,
    this.variableActualCents,
  });

  factory Insights({
    required List<DateTime> feeMonths,
    required List<int> feePerMonthCents,
    required int feeTotalCents,
    required List<_ip53xvp1.FeeLine> feeLines,
    required List<_i0mjlwv3.BankTransaction> feeOperations,
    required List<_iapfk8x9.UnusualInfo> unusual,
    required int plannedDue,
    required int plannedPaid,
    required int plannedLate,
    DateTime? variableMonth,
    int? variableEstimateCents,
    int? variableActualCents,
  }) = _InsightsImpl;

  factory Insights.fromJson(Map<String, dynamic> jsonSerialization) {
    return Insights(
      feeMonths: _iylp5nsw.Protocol().deserialize<List<DateTime>>(
        jsonSerialization['feeMonths'],
      ),
      feePerMonthCents: _iylp5nsw.Protocol().deserialize<List<int>>(
        jsonSerialization['feePerMonthCents'],
      ),
      feeTotalCents: jsonSerialization['feeTotalCents'] as int,
      feeLines: _iylp5nsw.Protocol().deserialize<List<_ip53xvp1.FeeLine>>(
        jsonSerialization['feeLines'],
      ),
      feeOperations: _iylp5nsw.Protocol()
          .deserialize<List<_i0mjlwv3.BankTransaction>>(
            jsonSerialization['feeOperations'],
          ),
      unusual: _iylp5nsw.Protocol().deserialize<List<_iapfk8x9.UnusualInfo>>(
        jsonSerialization['unusual'],
      ),
      plannedDue: jsonSerialization['plannedDue'] as int,
      plannedPaid: jsonSerialization['plannedPaid'] as int,
      plannedLate: jsonSerialization['plannedLate'] as int,
      variableMonth: jsonSerialization['variableMonth'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['variableMonth'],
            ),
      variableEstimateCents: jsonSerialization['variableEstimateCents'] as int?,
      variableActualCents: jsonSerialization['variableActualCents'] as int?,
    );
  }

  /// Bank fees of the last 12 budget months, oldest first.
  List<DateTime> feeMonths;

  List<int> feePerMonthCents;

  int feeTotalCents;

  List<_ip53xvp1.FeeLine> feeLines;

  List<_i0mjlwv3.BankTransaction> feeOperations;

  /// Debits of this budget month and the previous one that stand out.
  List<_iapfk8x9.UnusualInfo> unusual;

  /// Planned operations due in the last three complete months.
  int plannedDue;

  int plannedPaid;

  int plannedLate;

  /// Variable spending of the last complete month: estimated beforehand
  /// (median of the three months before), and really spent.
  DateTime? variableMonth;

  int? variableEstimateCents;

  int? variableActualCents;

  /// Returns a shallow copy of this [Insights]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Insights copyWith({
    List<DateTime>? feeMonths,
    List<int>? feePerMonthCents,
    int? feeTotalCents,
    List<_ip53xvp1.FeeLine>? feeLines,
    List<_i0mjlwv3.BankTransaction>? feeOperations,
    List<_iapfk8x9.UnusualInfo>? unusual,
    int? plannedDue,
    int? plannedPaid,
    int? plannedLate,
    DateTime? variableMonth,
    int? variableEstimateCents,
    int? variableActualCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Insights',
      'feeMonths': feeMonths.toJson(valueToJson: (v) => v.toJson()),
      'feePerMonthCents': feePerMonthCents.toJson(),
      'feeTotalCents': feeTotalCents,
      'feeLines': feeLines.toJson(valueToJson: (v) => v.toJson()),
      'feeOperations': feeOperations.toJson(valueToJson: (v) => v.toJson()),
      'unusual': unusual.toJson(valueToJson: (v) => v.toJson()),
      'plannedDue': plannedDue,
      'plannedPaid': plannedPaid,
      'plannedLate': plannedLate,
      if (variableMonth != null) 'variableMonth': variableMonth?.toJson(),
      if (variableEstimateCents != null)
        'variableEstimateCents': variableEstimateCents,
      if (variableActualCents != null)
        'variableActualCents': variableActualCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Insights',
      'feeMonths': feeMonths.toJson(valueToJson: (v) => v.toJson()),
      'feePerMonthCents': feePerMonthCents.toJson(),
      'feeTotalCents': feeTotalCents,
      'feeLines': feeLines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'feeOperations': feeOperations.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'unusual': unusual.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'plannedDue': plannedDue,
      'plannedPaid': plannedPaid,
      'plannedLate': plannedLate,
      if (variableMonth != null) 'variableMonth': variableMonth?.toJson(),
      if (variableEstimateCents != null)
        'variableEstimateCents': variableEstimateCents,
      if (variableActualCents != null)
        'variableActualCents': variableActualCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InsightsImpl extends Insights {
  _InsightsImpl({
    required List<DateTime> feeMonths,
    required List<int> feePerMonthCents,
    required int feeTotalCents,
    required List<_ip53xvp1.FeeLine> feeLines,
    required List<_i0mjlwv3.BankTransaction> feeOperations,
    required List<_iapfk8x9.UnusualInfo> unusual,
    required int plannedDue,
    required int plannedPaid,
    required int plannedLate,
    DateTime? variableMonth,
    int? variableEstimateCents,
    int? variableActualCents,
  }) : super._(
         feeMonths: feeMonths,
         feePerMonthCents: feePerMonthCents,
         feeTotalCents: feeTotalCents,
         feeLines: feeLines,
         feeOperations: feeOperations,
         unusual: unusual,
         plannedDue: plannedDue,
         plannedPaid: plannedPaid,
         plannedLate: plannedLate,
         variableMonth: variableMonth,
         variableEstimateCents: variableEstimateCents,
         variableActualCents: variableActualCents,
       );

  /// Returns a shallow copy of this [Insights]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Insights copyWith({
    List<DateTime>? feeMonths,
    List<int>? feePerMonthCents,
    int? feeTotalCents,
    List<_ip53xvp1.FeeLine>? feeLines,
    List<_i0mjlwv3.BankTransaction>? feeOperations,
    List<_iapfk8x9.UnusualInfo>? unusual,
    int? plannedDue,
    int? plannedPaid,
    int? plannedLate,
    Object? variableMonth = _Undefined,
    Object? variableEstimateCents = _Undefined,
    Object? variableActualCents = _Undefined,
  }) {
    return Insights(
      feeMonths: feeMonths ?? this.feeMonths.map((e0) => e0).toList(),
      feePerMonthCents:
          feePerMonthCents ?? this.feePerMonthCents.map((e0) => e0).toList(),
      feeTotalCents: feeTotalCents ?? this.feeTotalCents,
      feeLines: feeLines ?? this.feeLines.map((e0) => e0.copyWith()).toList(),
      feeOperations:
          feeOperations ??
          this.feeOperations.map((e0) => e0.copyWith()).toList(),
      unusual: unusual ?? this.unusual.map((e0) => e0.copyWith()).toList(),
      plannedDue: plannedDue ?? this.plannedDue,
      plannedPaid: plannedPaid ?? this.plannedPaid,
      plannedLate: plannedLate ?? this.plannedLate,
      variableMonth: variableMonth is DateTime?
          ? variableMonth
          : this.variableMonth,
      variableEstimateCents: variableEstimateCents is int?
          ? variableEstimateCents
          : this.variableEstimateCents,
      variableActualCents: variableActualCents is int?
          ? variableActualCents
          : this.variableActualCents,
    );
  }
}
