import 'package:owncoffer_client/owncoffer_client.dart';

import 'app_localizations.dart';

/// User-facing text for a server error code (AccessDeniedException and
/// InvalidInputException codes). Unknown codes fall back to a generic text.
String serverErrorText(AppLocalizations l, String code) => switch (code) {
  'not_authenticated' => l.error_not_authenticated,
  'group_access_denied' => l.error_group_access_denied,
  'account_access_denied' => l.error_account_access_denied,
  'server_admin_only' => l.error_server_admin_only,
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
  'two_factor_required' => l.error_two_factor_required,
  'two_factor_code_invalid' => l.error_two_factor_code_invalid,
  'two_factor_already_enabled' => l.error_two_factor_already_enabled,
  'two_factor_not_started' => l.error_two_factor_not_started,
  _ => l.error_generic,
};

/// User-facing text for any error thrown by a server call.
String errorText(AppLocalizations l, Object error) => switch (error) {
  AccessDeniedException(:final code) => serverErrorText(l, code),
  InvalidInputException(:final code) => serverErrorText(l, code),
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
