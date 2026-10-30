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

/// Thrown when the user may not see or change a resource. The same error is
/// used for "does not exist" and "not allowed", so ids cannot be probed.
abstract class AccessDeniedException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  AccessDeniedException._({required this.code});

  factory AccessDeniedException({required String code}) =
      _AccessDeniedExceptionImpl;

  factory AccessDeniedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccessDeniedException(code: jsonSerialization['code'] as String);
  }

  String code;

  /// Returns a shallow copy of this [AccessDeniedException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccessDeniedException copyWith({String? code});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccessDeniedException',
      'code': code,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccessDeniedException',
      'code': code,
    };
  }

  @override
  String toString() {
    return 'AccessDeniedException(code: $code)';
  }
}

class _AccessDeniedExceptionImpl extends AccessDeniedException {
  _AccessDeniedExceptionImpl({required String code}) : super._(code: code);

  /// Returns a shallow copy of this [AccessDeniedException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccessDeniedException copyWith({String? code}) {
    return AccessDeniedException(code: code ?? this.code);
  }
}
