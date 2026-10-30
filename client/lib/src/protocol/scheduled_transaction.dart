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
import 'frequency.dart' as _ixycnzxw;

/// A planned operation (rent, salary, subscription…).
abstract class ScheduledTransaction
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ScheduledTransaction._({
    this.id,
    required this.accountId,
    required this.amountCents,
    required this.label,
    this.categoryId,
    required this.frequency,
    int? interval,
    required this.startDate,
    this.endDate,
    this.occurrenceCount,
    this.nextDue,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    this.deletedAt,
  }) : interval = interval ?? 1,
       matchPattern = matchPattern ?? '',
       dateToleranceDays = dateToleranceDays ?? 5,
       amountTolerancePercent = amountTolerancePercent ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory ScheduledTransaction({
    int? id,
    required int accountId,
    required int amountCents,
    required String label,
    int? categoryId,
    required _ixycnzxw.ScheduleFrequency frequency,
    int? interval,
    required DateTime startDate,
    DateTime? endDate,
    int? occurrenceCount,
    DateTime? nextDue,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) = _ScheduledTransactionImpl;

  factory ScheduledTransaction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScheduledTransaction(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      label: jsonSerialization['label'] as String,
      categoryId: jsonSerialization['categoryId'] as int?,
      frequency: _ixycnzxw.ScheduleFrequency.fromJson(
        (jsonSerialization['frequency'] as String),
      ),
      interval: jsonSerialization['interval'] as int?,
      startDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      occurrenceCount: jsonSerialization['occurrenceCount'] as int?,
      nextDue: jsonSerialization['nextDue'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['nextDue']),
      matchPattern: jsonSerialization['matchPattern'] as String?,
      dateToleranceDays: jsonSerialization['dateToleranceDays'] as int?,
      amountTolerancePercent:
          jsonSerialization['amountTolerancePercent'] as int?,
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

  int accountId;

  int amountCents;

  String label;

  int? categoryId;

  _ixycnzxw.ScheduleFrequency frequency;

  int interval;

  DateTime startDate;

  DateTime? endDate;

  int? occurrenceCount;

  /// First occurrence not yet realised; null = from startDate.
  DateTime? nextDue;

  String matchPattern;

  int dateToleranceDays;

  int amountTolerancePercent;

  DateTime createdAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [ScheduledTransaction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ScheduledTransaction copyWith({
    int? id,
    int? accountId,
    int? amountCents,
    String? label,
    int? categoryId,
    _ixycnzxw.ScheduleFrequency? frequency,
    int? interval,
    DateTime? startDate,
    DateTime? endDate,
    int? occurrenceCount,
    DateTime? nextDue,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduledTransaction',
      if (id != null) 'id': id,
      'accountId': accountId,
      'amountCents': amountCents,
      'label': label,
      if (categoryId != null) 'categoryId': categoryId,
      'frequency': frequency.toJson(),
      'interval': interval,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (occurrenceCount != null) 'occurrenceCount': occurrenceCount,
      if (nextDue != null) 'nextDue': nextDue?.toJson(),
      'matchPattern': matchPattern,
      'dateToleranceDays': dateToleranceDays,
      'amountTolerancePercent': amountTolerancePercent,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduledTransaction',
      if (id != null) 'id': id,
      'accountId': accountId,
      'amountCents': amountCents,
      'label': label,
      if (categoryId != null) 'categoryId': categoryId,
      'frequency': frequency.toJson(),
      'interval': interval,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (occurrenceCount != null) 'occurrenceCount': occurrenceCount,
      if (nextDue != null) 'nextDue': nextDue?.toJson(),
      'matchPattern': matchPattern,
      'dateToleranceDays': dateToleranceDays,
      'amountTolerancePercent': amountTolerancePercent,
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

class _ScheduledTransactionImpl extends ScheduledTransaction {
  _ScheduledTransactionImpl({
    int? id,
    required int accountId,
    required int amountCents,
    required String label,
    int? categoryId,
    required _ixycnzxw.ScheduleFrequency frequency,
    int? interval,
    required DateTime startDate,
    DateTime? endDate,
    int? occurrenceCount,
    DateTime? nextDue,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         accountId: accountId,
         amountCents: amountCents,
         label: label,
         categoryId: categoryId,
         frequency: frequency,
         interval: interval,
         startDate: startDate,
         endDate: endDate,
         occurrenceCount: occurrenceCount,
         nextDue: nextDue,
         matchPattern: matchPattern,
         dateToleranceDays: dateToleranceDays,
         amountTolerancePercent: amountTolerancePercent,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [ScheduledTransaction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ScheduledTransaction copyWith({
    Object? id = _Undefined,
    int? accountId,
    int? amountCents,
    String? label,
    Object? categoryId = _Undefined,
    _ixycnzxw.ScheduleFrequency? frequency,
    int? interval,
    DateTime? startDate,
    Object? endDate = _Undefined,
    Object? occurrenceCount = _Undefined,
    Object? nextDue = _Undefined,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return ScheduledTransaction(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      amountCents: amountCents ?? this.amountCents,
      label: label ?? this.label,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      occurrenceCount: occurrenceCount is int?
          ? occurrenceCount
          : this.occurrenceCount,
      nextDue: nextDue is DateTime? ? nextDue : this.nextDue,
      matchPattern: matchPattern ?? this.matchPattern,
      dateToleranceDays: dateToleranceDays ?? this.dateToleranceDays,
      amountTolerancePercent:
          amountTolerancePercent ?? this.amountTolerancePercent,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
