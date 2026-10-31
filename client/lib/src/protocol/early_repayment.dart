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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Early repayment simulation, keeping the instalment.
abstract class EarlyRepayment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EarlyRepayment._({
    required this.amountCents,
    required this.interestSavedCents,
    required this.installmentsLeft,
    this.endDate,
  });

  factory EarlyRepayment({
    required int amountCents,
    required int interestSavedCents,
    required int installmentsLeft,
    DateTime? endDate,
  }) = _EarlyRepaymentImpl;

  factory EarlyRepayment.fromJson(Map<String, dynamic> jsonSerialization) {
    return EarlyRepayment(
      amountCents: jsonSerialization['amountCents'] as int,
      interestSavedCents: jsonSerialization['interestSavedCents'] as int,
      installmentsLeft: jsonSerialization['installmentsLeft'] as int,
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
    );
  }

  int amountCents;

  int interestSavedCents;

  int installmentsLeft;

  DateTime? endDate;

  /// Returns a shallow copy of this [EarlyRepayment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EarlyRepayment copyWith({
    int? amountCents,
    int? interestSavedCents,
    int? installmentsLeft,
    DateTime? endDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EarlyRepayment',
      'amountCents': amountCents,
      'interestSavedCents': interestSavedCents,
      'installmentsLeft': installmentsLeft,
      if (endDate != null) 'endDate': endDate?.toJson(),
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
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EarlyRepaymentImpl extends EarlyRepayment {
  _EarlyRepaymentImpl({
    required int amountCents,
    required int interestSavedCents,
    required int installmentsLeft,
    DateTime? endDate,
  }) : super._(
         amountCents: amountCents,
         interestSavedCents: interestSavedCents,
         installmentsLeft: installmentsLeft,
         endDate: endDate,
       );

  /// Returns a shallow copy of this [EarlyRepayment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EarlyRepayment copyWith({
    int? amountCents,
    int? interestSavedCents,
    int? installmentsLeft,
    Object? endDate = _Undefined,
  }) {
    return EarlyRepayment(
      amountCents: amountCents ?? this.amountCents,
      interestSavedCents: interestSavedCents ?? this.interestSavedCents,
      installmentsLeft: installmentsLeft ?? this.installmentsLeft,
      endDate: endDate is DateTime? ? endDate : this.endDate,
    );
  }
}
