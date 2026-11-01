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

/// `needsSetup`: no account exists yet; the first launch wizard is shown.
abstract class SetupStatus
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SetupStatus._({
    required this.needsSetup,
    this.demo,
  });

  factory SetupStatus({
    required bool needsSetup,
    bool? demo,
  }) = _SetupStatusImpl;

  factory SetupStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return SetupStatus(
      needsSetup: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['needsSetup'],
      ),
      demo: jsonSerialization['demo'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['demo']),
    );
  }

  bool needsSetup;

  /// A demonstration instance (OWNCOFFER_DEMO=true): fictitious data only;
  /// the app says so on every page.
  bool? demo;

  /// Returns a shallow copy of this [SetupStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SetupStatus copyWith({
    bool? needsSetup,
    bool? demo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SetupStatus',
      'needsSetup': needsSetup,
      if (demo != null) 'demo': demo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SetupStatus',
      'needsSetup': needsSetup,
      if (demo != null) 'demo': demo,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SetupStatusImpl extends SetupStatus {
  _SetupStatusImpl({
    required bool needsSetup,
    bool? demo,
  }) : super._(
         needsSetup: needsSetup,
         demo: demo,
       );

  /// Returns a shallow copy of this [SetupStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SetupStatus copyWith({
    bool? needsSetup,
    Object? demo = _Undefined,
  }) {
    return SetupStatus(
      needsSetup: needsSetup ?? this.needsSetup,
      demo: demo is bool? ? demo : this.demo,
    );
  }
}
