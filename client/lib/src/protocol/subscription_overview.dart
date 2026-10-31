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
import 'scheduled_transaction.dart' as _ifol8nrg;

abstract class SubscriptionOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SubscriptionOverview._({
    required this.items,
    required this.monthlyCents,
    required this.monthlyTotalCents,
    required this.yearlyTotalCents,
  });

  factory SubscriptionOverview({
    required List<_ifol8nrg.ScheduledTransaction> items,
    required List<int> monthlyCents,
    required int monthlyTotalCents,
    required int yearlyTotalCents,
  }) = _SubscriptionOverviewImpl;

  factory SubscriptionOverview.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SubscriptionOverview(
      items: _iylp5nsw.Protocol()
          .deserialize<List<_ifol8nrg.ScheduledTransaction>>(
            jsonSerialization['items'],
          ),
      monthlyCents: _iylp5nsw.Protocol().deserialize<List<int>>(
        jsonSerialization['monthlyCents'],
      ),
      monthlyTotalCents: jsonSerialization['monthlyTotalCents'] as int,
      yearlyTotalCents: jsonSerialization['yearlyTotalCents'] as int,
    );
  }

  List<_ifol8nrg.ScheduledTransaction> items;

  /// Monthly cost of each item, same order.
  List<int> monthlyCents;

  int monthlyTotalCents;

  int yearlyTotalCents;

  /// Returns a shallow copy of this [SubscriptionOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SubscriptionOverview copyWith({
    List<_ifol8nrg.ScheduledTransaction>? items,
    List<int>? monthlyCents,
    int? monthlyTotalCents,
    int? yearlyTotalCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubscriptionOverview',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'monthlyCents': monthlyCents.toJson(),
      'monthlyTotalCents': monthlyTotalCents,
      'yearlyTotalCents': yearlyTotalCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubscriptionOverview',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'monthlyCents': monthlyCents.toJson(),
      'monthlyTotalCents': monthlyTotalCents,
      'yearlyTotalCents': yearlyTotalCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SubscriptionOverviewImpl extends SubscriptionOverview {
  _SubscriptionOverviewImpl({
    required List<_ifol8nrg.ScheduledTransaction> items,
    required List<int> monthlyCents,
    required int monthlyTotalCents,
    required int yearlyTotalCents,
  }) : super._(
         items: items,
         monthlyCents: monthlyCents,
         monthlyTotalCents: monthlyTotalCents,
         yearlyTotalCents: yearlyTotalCents,
       );

  /// Returns a shallow copy of this [SubscriptionOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SubscriptionOverview copyWith({
    List<_ifol8nrg.ScheduledTransaction>? items,
    List<int>? monthlyCents,
    int? monthlyTotalCents,
    int? yearlyTotalCents,
  }) {
    return SubscriptionOverview(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      monthlyCents: monthlyCents ?? this.monthlyCents.map((e0) => e0).toList(),
      monthlyTotalCents: monthlyTotalCents ?? this.monthlyTotalCents,
      yearlyTotalCents: yearlyTotalCents ?? this.yearlyTotalCents,
    );
  }
}
