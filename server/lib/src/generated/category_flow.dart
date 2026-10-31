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

/// Money received or spent in a category over a period, its
/// sub-categories included (positive amounts; see SpendingSummary).
abstract class CategoryFlow
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CategoryFlow._({
    required this.categoryId,
    required this.amountCents,
    required this.count,
    required this.previousCents,
    required this.averageCents,
    this.goalCents,
  });

  factory CategoryFlow({
    required int categoryId,
    required int amountCents,
    required int count,
    required int previousCents,
    required int averageCents,
    int? goalCents,
  }) = _CategoryFlowImpl;

  factory CategoryFlow.fromJson(Map<String, dynamic> jsonSerialization) {
    return CategoryFlow(
      categoryId: jsonSerialization['categoryId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      count: jsonSerialization['count'] as int,
      previousCents: jsonSerialization['previousCents'] as int,
      averageCents: jsonSerialization['averageCents'] as int,
      goalCents: jsonSerialization['goalCents'] as int?,
    );
  }

  int categoryId;

  int amountCents;

  int count;

  /// Same category over the previous period.
  int previousCents;

  /// Average over the three previous periods.
  int averageCents;

  /// Monthly goal (month view only).
  int? goalCents;

  /// Returns a shallow copy of this [CategoryFlow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CategoryFlow copyWith({
    int? categoryId,
    int? amountCents,
    int? count,
    int? previousCents,
    int? averageCents,
    int? goalCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryFlow',
      'categoryId': categoryId,
      'amountCents': amountCents,
      'count': count,
      'previousCents': previousCents,
      'averageCents': averageCents,
      if (goalCents != null) 'goalCents': goalCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CategoryFlow',
      'categoryId': categoryId,
      'amountCents': amountCents,
      'count': count,
      'previousCents': previousCents,
      'averageCents': averageCents,
      if (goalCents != null) 'goalCents': goalCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryFlowImpl extends CategoryFlow {
  _CategoryFlowImpl({
    required int categoryId,
    required int amountCents,
    required int count,
    required int previousCents,
    required int averageCents,
    int? goalCents,
  }) : super._(
         categoryId: categoryId,
         amountCents: amountCents,
         count: count,
         previousCents: previousCents,
         averageCents: averageCents,
         goalCents: goalCents,
       );

  /// Returns a shallow copy of this [CategoryFlow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CategoryFlow copyWith({
    int? categoryId,
    int? amountCents,
    int? count,
    int? previousCents,
    int? averageCents,
    Object? goalCents = _Undefined,
  }) {
    return CategoryFlow(
      categoryId: categoryId ?? this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      count: count ?? this.count,
      previousCents: previousCents ?? this.previousCents,
      averageCents: averageCents ?? this.averageCents,
      goalCents: goalCents is int? ? goalCents : this.goalCents,
    );
  }
}
