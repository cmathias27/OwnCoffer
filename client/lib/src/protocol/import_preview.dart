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
import 'package:owncoffer_client/src/protocol/protocol.dart' as _iylp5nsw;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'import_issue_info.dart' as _iso7nf03;
import 'import_preview_line.dart' as _i4e8elxc;

/// What an import would do, computed without writing anything.
abstract class ImportPreview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportPreview._({
    required this.format,
    required this.encoding,
    required this.readCount,
    required this.newCount,
    required this.duplicateCount,
    required this.possibleDuplicateCount,
    required this.classifiedCount,
    required this.errorCount,
    required this.issues,
    required this.lines,
    required this.sameFileAlreadyImported,
    this.statedBalanceCents,
    this.statedBalanceDate,
    this.balanceAfterImportCents,
    this.recognisedAccountId,
    required this.otherBankAccount,
  });

  factory ImportPreview({
    required String format,
    required String encoding,
    required int readCount,
    required int newCount,
    required int duplicateCount,
    required int possibleDuplicateCount,
    required int classifiedCount,
    required int errorCount,
    required List<_iso7nf03.ImportIssueInfo> issues,
    required List<_i4e8elxc.ImportPreviewLine> lines,
    required bool sameFileAlreadyImported,
    int? statedBalanceCents,
    DateTime? statedBalanceDate,
    int? balanceAfterImportCents,
    int? recognisedAccountId,
    required bool otherBankAccount,
  }) = _ImportPreviewImpl;

  factory ImportPreview.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportPreview(
      format: jsonSerialization['format'] as String,
      encoding: jsonSerialization['encoding'] as String,
      readCount: jsonSerialization['readCount'] as int,
      newCount: jsonSerialization['newCount'] as int,
      duplicateCount: jsonSerialization['duplicateCount'] as int,
      possibleDuplicateCount:
          jsonSerialization['possibleDuplicateCount'] as int,
      classifiedCount: jsonSerialization['classifiedCount'] as int,
      errorCount: jsonSerialization['errorCount'] as int,
      issues: _iylp5nsw.Protocol().deserialize<List<_iso7nf03.ImportIssueInfo>>(
        jsonSerialization['issues'],
      ),
      lines: _iylp5nsw.Protocol()
          .deserialize<List<_i4e8elxc.ImportPreviewLine>>(
            jsonSerialization['lines'],
          ),
      sameFileAlreadyImported: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['sameFileAlreadyImported'],
      ),
      statedBalanceCents: jsonSerialization['statedBalanceCents'] as int?,
      statedBalanceDate: jsonSerialization['statedBalanceDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['statedBalanceDate'],
            ),
      balanceAfterImportCents:
          jsonSerialization['balanceAfterImportCents'] as int?,
      recognisedAccountId: jsonSerialization['recognisedAccountId'] as int?,
      otherBankAccount: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['otherBankAccount'],
      ),
    );
  }

  String format;

  String encoding;

  int readCount;

  int newCount;

  int duplicateCount;

  int possibleDuplicateCount;

  int classifiedCount;

  int errorCount;

  List<_iso7nf03.ImportIssueInfo> issues;

  List<_i4e8elxc.ImportPreviewLine> lines;

  /// The same file (same bytes) was already imported into this account.
  bool sameFileAlreadyImported;

  /// Closing balance stated by the bank (OFX), to compare with OwnCoffer's.
  int? statedBalanceCents;

  DateTime? statedBalanceDate;

  /// OwnCoffer's balance on statedBalanceDate once the new lines are
  /// imported (possible duplicates left out), to compare with the bank's.
  int? balanceAfterImportCents;

  /// Visible account of the group whose bank account number matches the
  /// file (OFX), possibly the chosen one.
  int? recognisedAccountId;

  /// The chosen account already knows another bank account number.
  bool otherBankAccount;

  /// Returns a shallow copy of this [ImportPreview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportPreview copyWith({
    String? format,
    String? encoding,
    int? readCount,
    int? newCount,
    int? duplicateCount,
    int? possibleDuplicateCount,
    int? classifiedCount,
    int? errorCount,
    List<_iso7nf03.ImportIssueInfo>? issues,
    List<_i4e8elxc.ImportPreviewLine>? lines,
    bool? sameFileAlreadyImported,
    int? statedBalanceCents,
    DateTime? statedBalanceDate,
    int? balanceAfterImportCents,
    int? recognisedAccountId,
    bool? otherBankAccount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportPreview',
      'format': format,
      'encoding': encoding,
      'readCount': readCount,
      'newCount': newCount,
      'duplicateCount': duplicateCount,
      'possibleDuplicateCount': possibleDuplicateCount,
      'classifiedCount': classifiedCount,
      'errorCount': errorCount,
      'issues': issues.toJson(valueToJson: (v) => v.toJson()),
      'lines': lines.toJson(valueToJson: (v) => v.toJson()),
      'sameFileAlreadyImported': sameFileAlreadyImported,
      if (statedBalanceCents != null) 'statedBalanceCents': statedBalanceCents,
      if (statedBalanceDate != null)
        'statedBalanceDate': statedBalanceDate?.toJson(),
      if (balanceAfterImportCents != null)
        'balanceAfterImportCents': balanceAfterImportCents,
      if (recognisedAccountId != null)
        'recognisedAccountId': recognisedAccountId,
      'otherBankAccount': otherBankAccount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportPreview',
      'format': format,
      'encoding': encoding,
      'readCount': readCount,
      'newCount': newCount,
      'duplicateCount': duplicateCount,
      'possibleDuplicateCount': possibleDuplicateCount,
      'classifiedCount': classifiedCount,
      'errorCount': errorCount,
      'issues': issues.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'lines': lines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'sameFileAlreadyImported': sameFileAlreadyImported,
      if (statedBalanceCents != null) 'statedBalanceCents': statedBalanceCents,
      if (statedBalanceDate != null)
        'statedBalanceDate': statedBalanceDate?.toJson(),
      if (balanceAfterImportCents != null)
        'balanceAfterImportCents': balanceAfterImportCents,
      if (recognisedAccountId != null)
        'recognisedAccountId': recognisedAccountId,
      'otherBankAccount': otherBankAccount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportPreviewImpl extends ImportPreview {
  _ImportPreviewImpl({
    required String format,
    required String encoding,
    required int readCount,
    required int newCount,
    required int duplicateCount,
    required int possibleDuplicateCount,
    required int classifiedCount,
    required int errorCount,
    required List<_iso7nf03.ImportIssueInfo> issues,
    required List<_i4e8elxc.ImportPreviewLine> lines,
    required bool sameFileAlreadyImported,
    int? statedBalanceCents,
    DateTime? statedBalanceDate,
    int? balanceAfterImportCents,
    int? recognisedAccountId,
    required bool otherBankAccount,
  }) : super._(
         format: format,
         encoding: encoding,
         readCount: readCount,
         newCount: newCount,
         duplicateCount: duplicateCount,
         possibleDuplicateCount: possibleDuplicateCount,
         classifiedCount: classifiedCount,
         errorCount: errorCount,
         issues: issues,
         lines: lines,
         sameFileAlreadyImported: sameFileAlreadyImported,
         statedBalanceCents: statedBalanceCents,
         statedBalanceDate: statedBalanceDate,
         balanceAfterImportCents: balanceAfterImportCents,
         recognisedAccountId: recognisedAccountId,
         otherBankAccount: otherBankAccount,
       );

  /// Returns a shallow copy of this [ImportPreview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportPreview copyWith({
    String? format,
    String? encoding,
    int? readCount,
    int? newCount,
    int? duplicateCount,
    int? possibleDuplicateCount,
    int? classifiedCount,
    int? errorCount,
    List<_iso7nf03.ImportIssueInfo>? issues,
    List<_i4e8elxc.ImportPreviewLine>? lines,
    bool? sameFileAlreadyImported,
    Object? statedBalanceCents = _Undefined,
    Object? statedBalanceDate = _Undefined,
    Object? balanceAfterImportCents = _Undefined,
    Object? recognisedAccountId = _Undefined,
    bool? otherBankAccount,
  }) {
    return ImportPreview(
      format: format ?? this.format,
      encoding: encoding ?? this.encoding,
      readCount: readCount ?? this.readCount,
      newCount: newCount ?? this.newCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
      possibleDuplicateCount:
          possibleDuplicateCount ?? this.possibleDuplicateCount,
      classifiedCount: classifiedCount ?? this.classifiedCount,
      errorCount: errorCount ?? this.errorCount,
      issues: issues ?? this.issues.map((e0) => e0.copyWith()).toList(),
      lines: lines ?? this.lines.map((e0) => e0.copyWith()).toList(),
      sameFileAlreadyImported:
          sameFileAlreadyImported ?? this.sameFileAlreadyImported,
      statedBalanceCents: statedBalanceCents is int?
          ? statedBalanceCents
          : this.statedBalanceCents,
      statedBalanceDate: statedBalanceDate is DateTime?
          ? statedBalanceDate
          : this.statedBalanceDate,
      balanceAfterImportCents: balanceAfterImportCents is int?
          ? balanceAfterImportCents
          : this.balanceAfterImportCents,
      recognisedAccountId: recognisedAccountId is int?
          ? recognisedAccountId
          : this.recognisedAccountId,
      otherBankAccount: otherBankAccount ?? this.otherBankAccount,
    );
  }
}
