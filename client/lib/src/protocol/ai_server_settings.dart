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

/// Server-wide AI settings configured by the server administrator.
abstract class AiServerSettings
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiServerSettings._({
    this.id,
    int? autonomyLevel,
    DateTime? updatedAt,
  }) : autonomyLevel = autonomyLevel ?? 3,
       updatedAt = updatedAt ?? DateTime.now();

  factory AiServerSettings({
    int? id,
    int? autonomyLevel,
    DateTime? updatedAt,
  }) = _AiServerSettingsImpl;

  factory AiServerSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiServerSettings(
      id: jsonSerialization['id'] as int?,
      autonomyLevel: jsonSerialization['autonomyLevel'] as int?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Autonomy level allowed on this server (1 to 5):
  /// 1: Read-only (context queries only, no proposals or document analysis)
  /// 2: Document consultation (reads receipts/invoices and loan documents)
  /// 3: Proposals (propose actions in "Mon conseiller" requiring user confirmation)
  /// 4: Limited automation (reversible operations with audit trail)
  /// 5: Full internal control (autonomous internal actions, never external bank operations)
  int autonomyLevel;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AiServerSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiServerSettings copyWith({
    int? id,
    int? autonomyLevel,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiServerSettings',
      if (id != null) 'id': id,
      'autonomyLevel': autonomyLevel,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiServerSettings',
      if (id != null) 'id': id,
      'autonomyLevel': autonomyLevel,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiServerSettingsImpl extends AiServerSettings {
  _AiServerSettingsImpl({
    int? id,
    int? autonomyLevel,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         autonomyLevel: autonomyLevel,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AiServerSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiServerSettings copyWith({
    Object? id = _Undefined,
    int? autonomyLevel,
    DateTime? updatedAt,
  }) {
    return AiServerSettings(
      id: id is int? ? id : this.id,
      autonomyLevel: autonomyLevel ?? this.autonomyLevel,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
