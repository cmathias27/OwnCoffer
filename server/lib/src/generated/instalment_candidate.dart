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
import 'loan_kind.dart' as _i1700pxx;

/// A payment in instalments (or small consumer loan) found among the
/// debits of the visible accounts and not yet in the loans: shown on the
/// loans page so that it can be added in one touch.
abstract class InstalmentCandidate
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InstalmentCandidate._({
    required this.accountId,
    required this.label,
    required this.kind,
    required this.amountCents,
    required this.paidCount,
    this.statedCount,
    required this.suggestedCount,
    required this.firstDate,
    required this.lastDate,
    required this.first,
  });

  factory InstalmentCandidate({
    required int accountId,
    required String label,
    required _i1700pxx.LoanKind kind,
    required int amountCents,
    required int paidCount,
    int? statedCount,
    required int suggestedCount,
    required DateTime firstDate,
    required DateTime lastDate,
    required _i0mjlwv3.BankTransaction first,
  }) = _InstalmentCandidateImpl;

  factory InstalmentCandidate.fromJson(Map<String, dynamic> jsonSerialization) {
    return InstalmentCandidate(
      accountId: jsonSerialization['accountId'] as int,
      label: jsonSerialization['label'] as String,
      kind: _i1700pxx.LoanKind.fromJson((jsonSerialization['kind'] as String)),
      amountCents: jsonSerialization['amountCents'] as int,
      paidCount: jsonSerialization['paidCount'] as int,
      statedCount: jsonSerialization['statedCount'] as int?,
      suggestedCount: jsonSerialization['suggestedCount'] as int,
      firstDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstDate'],
      ),
      lastDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastDate'],
      ),
      first: _itdod8fx.Protocol().deserialize<_i0mjlwv3.BankTransaction>(
        jsonSerialization['first'],
      ),
    );
  }

  int accountId;

  /// Label without the instalment number ("ONEY 4X").
  String label;

  /// installments, or consumer for a consumer-loan category.
  _i1700pxx.LoanKind kind;

  /// Last instalment debited (positive).
  int amountCents;

  int paidCount;

  /// Number of instalments written in the labels, when there is one.
  int? statedCount;

  /// Number of instalments to propose; the user sets the right one.
  int suggestedCount;

  DateTime firstDate;

  DateTime lastDate;

  /// The first instalment: the loan is declared from it.
  _i0mjlwv3.BankTransaction first;

  /// Returns a shallow copy of this [InstalmentCandidate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InstalmentCandidate copyWith({
    int? accountId,
    String? label,
    _i1700pxx.LoanKind? kind,
    int? amountCents,
    int? paidCount,
    int? statedCount,
    int? suggestedCount,
    DateTime? firstDate,
    DateTime? lastDate,
    _i0mjlwv3.BankTransaction? first,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InstalmentCandidate',
      'accountId': accountId,
      'label': label,
      'kind': kind.toJson(),
      'amountCents': amountCents,
      'paidCount': paidCount,
      if (statedCount != null) 'statedCount': statedCount,
      'suggestedCount': suggestedCount,
      'firstDate': firstDate.toJson(),
      'lastDate': lastDate.toJson(),
      'first': first.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InstalmentCandidate',
      'accountId': accountId,
      'label': label,
      'kind': kind.toJson(),
      'amountCents': amountCents,
      'paidCount': paidCount,
      if (statedCount != null) 'statedCount': statedCount,
      'suggestedCount': suggestedCount,
      'firstDate': firstDate.toJson(),
      'lastDate': lastDate.toJson(),
      'first': first.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InstalmentCandidateImpl extends InstalmentCandidate {
  _InstalmentCandidateImpl({
    required int accountId,
    required String label,
    required _i1700pxx.LoanKind kind,
    required int amountCents,
    required int paidCount,
    int? statedCount,
    required int suggestedCount,
    required DateTime firstDate,
    required DateTime lastDate,
    required _i0mjlwv3.BankTransaction first,
  }) : super._(
         accountId: accountId,
         label: label,
         kind: kind,
         amountCents: amountCents,
         paidCount: paidCount,
         statedCount: statedCount,
         suggestedCount: suggestedCount,
         firstDate: firstDate,
         lastDate: lastDate,
         first: first,
       );

  /// Returns a shallow copy of this [InstalmentCandidate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InstalmentCandidate copyWith({
    int? accountId,
    String? label,
    _i1700pxx.LoanKind? kind,
    int? amountCents,
    int? paidCount,
    Object? statedCount = _Undefined,
    int? suggestedCount,
    DateTime? firstDate,
    DateTime? lastDate,
    _i0mjlwv3.BankTransaction? first,
  }) {
    return InstalmentCandidate(
      accountId: accountId ?? this.accountId,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      amountCents: amountCents ?? this.amountCents,
      paidCount: paidCount ?? this.paidCount,
      statedCount: statedCount is int? ? statedCount : this.statedCount,
      suggestedCount: suggestedCount ?? this.suggestedCount,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      first: first ?? this.first.copyWith(),
    );
  }
}
