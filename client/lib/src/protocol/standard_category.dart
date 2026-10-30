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

/// Catalogue of standard categories (docs/data/standard_categories.yaml).
/// `code` is stable (e.g. `food.groceries`) and never reused.
abstract class StandardCategory
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StandardCategory._({
    this.id,
    required this.code,
    this.parentCode,
    required this.kind,
    required this.nameFr,
    required this.nameEn,
    this.icon,
    bool? deprecated,
    required this.catalogVersion,
  }) : deprecated = deprecated ?? false;

  factory StandardCategory({
    int? id,
    required String code,
    String? parentCode,
    required _i7kso3nf.CategoryKind kind,
    required String nameFr,
    required String nameEn,
    String? icon,
    bool? deprecated,
    required int catalogVersion,
  }) = _StandardCategoryImpl;

  factory StandardCategory.fromJson(Map<String, dynamic> jsonSerialization) {
    return StandardCategory(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      parentCode: jsonSerialization['parentCode'] as String?,
      kind: _i7kso3nf.CategoryKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      nameFr: jsonSerialization['nameFr'] as String,
      nameEn: jsonSerialization['nameEn'] as String,
      icon: jsonSerialization['icon'] as String?,
      deprecated: jsonSerialization['deprecated'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['deprecated']),
      catalogVersion: jsonSerialization['catalogVersion'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String? parentCode;

  _i7kso3nf.CategoryKind kind;

  String nameFr;

  String nameEn;

  String? icon;

  bool deprecated;

  int catalogVersion;

  /// Returns a shallow copy of this [StandardCategory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StandardCategory copyWith({
    int? id,
    String? code,
    String? parentCode,
    _i7kso3nf.CategoryKind? kind,
    String? nameFr,
    String? nameEn,
    String? icon,
    bool? deprecated,
    int? catalogVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StandardCategory',
      if (id != null) 'id': id,
      'code': code,
      if (parentCode != null) 'parentCode': parentCode,
      'kind': kind.toJson(),
      'nameFr': nameFr,
      'nameEn': nameEn,
      if (icon != null) 'icon': icon,
      'deprecated': deprecated,
      'catalogVersion': catalogVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StandardCategory',
      if (id != null) 'id': id,
      'code': code,
      if (parentCode != null) 'parentCode': parentCode,
      'kind': kind.toJson(),
      'nameFr': nameFr,
      'nameEn': nameEn,
      if (icon != null) 'icon': icon,
      'deprecated': deprecated,
      'catalogVersion': catalogVersion,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StandardCategoryImpl extends StandardCategory {
  _StandardCategoryImpl({
    int? id,
    required String code,
    String? parentCode,
    required _i7kso3nf.CategoryKind kind,
    required String nameFr,
    required String nameEn,
    String? icon,
    bool? deprecated,
    required int catalogVersion,
  }) : super._(
         id: id,
         code: code,
         parentCode: parentCode,
         kind: kind,
         nameFr: nameFr,
         nameEn: nameEn,
         icon: icon,
         deprecated: deprecated,
         catalogVersion: catalogVersion,
       );

  /// Returns a shallow copy of this [StandardCategory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StandardCategory copyWith({
    Object? id = _Undefined,
    String? code,
    Object? parentCode = _Undefined,
    _i7kso3nf.CategoryKind? kind,
    String? nameFr,
    String? nameEn,
    Object? icon = _Undefined,
    bool? deprecated,
    int? catalogVersion,
  }) {
    return StandardCategory(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      parentCode: parentCode is String? ? parentCode : this.parentCode,
      kind: kind ?? this.kind,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      icon: icon is String? ? icon : this.icon,
      deprecated: deprecated ?? this.deprecated,
      catalogVersion: catalogVersion ?? this.catalogVersion,
    );
  }
}
