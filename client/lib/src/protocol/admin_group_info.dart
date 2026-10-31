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

/// A group of the server, for the server administrator (name and size
/// only).
abstract class AdminGroupInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminGroupInfo._({
    required this.id,
    required this.name,
    required this.members,
    required this.accounts,
  });

  factory AdminGroupInfo({
    required int id,
    required String name,
    required int members,
    required int accounts,
  }) = _AdminGroupInfoImpl;

  factory AdminGroupInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminGroupInfo(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      members: jsonSerialization['members'] as int,
      accounts: jsonSerialization['accounts'] as int,
    );
  }

  int id;

  String name;

  int members;

  int accounts;

  /// Returns a shallow copy of this [AdminGroupInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminGroupInfo copyWith({
    int? id,
    String? name,
    int? members,
    int? accounts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminGroupInfo',
      'id': id,
      'name': name,
      'members': members,
      'accounts': accounts,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminGroupInfo',
      'id': id,
      'name': name,
      'members': members,
      'accounts': accounts,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminGroupInfoImpl extends AdminGroupInfo {
  _AdminGroupInfoImpl({
    required int id,
    required String name,
    required int members,
    required int accounts,
  }) : super._(
         id: id,
         name: name,
         members: members,
         accounts: accounts,
       );

  /// Returns a shallow copy of this [AdminGroupInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminGroupInfo copyWith({
    int? id,
    String? name,
    int? members,
    int? accounts,
  }) {
    return AdminGroupInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      accounts: accounts ?? this.accounts,
    );
  }
}
