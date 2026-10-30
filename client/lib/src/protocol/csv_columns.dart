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

/// Columns chosen by the user for a CSV file whose header is not recognised.
/// Indexes are 0-based.
abstract class CsvColumns
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CsvColumns._({
    required this.delimiter,
    required this.headerRow,
    required this.dateColumn,
    required this.labelColumn,
    this.memoColumn,
    this.amountColumn,
    this.debitColumn,
    this.creditColumn,
    required this.monthFirst,
  });

  factory CsvColumns({
    required String delimiter,
    required int headerRow,
    required int dateColumn,
    required int labelColumn,
    int? memoColumn,
    int? amountColumn,
    int? debitColumn,
    int? creditColumn,
    required bool monthFirst,
  }) = _CsvColumnsImpl;

  factory CsvColumns.fromJson(Map<String, dynamic> jsonSerialization) {
    return CsvColumns(
      delimiter: jsonSerialization['delimiter'] as String,
      headerRow: jsonSerialization['headerRow'] as int,
      dateColumn: jsonSerialization['dateColumn'] as int,
      labelColumn: jsonSerialization['labelColumn'] as int,
      memoColumn: jsonSerialization['memoColumn'] as int?,
      amountColumn: jsonSerialization['amountColumn'] as int?,
      debitColumn: jsonSerialization['debitColumn'] as int?,
      creditColumn: jsonSerialization['creditColumn'] as int?,
      monthFirst: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['monthFirst'],
      ),
    );
  }

  String delimiter;

  int headerRow;

  int dateColumn;

  int labelColumn;

  int? memoColumn;

  int? amountColumn;

  int? debitColumn;

  int? creditColumn;

  bool monthFirst;

  /// Returns a shallow copy of this [CsvColumns]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CsvColumns copyWith({
    String? delimiter,
    int? headerRow,
    int? dateColumn,
    int? labelColumn,
    int? memoColumn,
    int? amountColumn,
    int? debitColumn,
    int? creditColumn,
    bool? monthFirst,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CsvColumns',
      'delimiter': delimiter,
      'headerRow': headerRow,
      'dateColumn': dateColumn,
      'labelColumn': labelColumn,
      if (memoColumn != null) 'memoColumn': memoColumn,
      if (amountColumn != null) 'amountColumn': amountColumn,
      if (debitColumn != null) 'debitColumn': debitColumn,
      if (creditColumn != null) 'creditColumn': creditColumn,
      'monthFirst': monthFirst,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CsvColumns',
      'delimiter': delimiter,
      'headerRow': headerRow,
      'dateColumn': dateColumn,
      'labelColumn': labelColumn,
      if (memoColumn != null) 'memoColumn': memoColumn,
      if (amountColumn != null) 'amountColumn': amountColumn,
      if (debitColumn != null) 'debitColumn': debitColumn,
      if (creditColumn != null) 'creditColumn': creditColumn,
      'monthFirst': monthFirst,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CsvColumnsImpl extends CsvColumns {
  _CsvColumnsImpl({
    required String delimiter,
    required int headerRow,
    required int dateColumn,
    required int labelColumn,
    int? memoColumn,
    int? amountColumn,
    int? debitColumn,
    int? creditColumn,
    required bool monthFirst,
  }) : super._(
         delimiter: delimiter,
         headerRow: headerRow,
         dateColumn: dateColumn,
         labelColumn: labelColumn,
         memoColumn: memoColumn,
         amountColumn: amountColumn,
         debitColumn: debitColumn,
         creditColumn: creditColumn,
         monthFirst: monthFirst,
       );

  /// Returns a shallow copy of this [CsvColumns]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CsvColumns copyWith({
    String? delimiter,
    int? headerRow,
    int? dateColumn,
    int? labelColumn,
    Object? memoColumn = _Undefined,
    Object? amountColumn = _Undefined,
    Object? debitColumn = _Undefined,
    Object? creditColumn = _Undefined,
    bool? monthFirst,
  }) {
    return CsvColumns(
      delimiter: delimiter ?? this.delimiter,
      headerRow: headerRow ?? this.headerRow,
      dateColumn: dateColumn ?? this.dateColumn,
      labelColumn: labelColumn ?? this.labelColumn,
      memoColumn: memoColumn is int? ? memoColumn : this.memoColumn,
      amountColumn: amountColumn is int? ? amountColumn : this.amountColumn,
      debitColumn: debitColumn is int? ? debitColumn : this.debitColumn,
      creditColumn: creditColumn is int? ? creditColumn : this.creditColumn,
      monthFirst: monthFirst ?? this.monthFirst,
    );
  }
}
