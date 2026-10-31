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
import 'package:serverpod/serverpod.dart' as _is;

/// Figures of the whole server, never amounts (server administrator only).
abstract class AdminStats
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminStats._({
    required this.users,
    required this.blockedUsers,
    required this.twoFactorUsers,
    required this.groups,
    required this.accounts,
    required this.operations,
    required this.operationsLast30Days,
    required this.importsLast30Days,
    required this.rules,
    required this.pendingInvitations,
    required this.classifiedAutomatically,
    required this.classifiedManually,
    required this.unclassified,
  });

  factory AdminStats({
    required int users,
    required int blockedUsers,
    required int twoFactorUsers,
    required int groups,
    required int accounts,
    required int operations,
    required int operationsLast30Days,
    required int importsLast30Days,
    required int rules,
    required int pendingInvitations,
    required int classifiedAutomatically,
    required int classifiedManually,
    required int unclassified,
  }) = _AdminStatsImpl;

  factory AdminStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminStats(
      users: jsonSerialization['users'] as int,
      blockedUsers: jsonSerialization['blockedUsers'] as int,
      twoFactorUsers: jsonSerialization['twoFactorUsers'] as int,
      groups: jsonSerialization['groups'] as int,
      accounts: jsonSerialization['accounts'] as int,
      operations: jsonSerialization['operations'] as int,
      operationsLast30Days: jsonSerialization['operationsLast30Days'] as int,
      importsLast30Days: jsonSerialization['importsLast30Days'] as int,
      rules: jsonSerialization['rules'] as int,
      pendingInvitations: jsonSerialization['pendingInvitations'] as int,
      classifiedAutomatically:
          jsonSerialization['classifiedAutomatically'] as int,
      classifiedManually: jsonSerialization['classifiedManually'] as int,
      unclassified: jsonSerialization['unclassified'] as int,
    );
  }

  int users;

  int blockedUsers;

  int twoFactorUsers;

  int groups;

  int accounts;

  int operations;

  int operationsLast30Days;

  int importsLast30Days;

  int rules;

  int pendingInvitations;

  /// Imported operations of the last 90 days by how they were classified
  /// (decision 0014: target 70 % automatic).
  int classifiedAutomatically;

  int classifiedManually;

  int unclassified;

  /// Returns a shallow copy of this [AdminStats]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminStats copyWith({
    int? users,
    int? blockedUsers,
    int? twoFactorUsers,
    int? groups,
    int? accounts,
    int? operations,
    int? operationsLast30Days,
    int? importsLast30Days,
    int? rules,
    int? pendingInvitations,
    int? classifiedAutomatically,
    int? classifiedManually,
    int? unclassified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminStats',
      'users': users,
      'blockedUsers': blockedUsers,
      'twoFactorUsers': twoFactorUsers,
      'groups': groups,
      'accounts': accounts,
      'operations': operations,
      'operationsLast30Days': operationsLast30Days,
      'importsLast30Days': importsLast30Days,
      'rules': rules,
      'pendingInvitations': pendingInvitations,
      'classifiedAutomatically': classifiedAutomatically,
      'classifiedManually': classifiedManually,
      'unclassified': unclassified,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminStats',
      'users': users,
      'blockedUsers': blockedUsers,
      'twoFactorUsers': twoFactorUsers,
      'groups': groups,
      'accounts': accounts,
      'operations': operations,
      'operationsLast30Days': operationsLast30Days,
      'importsLast30Days': importsLast30Days,
      'rules': rules,
      'pendingInvitations': pendingInvitations,
      'classifiedAutomatically': classifiedAutomatically,
      'classifiedManually': classifiedManually,
      'unclassified': unclassified,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdminStatsImpl extends AdminStats {
  _AdminStatsImpl({
    required int users,
    required int blockedUsers,
    required int twoFactorUsers,
    required int groups,
    required int accounts,
    required int operations,
    required int operationsLast30Days,
    required int importsLast30Days,
    required int rules,
    required int pendingInvitations,
    required int classifiedAutomatically,
    required int classifiedManually,
    required int unclassified,
  }) : super._(
         users: users,
         blockedUsers: blockedUsers,
         twoFactorUsers: twoFactorUsers,
         groups: groups,
         accounts: accounts,
         operations: operations,
         operationsLast30Days: operationsLast30Days,
         importsLast30Days: importsLast30Days,
         rules: rules,
         pendingInvitations: pendingInvitations,
         classifiedAutomatically: classifiedAutomatically,
         classifiedManually: classifiedManually,
         unclassified: unclassified,
       );

  /// Returns a shallow copy of this [AdminStats]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminStats copyWith({
    int? users,
    int? blockedUsers,
    int? twoFactorUsers,
    int? groups,
    int? accounts,
    int? operations,
    int? operationsLast30Days,
    int? importsLast30Days,
    int? rules,
    int? pendingInvitations,
    int? classifiedAutomatically,
    int? classifiedManually,
    int? unclassified,
  }) {
    return AdminStats(
      users: users ?? this.users,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      twoFactorUsers: twoFactorUsers ?? this.twoFactorUsers,
      groups: groups ?? this.groups,
      accounts: accounts ?? this.accounts,
      operations: operations ?? this.operations,
      operationsLast30Days: operationsLast30Days ?? this.operationsLast30Days,
      importsLast30Days: importsLast30Days ?? this.importsLast30Days,
      rules: rules ?? this.rules,
      pendingInvitations: pendingInvitations ?? this.pendingInvitations,
      classifiedAutomatically:
          classifiedAutomatically ?? this.classifiedAutomatically,
      classifiedManually: classifiedManually ?? this.classifiedManually,
      unclassified: unclassified ?? this.unclassified,
    );
  }
}
