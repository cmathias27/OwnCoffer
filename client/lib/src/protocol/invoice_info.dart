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
import 'invoice.dart' as _ifja8moh;

/// An invoice with what is needed to show it: its name built from the
/// operation, and the operation itself.
abstract class InvoiceInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  InvoiceInfo._({
    required this.invoice,
    required this.name,
    this.transactionDate,
    this.transactionLabel,
    this.amountCents,
    this.currency,
    this.accountName,
  });

  factory InvoiceInfo({
    required _ifja8moh.Invoice invoice,
    required String name,
    DateTime? transactionDate,
    String? transactionLabel,
    int? amountCents,
    String? currency,
    String? accountName,
  }) = _InvoiceInfoImpl;

  factory InvoiceInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvoiceInfo(
      invoice: _iylp5nsw.Protocol().deserialize<_ifja8moh.Invoice>(
        jsonSerialization['invoice'],
      ),
      name: jsonSerialization['name'] as String,
      transactionDate: jsonSerialization['transactionDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['transactionDate'],
            ),
      transactionLabel: jsonSerialization['transactionLabel'] as String?,
      amountCents: jsonSerialization['amountCents'] as int?,
      currency: jsonSerialization['currency'] as String?,
      accountName: jsonSerialization['accountName'] as String?,
    );
  }

  _ifja8moh.Invoice invoice;

  /// Name to open, save or export it under.
  String name;

  DateTime? transactionDate;

  String? transactionLabel;

  int? amountCents;

  String? currency;

  String? accountName;

  /// Returns a shallow copy of this [InvoiceInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InvoiceInfo copyWith({
    _ifja8moh.Invoice? invoice,
    String? name,
    DateTime? transactionDate,
    String? transactionLabel,
    int? amountCents,
    String? currency,
    String? accountName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvoiceInfo',
      'invoice': invoice.toJson(),
      'name': name,
      if (transactionDate != null) 'transactionDate': transactionDate?.toJson(),
      if (transactionLabel != null) 'transactionLabel': transactionLabel,
      if (amountCents != null) 'amountCents': amountCents,
      if (currency != null) 'currency': currency,
      if (accountName != null) 'accountName': accountName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvoiceInfo',
      'invoice': invoice.toJsonForProtocol(),
      'name': name,
      if (transactionDate != null) 'transactionDate': transactionDate?.toJson(),
      if (transactionLabel != null) 'transactionLabel': transactionLabel,
      if (amountCents != null) 'amountCents': amountCents,
      if (currency != null) 'currency': currency,
      if (accountName != null) 'accountName': accountName,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InvoiceInfoImpl extends InvoiceInfo {
  _InvoiceInfoImpl({
    required _ifja8moh.Invoice invoice,
    required String name,
    DateTime? transactionDate,
    String? transactionLabel,
    int? amountCents,
    String? currency,
    String? accountName,
  }) : super._(
         invoice: invoice,
         name: name,
         transactionDate: transactionDate,
         transactionLabel: transactionLabel,
         amountCents: amountCents,
         currency: currency,
         accountName: accountName,
       );

  /// Returns a shallow copy of this [InvoiceInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InvoiceInfo copyWith({
    _ifja8moh.Invoice? invoice,
    String? name,
    Object? transactionDate = _Undefined,
    Object? transactionLabel = _Undefined,
    Object? amountCents = _Undefined,
    Object? currency = _Undefined,
    Object? accountName = _Undefined,
  }) {
    return InvoiceInfo(
      invoice: invoice ?? this.invoice.copyWith(),
      name: name ?? this.name,
      transactionDate: transactionDate is DateTime?
          ? transactionDate
          : this.transactionDate,
      transactionLabel: transactionLabel is String?
          ? transactionLabel
          : this.transactionLabel,
      amountCents: amountCents is int? ? amountCents : this.amountCents,
      currency: currency is String? ? currency : this.currency,
      accountName: accountName is String? ? accountName : this.accountName,
    );
  }
}
