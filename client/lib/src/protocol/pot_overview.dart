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
import 'package:owncoffer_client/src/protocol/protocol.dart' as _iylp5nsw;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'pot_share_info.dart' as _ierr65lw;

/// The common pot split by income (core.prorata).
abstract class PotOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PotOverview._({
    required this.totalCents,
    required this.shares,
  });

  factory PotOverview({
    required int totalCents,
    required List<_ierr65lw.PotShareInfo> shares,
  }) = _PotOverviewImpl;

  factory PotOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return PotOverview(
      totalCents: jsonSerialization['totalCents'] as int,
      shares: _iylp5nsw.Protocol().deserialize<List<_ierr65lw.PotShareInfo>>(
        jsonSerialization['shares'],
      ),
    );
  }

  int totalCents;

  List<_ierr65lw.PotShareInfo> shares;

  /// Returns a shallow copy of this [PotOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PotOverview copyWith({
    int? totalCents,
    List<_ierr65lw.PotShareInfo>? shares,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PotOverview',
      'totalCents': totalCents,
      'shares': shares.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PotOverview',
      'totalCents': totalCents,
      'shares': shares.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PotOverviewImpl extends PotOverview {
  _PotOverviewImpl({
    required int totalCents,
    required List<_ierr65lw.PotShareInfo> shares,
  }) : super._(
         totalCents: totalCents,
         shares: shares,
       );

  /// Returns a shallow copy of this [PotOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PotOverview copyWith({
    int? totalCents,
    List<_ierr65lw.PotShareInfo>? shares,
  }) {
    return PotOverview(
      totalCents: totalCents ?? this.totalCents,
      shares: shares ?? this.shares.map((e0) => e0.copyWith()).toList(),
    );
  }
}
