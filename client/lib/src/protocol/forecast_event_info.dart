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

abstract class ForecastEventInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ForecastEventInfo._({
    required this.date,
    required this.amountCents,
    required this.label,
    this.scheduledId,
    this.dueDate,
  });

  factory ForecastEventInfo({
    required DateTime date,
    required int amountCents,
    required String label,
    int? scheduledId,
    DateTime? dueDate,
  }) = _ForecastEventInfoImpl;

  factory ForecastEventInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ForecastEventInfo(
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amountCents: jsonSerialization['amountCents'] as int,
      label: jsonSerialization['label'] as String,
      scheduledId: jsonSerialization['scheduledId'] as int?,
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
    );
  }

  DateTime date;

  int amountCents;

  String label;

  int? scheduledId;

  /// Set when the occurrence is late and counted today.
  DateTime? dueDate;

  /// Returns a shallow copy of this [ForecastEventInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ForecastEventInfo copyWith({
    DateTime? date,
    int? amountCents,
    String? label,
    int? scheduledId,
    DateTime? dueDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ForecastEventInfo',
      'date': date.toJson(),
      'amountCents': amountCents,
      'label': label,
      if (scheduledId != null) 'scheduledId': scheduledId,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ForecastEventInfo',
      'date': date.toJson(),
      'amountCents': amountCents,
      'label': label,
      if (scheduledId != null) 'scheduledId': scheduledId,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ForecastEventInfoImpl extends ForecastEventInfo {
  _ForecastEventInfoImpl({
    required DateTime date,
    required int amountCents,
    required String label,
    int? scheduledId,
    DateTime? dueDate,
  }) : super._(
         date: date,
         amountCents: amountCents,
         label: label,
         scheduledId: scheduledId,
         dueDate: dueDate,
       );

  /// Returns a shallow copy of this [ForecastEventInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ForecastEventInfo copyWith({
    DateTime? date,
    int? amountCents,
    String? label,
    Object? scheduledId = _Undefined,
    Object? dueDate = _Undefined,
  }) {
    return ForecastEventInfo(
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
      label: label ?? this.label,
      scheduledId: scheduledId is int? ? scheduledId : this.scheduledId,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
    );
  }
}
