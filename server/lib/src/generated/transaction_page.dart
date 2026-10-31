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
import 'bank_transaction.dart' as _i0mjlwv3;
import 'scheduled_transaction.dart' as _ifol8nrg;

/// One page of operations, newest first.
abstract class TransactionPage
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TransactionPage._({
    required this.items,
    required this.total,
    this.amountSumCents,
    required this.subscriptions,
  });

  factory TransactionPage({
    required List<_i0mjlwv3.BankTransaction> items,
    required int total,
    int? amountSumCents,
    required List<_ifol8nrg.ScheduledTransaction> subscriptions,
  }) = _TransactionPageImpl;

  factory TransactionPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransactionPage(
      items: _itdod8fx.Protocol().deserialize<List<_i0mjlwv3.BankTransaction>>(
        jsonSerialization['items'],
      ),
      total: jsonSerialization['total'] as int,
      amountSumCents: jsonSerialization['amountSumCents'] as int?,
      subscriptions: _itdod8fx.Protocol()
          .deserialize<List<_ifol8nrg.ScheduledTransaction>>(
            jsonSerialization['subscriptions'],
          ),
    );
  }

  List<_i0mjlwv3.BankTransaction> items;

  int total;

  /// Sum of the matching operations, given with a provider filter
  /// (`sameLabel`) only.
  int? amountSumCents;

  /// Subscriptions of the account (planned operations marked as such, ended
  /// ones included), to mark the operations they realised.
  List<_ifol8nrg.ScheduledTransaction> subscriptions;

  /// Returns a shallow copy of this [TransactionPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TransactionPage copyWith({
    List<_i0mjlwv3.BankTransaction>? items,
    int? total,
    int? amountSumCents,
    List<_ifol8nrg.ScheduledTransaction>? subscriptions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransactionPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      if (amountSumCents != null) 'amountSumCents': amountSumCents,
      'subscriptions': subscriptions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransactionPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
      if (amountSumCents != null) 'amountSumCents': amountSumCents,
      'subscriptions': subscriptions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransactionPageImpl extends TransactionPage {
  _TransactionPageImpl({
    required List<_i0mjlwv3.BankTransaction> items,
    required int total,
    int? amountSumCents,
    required List<_ifol8nrg.ScheduledTransaction> subscriptions,
  }) : super._(
         items: items,
         total: total,
         amountSumCents: amountSumCents,
         subscriptions: subscriptions,
       );

  /// Returns a shallow copy of this [TransactionPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransactionPage copyWith({
    List<_i0mjlwv3.BankTransaction>? items,
    int? total,
    Object? amountSumCents = _Undefined,
    List<_ifol8nrg.ScheduledTransaction>? subscriptions,
  }) {
    return TransactionPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      amountSumCents: amountSumCents is int?
          ? amountSumCents
          : this.amountSumCents,
      subscriptions:
          subscriptions ??
          this.subscriptions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
