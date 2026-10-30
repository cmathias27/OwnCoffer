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
