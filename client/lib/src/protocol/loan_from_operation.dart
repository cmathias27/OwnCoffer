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
import 'loan_info.dart' as _ijbwwnsd;

/// Result of declaring a loan from one of its debits.
abstract class LoanFromOperation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LoanFromOperation._({
    required this.info,
    required this.reclassifiedCount,
    required this.linkedCount,
    this.ruleId,
  });

  factory LoanFromOperation({
    required _ijbwwnsd.LoanInfo info,
    required int reclassifiedCount,
    required int linkedCount,
    int? ruleId,
  }) = _LoanFromOperationImpl;

  factory LoanFromOperation.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanFromOperation(
      info: _iylp5nsw.Protocol().deserialize<_ijbwwnsd.LoanInfo>(
        jsonSerialization['info'],
      ),
      reclassifiedCount: jsonSerialization['reclassifiedCount'] as int,
      linkedCount: jsonSerialization['linkedCount'] as int,
      ruleId: jsonSerialization['ruleId'] as int?,
    );
  }

  _ijbwwnsd.LoanInfo info;

  /// Other operations classified by the loan's rule (manual choices are
  /// never overwritten).
  int reclassifiedCount;

  /// Operations recognised as past instalments of the loan.
  int linkedCount;

  /// Rule created by this action (for undo), if any.
  int? ruleId;

  /// Returns a shallow copy of this [LoanFromOperation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LoanFromOperation copyWith({
    _ijbwwnsd.LoanInfo? info,
    int? reclassifiedCount,
    int? linkedCount,
    int? ruleId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanFromOperation',
      'info': info.toJson(),
      'reclassifiedCount': reclassifiedCount,
      'linkedCount': linkedCount,
      if (ruleId != null) 'ruleId': ruleId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanFromOperation',
      'info': info.toJsonForProtocol(),
      'reclassifiedCount': reclassifiedCount,
      'linkedCount': linkedCount,
      if (ruleId != null) 'ruleId': ruleId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanFromOperationImpl extends LoanFromOperation {
  _LoanFromOperationImpl({
    required _ijbwwnsd.LoanInfo info,
    required int reclassifiedCount,
    required int linkedCount,
    int? ruleId,
  }) : super._(
         info: info,
         reclassifiedCount: reclassifiedCount,
         linkedCount: linkedCount,
         ruleId: ruleId,
       );

  /// Returns a shallow copy of this [LoanFromOperation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LoanFromOperation copyWith({
    _ijbwwnsd.LoanInfo? info,
    int? reclassifiedCount,
    int? linkedCount,
    Object? ruleId = _Undefined,
  }) {
    return LoanFromOperation(
      info: info ?? this.info.copyWith(),
      reclassifiedCount: reclassifiedCount ?? this.reclassifiedCount,
      linkedCount: linkedCount ?? this.linkedCount,
      ruleId: ruleId is int? ? ruleId : this.ruleId,
    );
  }
}
