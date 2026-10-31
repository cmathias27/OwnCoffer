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
import 'package:serverpod/serverpod.dart' as _is;

abstract class LoanInstallment
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LoanInstallment._({
    required this.number,
    required this.date,
    required this.paymentCents,
    required this.principalCents,
    required this.interestCents,
    required this.insuranceCents,
    required this.remainingCents,
  });

  factory LoanInstallment({
    required int number,
    required DateTime date,
    required int paymentCents,
    required int principalCents,
    required int interestCents,
    required int insuranceCents,
    required int remainingCents,
  }) = _LoanInstallmentImpl;

  factory LoanInstallment.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanInstallment(
      number: jsonSerialization['number'] as int,
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      paymentCents: jsonSerialization['paymentCents'] as int,
      principalCents: jsonSerialization['principalCents'] as int,
      interestCents: jsonSerialization['interestCents'] as int,
      insuranceCents: jsonSerialization['insuranceCents'] as int,
      remainingCents: jsonSerialization['remainingCents'] as int,
    );
  }

  int number;

  DateTime date;

  int paymentCents;

  int principalCents;

  int interestCents;

  int insuranceCents;

  int remainingCents;

  /// Returns a shallow copy of this [LoanInstallment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LoanInstallment copyWith({
    int? number,
    DateTime? date,
    int? paymentCents,
    int? principalCents,
    int? interestCents,
    int? insuranceCents,
    int? remainingCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanInstallment',
      'number': number,
      'date': date.toJson(),
      'paymentCents': paymentCents,
      'principalCents': principalCents,
      'interestCents': interestCents,
      'insuranceCents': insuranceCents,
      'remainingCents': remainingCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanInstallment',
      'number': number,
      'date': date.toJson(),
      'paymentCents': paymentCents,
      'principalCents': principalCents,
      'interestCents': interestCents,
      'insuranceCents': insuranceCents,
      'remainingCents': remainingCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LoanInstallmentImpl extends LoanInstallment {
  _LoanInstallmentImpl({
    required int number,
    required DateTime date,
    required int paymentCents,
    required int principalCents,
    required int interestCents,
    required int insuranceCents,
    required int remainingCents,
  }) : super._(
         number: number,
         date: date,
         paymentCents: paymentCents,
         principalCents: principalCents,
         interestCents: interestCents,
         insuranceCents: insuranceCents,
         remainingCents: remainingCents,
       );

  /// Returns a shallow copy of this [LoanInstallment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LoanInstallment copyWith({
    int? number,
    DateTime? date,
    int? paymentCents,
    int? principalCents,
    int? interestCents,
    int? insuranceCents,
    int? remainingCents,
  }) {
    return LoanInstallment(
      number: number ?? this.number,
      date: date ?? this.date,
      paymentCents: paymentCents ?? this.paymentCents,
      principalCents: principalCents ?? this.principalCents,
      interestCents: interestCents ?? this.interestCents,
      insuranceCents: insuranceCents ?? this.insuranceCents,
      remainingCents: remainingCents ?? this.remainingCents,
    );
  }
}
