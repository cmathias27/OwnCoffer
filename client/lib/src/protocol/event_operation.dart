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

/// An operation counted in a life event.
abstract class EventOperation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EventOperation._({
    this.id,
    required this.eventId,
    required this.transactionId,
  });

  factory EventOperation({
    int? id,
    required int eventId,
    required int transactionId,
  }) = _EventOperationImpl;

  factory EventOperation.fromJson(Map<String, dynamic> jsonSerialization) {
    return EventOperation(
      id: jsonSerialization['id'] as int?,
      eventId: jsonSerialization['eventId'] as int,
      transactionId: jsonSerialization['transactionId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int eventId;

  int transactionId;

  /// Returns a shallow copy of this [EventOperation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EventOperation copyWith({
    int? id,
    int? eventId,
    int? transactionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EventOperation',
      if (id != null) 'id': id,
      'eventId': eventId,
      'transactionId': transactionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EventOperation',
      if (id != null) 'id': id,
      'eventId': eventId,
      'transactionId': transactionId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventOperationImpl extends EventOperation {
  _EventOperationImpl({
    int? id,
    required int eventId,
    required int transactionId,
  }) : super._(
         id: id,
         eventId: eventId,
         transactionId: transactionId,
       );

  /// Returns a shallow copy of this [EventOperation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EventOperation copyWith({
    Object? id = _Undefined,
    int? eventId,
    int? transactionId,
  }) {
    return EventOperation(
      id: id is int? ? id : this.id,
      eventId: eventId ?? this.eventId,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
