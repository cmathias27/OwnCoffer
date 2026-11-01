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

/// Something that changed a loan from a date on (core.LoanChange): a new
/// rate (variable rate, renegotiation), a new instalment, a new remaining
/// duration, money drawn (revolving credit, > 0) or repaid early (< 0).
/// Kept in the loan; the schedule is computed again from them.
abstract class LoanEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LoanEvent._({
    required this.date,
    this.annualRateMilli,
    this.paymentCents,
    this.remainingMonths,
    this.drawCents,
    this.note,
  });

  factory LoanEvent({
    required DateTime date,
    int? annualRateMilli,
    int? paymentCents,
    int? remainingMonths,
    int? drawCents,
    String? note,
  }) = _LoanEventImpl;

  factory LoanEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanEvent(
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      annualRateMilli: jsonSerialization['annualRateMilli'] as int?,
      paymentCents: jsonSerialization['paymentCents'] as int?,
      remainingMonths: jsonSerialization['remainingMonths'] as int?,
      drawCents: jsonSerialization['drawCents'] as int?,
      note: jsonSerialization['note'] as String?,
    );
  }

  DateTime date;

  int? annualRateMilli;

  int? paymentCents;

  int? remainingMonths;

  int? drawCents;

  String? note;

  /// Returns a shallow copy of this [LoanEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LoanEvent copyWith({
    DateTime? date,
    int? annualRateMilli,
    int? paymentCents,
    int? remainingMonths,
    int? drawCents,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanEvent',
      'date': date.toJson(),
      if (annualRateMilli != null) 'annualRateMilli': annualRateMilli,
      if (paymentCents != null) 'paymentCents': paymentCents,
      if (remainingMonths != null) 'remainingMonths': remainingMonths,
      if (drawCents != null) 'drawCents': drawCents,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanEvent',
      'date': date.toJson(),
      if (annualRateMilli != null) 'annualRateMilli': annualRateMilli,
      if (paymentCents != null) 'paymentCents': paymentCents,
      if (remainingMonths != null) 'remainingMonths': remainingMonths,
      if (drawCents != null) 'drawCents': drawCents,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanEventImpl extends LoanEvent {
  _LoanEventImpl({
    required DateTime date,
    int? annualRateMilli,
    int? paymentCents,
    int? remainingMonths,
    int? drawCents,
    String? note,
  }) : super._(
         date: date,
         annualRateMilli: annualRateMilli,
         paymentCents: paymentCents,
         remainingMonths: remainingMonths,
         drawCents: drawCents,
         note: note,
       );

  /// Returns a shallow copy of this [LoanEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LoanEvent copyWith({
    DateTime? date,
    Object? annualRateMilli = _Undefined,
    Object? paymentCents = _Undefined,
    Object? remainingMonths = _Undefined,
    Object? drawCents = _Undefined,
    Object? note = _Undefined,
  }) {
    return LoanEvent(
      date: date ?? this.date,
      annualRateMilli: annualRateMilli is int?
          ? annualRateMilli
          : this.annualRateMilli,
      paymentCents: paymentCents is int? ? paymentCents : this.paymentCents,
      remainingMonths: remainingMonths is int?
          ? remainingMonths
          : this.remainingMonths,
      drawCents: drawCents is int? ? drawCents : this.drawCents,
      note: note is String? ? note : this.note,
    );
  }
}
