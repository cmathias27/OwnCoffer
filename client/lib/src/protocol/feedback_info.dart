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
import 'user_feedback.dart' as _iv6k6stc;

/// A remark and who sent it (server administrator).
abstract class FeedbackInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackInfo._({
    required this.feedback,
    this.email,
  });

  factory FeedbackInfo({
    required _iv6k6stc.UserFeedback feedback,
    String? email,
  }) = _FeedbackInfoImpl;

  factory FeedbackInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackInfo(
      feedback: _iylp5nsw.Protocol().deserialize<_iv6k6stc.UserFeedback>(
        jsonSerialization['feedback'],
      ),
      email: jsonSerialization['email'] as String?,
    );
  }

  _iv6k6stc.UserFeedback feedback;

  String? email;

  /// Returns a shallow copy of this [FeedbackInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackInfo copyWith({
    _iv6k6stc.UserFeedback? feedback,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackInfo',
      'feedback': feedback.toJson(),
      if (email != null) 'email': email,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackInfo',
      'feedback': feedback.toJsonForProtocol(),
      if (email != null) 'email': email,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackInfoImpl extends FeedbackInfo {
  _FeedbackInfoImpl({
    required _iv6k6stc.UserFeedback feedback,
    String? email,
  }) : super._(
         feedback: feedback,
         email: email,
       );

  /// Returns a shallow copy of this [FeedbackInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackInfo copyWith({
    _iv6k6stc.UserFeedback? feedback,
    Object? email = _Undefined,
  }) {
    return FeedbackInfo(
      feedback: feedback ?? this.feedback.copyWith(),
      email: email is String? ? email : this.email,
    );
  }
}
