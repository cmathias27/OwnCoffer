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

/// A planned operation that never arrived (more than 10 days late).
abstract class MissedOccurrenceInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MissedOccurrenceInfo._({
    required this.scheduledId,
    required this.label,
    required this.dueDate,
    required this.amountCents,
  });

  factory MissedOccurrenceInfo({
    required int scheduledId,
    required String label,
    required DateTime dueDate,
    required int amountCents,
  }) = _MissedOccurrenceInfoImpl;

  factory MissedOccurrenceInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MissedOccurrenceInfo(
      scheduledId: jsonSerialization['scheduledId'] as int,
      label: jsonSerialization['label'] as String,
      dueDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['dueDate'],
      ),
      amountCents: jsonSerialization['amountCents'] as int,
    );
  }

  int scheduledId;

  String label;

  DateTime dueDate;

  int amountCents;

  /// Returns a shallow copy of this [MissedOccurrenceInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MissedOccurrenceInfo copyWith({
    int? scheduledId,
    String? label,
    DateTime? dueDate,
    int? amountCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MissedOccurrenceInfo',
      'scheduledId': scheduledId,
      'label': label,
      'dueDate': dueDate.toJson(),
      'amountCents': amountCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MissedOccurrenceInfo',
      'scheduledId': scheduledId,
      'label': label,
      'dueDate': dueDate.toJson(),
      'amountCents': amountCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MissedOccurrenceInfoImpl extends MissedOccurrenceInfo {
  _MissedOccurrenceInfoImpl({
    required int scheduledId,
    required String label,
    required DateTime dueDate,
    required int amountCents,
  }) : super._(
         scheduledId: scheduledId,
         label: label,
         dueDate: dueDate,
         amountCents: amountCents,
       );

  /// Returns a shallow copy of this [MissedOccurrenceInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MissedOccurrenceInfo copyWith({
    int? scheduledId,
    String? label,
    DateTime? dueDate,
    int? amountCents,
  }) {
    return MissedOccurrenceInfo(
      scheduledId: scheduledId ?? this.scheduledId,
      label: label ?? this.label,
      dueDate: dueDate ?? this.dueDate,
      amountCents: amountCents ?? this.amountCents,
    );
  }
}
