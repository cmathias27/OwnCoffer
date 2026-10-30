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

/// A group (household, association…) owning accounts, categories and rules.
abstract class FinanceGroup
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FinanceGroup._({
    this.id,
    required this.name,
    bool? aiEnabled,
    required this.createdBy,
    DateTime? createdAt,
  }) : aiEnabled = aiEnabled ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory FinanceGroup({
    int? id,
    required String name,
    bool? aiEnabled,
    required _isc.UuidValue createdBy,
    DateTime? createdAt,
  }) = _FinanceGroupImpl;

  factory FinanceGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return FinanceGroup(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      aiEnabled: jsonSerialization['aiEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['aiEnabled']),
      createdBy: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  /// Optional AI (decision 0006): off by default.
  bool aiEnabled;

  _isc.UuidValue createdBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [FinanceGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FinanceGroup copyWith({
    int? id,
    String? name,
    bool? aiEnabled,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FinanceGroup',
      if (id != null) 'id': id,
      'name': name,
      'aiEnabled': aiEnabled,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FinanceGroup',
      if (id != null) 'id': id,
      'name': name,
      'aiEnabled': aiEnabled,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FinanceGroupImpl extends FinanceGroup {
  _FinanceGroupImpl({
    int? id,
    required String name,
    bool? aiEnabled,
    required _isc.UuidValue createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         aiEnabled: aiEnabled,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FinanceGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FinanceGroup copyWith({
    Object? id = _Undefined,
    String? name,
    bool? aiEnabled,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  }) {
    return FinanceGroup(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
