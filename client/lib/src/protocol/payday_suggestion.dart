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

/// The pay found in an account's history and not planned yet, proposed
/// for the forecast (core.detectPayday). The user checks it before it is
/// saved as a planned operation.
abstract class PaydaySuggestion
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PaydaySuggestion._({
    required this.accountId,
    required this.label,
    required this.amountCents,
    required this.dayOfMonth,
    required this.months,
    required this.lastDate,
    required this.nextDate,
    required this.tolerancePercent,
    this.categoryId,
  });

  factory PaydaySuggestion({
    required int accountId,
    required String label,
    required int amountCents,
    required int dayOfMonth,
    required int months,
    required DateTime lastDate,
    required DateTime nextDate,
    required int tolerancePercent,
    int? categoryId,
  }) = _PaydaySuggestionImpl;

  factory PaydaySuggestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaydaySuggestion(
      accountId: jsonSerialization['accountId'] as int,
      label: jsonSerialization['label'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      dayOfMonth: jsonSerialization['dayOfMonth'] as int,
      months: jsonSerialization['months'] as int,
      lastDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastDate'],
      ),
      nextDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['nextDate'],
      ),
      tolerancePercent: jsonSerialization['tolerancePercent'] as int,
      categoryId: jsonSerialization['categoryId'] as int?,
    );
  }

  int accountId;

  /// Label without dates or references, also the match pattern.
  String label;

  /// Median of the credits read as the pay.
  int amountCents;

  int dayOfMonth;

  /// Number of months seen.
  int months;

  DateTime lastDate;

  /// First pay to plan.
  DateTime nextDate;

  /// Proposed amount tolerance for reconciliation, in percent.
  int tolerancePercent;

  /// Category of the last credit, if any.
  int? categoryId;

  /// Returns a shallow copy of this [PaydaySuggestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PaydaySuggestion copyWith({
    int? accountId,
    String? label,
    int? amountCents,
    int? dayOfMonth,
    int? months,
    DateTime? lastDate,
    DateTime? nextDate,
    int? tolerancePercent,
    int? categoryId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaydaySuggestion',
      'accountId': accountId,
      'label': label,
      'amountCents': amountCents,
      'dayOfMonth': dayOfMonth,
      'months': months,
      'lastDate': lastDate.toJson(),
      'nextDate': nextDate.toJson(),
      'tolerancePercent': tolerancePercent,
      if (categoryId != null) 'categoryId': categoryId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaydaySuggestion',
      'accountId': accountId,
      'label': label,
      'amountCents': amountCents,
      'dayOfMonth': dayOfMonth,
      'months': months,
      'lastDate': lastDate.toJson(),
      'nextDate': nextDate.toJson(),
      'tolerancePercent': tolerancePercent,
      if (categoryId != null) 'categoryId': categoryId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaydaySuggestionImpl extends PaydaySuggestion {
  _PaydaySuggestionImpl({
    required int accountId,
    required String label,
    required int amountCents,
    required int dayOfMonth,
    required int months,
    required DateTime lastDate,
    required DateTime nextDate,
    required int tolerancePercent,
    int? categoryId,
  }) : super._(
         accountId: accountId,
         label: label,
         amountCents: amountCents,
         dayOfMonth: dayOfMonth,
         months: months,
         lastDate: lastDate,
         nextDate: nextDate,
         tolerancePercent: tolerancePercent,
         categoryId: categoryId,
       );

  /// Returns a shallow copy of this [PaydaySuggestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PaydaySuggestion copyWith({
    int? accountId,
    String? label,
    int? amountCents,
    int? dayOfMonth,
    int? months,
    DateTime? lastDate,
    DateTime? nextDate,
    int? tolerancePercent,
    Object? categoryId = _Undefined,
  }) {
    return PaydaySuggestion(
      accountId: accountId ?? this.accountId,
      label: label ?? this.label,
      amountCents: amountCents ?? this.amountCents,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      months: months ?? this.months,
      lastDate: lastDate ?? this.lastDate,
      nextDate: nextDate ?? this.nextDate,
      tolerancePercent: tolerancePercent ?? this.tolerancePercent,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
    );
  }
}
