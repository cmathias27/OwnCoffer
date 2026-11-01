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

/// A debit that stands out: much more than usual for its label (amount),
/// or the same label and amount a few days apart (duplicate).
abstract class UnusualInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UnusualInfo._({
    required this.kind,
    required this.transaction,
    required this.usualCents,
    required this.basis,
  });

  factory UnusualInfo({
    required String kind,
    required _i0mjlwv3.BankTransaction transaction,
    required int usualCents,
    required int basis,
  }) = _UnusualInfoImpl;

  factory UnusualInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return UnusualInfo(
      kind: jsonSerialization['kind'] as String,
      transaction: _iylp5nsw.Protocol().deserialize<_i0mjlwv3.BankTransaction>(
        jsonSerialization['transaction'],
      ),
      usualCents: jsonSerialization['usualCents'] as int,
      basis: jsonSerialization['basis'] as int,
    );
  }

  String kind;

  _i0mjlwv3.BankTransaction transaction;

  /// Usual amount (median of earlier debits), or the other debit's amount.
  int usualCents;

  /// Earlier debits counted, or the other debit's id.
  int basis;

  /// Returns a shallow copy of this [UnusualInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UnusualInfo copyWith({
    String? kind,
    _i0mjlwv3.BankTransaction? transaction,
    int? usualCents,
    int? basis,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UnusualInfo',
      'kind': kind,
      'transaction': transaction.toJson(),
      'usualCents': usualCents,
      'basis': basis,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UnusualInfo',
      'kind': kind,
      'transaction': transaction.toJsonForProtocol(),
      'usualCents': usualCents,
      'basis': basis,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UnusualInfoImpl extends UnusualInfo {
  _UnusualInfoImpl({
    required String kind,
    required _i0mjlwv3.BankTransaction transaction,
    required int usualCents,
    required int basis,
  }) : super._(
         kind: kind,
         transaction: transaction,
         usualCents: usualCents,
         basis: basis,
       );

  /// Returns a shallow copy of this [UnusualInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UnusualInfo copyWith({
    String? kind,
    _i0mjlwv3.BankTransaction? transaction,
    int? usualCents,
    int? basis,
  }) {
    return UnusualInfo(
      kind: kind ?? this.kind,
      transaction: transaction ?? this.transaction.copyWith(),
      usualCents: usualCents ?? this.usualCents,
      basis: basis ?? this.basis,
    );
  }
}
