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

/// A loan with and without a change (renegotiation, new rate), computed
/// by the loan engine (core.compareLoanChange). Nothing is saved.
abstract class LoanChangeSimulation
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LoanChangeSimulation._({
    required this.paymentBeforeCents,
    required this.paymentAfterCents,
    required this.interestBeforeCents,
    required this.interestAfterCents,
    required this.instalmentsBefore,
    required this.instalmentsAfter,
    required this.endBefore,
    required this.endAfter,
    required this.feesCents,
    required this.savingCents,
    this.breakEvenMonth,
  });

  factory LoanChangeSimulation({
    required int paymentBeforeCents,
    required int paymentAfterCents,
    required int interestBeforeCents,
    required int interestAfterCents,
    required int instalmentsBefore,
    required int instalmentsAfter,
    required DateTime endBefore,
    required DateTime endAfter,
    required int feesCents,
    required int savingCents,
    int? breakEvenMonth,
  }) = _LoanChangeSimulationImpl;

  factory LoanChangeSimulation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LoanChangeSimulation(
      paymentBeforeCents: jsonSerialization['paymentBeforeCents'] as int,
      paymentAfterCents: jsonSerialization['paymentAfterCents'] as int,
      interestBeforeCents: jsonSerialization['interestBeforeCents'] as int,
      interestAfterCents: jsonSerialization['interestAfterCents'] as int,
      instalmentsBefore: jsonSerialization['instalmentsBefore'] as int,
      instalmentsAfter: jsonSerialization['instalmentsAfter'] as int,
      endBefore: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['endBefore'],
      ),
      endAfter: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['endAfter'],
      ),
      feesCents: jsonSerialization['feesCents'] as int,
      savingCents: jsonSerialization['savingCents'] as int,
      breakEvenMonth: jsonSerialization['breakEvenMonth'] as int?,
    );
  }

  int paymentBeforeCents;

  int paymentAfterCents;

  int interestBeforeCents;

  int interestAfterCents;

  int instalmentsBefore;

  int instalmentsAfter;

  DateTime endBefore;

  DateTime endAfter;

  int feesCents;

  /// Interest saved, fees taken off (negative: the change costs more).
  int savingCents;

  /// Months after the change by which it has paid off; null if never.
  int? breakEvenMonth;

  /// Returns a shallow copy of this [LoanChangeSimulation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LoanChangeSimulation copyWith({
    int? paymentBeforeCents,
    int? paymentAfterCents,
    int? interestBeforeCents,
    int? interestAfterCents,
    int? instalmentsBefore,
    int? instalmentsAfter,
    DateTime? endBefore,
    DateTime? endAfter,
    int? feesCents,
    int? savingCents,
    int? breakEvenMonth,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanChangeSimulation',
      'paymentBeforeCents': paymentBeforeCents,
      'paymentAfterCents': paymentAfterCents,
      'interestBeforeCents': interestBeforeCents,
      'interestAfterCents': interestAfterCents,
      'instalmentsBefore': instalmentsBefore,
      'instalmentsAfter': instalmentsAfter,
      'endBefore': endBefore.toJson(),
      'endAfter': endAfter.toJson(),
      'feesCents': feesCents,
      'savingCents': savingCents,
      if (breakEvenMonth != null) 'breakEvenMonth': breakEvenMonth,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanChangeSimulation',
      'paymentBeforeCents': paymentBeforeCents,
      'paymentAfterCents': paymentAfterCents,
      'interestBeforeCents': interestBeforeCents,
      'interestAfterCents': interestAfterCents,
      'instalmentsBefore': instalmentsBefore,
      'instalmentsAfter': instalmentsAfter,
      'endBefore': endBefore.toJson(),
      'endAfter': endAfter.toJson(),
      'feesCents': feesCents,
      'savingCents': savingCents,
      if (breakEvenMonth != null) 'breakEvenMonth': breakEvenMonth,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanChangeSimulationImpl extends LoanChangeSimulation {
  _LoanChangeSimulationImpl({
    required int paymentBeforeCents,
    required int paymentAfterCents,
    required int interestBeforeCents,
    required int interestAfterCents,
    required int instalmentsBefore,
    required int instalmentsAfter,
    required DateTime endBefore,
    required DateTime endAfter,
    required int feesCents,
    required int savingCents,
    int? breakEvenMonth,
  }) : super._(
         paymentBeforeCents: paymentBeforeCents,
         paymentAfterCents: paymentAfterCents,
         interestBeforeCents: interestBeforeCents,
         interestAfterCents: interestAfterCents,
         instalmentsBefore: instalmentsBefore,
         instalmentsAfter: instalmentsAfter,
         endBefore: endBefore,
         endAfter: endAfter,
         feesCents: feesCents,
         savingCents: savingCents,
         breakEvenMonth: breakEvenMonth,
       );

  /// Returns a shallow copy of this [LoanChangeSimulation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LoanChangeSimulation copyWith({
    int? paymentBeforeCents,
    int? paymentAfterCents,
    int? interestBeforeCents,
    int? interestAfterCents,
    int? instalmentsBefore,
    int? instalmentsAfter,
    DateTime? endBefore,
    DateTime? endAfter,
    int? feesCents,
    int? savingCents,
    Object? breakEvenMonth = _Undefined,
  }) {
    return LoanChangeSimulation(
      paymentBeforeCents: paymentBeforeCents ?? this.paymentBeforeCents,
      paymentAfterCents: paymentAfterCents ?? this.paymentAfterCents,
      interestBeforeCents: interestBeforeCents ?? this.interestBeforeCents,
      interestAfterCents: interestAfterCents ?? this.interestAfterCents,
      instalmentsBefore: instalmentsBefore ?? this.instalmentsBefore,
      instalmentsAfter: instalmentsAfter ?? this.instalmentsAfter,
      endBefore: endBefore ?? this.endBefore,
      endAfter: endAfter ?? this.endAfter,
      feesCents: feesCents ?? this.feesCents,
      savingCents: savingCents ?? this.savingCents,
      breakEvenMonth: breakEvenMonth is int?
          ? breakEvenMonth
          : this.breakEvenMonth,
    );
  }
}
