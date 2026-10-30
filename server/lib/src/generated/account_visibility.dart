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

/// `shared`: every member of the group; `restricted`: only users listed in
/// AccountAccess (and group admins).
enum AccountVisibility implements _is.SerializableModel {
  shared,
  restricted;

  static AccountVisibility fromJson(String name) {
    switch (name) {
      case 'shared':
        return AccountVisibility.shared;
      case 'restricted':
        return AccountVisibility.restricted;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AccountVisibility"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
