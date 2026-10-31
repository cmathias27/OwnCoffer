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

/// An invoice or receipt kept on the server: PDF or photo, attached to an
/// operation (or waiting to be, `transactionId` null). Stored in the
/// database (so in the backups), never sent anywhere unless a member emails
/// it.
abstract class Invoice
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Invoice._({
    this.id,
    required this.groupId,
    this.transactionId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    this.label,
    this.warrantyUntil,
    this.hintAmountCents,
    this.hintDate,
    this.hintMerchant,
    this.uploadedBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Invoice({
    int? id,
    required int groupId,
    int? transactionId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? label,
    DateTime? warrantyUntil,
    int? hintAmountCents,
    DateTime? hintDate,
    String? hintMerchant,
    _isc.UuidValue? uploadedBy,
    DateTime? createdAt,
  }) = _InvoiceImpl;

  factory Invoice.fromJson(Map<String, dynamic> jsonSerialization) {
    return Invoice(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      transactionId: jsonSerialization['transactionId'] as int?,
      fileName: jsonSerialization['fileName'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      label: jsonSerialization['label'] as String?,
      warrantyUntil: jsonSerialization['warrantyUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['warrantyUntil'],
            ),
      hintAmountCents: jsonSerialization['hintAmountCents'] as int?,
      hintDate: jsonSerialization['hintDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['hintDate']),
      hintMerchant: jsonSerialization['hintMerchant'] as String?,
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

  int groupId;

  /// The operation it justifies; null while it waits to be attached.
  /// Deleted with the operation (when deleted for good, not when in the
  /// trash): never left visible to the whole group when it was only seen
  /// through a restricted account.
  int? transactionId;

  /// Name of the file as it was sent.
  String fileName;

  String mimeType;

  int sizeBytes;

  /// What it is for (e.g. `Lave-linge`), part of its name.
  String? label;

  /// End of the warranty: a reminder comes a month before.
  DateTime? warrantyUntil;

  /// What is known of an invoice waiting for its operation, to propose
  /// the right one: total paid (positive cents), date, merchant.
  int? hintAmountCents;

  DateTime? hintDate;

  String? hintMerchant;

  _isc.UuidValue? uploadedBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [Invoice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Invoice copyWith({
    int? id,
    int? groupId,
    int? transactionId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? label,
    DateTime? warrantyUntil,
    int? hintAmountCents,
    DateTime? hintDate,
    String? hintMerchant,
    _isc.UuidValue? uploadedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Invoice',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (transactionId != null) 'transactionId': transactionId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (label != null) 'label': label,
      if (warrantyUntil != null) 'warrantyUntil': warrantyUntil?.toJson(),
      if (hintAmountCents != null) 'hintAmountCents': hintAmountCents,
      if (hintDate != null) 'hintDate': hintDate?.toJson(),
      if (hintMerchant != null) 'hintMerchant': hintMerchant,
      if (uploadedBy != null) 'uploadedBy': uploadedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Invoice',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (transactionId != null) 'transactionId': transactionId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (label != null) 'label': label,
      if (warrantyUntil != null) 'warrantyUntil': warrantyUntil?.toJson(),
      if (hintAmountCents != null) 'hintAmountCents': hintAmountCents,
      if (hintDate != null) 'hintDate': hintDate?.toJson(),
      if (hintMerchant != null) 'hintMerchant': hintMerchant,
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

class _InvoiceImpl extends Invoice {
  _InvoiceImpl({
    int? id,
    required int groupId,
    int? transactionId,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    String? label,
    DateTime? warrantyUntil,
    int? hintAmountCents,
    DateTime? hintDate,
    String? hintMerchant,
    _isc.UuidValue? uploadedBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         transactionId: transactionId,
         fileName: fileName,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         label: label,
         warrantyUntil: warrantyUntil,
         hintAmountCents: hintAmountCents,
         hintDate: hintDate,
         hintMerchant: hintMerchant,
         uploadedBy: uploadedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Invoice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Invoice copyWith({
    Object? id = _Undefined,
    int? groupId,
    Object? transactionId = _Undefined,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    Object? label = _Undefined,
    Object? warrantyUntil = _Undefined,
    Object? hintAmountCents = _Undefined,
    Object? hintDate = _Undefined,
    Object? hintMerchant = _Undefined,
    Object? uploadedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return Invoice(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      transactionId: transactionId is int? ? transactionId : this.transactionId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      label: label is String? ? label : this.label,
      warrantyUntil: warrantyUntil is DateTime?
          ? warrantyUntil
          : this.warrantyUntil,
      hintAmountCents: hintAmountCents is int?
          ? hintAmountCents
          : this.hintAmountCents,
      hintDate: hintDate is DateTime? ? hintDate : this.hintDate,
      hintMerchant: hintMerchant is String? ? hintMerchant : this.hintMerchant,
      uploadedBy: uploadedBy is _isc.UuidValue? ? uploadedBy : this.uploadedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
