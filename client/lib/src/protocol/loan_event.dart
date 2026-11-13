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
/// duration, money drawn (revolving credit, > 0) or repaid early (< 0), a
/// pause of instalments (interest only, or nothing paid and the interest
/// added to what is owed when pauseCapitalized).
/// Kept in the loan; the schedule is computed again from them.
abstract class LoanEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LoanEvent._({
    required this.date,
    this.annualRateMilli,
    this.paymentCents,
    this.remainingMonths,
    this.drawCents,
    this.pauseMonths,
    this.pauseCapitalized,
    this.note,
  });

  factory LoanEvent({
    required DateTime date,
    int? annualRateMilli,
    int? paymentCents,
    int? remainingMonths,
    int? drawCents,
    int? pauseMonths,
    bool? pauseCapitalized,
    String? note,
  }) = _LoanEventImpl;

  factory LoanEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanEvent(
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      annualRateMilli: jsonSerialization['annualRateMilli'] as int?,
      paymentCents: jsonSerialization['paymentCents'] as int?,
      remainingMonths: jsonSerialization['remainingMonths'] as int?,
      drawCents: jsonSerialization['drawCents'] as int?,
      pauseMonths: jsonSerialization['pauseMonths'] as int?,
      pauseCapitalized: jsonSerialization['pauseCapitalized'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['pauseCapitalized'],
            ),
      note: jsonSerialization['note'] as String?,
    );
  }

  DateTime date;

  int? annualRateMilli;

  int? paymentCents;

  int? remainingMonths;

  int? drawCents;

  int? pauseMonths;

  bool? pauseCapitalized;

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
    int? pauseMonths,
    bool? pauseCapitalized,
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
      if (pauseMonths != null) 'pauseMonths': pauseMonths,
      if (pauseCapitalized != null) 'pauseCapitalized': pauseCapitalized,
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
      if (pauseMonths != null) 'pauseMonths': pauseMonths,
      if (pauseCapitalized != null) 'pauseCapitalized': pauseCapitalized,
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
    int? pauseMonths,
    bool? pauseCapitalized,
    String? note,
  }) : super._(
         date: date,
         annualRateMilli: annualRateMilli,
         paymentCents: paymentCents,
         remainingMonths: remainingMonths,
         drawCents: drawCents,
         pauseMonths: pauseMonths,
         pauseCapitalized: pauseCapitalized,
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
    Object? pauseMonths = _Undefined,
    Object? pauseCapitalized = _Undefined,
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
      pauseMonths: pauseMonths is int? ? pauseMonths : this.pauseMonths,
      pauseCapitalized: pauseCapitalized is bool?
          ? pauseCapitalized
          : this.pauseCapitalized,
      note: note is String? ? note : this.note,
    );
  }
}
