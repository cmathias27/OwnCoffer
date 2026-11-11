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

/// The 30-day forecast of one account, in a few figures (decision 0035).
abstract class AccountForecastSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AccountForecastSummary._({
    required this.accountId,
    required this.accountName,
    required this.currency,
    required this.currentBalanceCents,
    required this.endBalanceCents,
    required this.lowestBalanceCents,
    required this.lowestDate,
    required this.alertThresholdCents,
    this.firstBelowThresholdDate,
    required this.plannedDebitsCents,
    required this.plannedCreditsCents,
    required this.missedCount,
  });

  factory AccountForecastSummary({
    required int accountId,
    required String accountName,
    required String currency,
    required int currentBalanceCents,
    required int endBalanceCents,
    required int lowestBalanceCents,
    required DateTime lowestDate,
    required int alertThresholdCents,
    DateTime? firstBelowThresholdDate,
    required int plannedDebitsCents,
    required int plannedCreditsCents,
    required int missedCount,
  }) = _AccountForecastSummaryImpl;

  factory AccountForecastSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountForecastSummary(
      accountId: jsonSerialization['accountId'] as int,
      accountName: jsonSerialization['accountName'] as String,
      currency: jsonSerialization['currency'] as String,
      currentBalanceCents: jsonSerialization['currentBalanceCents'] as int,
      endBalanceCents: jsonSerialization['endBalanceCents'] as int,
      lowestBalanceCents: jsonSerialization['lowestBalanceCents'] as int,
      lowestDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lowestDate'],
      ),
      alertThresholdCents: jsonSerialization['alertThresholdCents'] as int,
      firstBelowThresholdDate:
          jsonSerialization['firstBelowThresholdDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstBelowThresholdDate'],
            ),
      plannedDebitsCents: jsonSerialization['plannedDebitsCents'] as int,
      plannedCreditsCents: jsonSerialization['plannedCreditsCents'] as int,
      missedCount: jsonSerialization['missedCount'] as int,
    );
  }

  int accountId;

  String accountName;

  String currency;

  int currentBalanceCents;

  /// Balance expected on the last day.
  int endBalanceCents;

  int lowestBalanceCents;

  DateTime lowestDate;

  int alertThresholdCents;

  DateTime? firstBelowThresholdDate;

  /// Planned debits and credits over the period (late ones included).
  int plannedDebitsCents;

  int plannedCreditsCents;

  /// Planned operations that are late.
  int missedCount;

  /// Returns a shallow copy of this [AccountForecastSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccountForecastSummary copyWith({
    int? accountId,
    String? accountName,
    String? currency,
    int? currentBalanceCents,
    int? endBalanceCents,
    int? lowestBalanceCents,
    DateTime? lowestDate,
    int? alertThresholdCents,
    DateTime? firstBelowThresholdDate,
    int? plannedDebitsCents,
    int? plannedCreditsCents,
    int? missedCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountForecastSummary',
      'accountId': accountId,
      'accountName': accountName,
      'currency': currency,
      'currentBalanceCents': currentBalanceCents,
      'endBalanceCents': endBalanceCents,
      'lowestBalanceCents': lowestBalanceCents,
      'lowestDate': lowestDate.toJson(),
      'alertThresholdCents': alertThresholdCents,
      if (firstBelowThresholdDate != null)
        'firstBelowThresholdDate': firstBelowThresholdDate?.toJson(),
      'plannedDebitsCents': plannedDebitsCents,
      'plannedCreditsCents': plannedCreditsCents,
      'missedCount': missedCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountForecastSummary',
      'accountId': accountId,
      'accountName': accountName,
      'currency': currency,
      'currentBalanceCents': currentBalanceCents,
      'endBalanceCents': endBalanceCents,
      'lowestBalanceCents': lowestBalanceCents,
      'lowestDate': lowestDate.toJson(),
      'alertThresholdCents': alertThresholdCents,
      if (firstBelowThresholdDate != null)
        'firstBelowThresholdDate': firstBelowThresholdDate?.toJson(),
      'plannedDebitsCents': plannedDebitsCents,
      'plannedCreditsCents': plannedCreditsCents,
      'missedCount': missedCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountForecastSummaryImpl extends AccountForecastSummary {
  _AccountForecastSummaryImpl({
    required int accountId,
    required String accountName,
    required String currency,
    required int currentBalanceCents,
    required int endBalanceCents,
    required int lowestBalanceCents,
    required DateTime lowestDate,
    required int alertThresholdCents,
    DateTime? firstBelowThresholdDate,
    required int plannedDebitsCents,
    required int plannedCreditsCents,
    required int missedCount,
  }) : super._(
         accountId: accountId,
         accountName: accountName,
         currency: currency,
         currentBalanceCents: currentBalanceCents,
         endBalanceCents: endBalanceCents,
         lowestBalanceCents: lowestBalanceCents,
         lowestDate: lowestDate,
         alertThresholdCents: alertThresholdCents,
         firstBelowThresholdDate: firstBelowThresholdDate,
         plannedDebitsCents: plannedDebitsCents,
         plannedCreditsCents: plannedCreditsCents,
         missedCount: missedCount,
       );

  /// Returns a shallow copy of this [AccountForecastSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccountForecastSummary copyWith({
    int? accountId,
    String? accountName,
    String? currency,
    int? currentBalanceCents,
    int? endBalanceCents,
    int? lowestBalanceCents,
    DateTime? lowestDate,
    int? alertThresholdCents,
    Object? firstBelowThresholdDate = _Undefined,
    int? plannedDebitsCents,
    int? plannedCreditsCents,
    int? missedCount,
  }) {
    return AccountForecastSummary(
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      currency: currency ?? this.currency,
      currentBalanceCents: currentBalanceCents ?? this.currentBalanceCents,
      endBalanceCents: endBalanceCents ?? this.endBalanceCents,
      lowestBalanceCents: lowestBalanceCents ?? this.lowestBalanceCents,
      lowestDate: lowestDate ?? this.lowestDate,
      alertThresholdCents: alertThresholdCents ?? this.alertThresholdCents,
      firstBelowThresholdDate: firstBelowThresholdDate is DateTime?
          ? firstBelowThresholdDate
          : this.firstBelowThresholdDate,
      plannedDebitsCents: plannedDebitsCents ?? this.plannedDebitsCents,
      plannedCreditsCents: plannedCreditsCents ?? this.plannedCreditsCents,
      missedCount: missedCount ?? this.missedCount,
    );
  }
}
