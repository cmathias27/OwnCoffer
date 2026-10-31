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
import 'loan.dart' as _i7jednjp;

/// A loan and where it stands today.
abstract class LoanInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LoanInfo._({
    required this.loan,
    required this.paymentCents,
    required this.paymentIsActual,
    required this.paidCount,
    required this.totalCount,
    required this.remainingCents,
    required this.principalPaidCents,
    required this.interestPaidCents,
    required this.interestRemainingCents,
    required this.insuranceRemainingCents,
    required this.costCents,
    required this.repaidPerMille,
    this.nextDueDate,
    required this.endDate,
  });

  factory LoanInfo({
    required _i7jednjp.Loan loan,
    required int paymentCents,
    required bool paymentIsActual,
    required int paidCount,
    required int totalCount,
    required int remainingCents,
    required int principalPaidCents,
    required int interestPaidCents,
    required int interestRemainingCents,
    required int insuranceRemainingCents,
    required int costCents,
    required int repaidPerMille,
    DateTime? nextDueDate,
    required DateTime endDate,
  }) = _LoanInfoImpl;

  factory LoanInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanInfo(
      loan: _iylp5nsw.Protocol().deserialize<_i7jednjp.Loan>(
        jsonSerialization['loan'],
      ),
      paymentCents: jsonSerialization['paymentCents'] as int,
      paymentIsActual: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['paymentIsActual'],
      ),
      paidCount: jsonSerialization['paidCount'] as int,
      totalCount: jsonSerialization['totalCount'] as int,
      remainingCents: jsonSerialization['remainingCents'] as int,
      principalPaidCents: jsonSerialization['principalPaidCents'] as int,
      interestPaidCents: jsonSerialization['interestPaidCents'] as int,
      interestRemainingCents:
          jsonSerialization['interestRemainingCents'] as int,
      insuranceRemainingCents:
          jsonSerialization['insuranceRemainingCents'] as int,
      costCents: jsonSerialization['costCents'] as int,
      repaidPerMille: jsonSerialization['repaidPerMille'] as int,
      nextDueDate: jsonSerialization['nextDueDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextDueDate'],
            ),
      endDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['endDate'],
      ),
    );
  }

  _i7jednjp.Loan loan;

  /// Capital + interest of a regular instalment.
  int paymentCents;

  /// The instalment is the one debited (entered or taken from a debit),
  /// not computed: the other figures are estimates based on it.
  bool paymentIsActual;

  int paidCount;

  int totalCount;

  int remainingCents;

  int principalPaidCents;

  int interestPaidCents;

  int interestRemainingCents;

  int insuranceRemainingCents;

  /// Interest, insurance and fees over the whole loan.
  int costCents;

  int repaidPerMille;

  DateTime? nextDueDate;

  DateTime endDate;

  /// Returns a shallow copy of this [LoanInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LoanInfo copyWith({
    _i7jednjp.Loan? loan,
    int? paymentCents,
    bool? paymentIsActual,
    int? paidCount,
    int? totalCount,
    int? remainingCents,
    int? principalPaidCents,
    int? interestPaidCents,
    int? interestRemainingCents,
    int? insuranceRemainingCents,
    int? costCents,
    int? repaidPerMille,
    DateTime? nextDueDate,
    DateTime? endDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanInfo',
      'loan': loan.toJson(),
      'paymentCents': paymentCents,
      'paymentIsActual': paymentIsActual,
      'paidCount': paidCount,
      'totalCount': totalCount,
      'remainingCents': remainingCents,
      'principalPaidCents': principalPaidCents,
      'interestPaidCents': interestPaidCents,
      'interestRemainingCents': interestRemainingCents,
      'insuranceRemainingCents': insuranceRemainingCents,
      'costCents': costCents,
      'repaidPerMille': repaidPerMille,
      if (nextDueDate != null) 'nextDueDate': nextDueDate?.toJson(),
      'endDate': endDate.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanInfo',
      'loan': loan.toJsonForProtocol(),
      'paymentCents': paymentCents,
      'paymentIsActual': paymentIsActual,
      'paidCount': paidCount,
      'totalCount': totalCount,
      'remainingCents': remainingCents,
      'principalPaidCents': principalPaidCents,
      'interestPaidCents': interestPaidCents,
      'interestRemainingCents': interestRemainingCents,
      'insuranceRemainingCents': insuranceRemainingCents,
      'costCents': costCents,
      'repaidPerMille': repaidPerMille,
      if (nextDueDate != null) 'nextDueDate': nextDueDate?.toJson(),
      'endDate': endDate.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanInfoImpl extends LoanInfo {
  _LoanInfoImpl({
    required _i7jednjp.Loan loan,
    required int paymentCents,
    required bool paymentIsActual,
    required int paidCount,
    required int totalCount,
    required int remainingCents,
    required int principalPaidCents,
    required int interestPaidCents,
    required int interestRemainingCents,
    required int insuranceRemainingCents,
    required int costCents,
    required int repaidPerMille,
    DateTime? nextDueDate,
    required DateTime endDate,
  }) : super._(
         loan: loan,
         paymentCents: paymentCents,
         paymentIsActual: paymentIsActual,
         paidCount: paidCount,
         totalCount: totalCount,
         remainingCents: remainingCents,
         principalPaidCents: principalPaidCents,
         interestPaidCents: interestPaidCents,
         interestRemainingCents: interestRemainingCents,
         insuranceRemainingCents: insuranceRemainingCents,
         costCents: costCents,
         repaidPerMille: repaidPerMille,
         nextDueDate: nextDueDate,
         endDate: endDate,
       );

  /// Returns a shallow copy of this [LoanInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LoanInfo copyWith({
    _i7jednjp.Loan? loan,
    int? paymentCents,
    bool? paymentIsActual,
    int? paidCount,
    int? totalCount,
    int? remainingCents,
    int? principalPaidCents,
    int? interestPaidCents,
    int? interestRemainingCents,
    int? insuranceRemainingCents,
    int? costCents,
    int? repaidPerMille,
    Object? nextDueDate = _Undefined,
    DateTime? endDate,
  }) {
    return LoanInfo(
      loan: loan ?? this.loan.copyWith(),
      paymentCents: paymentCents ?? this.paymentCents,
      paymentIsActual: paymentIsActual ?? this.paymentIsActual,
      paidCount: paidCount ?? this.paidCount,
      totalCount: totalCount ?? this.totalCount,
      remainingCents: remainingCents ?? this.remainingCents,
      principalPaidCents: principalPaidCents ?? this.principalPaidCents,
      interestPaidCents: interestPaidCents ?? this.interestPaidCents,
      interestRemainingCents:
          interestRemainingCents ?? this.interestRemainingCents,
      insuranceRemainingCents:
          insuranceRemainingCents ?? this.insuranceRemainingCents,
      costCents: costCents ?? this.costCents,
      repaidPerMille: repaidPerMille ?? this.repaidPerMille,
      nextDueDate: nextDueDate is DateTime? ? nextDueDate : this.nextDueDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
