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
      'You are not in any group yet. If you administer this server, create your household below; otherwise, ask its administrator for an invitation.';

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
  String get error_invalid_amount =>
      'Invalid amount: it must be positive and reasonable.';

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
  String get categorySearchHint => 'Search a category';

  @override
  String get categorySearchEmpty => 'No matching category.';

  @override
  String categoryCreateNamed(String name) {
    return 'Create the category “$name”';
  }

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
  String get webSearch => 'Search this label on Google';

  @override
  String get webSearchHelp =>
      'Opens Google in a new tab with the cleaned label (not the bank\'s full label).';

  @override
  String get noteLabel => 'Your note';

  @override
  String get importTitle => 'Import a statement';

  @override
  String get importChooseFile => 'Choose a file';

  @override
  String get importOtherFile => 'Choose another file';

  @override
  String get importFormats =>
      'QIF, OFX or CSV, 4 MB at most. The file is only sent to your OwnCoffer server.';

  @override
  String get importReaderOnly => 'With the Reader role, you cannot import.';

  @override
  String get importNoAccount => 'First create an account in the Accounts tab.';

  @override
  String importFileInfo(String name, String format, String encoding) {
    return '$name: $format format, $encoding encoding';
  }

  @override
  String importCountRead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count operations read',
      one: '1 operation read',
      zero: 'No operation read',
    );
    return '$_temp0';
  }

  @override
  String importCountNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new',
      one: '1 new',
    );
    return '$_temp0';
  }

  @override
  String importCountDuplicate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count already there',
      one: '1 already there',
    );
    return '$_temp0';
  }

  @override
  String importCountPossible(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count possible duplicates',
      one: '1 possible duplicate',
    );
    return '$_temp0';
  }

  @override
  String importCountClassified(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classified',
      one: '1 classified',
    );
    return '$_temp0';
  }

  @override
  String importCountErrors(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errors',
      one: '1 error',
    );
    return '$_temp0';
  }

  @override
  String get importSameFile =>
      'This file was already imported into this account.';

  @override
  String importBankBalance(String date, String amount) {
    return 'Balance stated by the bank on $date: $amount';
  }

  @override
  String get importBalanceMatches =>
      'After the import, OwnCoffer will have the same balance on that date.';

  @override
  String importBalanceDiffers(String amount, String gap) {
    return 'After the import, OwnCoffer will show $amount on that date, a gap of $gap. Check the account\'s initial balance, or whether older operations are missing.';
  }

  @override
  String get importIssues => 'Notes about the file';

  @override
  String get importStatusNew => 'New';

  @override
  String get importStatusDuplicate => 'Already there';

  @override
  String get importStatusPossible => 'Possible duplicate';

  @override
  String get importPossibleHelp =>
      'A possible duplicate has the same date and amount as an operation already there, with a different label. Tick those to import anyway.';

  @override
  String importConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count operations',
      one: 'Import 1 operation',
      zero: 'Nothing to import',
    );
    return '$_temp0';
  }

  @override
  String importDone(int added, int classified) {
    String _temp0 = intl.Intl.pluralLogic(
      added,
      locale: localeName,
      other: '$added operations added, $classified of them classified.',
      one: '1 operation added, $classified classified.',
      zero: 'No operation added.',
    );
    return '$_temp0';
  }

  @override
  String get importHistory => 'Previous imports';

  @override
  String get importHistoryEmpty => 'No import for this account.';

  @override
  String importHistoryLine(String date, int added, int duplicates) {
    return '$date · $added added, $duplicates already there';
  }

  @override
  String get importCancelled => 'Cancelled';

  @override
  String get importCancel => 'Cancel this import';

  @override
  String importCancelConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'The $count operations added by this import will be moved to the trash.',
      one: 'The operation added by this import will be moved to the trash.',
    );
    return '$_temp0 Your corrections on them will be lost.';
  }

  @override
  String get importCancelDone => 'Import cancelled.';

  @override
  String get csvTitle => 'CSV file columns';

  @override
  String get csvHelp =>
      'OwnCoffer does not recognise this file\'s header. Tell what each column holds.';

  @override
  String get csvChangeColumns => 'Change the columns';

  @override
  String get csvDelimiter => 'Separator';

  @override
  String get csvTab => 'Tab';

  @override
  String get csvHeaderRow => 'Header row';

  @override
  String get csvNoHeader => 'None';

  @override
  String get csvDate => 'Date';

  @override
  String get csvLabel => 'Label';

  @override
  String get csvMemo => 'Details (optional)';

  @override
  String get csvAmountMode => 'Amounts';

  @override
  String get csvOneColumn => 'One signed column';

  @override
  String get csvDebitCredit => 'Separate debit and credit';

  @override
  String get csvAmount => 'Amount';

  @override
  String get csvDebit => 'Debit';

  @override
  String get csvCredit => 'Credit';

  @override
  String get csvNone => 'None';

  @override
  String csvColumn(int number, String sample) {
    return 'Column $number: $sample';
  }

  @override
  String get csvMonthFirst => 'Dates as month/day/year (US)';

  @override
  String get csvIncomplete =>
      'Choose at least the date, the label and an amount.';

  @override
  String get validate => 'Validate';

  @override
  String csvRowSample(int number, String sample) {
    return 'Row $number: $sample';
  }

  @override
  String get forecastTitle => 'Forecast balance';

  @override
  String get forecastUnavailable => 'Forecast unavailable for now.';

  @override
  String horizonDays(int count) {
    return '$count d';
  }

  @override
  String get horizonYear => '1 year';

  @override
  String forecastCurrent(String amount) {
    return 'Current balance: $amount';
  }

  @override
  String forecastEnd(String date, String amount) {
    return 'On $date: $amount';
  }

  @override
  String forecastThresholdLine(String amount) {
    return 'Alert threshold: $amount';
  }

  @override
  String get forecastChartLabel => 'Day-by-day forecast balance curve';

  @override
  String get forecastLowestMark => 'Lowest';

  @override
  String get forecastProposals => 'To confirm';

  @override
  String forecastProposalText(
    String operation,
    String date,
    String planned,
    String due,
  ) {
    return 'Does $operation of $date realise “$planned” due on $due?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get forecastMatched => 'Match confirmed.';

  @override
  String get forecastMissed => 'Not arrived';

  @override
  String forecastMissedText(String date) {
    return 'Due on $date, still not on the account.';
  }

  @override
  String get forecastSkip => 'Stop waiting';

  @override
  String get forecastSkipped => 'Occurrence skipped.';

  @override
  String forecastAutoReconciled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count operations linked automatically to their planned occurrence.',
      one: '1 operation linked automatically to its planned occurrence.',
    );
    return '$_temp0';
  }

  @override
  String get forecastUpcoming => 'Upcoming';

  @override
  String get forecastNoUpcoming => 'No planned operation in this period.';

  @override
  String forecastLate(String date) {
    return 'late, due on $date';
  }

  @override
  String forecastBalanceAfter(String amount) {
    return 'balance: $amount';
  }

  @override
  String get scheduledTitle => 'Planned operations';

  @override
  String get scheduledEmpty =>
      'No planned operation. Add your rent, salary, subscriptions…';

  @override
  String get scheduledAdd => 'Add a planned operation';

  @override
  String get scheduledEdit => 'Edit the planned operation';

  @override
  String get scheduledDelete => 'Delete';

  @override
  String scheduledDeleteConfirm(String label) {
    return 'Delete “$label”? Forecasts will no longer count it.';
  }

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get frequencyOnce => 'Once';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String get frequencyYearly => 'Yearly';

  @override
  String everyWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Every week',
    );
    return '$_temp0';
  }

  @override
  String everyMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Every month',
    );
    return '$_temp0';
  }

  @override
  String everyYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Every year',
    );
    return '$_temp0';
  }

  @override
  String get intervalLabel => 'Interval';

  @override
  String get intervalHelp => '2 = every other week, month…';

  @override
  String get startDateLabel => 'First occurrence';

  @override
  String get endDateLabel => 'Last occurrence (optional)';

  @override
  String get noEndDate => 'No end';

  @override
  String onceOn(String date) {
    return 'On $date';
  }

  @override
  String fromDate(String date) {
    return 'from $date';
  }

  @override
  String untilDate(String date) {
    return 'until $date';
  }

  @override
  String get matchPatternLabel => 'Bank label to recognise (optional)';

  @override
  String get matchPatternHelp =>
      'E.g. RENT. Used to link the real operation to the planned occurrence.';

  @override
  String get dateToleranceLabel => 'Date tolerance (days)';

  @override
  String get amountToleranceLabel => 'Amount tolerance (%)';

  @override
  String get toleranceInvalid => 'Whole number expected.';

  @override
  String get scheduledLockedHelp =>
      'Frequency and first occurrence cannot be changed: delete and create the planned operation again.';

  @override
  String get categoriesTab => 'Categories';

  @override
  String get rulesTab => 'Rules';

  @override
  String get categoryAdd => 'Add a category';

  @override
  String get categoryEdit => 'Edit the category';

  @override
  String get categoryName => 'Name';

  @override
  String get categoryParent => 'Parent category';

  @override
  String get categoryNoParent => 'None (main category)';

  @override
  String get categoryKindLabel => 'Type';

  @override
  String get kindIncome => 'Income';

  @override
  String get kindExpense => 'Expense';

  @override
  String get kindTransfer => 'Internal transfer';

  @override
  String categoryStandardName(String name) {
    return 'Standard name: $name';
  }

  @override
  String get categoryResetName => 'Back to the standard name';

  @override
  String get categoryStandardHelp =>
      'Linked to the standard catalogue: community rules keep filling it, even renamed.';

  @override
  String get categoryArchive => 'Archive';

  @override
  String categoryArchiveConfirm(String name) {
    return 'Archive “$name”? It will no longer be offered; operations already classified keep it.';
  }

  @override
  String get ruleAdd => 'Add a rule';

  @override
  String get ruleEdit => 'Edit the rule';

  @override
  String get rulesEmpty =>
      'No group rule. Create one here or with “Always classify like this” on an operation.';

  @override
  String get rulePattern => 'Text searched in the label';

  @override
  String get ruleMatchType => 'Match';

  @override
  String get matchContains => 'contains';

  @override
  String get matchStartsWith => 'starts with';

  @override
  String get matchEquals => 'is exactly';

  @override
  String get ruleDirection => 'Direction';

  @override
  String get directionAny => 'Debit or credit';

  @override
  String get directionDebit => 'Debit only';

  @override
  String get directionCredit => 'Credit only';

  @override
  String get ruleMinAmount => 'Minimum amount (optional)';

  @override
  String get ruleMaxAmount => 'Maximum amount (optional)';

  @override
  String get rulePriority => 'Priority';

  @override
  String get rulePriorityHelp => 'The smallest goes first.';

  @override
  String get ruleEnabled => 'Enabled';

  @override
  String get ruleDelete => 'Delete';

  @override
  String ruleSummary(String match, String pattern, String category) {
    return 'Label $match “$pattern” → $category';
  }

  @override
  String ruleAmounts(String min, String max) {
    return 'between $min and $max';
  }

  @override
  String ruleAmountFrom(String min) {
    return 'from $min';
  }

  @override
  String ruleAmountUpTo(String max) {
    return 'up to $max';
  }

  @override
  String get testerTitle => 'Test a label';

  @override
  String get testerHelp =>
      'Paste a label from your statement: OwnCoffer shows how it cleans and classifies it, without saving anything.';

  @override
  String get testerRun => 'Test';

  @override
  String testerCleaned(String label) {
    return 'Short label: $label';
  }

  @override
  String testerResult(String category, String source) {
    return 'Category: $category ($source)';
  }

  @override
  String get testerNone =>
      'No rule applies: the operation would be “To classify”.';

  @override
  String get testerRuleOpen => 'Show the rule';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notification.';

  @override
  String get notificationsMarkAll => 'Mark all as read';

  @override
  String notificationsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notifications: $count unread',
      one: 'Notifications: 1 unread',
      zero: 'Notifications',
    );
    return '$_temp0';
  }

  @override
  String notifOverdraftTitle(String account, String date) {
    return '$account: overdraft expected on $date';
  }

  @override
  String notifOverdraftBody(String balance, String threshold) {
    return 'Expected balance that day when the alert was raised: $balance (threshold $threshold).';
  }

  @override
  String get notifUnknown => 'Notification';

  @override
  String get notifOpenForecast => 'Show the forecast';

  @override
  String get importAccountRecognised => 'Account recognised from the file.';

  @override
  String importOtherAccountMatch(String account) {
    return 'This file matches the account “$account”.';
  }

  @override
  String importSwitchAccount(String account) {
    return 'Import into “$account”';
  }

  @override
  String importWrongBankAccount(String account) {
    return 'This file comes from another bank account than “$account”. Check the chosen account.';
  }

  @override
  String get groupCreateTitle => 'Create your household';

  @override
  String get navBudget => 'Budget';

  @override
  String get navLoans => 'Loans';

  @override
  String get navMore => 'More';

  @override
  String get allAccounts => 'All accounts';

  @override
  String get moreActions => 'More actions';

  @override
  String get optional => 'Optional';

  @override
  String get fieldRequired => 'Required field.';

  @override
  String get filterCategory => 'Category';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodYear => 'Year';

  @override
  String get periodPrevious => 'Previous period';

  @override
  String get periodNext => 'Next period';

  @override
  String get budgetIncome => 'Income';

  @override
  String get budgetExpenses => 'Expenses';

  @override
  String get budgetSavings => 'Savings';

  @override
  String get budgetNet => 'Left over';

  @override
  String budgetDeltaPrevious(String percent) {
    return '$percent% vs previous period';
  }

  @override
  String get budgetHistoryTitle => 'Income and expenses';

  @override
  String get budgetHistorySemantic =>
      'Income and expenses of the last six periods';

  @override
  String get rankingExpenses => 'Expense ranking';

  @override
  String get rankingIncome => 'Income ranking';

  @override
  String get rankingEmpty => 'Nothing over this period.';

  @override
  String rankingShare(int percent) {
    return '$percent% of total';
  }

  @override
  String rankingPrevious(String amount) {
    return 'before: $amount';
  }

  @override
  String rankingAverage(String amount) {
    return 'average: $amount';
  }

  @override
  String get rankingOperations => 'See the operations';

  @override
  String get goalAdd => 'Goal';

  @override
  String get goalSet => 'Set a goal';

  @override
  String get goalEdit => 'Change the goal';

  @override
  String get goalRemove => 'Remove the goal';

  @override
  String goalTitle(String category) {
    return 'Goal: $category';
  }

  @override
  String get goalHelp =>
      'Maximum amount to spend each month in this category, sub-categories included.';

  @override
  String get goalAmountLabel => 'Amount per month';

  @override
  String goalSuggestion(String amount, String average) {
    return 'Suggestion: $amount (average of the 3 previous months: $average)';
  }

  @override
  String get goalOk => 'On track';

  @override
  String get goalWarning => 'Almost reached';

  @override
  String get goalOver => 'Exceeded';

  @override
  String goalProgress(int percent, String goal) {
    return '$percent% of $goal';
  }

  @override
  String goalLeft(String amount) {
    return '$amount left';
  }

  @override
  String goalExceeded(String amount) {
    return '$amount over';
  }

  @override
  String goalProjection(String amount) {
    return 'At this pace: $amount by the end of the month';
  }

  @override
  String goalProjectionOver(String amount, String date) {
    return 'At this pace: $amount over, from around $date';
  }

  @override
  String get monthStartTitle => 'Start of the month';

  @override
  String get monthStartHelp =>
      'The day your budget month starts, e.g. pay day. Budget, expense ranking and goals use it for the whole household.';

  @override
  String get monthStartLabel => 'The month starts';

  @override
  String get monthStartFirst => 'On the 1st (calendar month)';

  @override
  String monthStartDay(int day) {
    return 'On day $day';
  }

  @override
  String get subscriptionsTitle => 'Subscriptions';

  @override
  String get subscriptionsMonthly => 'Per month';

  @override
  String get subscriptionsYearly => 'Per year';

  @override
  String get subscriptionsHelp =>
      'Planned operations marked as subscriptions, on the accounts you can see. Yearly and weekly amounts are converted to a monthly cost.';

  @override
  String get subscriptionsEmpty =>
      'No subscription. In an operation\'s details, “This is a subscription” adds it here.';

  @override
  String subscriptionNext(String date) {
    return 'next: $date';
  }

  @override
  String subscriptionPerMonth(String amount) {
    return '$amount / month';
  }

  @override
  String get subscriptionUnmark => 'No longer count as a subscription';

  @override
  String get subscriptionUnmarkHelp =>
      'Stays a planned operation in the forecast.';

  @override
  String get subscriptionStop => 'Subscription cancelled';

  @override
  String get subscriptionStopHelp =>
      'Deletes the planned operation: it no longer counts in the forecast.';

  @override
  String get subscriptionSwitch => 'Subscription';

  @override
  String get subscriptionSwitchHelp => 'Shown in the subscriptions list.';

  @override
  String get subscriptionFromOperation => 'This is a subscription';

  @override
  String get subscriptionMarkPlanned => 'Mark as a subscription';

  @override
  String get filterSubscriptions => 'Subscriptions';

  @override
  String get subscriptionsOpen => 'Subscriptions list';

  @override
  String get subscriptionBadge => 'Subscription';

  @override
  String subscriptionOfOperation(String label) {
    return 'Subscription “$label”';
  }

  @override
  String subscriptionCreated(String label, String date) {
    return 'Subscription “$label” added, next debit on $date.';
  }

  @override
  String get loansRemaining => 'Left to repay';

  @override
  String get loansMonthly => 'Monthly instalments';

  @override
  String get loansDebtRatio => 'Debt ratio';

  @override
  String get loansDebtRatioUnknown =>
      'No classified income over the last 3 months.';

  @override
  String get loansDebtRatioOk => 'Below the advised 35%';

  @override
  String get loansDebtRatioHigh => 'Above the advised 35%';

  @override
  String loansDebtRatioBasis(String amount) {
    return 'average income: $amount / month';
  }

  @override
  String get loansEmpty => 'No loan. Add one to follow what is left to repay.';

  @override
  String get loansDisclaimer =>
      'Indicative computations, fixed rate and constant instalments: the bank\'s own schedule prevails.';

  @override
  String get loanAdd => 'Add a loan';

  @override
  String get loanEdit => 'Edit the loan';

  @override
  String get loanDelete => 'Delete the loan';

  @override
  String get loanDeleteConfirm =>
      'Delete this loan? Its planned instalments are removed from the forecast.';

  @override
  String get loanKind => 'Loan type';

  @override
  String get loanKindMortgage => 'Mortgage';

  @override
  String get loanKindCar => 'Car';

  @override
  String get loanKindConsumer => 'Consumer';

  @override
  String get loanKindStudent => 'Student';

  @override
  String get loanKindPersonal => 'Personal loan';

  @override
  String get loanKindOther => 'Other';

  @override
  String get loanLender => 'Lender';

  @override
  String get loanLabel => 'Name';

  @override
  String get loanLabelHint => 'House, car…';

  @override
  String get loanPrincipal => 'Amount borrowed';

  @override
  String get loanRate => 'Nominal rate';

  @override
  String get loanRateHelp => 'Per year, e.g. 3.45';

  @override
  String get loanRateInvalid =>
      'Rate between 0 and 50%, three decimals at most.';

  @override
  String get loanApr => 'APR';

  @override
  String get loanDuration => 'Duration';

  @override
  String get loanDurationMonths => 'Duration in months';

  @override
  String get loanDurationHelp => '240 months = 20 years';

  @override
  String get loanDurationInvalid => 'Between 1 and 600 months.';

  @override
  String loanMonths(int count) {
    return '$count months';
  }

  @override
  String get loanFirstDue => 'First instalment date';

  @override
  String get loanInsurance => 'Insurance per month';

  @override
  String get loanInsuranceMonthly => 'Insurance per month';

  @override
  String get loanFees => 'Arrangement fees';

  @override
  String get loanAccount => 'Debited account';

  @override
  String get loanAccountHelp =>
      'Instalments become planned operations on this account: they count in the forecast and are matched with the real debits.';

  @override
  String get loanNoAccount => 'None';

  @override
  String get loanPayment => 'Instalment (without insurance)';

  @override
  String loanPreview(String payment, String total) {
    return 'Instalment: $payment without insurance, $total with.';
  }

  @override
  String get loanPreviewEmpty =>
      'Enter the amount, rate and duration to see the instalment.';

  @override
  String get loanRemainingShort => 'left to repay';

  @override
  String loanRepaid(int percent) {
    return '$percent% repaid';
  }

  @override
  String loanInstallments(int paid, int total) {
    return '$paid / $total instalments';
  }

  @override
  String loanNext(String date, String amount) {
    return 'next on $date: $amount';
  }

  @override
  String get loanFinished => 'repaid';

  @override
  String loanEnd(String date) {
    return 'ends on $date';
  }

  @override
  String get loanInterestPaid => 'Interest paid';

  @override
  String get loanInterestLeft => 'Interest left to pay';

  @override
  String get loanCost => 'Total cost (interest, insurance, fees)';

  @override
  String get loanSimulationTitle => 'Early repayment';

  @override
  String get loanSimulationHelp =>
      'If I repay this amount now, keeping the same instalment.';

  @override
  String get loanSimulationAmount => 'Amount';

  @override
  String get loanSimulate => 'Simulate';

  @override
  String get loanSimulationSaved => 'Interest saved';

  @override
  String get loanSimulationEnd => 'New end date';

  @override
  String get loanSimulationRepaid => 'Loan settled';

  @override
  String get loanSimulationLeft => 'Instalments left';

  @override
  String get loanScheduleTitle => 'Amortisation schedule';

  @override
  String loanYearSummary(String principal, String interest, String remaining) {
    return 'Capital $principal · interest $interest · left $remaining';
  }

  @override
  String get loanColNumber => 'No.';

  @override
  String get loanColDate => 'Date';

  @override
  String get loanColPayment => 'Instalment';

  @override
  String get loanColPrincipal => 'Capital';

  @override
  String get loanColInterest => 'Interest';

  @override
  String get loanColInsurance => 'Insurance';

  @override
  String get loanColRemaining => 'Remaining';

  @override
  String get error_goal_expense_only =>
      'A goal can only be set on an expense category.';

  @override
  String get error_loan_access_denied =>
      'This loan does not exist or you cannot access it.';

  @override
  String get error_loan_terms_invalid =>
      'Impossible loan terms: check the amount, rate and duration.';

  @override
  String get error_invalid_month_start_day =>
      'The month must start between the 1st and the 28th.';

  @override
  String get loanFromOperation => 'This is a loan instalment';

  @override
  String get loanFromOperationTitle => 'Declare the loan';

  @override
  String loanFromOperationIntro(String label) {
    return 'Future “$label” debits will be recognised as this loan\'s instalments and classified automatically.';
  }

  @override
  String loanObservedInstalment(String amount) {
    return 'Observed debit: $amount (insurance included)';
  }

  @override
  String get loanDeducePrincipal => 'Compute the capital from this debit';

  @override
  String get loanDeduceNeedsTerms => 'Enter the rate and the duration first.';

  @override
  String loanInstalmentMismatch(String amount) {
    return 'The computed instalment ($amount) is more than 5% away from the debit: check the capital, rate, duration and insurance.';
  }

  @override
  String get loanFirstDueFromOperationHelp =>
      'Date of the very first instalment. If you do not know it, keep this debit\'s date and enter the remaining duration: the computed capital is then the capital still owed.';

  @override
  String get loanCategoryDefaultHelp =>
      'Without a choice, the category of the loan type is used (e.g. Mortgage).';

  @override
  String loanFromOperationDone(int linked, int others) {
    return 'Loan created: $linked instalments linked, $others other operations classified.';
  }

  @override
  String get error_loan_needs_debit => 'A loan is declared from a debit.';

  @override
  String get sameProvider => 'Other payments to this provider';

  @override
  String sameProviderFilter(String label) {
    return 'Provider: $label';
  }

  @override
  String sameProviderSummary(int count, String total, String average) {
    return '$count operations · total $total · average $average';
  }

  @override
  String get undoDone => 'Undone.';

  @override
  String get categoryChanged => 'Category changed.';

  @override
  String get clearedChanged => 'Checking changed.';

  @override
  String get goalSaved => 'Goal saved.';

  @override
  String get goalRemoved => 'Goal removed.';

  @override
  String get splitTitle => 'Split the operation';

  @override
  String get splitAction => 'Split between categories';

  @override
  String get splitAddPart => 'Add a part';

  @override
  String splitRemaining(String amount) {
    return 'Left to allocate: $amount';
  }

  @override
  String get splitBalanced => 'The total matches the operation\'s amount.';

  @override
  String get splitRemove => 'Remove the split';

  @override
  String get splitSaved => 'Operation split.';

  @override
  String splitPartLabel(int number) {
    return 'Part $number';
  }

  @override
  String splitPartsSummary(int count) {
    return 'Split into $count parts';
  }

  @override
  String get splitNoteLabel => 'Detail';

  @override
  String get splitRemovePart => 'Remove this part';

  @override
  String get leftToLiveTitle => 'Left to live on';

  @override
  String leftToLiveBody(String perDay, int days, String date) {
    return 'that is $perDay a day for $days days, until $date';
  }

  @override
  String leftToLiveDetail(String balance, String debits, String credits) {
    return 'Balance $balance · planned debits $debits · planned credits $credits';
  }

  @override
  String get leftToLiveHelp =>
      'Checking accounts only, planned operations included, until the end of the budget month (the day before the next pay day).';

  @override
  String get calendarTitle => 'Due-date calendar';

  @override
  String get calendarEmpty => 'No due date over this period.';

  @override
  String calendarUpcoming(String debits, String credits) {
    return 'Still to come: $debits of debits, $credits of credits';
  }

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusLate => 'Late';

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String statusPaidOther(String amount) {
    return 'Paid: $amount';
  }

  @override
  String get calendarLoan => 'Loan';

  @override
  String get calendarSubscription => 'Subscription';

  @override
  String get reviewTitle => 'Month review';

  @override
  String reviewNet(String net, String previous) {
    return 'Left over this month: $net (previous month: $previous)';
  }

  @override
  String get reviewRises => 'Up';

  @override
  String get reviewDrops => 'Down';

  @override
  String reviewChange(String amount, String average) {
    return '$amount instead of $average on average';
  }

  @override
  String get reviewGoalsOver => 'Goals exceeded';

  @override
  String reviewGoalOver(String amount, String goal) {
    return '$amount for a goal of $goal';
  }

  @override
  String get reviewFees => 'Bank fees';

  @override
  String reviewFeesTotal(String amount) {
    return '$amount of bank fees this month';
  }

  @override
  String get reviewNoFees => 'No bank fees this month.';

  @override
  String get reviewBiggest => 'Biggest expenses';

  @override
  String get reviewSubscriptions => 'Subscriptions';

  @override
  String reviewSubscriptionChange(String label, String actual, String planned) {
    return '$label: $actual instead of $planned';
  }

  @override
  String reviewNewSubscription(String label, String amount) {
    return 'New subscription: $label ($amount)';
  }

  @override
  String reviewUnclassified(int count) {
    return '$count operations are still to classify this month.';
  }

  @override
  String get reviewNothing => 'Nothing to report.';

  @override
  String get balanceCheckAction => 'Check the balance';

  @override
  String get balanceCheckHelp =>
      'Enter the balance your bank shows at the end of a day: OwnCoffer compares it with the balance computed from the operations.';

  @override
  String get balanceCheckDate => 'Balance date';

  @override
  String get balanceCheckAmount => 'Balance shown by the bank';

  @override
  String get balanceCheckOk => 'The balance matches.';

  @override
  String balanceCheckGap(String amount, String computed) {
    return 'Gap of $amount: the computed balance is $computed.';
  }

  @override
  String balanceCheckUncleared(String amount) {
    return 'Including $amount of operations entered by hand and not checked, which may not have reached the bank yet.';
  }

  @override
  String balanceCheckLastImport(String date) {
    return 'Last imported operation: $date. A statement may be missing.';
  }

  @override
  String get balanceCheckHistory => 'Last checks';

  @override
  String balanceCheckRow(String date, String bank, String gap) {
    return '$date: bank $bank, gap $gap';
  }

  @override
  String notifGoalWarningTitle(String category) {
    return 'Goal “$category” almost reached';
  }

  @override
  String notifGoalOverTitle(String category) {
    return 'Goal “$category” exceeded';
  }

  @override
  String notifGoalBody(String spent, String goal) {
    return '$spent spent for a goal of $goal this month.';
  }

  @override
  String notifGoalForecastTitle(String category, String date) {
    return 'Goal “$category”: expected to be exceeded around $date';
  }

  @override
  String notifGoalForecastBody(String spent, String goal, String projected) {
    return '$spent spent for a $goal goal; at this pace, $projected by the end of the month.';
  }

  @override
  String get loanKindInstallments => 'Payment in instalments';

  @override
  String get loanInstallmentsCount => 'Number of instalments';

  @override
  String get loanInstallmentsTotal => 'Total amount of the purchase';

  @override
  String get loanInstallmentsHelp =>
      'Payment in 3 or 4 instalments (Alma, Oney, card…), usually free: the rate stays at 0%.';

  @override
  String get loanSectionInstallments => 'Payments in instalments';

  @override
  String get error_split_invalid =>
      'A split needs at least two parts of the operation\'s sign adding up to its amount.';

  @override
  String get goalsTitle => 'Goals of the month';

  @override
  String get goalsEmpty =>
      'No goal yet. Set a monthly limit on an expense category to see where you stand as the month goes.';

  @override
  String goalsSummary(int ok, int warning, int over) {
    return '$ok on track · $warning almost reached · $over exceeded';
  }

  @override
  String get goalPaceHelp =>
      'The vertical mark shows where you should be today to keep the goal until the end of the month.';

  @override
  String goalSpentOf(String spent, String goal) {
    return '$spent of $goal';
  }

  @override
  String rankingShowAll(int count) {
    return 'See all $count categories';
  }

  @override
  String get rankingShowLess => 'Show less';

  @override
  String rankingTotal(String amount) {
    return 'Total: $amount';
  }

  @override
  String rankingVsAverage(String percent, String amount) {
    return '$percent% vs average ($amount)';
  }

  @override
  String get budgetBalanceTitle => 'Period overview';

  @override
  String budgetOverspent(String amount) {
    return 'You spent $amount more than your income';
  }

  @override
  String budgetLeftOver(String amount) {
    return 'You have $amount left';
  }

  @override
  String budgetBarsSemantic(String income, String out) {
    return 'Income $income, expenses and savings $out';
  }

  @override
  String get budgetExpensesAndSavings => 'Expenses and savings';

  @override
  String get budgetSavingsPart => 'of which savings';

  @override
  String budgetVsPrevious(String delta) {
    return '$delta vs previous period';
  }

  @override
  String unclassifiedBanner(int count, String amount) {
    return '$count operations to classify ($amount)';
  }

  @override
  String get unclassifiedBannerHelp =>
      'They count in the totals but not in the rankings or goals.';

  @override
  String get classifyNow => 'Classify';

  @override
  String get loanAttachTitle => 'Instalment of which loan?';

  @override
  String get loanAttachHelp =>
      'Pick a loan already entered: this debit is attached to it and the next ones are classified automatically.';

  @override
  String get loanAttachNew => 'Declare a new loan';

  @override
  String loanAttachDone(int linked, int others) {
    return 'Debit attached to the loan: $linked instalments linked, $others other operations classified.';
  }

  @override
  String get error_loan_other_account =>
      'This loan is debited from another account.';

  @override
  String get loanOperationsTitle => 'Loan operations';

  @override
  String loanOperationsSummary(int count, String total) {
    return '$count debits · $total paid';
  }

  @override
  String get loanOperationsEmpty =>
      'No debit attached yet. From a debit\'s details, “This is a loan instalment” attaches it to this loan.';

  @override
  String loanOperationsMore(int count) {
    return 'See all $count debits';
  }

  @override
  String get loanActualPayment => 'Instalment debited (insurance included)';

  @override
  String get loanActualPaymentHelp =>
      'The amount actually debited each month: the only certain figure. Remaining capital, interest and end date are worked out from it.';

  @override
  String loanActualPreview(String amount, int months) {
    return 'At $amount a month, the loan would be repaid in $months months.';
  }

  @override
  String get loanPaymentActual => 'Instalment (debited)';

  @override
  String get loanPaymentComputed => 'Instalment (computed)';

  @override
  String get loanEstimatedDuration => 'Estimated duration';

  @override
  String get loanEstimatesNote =>
      'The instalment debited is the only certain figure: remaining capital, interest and end date are estimates worked out from it. Your bank\'s amortisation table prevails.';

  @override
  String get loanEstimatesNoteComputed =>
      'Instalment computed from the capital, rate and duration: enter the instalment debited for better estimates. Your bank\'s amortisation table prevails.';

  @override
  String get loanDocumentsTitle => 'Loan documents';

  @override
  String get loanDocumentsHelp =>
      'Amortisation table, loan offer, screenshots… They stay on your server (PDF, image, CSV, spreadsheet; 10 MB at most).';

  @override
  String get loanDocumentsEmpty => 'No document.';

  @override
  String get loanDocumentAdd => 'Add a document';

  @override
  String get loanDocumentAdded => 'Document added.';

  @override
  String get loanDocumentDelete => 'Delete the document';

  @override
  String loanDocumentDeleteConfirm(String name) {
    return 'Delete “$name” from the server? This cannot be undone.';
  }

  @override
  String loanDocumentInfo(String size, String date) {
    return '$size · added on $date';
  }

  @override
  String get error_document_too_large => 'The document is empty or over 10 MB.';

  @override
  String get error_document_type =>
      'Document type not accepted: PDF, image (PNG, JPEG, WebP), CSV, text or spreadsheet (XLSX, ODS).';

  @override
  String get error_document_limit =>
      'This loan already has 30 documents: delete some first.';

  @override
  String sizeMb(String value) {
    return '$value MB';
  }

  @override
  String sizeKb(String value) {
    return '$value kB';
  }

  @override
  String get variableToggle => 'Variable spending';

  @override
  String get variableToggleHelp =>
      'Count groceries, fuel, outings… estimated from the previous months';

  @override
  String variableIncluded(String amount) {
    return 'Including $amount of estimated variable spending';
  }

  @override
  String variableMonthly(String amount) {
    return 'Usually $amount a month · see how';
  }

  @override
  String variableHow(String months) {
    return 'From $months: for each category, the median of the months (one exceptional month does not count). Planned operations, transfers between your accounts and income are left out.';
  }

  @override
  String variableThisMonth(String spent, String left) {
    return 'This month: $spent already spent, $left still expected, spread day by day.';
  }

  @override
  String get variableNoHistory =>
      'Variable spending: not enough history yet (at least one complete month of operations is needed).';

  @override
  String get variableNone => 'Variable spending: none in the last months.';

  @override
  String get purchaseTitle => 'Simulate a purchase';

  @override
  String purchaseHelp(String account) {
    return 'On the “$account” account: the balance on the chosen day, the low point and the overdraft risk, depending on how you pay. Nothing is saved until you choose.';
  }

  @override
  String get purchaseAmount => 'Purchase amount';

  @override
  String get purchaseAmountInvalid =>
      'A positive amount, for example 600 or 599.90';

  @override
  String get purchaseLabel => 'Label';

  @override
  String get purchaseDefaultLabel => 'Purchase';

  @override
  String purchaseDate(String date) {
    return 'Bought on $date';
  }

  @override
  String purchaseTarget(String date) {
    return 'Balance on $date';
  }

  @override
  String get purchaseCategoryHelp =>
      'Optional: warns if the month\'s goal would be exceeded';

  @override
  String get purchaseSimulate => 'Compare';

  @override
  String get purchaseNone => 'Without buying';

  @override
  String get purchaseNoneHelp => 'For comparison';

  @override
  String get purchaseCash => 'In cash';

  @override
  String purchaseTimes(int count) {
    return 'In $count instalments';
  }

  @override
  String get purchaseNextMonth => 'Next month';

  @override
  String purchaseBalanceOn(String date) {
    return 'Balance on $date';
  }

  @override
  String purchaseLowest(String amount, String date) {
    return 'Low point: $amount on $date';
  }

  @override
  String purchaseGoal(String spent, String goal) {
    return 'Category goal: $spent spent of $goal this month.';
  }

  @override
  String purchaseGoalOver(String amount) {
    return 'Month\'s goal exceeded by $amount';
  }

  @override
  String get purchaseChoose => 'Choose and save';

  @override
  String get purchaseSaved => 'Purchase saved in the planned operations.';

  @override
  String get purchaseHowVariable =>
      'Computed by the forecast engine: planned operations and estimated variable spending. In instalments: rounded up to the cent, the last one settles; no fees.';

  @override
  String get purchaseHowPlanned =>
      'Computed by the forecast engine: planned operations only. In instalments: rounded up to the cent, the last one settles; no fees.';

  @override
  String get adminTitle => 'Server administration';

  @override
  String get adminRefresh => 'Refresh';

  @override
  String get adminTabHealth => 'Health and figures';

  @override
  String get adminTabUsers => 'Users';

  @override
  String get adminTabSecurity => 'Blocked IPs';

  @override
  String get adminTabAudit => 'Log';

  @override
  String get adminHealth => 'Server state';

  @override
  String get adminVersion => 'Installed version';

  @override
  String get adminUptime => 'Running for';

  @override
  String adminUptimeValue(int days, int hours) {
    return '$days d $hours h';
  }

  @override
  String get adminDatabase => 'Database';

  @override
  String get adminUnreachable => 'unreachable';

  @override
  String get adminOk => 'OK';

  @override
  String get adminFailed => 'failed';

  @override
  String get adminNotYet => 'not yet';

  @override
  String get adminDocuments => 'Stored documents';

  @override
  String get adminAlertsJob => 'Last alert check';

  @override
  String get adminClock => 'Server clock';

  @override
  String adminClockDrift(int seconds) {
    return '$seconds s from this device';
  }

  @override
  String get adminEmail => 'Sending emails';

  @override
  String get adminEmailSmtp => 'SMTP server configured';

  @override
  String get adminEmailLog => 'not configured: written to the server log';

  @override
  String get adminTestEmail => 'Send a test email';

  @override
  String adminTestEmailSent(String email) {
    return 'Test email sent to $email.';
  }

  @override
  String get adminTestEmailLogged =>
      'SMTP not configured: the test email is written to the server log.';

  @override
  String get adminPublicUrl => 'Public address';

  @override
  String get adminStats => 'Server figures (no amounts)';

  @override
  String get adminStatUsers => 'User accounts';

  @override
  String adminStatUsersValue(int count, int twoFactor, int blocked) {
    return '$count · two-factor: $twoFactor · blocked: $blocked';
  }

  @override
  String get adminStatGroups => 'Groups (households)';

  @override
  String get adminStatAccounts => 'Bank accounts';

  @override
  String get adminStatOperations => 'Operations';

  @override
  String adminStatOperationsValue(int count, int recent) {
    return '$count · $recent added in 30 days';
  }

  @override
  String get adminStatImports => 'Imports in 30 days';

  @override
  String get adminStatRules => 'Group rules';

  @override
  String get adminStatInvitations => 'Pending invitations';

  @override
  String get adminStatAuto => 'Automatic classification (90 days)';

  @override
  String adminStatAutoHelp(int auto, int manual, int none) {
    return 'Imported operations: $auto classified automatically, $manual by hand, $none to classify. Alpha target: 70 % (decision 0014).';
  }

  @override
  String get adminUsersHelp =>
      'Every account of the server. A blocked account is signed out everywhere and can no longer sign in; its data stays intact.';

  @override
  String get adminServerAdmin => 'server administrator';

  @override
  String get adminTwoFactorOn => 'two-factor on';

  @override
  String get adminTwoFactorOff => 'no two-factor';

  @override
  String adminCreated(String date) {
    return 'created $date';
  }

  @override
  String adminLastActive(String date) {
    return 'active $date';
  }

  @override
  String get adminNeverActive => 'never signed in';

  @override
  String get adminBlocked => 'blocked';

  @override
  String get adminBlock => 'Block';

  @override
  String get adminUnblock => 'Unblock';

  @override
  String adminBlockTitle(String email) {
    return 'Block $email?';
  }

  @override
  String get adminBlockHelp =>
      'The account will be signed out within minutes and can no longer sign in. Nothing is deleted; you can unblock it.';

  @override
  String get adminUserBlocked => 'Account blocked.';

  @override
  String get adminUserUnblocked => 'Account unblocked.';

  @override
  String get adminBansHelp =>
      'IP addresses blocked after too many failed sign-ins. The duration doubles each time.';

  @override
  String get adminBansEmpty => 'No blocked address.';

  @override
  String adminBanUntil(String date, int count) {
    return 'until $date · block #$count';
  }

  @override
  String get adminUnban => 'Unblock';

  @override
  String get adminUnbanned => 'Address unblocked.';

  @override
  String get adminAuditHelp =>
      'The last 100 sensitive actions: who, what, when. The content of the changes is not shown (it may hold a household\'s data).';

  @override
  String get adminAuditEmpty => 'Nothing yet.';

  @override
  String adminAuditGroup(int id) {
    return 'group #$id';
  }

  @override
  String get adminSystem => 'server';

  @override
  String get menuAdmin => 'Server administration';

  @override
  String get error_cannot_block_self => 'You cannot block your own account.';

  @override
  String get error_user_not_found => 'Account not found.';

  @override
  String get error_mail_failed =>
      'Sending the email failed: check the SMTP settings in docker/.env and the server log.';

  @override
  String get adminTabBackups => 'Backups';

  @override
  String get adminBackupsUnavailable =>
      'The folder shared with the host (docker/state) is not mounted. The next automatic update installs it, or run this command as root in the OwnCoffer folder now:';

  @override
  String get adminBackupNoNightly => 'No nightly backup yet.';

  @override
  String adminBackupNightlyOk(String date) {
    return 'Last nightly backup: $date';
  }

  @override
  String adminBackupNightlyLate(String date) {
    return 'No nightly backup since $date: check owncoffer-backup.timer.';
  }

  @override
  String adminBackupLastFailed(String date, String message) {
    return 'The last backup failed ($date): $message';
  }

  @override
  String get adminBackupNow => 'Back up now';

  @override
  String get adminBackupPending => 'Requested, running on the server…';

  @override
  String get adminBackupRequested =>
      'Backup requested: it shows here within seconds (at most one every 10 minutes).';

  @override
  String get adminBackupsHelp =>
      'Kept on the same server, in docker/backups/: 30 nightly, 10 manual, 10 before an update. Copy them elsewhere regularly (disk, another machine).';

  @override
  String get adminBackupsEmpty => 'No backup.';

  @override
  String get adminBackupDaily => 'Nightly';

  @override
  String get adminBackupManual => 'Manual';

  @override
  String adminBackupBefore(String version) {
    return 'Before update $version';
  }

  @override
  String get adminRestoreTitle => 'Restore a backup';

  @override
  String get adminRestoreHelp =>
      'On the server only, in the OwnCoffer folder: restoring replaces all current data. Back up first.';

  @override
  String get error_host_bridge_missing =>
      'The folder shared with the host (docker/state) is not reachable.';

  @override
  String get adminTabInvitations => 'Invitations';

  @override
  String get adminInvitationsHelp =>
      'Pending invitations of every group. As the server administrator you can invite into any group; the person receives a link by email, valid for 7 days.';

  @override
  String get adminGroups => 'Groups of the server';

  @override
  String adminGroupSize(int members, int accounts) {
    return '$members member(s) · $accounts bank account(s)';
  }

  @override
  String get adminInvitationsPending => 'Pending invitations';

  @override
  String get adminInvitationsEmpty => 'No pending invitation.';

  @override
  String adminInvitedBy(String email) {
    return 'sent by $email';
  }

  @override
  String adminInvitationExpires(String date) {
    return 'valid until $date';
  }

  @override
  String get adminInvitationRevoked =>
      'Invitation revoked: the link no longer works.';

  @override
  String get error_invitation_not_pending =>
      'This invitation is no longer pending.';

  @override
  String get adminTabUpdates => 'Updates';

  @override
  String adminVersionRunning(String version) {
    return 'Running version: $version';
  }

  @override
  String get adminUpdatesUnavailable =>
      'The host has not reported the update state yet (docker/state missing, or the update script has not run yet). It runs every 15 minutes; to set it up now, run as root in the OwnCoffer folder:';

  @override
  String get adminUpToDate => 'OwnCoffer is up to date.';

  @override
  String adminUpdateAvailable(String version) {
    return 'New version available: $version';
  }

  @override
  String adminUpdateChecked(String date) {
    return 'Last check: $date';
  }

  @override
  String adminUpdateFailedVersion(String version) {
    return 'Version $version did not start: the server went back to the previous version with the backup. It is no longer retried automatically; you can install it by hand.';
  }

  @override
  String adminInstallNow(String version) {
    return 'Install $version';
  }

  @override
  String get adminInstall => 'Install';

  @override
  String adminInstallTitle(String version) {
    return 'Install $version now?';
  }

  @override
  String get adminInstallHelp =>
      'The server backs up first, installs the version, then checks it answers; otherwise it goes back to the current version with the backup. The app is unavailable for about a minute; reload the page afterwards.';

  @override
  String get adminCheckNow => 'Check now';

  @override
  String get adminUpdatePending => 'Requested, running on the server…';

  @override
  String get adminAutoUpdate => 'Automatic updates';

  @override
  String get adminAutoUpdateOn =>
      'Each published version is installed within 15 minutes, after a backup.';

  @override
  String get adminAutoUpdateOff =>
      'Off: new versions are shown here and wait for you to install them.';

  @override
  String get adminAutoUpdateSavedOn => 'Automatic updates on.';

  @override
  String get adminAutoUpdateSavedOff => 'Automatic updates off.';

  @override
  String get adminCheckRequested =>
      'Check requested: the result shows within seconds.';

  @override
  String adminInstallRequested(String version) {
    return 'Installation of $version requested: the app restarts within minutes.';
  }

  @override
  String get adminReleasesUpcoming => 'Coming';

  @override
  String get adminReleasesInstalled => 'Notes of the installed versions';

  @override
  String get adminUpdateHistory => 'History';

  @override
  String get adminUpdateInstalled => 'installed';

  @override
  String get adminUpdateRollback => 'rolled back';

  @override
  String get adminUpdateRollbackFailed => 'rollback failed';

  @override
  String get adminUpdateRefused => 'refused';

  @override
  String get error_invalid_version =>
      'Invalid version: only a published version newer than the installed one can be installed.';

  @override
  String get navInvoices => 'Invoices';

  @override
  String get invoicesTitle => 'Invoices';

  @override
  String get invoicesIntro =>
      'Invoices and receipts attached to operations, named after the operation (date, label, amount). To add one, open the operation in the Operations page.';

  @override
  String get invoicesSearch => 'Search (name, label, account)';

  @override
  String get invoicesAllYears => 'All years';

  @override
  String get invoicesWarrantyFilter => 'Warranty running';

  @override
  String get invoicesExport => 'Export as ZIP';

  @override
  String invoicesExporting(int done, int total) {
    return 'Exporting… $done/$total';
  }

  @override
  String get invoicesZipName => 'Invoices.zip';

  @override
  String invoicesZipNameYear(String year) {
    return 'Invoices $year.zip';
  }

  @override
  String get invoicesEmpty => 'No invoice yet.';

  @override
  String invoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invoices',
      one: '1 invoice',
    );
    return '$_temp0';
  }

  @override
  String get invoicesOfOperation => 'Invoices';

  @override
  String get invoicesNone => 'No invoice attached.';

  @override
  String get invoiceAttach => 'Attach an invoice';

  @override
  String get invoiceTakePhoto => 'Take a photo';

  @override
  String invoiceAdded(String name) {
    return 'Invoice added: $name';
  }

  @override
  String get invoiceBadge => 'Invoice attached';

  @override
  String get invoiceUnattached => 'No operation';

  @override
  String get invoiceActions => 'Actions';

  @override
  String get invoiceOpen => 'Open';

  @override
  String get invoiceEdit => 'Description and warranty';

  @override
  String get invoiceSend => 'Send by email';

  @override
  String get invoiceDelete => 'Delete';

  @override
  String invoiceDeleteConfirm(String name) {
    return 'Delete the invoice \"$name\"?';
  }

  @override
  String get invoiceLabel => 'Description';

  @override
  String get invoiceLabelHint => 'Washing machine, car repair…';

  @override
  String get invoiceLabelHelp => 'Added to the invoice\'s name.';

  @override
  String get invoiceWarranty => 'End of warranty';

  @override
  String get invoiceWarrantyNone => 'No warranty followed.';

  @override
  String invoiceWarrantyUntil(String date) {
    return 'Warranty until $date';
  }

  @override
  String invoiceWarrantyOver(String date) {
    return 'Warranty ended on $date';
  }

  @override
  String invoiceWarrantyYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String get invoiceWarrantyPick => 'Pick a date';

  @override
  String get invoiceWarrantyClear => 'None';

  @override
  String get invoiceWarrantyHelp =>
      'Counted from the operation\'s date. A reminder comes in the notifications and by email a month before the end.';

  @override
  String get invoiceSendTo => 'Recipient\'s address';

  @override
  String get invoiceSendMessage => 'Message (optional)';

  @override
  String get invoiceSendHelp =>
      'The invoice is attached, sent from the OwnCoffer server\'s address.';

  @override
  String get invoiceSendAction => 'Send';

  @override
  String get invoiceSent => 'Invoice sent.';

  @override
  String notifWarrantyTitle(String name, String date) {
    return 'Warranty of \"$name\": ends on $date';
  }

  @override
  String get notifWarrantyBody => 'The invoice is in the Invoices page.';

  @override
  String get error_invoice_access_denied =>
      'Invoice not found or not accessible.';

  @override
  String get error_mail_not_configured =>
      'Sending emails is not set up on this server (SMTP settings in docker/.env).';

  @override
  String get error_send_limit =>
      'Limit reached: 20 emails a day. Try again tomorrow.';
}
