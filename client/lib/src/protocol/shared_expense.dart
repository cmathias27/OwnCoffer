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

/// An expense paid by one member for several (split equally), or a
/// repayment between two members (decision 0050). Independent of the bank
/// operations: it records who owes whom.
abstract class SharedExpense
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SharedExpense._({
    this.id,
    required this.groupId,
    required this.label,
    required this.date,
    required this.amountCents,
    required this.paidBy,
    required this.participants,
    bool? repayment,
    required this.createdBy,
    DateTime? createdAt,
  }) : repayment = repayment ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory SharedExpense({
    int? id,
    required int groupId,
    required String label,
    required DateTime date,
    required int amountCents,
    required _isc.UuidValue paidBy,
    required List<_isc.UuidValue> participants,
    bool? repayment,
    required _isc.UuidValue createdBy,
    DateTime? createdAt,
  }) = _SharedExpenseImpl;

  factory SharedExpense.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedExpense(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      label: jsonSerialization['label'] as String,
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      amountCents: jsonSerialization['amountCents'] as int,
      paidBy: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['paidBy']),
      participants: _iylp5nsw.Protocol().deserialize<List<_isc.UuidValue>>(
        jsonSerialization['participants'],
      ),
      repayment: jsonSerialization['repayment'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['repayment']),
      createdBy: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdBy'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  String label;

  DateTime date;

  int amountCents;

  _isc.UuidValue paidBy;

  /// Members sharing it (user ids); a repayment has the one paid back.
  List<_isc.UuidValue> participants;

  bool repayment;

  _isc.UuidValue createdBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [SharedExpense]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SharedExpense copyWith({
    int? id,
    int? groupId,
    String? label,
    DateTime? date,
    int? amountCents,
    _isc.UuidValue? paidBy,
    List<_isc.UuidValue>? participants,
    bool? repayment,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedExpense',
      if (id != null) 'id': id,
      'groupId': groupId,
      'label': label,
      'date': date.toJson(),
      'amountCents': amountCents,
      'paidBy': paidBy.toJson(),
      'participants': participants.toJson(valueToJson: (v) => v.toJson()),
      'repayment': repayment,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedExpense',
      if (id != null) 'id': id,
      'groupId': groupId,
      'label': label,
      'date': date.toJson(),
      'amountCents': amountCents,
      'paidBy': paidBy.toJson(),
      'participants': participants.toJson(valueToJson: (v) => v.toJson()),
      'repayment': repayment,
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedExpenseImpl extends SharedExpense {
  _SharedExpenseImpl({
    int? id,
    required int groupId,
    required String label,
    required DateTime date,
    required int amountCents,
    required _isc.UuidValue paidBy,
    required List<_isc.UuidValue> participants,
    bool? repayment,
    required _isc.UuidValue createdBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         label: label,
         date: date,
         amountCents: amountCents,
         paidBy: paidBy,
         participants: participants,
         repayment: repayment,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SharedExpense]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SharedExpense copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? label,
    DateTime? date,
    int? amountCents,
    _isc.UuidValue? paidBy,
    List<_isc.UuidValue>? participants,
    bool? repayment,
    _isc.UuidValue? createdBy,
    DateTime? createdAt,
  }) {
    return SharedExpense(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      label: label ?? this.label,
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
      paidBy: paidBy ?? this.paidBy,
      participants: participants ?? this.participants.map((e0) => e0).toList(),
      repayment: repayment ?? this.repayment,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
