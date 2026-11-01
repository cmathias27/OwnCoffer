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

/// An invoice or loan document recreated by an import, waiting for its file.
abstract class ImportedDocument
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportedDocument._({
    required this.kind,
    required this.oldId,
    required this.newId,
    required this.sizeBytes,
  });

  factory ImportedDocument({
    required String kind,
    required int oldId,
    required int newId,
    required int sizeBytes,
  }) = _ImportedDocumentImpl;

  factory ImportedDocument.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportedDocument(
      kind: jsonSerialization['kind'] as String,
      oldId: jsonSerialization['oldId'] as int,
      newId: jsonSerialization['newId'] as int,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
    );
  }

  /// invoice or loanDocument
  String kind;

  /// Its id in the export, to find the file at the source.
  int oldId;

  /// Its id here, to send the file to.
  int newId;

  int sizeBytes;

  /// Returns a shallow copy of this [ImportedDocument]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportedDocument copyWith({
    String? kind,
    int? oldId,
    int? newId,
    int? sizeBytes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportedDocument',
      'kind': kind,
      'oldId': oldId,
      'newId': newId,
      'sizeBytes': sizeBytes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportedDocument',
      'kind': kind,
      'oldId': oldId,
      'newId': newId,
      'sizeBytes': sizeBytes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ImportedDocumentImpl extends ImportedDocument {
  _ImportedDocumentImpl({
    required String kind,
    required int oldId,
    required int newId,
    required int sizeBytes,
  }) : super._(
         kind: kind,
         oldId: oldId,
         newId: newId,
         sizeBytes: sizeBytes,
       );

  /// Returns a shallow copy of this [ImportedDocument]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportedDocument copyWith({
    String? kind,
    int? oldId,
    int? newId,
    int? sizeBytes,
  }) {
    return ImportedDocument(
      kind: kind ?? this.kind,
      oldId: oldId ?? this.oldId,
      newId: newId ?? this.newId,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }
}
