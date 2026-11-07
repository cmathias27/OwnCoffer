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

/// « Bien démarrer » (decision 0028, point 12): the setup steps that apply
/// and those done, checked from the data. The steps only the device knows
/// (fingerprint or Windows Hello, the ritual reminder, the device's backup)
/// are added by the app.
abstract class PepiteStart
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PepiteStart._({
    required this.steps,
    required this.done,
    required this.adminSteps,
    required this.adminDone,
  });

  factory PepiteStart({
    required List<String> steps,
    required List<String> done,
    required List<String> adminSteps,
    required List<String> adminDone,
  }) = _PepiteStartImpl;

  factory PepiteStart.fromJson(Map<String, dynamic> jsonSerialization) {
    return PepiteStart(
      steps: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['steps'],
      ),
      done: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['done'],
      ),
      adminSteps: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['adminSteps'],
      ),
      adminDone: _itdod8fx.Protocol().deserialize<List<String>>(
        jsonSerialization['adminDone'],
      ),
    );
  }

  /// In order: account, rules, scheduled, goal, two_factor, app, members.
  List<String> steps;

  List<String> done;

  /// For the server's administrator only (empty otherwise): backups,
  /// restore_test, auto_update, invitations, ai, proxy.
  List<String> adminSteps;

  List<String> adminDone;

  /// Returns a shallow copy of this [PepiteStart]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PepiteStart copyWith({
    List<String>? steps,
    List<String>? done,
    List<String>? adminSteps,
    List<String>? adminDone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PepiteStart',
      'steps': steps.toJson(),
      'done': done.toJson(),
      'adminSteps': adminSteps.toJson(),
      'adminDone': adminDone.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PepiteStart',
      'steps': steps.toJson(),
      'done': done.toJson(),
      'adminSteps': adminSteps.toJson(),
      'adminDone': adminDone.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PepiteStartImpl extends PepiteStart {
  _PepiteStartImpl({
    required List<String> steps,
    required List<String> done,
    required List<String> adminSteps,
    required List<String> adminDone,
  }) : super._(
         steps: steps,
         done: done,
         adminSteps: adminSteps,
         adminDone: adminDone,
       );

  /// Returns a shallow copy of this [PepiteStart]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PepiteStart copyWith({
    List<String>? steps,
    List<String>? done,
    List<String>? adminSteps,
    List<String>? adminDone,
  }) {
    return PepiteStart(
      steps: steps ?? this.steps.map((e0) => e0).toList(),
      done: done ?? this.done.map((e0) => e0).toList(),
      adminSteps: adminSteps ?? this.adminSteps.map((e0) => e0).toList(),
      adminDone: adminDone ?? this.adminDone.map((e0) => e0).toList(),
    );
  }
}
