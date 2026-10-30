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

/// Users allowed to see a `restricted` account.
abstract class AccountAccess
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AccountAccess._({
    this.id,
    required this.accountId,
    required this.authUserId,
  });

  factory AccountAccess({
    int? id,
    required int accountId,
    required _isc.UuidValue authUserId,
  }) = _AccountAccessImpl;

  factory AccountAccess.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountAccess(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int accountId;

  _isc.UuidValue authUserId;

  /// Returns a shallow copy of this [AccountAccess]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccountAccess copyWith({
    int? id,
    int? accountId,
    _isc.UuidValue? authUserId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountAccess',
      if (id != null) 'id': id,
      'accountId': accountId,
      'authUserId': authUserId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountAccess',
      if (id != null) 'id': id,
      'accountId': accountId,
      'authUserId': authUserId.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountAccessImpl extends AccountAccess {
  _AccountAccessImpl({
    int? id,
    required int accountId,
    required _isc.UuidValue authUserId,
  }) : super._(
         id: id,
         accountId: accountId,
         authUserId: authUserId,
       );

  /// Returns a shallow copy of this [AccountAccess]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccountAccess copyWith({
    Object? id = _Undefined,
    int? accountId,
    _isc.UuidValue? authUserId,
  }) {
    return AccountAccess(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      authUserId: authUserId ?? this.authUserId,
    );
  }
}
