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
import 'occurrence_status.dart' as _it10dx4m;

/// One occurrence of a planned operation in the due-date calendar.
abstract class CalendarItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CalendarItem._({
    required this.date,
    required this.scheduledId,
    required this.accountId,
    required this.label,
    required this.amountCents,
    this.categoryId,
    required this.subscription,
    this.loanId,
    required this.status,
    this.transactionId,
    this.transactionAmountCents,
  });

  factory CalendarItem({
    required DateTime date,
    required int scheduledId,
    required int accountId,
    required String label,
    required int amountCents,
    int? categoryId,
    required bool subscription,
    int? loanId,
    required _it10dx4m.OccurrenceStatus status,
    int? transactionId,
    int? transactionAmountCents,
  }) = _CalendarItemImpl;

  factory CalendarItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CalendarItem(
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      scheduledId: jsonSerialization['scheduledId'] as int,
      accountId: jsonSerialization['accountId'] as int,
      label: jsonSerialization['label'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      categoryId: jsonSerialization['categoryId'] as int?,
      subscription: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['subscription'],
      ),
      loanId: jsonSerialization['loanId'] as int?,
      status: _it10dx4m.OccurrenceStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      transactionId: jsonSerialization['transactionId'] as int?,
      transactionAmountCents:
          jsonSerialization['transactionAmountCents'] as int?,
    );
  }

  DateTime date;

  int scheduledId;

  int accountId;

  String label;

  int amountCents;

  int? categoryId;

  bool subscription;

  /// Instalment of a loan of the loans page.
  int? loanId;

  _it10dx4m.OccurrenceStatus status;

  /// Real operation matched with it.
  int? transactionId;

  int? transactionAmountCents;

  /// Returns a shallow copy of this [CalendarItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CalendarItem copyWith({
    DateTime? date,
    int? scheduledId,
    int? accountId,
    String? label,
    int? amountCents,
    int? categoryId,
    bool? subscription,
    int? loanId,
    _it10dx4m.OccurrenceStatus? status,
    int? transactionId,
    int? transactionAmountCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarItem',
      'date': date.toJson(),
      'scheduledId': scheduledId,
      'accountId': accountId,
      'label': label,
      'amountCents': amountCents,
      if (categoryId != null) 'categoryId': categoryId,
      'subscription': subscription,
      if (loanId != null) 'loanId': loanId,
      'status': status.toJson(),
      if (transactionId != null) 'transactionId': transactionId,
      if (transactionAmountCents != null)
        'transactionAmountCents': transactionAmountCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarItem',
      'date': date.toJson(),
      'scheduledId': scheduledId,
      'accountId': accountId,
      'label': label,
      'amountCents': amountCents,
      if (categoryId != null) 'categoryId': categoryId,
      'subscription': subscription,
      if (loanId != null) 'loanId': loanId,
      'status': status.toJson(),
      if (transactionId != null) 'transactionId': transactionId,
      if (transactionAmountCents != null)
        'transactionAmountCents': transactionAmountCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CalendarItemImpl extends CalendarItem {
  _CalendarItemImpl({
    required DateTime date,
    required int scheduledId,
    required int accountId,
    required String label,
    required int amountCents,
    int? categoryId,
    required bool subscription,
    int? loanId,
    required _it10dx4m.OccurrenceStatus status,
    int? transactionId,
    int? transactionAmountCents,
  }) : super._(
         date: date,
         scheduledId: scheduledId,
         accountId: accountId,
         label: label,
         amountCents: amountCents,
         categoryId: categoryId,
         subscription: subscription,
         loanId: loanId,
         status: status,
         transactionId: transactionId,
         transactionAmountCents: transactionAmountCents,
       );

  /// Returns a shallow copy of this [CalendarItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CalendarItem copyWith({
    DateTime? date,
    int? scheduledId,
    int? accountId,
    String? label,
    int? amountCents,
    Object? categoryId = _Undefined,
    bool? subscription,
    Object? loanId = _Undefined,
    _it10dx4m.OccurrenceStatus? status,
    Object? transactionId = _Undefined,
    Object? transactionAmountCents = _Undefined,
  }) {
    return CalendarItem(
      date: date ?? this.date,
      scheduledId: scheduledId ?? this.scheduledId,
      accountId: accountId ?? this.accountId,
      label: label ?? this.label,
      amountCents: amountCents ?? this.amountCents,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      subscription: subscription ?? this.subscription,
      loanId: loanId is int? ? loanId : this.loanId,
      status: status ?? this.status,
      transactionId: transactionId is int? ? transactionId : this.transactionId,
      transactionAmountCents: transactionAmountCents is int?
          ? transactionAmountCents
          : this.transactionAmountCents,
    );
  }
}
