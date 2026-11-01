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

/// A change proposed by the advisor (the engine, later an AI), applied
/// only once the user accepts it, by the financial commands service
/// (décision 0009). Never a real bank operation.
abstract class ActionProposal
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue authUserId,
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
    _is.UuidValue? decidedBy,
    DateTime? executedAt,
    int? resultId,
  }) = _ActionProposalImpl;

  factory ActionProposal.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActionProposal(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      authUserId: _is.UuidValueJsonExtension.fromJson(
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
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      decidedAt: jsonSerialization['decidedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['decidedAt']),
      decidedBy: jsonSerialization['decidedBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['decidedBy']),
      executedAt: jsonSerialization['executedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['executedAt']),
      resultId: jsonSerialization['resultId'] as int?,
    );
  }

  static final t = ActionProposalTable();

  static const db = ActionProposalRepository._();

  @override
  int? id;

  int groupId;

  /// Made for this user, from the accounts they may see: nobody else sees
  /// it (its figures may come from a restricted account).
  _is.UuidValue authUserId;

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

  _is.UuidValue? decidedBy;

  DateTime? executedAt;

  /// What the change created (create_loan: the loan), to undo it.
  int? resultId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ActionProposal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ActionProposal copyWith({
    int? id,
    int? groupId,
    _is.UuidValue? authUserId,
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
    _is.UuidValue? decidedBy,
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

  static ActionProposalInclude include() {
    return ActionProposalInclude._();
  }

  static ActionProposalIncludeList includeList({
    _is.WhereExpressionBuilder<ActionProposalTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActionProposalTable>? orderBy,
    _is.OrderByListBuilder<ActionProposalTable>? orderByList,
    ActionProposalInclude? include,
  }) {
    return ActionProposalIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionProposal.t),
      orderByList: orderByList?.call(ActionProposal.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActionProposalImpl extends ActionProposal {
  _ActionProposalImpl({
    int? id,
    required int groupId,
    required _is.UuidValue authUserId,
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
    _is.UuidValue? decidedBy,
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
  @_is.useResult
  @override
  ActionProposal copyWith({
    Object? id = _Undefined,
    int? groupId,
    _is.UuidValue? authUserId,
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
      decidedBy: decidedBy is _is.UuidValue? ? decidedBy : this.decidedBy,
      executedAt: executedAt is DateTime? ? executedAt : this.executedAt,
      resultId: resultId is int? ? resultId : this.resultId,
    );
  }
}

class ActionProposalUpdateTable extends _is.UpdateTable<ActionProposalTable> {
  ActionProposalUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> origin(String value) => _is.ColumnValue(
    table.origin,
    value,
  );

  _is.ColumnValue<String, String> provider(String? value) => _is.ColumnValue(
    table.provider,
    value,
  );

  _is.ColumnValue<String, String> model(String? value) => _is.ColumnValue(
    table.model,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<int, int> targetId(int value) => _is.ColumnValue(
    table.targetId,
    value,
  );

  _is.ColumnValue<int, int> currentValue(int? value) => _is.ColumnValue(
    table.currentValue,
    value,
  );

  _is.ColumnValue<int, int> proposedValue(int? value) => _is.ColumnValue(
    table.proposedValue,
    value,
  );

  _is.ColumnValue<String, String> proposedData(String? value) =>
      _is.ColumnValue(
        table.proposedData,
        value,
      );

  _is.ColumnValue<String, String> reason(String value) => _is.ColumnValue(
    table.reason,
    value,
  );

  _is.ColumnValue<String, String> data(String value) => _is.ColumnValue(
    table.data,
    value,
  );

  _is.ColumnValue<String, String> dataVersion(String value) => _is.ColumnValue(
    table.dataVersion,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> dedupKey(String value) => _is.ColumnValue(
    table.dedupKey,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> decidedAt(DateTime? value) =>
      _is.ColumnValue(
        table.decidedAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> decidedBy(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.decidedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> executedAt(DateTime? value) =>
      _is.ColumnValue(
        table.executedAt,
        value,
      );

  _is.ColumnValue<int, int> resultId(int? value) => _is.ColumnValue(
    table.resultId,
    value,
  );
}

class ActionProposalTable extends _is.Table<int?> {
  ActionProposalTable({super.tableRelation})
    : super(tableName: 'action_proposals') {
    updateTable = ActionProposalUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    origin = _is.ColumnString(
      'origin',
      this,
    );
    provider = _is.ColumnString(
      'provider',
      this,
    );
    model = _is.ColumnString(
      'model',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    targetId = _is.ColumnInt(
      'targetId',
      this,
    );
    currentValue = _is.ColumnInt(
      'currentValue',
      this,
    );
    proposedValue = _is.ColumnInt(
      'proposedValue',
      this,
    );
    proposedData = _is.ColumnString(
      'proposedData',
      this,
    );
    reason = _is.ColumnString(
      'reason',
      this,
    );
    data = _is.ColumnString(
      'data',
      this,
    );
    dataVersion = _is.ColumnString(
      'dataVersion',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    dedupKey = _is.ColumnString(
      'dedupKey',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    decidedAt = _is.ColumnDateTime(
      'decidedAt',
      this,
    );
    decidedBy = _is.ColumnUuid(
      'decidedBy',
      this,
    );
    executedAt = _is.ColumnDateTime(
      'executedAt',
      this,
    );
    resultId = _is.ColumnInt(
      'resultId',
      this,
    );
  }

  late final ActionProposalUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  /// Made for this user, from the accounts they may see: nobody else sees
  /// it (its figures may come from a restricted account).
  late final _is.ColumnUuid authUserId;

  /// engine or ai, and for an AI its provider and model.
  late final _is.ColumnString origin;

  late final _is.ColumnString provider;

  late final _is.ColumnString model;

  /// set_goal (target: category, value: amount in cents, null = no goal),
  /// set_category (target: operation, value: category id) or create_loan
  /// (target: the group, fields in proposedData).
  late final _is.ColumnString kind;

  late final _is.ColumnInt targetId;

  late final _is.ColumnInt currentValue;

  late final _is.ColumnInt proposedValue;

  /// Fields of a change that is more than one value (create_loan: the
  /// loan as JSON, as the loan form fills it).
  late final _is.ColumnString proposedData;

  /// Why, as a code the app turns into a sentence (raise_goal…), and the
  /// figures behind it as JSON.
  late final _is.ColumnString reason;

  late final _is.ColumnString data;

  /// The data it rests on; a proposal whose data changed is not applied.
  late final _is.ColumnString dataVersion;

  /// pending, executed, refused, expired, undone.
  late final _is.ColumnString status;

  /// One open proposal per change: the advisor does not repeat itself.
  late final _is.ColumnString dedupKey;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime decidedAt;

  late final _is.ColumnUuid decidedBy;

  late final _is.ColumnDateTime executedAt;

  /// What the change created (create_loan: the loan), to undo it.
  late final _is.ColumnInt resultId;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    authUserId,
    origin,
    provider,
    model,
    kind,
    targetId,
    currentValue,
    proposedValue,
    proposedData,
    reason,
    data,
    dataVersion,
    status,
    dedupKey,
    createdAt,
    decidedAt,
    decidedBy,
    executedAt,
    resultId,
  ];
}

class ActionProposalInclude extends _is.IncludeObject {
  ActionProposalInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ActionProposal.t;
}

class ActionProposalIncludeList extends _is.IncludeList {
  ActionProposalIncludeList._({
    _is.WhereExpressionBuilder<ActionProposalTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActionProposal.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ActionProposal.t;
}

class ActionProposalRepository {
  const ActionProposalRepository._();

  /// Returns a list of [ActionProposal]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ActionProposal>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActionProposalTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActionProposalTable>? orderBy,
    _is.OrderByListBuilder<ActionProposalTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ActionProposal>(
      where: where?.call(ActionProposal.t),
      orderBy: orderBy?.call(ActionProposal.t),
      orderByList: orderByList?.call(ActionProposal.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ActionProposal] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ActionProposal?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActionProposalTable>? where,
    int? offset,
    _is.OrderByBuilder<ActionProposalTable>? orderBy,
    _is.OrderByListBuilder<ActionProposalTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ActionProposal>(
      where: where?.call(ActionProposal.t),
      orderBy: orderBy?.call(ActionProposal.t),
      orderByList: orderByList?.call(ActionProposal.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ActionProposal] by its [id] or null if no such row exists.
  Future<ActionProposal?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ActionProposal>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ActionProposal]s in the list and returns the inserted rows.
  ///
  /// The returned [ActionProposal]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActionProposal>> insert(
    _is.DatabaseSession session,
    List<ActionProposal> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ActionProposal>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ActionProposal] and returns the inserted row.
  ///
  /// The returned [ActionProposal] will have its `id` field set.
  Future<ActionProposal> insertRow(
    _is.DatabaseSession session,
    ActionProposal row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActionProposal>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ActionProposal]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ActionProposal]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActionProposal>> upsert(
    _is.DatabaseSession session,
    List<ActionProposal> rows, {
    required _is.ColumnSelections<ActionProposalTable> conflictColumns,
    _is.ColumnSelections<ActionProposalTable>? updateColumns,
    _is.WhereExpressionBuilder<ActionProposalTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ActionProposal>(
      rows,
      conflictColumns: conflictColumns(ActionProposal.t),
      updateColumns: updateColumns?.call(ActionProposal.t),
      updateWhere: updateWhere?.call(ActionProposal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ActionProposal] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ActionProposal] will have its `id` field set.
  Future<ActionProposal?> upsertRow(
    _is.DatabaseSession session,
    ActionProposal row, {
    required _is.ColumnSelections<ActionProposalTable> conflictColumns,
    _is.ColumnSelections<ActionProposalTable>? updateColumns,
    _is.WhereExpressionBuilder<ActionProposalTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ActionProposal>(
      row,
      conflictColumns: conflictColumns(ActionProposal.t),
      updateColumns: updateColumns?.call(ActionProposal.t),
      updateWhere: updateWhere?.call(ActionProposal.t),
      transaction: transaction,
    );
  }

  /// Updates all [ActionProposal]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActionProposal>> update(
    _is.DatabaseSession session,
    List<ActionProposal> rows, {
    _is.ColumnSelections<ActionProposalTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ActionProposal>(
      rows,
      columns: columns?.call(ActionProposal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ActionProposal]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActionProposal> updateRow(
    _is.DatabaseSession session,
    ActionProposal row, {
    _is.ColumnSelections<ActionProposalTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActionProposal>(
      row,
      columns: columns?.call(ActionProposal.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActionProposal] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ActionProposal?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ActionProposalUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ActionProposal>(
      id,
      columnValues: columnValues(ActionProposal.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ActionProposal]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActionProposal>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ActionProposalUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ActionProposalTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActionProposalTable>? orderBy,
    _is.OrderByListBuilder<ActionProposalTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ActionProposal>(
      columnValues: columnValues(ActionProposal.t.updateTable),
      where: where(ActionProposal.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActionProposal.t),
      orderByList: orderByList?.call(ActionProposal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ActionProposal]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActionProposal>> delete(
    _is.DatabaseSession session,
    List<ActionProposal> rows, {
    _is.OrderByBuilder<ActionProposalTable>? orderBy,
    _is.OrderByListBuilder<ActionProposalTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ActionProposal>(
      rows,
      orderBy: orderBy?.call(ActionProposal.t),
      orderByList: orderByList?.call(ActionProposal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ActionProposal].
  Future<ActionProposal> deleteRow(
    _is.DatabaseSession session,
    ActionProposal row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActionProposal>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActionProposal>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ActionProposalTable> where,
    _is.OrderByBuilder<ActionProposalTable>? orderBy,
    _is.OrderByListBuilder<ActionProposalTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ActionProposal>(
      where: where(ActionProposal.t),
      orderBy: orderBy?.call(ActionProposal.t),
      orderByList: orderByList?.call(ActionProposal.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActionProposalTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ActionProposal>(
      where: where?.call(ActionProposal.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ActionProposal] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ActionProposalTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ActionProposal>(
      where: where(ActionProposal.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
