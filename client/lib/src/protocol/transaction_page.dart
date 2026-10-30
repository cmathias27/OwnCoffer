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

/// One page of operations, newest first.
abstract class TransactionPage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TransactionPage._({
    required this.items,
    required this.total,
  });

  factory TransactionPage({
    required List<_i0mjlwv3.BankTransaction> items,
    required int total,
  }) = _TransactionPageImpl;

  factory TransactionPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransactionPage(
      items: _iylp5nsw.Protocol().deserialize<List<_i0mjlwv3.BankTransaction>>(
        jsonSerialization['items'],
      ),
      total: jsonSerialization['total'] as int,
    );
  }

  List<_i0mjlwv3.BankTransaction> items;

  int total;

  /// Returns a shallow copy of this [TransactionPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TransactionPage copyWith({
    List<_i0mjlwv3.BankTransaction>? items,
    int? total,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransactionPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransactionPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TransactionPageImpl extends TransactionPage {
  _TransactionPageImpl({
    required List<_i0mjlwv3.BankTransaction> items,
    required int total,
  }) : super._(
         items: items,
         total: total,
       );

  /// Returns a shallow copy of this [TransactionPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TransactionPage copyWith({
    List<_i0mjlwv3.BankTransaction>? items,
    int? total,
  }) {
    return TransactionPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
    );
  }
}
