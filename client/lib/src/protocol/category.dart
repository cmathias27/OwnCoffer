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
import 'category_kind.dart' as _i7kso3nf;

/// A category of a group, optionally linked to a standard category so that
/// community rules keep working after renaming or splitting.
abstract class Category
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Category._({
    this.id,
    required this.groupId,
    this.parentId,
    required this.name,
    required this.kind,
    this.standardCode,
    this.icon,
    this.color,
    DateTime? createdAt,
    this.deletedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Category({
    int? id,
    required int groupId,
    int? parentId,
    required String name,
    required _i7kso3nf.CategoryKind kind,
    String? standardCode,
    String? icon,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) = _CategoryImpl;

  factory Category.fromJson(Map<String, dynamic> jsonSerialization) {
    return Category(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      parentId: jsonSerialization['parentId'] as int?,
      name: jsonSerialization['name'] as String,
      kind: _i7kso3nf.CategoryKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      standardCode: jsonSerialization['standardCode'] as String?,
      icon: jsonSerialization['icon'] as String?,
      color: jsonSerialization['color'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  int? parentId;

  String name;

  _i7kso3nf.CategoryKind kind;

  String? standardCode;

  String? icon;

  String? color;

  DateTime createdAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [Category]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Category copyWith({
    int? id,
    int? groupId,
    int? parentId,
    String? name,
    _i7kso3nf.CategoryKind? kind,
    String? standardCode,
    String? icon,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Category',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (parentId != null) 'parentId': parentId,
      'name': name,
      'kind': kind.toJson(),
      if (standardCode != null) 'standardCode': standardCode,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Category',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (parentId != null) 'parentId': parentId,
      'name': name,
      'kind': kind.toJson(),
      if (standardCode != null) 'standardCode': standardCode,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryImpl extends Category {
  _CategoryImpl({
    int? id,
    required int groupId,
    int? parentId,
    required String name,
    required _i7kso3nf.CategoryKind kind,
    String? standardCode,
    String? icon,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         parentId: parentId,
         name: name,
         kind: kind,
         standardCode: standardCode,
         icon: icon,
         color: color,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Category]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Category copyWith({
    Object? id = _Undefined,
    int? groupId,
    Object? parentId = _Undefined,
    String? name,
    _i7kso3nf.CategoryKind? kind,
    Object? standardCode = _Undefined,
    Object? icon = _Undefined,
    Object? color = _Undefined,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return Category(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      parentId: parentId is int? ? parentId : this.parentId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      standardCode: standardCode is String? ? standardCode : this.standardCode,
      icon: icon is String? ? icon : this.icon,
      color: color is String? ? color : this.color,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
