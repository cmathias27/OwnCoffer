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

abstract class YearCategoryLine
    implements _is.SerializableModel, _is.ProtocolSerialization {
  YearCategoryLine._({
    required this.categoryId,
    required this.amountCents,
    required this.count,
  });

  factory YearCategoryLine({
    required int categoryId,
    required int amountCents,
    required int count,
  }) = _YearCategoryLineImpl;

  factory YearCategoryLine.fromJson(Map<String, dynamic> jsonSerialization) {
    return YearCategoryLine(
      categoryId: jsonSerialization['categoryId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      count: jsonSerialization['count'] as int,
    );
  }

  int categoryId;

  int amountCents;

  int count;

  /// Returns a shallow copy of this [YearCategoryLine]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  YearCategoryLine copyWith({
    int? categoryId,
    int? amountCents,
    int? count,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'YearCategoryLine',
      'categoryId': categoryId,
      'amountCents': amountCents,
      'count': count,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'YearCategoryLine',
      'categoryId': categoryId,
      'amountCents': amountCents,
      'count': count,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _YearCategoryLineImpl extends YearCategoryLine {
  _YearCategoryLineImpl({
    required int categoryId,
    required int amountCents,
    required int count,
  }) : super._(
         categoryId: categoryId,
         amountCents: amountCents,
         count: count,
       );

  /// Returns a shallow copy of this [YearCategoryLine]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  YearCategoryLine copyWith({
    int? categoryId,
    int? amountCents,
    int? count,
  }) {
    return YearCategoryLine(
      categoryId: categoryId ?? this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      count: count ?? this.count,
    );
  }
}
