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

/// A real operation that probably realises a planned one (approximate amount
/// or label): the user confirms it.
abstract class ReconciliationProposal
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReconciliationProposal._({
    required this.scheduledId,
    required this.dueDate,
    required this.transactionId,
    required this.label,
    required this.amountCents,
    required this.date,
  });

  factory ReconciliationProposal({
    required int scheduledId,
    required DateTime dueDate,
    required int transactionId,
    required String label,
    required int amountCents,
    required DateTime date,
  }) = _ReconciliationProposalImpl;

  factory ReconciliationProposal.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReconciliationProposal(
      scheduledId: jsonSerialization['scheduledId'] as int,
      dueDate: _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      transactionId: jsonSerialization['transactionId'] as int,
      label: jsonSerialization['label'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
    );
  }

  int scheduledId;

  DateTime dueDate;

  int transactionId;

  String label;

  int amountCents;

  DateTime date;

  /// Returns a shallow copy of this [ReconciliationProposal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReconciliationProposal copyWith({
    int? scheduledId,
    DateTime? dueDate,
    int? transactionId,
    String? label,
    int? amountCents,
    DateTime? date,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReconciliationProposal',
      'scheduledId': scheduledId,
      'dueDate': dueDate.toJson(),
      'transactionId': transactionId,
      'label': label,
      'amountCents': amountCents,
      'date': date.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReconciliationProposal',
      'scheduledId': scheduledId,
      'dueDate': dueDate.toJson(),
      'transactionId': transactionId,
      'label': label,
      'amountCents': amountCents,
      'date': date.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ReconciliationProposalImpl extends ReconciliationProposal {
  _ReconciliationProposalImpl({
    required int scheduledId,
    required DateTime dueDate,
    required int transactionId,
    required String label,
    required int amountCents,
    required DateTime date,
  }) : super._(
         scheduledId: scheduledId,
         dueDate: dueDate,
         transactionId: transactionId,
         label: label,
         amountCents: amountCents,
         date: date,
       );

  /// Returns a shallow copy of this [ReconciliationProposal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReconciliationProposal copyWith({
    int? scheduledId,
    DateTime? dueDate,
    int? transactionId,
    String? label,
    int? amountCents,
    DateTime? date,
  }) {
    return ReconciliationProposal(
      scheduledId: scheduledId ?? this.scheduledId,
      dueDate: dueDate ?? this.dueDate,
      transactionId: transactionId ?? this.transactionId,
      label: label ?? this.label,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
    );
  }
}
