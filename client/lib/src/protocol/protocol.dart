/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:owncoffer_client/src/protocol/account.dart' as _i4motmly;
import 'package:owncoffer_client/src/protocol/group_member.dart' as _il25bams;
import 'package:owncoffer_client/src/protocol/group_membership.dart'
    as _itelwlzo;
import 'package:owncoffer_client/src/protocol/invitation_info.dart'
    as _i2judacm;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'access_denied_exception.dart' as _i8te4v3o;
import 'account.dart' as _iulmo8pc;
import 'account_access.dart' as _idkoqesg;
import 'account_kind.dart' as _ifkquxga;
import 'account_visibility.dart' as _ioxxcdxl;
import 'bank_transaction.dart' as _i0mjlwv3;
import 'category.dart' as _issw2w8j;
import 'category_kind.dart' as _i7kso3nf;
import 'category_source.dart' as _idpjit5g;
import 'community_rule.dart' as _igloa2c5;
import 'finance_group.dart' as _iqh5irlt;
import 'frequency.dart' as _ixycnzxw;
import 'group_member.dart' as _igiek2ee;
import 'group_membership.dart' as _i54nduyh;
import 'invalid_input_exception.dart' as _ijc83d8f;
import 'invitation_info.dart' as _i9hwipt6;
import 'member_role.dart' as _insyygng;
import 'rule.dart' as _ivw87pdb;
import 'rule_direction.dart' as _i13yq1r7;
import 'rule_match_type.dart' as _ibgrh3pe;
import 'scheduled_transaction.dart' as _ifol8nrg;
import 'setup_status.dart' as _iw7q1xsb;
import 'standard_category.dart' as _iwj8dr64;
import 'statement_import.dart' as _ia7wudj2;
export 'access_denied_exception.dart';
export 'account.dart';
export 'account_access.dart';
export 'account_kind.dart';
export 'account_visibility.dart';
export 'bank_transaction.dart';
export 'category.dart';
export 'category_kind.dart';
export 'category_source.dart';
export 'community_rule.dart';
export 'finance_group.dart';
export 'frequency.dart';
export 'group_member.dart';
export 'group_membership.dart';
export 'invalid_input_exception.dart';
export 'invitation_info.dart';
export 'member_role.dart';
export 'rule.dart';
export 'rule_direction.dart';
export 'rule_match_type.dart';
export 'scheduled_transaction.dart';
export 'setup_status.dart';
export 'standard_category.dart';
export 'statement_import.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i8te4v3o.AccessDeniedException) {
      return _i8te4v3o.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _iulmo8pc.Account) {
      return _iulmo8pc.Account.fromJson(data) as T;
    }
    if (t == _idkoqesg.AccountAccess) {
      return _idkoqesg.AccountAccess.fromJson(data) as T;
    }
    if (t == _ifkquxga.AccountKind) {
      return _ifkquxga.AccountKind.fromJson(data) as T;
    }
    if (t == _ioxxcdxl.AccountVisibility) {
      return _ioxxcdxl.AccountVisibility.fromJson(data) as T;
    }
    if (t == _i0mjlwv3.BankTransaction) {
      return _i0mjlwv3.BankTransaction.fromJson(data) as T;
    }
    if (t == _issw2w8j.Category) {
      return _issw2w8j.Category.fromJson(data) as T;
    }
    if (t == _i7kso3nf.CategoryKind) {
      return _i7kso3nf.CategoryKind.fromJson(data) as T;
    }
    if (t == _idpjit5g.CategorySource) {
      return _idpjit5g.CategorySource.fromJson(data) as T;
    }
    if (t == _igloa2c5.CommunityRule) {
      return _igloa2c5.CommunityRule.fromJson(data) as T;
    }
    if (t == _iqh5irlt.FinanceGroup) {
      return _iqh5irlt.FinanceGroup.fromJson(data) as T;
    }
    if (t == _ixycnzxw.ScheduleFrequency) {
      return _ixycnzxw.ScheduleFrequency.fromJson(data) as T;
    }
    if (t == _igiek2ee.GroupMember) {
      return _igiek2ee.GroupMember.fromJson(data) as T;
    }
    if (t == _i54nduyh.GroupMembership) {
      return _i54nduyh.GroupMembership.fromJson(data) as T;
    }
    if (t == _ijc83d8f.InvalidInputException) {
      return _ijc83d8f.InvalidInputException.fromJson(data) as T;
    }
    if (t == _i9hwipt6.InvitationInfo) {
      return _i9hwipt6.InvitationInfo.fromJson(data) as T;
    }
    if (t == _insyygng.MemberRole) {
      return _insyygng.MemberRole.fromJson(data) as T;
    }
    if (t == _ivw87pdb.Rule) {
      return _ivw87pdb.Rule.fromJson(data) as T;
    }
    if (t == _i13yq1r7.RuleDirection) {
      return _i13yq1r7.RuleDirection.fromJson(data) as T;
    }
    if (t == _ibgrh3pe.RuleMatchType) {
      return _ibgrh3pe.RuleMatchType.fromJson(data) as T;
    }
    if (t == _ifol8nrg.ScheduledTransaction) {
      return _ifol8nrg.ScheduledTransaction.fromJson(data) as T;
    }
    if (t == _iw7q1xsb.SetupStatus) {
      return _iw7q1xsb.SetupStatus.fromJson(data) as T;
    }
    if (t == _iwj8dr64.StandardCategory) {
      return _iwj8dr64.StandardCategory.fromJson(data) as T;
    }
    if (t == _ia7wudj2.StatementImport) {
      return _ia7wudj2.StatementImport.fromJson(data) as T;
    }
    if (t == _isc.getType<_i8te4v3o.AccessDeniedException?>()) {
      return (data != null
              ? _i8te4v3o.AccessDeniedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iulmo8pc.Account?>()) {
      return (data != null ? _iulmo8pc.Account.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idkoqesg.AccountAccess?>()) {
      return (data != null ? _idkoqesg.AccountAccess.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifkquxga.AccountKind?>()) {
      return (data != null ? _ifkquxga.AccountKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ioxxcdxl.AccountVisibility?>()) {
      return (data != null ? _ioxxcdxl.AccountVisibility.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0mjlwv3.BankTransaction?>()) {
      return (data != null ? _i0mjlwv3.BankTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_issw2w8j.Category?>()) {
      return (data != null ? _issw2w8j.Category.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7kso3nf.CategoryKind?>()) {
      return (data != null ? _i7kso3nf.CategoryKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idpjit5g.CategorySource?>()) {
      return (data != null ? _idpjit5g.CategorySource.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igloa2c5.CommunityRule?>()) {
      return (data != null ? _igloa2c5.CommunityRule.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iqh5irlt.FinanceGroup?>()) {
      return (data != null ? _iqh5irlt.FinanceGroup.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixycnzxw.ScheduleFrequency?>()) {
      return (data != null ? _ixycnzxw.ScheduleFrequency.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igiek2ee.GroupMember?>()) {
      return (data != null ? _igiek2ee.GroupMember.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i54nduyh.GroupMembership?>()) {
      return (data != null ? _i54nduyh.GroupMembership.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijc83d8f.InvalidInputException?>()) {
      return (data != null
              ? _ijc83d8f.InvalidInputException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i9hwipt6.InvitationInfo?>()) {
      return (data != null ? _i9hwipt6.InvitationInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_insyygng.MemberRole?>()) {
      return (data != null ? _insyygng.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivw87pdb.Rule?>()) {
      return (data != null ? _ivw87pdb.Rule.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i13yq1r7.RuleDirection?>()) {
      return (data != null ? _i13yq1r7.RuleDirection.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibgrh3pe.RuleMatchType?>()) {
      return (data != null ? _ibgrh3pe.RuleMatchType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifol8nrg.ScheduledTransaction?>()) {
      return (data != null
              ? _ifol8nrg.ScheduledTransaction.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iw7q1xsb.SetupStatus?>()) {
      return (data != null ? _iw7q1xsb.SetupStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iwj8dr64.StandardCategory?>()) {
      return (data != null ? _iwj8dr64.StandardCategory.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ia7wudj2.StatementImport?>()) {
      return (data != null ? _ia7wudj2.StatementImport.fromJson(data) : null)
          as T;
    }
    if (t == List<_i4motmly.Account>) {
      return (data as List)
              .map((e) => deserialize<_i4motmly.Account>(e))
              .toList()
          as T;
    }
    if (t == List<_itelwlzo.GroupMembership>) {
      return (data as List)
              .map((e) => deserialize<_itelwlzo.GroupMembership>(e))
              .toList()
          as T;
    }
    if (t == List<_il25bams.GroupMember>) {
      return (data as List)
              .map((e) => deserialize<_il25bams.GroupMember>(e))
              .toList()
          as T;
    }
    if (t == List<_i2judacm.InvitationInfo>) {
      return (data as List)
              .map((e) => deserialize<_i2judacm.InvitationInfo>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i8te4v3o.AccessDeniedException => 'AccessDeniedException',
      _iulmo8pc.Account => 'Account',
      _idkoqesg.AccountAccess => 'AccountAccess',
      _ifkquxga.AccountKind => 'AccountKind',
      _ioxxcdxl.AccountVisibility => 'AccountVisibility',
      _i0mjlwv3.BankTransaction => 'BankTransaction',
      _issw2w8j.Category => 'Category',
      _i7kso3nf.CategoryKind => 'CategoryKind',
      _idpjit5g.CategorySource => 'CategorySource',
      _igloa2c5.CommunityRule => 'CommunityRule',
      _iqh5irlt.FinanceGroup => 'FinanceGroup',
      _ixycnzxw.ScheduleFrequency => 'ScheduleFrequency',
      _igiek2ee.GroupMember => 'GroupMember',
      _i54nduyh.GroupMembership => 'GroupMembership',
      _ijc83d8f.InvalidInputException => 'InvalidInputException',
      _i9hwipt6.InvitationInfo => 'InvitationInfo',
      _insyygng.MemberRole => 'MemberRole',
      _ivw87pdb.Rule => 'Rule',
      _i13yq1r7.RuleDirection => 'RuleDirection',
      _ibgrh3pe.RuleMatchType => 'RuleMatchType',
      _ifol8nrg.ScheduledTransaction => 'ScheduledTransaction',
      _iw7q1xsb.SetupStatus => 'SetupStatus',
      _iwj8dr64.StandardCategory => 'StandardCategory',
      _ia7wudj2.StatementImport => 'StatementImport',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('owncoffer.', '');
    }

    switch (data) {
      case _i8te4v3o.AccessDeniedException():
        return 'AccessDeniedException';
      case _iulmo8pc.Account():
        return 'Account';
      case _idkoqesg.AccountAccess():
        return 'AccountAccess';
      case _ifkquxga.AccountKind():
        return 'AccountKind';
      case _ioxxcdxl.AccountVisibility():
        return 'AccountVisibility';
      case _i0mjlwv3.BankTransaction():
        return 'BankTransaction';
      case _issw2w8j.Category():
        return 'Category';
      case _i7kso3nf.CategoryKind():
        return 'CategoryKind';
      case _idpjit5g.CategorySource():
        return 'CategorySource';
      case _igloa2c5.CommunityRule():
        return 'CommunityRule';
      case _iqh5irlt.FinanceGroup():
        return 'FinanceGroup';
      case _ixycnzxw.ScheduleFrequency():
        return 'ScheduleFrequency';
      case _igiek2ee.GroupMember():
        return 'GroupMember';
      case _i54nduyh.GroupMembership():
        return 'GroupMembership';
      case _ijc83d8f.InvalidInputException():
        return 'InvalidInputException';
      case _i9hwipt6.InvitationInfo():
        return 'InvitationInfo';
      case _insyygng.MemberRole():
        return 'MemberRole';
      case _ivw87pdb.Rule():
        return 'Rule';
      case _i13yq1r7.RuleDirection():
        return 'RuleDirection';
      case _ibgrh3pe.RuleMatchType():
        return 'RuleMatchType';
      case _ifol8nrg.ScheduledTransaction():
        return 'ScheduledTransaction';
      case _iw7q1xsb.SetupStatus():
        return 'SetupStatus';
      case _iwj8dr64.StandardCategory():
        return 'StandardCategory';
      case _ia7wudj2.StatementImport():
        return 'StatementImport';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i8te4v3o.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'Account') {
      return deserialize<_iulmo8pc.Account>(data['data']);
    }
    if (dataClassName == 'AccountAccess') {
      return deserialize<_idkoqesg.AccountAccess>(data['data']);
    }
    if (dataClassName == 'AccountKind') {
      return deserialize<_ifkquxga.AccountKind>(data['data']);
    }
    if (dataClassName == 'AccountVisibility') {
      return deserialize<_ioxxcdxl.AccountVisibility>(data['data']);
    }
    if (dataClassName == 'BankTransaction') {
      return deserialize<_i0mjlwv3.BankTransaction>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_issw2w8j.Category>(data['data']);
    }
    if (dataClassName == 'CategoryKind') {
      return deserialize<_i7kso3nf.CategoryKind>(data['data']);
    }
    if (dataClassName == 'CategorySource') {
      return deserialize<_idpjit5g.CategorySource>(data['data']);
    }
    if (dataClassName == 'CommunityRule') {
      return deserialize<_igloa2c5.CommunityRule>(data['data']);
    }
    if (dataClassName == 'FinanceGroup') {
      return deserialize<_iqh5irlt.FinanceGroup>(data['data']);
    }
    if (dataClassName == 'ScheduleFrequency') {
      return deserialize<_ixycnzxw.ScheduleFrequency>(data['data']);
    }
    if (dataClassName == 'GroupMember') {
      return deserialize<_igiek2ee.GroupMember>(data['data']);
    }
    if (dataClassName == 'GroupMembership') {
      return deserialize<_i54nduyh.GroupMembership>(data['data']);
    }
    if (dataClassName == 'InvalidInputException') {
      return deserialize<_ijc83d8f.InvalidInputException>(data['data']);
    }
    if (dataClassName == 'InvitationInfo') {
      return deserialize<_i9hwipt6.InvitationInfo>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_insyygng.MemberRole>(data['data']);
    }
    if (dataClassName == 'Rule') {
      return deserialize<_ivw87pdb.Rule>(data['data']);
    }
    if (dataClassName == 'RuleDirection') {
      return deserialize<_i13yq1r7.RuleDirection>(data['data']);
    }
    if (dataClassName == 'RuleMatchType') {
      return deserialize<_ibgrh3pe.RuleMatchType>(data['data']);
    }
    if (dataClassName == 'ScheduledTransaction') {
      return deserialize<_ifol8nrg.ScheduledTransaction>(data['data']);
    }
    if (dataClassName == 'SetupStatus') {
      return deserialize<_iw7q1xsb.SetupStatus>(data['data']);
    }
    if (dataClassName == 'StandardCategory') {
      return deserialize<_iwj8dr64.StandardCategory>(data['data']);
    }
    if (dataClassName == 'StatementImport') {
      return deserialize<_ia7wudj2.StatementImport>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('owncoffer', this);
    _iacc.Protocol().registerHostProtocol('owncoffer', this);
  }

  @override
  String getModuleName() => 'owncoffer';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
