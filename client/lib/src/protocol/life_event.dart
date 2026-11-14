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

/// A life event (wedding, move, holiday) gathering its operations, with an
/// optional budget (decision 0050).
abstract class LifeEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LifeEvent._({
    this.id,
    required this.groupId,
    required this.name,
    required this.startDate,
    this.endDate,
    this.budgetCents,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LifeEvent({
    int? id,
    required int groupId,
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    int? budgetCents,
    DateTime? createdAt,
  }) = _LifeEventImpl;

  factory LifeEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return LifeEvent(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      name: jsonSerialization['name'] as String,
      startDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      budgetCents: jsonSerialization['budgetCents'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  String name;

  DateTime startDate;

  DateTime? endDate;

  int? budgetCents;

  DateTime createdAt;

  /// Returns a shallow copy of this [LifeEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LifeEvent copyWith({
    int? id,
    int? groupId,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? budgetCents,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LifeEvent',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (budgetCents != null) 'budgetCents': budgetCents,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LifeEvent',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (budgetCents != null) 'budgetCents': budgetCents,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LifeEventImpl extends LifeEvent {
  _LifeEventImpl({
    int? id,
    required int groupId,
    required String name,
    required DateTime startDate,
    DateTime? endDate,
    int? budgetCents,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         name: name,
         startDate: startDate,
         endDate: endDate,
         budgetCents: budgetCents,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LifeEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LifeEvent copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? name,
    DateTime? startDate,
    Object? endDate = _Undefined,
    Object? budgetCents = _Undefined,
    DateTime? createdAt,
  }) {
    return LifeEvent(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      budgetCents: budgetCents is int? ? budgetCents : this.budgetCents,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
