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
import 'invoice_info.dart' as _im7mm4oj;
import 'loan.dart' as _i7jednjp;

/// Results of the search from the top of every screen (decision 0041):
/// only what the user may see, at most a few of each kind, nothing kept.
abstract class GlobalSearchResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  GlobalSearchResult._({
    required this.operations,
    required this.loans,
    required this.invoices,
  });

  factory GlobalSearchResult({
    required List<_i0mjlwv3.BankTransaction> operations,
    required List<_i7jednjp.Loan> loans,
    required List<_im7mm4oj.InvoiceInfo> invoices,
  }) = _GlobalSearchResultImpl;

  factory GlobalSearchResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return GlobalSearchResult(
      operations: _iylp5nsw.Protocol()
          .deserialize<List<_i0mjlwv3.BankTransaction>>(
            jsonSerialization['operations'],
          ),
      loans: _iylp5nsw.Protocol().deserialize<List<_i7jednjp.Loan>>(
        jsonSerialization['loans'],
      ),
      invoices: _iylp5nsw.Protocol().deserialize<List<_im7mm4oj.InvoiceInfo>>(
        jsonSerialization['invoices'],
      ),
    );
  }

  /// Operations of the visible accounts, newest first.
  List<_i0mjlwv3.BankTransaction> operations;

  /// Visible loans whose lender or label matches.
  List<_i7jednjp.Loan> loans;

  /// Invoices whose name, label, merchant or operation matches.
  List<_im7mm4oj.InvoiceInfo> invoices;

  /// Returns a shallow copy of this [GlobalSearchResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  GlobalSearchResult copyWith({
    List<_i0mjlwv3.BankTransaction>? operations,
    List<_i7jednjp.Loan>? loans,
    List<_im7mm4oj.InvoiceInfo>? invoices,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GlobalSearchResult',
      'operations': operations.toJson(valueToJson: (v) => v.toJson()),
      'loans': loans.toJson(valueToJson: (v) => v.toJson()),
      'invoices': invoices.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GlobalSearchResult',
      'operations': operations.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'loans': loans.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'invoices': invoices.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _GlobalSearchResultImpl extends GlobalSearchResult {
  _GlobalSearchResultImpl({
    required List<_i0mjlwv3.BankTransaction> operations,
    required List<_i7jednjp.Loan> loans,
    required List<_im7mm4oj.InvoiceInfo> invoices,
  }) : super._(
         operations: operations,
         loans: loans,
         invoices: invoices,
       );

  /// Returns a shallow copy of this [GlobalSearchResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  GlobalSearchResult copyWith({
    List<_i0mjlwv3.BankTransaction>? operations,
    List<_i7jednjp.Loan>? loans,
    List<_im7mm4oj.InvoiceInfo>? invoices,
  }) {
    return GlobalSearchResult(
      operations:
          operations ?? this.operations.map((e0) => e0.copyWith()).toList(),
      loans: loans ?? this.loans.map((e0) => e0.copyWith()).toList(),
      invoices: invoices ?? this.invoices.map((e0) => e0.copyWith()).toList(),
    );
  }
}
