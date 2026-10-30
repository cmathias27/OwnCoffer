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
import 'category_source.dart' as _idpjit5g;

abstract class ImportPreviewLine
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportPreviewLine._({
    required this.index,
    required this.date,
    required this.amountCents,
    required this.label,
    required this.cleanLabel,
    required this.status,
    this.categoryId,
    required this.categorySource,
  });

  factory ImportPreviewLine({
    required int index,
    required DateTime date,
    required int amountCents,
    required String label,
    required String cleanLabel,
    required String status,
    int? categoryId,
    required _idpjit5g.CategorySource categorySource,
  }) = _ImportPreviewLineImpl;

  factory ImportPreviewLine.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportPreviewLine(
      index: jsonSerialization['index'] as int,
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amountCents: jsonSerialization['amountCents'] as int,
      label: jsonSerialization['label'] as String,
      cleanLabel: jsonSerialization['cleanLabel'] as String,
      status: jsonSerialization['status'] as String,
      categoryId: jsonSerialization['categoryId'] as int?,
      categorySource: _idpjit5g.CategorySource.fromJson(
        (jsonSerialization['categorySource'] as String),
      ),
    );
  }

  /// Position in the file, used to choose possible duplicates to import.
  int index;

  DateTime date;

  int amountCents;

  String label;

  String cleanLabel;

  /// new, duplicate or possibleDuplicate
  String status;

  int? categoryId;

  _idpjit5g.CategorySource categorySource;

  /// Returns a shallow copy of this [ImportPreviewLine]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportPreviewLine copyWith({
    int? index,
    DateTime? date,
    int? amountCents,
    String? label,
    String? cleanLabel,
    String? status,
    int? categoryId,
    _idpjit5g.CategorySource? categorySource,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportPreviewLine',
      'index': index,
      'date': date.toJson(),
      'amountCents': amountCents,
      'label': label,
      'cleanLabel': cleanLabel,
      'status': status,
      if (categoryId != null) 'categoryId': categoryId,
      'categorySource': categorySource.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportPreviewLine',
      'index': index,
      'date': date.toJson(),
      'amountCents': amountCents,
      'label': label,
      'cleanLabel': cleanLabel,
      'status': status,
      if (categoryId != null) 'categoryId': categoryId,
      'categorySource': categorySource.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportPreviewLineImpl extends ImportPreviewLine {
  _ImportPreviewLineImpl({
    required int index,
    required DateTime date,
    required int amountCents,
    required String label,
    required String cleanLabel,
    required String status,
    int? categoryId,
    required _idpjit5g.CategorySource categorySource,
  }) : super._(
         index: index,
         date: date,
         amountCents: amountCents,
         label: label,
         cleanLabel: cleanLabel,
         status: status,
         categoryId: categoryId,
         categorySource: categorySource,
       );

  /// Returns a shallow copy of this [ImportPreviewLine]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportPreviewLine copyWith({
    int? index,
    DateTime? date,
    int? amountCents,
    String? label,
    String? cleanLabel,
    String? status,
    Object? categoryId = _Undefined,
    _idpjit5g.CategorySource? categorySource,
  }) {
    return ImportPreviewLine(
      index: index ?? this.index,
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
      label: label ?? this.label,
      cleanLabel: cleanLabel ?? this.cleanLabel,
      status: status ?? this.status,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      categorySource: categorySource ?? this.categorySource,
    );
  }
}
