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

/// Thrown when a request is refused because of its content. `code` is
/// translated by the app; `field` names the faulty input, if any.
abstract class InvalidInputException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  InvalidInputException._({
    required this.code,
    this.field,
  });

  factory InvalidInputException({
    required String code,
    String? field,
  }) = _InvalidInputExceptionImpl;

  factory InvalidInputException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return InvalidInputException(
      code: jsonSerialization['code'] as String,
      field: jsonSerialization['field'] as String?,
    );
  }

  String code;

  String? field;

  /// Returns a shallow copy of this [InvalidInputException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InvalidInputException copyWith({
    String? code,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvalidInputException',
      'code': code,
      if (field != null) 'field': field,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvalidInputException',
      'code': code,
      if (field != null) 'field': field,
    };
  }

  @override
  String toString() {
    return 'InvalidInputException(code: $code, field: $field)';
  }
}

class _Undefined {}

class _InvalidInputExceptionImpl extends InvalidInputException {
  _InvalidInputExceptionImpl({
    required String code,
    String? field,
  }) : super._(
         code: code,
         field: field,
       );

  /// Returns a shallow copy of this [InvalidInputException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InvalidInputException copyWith({
    String? code,
    Object? field = _Undefined,
  }) {
    return InvalidInputException(
      code: code ?? this.code,
      field: field is String? ? field : this.field,
    );
  }
}
