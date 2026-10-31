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

/// What is left to spend until the next pay day (end of the budget month),
/// once the planned operations are counted. Checking accounts only, unless
/// one account is asked for.
abstract class LeftToLiveReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LeftToLiveReport._({
    required this.today,
    required this.last,
    required this.balanceCents,
    required this.plannedDebitsCents,
    required this.plannedCreditsCents,
    required this.leftCents,
    required this.daysLeft,
    required this.perDayCents,
    required this.accountIds,
  });

  factory LeftToLiveReport({
    required DateTime today,
    required DateTime last,
    required int balanceCents,
    required int plannedDebitsCents,
    required int plannedCreditsCents,
    required int leftCents,
    required int daysLeft,
    required int perDayCents,
    required List<int> accountIds,
  }) = _LeftToLiveReportImpl;

  factory LeftToLiveReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return LeftToLiveReport(
      today: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['today']),
      last: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['last']),
      balanceCents: jsonSerialization['balanceCents'] as int,
      plannedDebitsCents: jsonSerialization['plannedDebitsCents'] as int,
      plannedCreditsCents: jsonSerialization['plannedCreditsCents'] as int,
      leftCents: jsonSerialization['leftCents'] as int,
      daysLeft: jsonSerialization['daysLeft'] as int,
      perDayCents: jsonSerialization['perDayCents'] as int,
      accountIds: _iylp5nsw.Protocol().deserialize<List<int>>(
        jsonSerialization['accountIds'],
      ),
    );
  }

  DateTime today;

  DateTime last;

  int balanceCents;

  int plannedDebitsCents;

  int plannedCreditsCents;

  int leftCents;

  int daysLeft;

  int perDayCents;

  /// Accounts counted.
  List<int> accountIds;

  /// Returns a shallow copy of this [LeftToLiveReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LeftToLiveReport copyWith({
    DateTime? today,
    DateTime? last,
    int? balanceCents,
    int? plannedDebitsCents,
    int? plannedCreditsCents,
    int? leftCents,
    int? daysLeft,
    int? perDayCents,
    List<int>? accountIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LeftToLiveReport',
      'today': today.toJson(),
      'last': last.toJson(),
      'balanceCents': balanceCents,
      'plannedDebitsCents': plannedDebitsCents,
      'plannedCreditsCents': plannedCreditsCents,
      'leftCents': leftCents,
      'daysLeft': daysLeft,
      'perDayCents': perDayCents,
      'accountIds': accountIds.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LeftToLiveReport',
      'today': today.toJson(),
      'last': last.toJson(),
      'balanceCents': balanceCents,
      'plannedDebitsCents': plannedDebitsCents,
      'plannedCreditsCents': plannedCreditsCents,
      'leftCents': leftCents,
      'daysLeft': daysLeft,
      'perDayCents': perDayCents,
      'accountIds': accountIds.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _LeftToLiveReportImpl extends LeftToLiveReport {
  _LeftToLiveReportImpl({
    required DateTime today,
    required DateTime last,
    required int balanceCents,
    required int plannedDebitsCents,
    required int plannedCreditsCents,
    required int leftCents,
    required int daysLeft,
    required int perDayCents,
    required List<int> accountIds,
  }) : super._(
         today: today,
         last: last,
         balanceCents: balanceCents,
         plannedDebitsCents: plannedDebitsCents,
         plannedCreditsCents: plannedCreditsCents,
         leftCents: leftCents,
         daysLeft: daysLeft,
         perDayCents: perDayCents,
         accountIds: accountIds,
       );

  /// Returns a shallow copy of this [LeftToLiveReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LeftToLiveReport copyWith({
    DateTime? today,
    DateTime? last,
    int? balanceCents,
    int? plannedDebitsCents,
    int? plannedCreditsCents,
    int? leftCents,
    int? daysLeft,
    int? perDayCents,
    List<int>? accountIds,
  }) {
    return LeftToLiveReport(
      today: today ?? this.today,
      last: last ?? this.last,
      balanceCents: balanceCents ?? this.balanceCents,
      plannedDebitsCents: plannedDebitsCents ?? this.plannedDebitsCents,
      plannedCreditsCents: plannedCreditsCents ?? this.plannedCreditsCents,
      leftCents: leftCents ?? this.leftCents,
      daysLeft: daysLeft ?? this.daysLeft,
      perDayCents: perDayCents ?? this.perDayCents,
      accountIds: accountIds ?? this.accountIds.map((e0) => e0).toList(),
    );
  }
}
