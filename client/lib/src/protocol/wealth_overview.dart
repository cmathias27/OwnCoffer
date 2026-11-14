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
import 'asset.dart' as _if0dnshd;
import 'wealth_account.dart' as _ihwcdzv0;

/// Net worth: visible accounts and assets, less what is left to repay on
/// the visible loans (decision 0050).
abstract class WealthOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WealthOverview._({
    required this.accounts,
    required this.assets,
    required this.accountsCents,
    required this.assetsCents,
    required this.loansCents,
    required this.netWorthCents,
  });

  factory WealthOverview({
    required List<_ihwcdzv0.WealthAccount> accounts,
    required List<_if0dnshd.Asset> assets,
    required int accountsCents,
    required int assetsCents,
    required int loansCents,
    required int netWorthCents,
  }) = _WealthOverviewImpl;

  factory WealthOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return WealthOverview(
      accounts: _iylp5nsw.Protocol().deserialize<List<_ihwcdzv0.WealthAccount>>(
        jsonSerialization['accounts'],
      ),
      assets: _iylp5nsw.Protocol().deserialize<List<_if0dnshd.Asset>>(
        jsonSerialization['assets'],
      ),
      accountsCents: jsonSerialization['accountsCents'] as int,
      assetsCents: jsonSerialization['assetsCents'] as int,
      loansCents: jsonSerialization['loansCents'] as int,
      netWorthCents: jsonSerialization['netWorthCents'] as int,
    );
  }

  List<_ihwcdzv0.WealthAccount> accounts;

  List<_if0dnshd.Asset> assets;

  int accountsCents;

  int assetsCents;

  int loansCents;

  int netWorthCents;

  /// Returns a shallow copy of this [WealthOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WealthOverview copyWith({
    List<_ihwcdzv0.WealthAccount>? accounts,
    List<_if0dnshd.Asset>? assets,
    int? accountsCents,
    int? assetsCents,
    int? loansCents,
    int? netWorthCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WealthOverview',
      'accounts': accounts.toJson(valueToJson: (v) => v.toJson()),
      'assets': assets.toJson(valueToJson: (v) => v.toJson()),
      'accountsCents': accountsCents,
      'assetsCents': assetsCents,
      'loansCents': loansCents,
      'netWorthCents': netWorthCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WealthOverview',
      'accounts': accounts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'assets': assets.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'accountsCents': accountsCents,
      'assetsCents': assetsCents,
      'loansCents': loansCents,
      'netWorthCents': netWorthCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _WealthOverviewImpl extends WealthOverview {
  _WealthOverviewImpl({
    required List<_ihwcdzv0.WealthAccount> accounts,
    required List<_if0dnshd.Asset> assets,
    required int accountsCents,
    required int assetsCents,
    required int loansCents,
    required int netWorthCents,
  }) : super._(
         accounts: accounts,
         assets: assets,
         accountsCents: accountsCents,
         assetsCents: assetsCents,
         loansCents: loansCents,
         netWorthCents: netWorthCents,
       );

  /// Returns a shallow copy of this [WealthOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WealthOverview copyWith({
    List<_ihwcdzv0.WealthAccount>? accounts,
    List<_if0dnshd.Asset>? assets,
    int? accountsCents,
    int? assetsCents,
    int? loansCents,
    int? netWorthCents,
  }) {
    return WealthOverview(
      accounts: accounts ?? this.accounts.map((e0) => e0.copyWith()).toList(),
      assets: assets ?? this.assets.map((e0) => e0.copyWith()).toList(),
      accountsCents: accountsCents ?? this.accountsCents,
      assetsCents: assetsCents ?? this.assetsCents,
      loansCents: loansCents ?? this.loansCents,
      netWorthCents: netWorthCents ?? this.netWorthCents,
    );
  }
}
