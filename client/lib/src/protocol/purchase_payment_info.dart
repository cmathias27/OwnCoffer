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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class PurchasePaymentInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PurchasePaymentInfo._({
    required this.date,
    required this.amountCents,
  });

  factory PurchasePaymentInfo({
    required DateTime date,
    required int amountCents,
  }) = _PurchasePaymentInfoImpl;

  factory PurchasePaymentInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return PurchasePaymentInfo(
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amountCents: jsonSerialization['amountCents'] as int,
    );
  }

  DateTime date;

  /// Positive.
  int amountCents;

  /// Returns a shallow copy of this [PurchasePaymentInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PurchasePaymentInfo copyWith({
    DateTime? date,
    int? amountCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PurchasePaymentInfo',
      'date': date.toJson(),
      'amountCents': amountCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PurchasePaymentInfo',
      'date': date.toJson(),
      'amountCents': amountCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PurchasePaymentInfoImpl extends PurchasePaymentInfo {
  _PurchasePaymentInfoImpl({
    required DateTime date,
    required int amountCents,
  }) : super._(
         date: date,
         amountCents: amountCents,
       );

  /// Returns a shallow copy of this [PurchasePaymentInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PurchasePaymentInfo copyWith({
    DateTime? date,
    int? amountCents,
  }) {
    return PurchasePaymentInfo(
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
    );
  }
}
