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
  SetupStatus._({required this.needsSetup});

  factory SetupStatus({required bool needsSetup}) = _SetupStatusImpl;

  factory SetupStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return SetupStatus(
      needsSetup: _is.BoolJsonExtension.fromJson(
        jsonSerialization['needsSetup'],
      ),
    );
  }

  bool needsSetup;

  /// Returns a shallow copy of this [SetupStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SetupStatus copyWith({bool? needsSetup});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SetupStatus',
      'needsSetup': needsSetup,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SetupStatus',
      'needsSetup': needsSetup,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SetupStatusImpl extends SetupStatus {
  _SetupStatusImpl({required bool needsSetup})
    : super._(needsSetup: needsSetup);

  /// Returns a shallow copy of this [SetupStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SetupStatus copyWith({bool? needsSetup}) {
    return SetupStatus(needsSetup: needsSetup ?? this.needsSetup);
  }
}
