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

enum LoanKind implements _is.SerializableModel {
  mortgage,
  car,
  consumer,
  student,
  personal,
  other,
  installments,
  revolving;

  static LoanKind fromJson(String name) {
    switch (name) {
      case 'mortgage':
        return LoanKind.mortgage;
      case 'car':
        return LoanKind.car;
      case 'consumer':
        return LoanKind.consumer;
      case 'student':
        return LoanKind.student;
      case 'personal':
        return LoanKind.personal;
      case 'other':
        return LoanKind.other;
      case 'installments':
        return LoanKind.installments;
      case 'revolving':
        return LoanKind.revolving;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "LoanKind"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
