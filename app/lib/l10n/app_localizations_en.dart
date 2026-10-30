// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OwnCoffer';

  @override
  String get signOut => 'Sign out';

  @override
  String get language => 'Language';

  @override
  String get error_generic => 'Something went wrong. Please try again.';

  @override
  String get error_not_authenticated =>
      'Your session has expired. Please sign in again.';

  @override
  String get error_group_access_denied =>
      'This group does not exist or you cannot access it.';

  @override
  String get error_account_access_denied =>
      'This account does not exist or you cannot access it.';

  @override
  String get error_server_admin_only =>
      'Only the server administrator can do this.';

  @override
  String get error_invalid_name => 'The name must be 1 to 80 characters long.';

  @override
  String get error_invalid_email => 'This email address is not valid.';

  @override
  String get error_amount_out_of_range => 'This amount is too large.';

  @override
  String get error_last_admin =>
      'The group must keep at least one administrator.';

  @override
  String get error_not_a_member => 'This person is not a member of the group.';

  @override
  String get error_setup_done => 'The server is already set up.';

  @override
  String get error_setup_code_invalid =>
      'Wrong setup code. It is shown in the server log.';

  @override
  String get error_registration_closed => 'Sign-up is by invitation only.';

  @override
  String get error_invitation_invalid => 'This invitation is no longer valid.';

  @override
  String get error_invitation_other_email =>
      'This invitation was sent to another email address.';

  @override
  String get error_two_factor_required =>
      'Please enter your two-factor authentication code first.';

  @override
  String get error_two_factor_code_invalid => 'Wrong or already used code.';

  @override
  String get error_two_factor_already_enabled =>
      'Two-factor authentication is already enabled.';

  @override
  String get error_two_factor_not_started =>
      'Start by scanning the QR code with your app.';

  @override
  String import_error_missing_date(int line) {
    return 'Line $line: missing date';
  }

  @override
  String import_error_invalid_date(int line) {
    return 'Line $line: unreadable date';
  }

  @override
  String import_error_missing_amount(int line) {
    return 'Line $line: missing amount';
  }

  @override
  String import_error_invalid_amount(int line) {
    return 'Line $line: unreadable amount';
  }

  @override
  String import_error_debit_and_credit(int line) {
    return 'Line $line: both debit and credit are filled in';
  }

  @override
  String import_error_missing_label(int line) {
    return 'Line $line: missing label';
  }

  @override
  String import_error_qif_missing_end(int line) {
    return 'Line $line: missing end of record';
  }

  @override
  String import_error_qif_section_skipped(int line) {
    return 'Line $line: section skipped';
  }

  @override
  String import_error_qif_split_ignored(int line) {
    return 'Line $line: split ignored, only the total is imported';
  }

  @override
  String import_error_ofx_balance_unreadable(int line) {
    return 'Line $line: unreadable bank balance';
  }

  @override
  String get import_format_qif_no_header =>
      'This QIF file has no \"!Type\" header.';

  @override
  String get import_format_ofx_no_root => 'This OFX file is incomplete.';

  @override
  String get import_format_csv_columns_unknown =>
      'Columns not recognised: please choose them.';

  @override
  String get import_format_empty_file => 'The file is empty.';

  @override
  String get import_format_unknown_format =>
      'Unknown format. Accepted formats: QIF, OFX, CSV.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Retry';

  @override
  String get emailLabel => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordConfirmLabel => 'Confirm password';

  @override
  String get passwordHelp => 'At least 8 characters.';

  @override
  String get passwordsDiffer => 'The two passwords are different.';

  @override
  String get verificationCodeLabel => 'Code received by email';

  @override
  String get verificationCodeHelp =>
      'Without an email server configured, the code is shown in the server log.';

  @override
  String get setupTitle => 'OwnCoffer setup';

  @override
  String get setupIntro =>
      'Welcome! Create the administrator account of this server.';

  @override
  String get setupCodeLabel => 'Setup code';

  @override
  String get setupCodeHelp =>
      '8-digit code shown in the server log: docker compose logs owncoffer | grep \"setup code\"';

  @override
  String get setupStepAdmin => 'Administrator';

  @override
  String get setupStepVerify => 'Verification';

  @override
  String get setupStepPassword => 'Password';

  @override
  String get setupStepGroup => 'Group';

  @override
  String verifyIntro(String email) {
    return 'A code was sent to $email.';
  }

  @override
  String get groupNameLabel => 'Group name';

  @override
  String get groupNameHint => 'For example: Our household';

  @override
  String get groupIntro =>
      'A group gathers the people who share accounts (a household, an association…).';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signIn => 'Sign in';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get haveInvitation => 'I received an invitation';

  @override
  String get registerTitle => 'Create my account';

  @override
  String get registerIntro =>
      'Enter the email address the invitation was sent to.';

  @override
  String get resetTitle => 'New password';

  @override
  String get resetIntro =>
      'Enter your email address: a code will be sent to you.';

  @override
  String get resetDone => 'Password changed. You can sign in.';

  @override
  String get totpTitle => 'Two-factor authentication';

  @override
  String get totpIntro =>
      'Enter the 6-digit code from your authenticator app, or a backup code.';

  @override
  String get totpCodeLabel => 'Code';

  @override
  String get verify => 'Verify';

  @override
  String get homeNoGroup =>
      'You are not in any group yet. Ask an administrator for an invitation.';

  @override
  String get groupLabel => 'Group';

  @override
  String get menuSecurity => 'Security';

  @override
  String get menuMembers => 'Members';

  @override
  String get accountsComingSoon =>
      'Your accounts and operations will soon appear here.';

  @override
  String get securityTitle => 'Security';

  @override
  String get twoFactorTitle => 'Two-factor authentication (TOTP)';

  @override
  String get twoFactorOff => 'Off. Recommended, especially for administrators.';

  @override
  String twoFactorOn(int count) {
    return 'On — $count backup codes left.';
  }

  @override
  String get twoFactorEnable => 'Enable';

  @override
  String get twoFactorScan =>
      'Scan this QR code with your authenticator app (Aegis, FreeOTP, Google Authenticator…), then enter the code it shows.';

  @override
  String get twoFactorSecretManual => 'Or type this key manually:';

  @override
  String get backupCodesTitle => 'Backup codes';

  @override
  String get backupCodesIntro =>
      'Write them down and keep them safe: each one lets you sign in if you lose your phone. They will not be shown again.';

  @override
  String get backupCodesDone => 'I wrote down my codes';

  @override
  String get twoFactorDisable => 'Disable';

  @override
  String get twoFactorDisableIntro =>
      'Enter a code to disable two-factor authentication.';

  @override
  String get twoFactorRenew => 'New backup codes';

  @override
  String get membersTitle => 'Members';

  @override
  String get invitationsTitle => 'Pending invitations';

  @override
  String get noInvitations => 'No pending invitation.';

  @override
  String get invite => 'Invite';

  @override
  String get inviteTitle => 'Invite someone';

  @override
  String get roleLabel => 'Role';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleUser => 'User';

  @override
  String get roleReader => 'Reader';

  @override
  String get roleHelp =>
      'Reader: views. User: enters and imports. Administrator: manages accounts and members.';

  @override
  String invitationSent(String email) {
    return 'Invitation sent to $email.';
  }

  @override
  String invitationExpires(String date) {
    return 'expires on $date';
  }

  @override
  String get revoke => 'Revoke';

  @override
  String get you => 'you';

  @override
  String invitationAccepted(String group) {
    return 'You joined \"$group\".';
  }

  @override
  String get error_login_failed => 'Wrong email or password.';

  @override
  String get error_too_many_attempts => 'Too many attempts. Try again later.';

  @override
  String get error_code_invalid => 'Wrong code.';

  @override
  String get error_code_expired => 'This code has expired. Start again.';

  @override
  String get error_password_policy =>
      'This password is not accepted: at least 8 characters, no space at the start or end.';

  @override
  String get error_ip_banned =>
      'Too many failures from this address: access is temporarily blocked.';

  @override
  String get error_rate_limited => 'Too many requests. Please wait a minute.';

  @override
  String get error_network =>
      'The server does not answer. Check your connection.';

  @override
  String get copy => 'Copy';

  @override
  String get error_category_access_denied =>
      'This category does not exist or you cannot access it.';

  @override
  String get error_rule_access_denied =>
      'This rule does not exist or you cannot access it.';

  @override
  String get error_unknown_standard_category => 'Unknown standard category.';

  @override
  String get error_invalid_pattern =>
      'The pattern must be 1 to 100 characters (letters or digits).';

  @override
  String get error_invalid_amount_range =>
      'The minimum amount is above the maximum amount.';

  @override
  String get error_import_file_too_large => 'File too large (4 MB maximum).';

  @override
  String get error_import_nothing_readable =>
      'No readable operation in this file.';

  @override
  String get error_import_access_denied =>
      'This import does not exist or you cannot access it.';

  @override
  String get error_scheduled_access_denied =>
      'This planned operation does not exist or you cannot access it.';

  @override
  String get error_invalid_interval =>
      'The interval must be between 1 and 120.';

  @override
  String get error_invalid_tolerance =>
      'Invalid tolerance (0 to 31 days, 0 to 100 %).';

  @override
  String get error_invalid_recurrence =>
      'The end date is before the start date.';

  @override
  String get error_invalid_date => 'Invalid date.';

  @override
  String get error_invalid_horizon =>
      'The forecast length must be between 1 and 366 days.';

  @override
  String get error_transaction_access_denied =>
      'This operation does not exist or you cannot access it.';

  @override
  String get error_imported_operation_locked =>
      'The date, amount and label of an imported operation cannot be changed: they come from the bank.';

  @override
  String get error_already_imported_again =>
      'This operation was imported again in the meantime: it is already in the account.';

  @override
  String get error_notification_access_denied =>
      'This notification does not exist.';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navOperations => 'Operations';

  @override
  String get navImport => 'Import';

  @override
  String get navForecast => 'Forecast';

  @override
  String get navCategories => 'Categories';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsEmpty => 'No account yet.';

  @override
  String get accountAdd => 'Add an account';

  @override
  String get accountEdit => 'Edit account';

  @override
  String get accountName => 'Account name';

  @override
  String get accountBank => 'Bank';

  @override
  String get accountKind => 'Type';

  @override
  String get kindChecking => 'Current account';

  @override
  String get kindSavings => 'Savings';

  @override
  String get kindDeferredCard => 'Deferred debit card';

  @override
  String get kindCash => 'Cash';

  @override
  String get initialBalance => 'Opening balance';

  @override
  String get initialBalanceHelp =>
      'Balance of the account before the first imported operation.';

  @override
  String get alertThreshold => 'Alert threshold';

  @override
  String get alertThresholdHelp =>
      'Alert when the forecast goes below it. 0 = any overdraft; -500 = authorised overdraft of 500.';

  @override
  String get visibilityRestricted =>
      'Restricted account (visible only to administrators and allowed people)';

  @override
  String get balanceCurrent => 'Current balance';

  @override
  String get balanceCleared => 'Cleared balance';

  @override
  String forecastLowest(String amount, String date) {
    return '30-day low: $amount on $date';
  }

  @override
  String overdraftExpected(String date) {
    return 'Overdraft expected on $date';
  }

  @override
  String get amountInvalid => 'Unreadable amount. Example: -12.50';

  @override
  String get operationsTitle => 'Operations';

  @override
  String get operationsEmpty => 'No operation.';

  @override
  String get searchHint => 'Search a label';

  @override
  String get filterToClassify => 'To classify';

  @override
  String get filterUncleared => 'Not cleared';

  @override
  String get loadMore => 'Show more';

  @override
  String operationsCount(int count) {
    return '$count operations';
  }

  @override
  String get toClassify => 'To classify';

  @override
  String get operationAdd => 'Enter an operation';

  @override
  String get dateLabel => 'Date';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountHelp => 'Negative for an expense: -12.50';

  @override
  String get labelLabel => 'Label';

  @override
  String get categoryLabel => 'Category';

  @override
  String get noCategory => 'To classify';

  @override
  String get cleared => 'Cleared';

  @override
  String get bankLabel => 'Bank label';

  @override
  String get alwaysClassify => 'Always classify like this';

  @override
  String ruleCreated(int count) {
    return 'Rule created: $count other operations reclassified.';
  }

  @override
  String get trash => 'Move to trash';

  @override
  String get trashed => 'Operation moved to the trash.';

  @override
  String get undo => 'Undo';

  @override
  String get sourceManual => 'chosen by you';

  @override
  String get sourceGroupRule => 'group rule';

  @override
  String get sourceCommunityRule => 'community rule';

  @override
  String get sourceHistory => 'history';

  @override
  String get sourceAi => 'AI';

  @override
  String get chooseAccount => 'Account';

  @override
  String clearedBalanceValue(String amount) {
    return 'Cleared balance: $amount';
  }

  @override
  String bankLabelValue(String label) {
    return 'Bank label: $label';
  }

  @override
  String dateValue(String date) {
    return 'Date: $date';
  }

  @override
  String get noteLabel => 'Your note';
}
