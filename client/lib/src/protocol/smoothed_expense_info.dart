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

/// A planned expense less often than monthly, spread into a monthly
/// provision (core.smoothExpense).
abstract class SmoothedExpenseInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SmoothedExpenseInfo._({
    required this.scheduledId,
    required this.accountId,
    required this.label,
    required this.amountCents,
    required this.nextDue,
    required this.periodMonths,
    required this.monthlyCents,
    required this.setAsideCents,
    required this.monthsUntil,
  });

  factory SmoothedExpenseInfo({
    required int scheduledId,
    required int accountId,
    required String label,
    required int amountCents,
    required DateTime nextDue,
    required int periodMonths,
    required int monthlyCents,
    required int setAsideCents,
    required int monthsUntil,
  }) = _SmoothedExpenseInfoImpl;

  factory SmoothedExpenseInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmoothedExpenseInfo(
      scheduledId: jsonSerialization['scheduledId'] as int,
      accountId: jsonSerialization['accountId'] as int,
      label: jsonSerialization['label'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      nextDue: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['nextDue'],
      ),
      periodMonths: jsonSerialization['periodMonths'] as int,
      monthlyCents: jsonSerialization['monthlyCents'] as int,
      setAsideCents: jsonSerialization['setAsideCents'] as int,
      monthsUntil: jsonSerialization['monthsUntil'] as int,
    );
  }

  int scheduledId;

  int accountId;

  String label;

  /// Size of one occurrence, positive.
  int amountCents;

  DateTime nextDue;

  int periodMonths;

  int monthlyCents;

  int setAsideCents;

  int monthsUntil;

  /// Returns a shallow copy of this [SmoothedExpenseInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SmoothedExpenseInfo copyWith({
    int? scheduledId,
    int? accountId,
    String? label,
    int? amountCents,
    DateTime? nextDue,
    int? periodMonths,
    int? monthlyCents,
    int? setAsideCents,
    int? monthsUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SmoothedExpenseInfo',
      'scheduledId': scheduledId,
      'accountId': accountId,
      'label': label,
      'amountCents': amountCents,
      'nextDue': nextDue.toJson(),
      'periodMonths': periodMonths,
      'monthlyCents': monthlyCents,
      'setAsideCents': setAsideCents,
      'monthsUntil': monthsUntil,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SmoothedExpenseInfo',
      'scheduledId': scheduledId,
      'accountId': accountId,
      'label': label,
      'amountCents': amountCents,
      'nextDue': nextDue.toJson(),
      'periodMonths': periodMonths,
      'monthlyCents': monthlyCents,
      'setAsideCents': setAsideCents,
      'monthsUntil': monthsUntil,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SmoothedExpenseInfoImpl extends SmoothedExpenseInfo {
  _SmoothedExpenseInfoImpl({
    required int scheduledId,
    required int accountId,
    required String label,
    required int amountCents,
    required DateTime nextDue,
    required int periodMonths,
    required int monthlyCents,
    required int setAsideCents,
    required int monthsUntil,
  }) : super._(
         scheduledId: scheduledId,
         accountId: accountId,
         label: label,
         amountCents: amountCents,
         nextDue: nextDue,
         periodMonths: periodMonths,
         monthlyCents: monthlyCents,
         setAsideCents: setAsideCents,
         monthsUntil: monthsUntil,
       );

  /// Returns a shallow copy of this [SmoothedExpenseInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SmoothedExpenseInfo copyWith({
    int? scheduledId,
    int? accountId,
    String? label,
    int? amountCents,
    DateTime? nextDue,
    int? periodMonths,
    int? monthlyCents,
    int? setAsideCents,
    int? monthsUntil,
  }) {
    return SmoothedExpenseInfo(
      scheduledId: scheduledId ?? this.scheduledId,
      accountId: accountId ?? this.accountId,
      label: label ?? this.label,
      amountCents: amountCents ?? this.amountCents,
      nextDue: nextDue ?? this.nextDue,
      periodMonths: periodMonths ?? this.periodMonths,
      monthlyCents: monthlyCents ?? this.monthlyCents,
      setAsideCents: setAsideCents ?? this.setAsideCents,
      monthsUntil: monthsUntil ?? this.monthsUntil,
    );
  }
}
