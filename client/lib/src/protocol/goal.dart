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

/// Monthly spending goal of a category (its sub-categories included).
abstract class Goal
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Goal._({
    this.id,
    required this.groupId,
    required this.categoryId,
    required this.amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Goal({
    int? id,
    required int groupId,
    required int categoryId,
    required int amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GoalImpl;

  factory Goal.fromJson(Map<String, dynamic> jsonSerialization) {
    return Goal(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      categoryId: jsonSerialization['categoryId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  int categoryId;

  int amountCents;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Goal]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Goal copyWith({
    int? id,
    int? groupId,
    int? categoryId,
    int? amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Goal',
      if (id != null) 'id': id,
      'groupId': groupId,
      'categoryId': categoryId,
      'amountCents': amountCents,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Goal',
      if (id != null) 'id': id,
      'groupId': groupId,
      'categoryId': categoryId,
      'amountCents': amountCents,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoalImpl extends Goal {
  _GoalImpl({
    int? id,
    required int groupId,
    required int categoryId,
    required int amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         categoryId: categoryId,
         amountCents: amountCents,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Goal]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Goal copyWith({
    Object? id = _Undefined,
    int? groupId,
    int? categoryId,
    int? amountCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      categoryId: categoryId ?? this.categoryId,
      amountCents: amountCents ?? this.amountCents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
