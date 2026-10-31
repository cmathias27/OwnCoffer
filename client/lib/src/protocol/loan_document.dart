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

/// A document of a loan kept on the server: amortisation table, offer,
/// screenshot… Stored in the database (so in the backups), never sent
/// anywhere else.
abstract class LoanDocument
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LoanDocument._({
    this.id,
    required this.loanId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.uploadedBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LoanDocument({
    int? id,
    required int loanId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    _isc.UuidValue? uploadedBy,
    DateTime? createdAt,
  }) = _LoanDocumentImpl;

  factory LoanDocument.fromJson(Map<String, dynamic> jsonSerialization) {
    return LoanDocument(
      id: jsonSerialization['id'] as int?,
      loanId: jsonSerialization['loanId'] as int,
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      uploadedBy: jsonSerialization['uploadedBy'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['uploadedBy'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int loanId;

  String fileName;

  String mimeType;

  int sizeBytes;

  _isc.UuidValue? uploadedBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [LoanDocument]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LoanDocument copyWith({
    int? id,
    int? loanId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    _isc.UuidValue? uploadedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LoanDocument',
      if (id != null) 'id': id,
      'loanId': loanId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (uploadedBy != null) 'uploadedBy': uploadedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LoanDocument',
      if (id != null) 'id': id,
      'loanId': loanId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (uploadedBy != null) 'uploadedBy': uploadedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanDocumentImpl extends LoanDocument {
  _LoanDocumentImpl({
    int? id,
    required int loanId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    _isc.UuidValue? uploadedBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         loanId: loanId,
         fileName: fileName,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         uploadedBy: uploadedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LoanDocument]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LoanDocument copyWith({
    Object? id = _Undefined,
    int? loanId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    Object? uploadedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return LoanDocument(
      id: id is int? ? id : this.id,
      loanId: loanId ?? this.loanId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      uploadedBy: uploadedBy is _isc.UuidValue? ? uploadedBy : this.uploadedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
