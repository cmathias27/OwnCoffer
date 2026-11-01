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

/// A change proposed by the advisor (the engine, later an AI), applied
/// only once the user accepts it, by the financial commands service
/// (décision 0009). Never a real bank operation.
abstract class ActionProposal
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ActionProposal._({
    this.id,
    required this.groupId,
    required this.authUserId,
    required this.origin,
    this.provider,
    this.model,
    required this.kind,
    required this.targetId,
    this.currentValue,
    this.proposedValue,
    this.proposedData,
    required this.reason,
    required this.data,
    required this.dataVersion,
    required this.status,
    required this.dedupKey,
    DateTime? createdAt,
    this.decidedAt,
    this.decidedBy,
    this.executedAt,
    this.resultId,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ActionProposal({
    int? id,
    required int groupId,
    required _isc.UuidValue authUserId,
    required String origin,
    String? provider,
    String? model,
    required String kind,
    required int targetId,
    int? currentValue,
    int? proposedValue,
    String? proposedData,
    required String reason,
    required String data,
    required String dataVersion,
    required String status,
    required String dedupKey,
    DateTime? createdAt,
    DateTime? decidedAt,
    _isc.UuidValue? decidedBy,
    DateTime? executedAt,
    int? resultId,
  }) = _ActionProposalImpl;

  factory ActionProposal.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionProposal(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      origin: jsonSerialization['origin'] as String,
      provider: jsonSerialization['provider'] as String?,
      model: jsonSerialization['model'] as String?,
      kind: jsonSerialization['kind'] as String,
      targetId: jsonSerialization['targetId'] as int,
      currentValue: jsonSerialization['currentValue'] as int?,
      proposedValue: jsonSerialization['proposedValue'] as int?,
      proposedData: jsonSerialization['proposedData'] as String?,
      reason: jsonSerialization['reason'] as String,
      data: jsonSerialization['data'] as String,
      dataVersion: jsonSerialization['dataVersion'] as String,
      status: jsonSerialization['status'] as String,
      dedupKey: jsonSerialization['dedupKey'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      decidedAt: jsonSerialization['decidedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['decidedAt']),
      decidedBy: jsonSerialization['decidedBy'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['decidedBy'],
            ),
      executedAt: jsonSerialization['executedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['executedAt'],
            ),
      resultId: jsonSerialization['resultId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  /// Made for this user, from the accounts they may see: nobody else sees
  /// it (its figures may come from a restricted account).
  _isc.UuidValue authUserId;

  /// engine or ai, and for an AI its provider and model.
  String origin;

  String? provider;

  String? model;

  /// set_goal (target: category, value: amount in cents, null = no goal),
  /// set_category (target: operation, value: category id) or create_loan
  /// (target: the group, fields in proposedData).
  String kind;

  int targetId;

  int? currentValue;

  int? proposedValue;

  /// Fields of a change that is more than one value (create_loan: the
  /// loan as JSON, as the loan form fills it).
  String? proposedData;

  /// Why, as a code the app turns into a sentence (raise_goal…), and the
  /// figures behind it as JSON.
  String reason;

  String data;

  /// The data it rests on; a proposal whose data changed is not applied.
  String dataVersion;

  /// pending, executed, refused, expired, undone.
  String status;

  /// One open proposal per change: the advisor does not repeat itself.
  String dedupKey;

  DateTime createdAt;

  DateTime? decidedAt;

  _isc.UuidValue? decidedBy;

  DateTime? executedAt;

  /// What the change created (create_loan: the loan), to undo it.
  int? resultId;

  /// Returns a shallow copy of this [ActionProposal]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ActionProposal copyWith({
    int? id,
    int? groupId,
    _isc.UuidValue? authUserId,
    String? origin,
    String? provider,
    String? model,
    String? kind,
    int? targetId,
    int? currentValue,
    int? proposedValue,
    String? proposedData,
    String? reason,
    String? data,
    String? dataVersion,
    String? status,
    String? dedupKey,
    DateTime? createdAt,
    DateTime? decidedAt,
    _isc.UuidValue? decidedBy,
    DateTime? executedAt,
    int? resultId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActionProposal',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'origin': origin,
      if (provider != null) 'provider': provider,
      if (model != null) 'model': model,
      'kind': kind,
      'targetId': targetId,
      if (currentValue != null) 'currentValue': currentValue,
      if (proposedValue != null) 'proposedValue': proposedValue,
      if (proposedData != null) 'proposedData': proposedData,
      'reason': reason,
      'data': data,
      'dataVersion': dataVersion,
      'status': status,
      'dedupKey': dedupKey,
      'createdAt': createdAt.toJson(),
      if (decidedAt != null) 'decidedAt': decidedAt?.toJson(),
      if (decidedBy != null) 'decidedBy': decidedBy?.toJson(),
      if (executedAt != null) 'executedAt': executedAt?.toJson(),
      if (resultId != null) 'resultId': resultId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActionProposal',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'origin': origin,
      if (provider != null) 'provider': provider,
      if (model != null) 'model': model,
      'kind': kind,
      'targetId': targetId,
      if (currentValue != null) 'currentValue': currentValue,
      if (proposedValue != null) 'proposedValue': proposedValue,
      if (proposedData != null) 'proposedData': proposedData,
      'reason': reason,
      'data': data,
      'dataVersion': dataVersion,
      'status': status,
      'dedupKey': dedupKey,
      'createdAt': createdAt.toJson(),
      if (decidedAt != null) 'decidedAt': decidedAt?.toJson(),
      if (decidedBy != null) 'decidedBy': decidedBy?.toJson(),
      if (executedAt != null) 'executedAt': executedAt?.toJson(),
      if (resultId != null) 'resultId': resultId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionProposalImpl extends ActionProposal {
  _ActionProposalImpl({
    int? id,
    required int groupId,
    required _isc.UuidValue authUserId,
    required String origin,
    String? provider,
    String? model,
    required String kind,
    required int targetId,
    int? currentValue,
    int? proposedValue,
    String? proposedData,
    required String reason,
    required String data,
    required String dataVersion,
    required String status,
    required String dedupKey,
    DateTime? createdAt,
    DateTime? decidedAt,
    _isc.UuidValue? decidedBy,
    DateTime? executedAt,
    int? resultId,
  }) : super._(
         id: id,
         groupId: groupId,
         authUserId: authUserId,
         origin: origin,
         provider: provider,
         model: model,
         kind: kind,
         targetId: targetId,
         currentValue: currentValue,
         proposedValue: proposedValue,
         proposedData: proposedData,
         reason: reason,
         data: data,
         dataVersion: dataVersion,
         status: status,
         dedupKey: dedupKey,
         createdAt: createdAt,
         decidedAt: decidedAt,
         decidedBy: decidedBy,
         executedAt: executedAt,
         resultId: resultId,
       );

  /// Returns a shallow copy of this [ActionProposal]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ActionProposal copyWith({
    Object? id = _Undefined,
    int? groupId,
    _isc.UuidValue? authUserId,
    String? origin,
    Object? provider = _Undefined,
    Object? model = _Undefined,
    String? kind,
    int? targetId,
    Object? currentValue = _Undefined,
    Object? proposedValue = _Undefined,
    Object? proposedData = _Undefined,
    String? reason,
    String? data,
    String? dataVersion,
    String? status,
    String? dedupKey,
    DateTime? createdAt,
    Object? decidedAt = _Undefined,
    Object? decidedBy = _Undefined,
    Object? executedAt = _Undefined,
    Object? resultId = _Undefined,
  }) {
    return ActionProposal(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      authUserId: authUserId ?? this.authUserId,
      origin: origin ?? this.origin,
      provider: provider is String? ? provider : this.provider,
      model: model is String? ? model : this.model,
      kind: kind ?? this.kind,
      targetId: targetId ?? this.targetId,
      currentValue: currentValue is int? ? currentValue : this.currentValue,
      proposedValue: proposedValue is int? ? proposedValue : this.proposedValue,
      proposedData: proposedData is String? ? proposedData : this.proposedData,
      reason: reason ?? this.reason,
      data: data ?? this.data,
      dataVersion: dataVersion ?? this.dataVersion,
      status: status ?? this.status,
      dedupKey: dedupKey ?? this.dedupKey,
      createdAt: createdAt ?? this.createdAt,
      decidedAt: decidedAt is DateTime? ? decidedAt : this.decidedAt,
      decidedBy: decidedBy is _isc.UuidValue? ? decidedBy : this.decidedBy,
      executedAt: executedAt is DateTime? ? executedAt : this.executedAt,
      resultId: resultId is int? ? resultId : this.resultId,
    );
  }
}
