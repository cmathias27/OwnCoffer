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

/// Shown once when enabling two-factor authentication.
abstract class TotpEnrollment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TotpEnrollment._({
    required this.secret,
    required this.otpauthUri,
  });

  factory TotpEnrollment({
    required String secret,
    required String otpauthUri,
  }) = _TotpEnrollmentImpl;

  factory TotpEnrollment.fromJson(Map<String, dynamic> jsonSerialization) {
    return TotpEnrollment(
      secret: jsonSerialization['secret'] as String,
      otpauthUri: jsonSerialization['otpauthUri'] as String,
    );
  }

  String secret;

  String otpauthUri;

  /// Returns a shallow copy of this [TotpEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TotpEnrollment copyWith({
    String? secret,
    String? otpauthUri,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TotpEnrollment',
      'secret': secret,
      'otpauthUri': otpauthUri,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TotpEnrollment',
      'secret': secret,
      'otpauthUri': otpauthUri,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TotpEnrollmentImpl extends TotpEnrollment {
  _TotpEnrollmentImpl({
    required String secret,
    required String otpauthUri,
  }) : super._(
         secret: secret,
         otpauthUri: otpauthUri,
       );

  /// Returns a shallow copy of this [TotpEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TotpEnrollment copyWith({
    String? secret,
    String? otpauthUri,
  }) {
    return TotpEnrollment(
      secret: secret ?? this.secret,
      otpauthUri: otpauthUri ?? this.otpauthUri,
    );
  }
}
