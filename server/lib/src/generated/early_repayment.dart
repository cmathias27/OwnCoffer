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

/// Early repayment simulation, keeping the instalment.
abstract class EarlyRepayment
    implements _is.SerializableModel, _is.ProtocolSerialization {
  EarlyRepayment._({
    required this.amountCents,
    required this.interestSavedCents,
    required this.installmentsLeft,
    this.endDate,
    this.penaltyCents,
    this.penaltyLegalMaxCents,
    this.penaltyBasis,
    this.netSavedCents,
  });

  factory EarlyRepayment({
    required int amountCents,
    required int interestSavedCents,
    required int installmentsLeft,
    DateTime? endDate,
    int? penaltyCents,
    int? penaltyLegalMaxCents,
    String? penaltyBasis,
    int? netSavedCents,
  }) = _EarlyRepaymentImpl;

  factory EarlyRepayment.fromJson(Map<String, dynamic> jsonSerialization) {
    return EarlyRepayment(
      amountCents: jsonSerialization['amountCents'] as int,
      interestSavedCents: jsonSerialization['interestSavedCents'] as int,
      installmentsLeft: jsonSerialization['installmentsLeft'] as int,
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      penaltyCents: jsonSerialization['penaltyCents'] as int?,
      penaltyLegalMaxCents: jsonSerialization['penaltyLegalMaxCents'] as int?,
      penaltyBasis: jsonSerialization['penaltyBasis'] as String?,
      netSavedCents: jsonSerialization['netSavedCents'] as int?,
    );
  }

  int amountCents;

  int interestSavedCents;

  int installmentsLeft;

  DateTime? endDate;

  /// Early repayment penalty (decision 0043): the offer's clause within the
  /// legal maximum, or the legal maximum when the clause is unknown.
  int? penaltyCents;

  int? penaltyLegalMaxCents;

  /// offer, legalMax or none.
  String? penaltyBasis;

  /// Interest saved minus the penalty.
  int? netSavedCents;

  /// Returns a shallow copy of this [EarlyRepayment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EarlyRepayment copyWith({
    int? amountCents,
    int? interestSavedCents,
    int? installmentsLeft,
    DateTime? endDate,
    int? penaltyCents,
    int? penaltyLegalMaxCents,
    String? penaltyBasis,
    int? netSavedCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EarlyRepayment',
      'amountCents': amountCents,
      'interestSavedCents': interestSavedCents,
      'installmentsLeft': installmentsLeft,
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (penaltyCents != null) 'penaltyCents': penaltyCents,
      if (penaltyLegalMaxCents != null)
        'penaltyLegalMaxCents': penaltyLegalMaxCents,
      if (penaltyBasis != null) 'penaltyBasis': penaltyBasis,
      if (netSavedCents != null) 'netSavedCents': netSavedCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EarlyRepayment',
      'amountCents': amountCents,
      'interestSavedCents': interestSavedCents,
      'installmentsLeft': installmentsLeft,
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (penaltyCents != null) 'penaltyCents': penaltyCents,
      if (penaltyLegalMaxCents != null)
        'penaltyLegalMaxCents': penaltyLegalMaxCents,
      if (penaltyBasis != null) 'penaltyBasis': penaltyBasis,
      if (netSavedCents != null) 'netSavedCents': netSavedCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EarlyRepaymentImpl extends EarlyRepayment {
  _EarlyRepaymentImpl({
    required int amountCents,
    required int interestSavedCents,
    required int installmentsLeft,
    DateTime? endDate,
    int? penaltyCents,
    int? penaltyLegalMaxCents,
    String? penaltyBasis,
    int? netSavedCents,
  }) : super._(
         amountCents: amountCents,
         interestSavedCents: interestSavedCents,
         installmentsLeft: installmentsLeft,
         endDate: endDate,
         penaltyCents: penaltyCents,
         penaltyLegalMaxCents: penaltyLegalMaxCents,
         penaltyBasis: penaltyBasis,
         netSavedCents: netSavedCents,
       );

  /// Returns a shallow copy of this [EarlyRepayment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EarlyRepayment copyWith({
    int? amountCents,
    int? interestSavedCents,
    int? installmentsLeft,
    Object? endDate = _Undefined,
    Object? penaltyCents = _Undefined,
    Object? penaltyLegalMaxCents = _Undefined,
    Object? penaltyBasis = _Undefined,
    Object? netSavedCents = _Undefined,
  }) {
    return EarlyRepayment(
      amountCents: amountCents ?? this.amountCents,
      interestSavedCents: interestSavedCents ?? this.interestSavedCents,
      installmentsLeft: installmentsLeft ?? this.installmentsLeft,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      penaltyCents: penaltyCents is int? ? penaltyCents : this.penaltyCents,
      penaltyLegalMaxCents: penaltyLegalMaxCents is int?
          ? penaltyLegalMaxCents
          : this.penaltyLegalMaxCents,
      penaltyBasis: penaltyBasis is String? ? penaltyBasis : this.penaltyBasis,
      netSavedCents: netSavedCents is int? ? netSavedCents : this.netSavedCents,
    );
  }
}
