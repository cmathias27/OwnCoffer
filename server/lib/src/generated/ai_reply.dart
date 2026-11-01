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
import 'package:owncoffer_server/src/generated/protocol.dart' as _itdod8fx;
import 'package:serverpod/serverpod.dart' as _is;
import 'action_proposal.dart' as _ius3n358;

/// The assistant's answer, with what it used and what left the server.
abstract class AiReply
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AiReply._({
    required this.text,
    required this.tools,
    required this.provider,
    required this.model,
    required this.isExternal,
    required this.proposals,
  });

  factory AiReply({
    required String text,
    required List<String> tools,
    required String provider,
    required String model,
    required bool isExternal,
    required List<_ius3n358.ActionProposal> proposals,
  }) = _AiReplyImpl;

  factory AiReply.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiReply(
      text: jsonSerialization['text'] as String,
      tools: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['tools'],
      ),
      provider: jsonSerialization['provider'] as String,
      model: jsonSerialization['model'] as String,
      isExternal: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isExternal'],
      ),
      proposals: _itdod8fx.Protocol()
          .deserialize<List<_ius3n358.ActionProposal>>(
            jsonSerialization['proposals'],
          ),
    );
  }

  String text;

  /// Engine functions it called (get_budget_status…), in order.
  List<String> tools;

  /// Provider and model that answered.
  String provider;

  String model;

  /// The model runs outside this server and the local network.
  bool isExternal;

  /// Proposals it made, to accept in Mon conseiller.
  List<_ius3n358.ActionProposal> proposals;

  /// Returns a shallow copy of this [AiReply]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiReply copyWith({
    String? text,
    List<String>? tools,
    String? provider,
    String? model,
    bool? isExternal,
    List<_ius3n358.ActionProposal>? proposals,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiReply',
      'text': text,
      'tools': tools.toJson(),
      'provider': provider,
      'model': model,
      'isExternal': isExternal,
      'proposals': proposals.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiReply',
      'text': text,
      'tools': tools.toJson(),
      'provider': provider,
      'model': model,
      'isExternal': isExternal,
      'proposals': proposals.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AiReplyImpl extends AiReply {
  _AiReplyImpl({
    required String text,
    required List<String> tools,
    required String provider,
    required String model,
    required bool isExternal,
    required List<_ius3n358.ActionProposal> proposals,
  }) : super._(
         text: text,
         tools: tools,
         provider: provider,
         model: model,
         isExternal: isExternal,
         proposals: proposals,
       );

  /// Returns a shallow copy of this [AiReply]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiReply copyWith({
    String? text,
    List<String>? tools,
    String? provider,
    String? model,
    bool? isExternal,
    List<_ius3n358.ActionProposal>? proposals,
  }) {
    return AiReply(
      text: text ?? this.text,
      tools: tools ?? this.tools.map((e0) => e0).toList(),
      provider: provider ?? this.provider,
      model: model ?? this.model,
      isExternal: isExternal ?? this.isExternal,
      proposals:
          proposals ?? this.proposals.map((e0) => e0.copyWith()).toList(),
    );
  }
}
