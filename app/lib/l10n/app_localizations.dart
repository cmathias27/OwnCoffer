import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'OwnCoffer'**
  String get appTitle;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @error_generic.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessayez.'**
  String get error_generic;

  /// No description provided for @error_not_authenticated.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré. Reconnectez-vous.'**
  String get error_not_authenticated;

  /// No description provided for @error_group_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Ce groupe n\'existe pas ou vous n\'y avez pas accès.'**
  String get error_group_access_denied;

  /// No description provided for @error_account_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte n\'existe pas ou vous n\'y avez pas accès.'**
  String get error_account_access_denied;

  /// No description provided for @error_server_admin_only.
  ///
  /// In fr, this message translates to:
  /// **'Seul l\'administrateur du serveur peut faire cela.'**
  String get error_server_admin_only;

  /// No description provided for @error_invalid_name.
  ///
  /// In fr, this message translates to:
  /// **'Le nom doit contenir entre 1 et 80 caractères.'**
  String get error_invalid_name;

  /// No description provided for @error_invalid_email.
  ///
  /// In fr, this message translates to:
  /// **'Cette adresse email n\'est pas valide.'**
  String get error_invalid_email;

  /// No description provided for @error_amount_out_of_range.
  ///
  /// In fr, this message translates to:
  /// **'Ce montant est trop grand.'**
  String get error_amount_out_of_range;

  /// No description provided for @error_last_admin.
  ///
  /// In fr, this message translates to:
  /// **'Le groupe doit garder au moins un administrateur.'**
  String get error_last_admin;

  /// No description provided for @error_not_a_member.
  ///
  /// In fr, this message translates to:
  /// **'Cette personne ne fait pas partie du groupe.'**
  String get error_not_a_member;

  /// No description provided for @error_setup_done.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur est déjà installé.'**
  String get error_setup_done;

  /// No description provided for @error_setup_code_invalid.
  ///
  /// In fr, this message translates to:
  /// **'Code d\'installation incorrect. Il s\'affiche dans le journal du serveur.'**
  String get error_setup_code_invalid;

  /// No description provided for @error_registration_closed.
  ///
  /// In fr, this message translates to:
  /// **'L\'inscription se fait uniquement sur invitation.'**
  String get error_registration_closed;

  /// No description provided for @error_invitation_invalid.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation n\'est plus valable.'**
  String get error_invitation_invalid;

  /// No description provided for @error_invitation_other_email.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation a été envoyée à une autre adresse email.'**
  String get error_invitation_other_email;

  /// No description provided for @error_two_factor_required.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez d\'abord votre code de double authentification.'**
  String get error_two_factor_required;

  /// No description provided for @error_two_factor_code_invalid.
  ///
  /// In fr, this message translates to:
  /// **'Code incorrect ou déjà utilisé.'**
  String get error_two_factor_code_invalid;

  /// No description provided for @error_two_factor_already_enabled.
  ///
  /// In fr, this message translates to:
  /// **'La double authentification est déjà activée.'**
  String get error_two_factor_already_enabled;

  /// No description provided for @error_two_factor_not_started.
  ///
  /// In fr, this message translates to:
  /// **'Commencez par scanner le QR code dans votre application.'**
  String get error_two_factor_not_started;

  /// No description provided for @import_error_missing_date.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : date absente'**
  String import_error_missing_date(int line);

  /// No description provided for @import_error_invalid_date.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : date illisible'**
  String import_error_invalid_date(int line);

  /// No description provided for @import_error_missing_amount.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : montant absent'**
  String import_error_missing_amount(int line);

  /// No description provided for @import_error_invalid_amount.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : montant illisible'**
  String import_error_invalid_amount(int line);

  /// No description provided for @import_error_debit_and_credit.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : débit et crédit remplis tous les deux'**
  String import_error_debit_and_credit(int line);

  /// No description provided for @import_error_missing_label.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : libellé absent'**
  String import_error_missing_label(int line);

  /// No description provided for @import_error_qif_missing_end.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : fin d\'opération manquante'**
  String import_error_qif_missing_end(int line);

  /// No description provided for @import_error_qif_section_skipped.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : section ignorée'**
  String import_error_qif_section_skipped(int line);

  /// No description provided for @import_error_qif_split_ignored.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : ventilation ignorée, seul le total est importé'**
  String import_error_qif_split_ignored(int line);

  /// No description provided for @import_error_ofx_balance_unreadable.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : solde de la banque illisible'**
  String import_error_ofx_balance_unreadable(int line);

  /// No description provided for @import_format_qif_no_header.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier QIF n\'a pas d\'en-tête « !Type ».'**
  String get import_format_qif_no_header;

  /// No description provided for @import_format_ofx_no_root.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier OFX est incomplet.'**
  String get import_format_ofx_no_root;

  /// No description provided for @import_format_csv_columns_unknown.
  ///
  /// In fr, this message translates to:
  /// **'Colonnes non reconnues : choisissez-les.'**
  String get import_format_csv_columns_unknown;

  /// No description provided for @import_format_empty_file.
  ///
  /// In fr, this message translates to:
  /// **'Le fichier est vide.'**
  String get import_format_empty_file;

  /// No description provided for @import_format_unknown_format.
  ///
  /// In fr, this message translates to:
  /// **'Format non reconnu. Formats acceptés : QIF, OFX, CSV.'**
  String get import_format_unknown_format;

  /// No description provided for @continueLabel.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueLabel;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @passwordConfirmLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get passwordConfirmLabel;

  /// No description provided for @passwordHelp.
  ///
  /// In fr, this message translates to:
  /// **'8 caractères au minimum.'**
  String get passwordHelp;

  /// No description provided for @passwordsDiffer.
  ///
  /// In fr, this message translates to:
  /// **'Les deux mots de passe sont différents.'**
  String get passwordsDiffer;

  /// No description provided for @verificationCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code reçu par email'**
  String get verificationCodeLabel;

  /// No description provided for @verificationCodeHelp.
  ///
  /// In fr, this message translates to:
  /// **'Sans serveur d\'envoi configuré, le code s\'affiche dans le journal du serveur.'**
  String get verificationCodeHelp;

  /// No description provided for @setupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Installation d\'OwnCoffer'**
  String get setupTitle;

  /// No description provided for @setupIntro.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue ! Créez le compte administrateur de ce serveur.'**
  String get setupIntro;

  /// No description provided for @setupCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code d\'installation'**
  String get setupCodeLabel;

  /// No description provided for @setupCodeHelp.
  ///
  /// In fr, this message translates to:
  /// **'Code à 8 chiffres affiché dans le journal du serveur : docker compose logs owncoffer | grep \"setup code\"'**
  String get setupCodeHelp;

  /// No description provided for @setupStepAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get setupStepAdmin;

  /// No description provided for @setupStepVerify.
  ///
  /// In fr, this message translates to:
  /// **'Vérification'**
  String get setupStepVerify;

  /// No description provided for @setupStepPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get setupStepPassword;

  /// No description provided for @setupStepGroup.
  ///
  /// In fr, this message translates to:
  /// **'Groupe'**
  String get setupStepGroup;

  /// No description provided for @verifyIntro.
  ///
  /// In fr, this message translates to:
  /// **'Un code a été envoyé à {email}.'**
  String verifyIntro(String email);

  /// No description provided for @groupNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du groupe'**
  String get groupNameLabel;

  /// No description provided for @groupNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Par exemple : Notre foyer'**
  String get groupNameHint;

  /// No description provided for @groupIntro.
  ///
  /// In fr, this message translates to:
  /// **'Un groupe réunit les personnes qui partagent des comptes (un foyer, une association…).'**
  String get groupIntro;

  /// No description provided for @signInTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get signInTitle;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @haveInvitation.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai reçu une invitation'**
  String get haveInvitation;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get registerTitle;

  /// No description provided for @registerIntro.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez l\'adresse email à laquelle l\'invitation a été envoyée.'**
  String get registerIntro;

  /// No description provided for @resetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get resetTitle;

  /// No description provided for @resetIntro.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre adresse email : un code vous sera envoyé.'**
  String get resetIntro;

  /// No description provided for @resetDone.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe changé. Vous pouvez vous connecter.'**
  String get resetDone;

  /// No description provided for @totpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Double authentification'**
  String get totpTitle;

  /// No description provided for @totpIntro.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code à 6 chiffres de votre application d\'authentification, ou un code de secours.'**
  String get totpIntro;

  /// No description provided for @totpCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code'**
  String get totpCodeLabel;

  /// No description provided for @verify.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get verify;

  /// No description provided for @homeNoGroup.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne faites encore partie d\'aucun groupe. Demandez une invitation à un administrateur.'**
  String get homeNoGroup;

  /// No description provided for @groupLabel.
  ///
  /// In fr, this message translates to:
  /// **'Groupe'**
  String get groupLabel;

  /// No description provided for @menuSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get menuSecurity;

  /// No description provided for @menuMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get menuMembers;

  /// No description provided for @accountsComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Vos comptes et opérations arrivent bientôt ici.'**
  String get accountsComingSoon;

  /// No description provided for @securityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get securityTitle;

  /// No description provided for @twoFactorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Double authentification (TOTP)'**
  String get twoFactorTitle;

  /// No description provided for @twoFactorOff.
  ///
  /// In fr, this message translates to:
  /// **'Désactivée. Recommandée, surtout pour les administrateurs.'**
  String get twoFactorOff;

  /// No description provided for @twoFactorOn.
  ///
  /// In fr, this message translates to:
  /// **'Activée — {count} codes de secours restants.'**
  String twoFactorOn(int count);

  /// No description provided for @twoFactorEnable.
  ///
  /// In fr, this message translates to:
  /// **'Activer'**
  String get twoFactorEnable;

  /// No description provided for @twoFactorScan.
  ///
  /// In fr, this message translates to:
  /// **'Scannez ce QR code avec votre application d\'authentification (Aegis, FreeOTP, Google Authenticator…), puis saisissez le code affiché.'**
  String get twoFactorScan;

  /// No description provided for @twoFactorSecretManual.
  ///
  /// In fr, this message translates to:
  /// **'Ou saisissez cette clé à la main :'**
  String get twoFactorSecretManual;

  /// No description provided for @backupCodesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Codes de secours'**
  String get backupCodesTitle;

  /// No description provided for @backupCodesIntro.
  ///
  /// In fr, this message translates to:
  /// **'Notez-les et gardez-les en lieu sûr : chacun permet une connexion si vous perdez votre téléphone. Ils ne seront plus affichés.'**
  String get backupCodesIntro;

  /// No description provided for @backupCodesDone.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai noté mes codes'**
  String get backupCodesDone;

  /// No description provided for @twoFactorDisable.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver'**
  String get twoFactorDisable;

  /// No description provided for @twoFactorDisableIntro.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez un code pour désactiver la double authentification.'**
  String get twoFactorDisableIntro;

  /// No description provided for @twoFactorRenew.
  ///
  /// In fr, this message translates to:
  /// **'Nouveaux codes de secours'**
  String get twoFactorRenew;

  /// No description provided for @membersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get membersTitle;

  /// No description provided for @invitationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Invitations en attente'**
  String get invitationsTitle;

  /// No description provided for @noInvitations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune invitation en attente.'**
  String get noInvitations;

  /// No description provided for @invite.
  ///
  /// In fr, this message translates to:
  /// **'Inviter'**
  String get invite;

  /// No description provided for @inviteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inviter une personne'**
  String get inviteTitle;

  /// No description provided for @roleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rôle'**
  String get roleLabel;

  /// No description provided for @roleAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get roleAdmin;

  /// No description provided for @roleUser.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get roleUser;

  /// No description provided for @roleReader.
  ///
  /// In fr, this message translates to:
  /// **'Lecteur'**
  String get roleReader;

  /// No description provided for @roleHelp.
  ///
  /// In fr, this message translates to:
  /// **'Lecteur : consulte. Utilisateur : saisit et importe. Administrateur : gère les comptes et les membres.'**
  String get roleHelp;

  /// No description provided for @invitationSent.
  ///
  /// In fr, this message translates to:
  /// **'Invitation envoyée à {email}.'**
  String invitationSent(String email);

  /// No description provided for @invitationExpires.
  ///
  /// In fr, this message translates to:
  /// **'expire le {date}'**
  String invitationExpires(String date);

  /// No description provided for @revoke.
  ///
  /// In fr, this message translates to:
  /// **'Révoquer'**
  String get revoke;

  /// No description provided for @you.
  ///
  /// In fr, this message translates to:
  /// **'vous'**
  String get you;

  /// No description provided for @invitationAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez rejoint « {group} ».'**
  String invitationAccepted(String group);

  /// No description provided for @error_login_failed.
  ///
  /// In fr, this message translates to:
  /// **'Email ou mot de passe incorrect.'**
  String get error_login_failed;

  /// No description provided for @error_too_many_attempts.
  ///
  /// In fr, this message translates to:
  /// **'Trop d\'essais. Réessayez plus tard.'**
  String get error_too_many_attempts;

  /// No description provided for @error_code_invalid.
  ///
  /// In fr, this message translates to:
  /// **'Code incorrect.'**
  String get error_code_invalid;

  /// No description provided for @error_code_expired.
  ///
  /// In fr, this message translates to:
  /// **'Ce code a expiré. Recommencez.'**
  String get error_code_expired;

  /// No description provided for @error_password_policy.
  ///
  /// In fr, this message translates to:
  /// **'Ce mot de passe n\'est pas accepté : 8 caractères au minimum, sans espace au début ni à la fin.'**
  String get error_password_policy;

  /// No description provided for @error_ip_banned.
  ///
  /// In fr, this message translates to:
  /// **'Trop d\'échecs depuis cette adresse : l\'accès est bloqué temporairement.'**
  String get error_ip_banned;

  /// No description provided for @error_rate_limited.
  ///
  /// In fr, this message translates to:
  /// **'Trop de requêtes. Patientez une minute.'**
  String get error_rate_limited;

  /// No description provided for @error_network.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur ne répond pas. Vérifiez votre connexion.'**
  String get error_network;

  /// No description provided for @copy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copy;

  /// No description provided for @error_category_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Cette catégorie n\'existe pas ou vous n\'y avez pas accès.'**
  String get error_category_access_denied;

  /// No description provided for @error_rule_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Cette règle n\'existe pas ou vous n\'y avez pas accès.'**
  String get error_rule_access_denied;

  /// No description provided for @error_unknown_standard_category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie standard inconnue.'**
  String get error_unknown_standard_category;

  /// No description provided for @error_invalid_pattern.
  ///
  /// In fr, this message translates to:
  /// **'Le motif doit contenir entre 1 et 100 caractères (lettres ou chiffres).'**
  String get error_invalid_pattern;

  /// No description provided for @error_invalid_amount_range.
  ///
  /// In fr, this message translates to:
  /// **'Le montant minimum dépasse le montant maximum.'**
  String get error_invalid_amount_range;

  /// No description provided for @error_import_file_too_large.
  ///
  /// In fr, this message translates to:
  /// **'Fichier trop volumineux (4 Mo au maximum).'**
  String get error_import_file_too_large;

  /// No description provided for @error_import_nothing_readable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune opération lisible dans ce fichier.'**
  String get error_import_nothing_readable;

  /// No description provided for @error_import_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Cet import n\'existe pas ou vous n\'y avez pas accès.'**
  String get error_import_access_denied;

  /// No description provided for @error_scheduled_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Cette opération prévue n\'existe pas ou vous n\'y avez pas accès.'**
  String get error_scheduled_access_denied;

  /// No description provided for @error_invalid_interval.
  ///
  /// In fr, this message translates to:
  /// **'La périodicité doit être comprise entre 1 et 120.'**
  String get error_invalid_interval;

  /// No description provided for @error_invalid_tolerance.
  ///
  /// In fr, this message translates to:
  /// **'Tolérance invalide (0 à 31 jours, 0 à 100 %).'**
  String get error_invalid_tolerance;

  /// No description provided for @error_invalid_recurrence.
  ///
  /// In fr, this message translates to:
  /// **'La date de fin est avant la date de début.'**
  String get error_invalid_recurrence;

  /// No description provided for @error_invalid_date.
  ///
  /// In fr, this message translates to:
  /// **'Date invalide.'**
  String get error_invalid_date;

  /// No description provided for @error_invalid_horizon.
  ///
  /// In fr, this message translates to:
  /// **'La durée de prévision doit être comprise entre 1 et 366 jours.'**
  String get error_invalid_horizon;

  /// No description provided for @error_transaction_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Cette opération n\'existe pas ou vous n\'y avez pas accès.'**
  String get error_transaction_access_denied;

  /// No description provided for @error_imported_operation_locked.
  ///
  /// In fr, this message translates to:
  /// **'La date, le montant et le libellé d\'une opération importée ne se modifient pas : ce sont ceux de la banque.'**
  String get error_imported_operation_locked;

  /// No description provided for @error_already_imported_again.
  ///
  /// In fr, this message translates to:
  /// **'Cette opération a été réimportée entre-temps : elle est déjà dans le compte.'**
  String get error_already_imported_again;

  /// No description provided for @error_notification_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Cette notification n\'existe pas.'**
  String get error_notification_access_denied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
