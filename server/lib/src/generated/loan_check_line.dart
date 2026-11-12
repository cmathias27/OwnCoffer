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
import 'bank_transaction.dart' as _i0mjlwv3;
import 'loan_check_status.dart' as _ig5ywldk;

/// An instalment that needs a look, or a debit far from every instalment
/// (decision 0040).
abstract class LoanCheckLine
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LoanCheckLine._({
    required this.status,
    this.number,
    this.dueDate,
    this.expectedCents,
    required this.gapCents,
    required this.debits,
  });

  factory LoanCheckLine({
    required _ig5ywldk.LoanCheckStatus status,
    int? number,
    DateTime? dueDate,
    int? expectedCents,
    required int gapCents,
    required List<_i0mjlwv3.BankTransaction> debits,
  }) = _LoanCheckLineImpl;

  factory LoanCheckLine.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanCheckLine(
      status: _ig5ywldk.LoanCheckStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      number: jsonSerialization['number'] as int?,
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      expectedCents: jsonSerialization['expectedCents'] as int?,
      gapCents: jsonSerialization['gapCents'] as int,
      debits: _itdod8fx.Protocol().deserialize<List<_i0mjlwv3.BankTransaction>>(
        jsonSerialization['debits'],
      ),
    );
  }

  _ig5ywldk.LoanCheckStatus status;

  /// Null for an unexpected debit.
  int? number;

  DateTime? dueDate;

  /// Instalment with insurance, as planned.
  int? expectedCents;

  /// Debited minus expected, for a different amount.
  int gapCents;

  /// The debits found for it, oldest first.
  List<_i0mjlwv3.BankTransaction> debits;

  /// Returns a shallow copy of this [LoanCheckLine]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LoanCheckLine copyWith({
    _ig5ywldk.LoanCheckStatus? status,
    int? number,
    DateTime? dueDate,
    int? expectedCents,
    int? gapCents,
    List<_i0mjlwv3.BankTransaction>? debits,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanCheckLine',
      'status': status.toJson(),
      if (number != null) 'number': number,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      if (expectedCents != null) 'expectedCents': expectedCents,
      'gapCents': gapCents,
      'debits': debits.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanCheckLine',
      'status': status.toJson(),
      if (number != null) 'number': number,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      if (expectedCents != null) 'expectedCents': expectedCents,
      'gapCents': gapCents,
      'debits': debits.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanCheckLineImpl extends LoanCheckLine {
  _LoanCheckLineImpl({
    required _ig5ywldk.LoanCheckStatus status,
    int? number,
    DateTime? dueDate,
    int? expectedCents,
    required int gapCents,
    required List<_i0mjlwv3.BankTransaction> debits,
  }) : super._(
         status: status,
         number: number,
         dueDate: dueDate,
         expectedCents: expectedCents,
         gapCents: gapCents,
         debits: debits,
       );

  /// Returns a shallow copy of this [LoanCheckLine]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LoanCheckLine copyWith({
    _ig5ywldk.LoanCheckStatus? status,
    Object? number = _Undefined,
    Object? dueDate = _Undefined,
    Object? expectedCents = _Undefined,
    int? gapCents,
    List<_i0mjlwv3.BankTransaction>? debits,
  }) {
    return LoanCheckLine(
      status: status ?? this.status,
      number: number is int? ? number : this.number,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      expectedCents: expectedCents is int? ? expectedCents : this.expectedCents,
      gapCents: gapCents ?? this.gapCents,
      debits: debits ?? this.debits.map((e0) => e0.copyWith()).toList(),
    );
  }
}
