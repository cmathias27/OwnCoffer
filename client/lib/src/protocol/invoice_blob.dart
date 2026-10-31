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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Content of an invoice, apart so that listing invoices does not read the
/// files.
abstract class InvoiceBlob
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  InvoiceBlob._({
    this.id,
    required this.invoiceId,
    required this.content,
  });

  factory InvoiceBlob({
    int? id,
    required int invoiceId,
    required _idt.ByteData content,
  }) = _InvoiceBlobImpl;

  factory InvoiceBlob.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvoiceBlob(
      id: jsonSerialization['id'] as int?,
      invoiceId: jsonSerialization['invoiceId'] as int,
      content: _isc.ByteDataJsonExtension.fromJson(
        jsonSerialization['content'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int invoiceId;

  _idt.ByteData content;

  /// Returns a shallow copy of this [InvoiceBlob]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InvoiceBlob copyWith({
    int? id,
    int? invoiceId,
    _idt.ByteData? content,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvoiceBlob',
      if (id != null) 'id': id,
      'invoiceId': invoiceId,
      'content': content.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvoiceBlob',
      if (id != null) 'id': id,
      'invoiceId': invoiceId,
      'content': content.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InvoiceBlobImpl extends InvoiceBlob {
  _InvoiceBlobImpl({
    int? id,
    required int invoiceId,
    required _idt.ByteData content,
  }) : super._(
         id: id,
         invoiceId: invoiceId,
         content: content,
       );

  /// Returns a shallow copy of this [InvoiceBlob]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InvoiceBlob copyWith({
    Object? id = _Undefined,
    int? invoiceId,
    _idt.ByteData? content,
  }) {
    return InvoiceBlob(
      id: id is int? ? id : this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      content: content ?? this.content.clone(),
    );
  }
}
