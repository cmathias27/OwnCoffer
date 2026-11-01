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
  /// **'Vous ne faites encore partie d\'aucun groupe. Si vous administrez ce serveur, créez votre foyer ci-dessous ; sinon, demandez une invitation à son administrateur.'**
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

  /// No description provided for @error_invalid_amount.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide : il doit être positif et raisonnable.'**
  String get error_invalid_amount;

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

  /// No description provided for @navAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes'**
  String get navAccounts;

  /// No description provided for @navOperations.
  ///
  /// In fr, this message translates to:
  /// **'Opérations'**
  String get navOperations;

  /// No description provided for @navImport.
  ///
  /// In fr, this message translates to:
  /// **'Importer'**
  String get navImport;

  /// No description provided for @navForecast.
  ///
  /// In fr, this message translates to:
  /// **'Prévisions'**
  String get navForecast;

  /// No description provided for @navCategories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get navCategories;

  /// No description provided for @accountsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comptes'**
  String get accountsTitle;

  /// No description provided for @accountsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte pour l\'instant.'**
  String get accountsEmpty;

  /// No description provided for @accountAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un compte'**
  String get accountAdd;

  /// No description provided for @accountEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le compte'**
  String get accountEdit;

  /// No description provided for @accountName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du compte'**
  String get accountName;

  /// No description provided for @accountBank.
  ///
  /// In fr, this message translates to:
  /// **'Banque'**
  String get accountBank;

  /// No description provided for @accountKind.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get accountKind;

  /// No description provided for @kindChecking.
  ///
  /// In fr, this message translates to:
  /// **'Compte courant'**
  String get kindChecking;

  /// No description provided for @kindSavings.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get kindSavings;

  /// No description provided for @kindDeferredCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte à débit différé'**
  String get kindDeferredCard;

  /// No description provided for @kindCash.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get kindCash;

  /// No description provided for @initialBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde initial'**
  String get initialBalance;

  /// No description provided for @initialBalanceHelp.
  ///
  /// In fr, this message translates to:
  /// **'Solde du compte avant la première opération importée.'**
  String get initialBalanceHelp;

  /// No description provided for @alertThreshold.
  ///
  /// In fr, this message translates to:
  /// **'Seuil d\'alerte'**
  String get alertThreshold;

  /// No description provided for @alertThresholdHelp.
  ///
  /// In fr, this message translates to:
  /// **'Alerte quand le solde prévu passe en dessous. 0 = tout découvert ; -500 = découvert autorisé de 500.'**
  String get alertThresholdHelp;

  /// No description provided for @visibilityRestricted.
  ///
  /// In fr, this message translates to:
  /// **'Compte restreint (visible seulement par les administrateurs et les personnes autorisées)'**
  String get visibilityRestricted;

  /// No description provided for @balanceCurrent.
  ///
  /// In fr, this message translates to:
  /// **'Solde actuel'**
  String get balanceCurrent;

  /// No description provided for @balanceCleared.
  ///
  /// In fr, this message translates to:
  /// **'Solde pointé'**
  String get balanceCleared;

  /// No description provided for @forecastLowest.
  ///
  /// In fr, this message translates to:
  /// **'Point bas à 30 jours : {amount} le {date}'**
  String forecastLowest(String amount, String date);

  /// No description provided for @overdraftExpected.
  ///
  /// In fr, this message translates to:
  /// **'Découvert prévu le {date}'**
  String overdraftExpected(String date);

  /// No description provided for @amountInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Montant illisible. Exemple : -12,50'**
  String get amountInvalid;

  /// No description provided for @operationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Opérations'**
  String get operationsTitle;

  /// No description provided for @operationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune opération.'**
  String get operationsEmpty;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un libellé'**
  String get searchHint;

  /// No description provided for @filterToClassify.
  ///
  /// In fr, this message translates to:
  /// **'À classer'**
  String get filterToClassify;

  /// No description provided for @filterUncleared.
  ///
  /// In fr, this message translates to:
  /// **'Non pointées'**
  String get filterUncleared;

  /// No description provided for @loadMore.
  ///
  /// In fr, this message translates to:
  /// **'Afficher plus'**
  String get loadMore;

  /// No description provided for @operationsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} opérations'**
  String operationsCount(int count);

  /// No description provided for @toClassify.
  ///
  /// In fr, this message translates to:
  /// **'À classer'**
  String get toClassify;

  /// No description provided for @operationAdd.
  ///
  /// In fr, this message translates to:
  /// **'Saisir une opération'**
  String get operationAdd;

  /// No description provided for @dateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @amountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amountLabel;

  /// No description provided for @amountHelp.
  ///
  /// In fr, this message translates to:
  /// **'Négatif pour une dépense : -12,50'**
  String get amountHelp;

  /// No description provided for @labelLabel.
  ///
  /// In fr, this message translates to:
  /// **'Libellé'**
  String get labelLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get categoryLabel;

  /// No description provided for @noCategory.
  ///
  /// In fr, this message translates to:
  /// **'À classer'**
  String get noCategory;

  /// No description provided for @categorySearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une catégorie'**
  String get categorySearchHint;

  /// No description provided for @categorySearchEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune catégorie ne correspond.'**
  String get categorySearchEmpty;

  /// No description provided for @categoryCreateNamed.
  ///
  /// In fr, this message translates to:
  /// **'Créer la catégorie « {name} »'**
  String categoryCreateNamed(String name);

  /// No description provided for @cleared.
  ///
  /// In fr, this message translates to:
  /// **'Pointée'**
  String get cleared;

  /// No description provided for @bankLabel.
  ///
  /// In fr, this message translates to:
  /// **'Libellé de la banque'**
  String get bankLabel;

  /// No description provided for @alwaysClassify.
  ///
  /// In fr, this message translates to:
  /// **'Toujours classer ainsi'**
  String get alwaysClassify;

  /// No description provided for @ruleCreated.
  ///
  /// In fr, this message translates to:
  /// **'Règle créée : {count} autres opérations reclassées.'**
  String ruleCreated(int count);

  /// No description provided for @trash.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à la corbeille'**
  String get trash;

  /// No description provided for @trashed.
  ///
  /// In fr, this message translates to:
  /// **'Opération mise à la corbeille.'**
  String get trashed;

  /// No description provided for @undo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get undo;

  /// No description provided for @sourceManual.
  ///
  /// In fr, this message translates to:
  /// **'choisie par vous'**
  String get sourceManual;

  /// No description provided for @sourceGroupRule.
  ///
  /// In fr, this message translates to:
  /// **'règle du groupe'**
  String get sourceGroupRule;

  /// No description provided for @sourceCommunityRule.
  ///
  /// In fr, this message translates to:
  /// **'règle communautaire'**
  String get sourceCommunityRule;

  /// No description provided for @sourceHistory.
  ///
  /// In fr, this message translates to:
  /// **'historique'**
  String get sourceHistory;

  /// No description provided for @sourceAi.
  ///
  /// In fr, this message translates to:
  /// **'IA'**
  String get sourceAi;

  /// No description provided for @chooseAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get chooseAccount;

  /// No description provided for @clearedBalanceValue.
  ///
  /// In fr, this message translates to:
  /// **'Solde pointé : {amount}'**
  String clearedBalanceValue(String amount);

  /// No description provided for @bankLabelValue.
  ///
  /// In fr, this message translates to:
  /// **'Libellé de la banque : {label}'**
  String bankLabelValue(String label);

  /// No description provided for @dateValue.
  ///
  /// In fr, this message translates to:
  /// **'Date : {date}'**
  String dateValue(String date);

  /// No description provided for @webSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher ce libellé sur Google'**
  String get webSearch;

  /// No description provided for @webSearchHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ouvre Google dans un nouvel onglet avec le libellé nettoyé (pas le libellé complet de la banque).'**
  String get webSearchHelp;

  /// No description provided for @noteLabel.
  ///
  /// In fr, this message translates to:
  /// **'Votre note'**
  String get noteLabel;

  /// No description provided for @importTitle.
  ///
  /// In fr, this message translates to:
  /// **'Importer un relevé'**
  String get importTitle;

  /// No description provided for @importChooseFile.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un fichier'**
  String get importChooseFile;

  /// No description provided for @importOtherFile.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un autre fichier'**
  String get importOtherFile;

  /// No description provided for @importFormats.
  ///
  /// In fr, this message translates to:
  /// **'QIF, OFX ou CSV, 4 Mo au maximum. Le fichier n\'est envoyé qu\'à votre serveur OwnCoffer.'**
  String get importFormats;

  /// No description provided for @importReaderOnly.
  ///
  /// In fr, this message translates to:
  /// **'Avec le rôle Lecteur, vous ne pouvez pas importer.'**
  String get importReaderOnly;

  /// No description provided for @importNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créez d\'abord un compte dans l\'onglet Comptes.'**
  String get importNoAccount;

  /// No description provided for @importFileInfo.
  ///
  /// In fr, this message translates to:
  /// **'{name} : format {format}, encodage {encoding}'**
  String importFileInfo(String name, String format, String encoding);

  /// No description provided for @importCountRead.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune opération lue} =1{1 opération lue} other{{count} opérations lues}}'**
  String importCountRead(int count);

  /// No description provided for @importCountNew.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 nouvelle} other{{count} nouvelles}}'**
  String importCountNew(int count);

  /// No description provided for @importCountDuplicate.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 déjà présente} other{{count} déjà présentes}}'**
  String importCountDuplicate(int count);

  /// No description provided for @importCountPossible.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 doublon possible} other{{count} doublons possibles}}'**
  String importCountPossible(int count);

  /// No description provided for @importCountClassified.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 classée} other{{count} classées}}'**
  String importCountClassified(int count);

  /// No description provided for @importCountErrors.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 erreur} other{{count} erreurs}}'**
  String importCountErrors(int count);

  /// No description provided for @importSameFile.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier a déjà été importé dans ce compte.'**
  String get importSameFile;

  /// No description provided for @importBankBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde indiqué par la banque le {date} : {amount}'**
  String importBankBalance(String date, String amount);

  /// No description provided for @importBalanceMatches.
  ///
  /// In fr, this message translates to:
  /// **'Après l\'import, OwnCoffer aura le même solde à cette date.'**
  String get importBalanceMatches;

  /// No description provided for @importBalanceDiffers.
  ///
  /// In fr, this message translates to:
  /// **'Après l\'import, OwnCoffer affichera {amount} à cette date, soit un écart de {gap}. Vérifiez le solde initial du compte ou s\'il manque des opérations plus anciennes.'**
  String importBalanceDiffers(String amount, String gap);

  /// No description provided for @importIssues.
  ///
  /// In fr, this message translates to:
  /// **'Remarques sur le fichier'**
  String get importIssues;

  /// No description provided for @importStatusNew.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle'**
  String get importStatusNew;

  /// No description provided for @importStatusDuplicate.
  ///
  /// In fr, this message translates to:
  /// **'Déjà présente'**
  String get importStatusDuplicate;

  /// No description provided for @importStatusPossible.
  ///
  /// In fr, this message translates to:
  /// **'Doublon possible'**
  String get importStatusPossible;

  /// No description provided for @importPossibleHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un doublon possible a la même date et le même montant qu\'une opération déjà présente, avec un libellé différent. Cochez ceux à importer quand même.'**
  String get importPossibleHelp;

  /// No description provided for @importConfirm.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Rien à importer} =1{Importer 1 opération} other{Importer {count} opérations}}'**
  String importConfirm(int count);

  /// No description provided for @importDone.
  ///
  /// In fr, this message translates to:
  /// **'{added, plural, =0{Aucune opération ajoutée.} =1{1 opération ajoutée, {classified} classée.} other{{added} opérations ajoutées, dont {classified} classées.}}'**
  String importDone(int added, int classified);

  /// No description provided for @importHistory.
  ///
  /// In fr, this message translates to:
  /// **'Imports précédents'**
  String get importHistory;

  /// No description provided for @importHistoryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun import pour ce compte.'**
  String get importHistoryEmpty;

  /// No description provided for @importHistoryLine.
  ///
  /// In fr, this message translates to:
  /// **'{date} · {added} ajoutées, {duplicates} déjà présentes'**
  String importHistoryLine(String date, int added, int duplicates);

  /// No description provided for @importCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get importCancelled;

  /// No description provided for @importCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler cet import'**
  String get importCancel;

  /// No description provided for @importCancelConfirm.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{L\'opération ajoutée par cet import sera mise à la corbeille.} other{Les {count} opérations ajoutées par cet import seront mises à la corbeille.}} Vos corrections sur ces opérations seront perdues.'**
  String importCancelConfirm(int count);

  /// No description provided for @importCancelDone.
  ///
  /// In fr, this message translates to:
  /// **'Import annulé.'**
  String get importCancelDone;

  /// No description provided for @csvTitle.
  ///
  /// In fr, this message translates to:
  /// **'Colonnes du fichier CSV'**
  String get csvTitle;

  /// No description provided for @csvHelp.
  ///
  /// In fr, this message translates to:
  /// **'OwnCoffer ne reconnaît pas l\'en-tête de ce fichier. Indiquez ce que contient chaque colonne.'**
  String get csvHelp;

  /// No description provided for @csvChangeColumns.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les colonnes'**
  String get csvChangeColumns;

  /// No description provided for @csvDelimiter.
  ///
  /// In fr, this message translates to:
  /// **'Séparateur'**
  String get csvDelimiter;

  /// No description provided for @csvTab.
  ///
  /// In fr, this message translates to:
  /// **'Tabulation'**
  String get csvTab;

  /// No description provided for @csvHeaderRow.
  ///
  /// In fr, this message translates to:
  /// **'Ligne d\'en-tête'**
  String get csvHeaderRow;

  /// No description provided for @csvNoHeader.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get csvNoHeader;

  /// No description provided for @csvDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get csvDate;

  /// No description provided for @csvLabel.
  ///
  /// In fr, this message translates to:
  /// **'Libellé'**
  String get csvLabel;

  /// No description provided for @csvMemo.
  ///
  /// In fr, this message translates to:
  /// **'Détail (facultatif)'**
  String get csvMemo;

  /// No description provided for @csvAmountMode.
  ///
  /// In fr, this message translates to:
  /// **'Montants'**
  String get csvAmountMode;

  /// No description provided for @csvOneColumn.
  ///
  /// In fr, this message translates to:
  /// **'Une colonne signée'**
  String get csvOneColumn;

  /// No description provided for @csvDebitCredit.
  ///
  /// In fr, this message translates to:
  /// **'Débit et crédit séparés'**
  String get csvDebitCredit;

  /// No description provided for @csvAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get csvAmount;

  /// No description provided for @csvDebit.
  ///
  /// In fr, this message translates to:
  /// **'Débit'**
  String get csvDebit;

  /// No description provided for @csvCredit.
  ///
  /// In fr, this message translates to:
  /// **'Crédit'**
  String get csvCredit;

  /// No description provided for @csvNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get csvNone;

  /// No description provided for @csvColumn.
  ///
  /// In fr, this message translates to:
  /// **'Colonne {number} : {sample}'**
  String csvColumn(int number, String sample);

  /// No description provided for @csvMonthFirst.
  ///
  /// In fr, this message translates to:
  /// **'Dates au format mois/jour/année (américain)'**
  String get csvMonthFirst;

  /// No description provided for @csvIncomplete.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez au moins la date, le libellé et un montant.'**
  String get csvIncomplete;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @csvRowSample.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {number} : {sample}'**
  String csvRowSample(int number, String sample);

  /// No description provided for @forecastTitle.
  ///
  /// In fr, this message translates to:
  /// **'Solde prévu'**
  String get forecastTitle;

  /// No description provided for @forecastUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Prévision indisponible pour l\'instant.'**
  String get forecastUnavailable;

  /// No description provided for @horizonDays.
  ///
  /// In fr, this message translates to:
  /// **'{count} j'**
  String horizonDays(int count);

  /// No description provided for @horizonYear.
  ///
  /// In fr, this message translates to:
  /// **'1 an'**
  String get horizonYear;

  /// No description provided for @forecastCurrent.
  ///
  /// In fr, this message translates to:
  /// **'Solde actuel : {amount}'**
  String forecastCurrent(String amount);

  /// No description provided for @forecastEnd.
  ///
  /// In fr, this message translates to:
  /// **'Le {date} : {amount}'**
  String forecastEnd(String date, String amount);

  /// No description provided for @forecastThresholdLine.
  ///
  /// In fr, this message translates to:
  /// **'Seuil d\'alerte : {amount}'**
  String forecastThresholdLine(String amount);

  /// No description provided for @forecastChartLabel.
  ///
  /// In fr, this message translates to:
  /// **'Courbe du solde prévu jour par jour'**
  String get forecastChartLabel;

  /// No description provided for @forecastLowestMark.
  ///
  /// In fr, this message translates to:
  /// **'Point bas'**
  String get forecastLowestMark;

  /// No description provided for @forecastProposals.
  ///
  /// In fr, this message translates to:
  /// **'À confirmer'**
  String get forecastProposals;

  /// No description provided for @forecastProposalText.
  ///
  /// In fr, this message translates to:
  /// **'{operation} du {date} réalise-t-elle « {planned} » prévue le {due} ?'**
  String forecastProposalText(
    String operation,
    String date,
    String planned,
    String due,
  );

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @forecastMatched.
  ///
  /// In fr, this message translates to:
  /// **'Rapprochement confirmé.'**
  String get forecastMatched;

  /// No description provided for @forecastMissed.
  ///
  /// In fr, this message translates to:
  /// **'Non arrivées'**
  String get forecastMissed;

  /// No description provided for @forecastMissedText.
  ///
  /// In fr, this message translates to:
  /// **'Prévue le {date}, toujours pas sur le compte.'**
  String forecastMissedText(String date);

  /// No description provided for @forecastSkip.
  ///
  /// In fr, this message translates to:
  /// **'Ne plus l\'attendre'**
  String get forecastSkip;

  /// No description provided for @forecastSkipped.
  ///
  /// In fr, this message translates to:
  /// **'Échéance ignorée.'**
  String get forecastSkipped;

  /// No description provided for @forecastAutoReconciled.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 opération reliée automatiquement à son échéance prévue.} other{{count} opérations reliées automatiquement à leur échéance prévue.}}'**
  String forecastAutoReconciled(int count);

  /// No description provided for @forecastUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get forecastUpcoming;

  /// No description provided for @forecastNoUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'Aucune opération prévue sur cette période.'**
  String get forecastNoUpcoming;

  /// No description provided for @forecastLate.
  ///
  /// In fr, this message translates to:
  /// **'en retard, prévue le {date}'**
  String forecastLate(String date);

  /// No description provided for @forecastBalanceAfter.
  ///
  /// In fr, this message translates to:
  /// **'solde : {amount}'**
  String forecastBalanceAfter(String amount);

  /// No description provided for @scheduledTitle.
  ///
  /// In fr, this message translates to:
  /// **'Opérations prévues'**
  String get scheduledTitle;

  /// No description provided for @scheduledEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune opération prévue. Ajoutez votre loyer, votre salaire, vos abonnements…'**
  String get scheduledEmpty;

  /// No description provided for @scheduledAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une opération prévue'**
  String get scheduledAdd;

  /// No description provided for @scheduledEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'opération prévue'**
  String get scheduledEdit;

  /// No description provided for @scheduledDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get scheduledDelete;

  /// No description provided for @scheduledDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer « {label} » ? Les prévisions ne la compteront plus.'**
  String scheduledDeleteConfirm(String label);

  /// No description provided for @frequencyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence'**
  String get frequencyLabel;

  /// No description provided for @frequencyOnce.
  ///
  /// In fr, this message translates to:
  /// **'Une fois'**
  String get frequencyOnce;

  /// No description provided for @frequencyWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les semaines'**
  String get frequencyWeekly;

  /// No description provided for @frequencyMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Tous les mois'**
  String get frequencyMonthly;

  /// No description provided for @frequencyYearly.
  ///
  /// In fr, this message translates to:
  /// **'Tous les ans'**
  String get frequencyYearly;

  /// No description provided for @everyWeeks.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Chaque semaine} other{Toutes les {count} semaines}}'**
  String everyWeeks(int count);

  /// No description provided for @everyMonths.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Chaque mois} other{Tous les {count} mois}}'**
  String everyMonths(int count);

  /// No description provided for @everyYears.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Chaque année} other{Tous les {count} ans}}'**
  String everyYears(int count);

  /// No description provided for @intervalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Intervalle'**
  String get intervalLabel;

  /// No description provided for @intervalHelp.
  ///
  /// In fr, this message translates to:
  /// **'2 = toutes les deux semaines, deux mois…'**
  String get intervalHelp;

  /// No description provided for @startDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Première échéance'**
  String get startDateLabel;

  /// No description provided for @endDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dernière échéance (facultatif)'**
  String get endDateLabel;

  /// No description provided for @noEndDate.
  ///
  /// In fr, this message translates to:
  /// **'Sans fin'**
  String get noEndDate;

  /// No description provided for @onceOn.
  ///
  /// In fr, this message translates to:
  /// **'Le {date}'**
  String onceOn(String date);

  /// No description provided for @fromDate.
  ///
  /// In fr, this message translates to:
  /// **'à partir du {date}'**
  String fromDate(String date);

  /// No description provided for @untilDate.
  ///
  /// In fr, this message translates to:
  /// **'jusqu\'au {date}'**
  String untilDate(String date);

  /// No description provided for @matchPatternLabel.
  ///
  /// In fr, this message translates to:
  /// **'Libellé bancaire à reconnaître (facultatif)'**
  String get matchPatternLabel;

  /// No description provided for @matchPatternHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ex. : LOYER. Sert à relier l\'opération réelle à l\'échéance prévue.'**
  String get matchPatternHelp;

  /// No description provided for @dateToleranceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Tolérance de date (jours)'**
  String get dateToleranceLabel;

  /// No description provided for @amountToleranceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Tolérance de montant (%)'**
  String get amountToleranceLabel;

  /// No description provided for @toleranceInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Nombre entier attendu.'**
  String get toleranceInvalid;

  /// No description provided for @scheduledLockedHelp.
  ///
  /// In fr, this message translates to:
  /// **'La fréquence et la première échéance ne se modifient pas : supprimez et recréez l\'opération prévue.'**
  String get scheduledLockedHelp;

  /// No description provided for @categoriesTab.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categoriesTab;

  /// No description provided for @rulesTab.
  ///
  /// In fr, this message translates to:
  /// **'Règles'**
  String get rulesTab;

  /// No description provided for @categoryAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une catégorie'**
  String get categoryAdd;

  /// No description provided for @categoryEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la catégorie'**
  String get categoryEdit;

  /// No description provided for @categoryName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get categoryName;

  /// No description provided for @categoryParent.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie parente'**
  String get categoryParent;

  /// No description provided for @categoryNoParent.
  ///
  /// In fr, this message translates to:
  /// **'Aucune (catégorie principale)'**
  String get categoryNoParent;

  /// No description provided for @categoryKindLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get categoryKindLabel;

  /// No description provided for @kindIncome.
  ///
  /// In fr, this message translates to:
  /// **'Revenu'**
  String get kindIncome;

  /// No description provided for @kindExpense.
  ///
  /// In fr, this message translates to:
  /// **'Dépense'**
  String get kindExpense;

  /// No description provided for @kindTransfer.
  ///
  /// In fr, this message translates to:
  /// **'Virement interne'**
  String get kindTransfer;

  /// No description provided for @categoryStandardName.
  ///
  /// In fr, this message translates to:
  /// **'Nom standard : {name}'**
  String categoryStandardName(String name);

  /// No description provided for @categoryResetName.
  ///
  /// In fr, this message translates to:
  /// **'Revenir au nom standard'**
  String get categoryResetName;

  /// No description provided for @categoryStandardHelp.
  ///
  /// In fr, this message translates to:
  /// **'Reliée au catalogue standard : les règles communautaires continuent de la remplir, même renommée.'**
  String get categoryStandardHelp;

  /// No description provided for @categoryArchive.
  ///
  /// In fr, this message translates to:
  /// **'Archiver'**
  String get categoryArchive;

  /// No description provided for @categoryArchiveConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Archiver « {name} » ? Elle ne sera plus proposée ; les opérations déjà classées la gardent.'**
  String categoryArchiveConfirm(String name);

  /// No description provided for @ruleAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une règle'**
  String get ruleAdd;

  /// No description provided for @ruleEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la règle'**
  String get ruleEdit;

  /// No description provided for @rulesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune règle du groupe. Créez-en une ici ou avec « Toujours classer ainsi » sur une opération.'**
  String get rulesEmpty;

  /// No description provided for @rulePattern.
  ///
  /// In fr, this message translates to:
  /// **'Texte recherché dans le libellé'**
  String get rulePattern;

  /// No description provided for @ruleMatchType.
  ///
  /// In fr, this message translates to:
  /// **'Correspondance'**
  String get ruleMatchType;

  /// No description provided for @matchContains.
  ///
  /// In fr, this message translates to:
  /// **'contient'**
  String get matchContains;

  /// No description provided for @matchStartsWith.
  ///
  /// In fr, this message translates to:
  /// **'commence par'**
  String get matchStartsWith;

  /// No description provided for @matchEquals.
  ///
  /// In fr, this message translates to:
  /// **'est exactement'**
  String get matchEquals;

  /// No description provided for @ruleDirection.
  ///
  /// In fr, this message translates to:
  /// **'Sens'**
  String get ruleDirection;

  /// No description provided for @directionAny.
  ///
  /// In fr, this message translates to:
  /// **'Débit ou crédit'**
  String get directionAny;

  /// No description provided for @directionDebit.
  ///
  /// In fr, this message translates to:
  /// **'Débit seulement'**
  String get directionDebit;

  /// No description provided for @directionCredit.
  ///
  /// In fr, this message translates to:
  /// **'Crédit seulement'**
  String get directionCredit;

  /// No description provided for @ruleMinAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant minimum (facultatif)'**
  String get ruleMinAmount;

  /// No description provided for @ruleMaxAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant maximum (facultatif)'**
  String get ruleMaxAmount;

  /// No description provided for @rulePriority.
  ///
  /// In fr, this message translates to:
  /// **'Priorité'**
  String get rulePriority;

  /// No description provided for @rulePriorityHelp.
  ///
  /// In fr, this message translates to:
  /// **'La plus petite passe en premier.'**
  String get rulePriorityHelp;

  /// No description provided for @ruleEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Active'**
  String get ruleEnabled;

  /// No description provided for @ruleDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get ruleDelete;

  /// No description provided for @ruleSummary.
  ///
  /// In fr, this message translates to:
  /// **'Libellé {match} « {pattern} » → {category}'**
  String ruleSummary(String match, String pattern, String category);

  /// No description provided for @ruleAmounts.
  ///
  /// In fr, this message translates to:
  /// **'entre {min} et {max}'**
  String ruleAmounts(String min, String max);

  /// No description provided for @ruleAmountFrom.
  ///
  /// In fr, this message translates to:
  /// **'à partir de {min}'**
  String ruleAmountFrom(String min);

  /// No description provided for @ruleAmountUpTo.
  ///
  /// In fr, this message translates to:
  /// **'jusqu\'à {max}'**
  String ruleAmountUpTo(String max);

  /// No description provided for @testerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tester un libellé'**
  String get testerTitle;

  /// No description provided for @testerHelp.
  ///
  /// In fr, this message translates to:
  /// **'Collez un libellé de votre relevé : OwnCoffer montre comment il le nettoie et le classe, sans rien enregistrer.'**
  String get testerHelp;

  /// No description provided for @testerRun.
  ///
  /// In fr, this message translates to:
  /// **'Tester'**
  String get testerRun;

  /// No description provided for @testerCleaned.
  ///
  /// In fr, this message translates to:
  /// **'Libellé court : {label}'**
  String testerCleaned(String label);

  /// No description provided for @testerResult.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie : {category} ({source})'**
  String testerResult(String category, String source);

  /// No description provided for @testerNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune règle ne s\'applique : l\'opération serait « À classer ».'**
  String get testerNone;

  /// No description provided for @testerRuleOpen.
  ///
  /// In fr, this message translates to:
  /// **'Voir la règle'**
  String get testerRuleOpen;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsMarkAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu'**
  String get notificationsMarkAll;

  /// No description provided for @notificationsUnread.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Notifications} =1{Notifications : 1 non lue} other{Notifications : {count} non lues}}'**
  String notificationsUnread(int count);

  /// No description provided for @notifOverdraftTitle.
  ///
  /// In fr, this message translates to:
  /// **'{account} : découvert prévu le {date}'**
  String notifOverdraftTitle(String account, String date);

  /// No description provided for @notifOverdraftBody.
  ///
  /// In fr, this message translates to:
  /// **'Solde prévu ce jour-là au moment de l\'alerte : {balance} (seuil {threshold}).'**
  String notifOverdraftBody(String balance, String threshold);

  /// No description provided for @notifUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Notification'**
  String get notifUnknown;

  /// No description provided for @notifOpenForecast.
  ///
  /// In fr, this message translates to:
  /// **'Voir les prévisions'**
  String get notifOpenForecast;

  /// No description provided for @importAccountRecognised.
  ///
  /// In fr, this message translates to:
  /// **'Compte reconnu d\'après le fichier.'**
  String get importAccountRecognised;

  /// No description provided for @importOtherAccountMatch.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier correspond au compte « {account} ».'**
  String importOtherAccountMatch(String account);

  /// No description provided for @importSwitchAccount.
  ///
  /// In fr, this message translates to:
  /// **'Importer dans « {account} »'**
  String importSwitchAccount(String account);

  /// No description provided for @importWrongBankAccount.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier vient d\'un autre compte bancaire que « {account} ». Vérifiez le compte choisi.'**
  String importWrongBankAccount(String account);

  /// No description provided for @groupCreateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer votre foyer'**
  String get groupCreateTitle;

  /// No description provided for @navBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget'**
  String get navBudget;

  /// No description provided for @navLoans.
  ///
  /// In fr, this message translates to:
  /// **'Crédits'**
  String get navLoans;

  /// No description provided for @navMore.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get navMore;

  /// No description provided for @allAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Tous les comptes'**
  String get allAccounts;

  /// No description provided for @moreActions.
  ///
  /// In fr, this message translates to:
  /// **'Plus d\'actions'**
  String get moreActions;

  /// No description provided for @optional.
  ///
  /// In fr, this message translates to:
  /// **'Facultatif'**
  String get optional;

  /// No description provided for @fieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Champ obligatoire.'**
  String get fieldRequired;

  /// No description provided for @filterCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get filterCategory;

  /// No description provided for @periodWeek.
  ///
  /// In fr, this message translates to:
  /// **'Semaine'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get periodMonth;

  /// No description provided for @periodYear.
  ///
  /// In fr, this message translates to:
  /// **'Année'**
  String get periodYear;

  /// No description provided for @periodPrevious.
  ///
  /// In fr, this message translates to:
  /// **'Période précédente'**
  String get periodPrevious;

  /// No description provided for @periodNext.
  ///
  /// In fr, this message translates to:
  /// **'Période suivante'**
  String get periodNext;

  /// No description provided for @budgetIncome.
  ///
  /// In fr, this message translates to:
  /// **'Revenus'**
  String get budgetIncome;

  /// No description provided for @budgetExpenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses'**
  String get budgetExpenses;

  /// No description provided for @budgetSavings.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get budgetSavings;

  /// No description provided for @budgetNet.
  ///
  /// In fr, this message translates to:
  /// **'Reste'**
  String get budgetNet;

  /// No description provided for @budgetDeltaPrevious.
  ///
  /// In fr, this message translates to:
  /// **'{percent} % par rapport à la période précédente'**
  String budgetDeltaPrevious(String percent);

  /// No description provided for @budgetHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Revenus et dépenses'**
  String get budgetHistoryTitle;

  /// No description provided for @budgetHistorySemantic.
  ///
  /// In fr, this message translates to:
  /// **'Revenus et dépenses des dernières périodes'**
  String get budgetHistorySemantic;

  /// No description provided for @rankingExpenses.
  ///
  /// In fr, this message translates to:
  /// **'Classement des dépenses'**
  String get rankingExpenses;

  /// No description provided for @rankingIncome.
  ///
  /// In fr, this message translates to:
  /// **'Classement des revenus'**
  String get rankingIncome;

  /// No description provided for @rankingEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien sur cette période.'**
  String get rankingEmpty;

  /// No description provided for @rankingShare.
  ///
  /// In fr, this message translates to:
  /// **'{percent} % du total'**
  String rankingShare(int percent);

  /// No description provided for @rankingPrevious.
  ///
  /// In fr, this message translates to:
  /// **'avant : {amount}'**
  String rankingPrevious(String amount);

  /// No description provided for @rankingAverage.
  ///
  /// In fr, this message translates to:
  /// **'moyenne : {amount}'**
  String rankingAverage(String amount);

  /// No description provided for @rankingOperations.
  ///
  /// In fr, this message translates to:
  /// **'Voir les opérations'**
  String get rankingOperations;

  /// No description provided for @goalAdd.
  ///
  /// In fr, this message translates to:
  /// **'Objectif'**
  String get goalAdd;

  /// No description provided for @goalSet.
  ///
  /// In fr, this message translates to:
  /// **'Fixer un objectif'**
  String get goalSet;

  /// No description provided for @goalEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'objectif'**
  String get goalEdit;

  /// No description provided for @goalRemove.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'objectif'**
  String get goalRemove;

  /// No description provided for @goalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectif : {category}'**
  String goalTitle(String category);

  /// No description provided for @goalHelp.
  ///
  /// In fr, this message translates to:
  /// **'Montant maximum à dépenser chaque mois dans cette catégorie, sous-catégories comprises.'**
  String get goalHelp;

  /// No description provided for @goalAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant par mois'**
  String get goalAmountLabel;

  /// No description provided for @goalSuggestion.
  ///
  /// In fr, this message translates to:
  /// **'Suggestion : {amount} (moyenne des 3 mois précédents : {average})'**
  String goalSuggestion(String amount, String average);

  /// No description provided for @goalOk.
  ///
  /// In fr, this message translates to:
  /// **'Dans l\'objectif'**
  String get goalOk;

  /// No description provided for @goalWarning.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt atteint'**
  String get goalWarning;

  /// No description provided for @goalOver.
  ///
  /// In fr, this message translates to:
  /// **'Dépassé'**
  String get goalOver;

  /// No description provided for @goalProgress.
  ///
  /// In fr, this message translates to:
  /// **'{percent} % de {goal}'**
  String goalProgress(int percent, String goal);

  /// No description provided for @goalLeft.
  ///
  /// In fr, this message translates to:
  /// **'reste {amount}'**
  String goalLeft(String amount);

  /// No description provided for @goalExceeded.
  ///
  /// In fr, this message translates to:
  /// **'{amount} de trop'**
  String goalExceeded(String amount);

  /// No description provided for @goalProjection.
  ///
  /// In fr, this message translates to:
  /// **'À ce rythme : {amount} en fin de mois'**
  String goalProjection(String amount);

  /// No description provided for @goalProjectionOver.
  ///
  /// In fr, this message translates to:
  /// **'À ce rythme : {amount} de trop, dépassement vers le {date}'**
  String goalProjectionOver(String amount, String date);

  /// No description provided for @monthStartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Début du mois'**
  String get monthStartTitle;

  /// No description provided for @monthStartHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le jour où commence votre mois de budget, par exemple le jour de la paie. Le budget, le classement des dépenses et les objectifs l\'utilisent pour tout le foyer.'**
  String get monthStartHelp;

  /// No description provided for @monthStartLabel.
  ///
  /// In fr, this message translates to:
  /// **'Le mois commence'**
  String get monthStartLabel;

  /// No description provided for @monthStartFirst.
  ///
  /// In fr, this message translates to:
  /// **'Le 1er (mois du calendrier)'**
  String get monthStartFirst;

  /// No description provided for @monthStartDay.
  ///
  /// In fr, this message translates to:
  /// **'Le {day}'**
  String monthStartDay(int day);

  /// No description provided for @subscriptionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get subscriptionsTitle;

  /// No description provided for @subscriptionsMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Par mois'**
  String get subscriptionsMonthly;

  /// No description provided for @subscriptionsYearly.
  ///
  /// In fr, this message translates to:
  /// **'Par an'**
  String get subscriptionsYearly;

  /// No description provided for @subscriptionsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les opérations prévues marquées comme abonnements, sur les comptes que vous voyez. Les montants annuels et hebdomadaires sont ramenés au mois.'**
  String get subscriptionsHelp;

  /// No description provided for @subscriptionsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun abonnement. Dans la fiche d\'une opération, « C\'est un abonnement » l\'ajoute ici.'**
  String get subscriptionsEmpty;

  /// No description provided for @subscriptionNext.
  ///
  /// In fr, this message translates to:
  /// **'prochain : {date}'**
  String subscriptionNext(String date);

  /// No description provided for @subscriptionPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{amount} / mois'**
  String subscriptionPerMonth(String amount);

  /// No description provided for @subscriptionUnmark.
  ///
  /// In fr, this message translates to:
  /// **'Ne plus compter comme abonnement'**
  String get subscriptionUnmark;

  /// No description provided for @subscriptionUnmarkHelp.
  ///
  /// In fr, this message translates to:
  /// **'Reste une opération prévue dans les prévisions.'**
  String get subscriptionUnmarkHelp;

  /// No description provided for @subscriptionStop.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement résilié'**
  String get subscriptionStop;

  /// No description provided for @subscriptionStopHelp.
  ///
  /// In fr, this message translates to:
  /// **'Supprime l\'opération prévue : elle ne compte plus dans les prévisions.'**
  String get subscriptionStopHelp;

  /// No description provided for @subscriptionSwitch.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get subscriptionSwitch;

  /// No description provided for @subscriptionSwitchHelp.
  ///
  /// In fr, this message translates to:
  /// **'Apparaît dans la liste des abonnements.'**
  String get subscriptionSwitchHelp;

  /// No description provided for @subscriptionFromOperation.
  ///
  /// In fr, this message translates to:
  /// **'C\'est un abonnement'**
  String get subscriptionFromOperation;

  /// No description provided for @subscriptionMarkPlanned.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme abonnement'**
  String get subscriptionMarkPlanned;

  /// No description provided for @filterSubscriptions.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get filterSubscriptions;

  /// No description provided for @subscriptionsOpen.
  ///
  /// In fr, this message translates to:
  /// **'Liste des abonnements'**
  String get subscriptionsOpen;

  /// No description provided for @subscriptionBadge.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get subscriptionBadge;

  /// No description provided for @subscriptionOfOperation.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement « {label} »'**
  String subscriptionOfOperation(String label);

  /// No description provided for @subscriptionCreated.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement « {label} » ajouté, prochain prélèvement le {date}.'**
  String subscriptionCreated(String label, String date);

  /// No description provided for @loansRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Reste à rembourser'**
  String get loansRemaining;

  /// No description provided for @loansMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensualités'**
  String get loansMonthly;

  /// No description provided for @loansDebtRatio.
  ///
  /// In fr, this message translates to:
  /// **'Taux d\'endettement'**
  String get loansDebtRatio;

  /// No description provided for @loansDebtRatioUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Pas de revenus classés sur les 3 derniers mois.'**
  String get loansDebtRatioUnknown;

  /// No description provided for @loansDebtRatioOk.
  ///
  /// In fr, this message translates to:
  /// **'Sous les 35 % conseillés'**
  String get loansDebtRatioOk;

  /// No description provided for @loansDebtRatioHigh.
  ///
  /// In fr, this message translates to:
  /// **'Au-dessus des 35 % conseillés'**
  String get loansDebtRatioHigh;

  /// No description provided for @loansDebtRatioBasis.
  ///
  /// In fr, this message translates to:
  /// **'revenus moyens : {amount} / mois'**
  String loansDebtRatioBasis(String amount);

  /// No description provided for @loansEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun crédit. Ajoutez-en un pour suivre ce qu\'il reste à rembourser.'**
  String get loansEmpty;

  /// No description provided for @loansDisclaimer.
  ///
  /// In fr, this message translates to:
  /// **'Calculs indicatifs à taux fixe et mensualités constantes : en cas d\'écart, le tableau d\'amortissement de la banque fait foi.'**
  String get loansDisclaimer;

  /// No description provided for @loanAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un crédit'**
  String get loanAdd;

  /// No description provided for @loanEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le crédit'**
  String get loanEdit;

  /// No description provided for @loanDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le crédit'**
  String get loanDelete;

  /// No description provided for @loanDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce crédit ? Ses échéances prévues sont retirées des prévisions.'**
  String get loanDeleteConfirm;

  /// No description provided for @loanKind.
  ///
  /// In fr, this message translates to:
  /// **'Type de crédit'**
  String get loanKind;

  /// No description provided for @loanKindMortgage.
  ///
  /// In fr, this message translates to:
  /// **'Immobilier'**
  String get loanKindMortgage;

  /// No description provided for @loanKindCar.
  ///
  /// In fr, this message translates to:
  /// **'Auto'**
  String get loanKindCar;

  /// No description provided for @loanKindConsumer.
  ///
  /// In fr, this message translates to:
  /// **'Consommation'**
  String get loanKindConsumer;

  /// No description provided for @loanKindStudent.
  ///
  /// In fr, this message translates to:
  /// **'Étudiant'**
  String get loanKindStudent;

  /// No description provided for @loanKindPersonal.
  ///
  /// In fr, this message translates to:
  /// **'Prêt entre particuliers'**
  String get loanKindPersonal;

  /// No description provided for @loanKindOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get loanKindOther;

  /// No description provided for @loanLender.
  ///
  /// In fr, this message translates to:
  /// **'Organisme'**
  String get loanLender;

  /// No description provided for @loanLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get loanLabel;

  /// No description provided for @loanLabelHint.
  ///
  /// In fr, this message translates to:
  /// **'Maison, voiture…'**
  String get loanLabelHint;

  /// No description provided for @loanPrincipal.
  ///
  /// In fr, this message translates to:
  /// **'Capital emprunté'**
  String get loanPrincipal;

  /// No description provided for @loanRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux nominal'**
  String get loanRate;

  /// No description provided for @loanRateHelp.
  ///
  /// In fr, this message translates to:
  /// **'Par an, par exemple 3,45'**
  String get loanRateHelp;

  /// No description provided for @loanRateInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Taux entre 0 et 50 %, trois décimales au plus.'**
  String get loanRateInvalid;

  /// No description provided for @loanApr.
  ///
  /// In fr, this message translates to:
  /// **'TAEG'**
  String get loanApr;

  /// No description provided for @loanDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get loanDuration;

  /// No description provided for @loanDurationMonths.
  ///
  /// In fr, this message translates to:
  /// **'Durée en mois'**
  String get loanDurationMonths;

  /// No description provided for @loanDurationHelp.
  ///
  /// In fr, this message translates to:
  /// **'240 mois = 20 ans'**
  String get loanDurationHelp;

  /// No description provided for @loanDurationInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Entre 1 et 600 mois.'**
  String get loanDurationInvalid;

  /// No description provided for @loanMonths.
  ///
  /// In fr, this message translates to:
  /// **'{count} mois'**
  String loanMonths(int count);

  /// No description provided for @loanFirstDue.
  ///
  /// In fr, this message translates to:
  /// **'Date de la première échéance'**
  String get loanFirstDue;

  /// No description provided for @loanInsurance.
  ///
  /// In fr, this message translates to:
  /// **'Assurance par mois'**
  String get loanInsurance;

  /// No description provided for @loanInsuranceMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Assurance par mois'**
  String get loanInsuranceMonthly;

  /// No description provided for @loanFees.
  ///
  /// In fr, this message translates to:
  /// **'Frais de dossier'**
  String get loanFees;

  /// No description provided for @loanAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte de prélèvement'**
  String get loanAccount;

  /// No description provided for @loanAccountHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les échéances deviennent des opérations prévues sur ce compte : elles comptent dans le solde prévu et sont rapprochées des prélèvements réels.'**
  String get loanAccountHelp;

  /// No description provided for @loanNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get loanNoAccount;

  /// No description provided for @loanPayment.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité (hors assurance)'**
  String get loanPayment;

  /// No description provided for @loanPreview.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité : {payment} hors assurance, {total} avec.'**
  String loanPreview(String payment, String total);

  /// No description provided for @loanPreviewEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le capital, le taux et la durée pour voir la mensualité.'**
  String get loanPreviewEmpty;

  /// No description provided for @loanRemainingShort.
  ///
  /// In fr, this message translates to:
  /// **'restant dû'**
  String get loanRemainingShort;

  /// No description provided for @loanRepaid.
  ///
  /// In fr, this message translates to:
  /// **'{percent} % remboursé'**
  String loanRepaid(int percent);

  /// No description provided for @loanInstallments.
  ///
  /// In fr, this message translates to:
  /// **'{paid} / {total} échéances'**
  String loanInstallments(int paid, int total);

  /// No description provided for @loanNext.
  ///
  /// In fr, this message translates to:
  /// **'prochaine le {date} : {amount}'**
  String loanNext(String date, String amount);

  /// No description provided for @loanFinished.
  ///
  /// In fr, this message translates to:
  /// **'remboursé'**
  String get loanFinished;

  /// No description provided for @loanEnd.
  ///
  /// In fr, this message translates to:
  /// **'fin le {date}'**
  String loanEnd(String date);

  /// No description provided for @loanInterestPaid.
  ///
  /// In fr, this message translates to:
  /// **'Intérêts déjà payés'**
  String get loanInterestPaid;

  /// No description provided for @loanInterestLeft.
  ///
  /// In fr, this message translates to:
  /// **'Intérêts restant à payer'**
  String get loanInterestLeft;

  /// No description provided for @loanCost.
  ///
  /// In fr, this message translates to:
  /// **'Coût total (intérêts, assurance, frais)'**
  String get loanCost;

  /// No description provided for @loanSimulationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement anticipé'**
  String get loanSimulationTitle;

  /// No description provided for @loanSimulationHelp.
  ///
  /// In fr, this message translates to:
  /// **'Si je rembourse ce montant maintenant, en gardant la même mensualité.'**
  String get loanSimulationHelp;

  /// No description provided for @loanSimulationAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get loanSimulationAmount;

  /// No description provided for @loanSimulate.
  ///
  /// In fr, this message translates to:
  /// **'Simuler'**
  String get loanSimulate;

  /// No description provided for @loanSimulationSaved.
  ///
  /// In fr, this message translates to:
  /// **'Intérêts économisés'**
  String get loanSimulationSaved;

  /// No description provided for @loanSimulationEnd.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle date de fin'**
  String get loanSimulationEnd;

  /// No description provided for @loanSimulationRepaid.
  ///
  /// In fr, this message translates to:
  /// **'Crédit soldé'**
  String get loanSimulationRepaid;

  /// No description provided for @loanSimulationLeft.
  ///
  /// In fr, this message translates to:
  /// **'Échéances restantes'**
  String get loanSimulationLeft;

  /// No description provided for @loanScheduleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tableau d\'amortissement'**
  String get loanScheduleTitle;

  /// No description provided for @loanYearSummary.
  ///
  /// In fr, this message translates to:
  /// **'Capital {principal} · intérêts {interest} · restant dû {remaining}'**
  String loanYearSummary(String principal, String interest, String remaining);

  /// No description provided for @loanColNumber.
  ///
  /// In fr, this message translates to:
  /// **'N°'**
  String get loanColNumber;

  /// No description provided for @loanColDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get loanColDate;

  /// No description provided for @loanColPayment.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité'**
  String get loanColPayment;

  /// No description provided for @loanColPrincipal.
  ///
  /// In fr, this message translates to:
  /// **'Capital'**
  String get loanColPrincipal;

  /// No description provided for @loanColInterest.
  ///
  /// In fr, this message translates to:
  /// **'Intérêts'**
  String get loanColInterest;

  /// No description provided for @loanColInsurance.
  ///
  /// In fr, this message translates to:
  /// **'Assurance'**
  String get loanColInsurance;

  /// No description provided for @loanColRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Restant dû'**
  String get loanColRemaining;

  /// No description provided for @error_goal_expense_only.
  ///
  /// In fr, this message translates to:
  /// **'Un objectif se fixe sur une catégorie de dépenses.'**
  String get error_goal_expense_only;

  /// No description provided for @error_loan_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Ce crédit n\'existe pas ou vous n\'y avez pas accès.'**
  String get error_loan_access_denied;

  /// No description provided for @error_loan_terms_invalid.
  ///
  /// In fr, this message translates to:
  /// **'Conditions du crédit impossibles : vérifiez le capital, le taux et la durée.'**
  String get error_loan_terms_invalid;

  /// No description provided for @error_invalid_month_start_day.
  ///
  /// In fr, this message translates to:
  /// **'Le mois doit commencer entre le 1er et le 28.'**
  String get error_invalid_month_start_day;

  /// No description provided for @loanFromOperation.
  ///
  /// In fr, this message translates to:
  /// **'C\'est une échéance de crédit'**
  String get loanFromOperation;

  /// No description provided for @loanFromOperationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Déclarer le crédit'**
  String get loanFromOperationTitle;

  /// No description provided for @loanFromOperationIntro.
  ///
  /// In fr, this message translates to:
  /// **'Les prochains prélèvements « {label} » seront reconnus comme les échéances de ce crédit et classés automatiquement.'**
  String loanFromOperationIntro(String label);

  /// No description provided for @loanObservedInstalment.
  ///
  /// In fr, this message translates to:
  /// **'Prélèvement constaté : {amount} (assurance comprise)'**
  String loanObservedInstalment(String amount);

  /// No description provided for @loanDeducePrincipal.
  ///
  /// In fr, this message translates to:
  /// **'Calculer le capital à partir de ce prélèvement'**
  String get loanDeducePrincipal;

  /// No description provided for @loanDeduceNeedsTerms.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez d\'abord le taux et la durée.'**
  String get loanDeduceNeedsTerms;

  /// No description provided for @loanInstalmentMismatch.
  ///
  /// In fr, this message translates to:
  /// **'La mensualité calculée ({amount}) s\'écarte de plus de 5 % du prélèvement : vérifiez le capital, le taux, la durée et l\'assurance.'**
  String loanInstalmentMismatch(String amount);

  /// No description provided for @loanFirstDueFromOperationHelp.
  ///
  /// In fr, this message translates to:
  /// **'Date de la toute première échéance. Si vous ne la connaissez pas, gardez celle de ce prélèvement et indiquez la durée restante : le capital calculé sera alors le capital restant dû.'**
  String get loanFirstDueFromOperationHelp;

  /// No description provided for @loanCategoryDefaultHelp.
  ///
  /// In fr, this message translates to:
  /// **'Sans choix, la catégorie du type de crédit est utilisée (par exemple Crédit immobilier).'**
  String get loanCategoryDefaultHelp;

  /// No description provided for @loanFromOperationDone.
  ///
  /// In fr, this message translates to:
  /// **'Crédit créé : {linked} échéances rattachées, {others} autres opérations classées.'**
  String loanFromOperationDone(int linked, int others);

  /// No description provided for @error_loan_needs_debit.
  ///
  /// In fr, this message translates to:
  /// **'Un crédit se déclare depuis un prélèvement.'**
  String get error_loan_needs_debit;

  /// No description provided for @sameProvider.
  ///
  /// In fr, this message translates to:
  /// **'Autres paiements de ce prestataire'**
  String get sameProvider;

  /// No description provided for @sameProviderFilter.
  ///
  /// In fr, this message translates to:
  /// **'Prestataire : {label}'**
  String sameProviderFilter(String label);

  /// No description provided for @sameProviderSummary.
  ///
  /// In fr, this message translates to:
  /// **'{count} opérations · total {total} · moyenne {average}'**
  String sameProviderSummary(int count, String total, String average);

  /// No description provided for @undoDone.
  ///
  /// In fr, this message translates to:
  /// **'Action annulée.'**
  String get undoDone;

  /// No description provided for @categoryChanged.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie modifiée.'**
  String get categoryChanged;

  /// No description provided for @clearedChanged.
  ///
  /// In fr, this message translates to:
  /// **'Pointage modifié.'**
  String get clearedChanged;

  /// No description provided for @goalSaved.
  ///
  /// In fr, this message translates to:
  /// **'Objectif enregistré.'**
  String get goalSaved;

  /// No description provided for @goalRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Objectif supprimé.'**
  String get goalRemoved;

  /// No description provided for @splitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ventiler l\'opération'**
  String get splitTitle;

  /// No description provided for @splitAction.
  ///
  /// In fr, this message translates to:
  /// **'Ventiler entre plusieurs catégories'**
  String get splitAction;

  /// No description provided for @splitAddPart.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une part'**
  String get splitAddPart;

  /// No description provided for @splitRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Reste à répartir : {amount}'**
  String splitRemaining(String amount);

  /// No description provided for @splitBalanced.
  ///
  /// In fr, this message translates to:
  /// **'Le total correspond au montant de l\'opération.'**
  String get splitBalanced;

  /// No description provided for @splitRemove.
  ///
  /// In fr, this message translates to:
  /// **'Ne plus ventiler'**
  String get splitRemove;

  /// No description provided for @splitSaved.
  ///
  /// In fr, this message translates to:
  /// **'Opération ventilée.'**
  String get splitSaved;

  /// No description provided for @splitPartLabel.
  ///
  /// In fr, this message translates to:
  /// **'Part {number}'**
  String splitPartLabel(int number);

  /// No description provided for @splitPartsSummary.
  ///
  /// In fr, this message translates to:
  /// **'Ventilée en {count} parts'**
  String splitPartsSummary(int count);

  /// No description provided for @splitNoteLabel.
  ///
  /// In fr, this message translates to:
  /// **'Précision'**
  String get splitNoteLabel;

  /// No description provided for @splitRemovePart.
  ///
  /// In fr, this message translates to:
  /// **'Retirer cette part'**
  String get splitRemovePart;

  /// No description provided for @leftToLiveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reste à vivre'**
  String get leftToLiveTitle;

  /// No description provided for @leftToLiveBody.
  ///
  /// In fr, this message translates to:
  /// **'soit {perDay} par jour pendant {days} jours, jusqu\'au {date}'**
  String leftToLiveBody(String perDay, int days, String date);

  /// No description provided for @leftToLiveDetail.
  ///
  /// In fr, this message translates to:
  /// **'Solde {balance} · prélèvements prévus {debits} · rentrées prévues {credits}'**
  String leftToLiveDetail(String balance, String debits, String credits);

  /// No description provided for @leftToLiveHelp.
  ///
  /// In fr, this message translates to:
  /// **'Comptes courants seulement, opérations prévues comprises, jusqu\'à la fin du mois de budget (veille de la prochaine paie).'**
  String get leftToLiveHelp;

  /// No description provided for @calendarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier des échéances'**
  String get calendarTitle;

  /// No description provided for @calendarEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune échéance prévue sur cette période.'**
  String get calendarEmpty;

  /// No description provided for @calendarUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'Encore à venir : {debits} de prélèvements, {credits} de rentrées'**
  String calendarUpcoming(String debits, String credits);

  /// No description provided for @statusPaid.
  ///
  /// In fr, this message translates to:
  /// **'Passé'**
  String get statusPaid;

  /// No description provided for @statusLate.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get statusLate;

  /// No description provided for @statusSkipped.
  ///
  /// In fr, this message translates to:
  /// **'Sauté'**
  String get statusSkipped;

  /// No description provided for @statusUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get statusUpcoming;

  /// No description provided for @statusPaidOther.
  ///
  /// In fr, this message translates to:
  /// **'Passé : {amount}'**
  String statusPaidOther(String amount);

  /// No description provided for @calendarLoan.
  ///
  /// In fr, this message translates to:
  /// **'Crédit'**
  String get calendarLoan;

  /// No description provided for @calendarSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get calendarSubscription;

  /// No description provided for @reviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Revue du mois'**
  String get reviewTitle;

  /// No description provided for @reviewNet.
  ///
  /// In fr, this message translates to:
  /// **'Reste du mois : {net} (mois précédent : {previous})'**
  String reviewNet(String net, String previous);

  /// No description provided for @reviewRises.
  ///
  /// In fr, this message translates to:
  /// **'En hausse'**
  String get reviewRises;

  /// No description provided for @reviewDrops.
  ///
  /// In fr, this message translates to:
  /// **'En baisse'**
  String get reviewDrops;

  /// No description provided for @reviewChange.
  ///
  /// In fr, this message translates to:
  /// **'{amount} au lieu de {average} en moyenne'**
  String reviewChange(String amount, String average);

  /// No description provided for @reviewGoalsOver.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs dépassés'**
  String get reviewGoalsOver;

  /// No description provided for @reviewGoalOver.
  ///
  /// In fr, this message translates to:
  /// **'{amount} pour un objectif de {goal}'**
  String reviewGoalOver(String amount, String goal);

  /// No description provided for @reviewFees.
  ///
  /// In fr, this message translates to:
  /// **'Frais bancaires'**
  String get reviewFees;

  /// No description provided for @reviewFeesTotal.
  ///
  /// In fr, this message translates to:
  /// **'{amount} de frais bancaires ce mois-ci'**
  String reviewFeesTotal(String amount);

  /// No description provided for @reviewNoFees.
  ///
  /// In fr, this message translates to:
  /// **'Aucun frais bancaire ce mois-ci.'**
  String get reviewNoFees;

  /// No description provided for @reviewBiggest.
  ///
  /// In fr, this message translates to:
  /// **'Plus grosses dépenses'**
  String get reviewBiggest;

  /// No description provided for @reviewSubscriptions.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get reviewSubscriptions;

  /// No description provided for @reviewSubscriptionChange.
  ///
  /// In fr, this message translates to:
  /// **'{label} : {actual} au lieu de {planned}'**
  String reviewSubscriptionChange(String label, String actual, String planned);

  /// No description provided for @reviewNewSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel abonnement : {label} ({amount})'**
  String reviewNewSubscription(String label, String amount);

  /// No description provided for @reviewUnclassified.
  ///
  /// In fr, this message translates to:
  /// **'{count} opérations restent à classer sur ce mois.'**
  String reviewUnclassified(int count);

  /// No description provided for @reviewNothing.
  ///
  /// In fr, this message translates to:
  /// **'Rien de notable.'**
  String get reviewNothing;

  /// No description provided for @balanceCheckAction.
  ///
  /// In fr, this message translates to:
  /// **'Contrôler le solde'**
  String get balanceCheckAction;

  /// No description provided for @balanceCheckHelp.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le solde affiché par votre banque en fin de journée à une date : OwnCoffer le compare avec le solde calculé à partir des opérations.'**
  String get balanceCheckHelp;

  /// No description provided for @balanceCheckDate.
  ///
  /// In fr, this message translates to:
  /// **'Date du solde'**
  String get balanceCheckDate;

  /// No description provided for @balanceCheckAmount.
  ///
  /// In fr, this message translates to:
  /// **'Solde affiché par la banque'**
  String get balanceCheckAmount;

  /// No description provided for @balanceCheckOk.
  ///
  /// In fr, this message translates to:
  /// **'Le solde correspond.'**
  String get balanceCheckOk;

  /// No description provided for @balanceCheckGap.
  ///
  /// In fr, this message translates to:
  /// **'Écart de {amount} : le solde calculé est de {computed}.'**
  String balanceCheckGap(String amount, String computed);

  /// No description provided for @balanceCheckUncleared.
  ///
  /// In fr, this message translates to:
  /// **'Dont {amount} d\'opérations saisies à la main et non pointées, peut-être pas encore passées à la banque.'**
  String balanceCheckUncleared(String amount);

  /// No description provided for @balanceCheckLastImport.
  ///
  /// In fr, this message translates to:
  /// **'Dernière opération importée : {date}. Un relevé manque peut-être.'**
  String balanceCheckLastImport(String date);

  /// No description provided for @balanceCheckHistory.
  ///
  /// In fr, this message translates to:
  /// **'Derniers contrôles'**
  String get balanceCheckHistory;

  /// No description provided for @balanceCheckRow.
  ///
  /// In fr, this message translates to:
  /// **'{date} : banque {bank}, écart {gap}'**
  String balanceCheckRow(String date, String bank, String gap);

  /// No description provided for @notifGoalWarningTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectif « {category} » bientôt atteint'**
  String notifGoalWarningTitle(String category);

  /// No description provided for @notifGoalOverTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectif « {category} » dépassé'**
  String notifGoalOverTitle(String category);

  /// No description provided for @notifGoalBody.
  ///
  /// In fr, this message translates to:
  /// **'{spent} dépensés pour un objectif de {goal} ce mois-ci.'**
  String notifGoalBody(String spent, String goal);

  /// No description provided for @notifGoalForecastTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectif « {category} » : dépassement prévu vers le {date}'**
  String notifGoalForecastTitle(String category, String date);

  /// No description provided for @notifGoalForecastBody.
  ///
  /// In fr, this message translates to:
  /// **'{spent} dépensés pour un objectif de {goal} ; à ce rythme, {projected} en fin de mois.'**
  String notifGoalForecastBody(String spent, String goal, String projected);

  /// No description provided for @loanKindInstallments.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en plusieurs fois'**
  String get loanKindInstallments;

  /// No description provided for @loanInstallmentsCount.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d\'échéances'**
  String get loanInstallmentsCount;

  /// No description provided for @loanInstallmentsTotal.
  ///
  /// In fr, this message translates to:
  /// **'Montant total de l\'achat'**
  String get loanInstallmentsTotal;

  /// No description provided for @loanInstallmentsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en 3 ou 4 fois (Alma, Oney, carte bancaire…), généralement sans frais : le taux reste à 0 %.'**
  String get loanInstallmentsHelp;

  /// No description provided for @loanSectionInstallments.
  ///
  /// In fr, this message translates to:
  /// **'Paiements en plusieurs fois'**
  String get loanSectionInstallments;

  /// No description provided for @error_split_invalid.
  ///
  /// In fr, this message translates to:
  /// **'La ventilation doit compter au moins deux parts du même signe que l\'opération, dont le total est égal à son montant.'**
  String get error_split_invalid;

  /// No description provided for @goalsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs du mois'**
  String get goalsTitle;

  /// No description provided for @goalsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objectif. Fixez un plafond mensuel sur une catégorie de dépenses pour voir où vous en êtes au fil du mois.'**
  String get goalsEmpty;

  /// No description provided for @goalsSummary.
  ///
  /// In fr, this message translates to:
  /// **'{ok} dans l\'objectif · {warning} bientôt atteint · {over} dépassé'**
  String goalsSummary(int ok, int warning, int over);

  /// No description provided for @goalPaceHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le trait vertical marque où vous devriez en être aujourd\'hui pour tenir l\'objectif jusqu\'à la fin du mois.'**
  String get goalPaceHelp;

  /// No description provided for @goalSpentOf.
  ///
  /// In fr, this message translates to:
  /// **'{spent} sur {goal}'**
  String goalSpentOf(String spent, String goal);

  /// No description provided for @rankingShowAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir les {count} catégories'**
  String rankingShowAll(int count);

  /// No description provided for @rankingShowLess.
  ///
  /// In fr, this message translates to:
  /// **'Réduire'**
  String get rankingShowLess;

  /// No description provided for @rankingTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total : {amount}'**
  String rankingTotal(String amount);

  /// No description provided for @rankingVsAverage.
  ///
  /// In fr, this message translates to:
  /// **'{percent} % par rapport à la moyenne ({amount})'**
  String rankingVsAverage(String percent, String amount);

  /// No description provided for @budgetBalanceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bilan de la période'**
  String get budgetBalanceTitle;

  /// No description provided for @budgetOverspent.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez dépensé {amount} de plus que vos revenus'**
  String budgetOverspent(String amount);

  /// No description provided for @budgetLeftOver.
  ///
  /// In fr, this message translates to:
  /// **'Il vous reste {amount}'**
  String budgetLeftOver(String amount);

  /// No description provided for @budgetBarsSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Revenus {income}, dépenses et épargne {out}'**
  String budgetBarsSemantic(String income, String out);

  /// No description provided for @budgetExpensesAndSavings.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses et épargne'**
  String get budgetExpensesAndSavings;

  /// No description provided for @budgetSavingsPart.
  ///
  /// In fr, this message translates to:
  /// **'dont épargne'**
  String get budgetSavingsPart;

  /// No description provided for @budgetVsPrevious.
  ///
  /// In fr, this message translates to:
  /// **'{delta} par rapport à la période précédente'**
  String budgetVsPrevious(String delta);

  /// No description provided for @unclassifiedBanner.
  ///
  /// In fr, this message translates to:
  /// **'{count} opérations à classer ({amount})'**
  String unclassifiedBanner(int count, String amount);

  /// No description provided for @unclassifiedBannerHelp.
  ///
  /// In fr, this message translates to:
  /// **'Elles comptent dans les totaux mais pas dans les classements ni les objectifs.'**
  String get unclassifiedBannerHelp;

  /// No description provided for @classifyNow.
  ///
  /// In fr, this message translates to:
  /// **'Classer'**
  String get classifyNow;

  /// No description provided for @loanAttachTitle.
  ///
  /// In fr, this message translates to:
  /// **'Échéance de quel crédit ?'**
  String get loanAttachTitle;

  /// No description provided for @loanAttachHelp.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un crédit déjà saisi : ce prélèvement y sera rattaché et les suivants seront classés automatiquement.'**
  String get loanAttachHelp;

  /// No description provided for @loanAttachNew.
  ///
  /// In fr, this message translates to:
  /// **'Déclarer un nouveau crédit'**
  String get loanAttachNew;

  /// No description provided for @loanAttachDone.
  ///
  /// In fr, this message translates to:
  /// **'Prélèvement rattaché au crédit : {linked} échéances rattachées, {others} autres opérations classées.'**
  String loanAttachDone(int linked, int others);

  /// No description provided for @error_loan_other_account.
  ///
  /// In fr, this message translates to:
  /// **'Ce crédit est prélevé sur un autre compte.'**
  String get error_loan_other_account;

  /// No description provided for @loanOperationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Opérations du crédit'**
  String get loanOperationsTitle;

  /// No description provided for @loanOperationsSummary.
  ///
  /// In fr, this message translates to:
  /// **'{count} prélèvements · {total} payés'**
  String loanOperationsSummary(int count, String total);

  /// No description provided for @loanOperationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun prélèvement rattaché pour l\'instant. Depuis la fiche d\'un prélèvement, « C\'est une échéance de crédit » le rattache à ce crédit.'**
  String get loanOperationsEmpty;

  /// No description provided for @loanOperationsMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir les {count} prélèvements'**
  String loanOperationsMore(int count);

  /// No description provided for @loanActualPayment.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité prélevée (assurance comprise)'**
  String get loanActualPayment;

  /// No description provided for @loanActualPaymentHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le montant réellement prélevé chaque mois : c\'est la seule valeur certaine. Le capital restant, les intérêts et la date de fin en sont déduits.'**
  String get loanActualPaymentHelp;

  /// No description provided for @loanActualPreview.
  ///
  /// In fr, this message translates to:
  /// **'Avec {amount} prélevés par mois, le crédit serait remboursé en {months} mois.'**
  String loanActualPreview(String amount, int months);

  /// No description provided for @loanPaymentActual.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité (prélevée)'**
  String get loanPaymentActual;

  /// No description provided for @loanPaymentComputed.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité (calculée)'**
  String get loanPaymentComputed;

  /// No description provided for @loanEstimatedDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée estimée'**
  String get loanEstimatedDuration;

  /// No description provided for @loanEstimatesNote.
  ///
  /// In fr, this message translates to:
  /// **'La mensualité prélevée est la seule valeur certaine : le capital restant, les intérêts et la date de fin sont des estimations calculées à partir d\'elle. Le tableau d\'amortissement de votre banque fait foi.'**
  String get loanEstimatesNote;

  /// No description provided for @loanEstimatesNoteComputed.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité calculée à partir du capital, du taux et de la durée : indiquez la mensualité prélevée pour des estimations plus justes. Le tableau d\'amortissement de votre banque fait foi.'**
  String get loanEstimatesNoteComputed;

  /// No description provided for @loanDocumentsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Documents du crédit'**
  String get loanDocumentsTitle;

  /// No description provided for @loanDocumentsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Tableau d\'amortissement, offre de prêt, captures d\'écran… Ils restent sur votre serveur (PDF, image, CSV, tableur ; 10 Mo au plus).'**
  String get loanDocumentsHelp;

  /// No description provided for @loanDocumentsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun document.'**
  String get loanDocumentsEmpty;

  /// No description provided for @loanDocumentAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un document'**
  String get loanDocumentAdd;

  /// No description provided for @loanDocumentAdded.
  ///
  /// In fr, this message translates to:
  /// **'Document ajouté.'**
  String get loanDocumentAdded;

  /// No description provided for @loanDocumentDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le document'**
  String get loanDocumentDelete;

  /// No description provided for @loanDocumentDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer « {name} » du serveur ? Cette action est définitive.'**
  String loanDocumentDeleteConfirm(String name);

  /// No description provided for @loanDocumentInfo.
  ///
  /// In fr, this message translates to:
  /// **'{size} · ajouté le {date}'**
  String loanDocumentInfo(String size, String date);

  /// No description provided for @error_document_too_large.
  ///
  /// In fr, this message translates to:
  /// **'Le document est vide ou dépasse 10 Mo.'**
  String get error_document_too_large;

  /// No description provided for @error_document_type.
  ///
  /// In fr, this message translates to:
  /// **'Type de document non accepté : PDF, image (PNG, JPEG, WebP), CSV, texte ou tableur (XLSX, ODS).'**
  String get error_document_type;

  /// No description provided for @error_document_limit.
  ///
  /// In fr, this message translates to:
  /// **'Ce crédit a déjà 30 documents : supprimez-en avant d\'en ajouter.'**
  String get error_document_limit;

  /// No description provided for @sizeMb.
  ///
  /// In fr, this message translates to:
  /// **'{value} Mo'**
  String sizeMb(String value);

  /// No description provided for @sizeKb.
  ///
  /// In fr, this message translates to:
  /// **'{value} ko'**
  String sizeKb(String value);

  /// No description provided for @variableToggle.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses variables'**
  String get variableToggle;

  /// No description provided for @variableToggleHelp.
  ///
  /// In fr, this message translates to:
  /// **'Compter les courses, le carburant, les sorties… estimés d\'après les mois précédents'**
  String get variableToggleHelp;

  /// No description provided for @variableIncluded.
  ///
  /// In fr, this message translates to:
  /// **'Dont {amount} de dépenses variables estimées'**
  String variableIncluded(String amount);

  /// No description provided for @variableMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Habituellement {amount} par mois · voir le calcul'**
  String variableMonthly(String amount);

  /// No description provided for @variableHow.
  ///
  /// In fr, this message translates to:
  /// **'D\'après {months} : pour chaque catégorie, la médiane des mois (un mois exceptionnel ne compte pas). Les opérations prévues, les virements entre vos comptes et les revenus ne sont pas comptés.'**
  String variableHow(String months);

  /// No description provided for @variableThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois-ci : {spent} déjà dépensés, {left} encore attendus, répartis jour par jour.'**
  String variableThisMonth(String spent, String left);

  /// No description provided for @variableNoHistory.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses variables : pas encore assez d\'historique (il faut au moins un mois complet d\'opérations).'**
  String get variableNoHistory;

  /// No description provided for @variableNone.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses variables : aucune sur les derniers mois.'**
  String get variableNone;

  /// No description provided for @purchaseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Simuler un achat'**
  String get purchaseTitle;

  /// No description provided for @purchaseHelp.
  ///
  /// In fr, this message translates to:
  /// **'Sur le compte « {account} » : le solde à la date choisie, le point bas et le risque de découvert, selon la façon de payer. Rien n\'est enregistré tant que vous ne choisissez pas.'**
  String purchaseHelp(String account);

  /// No description provided for @purchaseAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant de l\'achat'**
  String get purchaseAmount;

  /// No description provided for @purchaseAmountInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Montant positif, par exemple 600 ou 599,90'**
  String get purchaseAmountInvalid;

  /// No description provided for @purchaseLabel.
  ///
  /// In fr, this message translates to:
  /// **'Libellé'**
  String get purchaseLabel;

  /// No description provided for @purchaseDefaultLabel.
  ///
  /// In fr, this message translates to:
  /// **'Achat'**
  String get purchaseDefaultLabel;

  /// No description provided for @purchaseDate.
  ///
  /// In fr, this message translates to:
  /// **'Achat le {date}'**
  String purchaseDate(String date);

  /// No description provided for @purchaseTarget.
  ///
  /// In fr, this message translates to:
  /// **'Solde au {date}'**
  String purchaseTarget(String date);

  /// No description provided for @purchaseCategoryHelp.
  ///
  /// In fr, this message translates to:
  /// **'Facultatif : prévient si l\'objectif du mois serait dépassé'**
  String get purchaseCategoryHelp;

  /// No description provided for @purchaseSimulate.
  ///
  /// In fr, this message translates to:
  /// **'Comparer'**
  String get purchaseSimulate;

  /// No description provided for @purchaseNone.
  ///
  /// In fr, this message translates to:
  /// **'Sans l\'achat'**
  String get purchaseNone;

  /// No description provided for @purchaseNoneHelp.
  ///
  /// In fr, this message translates to:
  /// **'Pour comparer'**
  String get purchaseNoneHelp;

  /// No description provided for @purchaseCash.
  ///
  /// In fr, this message translates to:
  /// **'Comptant'**
  String get purchaseCash;

  /// No description provided for @purchaseTimes.
  ///
  /// In fr, this message translates to:
  /// **'En {count} fois'**
  String purchaseTimes(int count);

  /// No description provided for @purchaseNextMonth.
  ///
  /// In fr, this message translates to:
  /// **'Le mois suivant'**
  String get purchaseNextMonth;

  /// No description provided for @purchaseBalanceOn.
  ///
  /// In fr, this message translates to:
  /// **'Solde au {date}'**
  String purchaseBalanceOn(String date);

  /// No description provided for @purchaseLowest.
  ///
  /// In fr, this message translates to:
  /// **'Point bas : {amount} le {date}'**
  String purchaseLowest(String amount, String date);

  /// No description provided for @purchaseGoal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif de la catégorie : {spent} dépensés sur {goal} ce mois-ci.'**
  String purchaseGoal(String spent, String goal);

  /// No description provided for @purchaseGoalOver.
  ///
  /// In fr, this message translates to:
  /// **'Objectif du mois dépassé de {amount}'**
  String purchaseGoalOver(String amount);

  /// No description provided for @purchaseChoose.
  ///
  /// In fr, this message translates to:
  /// **'Choisir et enregistrer'**
  String get purchaseChoose;

  /// No description provided for @purchaseSaved.
  ///
  /// In fr, this message translates to:
  /// **'Achat enregistré dans les opérations prévues.'**
  String get purchaseSaved;

  /// No description provided for @purchaseHowVariable.
  ///
  /// In fr, this message translates to:
  /// **'Calculé par le moteur de prévision : opérations prévues et dépenses variables estimées. En plusieurs fois : mensualités arrondies au centime supérieur, la dernière ajuste ; sans frais.'**
  String get purchaseHowVariable;

  /// No description provided for @purchaseHowPlanned.
  ///
  /// In fr, this message translates to:
  /// **'Calculé par le moteur de prévision : opérations prévues seulement. En plusieurs fois : mensualités arrondies au centime supérieur, la dernière ajuste ; sans frais.'**
  String get purchaseHowPlanned;

  /// No description provided for @adminTitle.
  ///
  /// In fr, this message translates to:
  /// **'Administration du serveur'**
  String get adminTitle;

  /// No description provided for @adminRefresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get adminRefresh;

  /// No description provided for @adminTabHealth.
  ///
  /// In fr, this message translates to:
  /// **'Santé et chiffres'**
  String get adminTabHealth;

  /// No description provided for @adminTabUsers.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs'**
  String get adminTabUsers;

  /// No description provided for @adminTabSecurity.
  ///
  /// In fr, this message translates to:
  /// **'IP bloquées'**
  String get adminTabSecurity;

  /// No description provided for @adminTabAudit.
  ///
  /// In fr, this message translates to:
  /// **'Journal'**
  String get adminTabAudit;

  /// No description provided for @adminHealth.
  ///
  /// In fr, this message translates to:
  /// **'État du serveur'**
  String get adminHealth;

  /// No description provided for @adminVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version installée'**
  String get adminVersion;

  /// No description provided for @adminUptime.
  ///
  /// In fr, this message translates to:
  /// **'En marche depuis'**
  String get adminUptime;

  /// No description provided for @adminUptimeDays.
  ///
  /// In fr, this message translates to:
  /// **'{days} j {hours} h'**
  String adminUptimeDays(int days, int hours);

  /// No description provided for @adminUptimeHours.
  ///
  /// In fr, this message translates to:
  /// **'{hours} h {minutes} min'**
  String adminUptimeHours(int hours, int minutes);

  /// No description provided for @adminUptimeMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min'**
  String adminUptimeMinutes(int minutes);

  /// No description provided for @adminDatabase.
  ///
  /// In fr, this message translates to:
  /// **'Base de données'**
  String get adminDatabase;

  /// No description provided for @adminUnreachable.
  ///
  /// In fr, this message translates to:
  /// **'injoignable'**
  String get adminUnreachable;

  /// No description provided for @adminOk.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get adminOk;

  /// No description provided for @adminFailed.
  ///
  /// In fr, this message translates to:
  /// **'en échec'**
  String get adminFailed;

  /// No description provided for @adminNotYet.
  ///
  /// In fr, this message translates to:
  /// **'pas encore'**
  String get adminNotYet;

  /// No description provided for @adminDocuments.
  ///
  /// In fr, this message translates to:
  /// **'Documents et factures stockés'**
  String get adminDocuments;

  /// No description provided for @adminAlertsJob.
  ///
  /// In fr, this message translates to:
  /// **'Dernière vérification des alertes'**
  String get adminAlertsJob;

  /// No description provided for @adminClock.
  ///
  /// In fr, this message translates to:
  /// **'Horloge du serveur'**
  String get adminClock;

  /// No description provided for @adminClockDrift.
  ///
  /// In fr, this message translates to:
  /// **'écart de {seconds} s avec cet appareil'**
  String adminClockDrift(int seconds);

  /// No description provided for @adminEmail.
  ///
  /// In fr, this message translates to:
  /// **'Envoi des courriels'**
  String get adminEmail;

  /// No description provided for @adminEmailSmtp.
  ///
  /// In fr, this message translates to:
  /// **'serveur SMTP configuré'**
  String get adminEmailSmtp;

  /// No description provided for @adminEmailLog.
  ///
  /// In fr, this message translates to:
  /// **'non configuré : écrits dans le journal du serveur'**
  String get adminEmailLog;

  /// No description provided for @adminTestEmail.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer un courriel de test'**
  String get adminTestEmail;

  /// No description provided for @adminTestEmailSent.
  ///
  /// In fr, this message translates to:
  /// **'Courriel de test envoyé à {email}.'**
  String adminTestEmailSent(String email);

  /// No description provided for @adminTestEmailLogged.
  ///
  /// In fr, this message translates to:
  /// **'SMTP non configuré : le courriel de test est écrit dans le journal du serveur.'**
  String get adminTestEmailLogged;

  /// No description provided for @adminPublicUrl.
  ///
  /// In fr, this message translates to:
  /// **'Adresse publique'**
  String get adminPublicUrl;

  /// No description provided for @adminStats.
  ///
  /// In fr, this message translates to:
  /// **'Chiffres du serveur (aucun montant)'**
  String get adminStats;

  /// No description provided for @adminStatUsers.
  ///
  /// In fr, this message translates to:
  /// **'Comptes utilisateurs'**
  String get adminStatUsers;

  /// No description provided for @adminStatUsersValue.
  ///
  /// In fr, this message translates to:
  /// **'{count} · double authentification : {twoFactor} · bloqués : {blocked}'**
  String adminStatUsersValue(int count, int twoFactor, int blocked);

  /// No description provided for @adminStatGroups.
  ///
  /// In fr, this message translates to:
  /// **'Groupes (foyers)'**
  String get adminStatGroups;

  /// No description provided for @adminStatAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes bancaires'**
  String get adminStatAccounts;

  /// No description provided for @adminStatOperations.
  ///
  /// In fr, this message translates to:
  /// **'Opérations'**
  String get adminStatOperations;

  /// No description provided for @adminStatOperationsValue.
  ///
  /// In fr, this message translates to:
  /// **'{count} · {recent} ajoutées en 30 jours'**
  String adminStatOperationsValue(int count, int recent);

  /// No description provided for @adminStatImports.
  ///
  /// In fr, this message translates to:
  /// **'Imports en 30 jours'**
  String get adminStatImports;

  /// No description provided for @adminStatRules.
  ///
  /// In fr, this message translates to:
  /// **'Règles des groupes'**
  String get adminStatRules;

  /// No description provided for @adminStatInvitations.
  ///
  /// In fr, this message translates to:
  /// **'Invitations en attente'**
  String get adminStatInvitations;

  /// No description provided for @adminStatAuto.
  ///
  /// In fr, this message translates to:
  /// **'Classement automatique (90 jours)'**
  String get adminStatAuto;

  /// No description provided for @adminStatAutoHelp.
  ///
  /// In fr, this message translates to:
  /// **'Opérations importées : {auto} classées automatiquement, {manual} à la main, {none} à classer. Objectif de l\'alpha : 70 % (décision 0014).'**
  String adminStatAutoHelp(int auto, int manual, int none);

  /// No description provided for @adminUsersHelp.
  ///
  /// In fr, this message translates to:
  /// **'Tous les comptes du serveur. Un compte bloqué est déconnecté partout et ne peut plus se connecter ; ses données restent intactes.'**
  String get adminUsersHelp;

  /// No description provided for @adminServerAdmin.
  ///
  /// In fr, this message translates to:
  /// **'administrateur du serveur'**
  String get adminServerAdmin;

  /// No description provided for @adminTwoFactorOn.
  ///
  /// In fr, this message translates to:
  /// **'double authentification'**
  String get adminTwoFactorOn;

  /// No description provided for @adminTwoFactorOff.
  ///
  /// In fr, this message translates to:
  /// **'sans double authentification'**
  String get adminTwoFactorOff;

  /// No description provided for @adminCreated.
  ///
  /// In fr, this message translates to:
  /// **'créé le {date}'**
  String adminCreated(String date);

  /// No description provided for @adminLastActive.
  ///
  /// In fr, this message translates to:
  /// **'actif le {date}'**
  String adminLastActive(String date);

  /// No description provided for @adminNeverActive.
  ///
  /// In fr, this message translates to:
  /// **'jamais connecté'**
  String get adminNeverActive;

  /// No description provided for @adminBlocked.
  ///
  /// In fr, this message translates to:
  /// **'bloqué'**
  String get adminBlocked;

  /// No description provided for @adminBlock.
  ///
  /// In fr, this message translates to:
  /// **'Bloquer'**
  String get adminBlock;

  /// No description provided for @adminUnblock.
  ///
  /// In fr, this message translates to:
  /// **'Débloquer'**
  String get adminUnblock;

  /// No description provided for @adminBlockTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bloquer {email} ?'**
  String adminBlockTitle(String email);

  /// No description provided for @adminBlockHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le compte sera déconnecté dans les minutes qui viennent et ne pourra plus se connecter. Rien n\'est supprimé ; vous pourrez le débloquer.'**
  String get adminBlockHelp;

  /// No description provided for @adminUserBlocked.
  ///
  /// In fr, this message translates to:
  /// **'Compte bloqué.'**
  String get adminUserBlocked;

  /// No description provided for @adminUserUnblocked.
  ///
  /// In fr, this message translates to:
  /// **'Compte débloqué.'**
  String get adminUserUnblocked;

  /// No description provided for @adminBansHelp.
  ///
  /// In fr, this message translates to:
  /// **'Adresses IP bloquées après trop d\'échecs de connexion. La durée double à chaque récidive.'**
  String get adminBansHelp;

  /// No description provided for @adminBansEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune adresse bloquée.'**
  String get adminBansEmpty;

  /// No description provided for @adminBanUntil.
  ///
  /// In fr, this message translates to:
  /// **'jusqu\'au {date} · {count}ᵉ blocage'**
  String adminBanUntil(String date, int count);

  /// No description provided for @adminUnban.
  ///
  /// In fr, this message translates to:
  /// **'Débloquer'**
  String get adminUnban;

  /// No description provided for @adminUnbanned.
  ///
  /// In fr, this message translates to:
  /// **'Adresse débloquée.'**
  String get adminUnbanned;

  /// No description provided for @adminAuditHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les 100 dernières actions sensibles : qui, quoi, quand. Le contenu des changements n\'est pas montré (il peut contenir les données d\'un foyer).'**
  String get adminAuditHelp;

  /// No description provided for @adminAuditEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien pour l\'instant.'**
  String get adminAuditEmpty;

  /// No description provided for @adminAuditGroup.
  ///
  /// In fr, this message translates to:
  /// **'groupe n° {id}'**
  String adminAuditGroup(int id);

  /// No description provided for @adminSystem.
  ///
  /// In fr, this message translates to:
  /// **'serveur'**
  String get adminSystem;

  /// No description provided for @menuAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administration du serveur'**
  String get menuAdmin;

  /// No description provided for @error_cannot_block_self.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez pas bloquer votre propre compte.'**
  String get error_cannot_block_self;

  /// No description provided for @error_user_not_found.
  ///
  /// In fr, this message translates to:
  /// **'Compte introuvable.'**
  String get error_user_not_found;

  /// No description provided for @error_mail_failed.
  ///
  /// In fr, this message translates to:
  /// **'L\'envoi du courriel a échoué : vérifiez les réglages SMTP dans docker/.env et le journal du serveur.'**
  String get error_mail_failed;

  /// No description provided for @adminTabBackups.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardes'**
  String get adminTabBackups;

  /// No description provided for @adminBackupsUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Le dossier d\'échange avec le serveur hôte (docker/state) n\'est pas monté. Il est installé tout seul par la prochaine mise à jour automatique, ou tout de suite avec cette commande lancée en root dans le dossier d\'OwnCoffer :'**
  String get adminBackupsUnavailable;

  /// No description provided for @adminBackupNoNightly.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sauvegarde de nuit pour l\'instant.'**
  String get adminBackupNoNightly;

  /// No description provided for @adminBackupNightlyOk.
  ///
  /// In fr, this message translates to:
  /// **'Dernière sauvegarde de nuit : {date}'**
  String adminBackupNightlyOk(String date);

  /// No description provided for @adminBackupNightlyLate.
  ///
  /// In fr, this message translates to:
  /// **'Pas de sauvegarde de nuit depuis le {date} : vérifiez owncoffer-backup.timer.'**
  String adminBackupNightlyLate(String date);

  /// No description provided for @adminBackupLastFailed.
  ///
  /// In fr, this message translates to:
  /// **'La dernière sauvegarde a échoué ({date}) : {message}'**
  String adminBackupLastFailed(String date, String message);

  /// No description provided for @adminBackupNow.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder maintenant'**
  String get adminBackupNow;

  /// No description provided for @adminBackupPending.
  ///
  /// In fr, this message translates to:
  /// **'Demandée, en cours sur le serveur…'**
  String get adminBackupPending;

  /// No description provided for @adminBackupRequested.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde demandée : elle apparaît ici dans quelques secondes (une toutes les 10 minutes au plus).'**
  String get adminBackupRequested;

  /// No description provided for @adminBackupsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Gardées sur le même serveur, dans docker/backups/ : 30 de nuit, 10 manuelles, 10 avant mise à jour. Copiez-les régulièrement ailleurs (disque, autre machine).'**
  String get adminBackupsHelp;

  /// No description provided for @adminBackupsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sauvegarde.'**
  String get adminBackupsEmpty;

  /// No description provided for @adminBackupDaily.
  ///
  /// In fr, this message translates to:
  /// **'De nuit'**
  String get adminBackupDaily;

  /// No description provided for @adminBackupManual.
  ///
  /// In fr, this message translates to:
  /// **'Manuelle'**
  String get adminBackupManual;

  /// No description provided for @adminBackupBefore.
  ///
  /// In fr, this message translates to:
  /// **'Avant la mise à jour {version}'**
  String adminBackupBefore(String version);

  /// No description provided for @adminRestoreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer une sauvegarde'**
  String get adminRestoreTitle;

  /// No description provided for @adminRestoreHelp.
  ///
  /// In fr, this message translates to:
  /// **'Sur le serveur seulement, dans le dossier d\'OwnCoffer : restaurer remplace toutes les données actuelles. Faites d\'abord une sauvegarde.'**
  String get adminRestoreHelp;

  /// No description provided for @error_host_bridge_missing.
  ///
  /// In fr, this message translates to:
  /// **'Le dossier d\'échange avec le serveur hôte (docker/state) n\'est pas accessible.'**
  String get error_host_bridge_missing;

  /// No description provided for @adminTabInvitations.
  ///
  /// In fr, this message translates to:
  /// **'Invitations'**
  String get adminTabInvitations;

  /// No description provided for @adminInvitationsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les invitations en attente de tous les groupes. En tant qu\'administrateur du serveur, vous pouvez inviter dans n\'importe quel groupe ; la personne reçoit un lien par courriel, valable 7 jours.'**
  String get adminInvitationsHelp;

  /// No description provided for @adminGroups.
  ///
  /// In fr, this message translates to:
  /// **'Groupes du serveur'**
  String get adminGroups;

  /// No description provided for @adminGroupSize.
  ///
  /// In fr, this message translates to:
  /// **'{members} membre(s) · {accounts} compte(s) bancaire(s)'**
  String adminGroupSize(int members, int accounts);

  /// No description provided for @adminInvitationsPending.
  ///
  /// In fr, this message translates to:
  /// **'Invitations en attente'**
  String get adminInvitationsPending;

  /// No description provided for @adminInvitationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune invitation en attente.'**
  String get adminInvitationsEmpty;

  /// No description provided for @adminInvitedBy.
  ///
  /// In fr, this message translates to:
  /// **'envoyée par {email}'**
  String adminInvitedBy(String email);

  /// No description provided for @adminInvitationExpires.
  ///
  /// In fr, this message translates to:
  /// **'valable jusqu\'au {date}'**
  String adminInvitationExpires(String date);

  /// No description provided for @adminInvitationRevoked.
  ///
  /// In fr, this message translates to:
  /// **'Invitation révoquée : le lien ne marche plus.'**
  String get adminInvitationRevoked;

  /// No description provided for @error_invitation_not_pending.
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation n\'est plus en attente.'**
  String get error_invitation_not_pending;

  /// No description provided for @adminTabUpdates.
  ///
  /// In fr, this message translates to:
  /// **'Mises à jour'**
  String get adminTabUpdates;

  /// No description provided for @adminVersionRunning.
  ///
  /// In fr, this message translates to:
  /// **'Version en service : {version}'**
  String adminVersionRunning(String version);

  /// No description provided for @adminUpdatesUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur hôte n\'a pas encore donné l\'état des mises à jour (dossier docker/state absent, ou script de mise à jour pas encore passé). Il passe toutes les 15 minutes ; pour l\'installer tout de suite, lancez en root dans le dossier d\'OwnCoffer :'**
  String get adminUpdatesUnavailable;

  /// No description provided for @adminUpToDate.
  ///
  /// In fr, this message translates to:
  /// **'OwnCoffer est à jour.'**
  String get adminUpToDate;

  /// No description provided for @adminUpdateAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle version disponible : {version}'**
  String adminUpdateAvailable(String version);

  /// No description provided for @adminUpdateChecked.
  ///
  /// In fr, this message translates to:
  /// **'Dernière vérification : {date}'**
  String adminUpdateChecked(String date);

  /// No description provided for @adminUpdateFailedVersion.
  ///
  /// In fr, this message translates to:
  /// **'La version {version} n\'a pas démarré : le serveur est revenu à la version précédente avec la sauvegarde. Elle n\'est plus réessayée automatiquement ; vous pouvez la réinstaller à la main.'**
  String adminUpdateFailedVersion(String version);

  /// No description provided for @adminInstallNow.
  ///
  /// In fr, this message translates to:
  /// **'Installer {version}'**
  String adminInstallNow(String version);

  /// No description provided for @adminInstall.
  ///
  /// In fr, this message translates to:
  /// **'Installer'**
  String get adminInstall;

  /// No description provided for @adminInstallTitle.
  ///
  /// In fr, this message translates to:
  /// **'Installer {version} maintenant ?'**
  String adminInstallTitle(String version);

  /// No description provided for @adminInstallHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur fait d\'abord une sauvegarde, installe la version, puis vérifie qu\'elle répond ; sinon il revient à la version actuelle avec la sauvegarde. L\'application est indisponible environ une minute ; rechargez la page ensuite.'**
  String get adminInstallHelp;

  /// No description provided for @adminCheckNow.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier maintenant'**
  String get adminCheckNow;

  /// No description provided for @adminUpdatePending.
  ///
  /// In fr, this message translates to:
  /// **'Demandé, en cours sur le serveur…'**
  String get adminUpdatePending;

  /// No description provided for @adminAutoUpdate.
  ///
  /// In fr, this message translates to:
  /// **'Mises à jour automatiques'**
  String get adminAutoUpdate;

  /// No description provided for @adminAutoUpdateOn.
  ///
  /// In fr, this message translates to:
  /// **'Chaque version publiée est installée dans les 15 minutes, après une sauvegarde.'**
  String get adminAutoUpdateOn;

  /// No description provided for @adminAutoUpdateOff.
  ///
  /// In fr, this message translates to:
  /// **'Désactivées : les nouvelles versions sont signalées ici et attendent que vous les installiez.'**
  String get adminAutoUpdateOff;

  /// No description provided for @adminAutoUpdateSavedOn.
  ///
  /// In fr, this message translates to:
  /// **'Mises à jour automatiques activées.'**
  String get adminAutoUpdateSavedOn;

  /// No description provided for @adminAutoUpdateSavedOff.
  ///
  /// In fr, this message translates to:
  /// **'Mises à jour automatiques désactivées.'**
  String get adminAutoUpdateSavedOff;

  /// No description provided for @adminCheckRequested.
  ///
  /// In fr, this message translates to:
  /// **'Vérification demandée : le résultat apparaît dans quelques secondes.'**
  String get adminCheckRequested;

  /// No description provided for @adminInstallRequested.
  ///
  /// In fr, this message translates to:
  /// **'Installation de {version} demandée : l\'application redémarre dans quelques minutes.'**
  String adminInstallRequested(String version);

  /// No description provided for @adminReleasesUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get adminReleasesUpcoming;

  /// No description provided for @adminReleasesInstalled.
  ///
  /// In fr, this message translates to:
  /// **'Notes des versions installées'**
  String get adminReleasesInstalled;

  /// No description provided for @adminUpdateHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get adminUpdateHistory;

  /// No description provided for @adminUpdateInstalled.
  ///
  /// In fr, this message translates to:
  /// **'installée'**
  String get adminUpdateInstalled;

  /// No description provided for @adminUpdateRollback.
  ///
  /// In fr, this message translates to:
  /// **'retour à la version précédente'**
  String get adminUpdateRollback;

  /// No description provided for @adminUpdateRollbackFailed.
  ///
  /// In fr, this message translates to:
  /// **'retour en arrière en échec'**
  String get adminUpdateRollbackFailed;

  /// No description provided for @adminUpdateRefused.
  ///
  /// In fr, this message translates to:
  /// **'refusée'**
  String get adminUpdateRefused;

  /// No description provided for @error_invalid_version.
  ///
  /// In fr, this message translates to:
  /// **'Version invalide : seule une version publiée plus récente que celle installée peut être installée.'**
  String get error_invalid_version;

  /// No description provided for @navInvoices.
  ///
  /// In fr, this message translates to:
  /// **'Factures'**
  String get navInvoices;

  /// No description provided for @invoicesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Factures'**
  String get invoicesTitle;

  /// No description provided for @invoicesIntro.
  ///
  /// In fr, this message translates to:
  /// **'Les factures et tickets, nommés d\'après leur opération (date, libellé, montant). Ajoutez-en depuis une opération (page Opérations), ou ici même si l\'opération n\'est pas encore là : elle sera proposée dès qu\'elle arrivera.'**
  String get invoicesIntro;

  /// No description provided for @invoicesSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher (nom, libellé, compte)'**
  String get invoicesSearch;

  /// No description provided for @invoicesAllYears.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les années'**
  String get invoicesAllYears;

  /// No description provided for @invoicesWarrantyFilter.
  ///
  /// In fr, this message translates to:
  /// **'Garantie en cours'**
  String get invoicesWarrantyFilter;

  /// No description provided for @invoicesExport.
  ///
  /// In fr, this message translates to:
  /// **'Exporter en ZIP'**
  String get invoicesExport;

  /// No description provided for @invoicesExporting.
  ///
  /// In fr, this message translates to:
  /// **'Export… {done}/{total}'**
  String invoicesExporting(int done, int total);

  /// No description provided for @invoicesZipName.
  ///
  /// In fr, this message translates to:
  /// **'Factures.zip'**
  String get invoicesZipName;

  /// No description provided for @invoicesZipNameYear.
  ///
  /// In fr, this message translates to:
  /// **'Factures {year}.zip'**
  String invoicesZipNameYear(String year);

  /// No description provided for @invoicesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune facture pour l\'instant.'**
  String get invoicesEmpty;

  /// No description provided for @invoicesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 facture} other{{count} factures}}'**
  String invoicesCount(int count);

  /// No description provided for @invoicesOfOperation.
  ///
  /// In fr, this message translates to:
  /// **'Factures'**
  String get invoicesOfOperation;

  /// No description provided for @invoicesNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune facture jointe.'**
  String get invoicesNone;

  /// No description provided for @invoiceAttach.
  ///
  /// In fr, this message translates to:
  /// **'Joindre une facture'**
  String get invoiceAttach;

  /// No description provided for @invoiceTakePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Prendre en photo'**
  String get invoiceTakePhoto;

  /// No description provided for @invoiceAdded.
  ///
  /// In fr, this message translates to:
  /// **'Facture ajoutée : {name}'**
  String invoiceAdded(String name);

  /// No description provided for @invoiceBadge.
  ///
  /// In fr, this message translates to:
  /// **'Facture jointe'**
  String get invoiceBadge;

  /// No description provided for @invoiceUnattached.
  ///
  /// In fr, this message translates to:
  /// **'Sans opération'**
  String get invoiceUnattached;

  /// No description provided for @invoiceActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions'**
  String get invoiceActions;

  /// No description provided for @invoiceOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir'**
  String get invoiceOpen;

  /// No description provided for @invoiceEdit.
  ///
  /// In fr, this message translates to:
  /// **'Description et garantie'**
  String get invoiceEdit;

  /// No description provided for @invoiceSend.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer par courriel'**
  String get invoiceSend;

  /// No description provided for @invoiceDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get invoiceDelete;

  /// No description provided for @invoiceDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la facture « {name} » ?'**
  String invoiceDeleteConfirm(String name);

  /// No description provided for @invoiceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get invoiceLabel;

  /// No description provided for @invoiceLabelHint.
  ///
  /// In fr, this message translates to:
  /// **'Lave-linge, réparation voiture…'**
  String get invoiceLabelHint;

  /// No description provided for @invoiceLabelHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutée au nom de la facture.'**
  String get invoiceLabelHelp;

  /// No description provided for @invoiceWarranty.
  ///
  /// In fr, this message translates to:
  /// **'Fin de garantie'**
  String get invoiceWarranty;

  /// No description provided for @invoiceWarrantyNone.
  ///
  /// In fr, this message translates to:
  /// **'Pas de garantie suivie.'**
  String get invoiceWarrantyNone;

  /// No description provided for @invoiceWarrantyUntil.
  ///
  /// In fr, this message translates to:
  /// **'Garantie jusqu\'au {date}'**
  String invoiceWarrantyUntil(String date);

  /// No description provided for @invoiceWarrantyOver.
  ///
  /// In fr, this message translates to:
  /// **'Garantie terminée le {date}'**
  String invoiceWarrantyOver(String date);

  /// No description provided for @invoiceWarrantyYears.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 an} other{{count} ans}}'**
  String invoiceWarrantyYears(int count);

  /// No description provided for @invoiceWarrantyPick.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une date'**
  String get invoiceWarrantyPick;

  /// No description provided for @invoiceWarrantyClear.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get invoiceWarrantyClear;

  /// No description provided for @invoiceWarrantyHelp.
  ///
  /// In fr, this message translates to:
  /// **'Comptée à partir de la date de l\'opération. Un rappel arrive dans les notifications et par courriel un mois avant la fin.'**
  String get invoiceWarrantyHelp;

  /// No description provided for @invoiceSendTo.
  ///
  /// In fr, this message translates to:
  /// **'Adresse du destinataire'**
  String get invoiceSendTo;

  /// No description provided for @invoiceSendMessage.
  ///
  /// In fr, this message translates to:
  /// **'Message (facultatif)'**
  String get invoiceSendMessage;

  /// No description provided for @invoiceSendHelp.
  ///
  /// In fr, this message translates to:
  /// **'La facture part en pièce jointe, depuis l\'adresse du serveur OwnCoffer.'**
  String get invoiceSendHelp;

  /// No description provided for @invoiceSendAction.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get invoiceSendAction;

  /// No description provided for @invoiceSent.
  ///
  /// In fr, this message translates to:
  /// **'Facture envoyée.'**
  String get invoiceSent;

  /// No description provided for @notifWarrantyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Garantie de « {name} » : fin le {date}'**
  String notifWarrantyTitle(String name, String date);

  /// No description provided for @notifWarrantyBody.
  ///
  /// In fr, this message translates to:
  /// **'La facture est dans la page Factures.'**
  String get notifWarrantyBody;

  /// No description provided for @error_invoice_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Facture introuvable ou non accessible.'**
  String get error_invoice_access_denied;

  /// No description provided for @error_mail_not_configured.
  ///
  /// In fr, this message translates to:
  /// **'L\'envoi de courriels n\'est pas configuré sur ce serveur (réglages SMTP de docker/.env).'**
  String get error_mail_not_configured;

  /// No description provided for @error_send_limit.
  ///
  /// In fr, this message translates to:
  /// **'Limite atteinte : 20 envois par jour. Réessayez demain.'**
  String get error_send_limit;

  /// No description provided for @adminTabMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres du groupe'**
  String get adminTabMembers;

  /// No description provided for @adminTabMySecurity.
  ///
  /// In fr, this message translates to:
  /// **'Ma sécurité'**
  String get adminTabMySecurity;

  /// No description provided for @adminMembersOf.
  ///
  /// In fr, this message translates to:
  /// **'Membres de « {group} »'**
  String adminMembersOf(String group);

  /// No description provided for @invoiceAddWaiting.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une facture'**
  String get invoiceAddWaiting;

  /// No description provided for @invoicesWaitingFilter.
  ///
  /// In fr, this message translates to:
  /// **'À rattacher'**
  String get invoicesWaitingFilter;

  /// No description provided for @invoiceAttachTo.
  ///
  /// In fr, this message translates to:
  /// **'Rattacher à une opération'**
  String get invoiceAttachTo;

  /// No description provided for @invoiceHints.
  ///
  /// In fr, this message translates to:
  /// **'Ce que dit la facture'**
  String get invoiceHints;

  /// No description provided for @invoiceHintsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Tout est facultatif : le montant, la date et le commerçant servent à proposer la bonne opération, maintenant ou après le prochain import. En attendant, tous les membres du groupe voient la facture.'**
  String get invoiceHintsHelp;

  /// No description provided for @invoiceHintAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant payé'**
  String get invoiceHintAmount;

  /// No description provided for @invoiceHintAmountInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Montant illisible (exemple : 499,00).'**
  String get invoiceHintAmountInvalid;

  /// No description provided for @invoiceHintMerchant.
  ///
  /// In fr, this message translates to:
  /// **'Commerçant'**
  String get invoiceHintMerchant;

  /// No description provided for @invoiceHintMerchantHint.
  ///
  /// In fr, this message translates to:
  /// **'Darty, garage Martin…'**
  String get invoiceHintMerchantHint;

  /// No description provided for @invoiceHintNoDate.
  ///
  /// In fr, this message translates to:
  /// **'Date inconnue'**
  String get invoiceHintNoDate;

  /// No description provided for @invoiceHintDate.
  ///
  /// In fr, this message translates to:
  /// **'Date : {date}'**
  String invoiceHintDate(String date);

  /// No description provided for @invoiceProposalsSearch.
  ///
  /// In fr, this message translates to:
  /// **'Chercher une opération par son libellé'**
  String get invoiceProposalsSearch;

  /// No description provided for @invoiceProposalsNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune opération ne correspond pour l\'instant. La facture reste « à rattacher » : elle vous sera proposée dans l\'opération quand elle sera importée.'**
  String get invoiceProposalsNone;

  /// No description provided for @invoiceProposalsNoneSearch.
  ///
  /// In fr, this message translates to:
  /// **'Aucune opération ne contient ce texte.'**
  String get invoiceProposalsNoneSearch;

  /// No description provided for @invoiceMatchScore.
  ///
  /// In fr, this message translates to:
  /// **'correspondance {score} %'**
  String invoiceMatchScore(int score);

  /// No description provided for @invoiceAttachLater.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get invoiceAttachLater;

  /// No description provided for @invoiceAttached.
  ///
  /// In fr, this message translates to:
  /// **'Facture rattachée : {name}'**
  String invoiceAttached(String name);

  /// No description provided for @invoicesWaitingForThis.
  ///
  /// In fr, this message translates to:
  /// **'Factures en attente qui pourraient être celle-ci'**
  String get invoicesWaitingForThis;

  /// No description provided for @invoiceAttachHere.
  ///
  /// In fr, this message translates to:
  /// **'Rattacher ici'**
  String get invoiceAttachHere;

  /// No description provided for @scanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recadrer la facture'**
  String get scanTitle;

  /// No description provided for @scanHelp.
  ///
  /// In fr, this message translates to:
  /// **'Faites glisser les 4 coins sur ceux de la facture : seule la facture est gardée, redressée comme par un scanner. Tout se fait sur cet appareil.'**
  String get scanHelp;

  /// No description provided for @scanLoading.
  ///
  /// In fr, this message translates to:
  /// **'Lecture de la photo…'**
  String get scanLoading;

  /// No description provided for @scanUnreadable.
  ///
  /// In fr, this message translates to:
  /// **'Cette image ne peut pas être lue ici pour la recadrer.'**
  String get scanUnreadable;

  /// No description provided for @scanFailed.
  ///
  /// In fr, this message translates to:
  /// **'Le recadrage a échoué. Gardez la photo telle quelle, ou réessayez avec d\'autres coins.'**
  String get scanFailed;

  /// No description provided for @scanKeepAsIs.
  ///
  /// In fr, this message translates to:
  /// **'Garder telle quelle'**
  String get scanKeepAsIs;

  /// No description provided for @scanEnhance.
  ///
  /// In fr, this message translates to:
  /// **'Améliorer la lisibilité (fond blanc, texte foncé)'**
  String get scanEnhance;

  /// No description provided for @scanWholePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Toute la photo'**
  String get scanWholePhoto;

  /// No description provided for @scanDetectAgain.
  ///
  /// In fr, this message translates to:
  /// **'Coins trouvés'**
  String get scanDetectAgain;

  /// No description provided for @scanApply.
  ///
  /// In fr, this message translates to:
  /// **'Recadrer'**
  String get scanApply;

  /// No description provided for @periodQuarter.
  ///
  /// In fr, this message translates to:
  /// **'Trimestre'**
  String get periodQuarter;

  /// No description provided for @periodQuarterName.
  ///
  /// In fr, this message translates to:
  /// **'T{quarter} {year}'**
  String periodQuarterName(int quarter, String year);

  /// No description provided for @spendingView.
  ///
  /// In fr, this message translates to:
  /// **'Affichage'**
  String get spendingView;

  /// No description provided for @spendingViewLines.
  ///
  /// In fr, this message translates to:
  /// **'Lignes'**
  String get spendingViewLines;

  /// No description provided for @spendingViewTable.
  ///
  /// In fr, this message translates to:
  /// **'Tableau'**
  String get spendingViewTable;

  /// No description provided for @spendingViewPie.
  ///
  /// In fr, this message translates to:
  /// **'Camembert'**
  String get spendingViewPie;

  /// No description provided for @spendingViewChart.
  ///
  /// In fr, this message translates to:
  /// **'Graphique'**
  String get spendingViewChart;

  /// No description provided for @spendingPeriods.
  ///
  /// In fr, this message translates to:
  /// **'Sur {count} périodes'**
  String spendingPeriods(int count);

  /// No description provided for @spendingPeriodsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de périodes montrées par les graphiques dans le temps'**
  String get spendingPeriodsHelp;

  /// No description provided for @sharePercent.
  ///
  /// In fr, this message translates to:
  /// **'{percent} %'**
  String sharePercent(int percent);

  /// No description provided for @tableCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get tableCategory;

  /// No description provided for @tableAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get tableAmount;

  /// No description provided for @tableShare.
  ///
  /// In fr, this message translates to:
  /// **'Part'**
  String get tableShare;

  /// No description provided for @tablePrevious.
  ///
  /// In fr, this message translates to:
  /// **'Période précédente'**
  String get tablePrevious;

  /// No description provided for @tableAverage.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne des 3 précédentes'**
  String get tableAverage;

  /// No description provided for @tableCount.
  ///
  /// In fr, this message translates to:
  /// **'Opérations'**
  String get tableCount;

  /// No description provided for @pieOthers.
  ///
  /// In fr, this message translates to:
  /// **'Autres'**
  String get pieOthers;

  /// No description provided for @pieDirect.
  ///
  /// In fr, this message translates to:
  /// **'{category} (sans sous-catégorie)'**
  String pieDirect(String category);

  /// No description provided for @pieTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get pieTotal;

  /// No description provided for @pieAllCategories.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories'**
  String get pieAllCategories;

  /// No description provided for @pieSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Répartition par catégorie'**
  String get pieSemantic;

  /// No description provided for @pieHelp.
  ///
  /// In fr, this message translates to:
  /// **'Touchez une catégorie pour voir sa répartition ou ses opérations ; « Autres » ouvre le tableau complet.'**
  String get pieHelp;

  /// No description provided for @pieHelpSub.
  ///
  /// In fr, this message translates to:
  /// **'Touchez une sous-catégorie pour voir ses opérations.'**
  String get pieHelpSub;

  /// No description provided for @chartSemantic.
  ///
  /// In fr, this message translates to:
  /// **'Évolution des principales catégories'**
  String get chartSemantic;

  /// No description provided for @chartHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les {count} catégories les plus importantes sur ces périodes. Touchez le graphique pour lire les montants, ou une catégorie pour voir ses opérations de la période en cours.'**
  String chartHelp(int count);

  /// No description provided for @budgetOperationsHint.
  ///
  /// In fr, this message translates to:
  /// **'Touchez une opération pour la gérer : catégorie, ventilation, facture, note, abonnement…'**
  String get budgetOperationsHint;

  /// No description provided for @loanFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Repérés dans vos opérations'**
  String get loanFoundTitle;

  /// No description provided for @loanFoundHelp.
  ///
  /// In fr, this message translates to:
  /// **'Paiements en plusieurs fois et petits crédits prélevés ces derniers mois, pas encore dans vos crédits. Ajoutez-les pour suivre ce qu\'il reste à payer ; vous réglez le nombre de mensualités.'**
  String get loanFoundHelp;

  /// No description provided for @loanFoundPaid.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 prélèvement de {amount} le {date}} other{{count} prélèvements, le dernier de {amount}, depuis le {date}}}'**
  String loanFoundPaid(int count, String amount, String date);

  /// No description provided for @loanFoundStated.
  ///
  /// In fr, this message translates to:
  /// **'en {count} fois d\'après le libellé'**
  String loanFoundStated(int count);

  /// No description provided for @loanFoundAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get loanFoundAdd;

  /// No description provided for @loanInstallmentsCountHelp.
  ///
  /// In fr, this message translates to:
  /// **'Touchez − ou + pour régler le nombre de mensualités, celles déjà prélevées comprises.'**
  String get loanInstallmentsCountHelp;

  /// No description provided for @loanInstallmentsLess.
  ///
  /// In fr, this message translates to:
  /// **'Une mensualité de moins'**
  String get loanInstallmentsLess;

  /// No description provided for @loanInstallmentsMore.
  ///
  /// In fr, this message translates to:
  /// **'Une mensualité de plus'**
  String get loanInstallmentsMore;

  /// No description provided for @loanInstallmentsTotalHelp.
  ///
  /// In fr, this message translates to:
  /// **'Calculé : mensualité × nombre de mensualités. Modifiable si l\'achat coûtait autre chose.'**
  String get loanInstallmentsTotalHelp;

  /// No description provided for @compareTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comparer'**
  String get compareTitle;

  /// No description provided for @compareIntro.
  ///
  /// In fr, this message translates to:
  /// **'Mettez côte à côte des catégories dans le temps, plusieurs périodes ou plusieurs comptes. La première période (ou le premier compte) sert de référence pour les écarts.'**
  String get compareIntro;

  /// No description provided for @compareCategories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get compareCategories;

  /// No description provided for @comparePeriods.
  ///
  /// In fr, this message translates to:
  /// **'Périodes'**
  String get comparePeriods;

  /// No description provided for @compareAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes'**
  String get compareAccounts;

  /// No description provided for @compareAddCategory.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une catégorie'**
  String get compareAddCategory;

  /// No description provided for @compareAddPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une période'**
  String get compareAddPeriod;

  /// No description provided for @compareAddPeriodHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un jour de la période à ajouter'**
  String get compareAddPeriodHelp;

  /// No description provided for @compareNothing.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez au moins une catégorie à comparer.'**
  String get compareNothing;

  /// No description provided for @compareOverTime.
  ///
  /// In fr, this message translates to:
  /// **'Évolution'**
  String get compareOverTime;

  /// No description provided for @compareColumnPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get compareColumnPeriod;

  /// No description provided for @compareTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get compareTotal;

  /// No description provided for @compareAverage.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne par période'**
  String get compareAverage;

  /// No description provided for @compareReference.
  ///
  /// In fr, this message translates to:
  /// **'{name} (référence)'**
  String compareReference(String name);

  /// No description provided for @compareByCategory.
  ///
  /// In fr, this message translates to:
  /// **'Par catégorie'**
  String get compareByCategory;

  /// No description provided for @compareGapHelp.
  ///
  /// In fr, this message translates to:
  /// **'Écarts par rapport à la référence, en euros et en pourcentage.'**
  String get compareGapHelp;

  /// No description provided for @compareSame.
  ///
  /// In fr, this message translates to:
  /// **'identique'**
  String get compareSame;

  /// No description provided for @sameProviderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Opérations passées au même libellé'**
  String get sameProviderTitle;

  /// No description provided for @sameProviderHistory.
  ///
  /// In fr, this message translates to:
  /// **'{count} opérations depuis le {since} · total {total} · moyenne {average}'**
  String sameProviderHistory(
    int count,
    String since,
    String total,
    String average,
  );

  /// No description provided for @sameProviderMore.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{et 1 plus ancienne} other{et {count} plus anciennes}}'**
  String sameProviderMore(int count);

  /// No description provided for @sectionProvider.
  ///
  /// In fr, this message translates to:
  /// **'Fournisseur'**
  String get sectionProvider;

  /// No description provided for @sectionClassification.
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get sectionClassification;

  /// No description provided for @sectionFollowUp.
  ///
  /// In fr, this message translates to:
  /// **'Suivi'**
  String get sectionFollowUp;

  /// No description provided for @sectionInvoices.
  ///
  /// In fr, this message translates to:
  /// **'Factures et tickets'**
  String get sectionInvoices;

  /// No description provided for @adminDisk.
  ///
  /// In fr, this message translates to:
  /// **'Disque du serveur'**
  String get adminDisk;

  /// No description provided for @adminDiskFree.
  ///
  /// In fr, this message translates to:
  /// **'{free} libres sur {total} ({percent} %)'**
  String adminDiskFree(String free, String total, int percent);

  /// No description provided for @adminDiskUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu (relevé toutes les 15 minutes par le serveur)'**
  String get adminDiskUnknown;

  /// No description provided for @adminDiskLow.
  ///
  /// In fr, this message translates to:
  /// **'Moins de 10 % libres : la base de données et les sauvegardes risquent d\'échouer. Libérez de la place sur le serveur (anciennes images Docker, journaux…).'**
  String get adminDiskLow;

  /// No description provided for @updateProgressTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour vers {version}'**
  String updateProgressTitle(String version);

  /// No description provided for @updateProgressHelp.
  ///
  /// In fr, this message translates to:
  /// **'Restez sur cette page : OwnCoffer va redémarrer et sera indisponible une à deux minutes. Vos données sont sauvegardées avant tout changement.'**
  String get updateProgressHelp;

  /// No description provided for @updateProgressRestarting.
  ///
  /// In fr, this message translates to:
  /// **'Redémarrage d\'OwnCoffer… (le serveur ne répond pas, c\'est normal)'**
  String get updateProgressRestarting;

  /// No description provided for @updateProgressDone.
  ///
  /// In fr, this message translates to:
  /// **'OwnCoffer {version} est installé. Rechargez la page pour utiliser la nouvelle version.'**
  String updateProgressDone(String version);

  /// No description provided for @updateProgressReload.
  ///
  /// In fr, this message translates to:
  /// **'Recharger la page'**
  String get updateProgressReload;

  /// No description provided for @updateProgressFailed.
  ///
  /// In fr, this message translates to:
  /// **'La mise à jour n\'a pas abouti : OwnCoffer est revenu à la version précédente, avec les données d\'avant la mise à jour. Le détail est dans l\'historique des mises à jour.'**
  String get updateProgressFailed;

  /// No description provided for @updateProgressWaiting.
  ///
  /// In fr, this message translates to:
  /// **'La nouvelle version n\'est pas encore prête au téléchargement (elle est publiée quelques minutes après son annonce). Le serveur réessaiera tout seul d\'ici 15 minutes.'**
  String get updateProgressWaiting;

  /// No description provided for @updateProgressSlow.
  ///
  /// In fr, this message translates to:
  /// **'Cela prend plus de temps que prévu. Vous pouvez quitter cette page : la mise à jour continue sur le serveur, et son résultat sera dans l\'historique.'**
  String get updateProgressSlow;

  /// No description provided for @updateProgressClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get updateProgressClose;

  /// No description provided for @updateStepRequested.
  ///
  /// In fr, this message translates to:
  /// **'Demande transmise au serveur'**
  String get updateStepRequested;

  /// No description provided for @updateStepPull.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargement de la nouvelle version'**
  String get updateStepPull;

  /// No description provided for @updateStepBackup.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde de vos données'**
  String get updateStepBackup;

  /// No description provided for @updateStepStart.
  ///
  /// In fr, this message translates to:
  /// **'Redémarrage d\'OwnCoffer'**
  String get updateStepStart;

  /// No description provided for @updateStepCheck.
  ///
  /// In fr, this message translates to:
  /// **'Vérification que tout répond'**
  String get updateStepCheck;

  /// No description provided for @updateStepRollback.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la version précédente…'**
  String get updateStepRollback;

  /// No description provided for @updateStepDone.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour terminée'**
  String get updateStepDone;

  /// No description provided for @menuAccount.
  ///
  /// In fr, this message translates to:
  /// **'Mon compte'**
  String get menuAccount;

  /// No description provided for @compareSimulation.
  ///
  /// In fr, this message translates to:
  /// **'Simulation'**
  String get compareSimulation;

  /// No description provided for @simIntro.
  ///
  /// In fr, this message translates to:
  /// **'Et si je changeais de contrat ? Comparez ce que coûte un abonnement gardé tel quel, et une autre offre, sur plusieurs années. C\'est une simulation : rien n\'est modifié.'**
  String get simIntro;

  /// No description provided for @simContract.
  ///
  /// In fr, this message translates to:
  /// **'Le contrat actuel'**
  String get simContract;

  /// No description provided for @simFrom.
  ///
  /// In fr, this message translates to:
  /// **'Partir de'**
  String get simFrom;

  /// No description provided for @simFreeAmount.
  ///
  /// In fr, this message translates to:
  /// **'Un montant libre'**
  String get simFreeAmount;

  /// No description provided for @simCurrentMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Prix actuel par mois'**
  String get simCurrentMonthly;

  /// No description provided for @simCurrentRise.
  ///
  /// In fr, this message translates to:
  /// **'Hausse par an du contrat actuel'**
  String get simCurrentRise;

  /// No description provided for @simRiseHelp.
  ///
  /// In fr, this message translates to:
  /// **'Facultatif : de combien le prix augmente chaque année (exemple : 3).'**
  String get simRiseHelp;

  /// No description provided for @simOffer.
  ///
  /// In fr, this message translates to:
  /// **'La nouvelle offre'**
  String get simOffer;

  /// No description provided for @simNewMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau prix par mois'**
  String get simNewMonthly;

  /// No description provided for @simSwitchCost.
  ///
  /// In fr, this message translates to:
  /// **'Coût du changement'**
  String get simSwitchCost;

  /// No description provided for @simSwitchCostHelp.
  ///
  /// In fr, this message translates to:
  /// **'Facultatif : frais de résiliation, d\'installation ou de dossier, payés une fois.'**
  String get simSwitchCostHelp;

  /// No description provided for @simNewRise.
  ///
  /// In fr, this message translates to:
  /// **'Hausse par an de la nouvelle offre'**
  String get simNewRise;

  /// No description provided for @simOver.
  ///
  /// In fr, this message translates to:
  /// **'Sur'**
  String get simOver;

  /// No description provided for @simYears.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 an} other{{count} ans}}'**
  String simYears(int count);

  /// No description provided for @simFillIn.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez le prix actuel et le nouveau prix pour voir la comparaison.'**
  String get simFillIn;

  /// No description provided for @simSaves.
  ///
  /// In fr, this message translates to:
  /// **'Vous économiseriez {amount} sur {period}.'**
  String simSaves(String amount, String period);

  /// No description provided for @simCostsMore.
  ///
  /// In fr, this message translates to:
  /// **'Ce changement coûterait {amount} de plus sur {period}.'**
  String simCostsMore(String amount, String period);

  /// No description provided for @simPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'par mois en moyenne'**
  String get simPerMonth;

  /// No description provided for @simPerYear.
  ///
  /// In fr, this message translates to:
  /// **'par an en moyenne'**
  String get simPerYear;

  /// No description provided for @simNeverPaysOff.
  ///
  /// In fr, this message translates to:
  /// **'Le changement n\'est jamais rentabilisé sur cette durée.'**
  String get simNeverPaysOff;

  /// No description provided for @simPaysOffNow.
  ///
  /// In fr, this message translates to:
  /// **'Rentable dès le premier mois.'**
  String get simPaysOffNow;

  /// No description provided for @simPaysOffAfter.
  ///
  /// In fr, this message translates to:
  /// **'Rentabilisé au bout de {months} mois.'**
  String simPaysOffAfter(int months);

  /// No description provided for @simMonthLabel.
  ///
  /// In fr, this message translates to:
  /// **'mois {month}'**
  String simMonthLabel(int month);

  /// No description provided for @simKeep.
  ///
  /// In fr, this message translates to:
  /// **'En gardant le contrat'**
  String get simKeep;

  /// No description provided for @simSwitch.
  ///
  /// In fr, this message translates to:
  /// **'En changeant'**
  String get simSwitch;

  /// No description provided for @simChart.
  ///
  /// In fr, this message translates to:
  /// **'Total payé, mois après mois'**
  String get simChart;

  /// No description provided for @simHow.
  ///
  /// In fr, this message translates to:
  /// **'Calcul : total payé chaque mois, coût du changement compté au départ, prix relevés chaque année de leur hausse, arrondis au centime.'**
  String get simHow;

  /// No description provided for @checkOne.
  ///
  /// In fr, this message translates to:
  /// **'Pointer'**
  String get checkOne;

  /// No description provided for @uncheckOne.
  ///
  /// In fr, this message translates to:
  /// **'Dépointer'**
  String get uncheckOne;

  /// No description provided for @checkedOne.
  ///
  /// In fr, this message translates to:
  /// **'Opération pointée.'**
  String get checkedOne;

  /// No description provided for @uncheckedOne.
  ///
  /// In fr, this message translates to:
  /// **'Opération dépointée.'**
  String get uncheckedOne;

  /// No description provided for @checkedMany.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 opération pointée.} other{{count} opérations pointées.}}'**
  String checkedMany(int count);

  /// No description provided for @uncheckedMany.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 opération dépointée.} other{{count} opérations dépointées.}}'**
  String uncheckedMany(int count);

  /// No description provided for @selectedCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 sélectionnée} other{{count} sélectionnées}}'**
  String selectedCount(int count);

  /// No description provided for @selectAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout sélectionner'**
  String get selectAll;

  /// No description provided for @checkSelected.
  ///
  /// In fr, this message translates to:
  /// **'Pointer'**
  String get checkSelected;

  /// No description provided for @uncheckSelected.
  ///
  /// In fr, this message translates to:
  /// **'Dépointer'**
  String get uncheckSelected;

  /// No description provided for @selectionStop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter la sélection'**
  String get selectionStop;

  /// No description provided for @operationsSelectHint.
  ///
  /// In fr, this message translates to:
  /// **'Touchez le rond d\'une opération pour la pointer ; appui long pour en sélectionner plusieurs.'**
  String get operationsSelectHint;

  /// No description provided for @error_too_many.
  ///
  /// In fr, this message translates to:
  /// **'Trop d\'opérations à la fois : 500 au plus.'**
  String get error_too_many;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @dashboardAdvisor.
  ///
  /// In fr, this message translates to:
  /// **'Mon conseiller : ce qu\'OwnCoffer vous propose'**
  String get dashboardAdvisor;

  /// No description provided for @dashboardBalance.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun compte en euros} =1{Sur votre compte} other{Sur vos {count} comptes}}'**
  String dashboardBalance(int count);

  /// No description provided for @dashboardLowest.
  ///
  /// In fr, this message translates to:
  /// **'Point bas des 30 prochains jours : {amount} sur {account}, le {date}'**
  String dashboardLowest(String account, String amount, String date);

  /// No description provided for @dashboardUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get dashboardUpcoming;

  /// No description provided for @dashboardUpcomingNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune échéance prévue d\'ici 7 jours.'**
  String get dashboardUpcomingNone;

  /// No description provided for @dashboardSeeForecast.
  ///
  /// In fr, this message translates to:
  /// **'Voir les prévisions'**
  String get dashboardSeeForecast;

  /// No description provided for @dashboardMonthSpending.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois-ci'**
  String get dashboardMonthSpending;

  /// No description provided for @dashboardMonthTotals.
  ///
  /// In fr, this message translates to:
  /// **'{expense} dépensés, {income} reçus'**
  String dashboardMonthTotals(String expense, String income);

  /// No description provided for @dashboardToClassify.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 opération à classer} other{{count} opérations à classer}}'**
  String dashboardToClassify(int count);

  /// No description provided for @dashboardSeeBudget.
  ///
  /// In fr, this message translates to:
  /// **'Voir le budget'**
  String get dashboardSeeBudget;

  /// No description provided for @dashboardWatch.
  ///
  /// In fr, this message translates to:
  /// **'À surveiller'**
  String get dashboardWatch;

  /// No description provided for @dashboardAllGood.
  ///
  /// In fr, this message translates to:
  /// **'Rien à signaler : aucun compte ne passe sous son seuil d\'alerte dans les 30 jours.'**
  String get dashboardAllGood;

  /// No description provided for @dashboardBelow.
  ///
  /// In fr, this message translates to:
  /// **'{account} passe sous son seuil d\'alerte le {date}'**
  String dashboardBelow(String account, String date);

  /// No description provided for @dashboardUnread.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 notification non lue} other{{count} notifications non lues}}'**
  String dashboardUnread(int count);

  /// No description provided for @advisorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon conseiller'**
  String get advisorTitle;

  /// No description provided for @advisorIntro.
  ///
  /// In fr, this message translates to:
  /// **'Ce qu\'OwnCoffer vous propose, d\'après les comptes que vous voyez. Chaque proposition montre ses chiffres et son calcul ; rien ne change tant que vous ne l\'acceptez pas, et tout changement accepté peut être annulé.'**
  String get advisorIntro;

  /// No description provided for @advisorNothing.
  ///
  /// In fr, this message translates to:
  /// **'Rien à proposer pour l\'instant'**
  String get advisorNothing;

  /// No description provided for @advisorNothingHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les propositions viennent de vos trois derniers mois complets : objectifs à fixer, à relever ou à baisser. Revenez après le prochain import.'**
  String get advisorNothingHelp;

  /// No description provided for @advisorPast.
  ///
  /// In fr, this message translates to:
  /// **'Décidées ces 30 derniers jours'**
  String get advisorPast;

  /// No description provided for @advisorSuggestGoal.
  ///
  /// In fr, this message translates to:
  /// **'Fixer un objectif « {category} » : {amount} par mois'**
  String advisorSuggestGoal(String category, String amount);

  /// No description provided for @advisorRaiseGoal.
  ///
  /// In fr, this message translates to:
  /// **'Relever l\'objectif « {category} » : {from} → {to}'**
  String advisorRaiseGoal(String category, String from, String to);

  /// No description provided for @advisorLowerGoal.
  ///
  /// In fr, this message translates to:
  /// **'Baisser l\'objectif « {category} » : {from} → {to}'**
  String advisorLowerGoal(String category, String from, String to);

  /// No description provided for @advisorOther.
  ///
  /// In fr, this message translates to:
  /// **'Proposition'**
  String get advisorOther;

  /// No description provided for @advisorGoalWhy.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses des trois derniers mois : {months}. Leur moyenne, arrondie à la dizaine d\'euros supérieure, donne {amount}.'**
  String advisorGoalWhy(String months, String amount);

  /// No description provided for @advisorSuggestWhy.
  ///
  /// In fr, this message translates to:
  /// **'Cette catégorie a des dépenses chaque mois et pas encore d\'objectif : un objectif réaliste vous préviendra à 80 % et à 100 %.'**
  String get advisorSuggestWhy;

  /// No description provided for @advisorRaiseWhy.
  ///
  /// In fr, this message translates to:
  /// **'L\'objectif a été dépassé au moins deux mois sur trois : un objectif réaliste reste utile au lieu d\'alerter tous les mois.'**
  String get advisorRaiseWhy;

  /// No description provided for @advisorLowerWhy.
  ///
  /// In fr, this message translates to:
  /// **'Les dépenses sont restées sous la moitié de l\'objectif trois mois de suite : un objectif plus serré garde la marge que vous avez prise.'**
  String get advisorLowerWhy;

  /// No description provided for @advisorByEngine.
  ///
  /// In fr, this message translates to:
  /// **'Calculé par OwnCoffer, sans IA.'**
  String get advisorByEngine;

  /// No description provided for @advisorByAi.
  ///
  /// In fr, this message translates to:
  /// **'Proposé par l\'IA ({provider}, {model}) : vérifiez avant d\'accepter.'**
  String advisorByAi(String provider, String model);

  /// No description provided for @advisorAiCategory.
  ///
  /// In fr, this message translates to:
  /// **'Classer « {label} » dans « {category} »'**
  String advisorAiCategory(String label, String category);

  /// No description provided for @advisorAiCategoryWhy.
  ///
  /// In fr, this message translates to:
  /// **'Opération du {date}, {amount}. {why}'**
  String advisorAiCategoryWhy(String date, String amount, String why);

  /// No description provided for @advisorAiLoan.
  ///
  /// In fr, this message translates to:
  /// **'Créer le crédit « {lender} » : {principal} sur {months} mois'**
  String advisorAiLoan(String lender, String principal, int months);

  /// No description provided for @advisorAiLoanWhy.
  ///
  /// In fr, this message translates to:
  /// **'Lu dans le document : taux {rate}, mensualité {payment}, première échéance le {date}. Vous pourrez tout corriger ensuite dans l\'onglet Crédits.'**
  String advisorAiLoanWhy(String rate, String payment, String date);

  /// No description provided for @advisorAiRule.
  ///
  /// In fr, this message translates to:
  /// **'Créer la règle : libellé {match} « {pattern} » → « {category} »'**
  String advisorAiRule(String match, String pattern, String category);

  /// No description provided for @advisorAiRuleWhy.
  ///
  /// In fr, this message translates to:
  /// **'Repérée sur « {label} ». {count, plural, =0{Aucune opération déjà importée n\'est concernée} =1{1 opération déjà importée sera classée} other{{count} opérations déjà importées seront classées}} (compté par OwnCoffer, sans toucher à vos choix faits à la main), puis les suivantes à chaque import. {why}'**
  String advisorAiRuleWhy(int count, String label, String why);

  /// No description provided for @advisorAiRuleUndo.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez annuler : la règle sera supprimée et ses opérations classées à nouveau sans elle.'**
  String get advisorAiRuleUndo;

  /// No description provided for @advisorAccept.
  ///
  /// In fr, this message translates to:
  /// **'Accepter'**
  String get advisorAccept;

  /// No description provided for @advisorRefuse.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get advisorRefuse;

  /// No description provided for @advisorAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Proposition appliquée.'**
  String get advisorAccepted;

  /// No description provided for @advisorRefused.
  ///
  /// In fr, this message translates to:
  /// **'Proposition refusée.'**
  String get advisorRefused;

  /// No description provided for @advisorUndone.
  ///
  /// In fr, this message translates to:
  /// **'Changement annulé.'**
  String get advisorUndone;

  /// No description provided for @advisorReaderHelp.
  ///
  /// In fr, this message translates to:
  /// **'En lecture seule : un membre peut accepter cette proposition.'**
  String get advisorReaderHelp;

  /// No description provided for @advisorStatusExecuted.
  ///
  /// In fr, this message translates to:
  /// **'Appliquée'**
  String get advisorStatusExecuted;

  /// No description provided for @advisorStatusRefused.
  ///
  /// In fr, this message translates to:
  /// **'Refusée'**
  String get advisorStatusRefused;

  /// No description provided for @advisorStatusExpired.
  ///
  /// In fr, this message translates to:
  /// **'Retirée : les données ont changé'**
  String get advisorStatusExpired;

  /// No description provided for @advisorStatusUndone.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get advisorStatusUndone;

  /// No description provided for @error_proposal_stale.
  ///
  /// In fr, this message translates to:
  /// **'Les données ont changé depuis cette proposition : elle a été retirée, sans rien modifier.'**
  String get error_proposal_stale;

  /// No description provided for @error_proposal_closed.
  ///
  /// In fr, this message translates to:
  /// **'Cette proposition a déjà été traitée.'**
  String get error_proposal_closed;

  /// No description provided for @error_proposal_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Cette proposition n\'existe pas ou n\'est pas à vous.'**
  String get error_proposal_access_denied;

  /// No description provided for @error_proposal_unknown.
  ///
  /// In fr, this message translates to:
  /// **'Cette proposition ne peut pas être appliquée : elle est incomplète.'**
  String get error_proposal_unknown;

  /// No description provided for @adminTabAi.
  ///
  /// In fr, this message translates to:
  /// **'IA'**
  String get adminTabAi;

  /// No description provided for @adminAiIntro.
  ///
  /// In fr, this message translates to:
  /// **'Les fournisseurs d\'IA que les utilisateurs peuvent choisir. L\'IA reste désactivée pour chacun tant qu\'il ne l\'active pas. Elle ne lit que les comptes que l\'utilisateur voit, par les fonctions du moteur, et ne fait que proposer : rien ne change sans validation.'**
  String get adminAiIntro;

  /// No description provided for @adminAiAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un fournisseur'**
  String get adminAiAdd;

  /// No description provided for @adminAiEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le fournisseur'**
  String get adminAiEdit;

  /// No description provided for @adminAiNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun fournisseur : l\'IA n\'est pas disponible sur ce serveur.'**
  String get adminAiNone;

  /// No description provided for @adminAiKeySet.
  ///
  /// In fr, this message translates to:
  /// **'clé enregistrée'**
  String get adminAiKeySet;

  /// No description provided for @adminAiDisabled.
  ///
  /// In fr, this message translates to:
  /// **'désactivé'**
  String get adminAiDisabled;

  /// No description provided for @adminAiCapValue.
  ///
  /// In fr, this message translates to:
  /// **'{count} demandes par mois et par utilisateur'**
  String adminAiCapValue(int count);

  /// No description provided for @adminAiTest.
  ///
  /// In fr, this message translates to:
  /// **'Tester la connexion'**
  String get adminAiTest;

  /// No description provided for @adminAiTestOk.
  ///
  /// In fr, this message translates to:
  /// **'Connexion réussie : {count} modèles ({models})'**
  String adminAiTestOk(int count, String models);

  /// No description provided for @adminAiDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get adminAiDelete;

  /// No description provided for @adminAiDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer « {name} » ?'**
  String adminAiDeleteTitle(String name);

  /// No description provided for @adminAiDeleteHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les utilisateurs qui l\'avaient choisi n\'auront plus d\'IA tant qu\'ils n\'en choisissent pas un autre.'**
  String get adminAiDeleteHelp;

  /// No description provided for @adminAiLocal.
  ///
  /// In fr, this message translates to:
  /// **'Local (Ollama)'**
  String get adminAiLocal;

  /// No description provided for @adminAiExternal.
  ///
  /// In fr, this message translates to:
  /// **'Externe (compatible OpenAI)'**
  String get adminAiExternal;

  /// No description provided for @adminAiLocalHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un modèle qui tourne sur ce serveur ou votre réseau : les données ne sortent pas de chez vous. Adresse du type http://192.168.1.10:11434/v1.'**
  String get adminAiLocalHelp;

  /// No description provided for @adminAiExternalHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un fournisseur en ligne (Mistral, OpenAI, OpenRouter…) : les questions et les chiffres utiles lui sont envoyés, ce que l\'application dit à l\'utilisateur.'**
  String get adminAiExternalHelp;

  /// No description provided for @adminAiName.
  ///
  /// In fr, this message translates to:
  /// **'Nom affiché'**
  String get adminAiName;

  /// No description provided for @adminAiUrl.
  ///
  /// In fr, this message translates to:
  /// **'Adresse de l\'API'**
  String get adminAiUrl;

  /// No description provided for @adminAiKey.
  ///
  /// In fr, this message translates to:
  /// **'Clé d\'API'**
  String get adminAiKey;

  /// No description provided for @adminAiKeyHelp.
  ///
  /// In fr, this message translates to:
  /// **'Facultative pour Ollama. Chiffrée sur le serveur, jamais réaffichée.'**
  String get adminAiKeyHelp;

  /// No description provided for @adminAiKeyKeep.
  ///
  /// In fr, this message translates to:
  /// **'Une clé est enregistrée : laisser vide pour la garder.'**
  String get adminAiKeyKeep;

  /// No description provided for @adminAiModels.
  ///
  /// In fr, this message translates to:
  /// **'Modèles proposés'**
  String get adminAiModels;

  /// No description provided for @adminAiModelsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Séparés par des virgules, par exemple : llama3.1, mistral-small'**
  String get adminAiModelsHelp;

  /// No description provided for @adminAiCap.
  ///
  /// In fr, this message translates to:
  /// **'Plafond mensuel par utilisateur'**
  String get adminAiCap;

  /// No description provided for @adminAiCapHelp.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de demandes ; 0 pour aucun plafond.'**
  String get adminAiCapHelp;

  /// No description provided for @adminAiTools.
  ///
  /// In fr, this message translates to:
  /// **'Appel des fonctions du moteur'**
  String get adminAiTools;

  /// No description provided for @adminAiToolsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le modèle sait appeler des fonctions : il lit vos chiffres et fait des propositions.'**
  String get adminAiToolsHelp;

  /// No description provided for @adminAiVision.
  ///
  /// In fr, this message translates to:
  /// **'Lecture d\'images'**
  String get adminAiVision;

  /// No description provided for @adminAiVisionHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le modèle lit des images (tableau d\'amortissement, ticket…).'**
  String get adminAiVisionHelp;

  /// No description provided for @adminAiEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Proposé aux utilisateurs'**
  String get adminAiEnabled;

  /// No description provided for @assistantTitle.
  ///
  /// In fr, this message translates to:
  /// **'Assistant'**
  String get assistantTitle;

  /// No description provided for @assistantNotSetUp.
  ///
  /// In fr, this message translates to:
  /// **'L\'IA n\'est pas configurée'**
  String get assistantNotSetUp;

  /// No description provided for @assistantSetUpAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez un fournisseur dans Administration > IA (un modèle local avec Ollama, ou un fournisseur en ligne).'**
  String get assistantSetUpAdmin;

  /// No description provided for @assistantSetUpAsk.
  ///
  /// In fr, this message translates to:
  /// **'L\'administrateur du serveur peut ajouter un fournisseur d\'IA. OwnCoffer fonctionne entièrement sans.'**
  String get assistantSetUpAsk;

  /// No description provided for @assistantChoice.
  ///
  /// In fr, this message translates to:
  /// **'Votre IA'**
  String get assistantChoice;

  /// No description provided for @assistantIntro.
  ///
  /// In fr, this message translates to:
  /// **'L\'assistant lit vos chiffres par les fonctions d\'OwnCoffer (comptes que vous voyez seulement), explique, et peut proposer des changements : catégories, crédit lu dans un document. Rien ne change tant que vous n\'acceptez pas dans Mon conseiller.'**
  String get assistantIntro;

  /// No description provided for @assistantProvider.
  ///
  /// In fr, this message translates to:
  /// **'Fournisseur'**
  String get assistantProvider;

  /// No description provided for @assistantModel.
  ///
  /// In fr, this message translates to:
  /// **'Modèle'**
  String get assistantModel;

  /// No description provided for @assistantLocal.
  ///
  /// In fr, this message translates to:
  /// **'local'**
  String get assistantLocal;

  /// No description provided for @assistantExternal.
  ///
  /// In fr, this message translates to:
  /// **'externe'**
  String get assistantExternal;

  /// No description provided for @assistantEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Activer l\'assistant'**
  String get assistantEnabled;

  /// No description provided for @assistantUsage.
  ///
  /// In fr, this message translates to:
  /// **'{count} demandes ce mois-ci'**
  String assistantUsage(int count);

  /// No description provided for @assistantUsageCap.
  ///
  /// In fr, this message translates to:
  /// **'{count} demandes sur {cap} ce mois-ci'**
  String assistantUsageCap(int count, int cap);

  /// No description provided for @assistantExternalWarning.
  ///
  /// In fr, this message translates to:
  /// **'Fournisseur externe : votre question, la conversation, les images jointes et les résultats des fonctions appelées (opérations, montants, catégories) sont envoyés à {provider}.'**
  String assistantExternalWarning(String provider);

  /// No description provided for @assistantImageSent.
  ///
  /// In fr, this message translates to:
  /// **'Image jointe'**
  String get assistantImageSent;

  /// No description provided for @assistantThinking.
  ///
  /// In fr, this message translates to:
  /// **'Réflexion…'**
  String get assistantThinking;

  /// No description provided for @assistantNoAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Pas de réponse du modèle.'**
  String get assistantNoAnswer;

  /// No description provided for @assistantUsedTools.
  ///
  /// In fr, this message translates to:
  /// **'A consulté : {tools}'**
  String assistantUsedTools(String tools);

  /// No description provided for @assistantSentTo.
  ///
  /// In fr, this message translates to:
  /// **'Envoyé à {provider} ({model}).'**
  String assistantSentTo(String provider, String model);

  /// No description provided for @assistantProposals.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 proposition à valider} other{{count} propositions à valider}}'**
  String assistantProposals(int count);

  /// No description provided for @assistantAttach.
  ///
  /// In fr, this message translates to:
  /// **'Joindre une image (tableau d\'amortissement, ticket…)'**
  String get assistantAttach;

  /// No description provided for @assistantImageReady.
  ///
  /// In fr, this message translates to:
  /// **'Image prête : {name}'**
  String assistantImageReady(String name);

  /// No description provided for @assistantHint.
  ///
  /// In fr, this message translates to:
  /// **'Posez une question, ou « classe mes opérations »…'**
  String get assistantHint;

  /// No description provided for @assistantClassifyChip.
  ///
  /// In fr, this message translates to:
  /// **'Classer les opérations à classer'**
  String get assistantClassifyChip;

  /// No description provided for @assistantClassifyPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Propose une catégorie pour mes opérations à classer, et une règle quand le même commerçant reviendra.'**
  String get assistantClassifyPrompt;

  /// No description provided for @assistantSend.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get assistantSend;

  /// No description provided for @error_ai_off.
  ///
  /// In fr, this message translates to:
  /// **'L\'assistant est désactivé : activez-le et choisissez un modèle.'**
  String get error_ai_off;

  /// No description provided for @error_ai_provider_unavailable.
  ///
  /// In fr, this message translates to:
  /// **'Ce fournisseur ou ce modèle n\'est pas disponible.'**
  String get error_ai_provider_unavailable;

  /// No description provided for @error_ai_cap_reached.
  ///
  /// In fr, this message translates to:
  /// **'Plafond mensuel de demandes atteint.'**
  String get error_ai_cap_reached;

  /// No description provided for @error_ai_unavailable.
  ///
  /// In fr, this message translates to:
  /// **'Le fournisseur d\'IA ne répond pas. Aucun autre n\'a été utilisé à sa place.'**
  String get error_ai_unavailable;

  /// No description provided for @error_ai_no_vision.
  ///
  /// In fr, this message translates to:
  /// **'Ce modèle ne lit pas les images.'**
  String get error_ai_no_vision;

  /// No description provided for @error_ai_message_too_long.
  ///
  /// In fr, this message translates to:
  /// **'Message trop long (4 000 caractères au plus).'**
  String get error_ai_message_too_long;

  /// No description provided for @error_ai_invalid_url.
  ///
  /// In fr, this message translates to:
  /// **'Adresse invalide : http:// ou https://, sans identifiant dedans.'**
  String get error_ai_invalid_url;

  /// No description provided for @error_ai_invalid_kind.
  ///
  /// In fr, this message translates to:
  /// **'Type de fournisseur inconnu.'**
  String get error_ai_invalid_kind;

  /// No description provided for @mcpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Depuis un autre assistant (MCP)'**
  String get mcpTitle;

  /// No description provided for @mcpIntro.
  ///
  /// In fr, this message translates to:
  /// **'Un assistant que vous utilisez déjà (Claude Desktop ou tout client MCP) peut lire vos chiffres et faire des propositions, avec les mêmes fonctions et les mêmes limites que l\'assistant intégré : les comptes que vous voyez, rien ne change sans votre accord. Les données qu\'il lit partent vers le modèle de cet assistant.'**
  String get mcpIntro;

  /// No description provided for @mcpCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer un jeton'**
  String get mcpCreate;

  /// No description provided for @mcpCreateHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le jeton donne accès à ce foyer, avec vos droits. Vous pourrez le révoquer à tout moment.'**
  String get mcpCreateHelp;

  /// No description provided for @mcpName.
  ///
  /// In fr, this message translates to:
  /// **'Nom (pour le reconnaître)'**
  String get mcpName;

  /// No description provided for @mcpCreated.
  ///
  /// In fr, this message translates to:
  /// **'Jeton créé'**
  String get mcpCreated;

  /// No description provided for @mcpCreatedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Copiez-le maintenant : il ne sera plus affiché. Dans votre assistant, ajoutez un serveur MCP « HTTP » avec cette adresse et l\'en-tête Authorization: Bearer suivi du jeton.'**
  String get mcpCreatedHelp;

  /// No description provided for @mcpAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get mcpAddress;

  /// No description provided for @mcpSecret.
  ///
  /// In fr, this message translates to:
  /// **'Jeton'**
  String get mcpSecret;

  /// No description provided for @mcpCopy.
  ///
  /// In fr, this message translates to:
  /// **'Copier le jeton'**
  String get mcpCopy;

  /// No description provided for @mcpDone.
  ///
  /// In fr, this message translates to:
  /// **'C\'est noté'**
  String get mcpDone;

  /// No description provided for @mcpNeverUsed.
  ///
  /// In fr, this message translates to:
  /// **'{prefix} · jamais utilisé'**
  String mcpNeverUsed(String prefix);

  /// No description provided for @mcpLastUsed.
  ///
  /// In fr, this message translates to:
  /// **'{prefix} · utilisé le {date}'**
  String mcpLastUsed(String prefix, String date);

  /// No description provided for @mcpRevoke.
  ///
  /// In fr, this message translates to:
  /// **'Révoquer'**
  String get mcpRevoke;

  /// No description provided for @error_mcp_token_access_denied.
  ///
  /// In fr, this message translates to:
  /// **'Ce jeton n\'existe pas ou n\'est pas à vous.'**
  String get error_mcp_token_access_denied;

  /// No description provided for @demoBanner.
  ///
  /// In fr, this message translates to:
  /// **'Démonstration : toutes les données sont fictives.'**
  String get demoBanner;

  /// No description provided for @adminDemoFill.
  ///
  /// In fr, this message translates to:
  /// **'Remplir avec le foyer de démonstration'**
  String get adminDemoFill;

  /// No description provided for @adminDemoHelp.
  ///
  /// In fr, this message translates to:
  /// **'Instance de démonstration : remplit le foyer actuel (vide) avec trois comptes, douze mois d\'opérations fictives, des abonnements, des objectifs et un crédit.'**
  String get adminDemoHelp;

  /// No description provided for @adminDemoDone.
  ///
  /// In fr, this message translates to:
  /// **'Foyer de démonstration rempli.'**
  String get adminDemoDone;

  /// No description provided for @error_demo_only.
  ///
  /// In fr, this message translates to:
  /// **'Possible seulement sur une instance de démonstration.'**
  String get error_demo_only;

  /// No description provided for @error_demo_group_not_empty.
  ///
  /// In fr, this message translates to:
  /// **'Le foyer doit être vide (aucun compte) pour y charger la démonstration.'**
  String get error_demo_group_not_empty;
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
