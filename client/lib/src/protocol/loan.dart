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
import 'loan_kind.dart' as _i1700pxx;

/// A fixed-rate loan with constant monthly instalments. The schedule is
/// computed (shared/loans), never stored; indicative, the bank's table
/// prevails.
abstract class Loan
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Loan._({
    this.id,
    required this.groupId,
    this.accountId,
    required this.kind,
    required this.lender,
    this.label,
    required this.principalCents,
    required this.annualRateMilli,
    this.aprMilli,
    required this.durationMonths,
    required this.firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    this.categoryId,
    this.scheduledId,
    DateTime? createdAt,
    this.deletedAt,
  }) : insuranceMonthlyCents = insuranceMonthlyCents ?? 0,
       feesCents = feesCents ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory Loan({
    int? id,
    required int groupId,
    int? accountId,
    required _i1700pxx.LoanKind kind,
    required String lender,
    String? label,
    required int principalCents,
    required int annualRateMilli,
    int? aprMilli,
    required int durationMonths,
    required DateTime firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    int? categoryId,
    int? scheduledId,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) = _LoanImpl;

  factory Loan.fromJson(Map<String, dynamic> jsonSerialization) {
    return Loan(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      accountId: jsonSerialization['accountId'] as int?,
      kind: _i1700pxx.LoanKind.fromJson((jsonSerialization['kind'] as String)),
      lender: jsonSerialization['lender'] as String,
      label: jsonSerialization['label'] as String?,
      principalCents: jsonSerialization['principalCents'] as int,
      annualRateMilli: jsonSerialization['annualRateMilli'] as int,
      aprMilli: jsonSerialization['aprMilli'] as int?,
      durationMonths: jsonSerialization['durationMonths'] as int,
      firstDueDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstDueDate'],
      ),
      insuranceMonthlyCents: jsonSerialization['insuranceMonthlyCents'] as int?,
      feesCents: jsonSerialization['feesCents'] as int?,
      categoryId: jsonSerialization['categoryId'] as int?,
      scheduledId: jsonSerialization['scheduledId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  /// Account debited; restricted accounts hide the loan from other members.
  int? accountId;

  _i1700pxx.LoanKind kind;

  /// Bank or organisation.
  String lender;

  /// What it pays for ("Maison", "Voiture").
  String? label;

  int principalCents;

  /// Nominal annual rate in thousandths of a percent: 3.45 % = 3450.
  int annualRateMilli;

  /// APR (TAEG), for information.
  int? aprMilli;

  int durationMonths;

  DateTime firstDueDate;

  int insuranceMonthlyCents;

  int feesCents;

  int? categoryId;

  /// Planned operation of the instalments, when an account is chosen.
  int? scheduledId;

  DateTime createdAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [Loan]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Loan copyWith({
    int? id,
    int? groupId,
    int? accountId,
    _i1700pxx.LoanKind? kind,
    String? lender,
    String? label,
    int? principalCents,
    int? annualRateMilli,
    int? aprMilli,
    int? durationMonths,
    DateTime? firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    int? categoryId,
    int? scheduledId,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Loan',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (accountId != null) 'accountId': accountId,
      'kind': kind.toJson(),
      'lender': lender,
      if (label != null) 'label': label,
      'principalCents': principalCents,
      'annualRateMilli': annualRateMilli,
      if (aprMilli != null) 'aprMilli': aprMilli,
      'durationMonths': durationMonths,
      'firstDueDate': firstDueDate.toJson(),
      'insuranceMonthlyCents': insuranceMonthlyCents,
      'feesCents': feesCents,
      if (categoryId != null) 'categoryId': categoryId,
      if (scheduledId != null) 'scheduledId': scheduledId,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Loan',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (accountId != null) 'accountId': accountId,
      'kind': kind.toJson(),
      'lender': lender,
      if (label != null) 'label': label,
      'principalCents': principalCents,
      'annualRateMilli': annualRateMilli,
      if (aprMilli != null) 'aprMilli': aprMilli,
      'durationMonths': durationMonths,
      'firstDueDate': firstDueDate.toJson(),
      'insuranceMonthlyCents': insuranceMonthlyCents,
      'feesCents': feesCents,
      if (categoryId != null) 'categoryId': categoryId,
      if (scheduledId != null) 'scheduledId': scheduledId,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanImpl extends Loan {
  _LoanImpl({
    int? id,
    required int groupId,
    int? accountId,
    required _i1700pxx.LoanKind kind,
    required String lender,
    String? label,
    required int principalCents,
    required int annualRateMilli,
    int? aprMilli,
    required int durationMonths,
    required DateTime firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    int? categoryId,
    int? scheduledId,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         accountId: accountId,
         kind: kind,
         lender: lender,
         label: label,
         principalCents: principalCents,
         annualRateMilli: annualRateMilli,
         aprMilli: aprMilli,
         durationMonths: durationMonths,
         firstDueDate: firstDueDate,
         insuranceMonthlyCents: insuranceMonthlyCents,
         feesCents: feesCents,
         categoryId: categoryId,
         scheduledId: scheduledId,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Loan]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Loan copyWith({
    Object? id = _Undefined,
    int? groupId,
    Object? accountId = _Undefined,
    _i1700pxx.LoanKind? kind,
    String? lender,
    Object? label = _Undefined,
    int? principalCents,
    int? annualRateMilli,
    Object? aprMilli = _Undefined,
    int? durationMonths,
    DateTime? firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    Object? categoryId = _Undefined,
    Object? scheduledId = _Undefined,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return Loan(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      accountId: accountId is int? ? accountId : this.accountId,
      kind: kind ?? this.kind,
      lender: lender ?? this.lender,
      label: label is String? ? label : this.label,
      principalCents: principalCents ?? this.principalCents,
      annualRateMilli: annualRateMilli ?? this.annualRateMilli,
      aprMilli: aprMilli is int? ? aprMilli : this.aprMilli,
      durationMonths: durationMonths ?? this.durationMonths,
      firstDueDate: firstDueDate ?? this.firstDueDate,
      insuranceMonthlyCents:
          insuranceMonthlyCents ?? this.insuranceMonthlyCents,
      feesCents: feesCents ?? this.feesCents,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      scheduledId: scheduledId is int? ? scheduledId : this.scheduledId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
