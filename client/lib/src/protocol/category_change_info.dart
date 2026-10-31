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

/// A category whose spending moved against the average of the three
/// previous months.
abstract class CategoryChangeInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CategoryChangeInfo._({
    required this.categoryId,
    required this.amountCents,
    required this.averageCents,
  });

  factory CategoryChangeInfo({
    required int categoryId,
    required int amountCents,
    required int averageCents,
  }) = _CategoryChangeInfoImpl;

  factory CategoryChangeInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return CategoryChangeInfo(
      categoryId: jsonSerialization['categoryId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      averageCents: jsonSerialization['averageCents'] as int,
    );
  }

  int categoryId;

  int amountCents;

  int averageCents;

  /// Returns a shallow copy of this [CategoryChangeInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CategoryChangeInfo copyWith({
    int? categoryId,
    int? amountCents,
    int? averageCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryChangeInfo',
      'categoryId': categoryId,
      'amountCents': amountCents,
      'averageCents': averageCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CategoryChangeInfo',
      'categoryId': categoryId,
      'amountCents': amountCents,
      'averageCents': averageCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CategoryChangeInfoImpl extends CategoryChangeInfo {
  _CategoryChangeInfoImpl({
    required int categoryId,
    required int amountCents,
    required int averageCents,
  }) : super._(
         categoryId: categoryId,
         amountCents: amountCents,
         averageCents: averageCents,
       );

  /// Returns a shallow copy of this [CategoryChangeInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CategoryChangeInfo copyWith({
    int? categoryId,
    int? amountCents,
    int? averageCents,
  }) {
    return CategoryChangeInfo(
      categoryId: categoryId ?? this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      averageCents: averageCents ?? this.averageCents,
    );
  }
}
