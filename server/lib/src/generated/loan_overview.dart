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
import 'loan_info.dart' as _ijbwwnsd;

abstract class LoanOverview
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LoanOverview._({
    required this.loans,
    required this.totalRemainingCents,
    required this.totalMonthlyCents,
    required this.monthlyIncomeCents,
    this.debtRatioPerMille,
  });

  factory LoanOverview({
    required List<_ijbwwnsd.LoanInfo> loans,
    required int totalRemainingCents,
    required int totalMonthlyCents,
    required int monthlyIncomeCents,
    int? debtRatioPerMille,
  }) = _LoanOverviewImpl;

  factory LoanOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanOverview(
      loans: _itdod8fx.Protocol().deserialize<List<_ijbwwnsd.LoanInfo>>(
        jsonSerialization['loans'],
      ),
      totalRemainingCents: jsonSerialization['totalRemainingCents'] as int,
      totalMonthlyCents: jsonSerialization['totalMonthlyCents'] as int,
      monthlyIncomeCents: jsonSerialization['monthlyIncomeCents'] as int,
      debtRatioPerMille: jsonSerialization['debtRatioPerMille'] as int?,
    );
  }

  List<_ijbwwnsd.LoanInfo> loans;

  int totalRemainingCents;

  /// Instalments and insurance of the loans still running, per month.
  int totalMonthlyCents;

  /// Average income of the three last complete months (visible accounts).
  int monthlyIncomeCents;

  /// Instalments / income, in per mille; null without income.
  int? debtRatioPerMille;

  /// Returns a shallow copy of this [LoanOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LoanOverview copyWith({
    List<_ijbwwnsd.LoanInfo>? loans,
    int? totalRemainingCents,
    int? totalMonthlyCents,
    int? monthlyIncomeCents,
    int? debtRatioPerMille,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanOverview',
      'loans': loans.toJson(valueToJson: (v) => v.toJson()),
      'totalRemainingCents': totalRemainingCents,
      'totalMonthlyCents': totalMonthlyCents,
      'monthlyIncomeCents': monthlyIncomeCents,
      if (debtRatioPerMille != null) 'debtRatioPerMille': debtRatioPerMille,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanOverview',
      'loans': loans.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'totalRemainingCents': totalRemainingCents,
      'totalMonthlyCents': totalMonthlyCents,
      'monthlyIncomeCents': monthlyIncomeCents,
      if (debtRatioPerMille != null) 'debtRatioPerMille': debtRatioPerMille,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanOverviewImpl extends LoanOverview {
  _LoanOverviewImpl({
    required List<_ijbwwnsd.LoanInfo> loans,
    required int totalRemainingCents,
    required int totalMonthlyCents,
    required int monthlyIncomeCents,
    int? debtRatioPerMille,
  }) : super._(
         loans: loans,
         totalRemainingCents: totalRemainingCents,
         totalMonthlyCents: totalMonthlyCents,
         monthlyIncomeCents: monthlyIncomeCents,
         debtRatioPerMille: debtRatioPerMille,
       );

  /// Returns a shallow copy of this [LoanOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LoanOverview copyWith({
    List<_ijbwwnsd.LoanInfo>? loans,
    int? totalRemainingCents,
    int? totalMonthlyCents,
    int? monthlyIncomeCents,
    Object? debtRatioPerMille = _Undefined,
  }) {
    return LoanOverview(
      loans: loans ?? this.loans.map((e0) => e0.copyWith()).toList(),
      totalRemainingCents: totalRemainingCents ?? this.totalRemainingCents,
      totalMonthlyCents: totalMonthlyCents ?? this.totalMonthlyCents,
      monthlyIncomeCents: monthlyIncomeCents ?? this.monthlyIncomeCents,
      debtRatioPerMille: debtRatioPerMille is int?
          ? debtRatioPerMille
          : this.debtRatioPerMille,
    );
  }
}
