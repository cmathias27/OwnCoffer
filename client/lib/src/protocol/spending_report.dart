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
import 'budget_period.dart' as _ixjzi4yl;
import 'category_flow.dart' as _i8msyna2;
import 'period_totals.dart' as _imctw77w;

/// Income, expenses and their split by category over one period, with the
/// previous periods for comparison.
abstract class SpendingReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SpendingReport._({
    required this.period,
    required this.start,
    required this.last,
    required this.incomeCents,
    required this.expenseCents,
    required this.savingsCents,
    required this.netCents,
    required this.unclassifiedCount,
    required this.unclassifiedInCents,
    required this.unclassifiedOutCents,
    required this.categories,
    required this.history,
  });

  factory SpendingReport({
    required _ixjzi4yl.BudgetPeriod period,
    required DateTime start,
    required DateTime last,
    required int incomeCents,
    required int expenseCents,
    required int savingsCents,
    required int netCents,
    required int unclassifiedCount,
    required int unclassifiedInCents,
    required int unclassifiedOutCents,
    required List<_i8msyna2.CategoryFlow> categories,
    required List<_imctw77w.PeriodTotals> history,
  }) = _SpendingReportImpl;

  factory SpendingReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return SpendingReport(
      period: _ixjzi4yl.BudgetPeriod.fromJson(
        (jsonSerialization['period'] as String),
      ),
      start: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['start']),
      last: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['last']),
      incomeCents: jsonSerialization['incomeCents'] as int,
      expenseCents: jsonSerialization['expenseCents'] as int,
      savingsCents: jsonSerialization['savingsCents'] as int,
      netCents: jsonSerialization['netCents'] as int,
      unclassifiedCount: jsonSerialization['unclassifiedCount'] as int,
      unclassifiedInCents: jsonSerialization['unclassifiedInCents'] as int,
      unclassifiedOutCents: jsonSerialization['unclassifiedOutCents'] as int,
      categories: _iylp5nsw.Protocol()
          .deserialize<List<_i8msyna2.CategoryFlow>>(
            jsonSerialization['categories'],
          ),
      history: _iylp5nsw.Protocol().deserialize<List<_imctw77w.PeriodTotals>>(
        jsonSerialization['history'],
      ),
    );
  }

  _ixjzi4yl.BudgetPeriod period;

  /// First and last day (UTC midnight).
  DateTime start;

  DateTime last;

  int incomeCents;

  int expenseCents;

  int savingsCents;

  int netCents;

  int unclassifiedCount;

  int unclassifiedInCents;

  int unclassifiedOutCents;

  List<_i8msyna2.CategoryFlow> categories;

  /// Six periods, oldest first, the current one last.
  List<_imctw77w.PeriodTotals> history;

  /// Returns a shallow copy of this [SpendingReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SpendingReport copyWith({
    _ixjzi4yl.BudgetPeriod? period,
    DateTime? start,
    DateTime? last,
    int? incomeCents,
    int? expenseCents,
    int? savingsCents,
    int? netCents,
    int? unclassifiedCount,
    int? unclassifiedInCents,
    int? unclassifiedOutCents,
    List<_i8msyna2.CategoryFlow>? categories,
    List<_imctw77w.PeriodTotals>? history,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SpendingReport',
      'period': period.toJson(),
      'start': start.toJson(),
      'last': last.toJson(),
      'incomeCents': incomeCents,
      'expenseCents': expenseCents,
      'savingsCents': savingsCents,
      'netCents': netCents,
      'unclassifiedCount': unclassifiedCount,
      'unclassifiedInCents': unclassifiedInCents,
      'unclassifiedOutCents': unclassifiedOutCents,
      'categories': categories.toJson(valueToJson: (v) => v.toJson()),
      'history': history.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SpendingReport',
      'period': period.toJson(),
      'start': start.toJson(),
      'last': last.toJson(),
      'incomeCents': incomeCents,
      'expenseCents': expenseCents,
      'savingsCents': savingsCents,
      'netCents': netCents,
      'unclassifiedCount': unclassifiedCount,
      'unclassifiedInCents': unclassifiedInCents,
      'unclassifiedOutCents': unclassifiedOutCents,
      'categories': categories.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'history': history.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SpendingReportImpl extends SpendingReport {
  _SpendingReportImpl({
    required _ixjzi4yl.BudgetPeriod period,
    required DateTime start,
    required DateTime last,
    required int incomeCents,
    required int expenseCents,
    required int savingsCents,
    required int netCents,
    required int unclassifiedCount,
    required int unclassifiedInCents,
    required int unclassifiedOutCents,
    required List<_i8msyna2.CategoryFlow> categories,
    required List<_imctw77w.PeriodTotals> history,
  }) : super._(
         period: period,
         start: start,
         last: last,
         incomeCents: incomeCents,
         expenseCents: expenseCents,
         savingsCents: savingsCents,
         netCents: netCents,
         unclassifiedCount: unclassifiedCount,
         unclassifiedInCents: unclassifiedInCents,
         unclassifiedOutCents: unclassifiedOutCents,
         categories: categories,
         history: history,
       );

  /// Returns a shallow copy of this [SpendingReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SpendingReport copyWith({
    _ixjzi4yl.BudgetPeriod? period,
    DateTime? start,
    DateTime? last,
    int? incomeCents,
    int? expenseCents,
    int? savingsCents,
    int? netCents,
    int? unclassifiedCount,
    int? unclassifiedInCents,
    int? unclassifiedOutCents,
    List<_i8msyna2.CategoryFlow>? categories,
    List<_imctw77w.PeriodTotals>? history,
  }) {
    return SpendingReport(
      period: period ?? this.period,
      start: start ?? this.start,
      last: last ?? this.last,
      incomeCents: incomeCents ?? this.incomeCents,
      expenseCents: expenseCents ?? this.expenseCents,
      savingsCents: savingsCents ?? this.savingsCents,
      netCents: netCents ?? this.netCents,
      unclassifiedCount: unclassifiedCount ?? this.unclassifiedCount,
      unclassifiedInCents: unclassifiedInCents ?? this.unclassifiedInCents,
      unclassifiedOutCents: unclassifiedOutCents ?? this.unclassifiedOutCents,
      categories:
          categories ?? this.categories.map((e0) => e0.copyWith()).toList(),
      history: history ?? this.history.map((e0) => e0.copyWith()).toList(),
    );
  }
}
