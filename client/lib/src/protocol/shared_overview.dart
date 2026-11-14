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
import 'member_balance.dart' as _iqlvsnfo;
import 'settlement_info.dart' as _iwe8qrap;
import 'shared_expense.dart' as _ikg9hqha;

/// Shared expenses of the group, balances and repayments to settle them
/// (core.sharedBalances, core.settle).
abstract class SharedOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SharedOverview._({
    required this.expenses,
    required this.balances,
    required this.settlements,
  });

  factory SharedOverview({
    required List<_ikg9hqha.SharedExpense> expenses,
    required List<_iqlvsnfo.MemberBalance> balances,
    required List<_iwe8qrap.SettlementInfo> settlements,
  }) = _SharedOverviewImpl;

  factory SharedOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedOverview(
      expenses: _iylp5nsw.Protocol().deserialize<List<_ikg9hqha.SharedExpense>>(
        jsonSerialization['expenses'],
      ),
      balances: _iylp5nsw.Protocol().deserialize<List<_iqlvsnfo.MemberBalance>>(
        jsonSerialization['balances'],
      ),
      settlements: _iylp5nsw.Protocol()
          .deserialize<List<_iwe8qrap.SettlementInfo>>(
            jsonSerialization['settlements'],
          ),
    );
  }

  List<_ikg9hqha.SharedExpense> expenses;

  List<_iqlvsnfo.MemberBalance> balances;

  List<_iwe8qrap.SettlementInfo> settlements;

  /// Returns a shallow copy of this [SharedOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SharedOverview copyWith({
    List<_ikg9hqha.SharedExpense>? expenses,
    List<_iqlvsnfo.MemberBalance>? balances,
    List<_iwe8qrap.SettlementInfo>? settlements,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedOverview',
      'expenses': expenses.toJson(valueToJson: (v) => v.toJson()),
      'balances': balances.toJson(valueToJson: (v) => v.toJson()),
      'settlements': settlements.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedOverview',
      'expenses': expenses.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'balances': balances.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'settlements': settlements.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SharedOverviewImpl extends SharedOverview {
  _SharedOverviewImpl({
    required List<_ikg9hqha.SharedExpense> expenses,
    required List<_iqlvsnfo.MemberBalance> balances,
    required List<_iwe8qrap.SettlementInfo> settlements,
  }) : super._(
         expenses: expenses,
         balances: balances,
         settlements: settlements,
       );

  /// Returns a shallow copy of this [SharedOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SharedOverview copyWith({
    List<_ikg9hqha.SharedExpense>? expenses,
    List<_iqlvsnfo.MemberBalance>? balances,
    List<_iwe8qrap.SettlementInfo>? settlements,
  }) {
    return SharedOverview(
      expenses: expenses ?? this.expenses.map((e0) => e0.copyWith()).toList(),
      balances: balances ?? this.balances.map((e0) => e0.copyWith()).toList(),
      settlements:
          settlements ?? this.settlements.map((e0) => e0.copyWith()).toList(),
    );
  }
}
