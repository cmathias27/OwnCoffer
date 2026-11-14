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

/// Monthly income declared by a member, to split the common pot in
/// proportion (decision 0050).
abstract class PotShare
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PotShare._({
    this.id,
    required this.groupId,
    required this.authUserId,
    required this.incomeCents,
  });

  factory PotShare({
    int? id,
    required int groupId,
    required _isc.UuidValue authUserId,
    required int incomeCents,
  }) = _PotShareImpl;

  factory PotShare.fromJson(Map<String, dynamic> jsonSerialization) {
    return PotShare(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      incomeCents: jsonSerialization['incomeCents'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  _isc.UuidValue authUserId;

  int incomeCents;

  /// Returns a shallow copy of this [PotShare]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PotShare copyWith({
    int? id,
    int? groupId,
    _isc.UuidValue? authUserId,
    int? incomeCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PotShare',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'incomeCents': incomeCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PotShare',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'incomeCents': incomeCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PotShareImpl extends PotShare {
  _PotShareImpl({
    int? id,
    required int groupId,
    required _isc.UuidValue authUserId,
    required int incomeCents,
  }) : super._(
         id: id,
         groupId: groupId,
         authUserId: authUserId,
         incomeCents: incomeCents,
       );

  /// Returns a shallow copy of this [PotShare]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PotShare copyWith({
    Object? id = _Undefined,
    int? groupId,
    _isc.UuidValue? authUserId,
    int? incomeCents,
  }) {
    return PotShare(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      authUserId: authUserId ?? this.authUserId,
      incomeCents: incomeCents ?? this.incomeCents,
    );
  }
}
