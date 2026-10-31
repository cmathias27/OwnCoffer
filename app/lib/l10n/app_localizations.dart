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
  /// **'Revenus et dépenses des six dernières périodes'**
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

  /// No description provided for @adminUptimeValue.
  ///
  /// In fr, this message translates to:
  /// **'{days} j {hours} h'**
  String adminUptimeValue(int days, int hours);

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
  /// **'Documents stockés'**
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
