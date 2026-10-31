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
import 'purchase_option.dart' as _i46nnn14;
import 'purchase_payment_info.dart' as _i60c7zzl;

/// One way of paying, computed by the forecast engine.
abstract class PurchaseScenarioInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PurchaseScenarioInfo._({
    required this.option,
    required this.payments,
    required this.balanceOnTargetCents,
    required this.lowestDate,
    required this.lowestBalanceCents,
    this.firstBelowThresholdDate,
    required this.thisMonthCents,
    this.goalOverCents,
  });

  factory PurchaseScenarioInfo({
    required _i46nnn14.PurchaseOption option,
    required List<_i60c7zzl.PurchasePaymentInfo> payments,
    required int balanceOnTargetCents,
    required DateTime lowestDate,
    required int lowestBalanceCents,
    DateTime? firstBelowThresholdDate,
    required int thisMonthCents,
    int? goalOverCents,
  }) = _PurchaseScenarioInfoImpl;

  factory PurchaseScenarioInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PurchaseScenarioInfo(
      option: _i46nnn14.PurchaseOption.fromJson(
        (jsonSerialization['option'] as String),
      ),
      payments: _itdod8fx.Protocol()
          .deserialize<List<_i60c7zzl.PurchasePaymentInfo>>(
            jsonSerialization['payments'],
          ),
      balanceOnTargetCents: jsonSerialization['balanceOnTargetCents'] as int,
      lowestDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lowestDate'],
      ),
      lowestBalanceCents: jsonSerialization['lowestBalanceCents'] as int,
      firstBelowThresholdDate:
          jsonSerialization['firstBelowThresholdDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstBelowThresholdDate'],
            ),
      thisMonthCents: jsonSerialization['thisMonthCents'] as int,
      goalOverCents: jsonSerialization['goalOverCents'] as int?,
    );
  }

  _i46nnn14.PurchaseOption option;

  List<_i60c7zzl.PurchasePaymentInfo> payments;

  /// Balance at the end of the chosen day.
  int balanceOnTargetCents;

  DateTime lowestDate;

  int lowestBalanceCents;

  /// First day below the account's alert threshold, if any.
  DateTime? firstBelowThresholdDate;

  /// Paid this budget month, and how much the category's goal would then be
  /// exceeded by (null: no goal, or not exceeded).
  int thisMonthCents;

  int? goalOverCents;

  /// Returns a shallow copy of this [PurchaseScenarioInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PurchaseScenarioInfo copyWith({
    _i46nnn14.PurchaseOption? option,
    List<_i60c7zzl.PurchasePaymentInfo>? payments,
    int? balanceOnTargetCents,
    DateTime? lowestDate,
    int? lowestBalanceCents,
    DateTime? firstBelowThresholdDate,
    int? thisMonthCents,
    int? goalOverCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PurchaseScenarioInfo',
      'option': option.toJson(),
      'payments': payments.toJson(valueToJson: (v) => v.toJson()),
      'balanceOnTargetCents': balanceOnTargetCents,
      'lowestDate': lowestDate.toJson(),
      'lowestBalanceCents': lowestBalanceCents,
      if (firstBelowThresholdDate != null)
        'firstBelowThresholdDate': firstBelowThresholdDate?.toJson(),
      'thisMonthCents': thisMonthCents,
      if (goalOverCents != null) 'goalOverCents': goalOverCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PurchaseScenarioInfo',
      'option': option.toJson(),
      'payments': payments.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'balanceOnTargetCents': balanceOnTargetCents,
      'lowestDate': lowestDate.toJson(),
      'lowestBalanceCents': lowestBalanceCents,
      if (firstBelowThresholdDate != null)
        'firstBelowThresholdDate': firstBelowThresholdDate?.toJson(),
      'thisMonthCents': thisMonthCents,
      if (goalOverCents != null) 'goalOverCents': goalOverCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PurchaseScenarioInfoImpl extends PurchaseScenarioInfo {
  _PurchaseScenarioInfoImpl({
    required _i46nnn14.PurchaseOption option,
    required List<_i60c7zzl.PurchasePaymentInfo> payments,
    required int balanceOnTargetCents,
    required DateTime lowestDate,
    required int lowestBalanceCents,
    DateTime? firstBelowThresholdDate,
    required int thisMonthCents,
    int? goalOverCents,
  }) : super._(
         option: option,
         payments: payments,
         balanceOnTargetCents: balanceOnTargetCents,
         lowestDate: lowestDate,
         lowestBalanceCents: lowestBalanceCents,
         firstBelowThresholdDate: firstBelowThresholdDate,
         thisMonthCents: thisMonthCents,
         goalOverCents: goalOverCents,
       );

  /// Returns a shallow copy of this [PurchaseScenarioInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PurchaseScenarioInfo copyWith({
    _i46nnn14.PurchaseOption? option,
    List<_i60c7zzl.PurchasePaymentInfo>? payments,
    int? balanceOnTargetCents,
    DateTime? lowestDate,
    int? lowestBalanceCents,
    Object? firstBelowThresholdDate = _Undefined,
    int? thisMonthCents,
    Object? goalOverCents = _Undefined,
  }) {
    return PurchaseScenarioInfo(
      option: option ?? this.option,
      payments: payments ?? this.payments.map((e0) => e0.copyWith()).toList(),
      balanceOnTargetCents: balanceOnTargetCents ?? this.balanceOnTargetCents,
      lowestDate: lowestDate ?? this.lowestDate,
      lowestBalanceCents: lowestBalanceCents ?? this.lowestBalanceCents,
      firstBelowThresholdDate: firstBelowThresholdDate is DateTime?
          ? firstBelowThresholdDate
          : this.firstBelowThresholdDate,
      thisMonthCents: thisMonthCents ?? this.thisMonthCents,
      goalOverCents: goalOverCents is int? ? goalOverCents : this.goalOverCents,
    );
  }
}
