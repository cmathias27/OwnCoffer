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
import 'package:owncoffer_client/src/protocol/action_proposal.dart'
    as _ihgp0l1x;
import 'package:owncoffer_client/src/protocol/admin_audit_info.dart'
    as _icr6cafh;
import 'package:owncoffer_client/src/protocol/admin_group_info.dart'
    as _iq49mcaz;
import 'package:owncoffer_client/src/protocol/admin_invitation_info.dart'
    as _idjaxr3o;
import 'package:owncoffer_client/src/protocol/admin_user_info.dart'
    as _i4kcqb5h;
import 'package:owncoffer_client/src/protocol/ai_message.dart' as _iarsdlqt;
import 'package:owncoffer_client/src/protocol/balance_check.dart' as _ifxnt0qj;
import 'package:owncoffer_client/src/protocol/bank_transaction.dart'
    as _ivksw0b3;
import 'package:owncoffer_client/src/protocol/category.dart' as _i37qqsjr;
import 'package:owncoffer_client/src/protocol/goal.dart' as _ita8uvsc;
import 'package:owncoffer_client/src/protocol/group_membership.dart'
    as _itelwlzo;
import 'package:owncoffer_client/src/protocol/instalment_candidate.dart'
    as _io211e4m;
import 'package:owncoffer_client/src/protocol/invitation_info.dart'
    as _i2judacm;
import 'package:owncoffer_client/src/protocol/invoice_info.dart' as _iej1c1us;
import 'package:owncoffer_client/src/protocol/invoice_match.dart' as _ikyjg3a9;
import 'package:owncoffer_client/src/protocol/ip_ban_info.dart' as _ivw6xhv3;
import 'package:owncoffer_client/src/protocol/loan_document.dart' as _ixzu9i3x;
import 'package:owncoffer_client/src/protocol/loan_installment.dart'
    as _i18weoko;
import 'package:owncoffer_client/src/protocol/mcp_token.dart' as _ioxkfsho;
import 'package:owncoffer_client/src/protocol/member_info.dart' as _igteyn7f;
import 'package:owncoffer_client/src/protocol/notification.dart' as _igwx4n0s;
import 'package:owncoffer_client/src/protocol/rule.dart' as _i0jtaw5e;
import 'package:owncoffer_client/src/protocol/scheduled_transaction.dart'
    as _ibpr6881;
import 'package:owncoffer_client/src/protocol/statement_import.dart'
    as _i5x9swls;
