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
import 'account_kind.dart' as _ifkquxga;
import 'account_visibility.dart' as _ioxxcdxl;

/// A bank account. Amounts are integer cents.
abstract class Account
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Account._({
    this.id,
    required this.groupId,
    required this.name,
    required this.kind,
    this.bank,
    String? currency,
    int? initialBalanceCents,
    this.initialBalanceDate,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    this.color,
    DateTime? createdAt,
    this.deletedAt,
  }) : currency = currency ?? 'EUR',
       initialBalanceCents = initialBalanceCents ?? 0,
       alertThresholdCents = alertThresholdCents ?? 0,
       visibility = visibility ?? _ioxxcdxl.AccountVisibility.shared,
       createdAt = createdAt ?? DateTime.now();

  factory Account({
    int? id,
    required int groupId,
    required String name,
    required _ifkquxga.AccountKind kind,
    String? bank,
    String? currency,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) = _AccountImpl;

  factory Account.fromJson(Map<String, dynamic> jsonSerialization) {
    return Account(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      name: jsonSerialization['name'] as String,
      kind: _ifkquxga.AccountKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      bank: jsonSerialization['bank'] as String?,
      currency: jsonSerialization['currency'] as String?,
      initialBalanceCents: jsonSerialization['initialBalanceCents'] as int?,
      initialBalanceDate: jsonSerialization['initialBalanceDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['initialBalanceDate'],
            ),
      alertThresholdCents: jsonSerialization['alertThresholdCents'] as int?,
      visibility: jsonSerialization['visibility'] == null
          ? null
          : _ioxxcdxl.AccountVisibility.fromJson(
              (jsonSerialization['visibility'] as String),
            ),
      color: jsonSerialization['color'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  static final t = AccountTable();

  static const db = AccountRepository._();

  @override
  int? id;

  int groupId;

  String name;

  _ifkquxga.AccountKind kind;

  String? bank;

  String currency;

  int initialBalanceCents;

  /// Date of the initial balance (UTC midnight, see LocalDate conversion).
  DateTime? initialBalanceDate;

  /// Alert when the forecast goes below this balance (0 = any overdraft;
  /// negative = authorised overdraft).
  int alertThresholdCents;

  _ioxxcdxl.AccountVisibility visibility;

  String? color;

  DateTime createdAt;

  DateTime? deletedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Account]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Account copyWith({
    int? id,
    int? groupId,
    String? name,
    _ifkquxga.AccountKind? kind,
    String? bank,
    String? currency,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Account',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'kind': kind.toJson(),
      if (bank != null) 'bank': bank,
      'currency': currency,
      'initialBalanceCents': initialBalanceCents,
      if (initialBalanceDate != null)
        'initialBalanceDate': initialBalanceDate?.toJson(),
      'alertThresholdCents': alertThresholdCents,
      'visibility': visibility.toJson(),
      if (color != null) 'color': color,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Account',
      if (id != null) 'id': id,
      'groupId': groupId,
      'name': name,
      'kind': kind.toJson(),
      if (bank != null) 'bank': bank,
      'currency': currency,
      'initialBalanceCents': initialBalanceCents,
      if (initialBalanceDate != null)
        'initialBalanceDate': initialBalanceDate?.toJson(),
      'alertThresholdCents': alertThresholdCents,
      'visibility': visibility.toJson(),
      if (color != null) 'color': color,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  static AccountInclude include() {
    return AccountInclude._();
  }

  static AccountIncludeList includeList({
    _is.WhereExpressionBuilder<AccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountTable>? orderBy,
    _is.OrderByListBuilder<AccountTable>? orderByList,
    AccountInclude? include,
  }) {
    return AccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Account.t),
      orderByList: orderByList?.call(Account.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountImpl extends Account {
  _AccountImpl({
    int? id,
    required int groupId,
    required String name,
    required _ifkquxga.AccountKind kind,
    String? bank,
    String? currency,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    String? color,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         groupId: groupId,
         name: name,
         kind: kind,
         bank: bank,
         currency: currency,
         initialBalanceCents: initialBalanceCents,
         initialBalanceDate: initialBalanceDate,
         alertThresholdCents: alertThresholdCents,
         visibility: visibility,
         color: color,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Account]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Account copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? name,
    _ifkquxga.AccountKind? kind,
    Object? bank = _Undefined,
    String? currency,
    int? initialBalanceCents,
    Object? initialBalanceDate = _Undefined,
    int? alertThresholdCents,
    _ioxxcdxl.AccountVisibility? visibility,
    Object? color = _Undefined,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return Account(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      bank: bank is String? ? bank : this.bank,
      currency: currency ?? this.currency,
      initialBalanceCents: initialBalanceCents ?? this.initialBalanceCents,
      initialBalanceDate: initialBalanceDate is DateTime?
          ? initialBalanceDate
          : this.initialBalanceDate,
      alertThresholdCents: alertThresholdCents ?? this.alertThresholdCents,
      visibility: visibility ?? this.visibility,
      color: color is String? ? color : this.color,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}

class AccountUpdateTable extends _is.UpdateTable<AccountTable> {
  AccountUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_ifkquxga.AccountKind, _ifkquxga.AccountKind> kind(
    _ifkquxga.AccountKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> bank(String? value) => _is.ColumnValue(
    table.bank,
    value,
  );

  _is.ColumnValue<String, String> currency(String value) => _is.ColumnValue(
    table.currency,
    value,
  );

  _is.ColumnValue<int, int> initialBalanceCents(int value) => _is.ColumnValue(
    table.initialBalanceCents,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> initialBalanceDate(DateTime? value) =>
      _is.ColumnValue(
        table.initialBalanceDate,
        value,
      );

  _is.ColumnValue<int, int> alertThresholdCents(int value) => _is.ColumnValue(
    table.alertThresholdCents,
    value,
  );

  _is.ColumnValue<_ioxxcdxl.AccountVisibility, _ioxxcdxl.AccountVisibility>
  visibility(_ioxxcdxl.AccountVisibility value) => _is.ColumnValue(
    table.visibility,
    value,
  );

  _is.ColumnValue<String, String> color(String? value) => _is.ColumnValue(
    table.color,
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

class AccountTable extends _is.Table<int?> {
  AccountTable({super.tableRelation}) : super(tableName: 'accounts') {
    updateTable = AccountUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    bank = _is.ColumnString(
      'bank',
      this,
    );
    currency = _is.ColumnString(
      'currency',
      this,
      hasDefault: true,
    );
    initialBalanceCents = _is.ColumnInt(
      'initialBalanceCents',
      this,
      hasDefault: true,
    );
    initialBalanceDate = _is.ColumnDateTime(
      'initialBalanceDate',
      this,
    );
    alertThresholdCents = _is.ColumnInt(
      'alertThresholdCents',
      this,
      hasDefault: true,
    );
    visibility = _is.ColumnEnum(
      'visibility',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    color = _is.ColumnString(
      'color',
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

  late final AccountUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnString name;

  late final _is.ColumnEnum<_ifkquxga.AccountKind> kind;

  late final _is.ColumnString bank;

  late final _is.ColumnString currency;

  late final _is.ColumnInt initialBalanceCents;

  /// Date of the initial balance (UTC midnight, see LocalDate conversion).
  late final _is.ColumnDateTime initialBalanceDate;

  /// Alert when the forecast goes below this balance (0 = any overdraft;
  /// negative = authorised overdraft).
  late final _is.ColumnInt alertThresholdCents;

  late final _is.ColumnEnum<_ioxxcdxl.AccountVisibility> visibility;

  late final _is.ColumnString color;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime deletedAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    name,
    kind,
    bank,
    currency,
    initialBalanceCents,
    initialBalanceDate,
    alertThresholdCents,
    visibility,
    color,
    createdAt,
    deletedAt,
  ];
}

class AccountInclude extends _is.IncludeObject {
  AccountInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Account.t;
}

class AccountIncludeList extends _is.IncludeList {
  AccountIncludeList._({
    _is.WhereExpressionBuilder<AccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Account.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Account.t;
}

class AccountRepository {
  const AccountRepository._();

  /// Returns a list of [Account]s matching the given query parameters.
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
  Future<List<Account>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountTable>? orderBy,
    _is.OrderByListBuilder<AccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Account>(
      where: where?.call(Account.t),
      orderBy: orderBy?.call(Account.t),
      orderByList: orderByList?.call(Account.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Account] matching the given query parameters.
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
  Future<Account?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountTable>? where,
    int? offset,
    _is.OrderByBuilder<AccountTable>? orderBy,
    _is.OrderByListBuilder<AccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Account>(
      where: where?.call(Account.t),
      orderBy: orderBy?.call(Account.t),
      orderByList: orderByList?.call(Account.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Account] by its [id] or null if no such row exists.
  Future<Account?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Account>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Account]s in the list and returns the inserted rows.
  ///
  /// The returned [Account]s will have their `id` fields set.
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
  Future<List<Account>> insert(
    _is.DatabaseSession session,
    List<Account> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Account>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Account] and returns the inserted row.
  ///
  /// The returned [Account] will have its `id` field set.
  Future<Account> insertRow(
    _is.DatabaseSession session,
    Account row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Account>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Account]s in the list and returns the resulting rows.
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
  /// The returned [Account]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Account>> upsert(
    _is.DatabaseSession session,
    List<Account> rows, {
    required _is.ColumnSelections<AccountTable> conflictColumns,
    _is.ColumnSelections<AccountTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Account>(
      rows,
      conflictColumns: conflictColumns(Account.t),
      updateColumns: updateColumns?.call(Account.t),
      updateWhere: updateWhere?.call(Account.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Account] and returns the resulting row.
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
  /// The returned [Account] will have its `id` field set.
  Future<Account?> upsertRow(
    _is.DatabaseSession session,
    Account row, {
    required _is.ColumnSelections<AccountTable> conflictColumns,
    _is.ColumnSelections<AccountTable>? updateColumns,
    _is.WhereExpressionBuilder<AccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Account>(
      row,
      conflictColumns: conflictColumns(Account.t),
      updateColumns: updateColumns?.call(Account.t),
      updateWhere: updateWhere?.call(Account.t),
      transaction: transaction,
    );
  }

  /// Updates all [Account]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Account>> update(
    _is.DatabaseSession session,
    List<Account> rows, {
    _is.ColumnSelections<AccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Account>(
      rows,
      columns: columns?.call(Account.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Account]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Account> updateRow(
    _is.DatabaseSession session,
    Account row, {
    _is.ColumnSelections<AccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Account>(
      row,
      columns: columns?.call(Account.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Account] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Account?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AccountUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Account>(
      id,
      columnValues: columnValues(Account.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Account]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Account>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccountUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccountTable>? orderBy,
    _is.OrderByListBuilder<AccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Account>(
      columnValues: columnValues(Account.t.updateTable),
      where: where(Account.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Account.t),
      orderByList: orderByList?.call(Account.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Account]s in the list and returns the deleted rows.
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
  Future<List<Account>> delete(
    _is.DatabaseSession session,
    List<Account> rows, {
    _is.OrderByBuilder<AccountTable>? orderBy,
    _is.OrderByListBuilder<AccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Account>(
      rows,
      orderBy: orderBy?.call(Account.t),
      orderByList: orderByList?.call(Account.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Account].
  Future<Account> deleteRow(
    _is.DatabaseSession session,
    Account row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Account>(
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
  Future<List<Account>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountTable> where,
    _is.OrderByBuilder<AccountTable>? orderBy,
    _is.OrderByListBuilder<AccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Account>(
      where: where(Account.t),
      orderBy: orderBy?.call(Account.t),
      orderByList: orderByList?.call(Account.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Account>(
      where: where?.call(Account.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Account] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Account>(
      where: where(Account.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
