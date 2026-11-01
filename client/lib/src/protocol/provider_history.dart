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

/// The past operations with the same cleaned label as one operation (same
/// provider: every EDF debit), on the accounts the user may see.
abstract class ProviderHistory
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProviderHistory._({
    required this.items,
    required this.count,
    required this.totalCents,
    required this.averageCents,
    this.since,
  });

  factory ProviderHistory({
    required List<_i0mjlwv3.BankTransaction> items,
    required int count,
    required int totalCents,
    required int averageCents,
    DateTime? since,
  }) = _ProviderHistoryImpl;

  factory ProviderHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProviderHistory(
      items: _iylp5nsw.Protocol().deserialize<List<_i0mjlwv3.BankTransaction>>(
        jsonSerialization['items'],
      ),
      count: jsonSerialization['count'] as int,
      totalCents: jsonSerialization['totalCents'] as int,
      averageCents: jsonSerialization['averageCents'] as int,
      since: jsonSerialization['since'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['since']),
    );
  }

  /// The most recent ones, newest first, the operation itself left out.
  List<_i0mjlwv3.BankTransaction> items;

  /// All of them, the operation included.
  int count;

  int totalCents;

  /// Average of one operation.
  int averageCents;

  /// Date of the oldest one.
  DateTime? since;

  /// Returns a shallow copy of this [ProviderHistory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProviderHistory copyWith({
    List<_i0mjlwv3.BankTransaction>? items,
    int? count,
    int? totalCents,
    int? averageCents,
    DateTime? since,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProviderHistory',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'count': count,
      'totalCents': totalCents,
      'averageCents': averageCents,
      if (since != null) 'since': since?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProviderHistory',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'count': count,
      'totalCents': totalCents,
      'averageCents': averageCents,
      if (since != null) 'since': since?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProviderHistoryImpl extends ProviderHistory {
  _ProviderHistoryImpl({
    required List<_i0mjlwv3.BankTransaction> items,
    required int count,
    required int totalCents,
    required int averageCents,
    DateTime? since,
  }) : super._(
         items: items,
         count: count,
         totalCents: totalCents,
         averageCents: averageCents,
         since: since,
       );

  /// Returns a shallow copy of this [ProviderHistory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProviderHistory copyWith({
    List<_i0mjlwv3.BankTransaction>? items,
    int? count,
    int? totalCents,
    int? averageCents,
    Object? since = _Undefined,
  }) {
    return ProviderHistory(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      count: count ?? this.count,
      totalCents: totalCents ?? this.totalCents,
      averageCents: averageCents ?? this.averageCents,
      since: since is DateTime? ? since : this.since,
    );
  }
}
