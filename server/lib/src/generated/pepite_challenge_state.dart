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

/// The challenge of this month, as the app shows it (decision 0030).
abstract class PepiteChallengeState
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PepiteChallengeState._({
    required this.month,
    required this.code,
    required this.target,
    required this.progress,
    required this.done,
    required this.justDone,
  });

  factory PepiteChallengeState({
    required String month,
    required String code,
    required int target,
    required int progress,
    required bool done,
    required bool justDone,
  }) = _PepiteChallengeStateImpl;

  factory PepiteChallengeState.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PepiteChallengeState(
      month: jsonSerialization['month'] as String,
      code: jsonSerialization['code'] as String,
      target: jsonSerialization['target'] as int,
      progress: jsonSerialization['progress'] as int,
      done: _is.BoolJsonExtension.fromJson(jsonSerialization['done']),
      justDone: _is.BoolJsonExtension.fromJson(jsonSerialization['justDone']),
    );
  }

  /// `2026-11`.
  String month;

  String code;

  int target;

  /// How many times so far, since it was chosen (at most [target]).
  int progress;

  bool done;

  /// Done by this very call (to celebrate).
  bool justDone;

  /// Returns a shallow copy of this [PepiteChallengeState]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteChallengeState copyWith({
    String? month,
    String? code,
    int? target,
    int? progress,
    bool? done,
    bool? justDone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteChallengeState',
      'month': month,
      'code': code,
      'target': target,
      'progress': progress,
      'done': done,
      'justDone': justDone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PepiteChallengeState',
      'month': month,
      'code': code,
      'target': target,
      'progress': progress,
      'done': done,
      'justDone': justDone,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PepiteChallengeStateImpl extends PepiteChallengeState {
  _PepiteChallengeStateImpl({
    required String month,
    required String code,
    required int target,
    required int progress,
    required bool done,
    required bool justDone,
  }) : super._(
         month: month,
         code: code,
         target: target,
         progress: progress,
         done: done,
         justDone: justDone,
       );

  /// Returns a shallow copy of this [PepiteChallengeState]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteChallengeState copyWith({
    String? month,
    String? code,
    int? target,
    int? progress,
    bool? done,
    bool? justDone,
  }) {
    return PepiteChallengeState(
      month: month ?? this.month,
      code: code ?? this.code,
      target: target ?? this.target,
      progress: progress ?? this.progress,
      done: done ?? this.done,
      justDone: justDone ?? this.justDone,
    );
  }
}
