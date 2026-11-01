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
import 'package:serverpod/serverpod.dart' as _is;

/// One database backup kept on the host (name, size, date: no data).
abstract class BackupInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  BackupInfo._({
    required this.name,
    required this.label,
    required this.bytes,
    required this.createdAt,
    bool? encrypted,
  }) : encrypted = encrypted ?? false;

  factory BackupInfo({
    required String name,
    required String label,
    required int bytes,
    required DateTime createdAt,
    bool? encrypted,
  }) = _BackupInfoImpl;

  factory BackupInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return BackupInfo(
      name: jsonSerialization['name'] as String,
      label: jsonSerialization['label'] as String,
      bytes: jsonSerialization['bytes'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      encrypted: jsonSerialization['encrypted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['encrypted']),
    );
  }

  String name;

  /// daily, manual, before-X.Y.Z…
  String label;

  int bytes;

  DateTime createdAt;

  /// Encrypted with docker/backup.key (.dump.gpg).
  bool encrypted;

  /// Returns a shallow copy of this [BackupInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BackupInfo copyWith({
    String? name,
    String? label,
    int? bytes,
    DateTime? createdAt,
    bool? encrypted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BackupInfo',
      'name': name,
      'label': label,
      'bytes': bytes,
      'createdAt': createdAt.toJson(),
      'encrypted': encrypted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BackupInfo',
      'name': name,
      'label': label,
      'bytes': bytes,
      'createdAt': createdAt.toJson(),
      'encrypted': encrypted,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _BackupInfoImpl extends BackupInfo {
  _BackupInfoImpl({
    required String name,
    required String label,
    required int bytes,
    required DateTime createdAt,
    bool? encrypted,
  }) : super._(
         name: name,
         label: label,
         bytes: bytes,
         createdAt: createdAt,
         encrypted: encrypted,
       );

  /// Returns a shallow copy of this [BackupInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BackupInfo copyWith({
    String? name,
    String? label,
    int? bytes,
    DateTime? createdAt,
    bool? encrypted,
  }) {
    return BackupInfo(
      name: name ?? this.name,
      label: label ?? this.label,
      bytes: bytes ?? this.bytes,
      createdAt: createdAt ?? this.createdAt,
      encrypted: encrypted ?? this.encrypted,
    );
  }
}
