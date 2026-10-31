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

abstract class PeriodTotals
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PeriodTotals._({
    required this.start,
    required this.incomeCents,
    required this.expenseCents,
    required this.savingsCents,
  });

  factory PeriodTotals({
    required DateTime start,
    required int incomeCents,
    required int expenseCents,
    required int savingsCents,
  }) = _PeriodTotalsImpl;

  factory PeriodTotals.fromJson(Map<String, dynamic> jsonSerialization) {
    return PeriodTotals(
      start: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['start']),
      incomeCents: jsonSerialization['incomeCents'] as int,
      expenseCents: jsonSerialization['expenseCents'] as int,
      savingsCents: jsonSerialization['savingsCents'] as int,
    );
  }

  DateTime start;

  int incomeCents;

  int expenseCents;

  int savingsCents;

  /// Returns a shallow copy of this [PeriodTotals]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PeriodTotals copyWith({
    DateTime? start,
    int? incomeCents,
    int? expenseCents,
    int? savingsCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PeriodTotals',
      'start': start.toJson(),
      'incomeCents': incomeCents,
      'expenseCents': expenseCents,
      'savingsCents': savingsCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PeriodTotals',
      'start': start.toJson(),
      'incomeCents': incomeCents,
      'expenseCents': expenseCents,
      'savingsCents': savingsCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PeriodTotalsImpl extends PeriodTotals {
  _PeriodTotalsImpl({
    required DateTime start,
    required int incomeCents,
    required int expenseCents,
    required int savingsCents,
  }) : super._(
         start: start,
         incomeCents: incomeCents,
         expenseCents: expenseCents,
         savingsCents: savingsCents,
       );

  /// Returns a shallow copy of this [PeriodTotals]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PeriodTotals copyWith({
    DateTime? start,
    int? incomeCents,
    int? expenseCents,
    int? savingsCents,
  }) {
    return PeriodTotals(
      start: start ?? this.start,
      incomeCents: incomeCents ?? this.incomeCents,
      expenseCents: expenseCents ?? this.expenseCents,
      savingsCents: savingsCents ?? this.savingsCents,
    );
  }
}
