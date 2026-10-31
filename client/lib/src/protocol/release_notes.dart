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

/// One version of the CHANGELOG (markdown body, French).
abstract class ReleaseNotes
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReleaseNotes._({
    required this.version,
    required this.date,
    required this.body,
  });

  factory ReleaseNotes({
    required String version,
    required String date,
    required String body,
  }) = _ReleaseNotesImpl;

  factory ReleaseNotes.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReleaseNotes(
      version: jsonSerialization['version'] as String,
      date: jsonSerialization['date'] as String,
      body: jsonSerialization['body'] as String,
    );
  }

  String version;

  String date;

  String body;

  /// Returns a shallow copy of this [ReleaseNotes]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReleaseNotes copyWith({
    String? version,
    String? date,
    String? body,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReleaseNotes',
      'version': version,
      'date': date,
      'body': body,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReleaseNotes',
      'version': version,
      'date': date,
      'body': body,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ReleaseNotesImpl extends ReleaseNotes {
  _ReleaseNotesImpl({
    required String version,
    required String date,
    required String body,
  }) : super._(
         version: version,
         date: date,
         body: body,
       );

  /// Returns a shallow copy of this [ReleaseNotes]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReleaseNotes copyWith({
    String? version,
    String? date,
    String? body,
  }) {
    return ReleaseNotes(
      version: version ?? this.version,
      date: date ?? this.date,
      body: body ?? this.body,
    );
  }
}
