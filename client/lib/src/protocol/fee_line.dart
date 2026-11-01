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

/// Bank fees of one label over the last 12 months.
abstract class FeeLine
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeeLine._({
    required this.label,
    required this.cents,
    required this.count,
  });

  factory FeeLine({
    required String label,
    required int cents,
    required int count,
  }) = _FeeLineImpl;

  factory FeeLine.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeeLine(
      label: jsonSerialization['label'] as String,
      cents: jsonSerialization['cents'] as int,
      count: jsonSerialization['count'] as int,
    );
  }

  String label;

  int cents;

  int count;

  /// Returns a shallow copy of this [FeeLine]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeeLine copyWith({
    String? label,
    int? cents,
    int? count,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeeLine',
      'label': label,
      'cents': cents,
      'count': count,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeeLine',
      'label': label,
      'cents': cents,
      'count': count,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _FeeLineImpl extends FeeLine {
  _FeeLineImpl({
    required String label,
    required int cents,
    required int count,
  }) : super._(
         label: label,
         cents: cents,
         count: count,
       );

  /// Returns a shallow copy of this [FeeLine]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeeLine copyWith({
    String? label,
    int? cents,
    int? count,
  }) {
    return FeeLine(
      label: label ?? this.label,
      cents: cents ?? this.cents,
      count: count ?? this.count,
    );
  }
}
