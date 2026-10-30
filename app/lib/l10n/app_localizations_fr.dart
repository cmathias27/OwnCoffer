// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'OwnCoffer';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get language => 'Langue';

  @override
  String get error_generic => 'Une erreur est survenue. Réessayez.';

  @override
  String get error_not_authenticated =>
      'Votre session a expiré. Reconnectez-vous.';

  @override
  String get error_group_access_denied =>
      'Ce groupe n\'existe pas ou vous n\'y avez pas accès.';

  @override
  String get error_account_access_denied =>
      'Ce compte n\'existe pas ou vous n\'y avez pas accès.';

  @override
  String get error_server_admin_only =>
      'Seul l\'administrateur du serveur peut faire cela.';

  @override
  String get error_invalid_name =>
      'Le nom doit contenir entre 1 et 80 caractères.';

  @override
  String get error_invalid_email => 'Cette adresse email n\'est pas valide.';

  @override
  String get error_amount_out_of_range => 'Ce montant est trop grand.';

  @override
  String get error_last_admin =>
      'Le groupe doit garder au moins un administrateur.';

  @override
  String get error_not_a_member =>
      'Cette personne ne fait pas partie du groupe.';

  @override
  String get error_setup_done => 'Le serveur est déjà installé.';

  @override
  String get error_setup_code_invalid =>
      'Code d\'installation incorrect. Il s\'affiche dans le journal du serveur.';

  @override
  String get error_registration_closed =>
      'L\'inscription se fait uniquement sur invitation.';

  @override
  String get error_invitation_invalid =>
      'Cette invitation n\'est plus valable.';

  @override
  String get error_invitation_other_email =>
      'Cette invitation a été envoyée à une autre adresse email.';

  @override
  String import_error_missing_date(int line) {
    return 'Ligne $line : date absente';
  }

  @override
  String import_error_invalid_date(int line) {
    return 'Ligne $line : date illisible';
  }

  @override
  String import_error_missing_amount(int line) {
    return 'Ligne $line : montant absent';
  }

  @override
  String import_error_invalid_amount(int line) {
    return 'Ligne $line : montant illisible';
  }

  @override
  String import_error_debit_and_credit(int line) {
    return 'Ligne $line : débit et crédit remplis tous les deux';
  }

  @override
  String import_error_missing_label(int line) {
    return 'Ligne $line : libellé absent';
  }

  @override
  String import_error_qif_missing_end(int line) {
    return 'Ligne $line : fin d\'opération manquante';
  }

  @override
  String import_error_qif_section_skipped(int line) {
    return 'Ligne $line : section ignorée';
  }

  @override
  String import_error_qif_split_ignored(int line) {
    return 'Ligne $line : ventilation ignorée, seul le total est importé';
  }

  @override
  String import_error_ofx_balance_unreadable(int line) {
    return 'Ligne $line : solde de la banque illisible';
  }

  @override
  String get import_format_qif_no_header =>
      'Ce fichier QIF n\'a pas d\'en-tête « !Type ».';

  @override
  String get import_format_ofx_no_root => 'Ce fichier OFX est incomplet.';

  @override
  String get import_format_csv_columns_unknown =>
      'Colonnes non reconnues : choisissez-les.';

  @override
  String get import_format_empty_file => 'Le fichier est vide.';

  @override
  String get import_format_unknown_format =>
      'Format non reconnu. Formats acceptés : QIF, OFX, CSV.';
}
