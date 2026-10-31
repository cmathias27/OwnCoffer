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

/// A subscription debited this month for another amount than planned.
abstract class SubscriptionChange
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SubscriptionChange._({
    required this.scheduledId,
    required this.label,
    required this.plannedCents,
    required this.actualCents,
    required this.transactionId,
  });

  factory SubscriptionChange({
    required int scheduledId,
    required String label,
    required int plannedCents,
    required int actualCents,
    required int transactionId,
  }) = _SubscriptionChangeImpl;

  factory SubscriptionChange.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubscriptionChange(
      scheduledId: jsonSerialization['scheduledId'] as int,
      label: jsonSerialization['label'] as String,
      plannedCents: jsonSerialization['plannedCents'] as int,
      actualCents: jsonSerialization['actualCents'] as int,
      transactionId: jsonSerialization['transactionId'] as int,
    );
  }

  int scheduledId;

  String label;

  int plannedCents;

  int actualCents;

  int transactionId;

  /// Returns a shallow copy of this [SubscriptionChange]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SubscriptionChange copyWith({
    int? scheduledId,
    String? label,
    int? plannedCents,
    int? actualCents,
    int? transactionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubscriptionChange',
      'scheduledId': scheduledId,
      'label': label,
      'plannedCents': plannedCents,
      'actualCents': actualCents,
      'transactionId': transactionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubscriptionChange',
      'scheduledId': scheduledId,
      'label': label,
      'plannedCents': plannedCents,
      'actualCents': actualCents,
      'transactionId': transactionId,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SubscriptionChangeImpl extends SubscriptionChange {
  _SubscriptionChangeImpl({
    required int scheduledId,
    required String label,
    required int plannedCents,
    required int actualCents,
    required int transactionId,
  }) : super._(
         scheduledId: scheduledId,
         label: label,
         plannedCents: plannedCents,
         actualCents: actualCents,
         transactionId: transactionId,
       );

  /// Returns a shallow copy of this [SubscriptionChange]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SubscriptionChange copyWith({
    int? scheduledId,
    String? label,
    int? plannedCents,
    int? actualCents,
    int? transactionId,
  }) {
    return SubscriptionChange(
      scheduledId: scheduledId ?? this.scheduledId,
      label: label ?? this.label,
      plannedCents: plannedCents ?? this.plannedCents,
      actualCents: actualCents ?? this.actualCents,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
