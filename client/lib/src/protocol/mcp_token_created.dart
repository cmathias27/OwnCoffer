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
import 'mcp_token.dart' as _ibm9fvwa;

/// A new token, shown once: it is not kept in clear.
abstract class McpTokenCreated
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  McpTokenCreated._({
    required this.token,
    required this.secret,
  });

  factory McpTokenCreated({
    required _ibm9fvwa.McpToken token,
    required String secret,
  }) = _McpTokenCreatedImpl;

  factory McpTokenCreated.fromJson(Map<String, dynamic> jsonSerialization) {
    return McpTokenCreated(
      token: _iylp5nsw.Protocol().deserialize<_ibm9fvwa.McpToken>(
        jsonSerialization['token'],
      ),
      secret: jsonSerialization['secret'] as String,
    );
  }

  _ibm9fvwa.McpToken token;

  String secret;

  /// Returns a shallow copy of this [McpTokenCreated]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  McpTokenCreated copyWith({
    _ibm9fvwa.McpToken? token,
    String? secret,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'McpTokenCreated',
      'token': token.toJson(),
      'secret': secret,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'McpTokenCreated',
      'token': token.toJsonForProtocol(),
      'secret': secret,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _McpTokenCreatedImpl extends McpTokenCreated {
  _McpTokenCreatedImpl({
    required _ibm9fvwa.McpToken token,
    required String secret,
  }) : super._(
         token: token,
         secret: secret,
       );

  /// Returns a shallow copy of this [McpTokenCreated]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  McpTokenCreated copyWith({
    _ibm9fvwa.McpToken? token,
    String? secret,
  }) {
    return McpTokenCreated(
      token: token ?? this.token.copyWith(),
      secret: secret ?? this.secret,
    );
  }
}
