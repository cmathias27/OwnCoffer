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

/// One part of an operation split between categories (a supermarket
/// receipt: groceries, household, clothes). The parts add up to the
/// operation's amount; budgets count the parts instead of the operation.
abstract class TransactionSplit
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TransactionSplit._({
    this.id,
    required this.transactionId,
    this.categoryId,
    required this.amountCents,
    this.note,
  });

  factory TransactionSplit({
    int? id,
    required int transactionId,
    int? categoryId,
    required int amountCents,
    String? note,
  }) = _TransactionSplitImpl;

  factory TransactionSplit.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransactionSplit(
      id: jsonSerialization['id'] as int?,
      transactionId: jsonSerialization['transactionId'] as int,
      categoryId: jsonSerialization['categoryId'] as int?,
      amountCents: jsonSerialization['amountCents'] as int,
      note: jsonSerialization['note'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int transactionId;

  int? categoryId;

  /// Signed like the operation.
  int amountCents;

  String? note;

  /// Returns a shallow copy of this [TransactionSplit]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TransactionSplit copyWith({
    int? id,
    int? transactionId,
    int? categoryId,
    int? amountCents,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransactionSplit',
      if (id != null) 'id': id,
      'transactionId': transactionId,
      if (categoryId != null) 'categoryId': categoryId,
      'amountCents': amountCents,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransactionSplit',
      if (id != null) 'id': id,
      'transactionId': transactionId,
      if (categoryId != null) 'categoryId': categoryId,
      'amountCents': amountCents,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransactionSplitImpl extends TransactionSplit {
  _TransactionSplitImpl({
    int? id,
    required int transactionId,
    int? categoryId,
    required int amountCents,
    String? note,
  }) : super._(
         id: id,
         transactionId: transactionId,
         categoryId: categoryId,
         amountCents: amountCents,
         note: note,
       );

  /// Returns a shallow copy of this [TransactionSplit]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TransactionSplit copyWith({
    Object? id = _Undefined,
    int? transactionId,
    Object? categoryId = _Undefined,
    int? amountCents,
    Object? note = _Undefined,
  }) {
    return TransactionSplit(
      id: id is int? ? id : this.id,
      transactionId: transactionId ?? this.transactionId,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      note: note is String? ? note : this.note,
    );
  }
}
