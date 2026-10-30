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
}
