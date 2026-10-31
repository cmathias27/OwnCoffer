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
import 'calendar_item.dart' as _itcb21m0;

/// Due dates of a budget month on the accounts the user may see.
abstract class DueCalendar
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DueCalendar._({
    required this.start,
    required this.last,
    required this.items,
    required this.upcomingDebitsCents,
    required this.upcomingCreditsCents,
  });

  factory DueCalendar({
    required DateTime start,
    required DateTime last,
    required List<_itcb21m0.CalendarItem> items,
    required int upcomingDebitsCents,
    required int upcomingCreditsCents,
  }) = _DueCalendarImpl;

  factory DueCalendar.fromJson(Map<String, dynamic> jsonSerialization) {
    return DueCalendar(
      start: _is.DateTimeJsonExtension.fromJson(jsonSerialization['start']),
      last: _is.DateTimeJsonExtension.fromJson(jsonSerialization['last']),
      items: _itdod8fx.Protocol().deserialize<List<_itcb21m0.CalendarItem>>(
        jsonSerialization['items'],
      ),
      upcomingDebitsCents: jsonSerialization['upcomingDebitsCents'] as int,
      upcomingCreditsCents: jsonSerialization['upcomingCreditsCents'] as int,
    );
  }

  DateTime start;

  DateTime last;

  List<_itcb21m0.CalendarItem> items;

  /// Debits still to come (negative) and credits still to come.
  int upcomingDebitsCents;

  int upcomingCreditsCents;

  /// Returns a shallow copy of this [DueCalendar]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DueCalendar copyWith({
    DateTime? start,
    DateTime? last,
    List<_itcb21m0.CalendarItem>? items,
    int? upcomingDebitsCents,
    int? upcomingCreditsCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DueCalendar',
      'start': start.toJson(),
      'last': last.toJson(),
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'upcomingDebitsCents': upcomingDebitsCents,
      'upcomingCreditsCents': upcomingCreditsCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DueCalendar',
      'start': start.toJson(),
      'last': last.toJson(),
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'upcomingDebitsCents': upcomingDebitsCents,
      'upcomingCreditsCents': upcomingCreditsCents,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DueCalendarImpl extends DueCalendar {
  _DueCalendarImpl({
    required DateTime start,
    required DateTime last,
    required List<_itcb21m0.CalendarItem> items,
    required int upcomingDebitsCents,
    required int upcomingCreditsCents,
  }) : super._(
         start: start,
         last: last,
         items: items,
         upcomingDebitsCents: upcomingDebitsCents,
         upcomingCreditsCents: upcomingCreditsCents,
       );

  /// Returns a shallow copy of this [DueCalendar]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DueCalendar copyWith({
    DateTime? start,
    DateTime? last,
    List<_itcb21m0.CalendarItem>? items,
    int? upcomingDebitsCents,
    int? upcomingCreditsCents,
  }) {
    return DueCalendar(
      start: start ?? this.start,
      last: last ?? this.last,
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      upcomingDebitsCents: upcomingDebitsCents ?? this.upcomingDebitsCents,
      upcomingCreditsCents: upcomingCreditsCents ?? this.upcomingCreditsCents,
    );
  }
}
