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

/// A contract renewed every year and the last day to cancel it
/// (core.contractDates).
abstract class ContractInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ContractInfo._({
    required this.scheduledId,
    required this.accountId,
    required this.label,
    required this.amountCents,
    required this.noticeDays,
    required this.renewal,
    required this.deadline,
    required this.daysToDeadline,
  });

  factory ContractInfo({
    required int scheduledId,
    required int accountId,
    required String label,
    required int amountCents,
    required int noticeDays,
    required DateTime renewal,
    required DateTime deadline,
    required int daysToDeadline,
  }) = _ContractInfoImpl;

  factory ContractInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ContractInfo(
      scheduledId: jsonSerialization['scheduledId'] as int,
      accountId: jsonSerialization['accountId'] as int,
      label: jsonSerialization['label'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      noticeDays: jsonSerialization['noticeDays'] as int,
      renewal: _is.DateTimeJsonExtension.fromJson(jsonSerialization['renewal']),
      deadline: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['deadline'],
      ),
      daysToDeadline: jsonSerialization['daysToDeadline'] as int,
    );
  }

  int scheduledId;

  int accountId;

  String label;

  int amountCents;

  int noticeDays;

  DateTime renewal;

  DateTime deadline;

  int daysToDeadline;

  /// Returns a shallow copy of this [ContractInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ContractInfo copyWith({
    int? scheduledId,
    int? accountId,
    String? label,
    int? amountCents,
    int? noticeDays,
    DateTime? renewal,
    DateTime? deadline,
    int? daysToDeadline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ContractInfo',
      'scheduledId': scheduledId,
      'accountId': accountId,
      'label': label,
      'amountCents': amountCents,
      'noticeDays': noticeDays,
      'renewal': renewal.toJson(),
      'deadline': deadline.toJson(),
      'daysToDeadline': daysToDeadline,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ContractInfo',
      'scheduledId': scheduledId,
      'accountId': accountId,
      'label': label,
      'amountCents': amountCents,
      'noticeDays': noticeDays,
      'renewal': renewal.toJson(),
      'deadline': deadline.toJson(),
      'daysToDeadline': daysToDeadline,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ContractInfoImpl extends ContractInfo {
  _ContractInfoImpl({
    required int scheduledId,
    required int accountId,
    required String label,
    required int amountCents,
    required int noticeDays,
    required DateTime renewal,
    required DateTime deadline,
    required int daysToDeadline,
  }) : super._(
         scheduledId: scheduledId,
         accountId: accountId,
         label: label,
         amountCents: amountCents,
         noticeDays: noticeDays,
         renewal: renewal,
         deadline: deadline,
         daysToDeadline: daysToDeadline,
       );

  /// Returns a shallow copy of this [ContractInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ContractInfo copyWith({
    int? scheduledId,
    int? accountId,
    String? label,
    int? amountCents,
    int? noticeDays,
    DateTime? renewal,
    DateTime? deadline,
    int? daysToDeadline,
  }) {
    return ContractInfo(
      scheduledId: scheduledId ?? this.scheduledId,
      accountId: accountId ?? this.accountId,
      label: label ?? this.label,
      amountCents: amountCents ?? this.amountCents,
      noticeDays: noticeDays ?? this.noticeDays,
      renewal: renewal ?? this.renewal,
      deadline: deadline ?? this.deadline,
      daysToDeadline: daysToDeadline ?? this.daysToDeadline,
    );
  }
}
