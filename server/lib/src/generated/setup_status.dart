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

/// `needsSetup`: no account exists yet; the first launch wizard is shown.
abstract class SetupStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SetupStatus._({
    required this.needsSetup,
    this.demo,
    this.serverVersion,
  });

  factory SetupStatus({
    required bool needsSetup,
    bool? demo,
    String? serverVersion,
  }) = _SetupStatusImpl;

  factory SetupStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return SetupStatus(
      needsSetup: _is.BoolJsonExtension.fromJson(
        jsonSerialization['needsSetup'],
      ),
      demo: jsonSerialization['demo'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['demo']),
      serverVersion: jsonSerialization['serverVersion'] as String?,
    );
  }

  bool needsSetup;

  /// A demonstration instance (OWNCOFFER_DEMO=true): fictitious data only;
  /// the app says so on every page.
  bool? demo;

  /// Version of the server (1.0.2; "dev" for a development build): the
  /// Windows and Android apps compare it with their own.
  String? serverVersion;

  /// Returns a shallow copy of this [SetupStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SetupStatus copyWith({
    bool? needsSetup,
    bool? demo,
    String? serverVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SetupStatus',
      'needsSetup': needsSetup,
      if (demo != null) 'demo': demo,
      if (serverVersion != null) 'serverVersion': serverVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SetupStatus',
      'needsSetup': needsSetup,
      if (demo != null) 'demo': demo,
      if (serverVersion != null) 'serverVersion': serverVersion,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SetupStatusImpl extends SetupStatus {
  _SetupStatusImpl({
    required bool needsSetup,
    bool? demo,
    String? serverVersion,
  }) : super._(
         needsSetup: needsSetup,
         demo: demo,
         serverVersion: serverVersion,
       );

  /// Returns a shallow copy of this [SetupStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SetupStatus copyWith({
    bool? needsSetup,
    Object? demo = _Undefined,
    Object? serverVersion = _Undefined,
  }) {
    return SetupStatus(
      needsSetup: needsSetup ?? this.needsSetup,
      demo: demo is bool? ? demo : this.demo,
      serverVersion: serverVersion is String?
          ? serverVersion
          : this.serverVersion,
    );
  }
}
