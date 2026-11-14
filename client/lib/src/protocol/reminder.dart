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

/// A free reminder of a member ("call the bank", "send the form"), notified
/// on its day (decision 0050).
abstract class Reminder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Reminder._({
    this.id,
    required this.groupId,
    required this.authUserId,
    required this.text,
    required this.dueDate,
    this.doneAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Reminder({
    int? id,
    required int groupId,
    required _isc.UuidValue authUserId,
    required String text,
    required DateTime dueDate,
    DateTime? doneAt,
    DateTime? createdAt,
  }) = _ReminderImpl;

  factory Reminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reminder(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      text: jsonSerialization['text'] as String,
      dueDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['dueDate'],
      ),
      doneAt: jsonSerialization['doneAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['doneAt']),
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

  _isc.UuidValue authUserId;

  String text;

  DateTime dueDate;

  DateTime? doneAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Reminder copyWith({
    int? id,
    int? groupId,
    _isc.UuidValue? authUserId,
    String? text,
    DateTime? dueDate,
    DateTime? doneAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reminder',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'text': text,
      'dueDate': dueDate.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reminder',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'text': text,
      'dueDate': dueDate.toJson(),
      if (doneAt != null) 'doneAt': doneAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderImpl extends Reminder {
  _ReminderImpl({
    int? id,
    required int groupId,
    required _isc.UuidValue authUserId,
    required String text,
    required DateTime dueDate,
    DateTime? doneAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         authUserId: authUserId,
         text: text,
         dueDate: dueDate,
         doneAt: doneAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Reminder copyWith({
    Object? id = _Undefined,
    int? groupId,
    _isc.UuidValue? authUserId,
    String? text,
    DateTime? dueDate,
    Object? doneAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      authUserId: authUserId ?? this.authUserId,
      text: text ?? this.text,
      dueDate: dueDate ?? this.dueDate,
      doneAt: doneAt is DateTime? ? doneAt : this.doneAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
