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
import 'category_change_info.dart' as _iknjgrwa;
import 'category_flow.dart' as _i8msyna2;
import 'scheduled_transaction.dart' as _ifol8nrg;
import 'subscription_change.dart' as _ilnyaemj;

/// Month-end review, computed without AI: what changed, what it cost.
abstract class MonthReview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MonthReview._({
    required this.start,
    required this.last,
    required this.incomeCents,
    required this.expenseCents,
    required this.savingsCents,
    required this.netCents,
    required this.previousNetCents,
    required this.rises,
    required this.drops,
    required this.goalsOver,
    required this.bankFeesCents,
    required this.bankFees,
    required this.biggestExpenses,
    required this.subscriptionChanges,
    required this.newSubscriptions,
    required this.unclassifiedCount,
  });

  factory MonthReview({
    required DateTime start,
    required DateTime last,
    required int incomeCents,
    required int expenseCents,
    required int savingsCents,
    required int netCents,
    required int previousNetCents,
    required List<_iknjgrwa.CategoryChangeInfo> rises,
    required List<_iknjgrwa.CategoryChangeInfo> drops,
    required List<_i8msyna2.CategoryFlow> goalsOver,
    required int bankFeesCents,
    required List<_i0mjlwv3.BankTransaction> bankFees,
    required List<_i0mjlwv3.BankTransaction> biggestExpenses,
    required List<_ilnyaemj.SubscriptionChange> subscriptionChanges,
    required List<_ifol8nrg.ScheduledTransaction> newSubscriptions,
    required int unclassifiedCount,
  }) = _MonthReviewImpl;

  factory MonthReview.fromJson(Map<String, dynamic> jsonSerialization) {
    return MonthReview(
      start: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['start']),
      last: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['last']),
      incomeCents: jsonSerialization['incomeCents'] as int,
      expenseCents: jsonSerialization['expenseCents'] as int,
      savingsCents: jsonSerialization['savingsCents'] as int,
      netCents: jsonSerialization['netCents'] as int,
      previousNetCents: jsonSerialization['previousNetCents'] as int,
      rises: _iylp5nsw.Protocol()
          .deserialize<List<_iknjgrwa.CategoryChangeInfo>>(
            jsonSerialization['rises'],
          ),
      drops: _iylp5nsw.Protocol()
          .deserialize<List<_iknjgrwa.CategoryChangeInfo>>(
            jsonSerialization['drops'],
          ),
      goalsOver: _iylp5nsw.Protocol().deserialize<List<_i8msyna2.CategoryFlow>>(
        jsonSerialization['goalsOver'],
      ),
      bankFeesCents: jsonSerialization['bankFeesCents'] as int,
      bankFees: _iylp5nsw.Protocol()
          .deserialize<List<_i0mjlwv3.BankTransaction>>(
            jsonSerialization['bankFees'],
          ),
      biggestExpenses: _iylp5nsw.Protocol()
          .deserialize<List<_i0mjlwv3.BankTransaction>>(
            jsonSerialization['biggestExpenses'],
          ),
      subscriptionChanges: _iylp5nsw.Protocol()
          .deserialize<List<_ilnyaemj.SubscriptionChange>>(
            jsonSerialization['subscriptionChanges'],
          ),
      newSubscriptions: _iylp5nsw.Protocol()
          .deserialize<List<_ifol8nrg.ScheduledTransaction>>(
            jsonSerialization['newSubscriptions'],
          ),
      unclassifiedCount: jsonSerialization['unclassifiedCount'] as int,
    );
  }

  DateTime start;

  DateTime last;

  int incomeCents;

  int expenseCents;

  int savingsCents;

  int netCents;

  int previousNetCents;

  List<_iknjgrwa.CategoryChangeInfo> rises;

  List<_iknjgrwa.CategoryChangeInfo> drops;

  /// Expense goals exceeded (month view).
  List<_i8msyna2.CategoryFlow> goalsOver;

  /// Bank fees and overdraft interest of the month.
  int bankFeesCents;

  List<_i0mjlwv3.BankTransaction> bankFees;

  List<_i0mjlwv3.BankTransaction> biggestExpenses;

  List<_ilnyaemj.SubscriptionChange> subscriptionChanges;

  List<_ifol8nrg.ScheduledTransaction> newSubscriptions;

  int unclassifiedCount;

  /// Returns a shallow copy of this [MonthReview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MonthReview copyWith({
    DateTime? start,
    DateTime? last,
    int? incomeCents,
    int? expenseCents,
    int? savingsCents,
    int? netCents,
    int? previousNetCents,
    List<_iknjgrwa.CategoryChangeInfo>? rises,
    List<_iknjgrwa.CategoryChangeInfo>? drops,
    List<_i8msyna2.CategoryFlow>? goalsOver,
    int? bankFeesCents,
    List<_i0mjlwv3.BankTransaction>? bankFees,
    List<_i0mjlwv3.BankTransaction>? biggestExpenses,
    List<_ilnyaemj.SubscriptionChange>? subscriptionChanges,
    List<_ifol8nrg.ScheduledTransaction>? newSubscriptions,
    int? unclassifiedCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MonthReview',
      'start': start.toJson(),
      'last': last.toJson(),
      'incomeCents': incomeCents,
      'expenseCents': expenseCents,
      'savingsCents': savingsCents,
      'netCents': netCents,
      'previousNetCents': previousNetCents,
      'rises': rises.toJson(valueToJson: (v) => v.toJson()),
      'drops': drops.toJson(valueToJson: (v) => v.toJson()),
      'goalsOver': goalsOver.toJson(valueToJson: (v) => v.toJson()),
      'bankFeesCents': bankFeesCents,
      'bankFees': bankFees.toJson(valueToJson: (v) => v.toJson()),
      'biggestExpenses': biggestExpenses.toJson(valueToJson: (v) => v.toJson()),
      'subscriptionChanges': subscriptionChanges.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'newSubscriptions': newSubscriptions.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'unclassifiedCount': unclassifiedCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MonthReview',
      'start': start.toJson(),
      'last': last.toJson(),
      'incomeCents': incomeCents,
      'expenseCents': expenseCents,
      'savingsCents': savingsCents,
      'netCents': netCents,
      'previousNetCents': previousNetCents,
      'rises': rises.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'drops': drops.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'goalsOver': goalsOver.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'bankFeesCents': bankFeesCents,
      'bankFees': bankFees.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'biggestExpenses': biggestExpenses.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'subscriptionChanges': subscriptionChanges.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'newSubscriptions': newSubscriptions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'unclassifiedCount': unclassifiedCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MonthReviewImpl extends MonthReview {
  _MonthReviewImpl({
    required DateTime start,
    required DateTime last,
    required int incomeCents,
    required int expenseCents,
    required int savingsCents,
    required int netCents,
    required int previousNetCents,
    required List<_iknjgrwa.CategoryChangeInfo> rises,
    required List<_iknjgrwa.CategoryChangeInfo> drops,
    required List<_i8msyna2.CategoryFlow> goalsOver,
    required int bankFeesCents,
    required List<_i0mjlwv3.BankTransaction> bankFees,
    required List<_i0mjlwv3.BankTransaction> biggestExpenses,
    required List<_ilnyaemj.SubscriptionChange> subscriptionChanges,
    required List<_ifol8nrg.ScheduledTransaction> newSubscriptions,
    required int unclassifiedCount,
  }) : super._(
         start: start,
         last: last,
         incomeCents: incomeCents,
         expenseCents: expenseCents,
         savingsCents: savingsCents,
         netCents: netCents,
         previousNetCents: previousNetCents,
         rises: rises,
         drops: drops,
         goalsOver: goalsOver,
         bankFeesCents: bankFeesCents,
         bankFees: bankFees,
         biggestExpenses: biggestExpenses,
         subscriptionChanges: subscriptionChanges,
         newSubscriptions: newSubscriptions,
         unclassifiedCount: unclassifiedCount,
       );

  /// Returns a shallow copy of this [MonthReview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MonthReview copyWith({
    DateTime? start,
    DateTime? last,
    int? incomeCents,
    int? expenseCents,
    int? savingsCents,
    int? netCents,
    int? previousNetCents,
    List<_iknjgrwa.CategoryChangeInfo>? rises,
    List<_iknjgrwa.CategoryChangeInfo>? drops,
    List<_i8msyna2.CategoryFlow>? goalsOver,
    int? bankFeesCents,
    List<_i0mjlwv3.BankTransaction>? bankFees,
    List<_i0mjlwv3.BankTransaction>? biggestExpenses,
    List<_ilnyaemj.SubscriptionChange>? subscriptionChanges,
    List<_ifol8nrg.ScheduledTransaction>? newSubscriptions,
    int? unclassifiedCount,
  }) {
    return MonthReview(
      start: start ?? this.start,
      last: last ?? this.last,
      incomeCents: incomeCents ?? this.incomeCents,
      expenseCents: expenseCents ?? this.expenseCents,
      savingsCents: savingsCents ?? this.savingsCents,
      netCents: netCents ?? this.netCents,
      previousNetCents: previousNetCents ?? this.previousNetCents,
      rises: rises ?? this.rises.map((e0) => e0.copyWith()).toList(),
      drops: drops ?? this.drops.map((e0) => e0.copyWith()).toList(),
      goalsOver:
          goalsOver ?? this.goalsOver.map((e0) => e0.copyWith()).toList(),
      bankFeesCents: bankFeesCents ?? this.bankFeesCents,
      bankFees: bankFees ?? this.bankFees.map((e0) => e0.copyWith()).toList(),
      biggestExpenses:
          biggestExpenses ??
          this.biggestExpenses.map((e0) => e0.copyWith()).toList(),
      subscriptionChanges:
          subscriptionChanges ??
          this.subscriptionChanges.map((e0) => e0.copyWith()).toList(),
      newSubscriptions:
          newSubscriptions ??
          this.newSubscriptions.map((e0) => e0.copyWith()).toList(),
      unclassifiedCount: unclassifiedCount ?? this.unclassifiedCount,
    );
  }
}
