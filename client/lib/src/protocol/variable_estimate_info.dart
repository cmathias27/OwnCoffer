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
import 'variable_category_info.dart' as _ic7yx6at;

/// Variable spending (groceries, fuel…) estimated from the previous months
/// and counted in the forecast; every figure is shown to the user.
abstract class VariableEstimateInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  VariableEstimateInfo._({
    required this.monthlyCents,
    required this.spentThisMonthCents,
    required this.leftThisMonthCents,
    required this.horizonCents,
    required this.months,
    required this.categories,
  });

  factory VariableEstimateInfo({
    required int monthlyCents,
    required int spentThisMonthCents,
    required int leftThisMonthCents,
    required int horizonCents,
    required List<DateTime> months,
    required List<_ic7yx6at.VariableCategoryInfo> categories,
  }) = _VariableEstimateInfoImpl;

  factory VariableEstimateInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VariableEstimateInfo(
      monthlyCents: jsonSerialization['monthlyCents'] as int,
      spentThisMonthCents: jsonSerialization['spentThisMonthCents'] as int,
      leftThisMonthCents: jsonSerialization['leftThisMonthCents'] as int,
      horizonCents: jsonSerialization['horizonCents'] as int,
      months: _iylp5nsw.Protocol().deserialize<List<DateTime>>(
        jsonSerialization['months'],
      ),
      categories: _iylp5nsw.Protocol()
          .deserialize<List<_ic7yx6at.VariableCategoryInfo>>(
            jsonSerialization['categories'],
          ),
    );
  }

  /// Usual amount of a month: sum of the categories' medians.
  int monthlyCents;

  /// Already spent this month, and still expected until its end.
  int spentThisMonthCents;

  int leftThisMonthCents;

  /// Counted in the forecast, up to its last day.
  int horizonCents;

  /// First day of each complete month used, oldest first (empty: not enough
  /// history).
  List<DateTime> months;

  List<_ic7yx6at.VariableCategoryInfo> categories;

  /// Returns a shallow copy of this [VariableEstimateInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  VariableEstimateInfo copyWith({
    int? monthlyCents,
    int? spentThisMonthCents,
    int? leftThisMonthCents,
    int? horizonCents,
    List<DateTime>? months,
    List<_ic7yx6at.VariableCategoryInfo>? categories,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VariableEstimateInfo',
      'monthlyCents': monthlyCents,
      'spentThisMonthCents': spentThisMonthCents,
      'leftThisMonthCents': leftThisMonthCents,
      'horizonCents': horizonCents,
      'months': months.toJson(valueToJson: (v) => v.toJson()),
      'categories': categories.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VariableEstimateInfo',
      'monthlyCents': monthlyCents,
      'spentThisMonthCents': spentThisMonthCents,
      'leftThisMonthCents': leftThisMonthCents,
      'horizonCents': horizonCents,
      'months': months.toJson(valueToJson: (v) => v.toJson()),
      'categories': categories.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _VariableEstimateInfoImpl extends VariableEstimateInfo {
  _VariableEstimateInfoImpl({
    required int monthlyCents,
    required int spentThisMonthCents,
    required int leftThisMonthCents,
    required int horizonCents,
    required List<DateTime> months,
    required List<_ic7yx6at.VariableCategoryInfo> categories,
  }) : super._(
         monthlyCents: monthlyCents,
         spentThisMonthCents: spentThisMonthCents,
         leftThisMonthCents: leftThisMonthCents,
         horizonCents: horizonCents,
         months: months,
         categories: categories,
       );

  /// Returns a shallow copy of this [VariableEstimateInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  VariableEstimateInfo copyWith({
    int? monthlyCents,
    int? spentThisMonthCents,
    int? leftThisMonthCents,
    int? horizonCents,
    List<DateTime>? months,
    List<_ic7yx6at.VariableCategoryInfo>? categories,
  }) {
    return VariableEstimateInfo(
      monthlyCents: monthlyCents ?? this.monthlyCents,
      spentThisMonthCents: spentThisMonthCents ?? this.spentThisMonthCents,
      leftThisMonthCents: leftThisMonthCents ?? this.leftThisMonthCents,
      horizonCents: horizonCents ?? this.horizonCents,
      months: months ?? this.months.map((e0) => e0).toList(),
      categories:
          categories ?? this.categories.map((e0) => e0.copyWith()).toList(),
    );
  }
}
