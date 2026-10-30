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

/// One imported bank file. Cancelling an import soft-deletes its operations.
abstract class StatementImport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StatementImport._({
    this.id,
    required this.accountId,
    required this.format,
    required this.fileName,
    required this.fileHash,
    required this.encoding,
    required this.readCount,
    required this.addedCount,
    required this.duplicateCount,
    required this.possibleDuplicateCount,
    required this.errorCount,
    required this.classifiedCount,
    required this.authorId,
    DateTime? createdAt,
    this.cancelledAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory StatementImport({
    int? id,
    required int accountId,
    required String format,
    required String fileName,
    required String fileHash,
    required String encoding,
    required int readCount,
    required int addedCount,
    required int duplicateCount,
    required int possibleDuplicateCount,
    required int errorCount,
    required int classifiedCount,
    required _isc.UuidValue authorId,
    DateTime? createdAt,
    DateTime? cancelledAt,
  }) = _StatementImportImpl;

  factory StatementImport.fromJson(Map<String, dynamic> jsonSerialization) {
    return StatementImport(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int,
      format: jsonSerialization['format'] as String,
      fileName: jsonSerialization['fileName'] as String,
      fileHash: jsonSerialization['fileHash'] as String,
      encoding: jsonSerialization['encoding'] as String,
      readCount: jsonSerialization['readCount'] as int,
      addedCount: jsonSerialization['addedCount'] as int,
      duplicateCount: jsonSerialization['duplicateCount'] as int,
      possibleDuplicateCount:
          jsonSerialization['possibleDuplicateCount'] as int,
      errorCount: jsonSerialization['errorCount'] as int,
      classifiedCount: jsonSerialization['classifiedCount'] as int,
      authorId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authorId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['cancelledAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int accountId;

  String format;

  String fileName;

  /// SHA-256 of the file, to warn when the same file is imported twice.
  String fileHash;

  String encoding;

  int readCount;

  int addedCount;

  int duplicateCount;

  int possibleDuplicateCount;

  int errorCount;

  int classifiedCount;

  _isc.UuidValue authorId;

  DateTime createdAt;

  DateTime? cancelledAt;

  /// Returns a shallow copy of this [StatementImport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StatementImport copyWith({
    int? id,
    int? accountId,
    String? format,
    String? fileName,
    String? fileHash,
    String? encoding,
    int? readCount,
    int? addedCount,
    int? duplicateCount,
    int? possibleDuplicateCount,
    int? errorCount,
    int? classifiedCount,
    _isc.UuidValue? authorId,
    DateTime? createdAt,
    DateTime? cancelledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StatementImport',
      if (id != null) 'id': id,
      'accountId': accountId,
      'format': format,
      'fileName': fileName,
      'fileHash': fileHash,
      'encoding': encoding,
      'readCount': readCount,
      'addedCount': addedCount,
      'duplicateCount': duplicateCount,
      'possibleDuplicateCount': possibleDuplicateCount,
      'errorCount': errorCount,
      'classifiedCount': classifiedCount,
      'authorId': authorId.toJson(),
      'createdAt': createdAt.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StatementImport',
      if (id != null) 'id': id,
      'accountId': accountId,
      'format': format,
      'fileName': fileName,
      'fileHash': fileHash,
      'encoding': encoding,
      'readCount': readCount,
      'addedCount': addedCount,
      'duplicateCount': duplicateCount,
      'possibleDuplicateCount': possibleDuplicateCount,
      'errorCount': errorCount,
      'classifiedCount': classifiedCount,
      'authorId': authorId.toJson(),
      'createdAt': createdAt.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StatementImportImpl extends StatementImport {
  _StatementImportImpl({
    int? id,
    required int accountId,
    required String format,
    required String fileName,
    required String fileHash,
    required String encoding,
    required int readCount,
    required int addedCount,
    required int duplicateCount,
    required int possibleDuplicateCount,
    required int errorCount,
    required int classifiedCount,
    required _isc.UuidValue authorId,
    DateTime? createdAt,
    DateTime? cancelledAt,
  }) : super._(
         id: id,
         accountId: accountId,
         format: format,
         fileName: fileName,
         fileHash: fileHash,
         encoding: encoding,
         readCount: readCount,
         addedCount: addedCount,
         duplicateCount: duplicateCount,
         possibleDuplicateCount: possibleDuplicateCount,
         errorCount: errorCount,
         classifiedCount: classifiedCount,
         authorId: authorId,
         createdAt: createdAt,
         cancelledAt: cancelledAt,
       );

  /// Returns a shallow copy of this [StatementImport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StatementImport copyWith({
    Object? id = _Undefined,
    int? accountId,
    String? format,
    String? fileName,
    String? fileHash,
    String? encoding,
    int? readCount,
    int? addedCount,
    int? duplicateCount,
    int? possibleDuplicateCount,
    int? errorCount,
    int? classifiedCount,
    _isc.UuidValue? authorId,
    DateTime? createdAt,
    Object? cancelledAt = _Undefined,
  }) {
    return StatementImport(
      id: id is int? ? id : this.id,
      accountId: accountId ?? this.accountId,
      format: format ?? this.format,
      fileName: fileName ?? this.fileName,
      fileHash: fileHash ?? this.fileHash,
      encoding: encoding ?? this.encoding,
      readCount: readCount ?? this.readCount,
      addedCount: addedCount ?? this.addedCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
      possibleDuplicateCount:
          possibleDuplicateCount ?? this.possibleDuplicateCount,
      errorCount: errorCount ?? this.errorCount,
      classifiedCount: classifiedCount ?? this.classifiedCount,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt is DateTime? ? cancelledAt : this.cancelledAt,
    );
  }
}
