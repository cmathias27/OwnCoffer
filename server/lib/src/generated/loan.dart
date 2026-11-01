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
import 'loan_event.dart' as _inh9sy0f;
import 'loan_kind.dart' as _i1700pxx;

/// A loan with monthly instalments: fixed rate, or changed by its events
/// (variable rate, renegotiation, revolving credit). The schedule is
/// computed (shared/loans), never stored; indicative, the bank's table
/// prevails.
abstract class Loan implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Loan._({
    this.id,
    required this.groupId,
    this.accountId,
    required this.kind,
    required this.lender,
    this.label,
    required this.principalCents,
    required this.annualRateMilli,
    this.aprMilli,
    required this.durationMonths,
    this.paymentCents,
    required this.firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    this.categoryId,
    this.scheduledId,
    this.matchPattern,
    this.ruleId,
    this.creditLimitCents,
    this.events,
    DateTime? createdAt,
    this.deletedAt,
  }) : insuranceMonthlyCents = insuranceMonthlyCents ?? 0,
       feesCents = feesCents ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory Loan({
    int? id,
    required int groupId,
    int? accountId,
    required _i1700pxx.LoanKind kind,
    required String lender,
    String? label,
    required int principalCents,
    required int annualRateMilli,
    int? aprMilli,
    required int durationMonths,
    int? paymentCents,
    required DateTime firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    int? categoryId,
    int? scheduledId,
    String? matchPattern,
    int? ruleId,
    int? creditLimitCents,
    List<_inh9sy0f.LoanEvent>? events,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) = _LoanImpl;

  factory Loan.fromJson(Map<String, dynamic> jsonSerialization) {
    return Loan(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      accountId: jsonSerialization['accountId'] as int?,
      kind: _i1700pxx.LoanKind.fromJson((jsonSerialization['kind'] as String)),
      lender: jsonSerialization['lender'] as String,
      label: jsonSerialization['label'] as String?,
      principalCents: jsonSerialization['principalCents'] as int,
      annualRateMilli: jsonSerialization['annualRateMilli'] as int,
      aprMilli: jsonSerialization['aprMilli'] as int?,
      durationMonths: jsonSerialization['durationMonths'] as int,
      paymentCents: jsonSerialization['paymentCents'] as int?,
      firstDueDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstDueDate'],
      ),
      insuranceMonthlyCents: jsonSerialization['insuranceMonthlyCents'] as int?,
      feesCents: jsonSerialization['feesCents'] as int?,
      categoryId: jsonSerialization['categoryId'] as int?,
      scheduledId: jsonSerialization['scheduledId'] as int?,
      matchPattern: jsonSerialization['matchPattern'] as String?,
      ruleId: jsonSerialization['ruleId'] as int?,
      creditLimitCents: jsonSerialization['creditLimitCents'] as int?,
      events: jsonSerialization['events'] == null
          ? null
          : _itdod8fx.Protocol().deserialize<List<_inh9sy0f.LoanEvent>>(
              jsonSerialization['events'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = LoanTable();

  static const db = LoanRepository._();

  @override
  int? id;

  int groupId;

  /// Account debited; restricted accounts hide the loan from other members.
  int? accountId;

  _i1700pxx.LoanKind kind;

  /// Bank or organisation.
  String lender;

  /// What it pays for ("Maison", "Voiture").
  String? label;

  int principalCents;

  /// Nominal annual rate in thousandths of a percent: 3.45 % = 3450.
  int annualRateMilli;

  /// APR (TAEG), for information.
  int? aprMilli;

  int durationMonths;

  /// Instalment actually debited, insurance excluded (the only certain
  /// figure): the schedule follows it, the rest is estimated.
  int? paymentCents;

  DateTime firstDueDate;

  int insuranceMonthlyCents;

  int feesCents;

  int? categoryId;

  /// Planned operation of the instalments, when an account is chosen.
  int? scheduledId;

  /// Bank label (normalised) of the instalments, when the loan was declared
  /// from one of its debits; otherwise the lender's name is used.
  String? matchPattern;

  /// Group rule classifying the instalments, created with the loan when it
  /// is declared from an operation.
  int? ruleId;

  /// Revolving credit: the amount that may be drawn in all.
  int? creditLimitCents;

  /// Changes since the start (rate, instalment, duration, money drawn or
  /// repaid), oldest first.
  List<_inh9sy0f.LoanEvent>? events;

  DateTime createdAt;

  DateTime? deletedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Loan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Loan copyWith({
    int? id,
    int? groupId,
    int? accountId,
    _i1700pxx.LoanKind? kind,
    String? lender,
    String? label,
    int? principalCents,
    int? annualRateMilli,
    int? aprMilli,
    int? durationMonths,
    int? paymentCents,
    DateTime? firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    int? categoryId,
    int? scheduledId,
    String? matchPattern,
    int? ruleId,
    int? creditLimitCents,
    List<_inh9sy0f.LoanEvent>? events,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Loan',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (accountId != null) 'accountId': accountId,
      'kind': kind.toJson(),
      'lender': lender,
      if (label != null) 'label': label,
      'principalCents': principalCents,
      'annualRateMilli': annualRateMilli,
      if (aprMilli != null) 'aprMilli': aprMilli,
      'durationMonths': durationMonths,
      if (paymentCents != null) 'paymentCents': paymentCents,
      'firstDueDate': firstDueDate.toJson(),
      'insuranceMonthlyCents': insuranceMonthlyCents,
      'feesCents': feesCents,
      if (categoryId != null) 'categoryId': categoryId,
      if (scheduledId != null) 'scheduledId': scheduledId,
      if (matchPattern != null) 'matchPattern': matchPattern,
      if (ruleId != null) 'ruleId': ruleId,
      if (creditLimitCents != null) 'creditLimitCents': creditLimitCents,
      if (events != null)
        'events': events?.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Loan',
      if (id != null) 'id': id,
      'groupId': groupId,
      if (accountId != null) 'accountId': accountId,
      'kind': kind.toJson(),
      'lender': lender,
      if (label != null) 'label': label,
      'principalCents': principalCents,
      'annualRateMilli': annualRateMilli,
      if (aprMilli != null) 'aprMilli': aprMilli,
      'durationMonths': durationMonths,
      if (paymentCents != null) 'paymentCents': paymentCents,
      'firstDueDate': firstDueDate.toJson(),
      'insuranceMonthlyCents': insuranceMonthlyCents,
      'feesCents': feesCents,
      if (categoryId != null) 'categoryId': categoryId,
      if (scheduledId != null) 'scheduledId': scheduledId,
      if (matchPattern != null) 'matchPattern': matchPattern,
      if (ruleId != null) 'ruleId': ruleId,
      if (creditLimitCents != null) 'creditLimitCents': creditLimitCents,
      if (events != null)
        'events': events?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static LoanInclude include() {
    return LoanInclude._();
  }

  static LoanIncludeList includeList({
    _is.WhereExpressionBuilder<LoanTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanTable>? orderBy,
    _is.OrderByListBuilder<LoanTable>? orderByList,
    LoanInclude? include,
  }) {
    return LoanIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Loan.t),
      orderByList: orderByList?.call(Loan.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LoanImpl extends Loan {
  _LoanImpl({
    int? id,
    required int groupId,
    int? accountId,
    required _i1700pxx.LoanKind kind,
    required String lender,
    String? label,
    required int principalCents,
    required int annualRateMilli,
    int? aprMilli,
    required int durationMonths,
    int? paymentCents,
    required DateTime firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    int? categoryId,
    int? scheduledId,
    String? matchPattern,
    int? ruleId,
    int? creditLimitCents,
    List<_inh9sy0f.LoanEvent>? events,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         accountId: accountId,
         kind: kind,
         lender: lender,
         label: label,
         principalCents: principalCents,
         annualRateMilli: annualRateMilli,
         aprMilli: aprMilli,
         durationMonths: durationMonths,
         paymentCents: paymentCents,
         firstDueDate: firstDueDate,
         insuranceMonthlyCents: insuranceMonthlyCents,
         feesCents: feesCents,
         categoryId: categoryId,
         scheduledId: scheduledId,
         matchPattern: matchPattern,
         ruleId: ruleId,
         creditLimitCents: creditLimitCents,
         events: events,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Loan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Loan copyWith({
    Object? id = _Undefined,
    int? groupId,
    Object? accountId = _Undefined,
    _i1700pxx.LoanKind? kind,
    String? lender,
    Object? label = _Undefined,
    int? principalCents,
    int? annualRateMilli,
    Object? aprMilli = _Undefined,
    int? durationMonths,
    Object? paymentCents = _Undefined,
    DateTime? firstDueDate,
    int? insuranceMonthlyCents,
    int? feesCents,
    Object? categoryId = _Undefined,
    Object? scheduledId = _Undefined,
    Object? matchPattern = _Undefined,
    Object? ruleId = _Undefined,
    Object? creditLimitCents = _Undefined,
    Object? events = _Undefined,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return Loan(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      accountId: accountId is int? ? accountId : this.accountId,
      kind: kind ?? this.kind,
      lender: lender ?? this.lender,
      label: label is String? ? label : this.label,
      principalCents: principalCents ?? this.principalCents,
      annualRateMilli: annualRateMilli ?? this.annualRateMilli,
      aprMilli: aprMilli is int? ? aprMilli : this.aprMilli,
      durationMonths: durationMonths ?? this.durationMonths,
      paymentCents: paymentCents is int? ? paymentCents : this.paymentCents,
      firstDueDate: firstDueDate ?? this.firstDueDate,
      insuranceMonthlyCents:
          insuranceMonthlyCents ?? this.insuranceMonthlyCents,
      feesCents: feesCents ?? this.feesCents,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      scheduledId: scheduledId is int? ? scheduledId : this.scheduledId,
      matchPattern: matchPattern is String? ? matchPattern : this.matchPattern,
      ruleId: ruleId is int? ? ruleId : this.ruleId,
      creditLimitCents: creditLimitCents is int?
          ? creditLimitCents
          : this.creditLimitCents,
      events: events is List<_inh9sy0f.LoanEvent>?
          ? events
          : this.events?.map((e0) => e0.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class LoanUpdateTable extends _is.UpdateTable<LoanTable> {
  LoanUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<int, int> accountId(int? value) => _is.ColumnValue(
    table.accountId,
    value,
  );

  _is.ColumnValue<_i1700pxx.LoanKind, _i1700pxx.LoanKind> kind(
    _i1700pxx.LoanKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> lender(String value) => _is.ColumnValue(
    table.lender,
    value,
  );

  _is.ColumnValue<String, String> label(String? value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<int, int> principalCents(int value) => _is.ColumnValue(
    table.principalCents,
    value,
  );

  _is.ColumnValue<int, int> annualRateMilli(int value) => _is.ColumnValue(
    table.annualRateMilli,
    value,
  );

  _is.ColumnValue<int, int> aprMilli(int? value) => _is.ColumnValue(
    table.aprMilli,
    value,
  );

  _is.ColumnValue<int, int> durationMonths(int value) => _is.ColumnValue(
    table.durationMonths,
    value,
  );

  _is.ColumnValue<int, int> paymentCents(int? value) => _is.ColumnValue(
    table.paymentCents,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> firstDueDate(DateTime value) =>
      _is.ColumnValue(
        table.firstDueDate,
        value,
      );

  _is.ColumnValue<int, int> insuranceMonthlyCents(int value) => _is.ColumnValue(
    table.insuranceMonthlyCents,
    value,
  );

  _is.ColumnValue<int, int> feesCents(int value) => _is.ColumnValue(
    table.feesCents,
    value,
  );

  _is.ColumnValue<int, int> categoryId(int? value) => _is.ColumnValue(
    table.categoryId,
    value,
  );

  _is.ColumnValue<int, int> scheduledId(int? value) => _is.ColumnValue(
    table.scheduledId,
    value,
  );

  _is.ColumnValue<String, String> matchPattern(String? value) =>
      _is.ColumnValue(
        table.matchPattern,
        value,
      );

  _is.ColumnValue<int, int> ruleId(int? value) => _is.ColumnValue(
    table.ruleId,
    value,
  );

  _is.ColumnValue<int, int> creditLimitCents(int? value) => _is.ColumnValue(
    table.creditLimitCents,
    value,
  );

  _is.ColumnValue<List<_inh9sy0f.LoanEvent>, List<_inh9sy0f.LoanEvent>> events(
    List<_inh9sy0f.LoanEvent>? value,
  ) => _is.ColumnValue(
    table.events,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _is.ColumnValue(
        table.deletedAt,
        value,
      );
}

class LoanTable extends _is.Table<int?> {
  LoanTable({super.tableRelation}) : super(tableName: 'loans') {
    updateTable = LoanUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    accountId = _is.ColumnInt(
      'accountId',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    lender = _is.ColumnString(
      'lender',
      this,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    principalCents = _is.ColumnInt(
      'principalCents',
      this,
    );
    annualRateMilli = _is.ColumnInt(
      'annualRateMilli',
      this,
    );
    aprMilli = _is.ColumnInt(
      'aprMilli',
      this,
    );
    durationMonths = _is.ColumnInt(
      'durationMonths',
      this,
    );
    paymentCents = _is.ColumnInt(
      'paymentCents',
      this,
    );
    firstDueDate = _is.ColumnDateTime(
      'firstDueDate',
      this,
    );
    insuranceMonthlyCents = _is.ColumnInt(
      'insuranceMonthlyCents',
      this,
      hasDefault: true,
    );
    feesCents = _is.ColumnInt(
      'feesCents',
      this,
      hasDefault: true,
    );
    categoryId = _is.ColumnInt(
      'categoryId',
      this,
    );
    scheduledId = _is.ColumnInt(
      'scheduledId',
      this,
    );
    matchPattern = _is.ColumnString(
      'matchPattern',
      this,
    );
    ruleId = _is.ColumnInt(
      'ruleId',
      this,
    );
    creditLimitCents = _is.ColumnInt(
      'creditLimitCents',
      this,
    );
    events = _is.ColumnSerializable<List<_inh9sy0f.LoanEvent>>(
      'events',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    deletedAt = _is.ColumnDateTime(
      'deletedAt',
      this,
    );
  }

  late final LoanUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  /// Account debited; restricted accounts hide the loan from other members.
  late final _is.ColumnInt accountId;

  late final _is.ColumnEnum<_i1700pxx.LoanKind> kind;

  /// Bank or organisation.
  late final _is.ColumnString lender;

  /// What it pays for ("Maison", "Voiture").
  late final _is.ColumnString label;

  late final _is.ColumnInt principalCents;

  /// Nominal annual rate in thousandths of a percent: 3.45 % = 3450.
  late final _is.ColumnInt annualRateMilli;

  /// APR (TAEG), for information.
  late final _is.ColumnInt aprMilli;

  late final _is.ColumnInt durationMonths;

  /// Instalment actually debited, insurance excluded (the only certain
  /// figure): the schedule follows it, the rest is estimated.
  late final _is.ColumnInt paymentCents;

  late final _is.ColumnDateTime firstDueDate;

  late final _is.ColumnInt insuranceMonthlyCents;

  late final _is.ColumnInt feesCents;

  late final _is.ColumnInt categoryId;

  /// Planned operation of the instalments, when an account is chosen.
  late final _is.ColumnInt scheduledId;

  /// Bank label (normalised) of the instalments, when the loan was declared
  /// from one of its debits; otherwise the lender's name is used.
  late final _is.ColumnString matchPattern;

  /// Group rule classifying the instalments, created with the loan when it
  /// is declared from an operation.
  late final _is.ColumnInt ruleId;

  /// Revolving credit: the amount that may be drawn in all.
  late final _is.ColumnInt creditLimitCents;

  /// Changes since the start (rate, instalment, duration, money drawn or
  /// repaid), oldest first.
  late final _is.ColumnSerializable<List<_inh9sy0f.LoanEvent>> events;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime deletedAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    accountId,
    kind,
    lender,
    label,
    principalCents,
    annualRateMilli,
    aprMilli,
    durationMonths,
    paymentCents,
    firstDueDate,
    insuranceMonthlyCents,
    feesCents,
    categoryId,
    scheduledId,
    matchPattern,
    ruleId,
    creditLimitCents,
    events,
    createdAt,
    deletedAt,
  ];
}

class LoanInclude extends _is.IncludeObject {
  LoanInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Loan.t;
}

class LoanIncludeList extends _is.IncludeList {
  LoanIncludeList._({
    _is.WhereExpressionBuilder<LoanTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Loan.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Loan.t;
}

class LoanRepository {
  const LoanRepository._();

  /// Returns a list of [Loan]s matching the given query parameters.
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
  Future<List<Loan>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanTable>? orderBy,
    _is.OrderByListBuilder<LoanTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Loan>(
      where: where?.call(Loan.t),
      orderBy: orderBy?.call(Loan.t),
      orderByList: orderByList?.call(Loan.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Loan] matching the given query parameters.
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
  Future<Loan?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanTable>? where,
    int? offset,
    _is.OrderByBuilder<LoanTable>? orderBy,
    _is.OrderByListBuilder<LoanTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Loan>(
      where: where?.call(Loan.t),
      orderBy: orderBy?.call(Loan.t),
      orderByList: orderByList?.call(Loan.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Loan] by its [id] or null if no such row exists.
  Future<Loan?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Loan>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Loan]s in the list and returns the inserted rows.
  ///
  /// The returned [Loan]s will have their `id` fields set.
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
  Future<List<Loan>> insert(
    _is.DatabaseSession session,
    List<Loan> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Loan>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Loan] and returns the inserted row.
  ///
  /// The returned [Loan] will have its `id` field set.
  Future<Loan> insertRow(
    _is.DatabaseSession session,
    Loan row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Loan>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Loan]s in the list and returns the resulting rows.
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
  /// The returned [Loan]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Loan>> upsert(
    _is.DatabaseSession session,
    List<Loan> rows, {
    required _is.ColumnSelections<LoanTable> conflictColumns,
    _is.ColumnSelections<LoanTable>? updateColumns,
    _is.WhereExpressionBuilder<LoanTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Loan>(
      rows,
      conflictColumns: conflictColumns(Loan.t),
      updateColumns: updateColumns?.call(Loan.t),
      updateWhere: updateWhere?.call(Loan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Loan] and returns the resulting row.
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
  /// The returned [Loan] will have its `id` field set.
  Future<Loan?> upsertRow(
    _is.DatabaseSession session,
    Loan row, {
    required _is.ColumnSelections<LoanTable> conflictColumns,
    _is.ColumnSelections<LoanTable>? updateColumns,
    _is.WhereExpressionBuilder<LoanTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Loan>(
      row,
      conflictColumns: conflictColumns(Loan.t),
      updateColumns: updateColumns?.call(Loan.t),
      updateWhere: updateWhere?.call(Loan.t),
      transaction: transaction,
    );
  }

  /// Updates all [Loan]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Loan>> update(
    _is.DatabaseSession session,
    List<Loan> rows, {
    _is.ColumnSelections<LoanTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Loan>(
      rows,
      columns: columns?.call(Loan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Loan]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Loan> updateRow(
    _is.DatabaseSession session,
    Loan row, {
    _is.ColumnSelections<LoanTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Loan>(
      row,
      columns: columns?.call(Loan.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Loan] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Loan?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LoanUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Loan>(
      id,
      columnValues: columnValues(Loan.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Loan]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Loan>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LoanUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LoanTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LoanTable>? orderBy,
    _is.OrderByListBuilder<LoanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Loan>(
      columnValues: columnValues(Loan.t.updateTable),
      where: where(Loan.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Loan.t),
      orderByList: orderByList?.call(Loan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Loan]s in the list and returns the deleted rows.
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
  Future<List<Loan>> delete(
    _is.DatabaseSession session,
    List<Loan> rows, {
    _is.OrderByBuilder<LoanTable>? orderBy,
    _is.OrderByListBuilder<LoanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Loan>(
      rows,
      orderBy: orderBy?.call(Loan.t),
      orderByList: orderByList?.call(Loan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Loan].
  Future<Loan> deleteRow(
    _is.DatabaseSession session,
    Loan row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Loan>(
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
  Future<List<Loan>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LoanTable> where,
    _is.OrderByBuilder<LoanTable>? orderBy,
    _is.OrderByListBuilder<LoanTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Loan>(
      where: where(Loan.t),
      orderBy: orderBy?.call(Loan.t),
      orderByList: orderByList?.call(Loan.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LoanTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Loan>(
      where: where?.call(Loan.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Loan] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LoanTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Loan>(
      where: where(Loan.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
