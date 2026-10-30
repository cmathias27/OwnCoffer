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
import 'package:owncoffer_client/src/protocol/category.dart' as _i37qqsjr;
import 'package:owncoffer_client/src/protocol/group_membership.dart'
    as _itelwlzo;
import 'package:owncoffer_client/src/protocol/invitation_info.dart'
    as _i2judacm;
import 'package:owncoffer_client/src/protocol/ip_ban_info.dart' as _ivw6xhv3;
import 'package:owncoffer_client/src/protocol/member_info.dart' as _igteyn7f;
import 'package:owncoffer_client/src/protocol/notification.dart' as _igwx4n0s;
import 'package:owncoffer_client/src/protocol/rule.dart' as _i0jtaw5e;
import 'package:owncoffer_client/src/protocol/scheduled_transaction.dart'
    as _ibpr6881;
import 'package:owncoffer_client/src/protocol/statement_import.dart'
    as _i5x9swls;
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
import 'csv_columns.dart' as _iq9wp9wq;
import 'finance_group.dart' as _iqh5irlt;
import 'forecast_day.dart' as _ids0ngao;
import 'forecast_event_info.dart' as _iuscnr1n;
import 'forecast_result.dart' as _idemr8ki;
import 'frequency.dart' as _ixycnzxw;
import 'group_member.dart' as _igiek2ee;
import 'group_membership.dart' as _i54nduyh;
import 'import_issue_info.dart' as _iso7nf03;
import 'import_preview.dart' as _im8lwq6n;
import 'import_preview_line.dart' as _i4e8elxc;
import 'invalid_input_exception.dart' as _ijc83d8f;
import 'invitation_info.dart' as _i9hwipt6;
import 'ip_ban_info.dart' as _ijfl1fdm;
import 'member_info.dart' as _i2slp771;
import 'member_role.dart' as _insyygng;
import 'missed_occurrence_info.dart' as _ifjtpr6l;
import 'notification.dart' as _irt10kca;
import 'reconciliation_proposal.dart' as _i7qmkh8w;
import 'rule.dart' as _ivw87pdb;
import 'rule_direction.dart' as _i13yq1r7;
import 'rule_match_type.dart' as _ibgrh3pe;
import 'scheduled_transaction.dart' as _ifol8nrg;
import 'setup_status.dart' as _iw7q1xsb;
import 'statement_import.dart' as _ia7wudj2;
import 'totp_enrollment.dart' as _iul1v2p7;
import 'two_factor_status.dart' as _igcslm1n;
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
export 'csv_columns.dart';
export 'finance_group.dart';
export 'forecast_day.dart';
export 'forecast_event_info.dart';
export 'forecast_result.dart';
export 'frequency.dart';
export 'group_member.dart';
export 'group_membership.dart';
export 'import_issue_info.dart';
export 'import_preview.dart';
export 'import_preview_line.dart';
export 'invalid_input_exception.dart';
export 'invitation_info.dart';
export 'ip_ban_info.dart';
export 'member_info.dart';
export 'member_role.dart';
export 'missed_occurrence_info.dart';
export 'notification.dart';
export 'reconciliation_proposal.dart';
export 'rule.dart';
export 'rule_direction.dart';
export 'rule_match_type.dart';
export 'scheduled_transaction.dart';
export 'setup_status.dart';
export 'statement_import.dart';
export 'totp_enrollment.dart';
export 'two_factor_status.dart';
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
    if (t == _iq9wp9wq.CsvColumns) {
      return _iq9wp9wq.CsvColumns.fromJson(data) as T;
    }
    if (t == _iqh5irlt.FinanceGroup) {
      return _iqh5irlt.FinanceGroup.fromJson(data) as T;
    }
    if (t == _ids0ngao.ForecastDay) {
      return _ids0ngao.ForecastDay.fromJson(data) as T;
    }
    if (t == _iuscnr1n.ForecastEventInfo) {
      return _iuscnr1n.ForecastEventInfo.fromJson(data) as T;
    }
    if (t == _idemr8ki.ForecastResult) {
      return _idemr8ki.ForecastResult.fromJson(data) as T;
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
    if (t == _iso7nf03.ImportIssueInfo) {
      return _iso7nf03.ImportIssueInfo.fromJson(data) as T;
    }
    if (t == _im8lwq6n.ImportPreview) {
      return _im8lwq6n.ImportPreview.fromJson(data) as T;
    }
    if (t == _i4e8elxc.ImportPreviewLine) {
      return _i4e8elxc.ImportPreviewLine.fromJson(data) as T;
    }
    if (t == _ijc83d8f.InvalidInputException) {
      return _ijc83d8f.InvalidInputException.fromJson(data) as T;
    }
    if (t == _i9hwipt6.InvitationInfo) {
      return _i9hwipt6.InvitationInfo.fromJson(data) as T;
    }
    if (t == _ijfl1fdm.IpBanInfo) {
      return _ijfl1fdm.IpBanInfo.fromJson(data) as T;
    }
    if (t == _i2slp771.MemberInfo) {
      return _i2slp771.MemberInfo.fromJson(data) as T;
    }
    if (t == _insyygng.MemberRole) {
      return _insyygng.MemberRole.fromJson(data) as T;
    }
    if (t == _ifjtpr6l.MissedOccurrenceInfo) {
      return _ifjtpr6l.MissedOccurrenceInfo.fromJson(data) as T;
    }
    if (t == _irt10kca.AppNotification) {
      return _irt10kca.AppNotification.fromJson(data) as T;
    }
    if (t == _i7qmkh8w.ReconciliationProposal) {
      return _i7qmkh8w.ReconciliationProposal.fromJson(data) as T;
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
    if (t == _ia7wudj2.StatementImport) {
      return _ia7wudj2.StatementImport.fromJson(data) as T;
    }
    if (t == _iul1v2p7.TotpEnrollment) {
      return _iul1v2p7.TotpEnrollment.fromJson(data) as T;
    }
    if (t == _igcslm1n.TwoFactorStatus) {
      return _igcslm1n.TwoFactorStatus.fromJson(data) as T;
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
    if (t == _isc.getType<_iq9wp9wq.CsvColumns?>()) {
      return (data != null ? _iq9wp9wq.CsvColumns.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iqh5irlt.FinanceGroup?>()) {
      return (data != null ? _iqh5irlt.FinanceGroup.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ids0ngao.ForecastDay?>()) {
      return (data != null ? _ids0ngao.ForecastDay.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iuscnr1n.ForecastEventInfo?>()) {
      return (data != null ? _iuscnr1n.ForecastEventInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idemr8ki.ForecastResult?>()) {
      return (data != null ? _idemr8ki.ForecastResult.fromJson(data) : null)
          as T;
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
    if (t == _isc.getType<_iso7nf03.ImportIssueInfo?>()) {
      return (data != null ? _iso7nf03.ImportIssueInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_im8lwq6n.ImportPreview?>()) {
      return (data != null ? _im8lwq6n.ImportPreview.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4e8elxc.ImportPreviewLine?>()) {
      return (data != null ? _i4e8elxc.ImportPreviewLine.fromJson(data) : null)
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
    if (t == _isc.getType<_ijfl1fdm.IpBanInfo?>()) {
      return (data != null ? _ijfl1fdm.IpBanInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2slp771.MemberInfo?>()) {
      return (data != null ? _i2slp771.MemberInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_insyygng.MemberRole?>()) {
      return (data != null ? _insyygng.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifjtpr6l.MissedOccurrenceInfo?>()) {
      return (data != null
              ? _ifjtpr6l.MissedOccurrenceInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_irt10kca.AppNotification?>()) {
      return (data != null ? _irt10kca.AppNotification.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7qmkh8w.ReconciliationProposal?>()) {
      return (data != null
              ? _i7qmkh8w.ReconciliationProposal.fromJson(data)
              : null)
          as T;
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
    if (t == _isc.getType<_ia7wudj2.StatementImport?>()) {
      return (data != null ? _ia7wudj2.StatementImport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iul1v2p7.TotpEnrollment?>()) {
      return (data != null ? _iul1v2p7.TotpEnrollment.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igcslm1n.TwoFactorStatus?>()) {
      return (data != null ? _igcslm1n.TwoFactorStatus.fromJson(data) : null)
          as T;
    }
    if (t == List<_ids0ngao.ForecastDay>) {
      return (data as List)
              .map((e) => deserialize<_ids0ngao.ForecastDay>(e))
              .toList()
          as T;
    }
    if (t == List<_iuscnr1n.ForecastEventInfo>) {
      return (data as List)
              .map((e) => deserialize<_iuscnr1n.ForecastEventInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_ifjtpr6l.MissedOccurrenceInfo>) {
      return (data as List)
              .map((e) => deserialize<_ifjtpr6l.MissedOccurrenceInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i7qmkh8w.ReconciliationProposal>) {
      return (data as List)
              .map((e) => deserialize<_i7qmkh8w.ReconciliationProposal>(e))
              .toList()
          as T;
    }
    if (t == List<_iso7nf03.ImportIssueInfo>) {
      return (data as List)
              .map((e) => deserialize<_iso7nf03.ImportIssueInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i4e8elxc.ImportPreviewLine>) {
      return (data as List)
              .map((e) => deserialize<_i4e8elxc.ImportPreviewLine>(e))
              .toList()
          as T;
    }
    if (t == List<_i4motmly.Account>) {
      return (data as List)
              .map((e) => deserialize<_i4motmly.Account>(e))
              .toList()
          as T;
    }
    if (t == List<_ivw6xhv3.IpBanInfo>) {
      return (data as List)
              .map((e) => deserialize<_ivw6xhv3.IpBanInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i37qqsjr.Category>) {
      return (data as List)
              .map((e) => deserialize<_i37qqsjr.Category>(e))
              .toList()
          as T;
    }
    if (t == List<_itelwlzo.GroupMembership>) {
      return (data as List)
              .map((e) => deserialize<_itelwlzo.GroupMembership>(e))
              .toList()
          as T;
    }
    if (t == List<_igteyn7f.MemberInfo>) {
      return (data as List)
              .map((e) => deserialize<_igteyn7f.MemberInfo>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _isc.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i5x9swls.StatementImport>) {
      return (data as List)
              .map((e) => deserialize<_i5x9swls.StatementImport>(e))
              .toList()
          as T;
    }
    if (t == List<_i2judacm.InvitationInfo>) {
      return (data as List)
              .map((e) => deserialize<_i2judacm.InvitationInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_igwx4n0s.AppNotification>) {
      return (data as List)
              .map((e) => deserialize<_igwx4n0s.AppNotification>(e))
              .toList()
          as T;
    }
    if (t == List<_i0jtaw5e.Rule>) {
      return (data as List).map((e) => deserialize<_i0jtaw5e.Rule>(e)).toList()
          as T;
    }
    if (t == List<_ibpr6881.ScheduledTransaction>) {
      return (data as List)
              .map((e) => deserialize<_ibpr6881.ScheduledTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
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
      _iq9wp9wq.CsvColumns => 'CsvColumns',
      _iqh5irlt.FinanceGroup => 'FinanceGroup',
      _ids0ngao.ForecastDay => 'ForecastDay',
      _iuscnr1n.ForecastEventInfo => 'ForecastEventInfo',
      _idemr8ki.ForecastResult => 'ForecastResult',
      _ixycnzxw.ScheduleFrequency => 'ScheduleFrequency',
      _igiek2ee.GroupMember => 'GroupMember',
      _i54nduyh.GroupMembership => 'GroupMembership',
      _iso7nf03.ImportIssueInfo => 'ImportIssueInfo',
      _im8lwq6n.ImportPreview => 'ImportPreview',
      _i4e8elxc.ImportPreviewLine => 'ImportPreviewLine',
      _ijc83d8f.InvalidInputException => 'InvalidInputException',
      _i9hwipt6.InvitationInfo => 'InvitationInfo',
      _ijfl1fdm.IpBanInfo => 'IpBanInfo',
      _i2slp771.MemberInfo => 'MemberInfo',
      _insyygng.MemberRole => 'MemberRole',
      _ifjtpr6l.MissedOccurrenceInfo => 'MissedOccurrenceInfo',
      _irt10kca.AppNotification => 'AppNotification',
      _i7qmkh8w.ReconciliationProposal => 'ReconciliationProposal',
      _ivw87pdb.Rule => 'Rule',
      _i13yq1r7.RuleDirection => 'RuleDirection',
      _ibgrh3pe.RuleMatchType => 'RuleMatchType',
      _ifol8nrg.ScheduledTransaction => 'ScheduledTransaction',
      _iw7q1xsb.SetupStatus => 'SetupStatus',
      _ia7wudj2.StatementImport => 'StatementImport',
      _iul1v2p7.TotpEnrollment => 'TotpEnrollment',
      _igcslm1n.TwoFactorStatus => 'TwoFactorStatus',
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
      case _iq9wp9wq.CsvColumns():
        return 'CsvColumns';
      case _iqh5irlt.FinanceGroup():
        return 'FinanceGroup';
      case _ids0ngao.ForecastDay():
        return 'ForecastDay';
      case _iuscnr1n.ForecastEventInfo():
        return 'ForecastEventInfo';
      case _idemr8ki.ForecastResult():
        return 'ForecastResult';
      case _ixycnzxw.ScheduleFrequency():
        return 'ScheduleFrequency';
      case _igiek2ee.GroupMember():
        return 'GroupMember';
      case _i54nduyh.GroupMembership():
        return 'GroupMembership';
      case _iso7nf03.ImportIssueInfo():
        return 'ImportIssueInfo';
      case _im8lwq6n.ImportPreview():
        return 'ImportPreview';
      case _i4e8elxc.ImportPreviewLine():
        return 'ImportPreviewLine';
      case _ijc83d8f.InvalidInputException():
        return 'InvalidInputException';
      case _i9hwipt6.InvitationInfo():
        return 'InvitationInfo';
      case _ijfl1fdm.IpBanInfo():
        return 'IpBanInfo';
      case _i2slp771.MemberInfo():
        return 'MemberInfo';
      case _insyygng.MemberRole():
        return 'MemberRole';
      case _ifjtpr6l.MissedOccurrenceInfo():
        return 'MissedOccurrenceInfo';
      case _irt10kca.AppNotification():
        return 'AppNotification';
      case _i7qmkh8w.ReconciliationProposal():
        return 'ReconciliationProposal';
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
      case _ia7wudj2.StatementImport():
        return 'StatementImport';
      case _iul1v2p7.TotpEnrollment():
        return 'TotpEnrollment';
      case _igcslm1n.TwoFactorStatus():
        return 'TwoFactorStatus';
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
    if (dataClassName == 'CsvColumns') {
      return deserialize<_iq9wp9wq.CsvColumns>(data['data']);
    }
    if (dataClassName == 'FinanceGroup') {
      return deserialize<_iqh5irlt.FinanceGroup>(data['data']);
    }
    if (dataClassName == 'ForecastDay') {
      return deserialize<_ids0ngao.ForecastDay>(data['data']);
    }
    if (dataClassName == 'ForecastEventInfo') {
      return deserialize<_iuscnr1n.ForecastEventInfo>(data['data']);
    }
    if (dataClassName == 'ForecastResult') {
      return deserialize<_idemr8ki.ForecastResult>(data['data']);
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
    if (dataClassName == 'ImportIssueInfo') {
      return deserialize<_iso7nf03.ImportIssueInfo>(data['data']);
    }
    if (dataClassName == 'ImportPreview') {
      return deserialize<_im8lwq6n.ImportPreview>(data['data']);
    }
    if (dataClassName == 'ImportPreviewLine') {
      return deserialize<_i4e8elxc.ImportPreviewLine>(data['data']);
    }
    if (dataClassName == 'InvalidInputException') {
      return deserialize<_ijc83d8f.InvalidInputException>(data['data']);
    }
    if (dataClassName == 'InvitationInfo') {
      return deserialize<_i9hwipt6.InvitationInfo>(data['data']);
    }
    if (dataClassName == 'IpBanInfo') {
      return deserialize<_ijfl1fdm.IpBanInfo>(data['data']);
    }
    if (dataClassName == 'MemberInfo') {
      return deserialize<_i2slp771.MemberInfo>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_insyygng.MemberRole>(data['data']);
    }
    if (dataClassName == 'MissedOccurrenceInfo') {
      return deserialize<_ifjtpr6l.MissedOccurrenceInfo>(data['data']);
    }
    if (dataClassName == 'AppNotification') {
      return deserialize<_irt10kca.AppNotification>(data['data']);
    }
    if (dataClassName == 'ReconciliationProposal') {
      return deserialize<_i7qmkh8w.ReconciliationProposal>(data['data']);
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
    if (dataClassName == 'StatementImport') {
      return deserialize<_ia7wudj2.StatementImport>(data['data']);
    }
    if (dataClassName == 'TotpEnrollment') {
      return deserialize<_iul1v2p7.TotpEnrollment>(data['data']);
    }
    if (dataClassName == 'TwoFactorStatus') {
      return deserialize<_igcslm1n.TwoFactorStatus>(data['data']);
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
