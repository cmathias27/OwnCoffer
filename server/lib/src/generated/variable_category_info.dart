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
import 'package:owncoffer_server/src/generated/protocol.dart' as _itdod8fx;
import 'package:serverpod/serverpod.dart' as _is;

/// What one category usually costs in a month (null id: unclassified).
abstract class VariableCategoryInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  VariableCategoryInfo._({
    this.categoryId,
    required this.monthsCents,
    required this.monthlyCents,
  });

  factory VariableCategoryInfo({
    int? categoryId,
    required List<int> monthsCents,
    required int monthlyCents,
  }) = _VariableCategoryInfoImpl;

  factory VariableCategoryInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VariableCategoryInfo(
      categoryId: jsonSerialization['categoryId'] as int?,
      monthsCents: _itdod8fx.Protocol().deserialize<List<int>>(
        jsonSerialization['monthsCents'],
      ),
      monthlyCents: jsonSerialization['monthlyCents'] as int,
    );
  }

  int? categoryId;

  /// Spending of each month used, oldest first.
  List<int> monthsCents;

  /// Median of those months.
  int monthlyCents;

  /// Returns a shallow copy of this [VariableCategoryInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VariableCategoryInfo copyWith({
    int? categoryId,
    List<int>? monthsCents,
    int? monthlyCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VariableCategoryInfo',
      if (categoryId != null) 'categoryId': categoryId,
      'monthsCents': monthsCents.toJson(),
      'monthlyCents': monthlyCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VariableCategoryInfo',
      if (categoryId != null) 'categoryId': categoryId,
      'monthsCents': monthsCents.toJson(),
      'monthlyCents': monthlyCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VariableCategoryInfoImpl extends VariableCategoryInfo {
  _VariableCategoryInfoImpl({
    int? categoryId,
    required List<int> monthsCents,
    required int monthlyCents,
  }) : super._(
         categoryId: categoryId,
         monthsCents: monthsCents,
         monthlyCents: monthlyCents,
       );

  /// Returns a shallow copy of this [VariableCategoryInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VariableCategoryInfo copyWith({
    Object? categoryId = _Undefined,
    List<int>? monthsCents,
    int? monthlyCents,
  }) {
    return VariableCategoryInfo(
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      monthsCents: monthsCents ?? this.monthsCents.map((e0) => e0).toList(),
      monthlyCents: monthlyCents ?? this.monthlyCents,
    );
  }
}
