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
  String get error_two_factor_required =>
      'Saisissez d\'abord votre code de double authentification.';

  @override
  String get error_two_factor_code_invalid => 'Code incorrect ou déjà utilisé.';

  @override
  String get error_two_factor_already_enabled =>
      'La double authentification est déjà activée.';

  @override
  String get error_two_factor_not_started =>
      'Commencez par scanner le QR code dans votre application.';

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

  @override
  String get continueLabel => 'Continuer';

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get save => 'Enregistrer';

  @override
  String get retry => 'Réessayer';

  @override
  String get emailLabel => 'Adresse email';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordConfirmLabel => 'Confirmer le mot de passe';

  @override
  String get passwordHelp => '8 caractères au minimum.';

  @override
  String get passwordsDiffer => 'Les deux mots de passe sont différents.';

  @override
  String get verificationCodeLabel => 'Code reçu par email';

  @override
  String get verificationCodeHelp =>
      'Sans serveur d\'envoi configuré, le code s\'affiche dans le journal du serveur.';

  @override
  String get setupTitle => 'Installation d\'OwnCoffer';

  @override
  String get setupIntro =>
      'Bienvenue ! Créez le compte administrateur de ce serveur.';

  @override
  String get setupCodeLabel => 'Code d\'installation';

  @override
  String get setupCodeHelp =>
      'Code à 8 chiffres affiché dans le journal du serveur : docker compose logs owncoffer | grep \"setup code\"';

  @override
  String get setupStepAdmin => 'Administrateur';

  @override
  String get setupStepVerify => 'Vérification';

  @override
  String get setupStepPassword => 'Mot de passe';

  @override
  String get setupStepGroup => 'Groupe';

  @override
  String verifyIntro(String email) {
    return 'Un code a été envoyé à $email.';
  }

  @override
  String get groupNameLabel => 'Nom du groupe';

  @override
  String get groupNameHint => 'Par exemple : Notre foyer';

  @override
  String get groupIntro =>
      'Un groupe réunit les personnes qui partagent des comptes (un foyer, une association…).';

  @override
  String get signInTitle => 'Connexion';

  @override
  String get signIn => 'Se connecter';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get haveInvitation => 'J\'ai reçu une invitation';

  @override
  String get registerTitle => 'Créer mon compte';

  @override
  String get registerIntro =>
      'Saisissez l\'adresse email à laquelle l\'invitation a été envoyée.';

  @override
  String get resetTitle => 'Nouveau mot de passe';

  @override
  String get resetIntro =>
      'Saisissez votre adresse email : un code vous sera envoyé.';

  @override
  String get resetDone => 'Mot de passe changé. Vous pouvez vous connecter.';

  @override
  String get totpTitle => 'Double authentification';

  @override
  String get totpIntro =>
      'Saisissez le code à 6 chiffres de votre application d\'authentification, ou un code de secours.';

  @override
  String get totpCodeLabel => 'Code';

  @override
  String get verify => 'Valider';

  @override
  String get homeNoGroup =>
      'Vous ne faites encore partie d\'aucun groupe. Demandez une invitation à un administrateur.';

  @override
  String get groupLabel => 'Groupe';

  @override
  String get menuSecurity => 'Sécurité';

  @override
  String get menuMembers => 'Membres';

  @override
  String get accountsComingSoon =>
      'Vos comptes et opérations arrivent bientôt ici.';

  @override
  String get securityTitle => 'Sécurité';

  @override
  String get twoFactorTitle => 'Double authentification (TOTP)';

  @override
  String get twoFactorOff =>
      'Désactivée. Recommandée, surtout pour les administrateurs.';

  @override
  String twoFactorOn(int count) {
    return 'Activée — $count codes de secours restants.';
  }

  @override
  String get twoFactorEnable => 'Activer';

  @override
  String get twoFactorScan =>
      'Scannez ce QR code avec votre application d\'authentification (Aegis, FreeOTP, Google Authenticator…), puis saisissez le code affiché.';

  @override
  String get twoFactorSecretManual => 'Ou saisissez cette clé à la main :';

  @override
  String get backupCodesTitle => 'Codes de secours';

  @override
  String get backupCodesIntro =>
      'Notez-les et gardez-les en lieu sûr : chacun permet une connexion si vous perdez votre téléphone. Ils ne seront plus affichés.';

  @override
  String get backupCodesDone => 'J\'ai noté mes codes';

  @override
  String get twoFactorDisable => 'Désactiver';

  @override
  String get twoFactorDisableIntro =>
      'Saisissez un code pour désactiver la double authentification.';

  @override
  String get twoFactorRenew => 'Nouveaux codes de secours';

  @override
  String get membersTitle => 'Membres';

  @override
  String get invitationsTitle => 'Invitations en attente';

  @override
  String get noInvitations => 'Aucune invitation en attente.';

  @override
  String get invite => 'Inviter';

  @override
  String get inviteTitle => 'Inviter une personne';

  @override
  String get roleLabel => 'Rôle';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleUser => 'Utilisateur';

  @override
  String get roleReader => 'Lecteur';

  @override
  String get roleHelp =>
      'Lecteur : consulte. Utilisateur : saisit et importe. Administrateur : gère les comptes et les membres.';

  @override
  String invitationSent(String email) {
    return 'Invitation envoyée à $email.';
  }

  @override
  String invitationExpires(String date) {
    return 'expire le $date';
  }

  @override
  String get revoke => 'Révoquer';

  @override
  String get you => 'vous';

  @override
  String invitationAccepted(String group) {
    return 'Vous avez rejoint « $group ».';
  }

  @override
  String get error_login_failed => 'Email ou mot de passe incorrect.';

  @override
  String get error_too_many_attempts => 'Trop d\'essais. Réessayez plus tard.';

  @override
  String get error_code_invalid => 'Code incorrect.';

  @override
  String get error_code_expired => 'Ce code a expiré. Recommencez.';

  @override
  String get error_password_policy =>
      'Ce mot de passe n\'est pas accepté : 8 caractères au minimum, sans espace au début ni à la fin.';

  @override
  String get error_ip_banned =>
      'Trop d\'échecs depuis cette adresse : l\'accès est bloqué temporairement.';

  @override
  String get error_rate_limited => 'Trop de requêtes. Patientez une minute.';

  @override
  String get error_network =>
      'Le serveur ne répond pas. Vérifiez votre connexion.';

  @override
  String get copy => 'Copier';

  @override
  String get error_category_access_denied =>
      'Cette catégorie n\'existe pas ou vous n\'y avez pas accès.';

  @override
  String get error_rule_access_denied =>
      'Cette règle n\'existe pas ou vous n\'y avez pas accès.';

  @override
  String get error_unknown_standard_category => 'Catégorie standard inconnue.';

  @override
  String get error_invalid_pattern =>
      'Le motif doit contenir entre 1 et 100 caractères (lettres ou chiffres).';

  @override
  String get error_invalid_amount_range =>
      'Le montant minimum dépasse le montant maximum.';
}
