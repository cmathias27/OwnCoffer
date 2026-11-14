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
import 'bank_transaction.dart' as _i0mjlwv3;
import 'year_category_line.dart' as _iotroukk;

/// Review of a calendar year, with the operations of the categories marked
/// for the tax return (decision 0050).
abstract class YearReview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  YearReview._({
    required this.year,
    required this.incomeCents,
    required this.expenseCents,
    required this.savingsCents,
    required this.topExpenses,
    required this.taxCategories,
    required this.taxOperations,
    required this.interestCents,
  });

  factory YearReview({
    required int year,
    required int incomeCents,
    required int expenseCents,
    required int savingsCents,
    required List<_iotroukk.YearCategoryLine> topExpenses,
    required List<_iotroukk.YearCategoryLine> taxCategories,
    required List<_i0mjlwv3.BankTransaction> taxOperations,
    required int interestCents,
  }) = _YearReviewImpl;

  factory YearReview.fromJson(Map<String, dynamic> jsonSerialization) {
    return YearReview(
      year: jsonSerialization['year'] as int,
      incomeCents: jsonSerialization['incomeCents'] as int,
      expenseCents: jsonSerialization['expenseCents'] as int,
      savingsCents: jsonSerialization['savingsCents'] as int,
      topExpenses: _iylp5nsw.Protocol()
          .deserialize<List<_iotroukk.YearCategoryLine>>(
            jsonSerialization['topExpenses'],
          ),
      taxCategories: _iylp5nsw.Protocol()
          .deserialize<List<_iotroukk.YearCategoryLine>>(
            jsonSerialization['taxCategories'],
          ),
      taxOperations: _iylp5nsw.Protocol()
          .deserialize<List<_i0mjlwv3.BankTransaction>>(
            jsonSerialization['taxOperations'],
          ),
      interestCents: jsonSerialization['interestCents'] as int,
    );
  }

  int year;

  int incomeCents;

  int expenseCents;

  int savingsCents;

  /// Expense categories, biggest first.
  List<_iotroukk.YearCategoryLine> topExpenses;

  /// Categories marked for the tax return.
  List<_iotroukk.YearCategoryLine> taxCategories;

  List<_i0mjlwv3.BankTransaction> taxOperations;

  /// Interest of the regulated savings accounts with a rate (estimate).
  int interestCents;

  /// Returns a shallow copy of this [YearReview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  YearReview copyWith({
    int? year,
    int? incomeCents,
    int? expenseCents,
    int? savingsCents,
    List<_iotroukk.YearCategoryLine>? topExpenses,
    List<_iotroukk.YearCategoryLine>? taxCategories,
    List<_i0mjlwv3.BankTransaction>? taxOperations,
    int? interestCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'YearReview',
      'year': year,
      'incomeCents': incomeCents,
      'expenseCents': expenseCents,
      'savingsCents': savingsCents,
      'topExpenses': topExpenses.toJson(valueToJson: (v) => v.toJson()),
      'taxCategories': taxCategories.toJson(valueToJson: (v) => v.toJson()),
      'taxOperations': taxOperations.toJson(valueToJson: (v) => v.toJson()),
      'interestCents': interestCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'YearReview',
      'year': year,
      'incomeCents': incomeCents,
      'expenseCents': expenseCents,
      'savingsCents': savingsCents,
      'topExpenses': topExpenses.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'taxCategories': taxCategories.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'taxOperations': taxOperations.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'interestCents': interestCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _YearReviewImpl extends YearReview {
  _YearReviewImpl({
    required int year,
    required int incomeCents,
    required int expenseCents,
    required int savingsCents,
    required List<_iotroukk.YearCategoryLine> topExpenses,
    required List<_iotroukk.YearCategoryLine> taxCategories,
    required List<_i0mjlwv3.BankTransaction> taxOperations,
    required int interestCents,
  }) : super._(
         year: year,
         incomeCents: incomeCents,
         expenseCents: expenseCents,
         savingsCents: savingsCents,
         topExpenses: topExpenses,
         taxCategories: taxCategories,
         taxOperations: taxOperations,
         interestCents: interestCents,
       );

  /// Returns a shallow copy of this [YearReview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  YearReview copyWith({
    int? year,
    int? incomeCents,
    int? expenseCents,
    int? savingsCents,
    List<_iotroukk.YearCategoryLine>? topExpenses,
    List<_iotroukk.YearCategoryLine>? taxCategories,
    List<_i0mjlwv3.BankTransaction>? taxOperations,
    int? interestCents,
  }) {
    return YearReview(
      year: year ?? this.year,
      incomeCents: incomeCents ?? this.incomeCents,
      expenseCents: expenseCents ?? this.expenseCents,
      savingsCents: savingsCents ?? this.savingsCents,
      topExpenses:
          topExpenses ?? this.topExpenses.map((e0) => e0.copyWith()).toList(),
      taxCategories:
          taxCategories ??
          this.taxCategories.map((e0) => e0.copyWith()).toList(),
      taxOperations:
          taxOperations ??
          this.taxOperations.map((e0) => e0.copyWith()).toList(),
      interestCents: interestCents ?? this.interestCents,
    );
  }
}
