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
import 'package:owncoffer_server/src/generated/protocol.dart' as _itdod8fx;
import 'package:serverpod/serverpod.dart' as _is;
import 'finance_group.dart' as _iqh5irlt;
import 'member_role.dart' as _insyygng;

/// A group the current user belongs to, with their role.
abstract class GroupMembership
    implements _is.SerializableModel, _is.ProtocolSerialization {
  GroupMembership._({
    required this.group,
    required this.role,
  });

  factory GroupMembership({
    required _iqh5irlt.FinanceGroup group,
    required _insyygng.MemberRole role,
  }) = _GroupMembershipImpl;

  factory GroupMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return GroupMembership(
      group: _itdod8fx.Protocol().deserialize<_iqh5irlt.FinanceGroup>(
        jsonSerialization['group'],
      ),
      role: _insyygng.MemberRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
    );
  }

  _iqh5irlt.FinanceGroup group;

  _insyygng.MemberRole role;

  /// Returns a shallow copy of this [GroupMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  GroupMembership copyWith({
    _iqh5irlt.FinanceGroup? group,
    _insyygng.MemberRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GroupMembership',
      'group': group.toJson(),
      'role': role.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GroupMembership',
      'group': group.toJsonForProtocol(),
      'role': role.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _GroupMembershipImpl extends GroupMembership {
  _GroupMembershipImpl({
    required _iqh5irlt.FinanceGroup group,
    required _insyygng.MemberRole role,
  }) : super._(
         group: group,
         role: role,
       );

  /// Returns a shallow copy of this [GroupMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  GroupMembership copyWith({
    _iqh5irlt.FinanceGroup? group,
    _insyygng.MemberRole? role,
  }) {
    return GroupMembership(
      group: group ?? this.group.copyWith(),
      role: role ?? this.role,
    );
  }
}
