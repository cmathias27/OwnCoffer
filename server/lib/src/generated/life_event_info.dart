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
import 'life_event.dart' as _i2n6mb1r;

abstract class LifeEventInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LifeEventInfo._({
    required this.event,
    required this.totalCents,
    required this.count,
  });

  factory LifeEventInfo({
    required _i2n6mb1r.LifeEvent event,
    required int totalCents,
    required int count,
  }) = _LifeEventInfoImpl;

  factory LifeEventInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return LifeEventInfo(
      event: _itdod8fx.Protocol().deserialize<_i2n6mb1r.LifeEvent>(
        jsonSerialization['event'],
      ),
      totalCents: jsonSerialization['totalCents'] as int,
      count: jsonSerialization['count'] as int,
    );
  }

  _i2n6mb1r.LifeEvent event;

  /// Sum of its operations (visible accounts), negative when spent.
  int totalCents;

  int count;

  /// Returns a shallow copy of this [LifeEventInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LifeEventInfo copyWith({
    _i2n6mb1r.LifeEvent? event,
    int? totalCents,
    int? count,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LifeEventInfo',
      'event': event.toJson(),
      'totalCents': totalCents,
      'count': count,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LifeEventInfo',
      'event': event.toJsonForProtocol(),
      'totalCents': totalCents,
      'count': count,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LifeEventInfoImpl extends LifeEventInfo {
  _LifeEventInfoImpl({
    required _i2n6mb1r.LifeEvent event,
    required int totalCents,
    required int count,
  }) : super._(
         event: event,
         totalCents: totalCents,
         count: count,
       );

  /// Returns a shallow copy of this [LifeEventInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LifeEventInfo copyWith({
    _i2n6mb1r.LifeEvent? event,
    int? totalCents,
    int? count,
  }) {
    return LifeEventInfo(
      event: event ?? this.event.copyWith(),
      totalCents: totalCents ?? this.totalCents,
      count: count ?? this.count,
    );
  }
}
