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
import 'package:serverpod/serverpod.dart' as _is;

/// An operation proposed for an invoice waiting to be attached (or an
/// invoice waiting, proposed for an operation): the user chooses.
abstract class InvoiceMatch
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InvoiceMatch._({
    required this.transactionId,
    required this.invoiceId,
    required this.date,
    required this.label,
    required this.amountCents,
    required this.currency,
    required this.accountName,
    required this.score,
  });

  factory InvoiceMatch({
    required int transactionId,
    required int invoiceId,
    required DateTime date,
    required String label,
    required int amountCents,
    required String currency,
    required String accountName,
    required int score,
  }) = _InvoiceMatchImpl;

  factory InvoiceMatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvoiceMatch(
      transactionId: jsonSerialization['transactionId'] as int,
      invoiceId: jsonSerialization['invoiceId'] as int,
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      label: jsonSerialization['label'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      currency: jsonSerialization['currency'] as String,
      accountName: jsonSerialization['accountName'] as String,
      score: jsonSerialization['score'] as int,
    );
  }

  int transactionId;

  int invoiceId;

  DateTime date;

  String label;

  int amountCents;

  String currency;

  String accountName;

  /// 0 to 100: same amount, near date, merchant in the label.
  int score;

  /// Returns a shallow copy of this [InvoiceMatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InvoiceMatch copyWith({
    int? transactionId,
    int? invoiceId,
    DateTime? date,
    String? label,
    int? amountCents,
    String? currency,
    String? accountName,
    int? score,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvoiceMatch',
      'transactionId': transactionId,
      'invoiceId': invoiceId,
      'date': date.toJson(),
      'label': label,
      'amountCents': amountCents,
      'currency': currency,
      'accountName': accountName,
      'score': score,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvoiceMatch',
      'transactionId': transactionId,
      'invoiceId': invoiceId,
      'date': date.toJson(),
      'label': label,
      'amountCents': amountCents,
      'currency': currency,
      'accountName': accountName,
      'score': score,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _InvoiceMatchImpl extends InvoiceMatch {
  _InvoiceMatchImpl({
    required int transactionId,
    required int invoiceId,
    required DateTime date,
    required String label,
    required int amountCents,
    required String currency,
    required String accountName,
    required int score,
  }) : super._(
         transactionId: transactionId,
         invoiceId: invoiceId,
         date: date,
         label: label,
         amountCents: amountCents,
         currency: currency,
         accountName: accountName,
         score: score,
       );

  /// Returns a shallow copy of this [InvoiceMatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InvoiceMatch copyWith({
    int? transactionId,
    int? invoiceId,
    DateTime? date,
    String? label,
    int? amountCents,
    String? currency,
    String? accountName,
    int? score,
  }) {
    return InvoiceMatch(
      transactionId: transactionId ?? this.transactionId,
      invoiceId: invoiceId ?? this.invoiceId,
      date: date ?? this.date,
      label: label ?? this.label,
      amountCents: amountCents ?? this.amountCents,
      currency: currency ?? this.currency,
      accountName: accountName ?? this.accountName,
      score: score ?? this.score,
    );
  }
}
