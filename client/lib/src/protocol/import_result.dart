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
import 'imported_document.dart' as _ij21v5rw;

/// What an import created (decision 0022): the new group, counts, and the
/// documents whose files are sent next, one by one.
abstract class ImportResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportResult._({
    required this.groupId,
    required this.groupName,
    required this.accounts,
    required this.transactions,
    required this.documents,
  });

  factory ImportResult({
    required int groupId,
    required String groupName,
    required int accounts,
    required int transactions,
    required List<_ij21v5rw.ImportedDocument> documents,
  }) = _ImportResultImpl;

  factory ImportResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportResult(
      groupId: jsonSerialization['groupId'] as int,
      groupName: jsonSerialization['groupName'] as String,
      accounts: jsonSerialization['accounts'] as int,
      transactions: jsonSerialization['transactions'] as int,
      documents: _iylp5nsw.Protocol()
          .deserialize<List<_ij21v5rw.ImportedDocument>>(
            jsonSerialization['documents'],
          ),
    );
  }

  int groupId;

  String groupName;

  int accounts;

  int transactions;

  List<_ij21v5rw.ImportedDocument> documents;

  /// Returns a shallow copy of this [ImportResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportResult copyWith({
    int? groupId,
    String? groupName,
    int? accounts,
    int? transactions,
    List<_ij21v5rw.ImportedDocument>? documents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportResult',
      'groupId': groupId,
      'groupName': groupName,
      'accounts': accounts,
      'transactions': transactions,
      'documents': documents.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportResult',
      'groupId': groupId,
      'groupName': groupName,
      'accounts': accounts,
      'transactions': transactions,
      'documents': documents.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ImportResultImpl extends ImportResult {
  _ImportResultImpl({
    required int groupId,
    required String groupName,
    required int accounts,
    required int transactions,
    required List<_ij21v5rw.ImportedDocument> documents,
  }) : super._(
         groupId: groupId,
         groupName: groupName,
         accounts: accounts,
         transactions: transactions,
         documents: documents,
       );

  /// Returns a shallow copy of this [ImportResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportResult copyWith({
    int? groupId,
    String? groupName,
    int? accounts,
    int? transactions,
    List<_ij21v5rw.ImportedDocument>? documents,
  }) {
    return ImportResult(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      accounts: accounts ?? this.accounts,
      transactions: transactions ?? this.transactions,
      documents:
          documents ?? this.documents.map((e0) => e0.copyWith()).toList(),
    );
  }
}
