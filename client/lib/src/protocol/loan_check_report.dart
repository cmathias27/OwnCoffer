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
import 'loan_check_line.dart' as _implde5j;

/// The loan's instalments compared with the real debits of its account,
/// by the engine (decision 0040).
abstract class LoanCheckReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LoanCheckReport._({
    required this.available,
    this.historyFrom,
    this.historyTo,
    required this.paidCount,
    required this.lines,
  });

  factory LoanCheckReport({
    required bool available,
    DateTime? historyFrom,
    DateTime? historyTo,
    required int paidCount,
    required List<_implde5j.LoanCheckLine> lines,
  }) = _LoanCheckReportImpl;

  factory LoanCheckReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanCheckReport(
      available: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['available'],
      ),
      historyFrom: jsonSerialization['historyFrom'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['historyFrom'],
            ),
      historyTo: jsonSerialization['historyTo'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['historyTo']),
      paidCount: jsonSerialization['paidCount'] as int,
      lines: _iylp5nsw.Protocol().deserialize<List<_implde5j.LoanCheckLine>>(
        jsonSerialization['lines'],
      ),
    );
  }

  /// False when the loan has no account the user can see or the account
  /// has no operation yet: nothing to compare.
  bool available;

  /// Imported history of the account used for the comparison.
  DateTime? historyFrom;

  DateTime? historyTo;

  /// Instalments of that history debited once at the right amount.
  int paidCount;

  /// Everything else, missing and wrong instalments by date first, then
  /// unexpected debits.
  List<_implde5j.LoanCheckLine> lines;

  /// Returns a shallow copy of this [LoanCheckReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LoanCheckReport copyWith({
    bool? available,
    DateTime? historyFrom,
    DateTime? historyTo,
    int? paidCount,
    List<_implde5j.LoanCheckLine>? lines,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanCheckReport',
      'available': available,
      if (historyFrom != null) 'historyFrom': historyFrom?.toJson(),
      if (historyTo != null) 'historyTo': historyTo?.toJson(),
      'paidCount': paidCount,
      'lines': lines.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanCheckReport',
      'available': available,
      if (historyFrom != null) 'historyFrom': historyFrom?.toJson(),
      if (historyTo != null) 'historyTo': historyTo?.toJson(),
      'paidCount': paidCount,
      'lines': lines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanCheckReportImpl extends LoanCheckReport {
  _LoanCheckReportImpl({
    required bool available,
    DateTime? historyFrom,
    DateTime? historyTo,
    required int paidCount,
    required List<_implde5j.LoanCheckLine> lines,
  }) : super._(
         available: available,
         historyFrom: historyFrom,
         historyTo: historyTo,
         paidCount: paidCount,
         lines: lines,
       );

  /// Returns a shallow copy of this [LoanCheckReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LoanCheckReport copyWith({
    bool? available,
    Object? historyFrom = _Undefined,
    Object? historyTo = _Undefined,
    int? paidCount,
    List<_implde5j.LoanCheckLine>? lines,
  }) {
    return LoanCheckReport(
      available: available ?? this.available,
      historyFrom: historyFrom is DateTime? ? historyFrom : this.historyFrom,
      historyTo: historyTo is DateTime? ? historyTo : this.historyTo,
      paidCount: paidCount ?? this.paidCount,
      lines: lines ?? this.lines.map((e0) => e0.copyWith()).toList(),
    );
  }
}
