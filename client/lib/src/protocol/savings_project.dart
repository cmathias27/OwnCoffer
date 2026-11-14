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

/// A savings project (holiday, car, works…): a target, an optional date and
/// what is already saved, entered by hand (decision 0050).
abstract class SavingsProject
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SavingsProject._({
    this.id,
    required this.groupId,
    required this.name,
    required this.targetCents,
    int? savedCents,
    this.targetDate,
    this.accountId,
    DateTime? createdAt,
    this.archivedAt,
  }) : savedCents = savedCents ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory SavingsProject({
    int? id,
    required int groupId,
    required String name,
    required int targetCents,
    int? savedCents,
    DateTime? targetDate,
    int? accountId,
    DateTime? createdAt,
    DateTime? archivedAt,
  }) = _SavingsProjectImpl;

  factory SavingsProject.fromJson(Map<String, dynamic> jsonSerialization) {
    return SavingsProject(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      name: jsonSerialization['name'] as String,
      targetCents: jsonSerialization['targetCents'] as int,
      savedCents: jsonSerialization['savedCents'] as int?,
      targetDate: jsonSerialization['targetDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['targetDate'],
            ),
      accountId: jsonSerialization['accountId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      archivedAt: jsonSerialization['archivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['archivedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  String name;

  int targetCents;

  int savedCents;

  DateTime? targetDate;

  /// Account the money is kept on, for information.
  int? accountId;

  DateTime createdAt;

  DateTime? archivedAt;

  /// Returns a shallow copy of this [SavingsProject]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SavingsProject copyWith({
    int? id,
    int? groupId,
    String? name,
    int? targetCents,
    int? savedCents,
    DateTime? targetDate,
    int? accountId,
    DateTime? createdAt,
    DateTime? archivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SavingsProject',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'targetCents': targetCents,
      'savedCents': savedCents,
      if (targetDate != null) 'targetDate': targetDate?.toJson(),
      if (accountId != null) 'accountId': accountId,
      'createdAt': createdAt.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SavingsProject',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'targetCents': targetCents,
      'savedCents': savedCents,
      if (targetDate != null) 'targetDate': targetDate?.toJson(),
      if (accountId != null) 'accountId': accountId,
      'createdAt': createdAt.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SavingsProjectImpl extends SavingsProject {
  _SavingsProjectImpl({
    int? id,
    required int groupId,
    required String name,
    required int targetCents,
    int? savedCents,
    DateTime? targetDate,
    int? accountId,
    DateTime? createdAt,
    DateTime? archivedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         name: name,
         targetCents: targetCents,
         savedCents: savedCents,
         targetDate: targetDate,
         accountId: accountId,
         createdAt: createdAt,
         archivedAt: archivedAt,
       );

  /// Returns a shallow copy of this [SavingsProject]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SavingsProject copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? name,
    int? targetCents,
    int? savedCents,
    Object? targetDate = _Undefined,
    Object? accountId = _Undefined,
    DateTime? createdAt,
    Object? archivedAt = _Undefined,
  }) {
    return SavingsProject(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      targetCents: targetCents ?? this.targetCents,
      savedCents: savedCents ?? this.savedCents,
      targetDate: targetDate is DateTime? ? targetDate : this.targetDate,
      accountId: accountId is int? ? accountId : this.accountId,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt is DateTime? ? archivedAt : this.archivedAt,
    );
  }
}