import 'package:owncoffer_client/src/protocol/transaction_split.dart'
    as _idy91hap;
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
import 'action_proposal.dart' as _ius3n358;
import 'admin_audit_info.dart' as _ie0chd06;
import 'admin_group_info.dart' as _ixpxctu5;
import 'admin_health.dart' as _ihbeufm3;
import 'admin_invitation_info.dart' as _ib01m0m7;
import 'admin_stats.dart' as _iqygks5s;
import 'admin_user_info.dart' as _is8wfuq8;
import 'ai_message.dart' as _ikwoa06z;
import 'ai_preference.dart' as _i5zygq2d;
import 'ai_provider.dart' as _ibtxcndu;
import 'ai_reply.dart' as _ih3b4fxu;
import 'ai_status.dart' as _idsjcs1s;
import 'ai_usage.dart' as _iojy8c5d;
import 'backup_info.dart' as _i73uehc4;
import 'backup_overview.dart' as _in8hkpoa;
import 'balance_check.dart' as _ip4e316z;
import 'bank_transaction.dart' as _i0mjlwv3;
import 'budget_period.dart' as _ixjzi4yl;
import 'calendar_item.dart' as _itcb21m0;
import 'category.dart' as _issw2w8j;
import 'category_change_info.dart' as _iknjgrwa;
import 'category_flow.dart' as _i8msyna2;
import 'category_kind.dart' as _i7kso3nf;
import 'category_source.dart' as _idpjit5g;
import 'community_rule.dart' as _igloa2c5;
import 'csv_columns.dart' as _iq9wp9wq;
import 'due_calendar.dart' as _ic7yhr4p;
import 'early_repayment.dart' as _ind4b83h;
import 'finance_group.dart' as _iqh5irlt;
import 'forecast_day.dart' as _ids0ngao;
import 'forecast_event_info.dart' as _iuscnr1n;
import 'forecast_result.dart' as _idemr8ki;
import 'frequency.dart' as _ixycnzxw;
import 'goal.dart' as _ibqaulxu;
import 'group_member.dart' as _igiek2ee;
import 'group_membership.dart' as _i54nduyh;
import 'import_issue_info.dart' as _iso7nf03;
import 'import_preview.dart' as _im8lwq6n;
import 'import_preview_line.dart' as _i4e8elxc;
import 'instalment_candidate.dart' as _ia1npsti;
import 'invalid_input_exception.dart' as _ijc83d8f;
import 'invitation_info.dart' as _i9hwipt6;
import 'invoice.dart' as _ifja8moh;
import 'invoice_blob.dart' as _i0mnzbub;
import 'invoice_info.dart' as _im7mm4oj;
import 'invoice_match.dart' as _ixgqo4yu;
import 'ip_ban_info.dart' as _ijfl1fdm;
import 'left_to_live_report.dart' as _ibb3lpoc;
import 'loan.dart' as _i7jednjp;
import 'loan_document.dart' as _ixhwb2ta;
import 'loan_document_blob.dart' as _i05ovdfs;
import 'loan_from_operation.dart' as _ibgzxro1;
import 'loan_info.dart' as _ijbwwnsd;
import 'loan_installment.dart' as _ics9k3ng;
import 'loan_kind.dart' as _i1700pxx;
import 'loan_overview.dart' as _itnp0u8s;
import 'mcp_token.dart' as _ibm9fvwa;
import 'mcp_token_created.dart' as _iqv371vc;
import 'member_info.dart' as _i2slp771;
import 'member_role.dart' as _insyygng;
import 'missed_occurrence_info.dart' as _ifjtpr6l;
import 'month_review.dart' as _i5m4pdin;
import 'notification.dart' as _irt10kca;
import 'occurrence_status.dart' as _it10dx4m;
import 'period_totals.dart' as _imctw77w;
import 'provider_history.dart' as _irsxtgs7;
import 'purchase_option.dart' as _i46nnn14;
import 'purchase_payment_info.dart' as _i60c7zzl;
import 'purchase_scenario_info.dart' as _irvruma2;
import 'purchase_simulation.dart' as _idtt2l34;
import 'reconciliation_proposal.dart' as _i7qmkh8w;
import 'release_notes.dart' as _idndmjo8;
import 'rule.dart' as _ivw87pdb;
import 'rule_application.dart' as _ie66uvh9;
import 'rule_direction.dart' as _i13yq1r7;
import 'rule_match_type.dart' as _ibgrh3pe;
import 'rule_test_result.dart' as _ipgrn6yw;
import 'scheduled_transaction.dart' as _ifol8nrg;
import 'setup_status.dart' as _iw7q1xsb;
import 'spending_report.dart' as _ixcwyj5v;
import 'statement_import.dart' as _ia7wudj2;
import 'subscription_change.dart' as _ilnyaemj;
import 'subscription_overview.dart' as _iliwwe2k;
import 'totp_enrollment.dart' as _iul1v2p7;
import 'transaction_page.dart' as _i4rkvxa2;
import 'transaction_split.dart' as _iqvm376u;
import 'two_factor_status.dart' as _igcslm1n;
import 'update_history_entry.dart' as _idu38kh6;
import 'update_overview.dart' as _iv5yf7x0;
import 'variable_category_info.dart' as _ic7yx6at;
import 'variable_estimate_info.dart' as _in08zzvs;
export 'access_denied_exception.dart';
export 'account.dart';
export 'account_access.dart';
export 'account_kind.dart';
export 'account_visibility.dart';
export 'action_proposal.dart';
export 'admin_audit_info.dart';
export 'admin_group_info.dart';
export 'admin_health.dart';
export 'admin_invitation_info.dart';
export 'admin_stats.dart';
export 'admin_user_info.dart';
export 'ai_message.dart';
export 'ai_preference.dart';
export 'ai_provider.dart';
export 'ai_reply.dart';
export 'ai_status.dart';
export 'ai_usage.dart';
export 'backup_info.dart';
export 'backup_overview.dart';
export 'balance_check.dart';
export 'bank_transaction.dart';
export 'budget_period.dart';
export 'calendar_item.dart';
export 'category.dart';
export 'category_change_info.dart';
export 'category_flow.dart';
export 'category_kind.dart';
export 'category_source.dart';
export 'community_rule.dart';
export 'csv_columns.dart';
export 'due_calendar.dart';
export 'early_repayment.dart';
export 'finance_group.dart';
export 'forecast_day.dart';
export 'forecast_event_info.dart';
export 'forecast_result.dart';
export 'frequency.dart';
export 'goal.dart';
export 'group_member.dart';
export 'group_membership.dart';
export 'import_issue_info.dart';
export 'import_preview.dart';
export 'import_preview_line.dart';
export 'instalment_candidate.dart';
export 'invalid_input_exception.dart';
export 'invitation_info.dart';
export 'invoice.dart';
export 'invoice_blob.dart';
export 'invoice_info.dart';
export 'invoice_match.dart';
export 'ip_ban_info.dart';
export 'left_to_live_report.dart';
export 'loan.dart';
export 'loan_document.dart';
export 'loan_document_blob.dart';
export 'loan_from_operation.dart';
export 'loan_info.dart';
export 'loan_installment.dart';
export 'loan_kind.dart';
export 'loan_overview.dart';
export 'mcp_token.dart';
export 'mcp_token_created.dart';
export 'member_info.dart';
export 'member_role.dart';
export 'missed_occurrence_info.dart';
export 'month_review.dart';
export 'notification.dart';
export 'occurrence_status.dart';
export 'period_totals.dart';
export 'provider_history.dart';
export 'purchase_option.dart';
export 'purchase_payment_info.dart';
export 'purchase_scenario_info.dart';
export 'purchase_simulation.dart';
export 'reconciliation_proposal.dart';
export 'release_notes.dart';
export 'rule.dart';
export 'rule_application.dart';
export 'rule_direction.dart';
export 'rule_match_type.dart';
export 'rule_test_result.dart';
export 'scheduled_transaction.dart';
export 'setup_status.dart';
export 'spending_report.dart';
export 'statement_import.dart';
export 'subscription_change.dart';
export 'subscription_overview.dart';
export 'totp_enrollment.dart';
export 'transaction_page.dart';
export 'transaction_split.dart';
export 'two_factor_status.dart';
export 'update_history_entry.dart';
export 'update_overview.dart';
export 'variable_category_info.dart';
export 'variable_estimate_info.dart';
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
    if (t == _ius3n358.ActionProposal) {
      return _ius3n358.ActionProposal.fromJson(data) as T;
    }
    if (t == _ie0chd06.AdminAuditInfo) {
      return _ie0chd06.AdminAuditInfo.fromJson(data) as T;
    }
    if (t == _ixpxctu5.AdminGroupInfo) {
      return _ixpxctu5.AdminGroupInfo.fromJson(data) as T;
    }
    if (t == _ihbeufm3.AdminHealth) {
      return _ihbeufm3.AdminHealth.fromJson(data) as T;
    }
    if (t == _ib01m0m7.AdminInvitationInfo) {
      return _ib01m0m7.AdminInvitationInfo.fromJson(data) as T;
    }
    if (t == _iqygks5s.AdminStats) {
      return _iqygks5s.AdminStats.fromJson(data) as T;
    }
    if (t == _is8wfuq8.AdminUserInfo) {
      return _is8wfuq8.AdminUserInfo.fromJson(data) as T;
    }
    if (t == _ikwoa06z.AiMessage) {
      return _ikwoa06z.AiMessage.fromJson(data) as T;
    }
    if (t == _i5zygq2d.AiPreference) {
      return _i5zygq2d.AiPreference.fromJson(data) as T;
    }
    if (t == _ibtxcndu.AiProvider) {
      return _ibtxcndu.AiProvider.fromJson(data) as T;
    }
    if (t == _ih3b4fxu.AiReply) {
      return _ih3b4fxu.AiReply.fromJson(data) as T;
    }
    if (t == _idsjcs1s.AiStatus) {
      return _idsjcs1s.AiStatus.fromJson(data) as T;
    }
    if (t == _iojy8c5d.AiUsage) {
      return _iojy8c5d.AiUsage.fromJson(data) as T;
    }
    if (t == _i73uehc4.BackupInfo) {
      return _i73uehc4.BackupInfo.fromJson(data) as T;
    }
    if (t == _in8hkpoa.BackupOverview) {
      return _in8hkpoa.BackupOverview.fromJson(data) as T;
    }
    if (t == _ip4e316z.BalanceCheck) {
      return _ip4e316z.BalanceCheck.fromJson(data) as T;
    }
    if (t == _i0mjlwv3.BankTransaction) {
      return _i0mjlwv3.BankTransaction.fromJson(data) as T;
    }
    if (t == _ixjzi4yl.BudgetPeriod) {
      return _ixjzi4yl.BudgetPeriod.fromJson(data) as T;
    }
    if (t == _itcb21m0.CalendarItem) {
      return _itcb21m0.CalendarItem.fromJson(data) as T;
    }
    if (t == _issw2w8j.Category) {
      return _issw2w8j.Category.fromJson(data) as T;
    }
    if (t == _iknjgrwa.CategoryChangeInfo) {
      return _iknjgrwa.CategoryChangeInfo.fromJson(data) as T;
    }
    if (t == _i8msyna2.CategoryFlow) {
      return _i8msyna2.CategoryFlow.fromJson(data) as T;
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
    if (t == _ic7yhr4p.DueCalendar) {
      return _ic7yhr4p.DueCalendar.fromJson(data) as T;
    }
    if (t == _ind4b83h.EarlyRepayment) {
      return _ind4b83h.EarlyRepayment.fromJson(data) as T;
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
    if (t == _ibqaulxu.Goal) {
      return _ibqaulxu.Goal.fromJson(data) as T;
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
    if (t == _ia1npsti.InstalmentCandidate) {
      return _ia1npsti.InstalmentCandidate.fromJson(data) as T;
    }
    if (t == _ijc83d8f.InvalidInputException) {
      return _ijc83d8f.InvalidInputException.fromJson(data) as T;
    }
    if (t == _i9hwipt6.InvitationInfo) {
      return _i9hwipt6.InvitationInfo.fromJson(data) as T;
    }
    if (t == _ifja8moh.Invoice) {
      return _ifja8moh.Invoice.fromJson(data) as T;
    }
    if (t == _i0mnzbub.InvoiceBlob) {
      return _i0mnzbub.InvoiceBlob.fromJson(data) as T;
    }
    if (t == _im7mm4oj.InvoiceInfo) {
      return _im7mm4oj.InvoiceInfo.fromJson(data) as T;
    }
    if (t == _ixgqo4yu.InvoiceMatch) {
      return _ixgqo4yu.InvoiceMatch.fromJson(data) as T;
    }
    if (t == _ijfl1fdm.IpBanInfo) {
      return _ijfl1fdm.IpBanInfo.fromJson(data) as T;
    }
    if (t == _ibb3lpoc.LeftToLiveReport) {
      return _ibb3lpoc.LeftToLiveReport.fromJson(data) as T;
    }
    if (t == _i7jednjp.Loan) {
      return _i7jednjp.Loan.fromJson(data) as T;
    }
    if (t == _ixhwb2ta.LoanDocument) {
      return _ixhwb2ta.LoanDocument.fromJson(data) as T;
    }
    if (t == _i05ovdfs.LoanDocumentBlob) {
      return _i05ovdfs.LoanDocumentBlob.fromJson(data) as T;
    }
    if (t == _ibgzxro1.LoanFromOperation) {
      return _ibgzxro1.LoanFromOperation.fromJson(data) as T;
    }
    if (t == _ijbwwnsd.LoanInfo) {
      return _ijbwwnsd.LoanInfo.fromJson(data) as T;
    }
    if (t == _ics9k3ng.LoanInstallment) {
      return _ics9k3ng.LoanInstallment.fromJson(data) as T;
    }
    if (t == _i1700pxx.LoanKind) {
      return _i1700pxx.LoanKind.fromJson(data) as T;
    }
    if (t == _itnp0u8s.LoanOverview) {
      return _itnp0u8s.LoanOverview.fromJson(data) as T;
    }
    if (t == _ibm9fvwa.McpToken) {
      return _ibm9fvwa.McpToken.fromJson(data) as T;
    }
    if (t == _iqv371vc.McpTokenCreated) {
      return _iqv371vc.McpTokenCreated.fromJson(data) as T;
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
    if (t == _i5m4pdin.MonthReview) {
      return _i5m4pdin.MonthReview.fromJson(data) as T;
    }
    if (t == _irt10kca.AppNotification) {
      return _irt10kca.AppNotification.fromJson(data) as T;
    }
    if (t == _it10dx4m.OccurrenceStatus) {
      return _it10dx4m.OccurrenceStatus.fromJson(data) as T;
    }
    if (t == _imctw77w.PeriodTotals) {
      return _imctw77w.PeriodTotals.fromJson(data) as T;
    }
    if (t == _irsxtgs7.ProviderHistory) {
      return _irsxtgs7.ProviderHistory.fromJson(data) as T;
    }
    if (t == _i46nnn14.PurchaseOption) {
      return _i46nnn14.PurchaseOption.fromJson(data) as T;
    }
    if (t == _i60c7zzl.PurchasePaymentInfo) {
      return _i60c7zzl.PurchasePaymentInfo.fromJson(data) as T;
    }
    if (t == _irvruma2.PurchaseScenarioInfo) {
      return _irvruma2.PurchaseScenarioInfo.fromJson(data) as T;
    }
    if (t == _idtt2l34.PurchaseSimulation) {
      return _idtt2l34.PurchaseSimulation.fromJson(data) as T;
    }
    if (t == _i7qmkh8w.ReconciliationProposal) {
      return _i7qmkh8w.ReconciliationProposal.fromJson(data) as T;
    }
    if (t == _idndmjo8.ReleaseNotes) {
      return _idndmjo8.ReleaseNotes.fromJson(data) as T;
    }
    if (t == _ivw87pdb.Rule) {
      return _ivw87pdb.Rule.fromJson(data) as T;
    }
    if (t == _ie66uvh9.RuleApplication) {
      return _ie66uvh9.RuleApplication.fromJson(data) as T;
    }
    if (t == _i13yq1r7.RuleDirection) {
      return _i13yq1r7.RuleDirection.fromJson(data) as T;
    }
    if (t == _ibgrh3pe.RuleMatchType) {
      return _ibgrh3pe.RuleMatchType.fromJson(data) as T;
    }
    if (t == _ipgrn6yw.RuleTestResult) {
      return _ipgrn6yw.RuleTestResult.fromJson(data) as T;
    }
    if (t == _ifol8nrg.ScheduledTransaction) {
      return _ifol8nrg.ScheduledTransaction.fromJson(data) as T;
    }
    if (t == _iw7q1xsb.SetupStatus) {
      return _iw7q1xsb.SetupStatus.fromJson(data) as T;
    }
    if (t == _ixcwyj5v.SpendingReport) {
      return _ixcwyj5v.SpendingReport.fromJson(data) as T;
    }
    if (t == _ia7wudj2.StatementImport) {
      return _ia7wudj2.StatementImport.fromJson(data) as T;
    }
    if (t == _ilnyaemj.SubscriptionChange) {
      return _ilnyaemj.SubscriptionChange.fromJson(data) as T;
    }
    if (t == _iliwwe2k.SubscriptionOverview) {
      return _iliwwe2k.SubscriptionOverview.fromJson(data) as T;
    }
    if (t == _iul1v2p7.TotpEnrollment) {
      return _iul1v2p7.TotpEnrollment.fromJson(data) as T;
    }
    if (t == _i4rkvxa2.TransactionPage) {
      return _i4rkvxa2.TransactionPage.fromJson(data) as T;
    }
    if (t == _iqvm376u.TransactionSplit) {
      return _iqvm376u.TransactionSplit.fromJson(data) as T;
    }
    if (t == _igcslm1n.TwoFactorStatus) {
      return _igcslm1n.TwoFactorStatus.fromJson(data) as T;
    }
    if (t == _idu38kh6.UpdateHistoryEntry) {
      return _idu38kh6.UpdateHistoryEntry.fromJson(data) as T;
    }
    if (t == _iv5yf7x0.UpdateOverview) {
      return _iv5yf7x0.UpdateOverview.fromJson(data) as T;
    }
    if (t == _ic7yx6at.VariableCategoryInfo) {
      return _ic7yx6at.VariableCategoryInfo.fromJson(data) as T;
    }
    if (t == _in08zzvs.VariableEstimateInfo) {
      return _in08zzvs.VariableEstimateInfo.fromJson(data) as T;
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
    if (t == _isc.getType<_ius3n358.ActionProposal?>()) {
      return (data != null ? _ius3n358.ActionProposal.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ie0chd06.AdminAuditInfo?>()) {
      return (data != null ? _ie0chd06.AdminAuditInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixpxctu5.AdminGroupInfo?>()) {
      return (data != null ? _ixpxctu5.AdminGroupInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihbeufm3.AdminHealth?>()) {
      return (data != null ? _ihbeufm3.AdminHealth.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ib01m0m7.AdminInvitationInfo?>()) {
      return (data != null
              ? _ib01m0m7.AdminInvitationInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iqygks5s.AdminStats?>()) {
      return (data != null ? _iqygks5s.AdminStats.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_is8wfuq8.AdminUserInfo?>()) {
      return (data != null ? _is8wfuq8.AdminUserInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikwoa06z.AiMessage?>()) {
      return (data != null ? _ikwoa06z.AiMessage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5zygq2d.AiPreference?>()) {
      return (data != null ? _i5zygq2d.AiPreference.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibtxcndu.AiProvider?>()) {
      return (data != null ? _ibtxcndu.AiProvider.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ih3b4fxu.AiReply?>()) {
      return (data != null ? _ih3b4fxu.AiReply.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idsjcs1s.AiStatus?>()) {
      return (data != null ? _idsjcs1s.AiStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iojy8c5d.AiUsage?>()) {
      return (data != null ? _iojy8c5d.AiUsage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i73uehc4.BackupInfo?>()) {
      return (data != null ? _i73uehc4.BackupInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in8hkpoa.BackupOverview?>()) {
      return (data != null ? _in8hkpoa.BackupOverview.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ip4e316z.BalanceCheck?>()) {
      return (data != null ? _ip4e316z.BalanceCheck.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0mjlwv3.BankTransaction?>()) {
      return (data != null ? _i0mjlwv3.BankTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixjzi4yl.BudgetPeriod?>()) {
      return (data != null ? _ixjzi4yl.BudgetPeriod.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itcb21m0.CalendarItem?>()) {
      return (data != null ? _itcb21m0.CalendarItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_issw2w8j.Category?>()) {
      return (data != null ? _issw2w8j.Category.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iknjgrwa.CategoryChangeInfo?>()) {
      return (data != null ? _iknjgrwa.CategoryChangeInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8msyna2.CategoryFlow?>()) {
      return (data != null ? _i8msyna2.CategoryFlow.fromJson(data) : null) as T;
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
    if (t == _isc.getType<_ic7yhr4p.DueCalendar?>()) {
      return (data != null ? _ic7yhr4p.DueCalendar.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ind4b83h.EarlyRepayment?>()) {
      return (data != null ? _ind4b83h.EarlyRepayment.fromJson(data) : null)
          as T;
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
    if (t == _isc.getType<_ibqaulxu.Goal?>()) {
      return (data != null ? _ibqaulxu.Goal.fromJson(data) : null) as T;
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
    if (t == _isc.getType<_ia1npsti.InstalmentCandidate?>()) {
      return (data != null
              ? _ia1npsti.InstalmentCandidate.fromJson(data)
              : null)
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
    if (t == _isc.getType<_ifja8moh.Invoice?>()) {
      return (data != null ? _ifja8moh.Invoice.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0mnzbub.InvoiceBlob?>()) {
      return (data != null ? _i0mnzbub.InvoiceBlob.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_im7mm4oj.InvoiceInfo?>()) {
      return (data != null ? _im7mm4oj.InvoiceInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixgqo4yu.InvoiceMatch?>()) {
      return (data != null ? _ixgqo4yu.InvoiceMatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijfl1fdm.IpBanInfo?>()) {
      return (data != null ? _ijfl1fdm.IpBanInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibb3lpoc.LeftToLiveReport?>()) {
      return (data != null ? _ibb3lpoc.LeftToLiveReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7jednjp.Loan?>()) {
      return (data != null ? _i7jednjp.Loan.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixhwb2ta.LoanDocument?>()) {
      return (data != null ? _ixhwb2ta.LoanDocument.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i05ovdfs.LoanDocumentBlob?>()) {
      return (data != null ? _i05ovdfs.LoanDocumentBlob.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibgzxro1.LoanFromOperation?>()) {
      return (data != null ? _ibgzxro1.LoanFromOperation.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijbwwnsd.LoanInfo?>()) {
      return (data != null ? _ijbwwnsd.LoanInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ics9k3ng.LoanInstallment?>()) {
      return (data != null ? _ics9k3ng.LoanInstallment.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1700pxx.LoanKind?>()) {
      return (data != null ? _i1700pxx.LoanKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itnp0u8s.LoanOverview?>()) {
      return (data != null ? _itnp0u8s.LoanOverview.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibm9fvwa.McpToken?>()) {
      return (data != null ? _ibm9fvwa.McpToken.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iqv371vc.McpTokenCreated?>()) {
      return (data != null ? _iqv371vc.McpTokenCreated.fromJson(data) : null)
          as T;
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
    if (t == _isc.getType<_i5m4pdin.MonthReview?>()) {
      return (data != null ? _i5m4pdin.MonthReview.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irt10kca.AppNotification?>()) {
      return (data != null ? _irt10kca.AppNotification.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_it10dx4m.OccurrenceStatus?>()) {
      return (data != null ? _it10dx4m.OccurrenceStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_imctw77w.PeriodTotals?>()) {
      return (data != null ? _imctw77w.PeriodTotals.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irsxtgs7.ProviderHistory?>()) {
      return (data != null ? _irsxtgs7.ProviderHistory.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i46nnn14.PurchaseOption?>()) {
      return (data != null ? _i46nnn14.PurchaseOption.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i60c7zzl.PurchasePaymentInfo?>()) {
      return (data != null
              ? _i60c7zzl.PurchasePaymentInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_irvruma2.PurchaseScenarioInfo?>()) {
      return (data != null
              ? _irvruma2.PurchaseScenarioInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_idtt2l34.PurchaseSimulation?>()) {
      return (data != null ? _idtt2l34.PurchaseSimulation.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7qmkh8w.ReconciliationProposal?>()) {
      return (data != null
              ? _i7qmkh8w.ReconciliationProposal.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_idndmjo8.ReleaseNotes?>()) {
      return (data != null ? _idndmjo8.ReleaseNotes.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivw87pdb.Rule?>()) {
      return (data != null ? _ivw87pdb.Rule.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ie66uvh9.RuleApplication?>()) {
      return (data != null ? _ie66uvh9.RuleApplication.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i13yq1r7.RuleDirection?>()) {
      return (data != null ? _i13yq1r7.RuleDirection.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibgrh3pe.RuleMatchType?>()) {
      return (data != null ? _ibgrh3pe.RuleMatchType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ipgrn6yw.RuleTestResult?>()) {
      return (data != null ? _ipgrn6yw.RuleTestResult.fromJson(data) : null)
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
    if (t == _isc.getType<_ixcwyj5v.SpendingReport?>()) {
      return (data != null ? _ixcwyj5v.SpendingReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ia7wudj2.StatementImport?>()) {
      return (data != null ? _ia7wudj2.StatementImport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilnyaemj.SubscriptionChange?>()) {
      return (data != null ? _ilnyaemj.SubscriptionChange.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iliwwe2k.SubscriptionOverview?>()) {
      return (data != null
              ? _iliwwe2k.SubscriptionOverview.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iul1v2p7.TotpEnrollment?>()) {
      return (data != null ? _iul1v2p7.TotpEnrollment.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4rkvxa2.TransactionPage?>()) {
      return (data != null ? _i4rkvxa2.TransactionPage.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iqvm376u.TransactionSplit?>()) {
      return (data != null ? _iqvm376u.TransactionSplit.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igcslm1n.TwoFactorStatus?>()) {
      return (data != null ? _igcslm1n.TwoFactorStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idu38kh6.UpdateHistoryEntry?>()) {
      return (data != null ? _idu38kh6.UpdateHistoryEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv5yf7x0.UpdateOverview?>()) {
      return (data != null ? _iv5yf7x0.UpdateOverview.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ic7yx6at.VariableCategoryInfo?>()) {
      return (data != null
              ? _ic7yx6at.VariableCategoryInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_in08zzvs.VariableEstimateInfo?>()) {
      return (data != null
              ? _in08zzvs.VariableEstimateInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_insyygng.MemberRole>) {
      return (data as List)
              .map((e) => deserialize<_insyygng.MemberRole>(e))
              .toList()
          as T;
    }
    if (t == List<_ius3n358.ActionProposal>) {
      return (data as List)
              .map((e) => deserialize<_ius3n358.ActionProposal>(e))
              .toList()
          as T;
    }
    if (t == List<_ibtxcndu.AiProvider>) {
      return (data as List)
              .map((e) => deserialize<_ibtxcndu.AiProvider>(e))
              .toList()
          as T;
    }
    if (t == List<_i73uehc4.BackupInfo>) {
      return (data as List)
              .map((e) => deserialize<_i73uehc4.BackupInfo>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_itcb21m0.CalendarItem>) {
      return (data as List)
              .map((e) => deserialize<_itcb21m0.CalendarItem>(e))
              .toList()
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
    if (t == List<_ijbwwnsd.LoanInfo>) {
      return (data as List)
              .map((e) => deserialize<_ijbwwnsd.LoanInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_iknjgrwa.CategoryChangeInfo>) {
      return (data as List)
              .map((e) => deserialize<_iknjgrwa.CategoryChangeInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i8msyna2.CategoryFlow>) {
      return (data as List)
              .map((e) => deserialize<_i8msyna2.CategoryFlow>(e))
              .toList()
          as T;
    }
    if (t == List<_i0mjlwv3.BankTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i0mjlwv3.BankTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_ilnyaemj.SubscriptionChange>) {
      return (data as List)
              .map((e) => deserialize<_ilnyaemj.SubscriptionChange>(e))
              .toList()
          as T;
    }
    if (t == List<_ifol8nrg.ScheduledTransaction>) {
      return (data as List)
              .map((e) => deserialize<_ifol8nrg.ScheduledTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i60c7zzl.PurchasePaymentInfo>) {
      return (data as List)
              .map((e) => deserialize<_i60c7zzl.PurchasePaymentInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_irvruma2.PurchaseScenarioInfo>) {
      return (data as List)
              .map((e) => deserialize<_irvruma2.PurchaseScenarioInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_imctw77w.PeriodTotals>) {
      return (data as List)
              .map((e) => deserialize<_imctw77w.PeriodTotals>(e))
              .toList()
          as T;
    }
    if (t == List<_idu38kh6.UpdateHistoryEntry>) {
      return (data as List)
              .map((e) => deserialize<_idu38kh6.UpdateHistoryEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_idndmjo8.ReleaseNotes>) {
      return (data as List)
              .map((e) => deserialize<_idndmjo8.ReleaseNotes>(e))
              .toList()
          as T;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList() as T;
    }
    if (t == List<_ic7yx6at.VariableCategoryInfo>) {
      return (data as List)
              .map((e) => deserialize<_ic7yx6at.VariableCategoryInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i4motmly.Account>) {
      return (data as List)
              .map((e) => deserialize<_i4motmly.Account>(e))
              .toList()
          as T;
    }
    if (t == List<_ifxnt0qj.BalanceCheck>) {
      return (data as List)
              .map((e) => deserialize<_ifxnt0qj.BalanceCheck>(e))
              .toList()
          as T;
    }
    if (t == List<_ivw6xhv3.IpBanInfo>) {
      return (data as List)
              .map((e) => deserialize<_ivw6xhv3.IpBanInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i4kcqb5h.AdminUserInfo>) {
      return (data as List)
              .map((e) => deserialize<_i4kcqb5h.AdminUserInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_icr6cafh.AdminAuditInfo>) {
      return (data as List)
              .map((e) => deserialize<_icr6cafh.AdminAuditInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_iq49mcaz.AdminGroupInfo>) {
      return (data as List)
              .map((e) => deserialize<_iq49mcaz.AdminGroupInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_idjaxr3o.AdminInvitationInfo>) {
      return (data as List)
              .map((e) => deserialize<_idjaxr3o.AdminInvitationInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_ihgp0l1x.ActionProposal>) {
      return (data as List)
              .map((e) => deserialize<_ihgp0l1x.ActionProposal>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iarsdlqt.AiMessage>) {
      return (data as List)
              .map((e) => deserialize<_iarsdlqt.AiMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_ivksw0b3.BankTransaction>) {
      return (data as List)
              .map((e) => deserialize<_ivksw0b3.BankTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i37qqsjr.Category>) {
      return (data as List)
              .map((e) => deserialize<_i37qqsjr.Category>(e))
              .toList()
          as T;
    }
    if (t == List<_ita8uvsc.Goal>) {
      return (data as List).map((e) => deserialize<_ita8uvsc.Goal>(e)).toList()
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
    if (t == List<_iej1c1us.InvoiceInfo>) {
      return (data as List)
              .map((e) => deserialize<_iej1c1us.InvoiceInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_ikyjg3a9.InvoiceMatch>) {
      return (data as List)
              .map((e) => deserialize<_ikyjg3a9.InvoiceMatch>(e))
              .toList()
          as T;
    }
    if (t == List<_io211e4m.InstalmentCandidate>) {
      return (data as List)
              .map((e) => deserialize<_io211e4m.InstalmentCandidate>(e))
              .toList()
          as T;
    }
    if (t == List<_i18weoko.LoanInstallment>) {
      return (data as List)
              .map((e) => deserialize<_i18weoko.LoanInstallment>(e))
              .toList()
          as T;
    }
    if (t == List<_ixzu9i3x.LoanDocument>) {
      return (data as List)
              .map((e) => deserialize<_ixzu9i3x.LoanDocument>(e))
              .toList()
          as T;
    }
    if (t == List<_ioxkfsho.McpToken>) {
      return (data as List)
              .map((e) => deserialize<_ioxkfsho.McpToken>(e))
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
    if (t == List<_idy91hap.TransactionSplit>) {
      return (data as List)
              .map((e) => deserialize<_idy91hap.TransactionSplit>(e))
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
      _ius3n358.ActionProposal => 'ActionProposal',
      _ie0chd06.AdminAuditInfo => 'AdminAuditInfo',
      _ixpxctu5.AdminGroupInfo => 'AdminGroupInfo',
      _ihbeufm3.AdminHealth => 'AdminHealth',
      _ib01m0m7.AdminInvitationInfo => 'AdminInvitationInfo',
      _iqygks5s.AdminStats => 'AdminStats',
      _is8wfuq8.AdminUserInfo => 'AdminUserInfo',
      _ikwoa06z.AiMessage => 'AiMessage',
      _i5zygq2d.AiPreference => 'AiPreference',
      _ibtxcndu.AiProvider => 'AiProvider',
      _ih3b4fxu.AiReply => 'AiReply',
      _idsjcs1s.AiStatus => 'AiStatus',
      _iojy8c5d.AiUsage => 'AiUsage',
      _i73uehc4.BackupInfo => 'BackupInfo',
      _in8hkpoa.BackupOverview => 'BackupOverview',
      _ip4e316z.BalanceCheck => 'BalanceCheck',
      _i0mjlwv3.BankTransaction => 'BankTransaction',
      _ixjzi4yl.BudgetPeriod => 'BudgetPeriod',
      _itcb21m0.CalendarItem => 'CalendarItem',
      _issw2w8j.Category => 'Category',
      _iknjgrwa.CategoryChangeInfo => 'CategoryChangeInfo',
      _i8msyna2.CategoryFlow => 'CategoryFlow',
      _i7kso3nf.CategoryKind => 'CategoryKind',
      _idpjit5g.CategorySource => 'CategorySource',
      _igloa2c5.CommunityRule => 'CommunityRule',
      _iq9wp9wq.CsvColumns => 'CsvColumns',
      _ic7yhr4p.DueCalendar => 'DueCalendar',
      _ind4b83h.EarlyRepayment => 'EarlyRepayment',
      _iqh5irlt.FinanceGroup => 'FinanceGroup',
      _ids0ngao.ForecastDay => 'ForecastDay',
      _iuscnr1n.ForecastEventInfo => 'ForecastEventInfo',
      _idemr8ki.ForecastResult => 'ForecastResult',
      _ixycnzxw.ScheduleFrequency => 'ScheduleFrequency',
      _ibqaulxu.Goal => 'Goal',
      _igiek2ee.GroupMember => 'GroupMember',
      _i54nduyh.GroupMembership => 'GroupMembership',
      _iso7nf03.ImportIssueInfo => 'ImportIssueInfo',
      _im8lwq6n.ImportPreview => 'ImportPreview',
      _i4e8elxc.ImportPreviewLine => 'ImportPreviewLine',
      _ia1npsti.InstalmentCandidate => 'InstalmentCandidate',
      _ijc83d8f.InvalidInputException => 'InvalidInputException',
      _i9hwipt6.InvitationInfo => 'InvitationInfo',
      _ifja8moh.Invoice => 'Invoice',
      _i0mnzbub.InvoiceBlob => 'InvoiceBlob',
      _im7mm4oj.InvoiceInfo => 'InvoiceInfo',
      _ixgqo4yu.InvoiceMatch => 'InvoiceMatch',
      _ijfl1fdm.IpBanInfo => 'IpBanInfo',
      _ibb3lpoc.LeftToLiveReport => 'LeftToLiveReport',
      _i7jednjp.Loan => 'Loan',
      _ixhwb2ta.LoanDocument => 'LoanDocument',
      _i05ovdfs.LoanDocumentBlob => 'LoanDocumentBlob',
      _ibgzxro1.LoanFromOperation => 'LoanFromOperation',
      _ijbwwnsd.LoanInfo => 'LoanInfo',
      _ics9k3ng.LoanInstallment => 'LoanInstallment',
      _i1700pxx.LoanKind => 'LoanKind',
      _itnp0u8s.LoanOverview => 'LoanOverview',
      _ibm9fvwa.McpToken => 'McpToken',
      _iqv371vc.McpTokenCreated => 'McpTokenCreated',
      _i2slp771.MemberInfo => 'MemberInfo',
      _insyygng.MemberRole => 'MemberRole',
      _ifjtpr6l.MissedOccurrenceInfo => 'MissedOccurrenceInfo',
      _i5m4pdin.MonthReview => 'MonthReview',
      _irt10kca.AppNotification => 'AppNotification',
      _it10dx4m.OccurrenceStatus => 'OccurrenceStatus',
      _imctw77w.PeriodTotals => 'PeriodTotals',
      _irsxtgs7.ProviderHistory => 'ProviderHistory',
      _i46nnn14.PurchaseOption => 'PurchaseOption',
      _i60c7zzl.PurchasePaymentInfo => 'PurchasePaymentInfo',
      _irvruma2.PurchaseScenarioInfo => 'PurchaseScenarioInfo',
      _idtt2l34.PurchaseSimulation => 'PurchaseSimulation',
      _i7qmkh8w.ReconciliationProposal => 'ReconciliationProposal',
      _idndmjo8.ReleaseNotes => 'ReleaseNotes',
      _ivw87pdb.Rule => 'Rule',
      _ie66uvh9.RuleApplication => 'RuleApplication',
      _i13yq1r7.RuleDirection => 'RuleDirection',
      _ibgrh3pe.RuleMatchType => 'RuleMatchType',
      _ipgrn6yw.RuleTestResult => 'RuleTestResult',
      _ifol8nrg.ScheduledTransaction => 'ScheduledTransaction',
      _iw7q1xsb.SetupStatus => 'SetupStatus',
      _ixcwyj5v.SpendingReport => 'SpendingReport',
      _ia7wudj2.StatementImport => 'StatementImport',
      _ilnyaemj.SubscriptionChange => 'SubscriptionChange',
      _iliwwe2k.SubscriptionOverview => 'SubscriptionOverview',
      _iul1v2p7.TotpEnrollment => 'TotpEnrollment',
      _i4rkvxa2.TransactionPage => 'TransactionPage',
      _iqvm376u.TransactionSplit => 'TransactionSplit',
      _igcslm1n.TwoFactorStatus => 'TwoFactorStatus',
      _idu38kh6.UpdateHistoryEntry => 'UpdateHistoryEntry',
      _iv5yf7x0.UpdateOverview => 'UpdateOverview',
      _ic7yx6at.VariableCategoryInfo => 'VariableCategoryInfo',
      _in08zzvs.VariableEstimateInfo => 'VariableEstimateInfo',
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
      case _ius3n358.ActionProposal():
        return 'ActionProposal';
      case _ie0chd06.AdminAuditInfo():
        return 'AdminAuditInfo';
      case _ixpxctu5.AdminGroupInfo():
        return 'AdminGroupInfo';
      case _ihbeufm3.AdminHealth():
        return 'AdminHealth';
      case _ib01m0m7.AdminInvitationInfo():
        return 'AdminInvitationInfo';
      case _iqygks5s.AdminStats():
        return 'AdminStats';
      case _is8wfuq8.AdminUserInfo():
        return 'AdminUserInfo';
      case _ikwoa06z.AiMessage():
        return 'AiMessage';
      case _i5zygq2d.AiPreference():
        return 'AiPreference';
      case _ibtxcndu.AiProvider():
        return 'AiProvider';
      case _ih3b4fxu.AiReply():
        return 'AiReply';
      case _idsjcs1s.AiStatus():
        return 'AiStatus';
      case _iojy8c5d.AiUsage():
        return 'AiUsage';
      case _i73uehc4.BackupInfo():
        return 'BackupInfo';
      case _in8hkpoa.BackupOverview():
        return 'BackupOverview';
      case _ip4e316z.BalanceCheck():
        return 'BalanceCheck';
      case _i0mjlwv3.BankTransaction():
        return 'BankTransaction';
      case _ixjzi4yl.BudgetPeriod():
        return 'BudgetPeriod';
      case _itcb21m0.CalendarItem():
        return 'CalendarItem';
      case _issw2w8j.Category():
        return 'Category';
      case _iknjgrwa.CategoryChangeInfo():
        return 'CategoryChangeInfo';
      case _i8msyna2.CategoryFlow():
        return 'CategoryFlow';
      case _i7kso3nf.CategoryKind():
        return 'CategoryKind';
      case _idpjit5g.CategorySource():
        return 'CategorySource';
      case _igloa2c5.CommunityRule():
        return 'CommunityRule';
      case _iq9wp9wq.CsvColumns():
        return 'CsvColumns';
      case _ic7yhr4p.DueCalendar():
        return 'DueCalendar';
      case _ind4b83h.EarlyRepayment():
        return 'EarlyRepayment';
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
      case _ibqaulxu.Goal():
        return 'Goal';
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
      case _ia1npsti.InstalmentCandidate():
        return 'InstalmentCandidate';
      case _ijc83d8f.InvalidInputException():
        return 'InvalidInputException';
      case _i9hwipt6.InvitationInfo():
        return 'InvitationInfo';
      case _ifja8moh.Invoice():
        return 'Invoice';
      case _i0mnzbub.InvoiceBlob():
        return 'InvoiceBlob';
      case _im7mm4oj.InvoiceInfo():
        return 'InvoiceInfo';
      case _ixgqo4yu.InvoiceMatch():
        return 'InvoiceMatch';
      case _ijfl1fdm.IpBanInfo():
        return 'IpBanInfo';
      case _ibb3lpoc.LeftToLiveReport():
        return 'LeftToLiveReport';
      case _i7jednjp.Loan():
        return 'Loan';
      case _ixhwb2ta.LoanDocument():
        return 'LoanDocument';
      case _i05ovdfs.LoanDocumentBlob():
        return 'LoanDocumentBlob';
      case _ibgzxro1.LoanFromOperation():
        return 'LoanFromOperation';
      case _ijbwwnsd.LoanInfo():
        return 'LoanInfo';
      case _ics9k3ng.LoanInstallment():
        return 'LoanInstallment';
      case _i1700pxx.LoanKind():
        return 'LoanKind';
      case _itnp0u8s.LoanOverview():
        return 'LoanOverview';
      case _ibm9fvwa.McpToken():
        return 'McpToken';
      case _iqv371vc.McpTokenCreated():
        return 'McpTokenCreated';
      case _i2slp771.MemberInfo():
        return 'MemberInfo';
      case _insyygng.MemberRole():
        return 'MemberRole';
      case _ifjtpr6l.MissedOccurrenceInfo():
        return 'MissedOccurrenceInfo';
      case _i5m4pdin.MonthReview():
        return 'MonthReview';
      case _irt10kca.AppNotification():
        return 'AppNotification';
      case _it10dx4m.OccurrenceStatus():
        return 'OccurrenceStatus';
      case _imctw77w.PeriodTotals():
        return 'PeriodTotals';
      case _irsxtgs7.ProviderHistory():
        return 'ProviderHistory';
      case _i46nnn14.PurchaseOption():
        return 'PurchaseOption';
      case _i60c7zzl.PurchasePaymentInfo():
        return 'PurchasePaymentInfo';
      case _irvruma2.PurchaseScenarioInfo():
        return 'PurchaseScenarioInfo';
      case _idtt2l34.PurchaseSimulation():
        return 'PurchaseSimulation';
      case _i7qmkh8w.ReconciliationProposal():
        return 'ReconciliationProposal';
      case _idndmjo8.ReleaseNotes():
        return 'ReleaseNotes';
      case _ivw87pdb.Rule():
        return 'Rule';
      case _ie66uvh9.RuleApplication():
        return 'RuleApplication';
      case _i13yq1r7.RuleDirection():
        return 'RuleDirection';
      case _ibgrh3pe.RuleMatchType():
        return 'RuleMatchType';
      case _ipgrn6yw.RuleTestResult():
        return 'RuleTestResult';
      case _ifol8nrg.ScheduledTransaction():
        return 'ScheduledTransaction';
      case _iw7q1xsb.SetupStatus():
        return 'SetupStatus';
      case _ixcwyj5v.SpendingReport():
        return 'SpendingReport';
      case _ia7wudj2.StatementImport():
        return 'StatementImport';
      case _ilnyaemj.SubscriptionChange():
        return 'SubscriptionChange';
      case _iliwwe2k.SubscriptionOverview():
        return 'SubscriptionOverview';
      case _iul1v2p7.TotpEnrollment():
        return 'TotpEnrollment';
      case _i4rkvxa2.TransactionPage():
        return 'TransactionPage';
      case _iqvm376u.TransactionSplit():
        return 'TransactionSplit';
      case _igcslm1n.TwoFactorStatus():
        return 'TwoFactorStatus';
      case _idu38kh6.UpdateHistoryEntry():
        return 'UpdateHistoryEntry';
      case _iv5yf7x0.UpdateOverview():
        return 'UpdateOverview';
      case _ic7yx6at.VariableCategoryInfo():
        return 'VariableCategoryInfo';
      case _in08zzvs.VariableEstimateInfo():
        return 'VariableEstimateInfo';
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
    if (dataClassName == 'ActionProposal') {
      return deserialize<_ius3n358.ActionProposal>(data['data']);
    }
    if (dataClassName == 'AdminAuditInfo') {
      return deserialize<_ie0chd06.AdminAuditInfo>(data['data']);
    }
    if (dataClassName == 'AdminGroupInfo') {
      return deserialize<_ixpxctu5.AdminGroupInfo>(data['data']);
    }
    if (dataClassName == 'AdminHealth') {
      return deserialize<_ihbeufm3.AdminHealth>(data['data']);
    }
    if (dataClassName == 'AdminInvitationInfo') {
      return deserialize<_ib01m0m7.AdminInvitationInfo>(data['data']);
    }
    if (dataClassName == 'AdminStats') {
      return deserialize<_iqygks5s.AdminStats>(data['data']);
    }
    if (dataClassName == 'AdminUserInfo') {
      return deserialize<_is8wfuq8.AdminUserInfo>(data['data']);
    }
    if (dataClassName == 'AiMessage') {
      return deserialize<_ikwoa06z.AiMessage>(data['data']);
    }
    if (dataClassName == 'AiPreference') {
      return deserialize<_i5zygq2d.AiPreference>(data['data']);
    }
    if (dataClassName == 'AiProvider') {
      return deserialize<_ibtxcndu.AiProvider>(data['data']);
    }
    if (dataClassName == 'AiReply') {
      return deserialize<_ih3b4fxu.AiReply>(data['data']);
    }
    if (dataClassName == 'AiStatus') {
      return deserialize<_idsjcs1s.AiStatus>(data['data']);
    }
    if (dataClassName == 'AiUsage') {
      return deserialize<_iojy8c5d.AiUsage>(data['data']);
    }
    if (dataClassName == 'BackupInfo') {
      return deserialize<_i73uehc4.BackupInfo>(data['data']);
    }
    if (dataClassName == 'BackupOverview') {
      return deserialize<_in8hkpoa.BackupOverview>(data['data']);
    }
    if (dataClassName == 'BalanceCheck') {
      return deserialize<_ip4e316z.BalanceCheck>(data['data']);
    }
    if (dataClassName == 'BankTransaction') {
      return deserialize<_i0mjlwv3.BankTransaction>(data['data']);
    }
    if (dataClassName == 'BudgetPeriod') {
      return deserialize<_ixjzi4yl.BudgetPeriod>(data['data']);
    }
    if (dataClassName == 'CalendarItem') {
      return deserialize<_itcb21m0.CalendarItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_issw2w8j.Category>(data['data']);
    }
    if (dataClassName == 'CategoryChangeInfo') {
      return deserialize<_iknjgrwa.CategoryChangeInfo>(data['data']);
    }
    if (dataClassName == 'CategoryFlow') {
      return deserialize<_i8msyna2.CategoryFlow>(data['data']);
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
    if (dataClassName == 'DueCalendar') {
      return deserialize<_ic7yhr4p.DueCalendar>(data['data']);
    }
    if (dataClassName == 'EarlyRepayment') {
      return deserialize<_ind4b83h.EarlyRepayment>(data['data']);
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
    if (dataClassName == 'Goal') {
      return deserialize<_ibqaulxu.Goal>(data['data']);
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
    if (dataClassName == 'InstalmentCandidate') {
      return deserialize<_ia1npsti.InstalmentCandidate>(data['data']);
    }
    if (dataClassName == 'InvalidInputException') {
      return deserialize<_ijc83d8f.InvalidInputException>(data['data']);
    }
    if (dataClassName == 'InvitationInfo') {
      return deserialize<_i9hwipt6.InvitationInfo>(data['data']);
    }
    if (dataClassName == 'Invoice') {
      return deserialize<_ifja8moh.Invoice>(data['data']);
    }
    if (dataClassName == 'InvoiceBlob') {
      return deserialize<_i0mnzbub.InvoiceBlob>(data['data']);
    }
    if (dataClassName == 'InvoiceInfo') {
      return deserialize<_im7mm4oj.InvoiceInfo>(data['data']);
    }
    if (dataClassName == 'InvoiceMatch') {
      return deserialize<_ixgqo4yu.InvoiceMatch>(data['data']);
    }
    if (dataClassName == 'IpBanInfo') {
      return deserialize<_ijfl1fdm.IpBanInfo>(data['data']);
    }
    if (dataClassName == 'LeftToLiveReport') {
      return deserialize<_ibb3lpoc.LeftToLiveReport>(data['data']);
    }
    if (dataClassName == 'Loan') {
      return deserialize<_i7jednjp.Loan>(data['data']);
    }
    if (dataClassName == 'LoanDocument') {
      return deserialize<_ixhwb2ta.LoanDocument>(data['data']);
    }
    if (dataClassName == 'LoanDocumentBlob') {
      return deserialize<_i05ovdfs.LoanDocumentBlob>(data['data']);
    }
    if (dataClassName == 'LoanFromOperation') {
      return deserialize<_ibgzxro1.LoanFromOperation>(data['data']);
    }
    if (dataClassName == 'LoanInfo') {
      return deserialize<_ijbwwnsd.LoanInfo>(data['data']);
    }
    if (dataClassName == 'LoanInstallment') {
      return deserialize<_ics9k3ng.LoanInstallment>(data['data']);
    }
    if (dataClassName == 'LoanKind') {
      return deserialize<_i1700pxx.LoanKind>(data['data']);
    }
    if (dataClassName == 'LoanOverview') {
      return deserialize<_itnp0u8s.LoanOverview>(data['data']);
    }
    if (dataClassName == 'McpToken') {
      return deserialize<_ibm9fvwa.McpToken>(data['data']);
    }
    if (dataClassName == 'McpTokenCreated') {
      return deserialize<_iqv371vc.McpTokenCreated>(data['data']);
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
    if (dataClassName == 'MonthReview') {
      return deserialize<_i5m4pdin.MonthReview>(data['data']);
    }
    if (dataClassName == 'AppNotification') {
      return deserialize<_irt10kca.AppNotification>(data['data']);
    }
    if (dataClassName == 'OccurrenceStatus') {
      return deserialize<_it10dx4m.OccurrenceStatus>(data['data']);
    }
    if (dataClassName == 'PeriodTotals') {
      return deserialize<_imctw77w.PeriodTotals>(data['data']);
    }
    if (dataClassName == 'ProviderHistory') {
      return deserialize<_irsxtgs7.ProviderHistory>(data['data']);
    }
    if (dataClassName == 'PurchaseOption') {
      return deserialize<_i46nnn14.PurchaseOption>(data['data']);
    }
    if (dataClassName == 'PurchasePaymentInfo') {
      return deserialize<_i60c7zzl.PurchasePaymentInfo>(data['data']);
    }
    if (dataClassName == 'PurchaseScenarioInfo') {
      return deserialize<_irvruma2.PurchaseScenarioInfo>(data['data']);
    }
    if (dataClassName == 'PurchaseSimulation') {
      return deserialize<_idtt2l34.PurchaseSimulation>(data['data']);
    }
    if (dataClassName == 'ReconciliationProposal') {
      return deserialize<_i7qmkh8w.ReconciliationProposal>(data['data']);
    }
    if (dataClassName == 'ReleaseNotes') {
      return deserialize<_idndmjo8.ReleaseNotes>(data['data']);
    }
    if (dataClassName == 'Rule') {
      return deserialize<_ivw87pdb.Rule>(data['data']);
    }
    if (dataClassName == 'RuleApplication') {
      return deserialize<_ie66uvh9.RuleApplication>(data['data']);
    }
    if (dataClassName == 'RuleDirection') {
      return deserialize<_i13yq1r7.RuleDirection>(data['data']);
    }
    if (dataClassName == 'RuleMatchType') {
      return deserialize<_ibgrh3pe.RuleMatchType>(data['data']);
    }
    if (dataClassName == 'RuleTestResult') {
      return deserialize<_ipgrn6yw.RuleTestResult>(data['data']);
    }
    if (dataClassName == 'ScheduledTransaction') {
      return deserialize<_ifol8nrg.ScheduledTransaction>(data['data']);
    }
    if (dataClassName == 'SetupStatus') {
      return deserialize<_iw7q1xsb.SetupStatus>(data['data']);
    }
    if (dataClassName == 'SpendingReport') {
      return deserialize<_ixcwyj5v.SpendingReport>(data['data']);
    }
    if (dataClassName == 'StatementImport') {
      return deserialize<_ia7wudj2.StatementImport>(data['data']);
    }
    if (dataClassName == 'SubscriptionChange') {
      return deserialize<_ilnyaemj.SubscriptionChange>(data['data']);
    }
    if (dataClassName == 'SubscriptionOverview') {
      return deserialize<_iliwwe2k.SubscriptionOverview>(data['data']);
    }
    if (dataClassName == 'TotpEnrollment') {
      return deserialize<_iul1v2p7.TotpEnrollment>(data['data']);
    }
    if (dataClassName == 'TransactionPage') {
      return deserialize<_i4rkvxa2.TransactionPage>(data['data']);
    }
    if (dataClassName == 'TransactionSplit') {
      return deserialize<_iqvm376u.TransactionSplit>(data['data']);
    }
    if (dataClassName == 'TwoFactorStatus') {
      return deserialize<_igcslm1n.TwoFactorStatus>(data['data']);
    }
    if (dataClassName == 'UpdateHistoryEntry') {
      return deserialize<_idu38kh6.UpdateHistoryEntry>(data['data']);
    }
    if (dataClassName == 'UpdateOverview') {
      return deserialize<_iv5yf7x0.UpdateOverview>(data['data']);
    }
    if (dataClassName == 'VariableCategoryInfo') {
      return deserialize<_ic7yx6at.VariableCategoryInfo>(data['data']);
    }
    if (dataClassName == 'VariableEstimateInfo') {
      return deserialize<_in08zzvs.VariableEstimateInfo>(data['data']);
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
