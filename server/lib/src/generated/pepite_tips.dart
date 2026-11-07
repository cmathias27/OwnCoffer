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

/// The tips seen by the user, and when the last one was (at most one a day).
abstract class PepiteTips
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PepiteTips._({
    required this.seen,
    this.lastSeenAt,
  });

  factory PepiteTips({
    required List<String> seen,
    DateTime? lastSeenAt,
  }) = _PepiteTipsImpl;

  factory PepiteTips.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteTips(
      seen: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['seen'],
      ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
    );
  }

  List<String> seen;

  DateTime? lastSeenAt;

  /// Returns a shallow copy of this [PepiteTips]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteTips copyWith({
    List<String>? seen,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteTips',
      'seen': seen.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PepiteTips',
      'seen': seen.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PepiteTipsImpl extends PepiteTips {
  _PepiteTipsImpl({
    required List<String> seen,
    DateTime? lastSeenAt,
  }) : super._(
         seen: seen,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [PepiteTips]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteTips copyWith({
    List<String>? seen,
    Object? lastSeenAt = _Undefined,
  }) {
    return PepiteTips(
      seen: seen ?? this.seen.map((e0) => e0).toList(),
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
    );
  }
}
