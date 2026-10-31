import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'app_localizations.dart';

/// User-facing text for a server error code (AccessDeniedException and
/// InvalidInputException codes). Unknown codes fall back to a generic text.
String serverErrorText(AppLocalizations l, String code) => switch (code) {
  'not_authenticated' => l.error_not_authenticated,
  'group_access_denied' => l.error_group_access_denied,
  'account_access_denied' => l.error_account_access_denied,
  'server_admin_only' => l.error_server_admin_only,
  'cannot_block_self' => l.error_cannot_block_self,
  'user_not_found' => l.error_user_not_found,
  'mail_failed' => l.error_mail_failed,
  'invalid_name' => l.error_invalid_name,
  'invalid_email' => l.error_invalid_email,
  'amount_out_of_range' => l.error_amount_out_of_range,
  'last_admin' => l.error_last_admin,
  'not_a_member' => l.error_not_a_member,
  'setup_done' => l.error_setup_done,
  'setup_code_invalid' => l.error_setup_code_invalid,
  'registration_closed' => l.error_registration_closed,
  'invitation_invalid' => l.error_invitation_invalid,
  'invitation_other_email' => l.error_invitation_other_email,
  'notification_access_denied' => l.error_notification_access_denied,
  'two_factor_required' => l.error_two_factor_required,
  'two_factor_code_invalid' => l.error_two_factor_code_invalid,
  'two_factor_already_enabled' => l.error_two_factor_already_enabled,
  'two_factor_not_started' => l.error_two_factor_not_started,
  'category_access_denied' => l.error_category_access_denied,
  'rule_access_denied' => l.error_rule_access_denied,
  'unknown_standard_category' => l.error_unknown_standard_category,
  'invalid_pattern' => l.error_invalid_pattern,
  'invalid_amount_range' => l.error_invalid_amount_range,
  'invalid_amount' => l.error_invalid_amount,
  'import_file_too_large' => l.error_import_file_too_large,
  'import_nothing_readable' => l.error_import_nothing_readable,
  'import_access_denied' => l.error_import_access_denied,
  'scheduled_access_denied' => l.error_scheduled_access_denied,
  'invalid_interval' => l.error_invalid_interval,
  'invalid_tolerance' => l.error_invalid_tolerance,
  'invalid_recurrence' => l.error_invalid_recurrence,
  'invalid_date' => l.error_invalid_date,
  'invalid_horizon' => l.error_invalid_horizon,
  'transaction_access_denied' => l.error_transaction_access_denied,
  'imported_operation_locked' => l.error_imported_operation_locked,
  'already_imported_again' => l.error_already_imported_again,
  'goal_expense_only' => l.error_goal_expense_only,
  'loan_access_denied' => l.error_loan_access_denied,
  'loan_terms_invalid' => l.error_loan_terms_invalid,
  'loan_needs_debit' => l.error_loan_needs_debit,
  'split_invalid' => l.error_split_invalid,
  'loan_other_account' => l.error_loan_other_account,
  'document_too_large' => l.error_document_too_large,
  'document_type' => l.error_document_type,
  'document_limit' => l.error_document_limit,
  'invalid_month_start_day' => l.error_invalid_month_start_day,
  // File format errors of shared/ come prefixed with `import_`.
  _ when code.startsWith('import_') => importFormatText(l, code.substring(7)),
  _ => l.error_generic,
};

/// User-facing text for any error thrown by a server call.
String errorText(AppLocalizations l, Object error) => switch (error) {
  AccessDeniedException(:final code) => serverErrorText(l, code),
  InvalidInputException(:final code) => serverErrorText(l, code),
  EmailAccountLoginException(:final reason) => switch (reason) {
    EmailAccountLoginExceptionReason.tooManyAttempts =>
      l.error_too_many_attempts,
    _ => l.error_login_failed,
  },
  EmailAccountRequestException(:final reason) => _codeReason(l, reason.name),
  EmailAccountPasswordResetException(:final reason) => _codeReason(
    l,
    reason.name,
  ),
  ServerpodClientForbidden() => l.error_ip_banned,
  ServerpodClientHttpException(:final statusCode) when statusCode == 429 =>
    l.error_rate_limited,
  ServerpodClientNetworkException() => l.error_network,
  _ => l.error_generic,
};

String _codeReason(AppLocalizations l, String reason) => switch (reason) {
  'expired' => l.error_code_expired,
  'invalid' => l.error_code_invalid,
  'policyViolation' => l.error_password_policy,
  'tooManyAttempts' => l.error_too_many_attempts,
  _ => l.error_generic,
};

/// Text for a problem found while reading a bank file (shared ImportIssue).
String importIssueText(AppLocalizations l, String code, int line) =>
    switch (code) {
      'missing_date' => l.import_error_missing_date(line),
      'invalid_date' => l.import_error_invalid_date(line),
      'missing_amount' => l.import_error_missing_amount(line),
      'invalid_amount' => l.import_error_invalid_amount(line),
      'debit_and_credit' => l.import_error_debit_and_credit(line),
      'missing_label' => l.import_error_missing_label(line),
      'qif_missing_end' => l.import_error_qif_missing_end(line),
      'qif_section_skipped' => l.import_error_qif_section_skipped(line),
      'qif_split_ignored' => l.import_error_qif_split_ignored(line),
      'ofx_balance_unreadable' => l.import_error_ofx_balance_unreadable(line),
      _ => l.error_generic,
    };

/// Text for a file that cannot be read at all (StatementFormatException).
String importFormatText(AppLocalizations l, String code) => switch (code) {
  'qif_no_header' => l.import_format_qif_no_header,
  'ofx_no_root' => l.import_format_ofx_no_root,
  'csv_columns_unknown' => l.import_format_csv_columns_unknown,
  'empty_file' => l.import_format_empty_file,
  'unknown_format' => l.import_format_unknown_format,
  _ => l.error_generic,
};
