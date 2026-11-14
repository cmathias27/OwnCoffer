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
import 'asset_kind.dart' as _ibuqfn3k;

/// Something owned outside the accounts (home, car, investments), valued
/// by hand, for the net worth (decision 0050).
abstract class Asset
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Asset._({
    this.id,
    required this.groupId,
    required this.name,
    required this.kind,
    required this.valueCents,
    required this.valuedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Asset({
    int? id,
    required int groupId,
    required String name,
    required _ibuqfn3k.AssetKind kind,
    required int valueCents,
    required DateTime valuedAt,
    DateTime? createdAt,
  }) = _AssetImpl;

  factory Asset.fromJson(Map<String, dynamic> jsonSerialization) {
    return Asset(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      name: jsonSerialization['name'] as String,
      kind: _ibuqfn3k.AssetKind.fromJson((jsonSerialization['kind'] as String)),
      valueCents: jsonSerialization['valueCents'] as int,
      valuedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['valuedAt'],
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

  int groupId;

  String name;

  _ibuqfn3k.AssetKind kind;

  int valueCents;

  DateTime valuedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [Asset]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Asset copyWith({
    int? id,
    int? groupId,
    String? name,
    _ibuqfn3k.AssetKind? kind,
    int? valueCents,
    DateTime? valuedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Asset',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'kind': kind.toJson(),
      'valueCents': valueCents,
      'valuedAt': valuedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Asset',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'kind': kind.toJson(),
      'valueCents': valueCents,
      'valuedAt': valuedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssetImpl extends Asset {
  _AssetImpl({
    int? id,
    required int groupId,
    required String name,
    required _ibuqfn3k.AssetKind kind,
    required int valueCents,
    required DateTime valuedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         name: name,
         kind: kind,
         valueCents: valueCents,
         valuedAt: valuedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Asset]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Asset copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? name,
    _ibuqfn3k.AssetKind? kind,
    int? valueCents,
    DateTime? valuedAt,
    DateTime? createdAt,
  }) {
    return Asset(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      valueCents: valueCents ?? this.valueCents,
      valuedAt: valuedAt ?? this.valuedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
