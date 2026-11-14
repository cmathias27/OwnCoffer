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
import 'health_indicator_info.dart' as _ir2o1qbt;

/// Financial health score with its indicators and the figures behind them
/// (decision 0050).
abstract class HealthReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  HealthReport._({
    this.score,
    required this.indicators,
    required this.savingsCents,
    required this.monthlyIncomeCents,
    required this.monthlyExpenseCents,
    required this.monthlyLoanCents,
    required this.months,
  });

  factory HealthReport({
    int? score,
    required List<_ir2o1qbt.HealthIndicatorInfo> indicators,
    required int savingsCents,
    required int monthlyIncomeCents,
    required int monthlyExpenseCents,
    required int monthlyLoanCents,
    required int months,
  }) = _HealthReportImpl;

  factory HealthReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthReport(
      score: jsonSerialization['score'] as int?,
      indicators: _itdod8fx.Protocol()
          .deserialize<List<_ir2o1qbt.HealthIndicatorInfo>>(
            jsonSerialization['indicators'],
          ),
      savingsCents: jsonSerialization['savingsCents'] as int,
      monthlyIncomeCents: jsonSerialization['monthlyIncomeCents'] as int,
      monthlyExpenseCents: jsonSerialization['monthlyExpenseCents'] as int,
      monthlyLoanCents: jsonSerialization['monthlyLoanCents'] as int,
      months: jsonSerialization['months'] as int,
    );
  }

  /// Out of 100; null when nothing is known.
  int? score;

  List<_ir2o1qbt.HealthIndicatorInfo> indicators;

  int savingsCents;

  int monthlyIncomeCents;

  int monthlyExpenseCents;

  int monthlyLoanCents;

  /// Months counted for the regularity.
  int months;

  /// Returns a shallow copy of this [HealthReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  HealthReport copyWith({
    int? score,
    List<_ir2o1qbt.HealthIndicatorInfo>? indicators,
    int? savingsCents,
    int? monthlyIncomeCents,
    int? monthlyExpenseCents,
    int? monthlyLoanCents,
    int? months,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthReport',
      if (score != null) 'score': score,
      'indicators': indicators.toJson(valueToJson: (v) => v.toJson()),
      'savingsCents': savingsCents,
      'monthlyIncomeCents': monthlyIncomeCents,
      'monthlyExpenseCents': monthlyExpenseCents,
      'monthlyLoanCents': monthlyLoanCents,
      'months': months,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthReport',
      if (score != null) 'score': score,
      'indicators': indicators.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'savingsCents': savingsCents,
      'monthlyIncomeCents': monthlyIncomeCents,
      'monthlyExpenseCents': monthlyExpenseCents,
      'monthlyLoanCents': monthlyLoanCents,
      'months': months,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthReportImpl extends HealthReport {
  _HealthReportImpl({
    int? score,
    required List<_ir2o1qbt.HealthIndicatorInfo> indicators,
    required int savingsCents,
    required int monthlyIncomeCents,
    required int monthlyExpenseCents,
    required int monthlyLoanCents,
    required int months,
  }) : super._(
         score: score,
         indicators: indicators,
         savingsCents: savingsCents,
         monthlyIncomeCents: monthlyIncomeCents,
         monthlyExpenseCents: monthlyExpenseCents,
         monthlyLoanCents: monthlyLoanCents,
         months: months,
       );

  /// Returns a shallow copy of this [HealthReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  HealthReport copyWith({
    Object? score = _Undefined,
    List<_ir2o1qbt.HealthIndicatorInfo>? indicators,
    int? savingsCents,
    int? monthlyIncomeCents,
    int? monthlyExpenseCents,
    int? monthlyLoanCents,
    int? months,
  }) {
    return HealthReport(
      score: score is int? ? score : this.score,
      indicators:
          indicators ?? this.indicators.map((e0) => e0.copyWith()).toList(),
      savingsCents: savingsCents ?? this.savingsCents,
      monthlyIncomeCents: monthlyIncomeCents ?? this.monthlyIncomeCents,
      monthlyExpenseCents: monthlyExpenseCents ?? this.monthlyExpenseCents,
      monthlyLoanCents: monthlyLoanCents ?? this.monthlyLoanCents,
      months: months ?? this.months,
    );
  }
}
