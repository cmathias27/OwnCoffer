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

abstract class ForecastDay
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ForecastDay._({
    required this.date,
    required this.balanceCents,
  });

  factory ForecastDay({
    required DateTime date,
    required int balanceCents,
  }) = _ForecastDayImpl;

  factory ForecastDay.fromJson(Map<String, dynamic> jsonSerialization) {
    return ForecastDay(
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      balanceCents: jsonSerialization['balanceCents'] as int,
    );
  }

  DateTime date;

  int balanceCents;

  /// Returns a shallow copy of this [ForecastDay]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ForecastDay copyWith({
    DateTime? date,
    int? balanceCents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ForecastDay',
      'date': date.toJson(),
      'balanceCents': balanceCents,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ForecastDay',
      'date': date.toJson(),
      'balanceCents': balanceCents,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ForecastDayImpl extends ForecastDay {
  _ForecastDayImpl({
    required DateTime date,
    required int balanceCents,
  }) : super._(
         date: date,
         balanceCents: balanceCents,
       );

  /// Returns a shallow copy of this [ForecastDay]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ForecastDay copyWith({
    DateTime? date,
    int? balanceCents,
  }) {
    return ForecastDay(
      date: date ?? this.date,
      balanceCents: balanceCents ?? this.balanceCents,
    );
  }
}
