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
    int? standardCatalogVersion,
    int? monthStartDay,
    required this.createdBy,
    DateTime? createdAt,
  }) : aiEnabled = aiEnabled ?? false,
       standardCatalogVersion = standardCatalogVersion ?? 1,
       monthStartDay = monthStartDay ?? 1,
       createdAt = createdAt ?? DateTime.now();

  factory FinanceGroup({
    int? id,
    required String name,
    bool? aiEnabled,
    int? standardCatalogVersion,
    int? monthStartDay,
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
      standardCatalogVersion:
          jsonSerialization['standardCatalogVersion'] as int?,
      monthStartDay: jsonSerialization['monthStartDay'] as int?,
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

  /// Version of the standard catalogue its categories were last updated to
  /// (see updateStandardCategories).
  int standardCatalogVersion;

  /// Day the budget month starts (1 to 28, e.g. pay day): budget, goals and
  /// spending ranking use months from this day.
  int monthStartDay;

  _isc.UuidValue createdBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [FinanceGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FinanceGroup copyWith({
    int? id,
    String? name,
    bool? aiEnabled,
    int? standardCatalogVersion,
    int? monthStartDay,
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
      'standardCatalogVersion': standardCatalogVersion,
      'monthStartDay': monthStartDay,
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
      'standardCatalogVersion': standardCatalogVersion,
      'monthStartDay': monthStartDay,
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
    int? standardCatalogVersion,
    int? monthStartDay,
    required _isc.UuidValue createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         aiEnabled: aiEnabled,
         standardCatalogVersion: standardCatalogVersion,
         monthStartDay: monthStartDay,
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
    int? standardCatalogVersion,
    int? monthStartDay,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  }) {
    return FinanceGroup(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      standardCatalogVersion:
          standardCatalogVersion ?? this.standardCatalogVersion,
      monthStartDay: monthStartDay ?? this.monthStartDay,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
