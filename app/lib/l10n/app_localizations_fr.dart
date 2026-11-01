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
  String get helpTitle => 'Aide';

  @override
  String get helpButton => 'Aide sur cette page';

  @override
  String get helpAll => 'Toute l\'aide';

  @override
  String get helpIntro =>
      'Une page par écran. Le bouton ? en haut de chaque page ouvre directement la sienne.';

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
      'Vous ne faites encore partie d\'aucun groupe. Si vous administrez ce serveur, créez votre foyer ci-dessous ; sinon, demandez une invitation à son administrateur.';

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

  @override
  String get error_invalid_amount =>
      'Montant invalide : il doit être positif et raisonnable.';

  @override
  String get error_import_file_too_large =>
      'Fichier trop volumineux (4 Mo au maximum).';

  @override
  String get error_import_nothing_readable =>
      'Aucune opération lisible dans ce fichier.';

  @override
  String get error_import_access_denied =>
      'Cet import n\'existe pas ou vous n\'y avez pas accès.';

  @override
  String get error_scheduled_access_denied =>
      'Cette opération prévue n\'existe pas ou vous n\'y avez pas accès.';

  @override
  String get error_invalid_interval =>
      'La périodicité doit être comprise entre 1 et 120.';

  @override
  String get error_invalid_tolerance =>
      'Tolérance invalide (0 à 31 jours, 0 à 100 %).';

  @override
  String get error_invalid_recurrence =>
      'La date de fin est avant la date de début.';

  @override
  String get error_invalid_date => 'Date invalide.';

  @override
  String get error_invalid_horizon =>
      'La durée de prévision doit être comprise entre 1 et 366 jours.';

  @override
  String get error_transaction_access_denied =>
      'Cette opération n\'existe pas ou vous n\'y avez pas accès.';

  @override
  String get error_imported_operation_locked =>
      'La date, le montant et le libellé d\'une opération importée ne se modifient pas : ce sont ceux de la banque.';

  @override
  String get error_already_imported_again =>
      'Cette opération a été réimportée entre-temps : elle est déjà dans le compte.';

  @override
  String get error_notification_access_denied =>
      'Cette notification n\'existe pas.';

  @override
  String get navAccounts => 'Comptes';

  @override
  String get navOperations => 'Opérations';

  @override
  String get navImport => 'Importer';

  @override
  String get navForecast => 'Prévisions';

  @override
  String get navCategories => 'Catégories';

  @override
  String get accountsTitle => 'Comptes';

  @override
  String get accountsEmpty => 'Aucun compte pour l\'instant.';

  @override
  String get accountAdd => 'Ajouter un compte';

  @override
  String get accountEdit => 'Modifier le compte';

  @override
  String get accountName => 'Nom du compte';

  @override
  String get accountBank => 'Banque';

  @override
  String get accountKind => 'Type';

  @override
  String get kindChecking => 'Compte courant';

  @override
  String get kindSavings => 'Épargne';

  @override
  String get kindDeferredCard => 'Carte à débit différé';

  @override
  String get kindCash => 'Espèces';

  @override
  String get initialBalance => 'Solde initial';

  @override
  String get initialBalanceHelp =>
      'Solde du compte avant la première opération importée.';

  @override
  String get alertThreshold => 'Seuil d\'alerte';

  @override
  String get alertThresholdHelp =>
      'Alerte quand le solde prévu passe en dessous. 0 = tout découvert ; -500 = découvert autorisé de 500.';

  @override
  String get visibilityRestricted =>
      'Compte restreint (visible seulement par les administrateurs et les personnes autorisées)';

  @override
  String get balanceCurrent => 'Solde actuel';

  @override
  String get balanceCleared => 'Solde pointé';

  @override
  String forecastLowest(String amount, String date) {
    return 'Point bas à 30 jours : $amount le $date';
  }

  @override
  String overdraftExpected(String date) {
    return 'Découvert prévu le $date';
  }

  @override
  String get amountInvalid => 'Montant illisible. Exemple : -12,50';

  @override
  String get operationsTitle => 'Opérations';

  @override
  String get operationsEmpty => 'Aucune opération.';

  @override
  String get searchHint => 'Rechercher un libellé';

  @override
  String get filterToClassify => 'À classer';

  @override
  String get filterUncleared => 'Non pointées';

  @override
  String get loadMore => 'Afficher plus';

  @override
  String operationsCount(int count) {
    return '$count opérations';
  }

  @override
  String get toClassify => 'À classer';

  @override
  String get operationAdd => 'Saisir une opération';

  @override
  String get dateLabel => 'Date';

  @override
  String get amountLabel => 'Montant';

  @override
  String get amountHelp => 'Négatif pour une dépense : -12,50';

  @override
  String get labelLabel => 'Libellé';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get noCategory => 'À classer';

  @override
  String get categorySearchHint => 'Rechercher une catégorie';

  @override
  String get categorySearchEmpty => 'Aucune catégorie ne correspond.';

  @override
  String categoryCreateNamed(String name) {
    return 'Créer la catégorie « $name »';
  }

  @override
  String get cleared => 'Pointée';

  @override
  String get bankLabel => 'Libellé de la banque';

  @override
  String get alwaysClassify => 'Toujours classer ainsi';

  @override
  String ruleCreated(int count) {
    return 'Règle créée : $count autres opérations reclassées.';
  }

  @override
  String get trash => 'Mettre à la corbeille';

  @override
  String get trashed => 'Opération mise à la corbeille.';

  @override
  String get undo => 'Annuler';

  @override
  String get sourceManual => 'choisie par vous';

  @override
  String get sourceGroupRule => 'règle du groupe';

  @override
  String get sourceCommunityRule => 'règle communautaire';

  @override
  String get sourceHistory => 'historique';

  @override
  String get sourceAi => 'IA';

  @override
  String get chooseAccount => 'Compte';

  @override
  String clearedBalanceValue(String amount) {
    return 'Solde pointé : $amount';
  }

  @override
  String bankLabelValue(String label) {
    return 'Libellé de la banque : $label';
  }

  @override
  String dateValue(String date) {
    return 'Date : $date';
  }

  @override
  String get webSearch => 'Rechercher ce libellé sur Google';

  @override
  String get webSearchHelp =>
      'Ouvre Google dans un nouvel onglet avec le libellé nettoyé (pas le libellé complet de la banque).';

  @override
  String get noteLabel => 'Votre note';

  @override
  String get importTitle => 'Importer un relevé';

  @override
  String get importChooseFile => 'Choisir un fichier';

  @override
  String get importOtherFile => 'Choisir un autre fichier';

  @override
  String get importFormats =>
      'QIF, OFX ou CSV, 4 Mo au maximum. Le fichier n\'est envoyé qu\'à votre serveur OwnCoffer.';

  @override
  String get importReaderOnly =>
      'Avec le rôle Lecteur, vous ne pouvez pas importer.';

  @override
  String get importNoAccount =>
      'Créez d\'abord un compte dans l\'onglet Comptes.';

  @override
  String importFileInfo(String name, String format, String encoding) {
    return '$name : format $format, encodage $encoding';
  }

  @override
  String importCountRead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations lues',
      one: '1 opération lue',
      zero: 'Aucune opération lue',
    );
    return '$_temp0';
  }

  @override
  String importCountNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouvelles',
      one: '1 nouvelle',
    );
    return '$_temp0';
  }

  @override
  String importCountDuplicate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count déjà présentes',
      one: '1 déjà présente',
    );
    return '$_temp0';
  }

  @override
  String importCountPossible(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doublons possibles',
      one: '1 doublon possible',
    );
    return '$_temp0';
  }

  @override
  String importCountClassified(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classées',
      one: '1 classée',
    );
    return '$_temp0';
  }

  @override
  String importCountErrors(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erreurs',
      one: '1 erreur',
    );
    return '$_temp0';
  }

  @override
  String get importSameFile => 'Ce fichier a déjà été importé dans ce compte.';

  @override
  String importBankBalance(String date, String amount) {
    return 'Solde indiqué par la banque le $date : $amount';
  }

  @override
  String get importBalanceMatches =>
      'Après l\'import, OwnCoffer aura le même solde à cette date.';

  @override
  String importBalanceDiffers(String amount, String gap) {
    return 'Après l\'import, OwnCoffer affichera $amount à cette date, soit un écart de $gap. Vérifiez le solde initial du compte ou s\'il manque des opérations plus anciennes.';
  }

  @override
  String get importIssues => 'Remarques sur le fichier';

  @override
  String get importStatusNew => 'Nouvelle';

  @override
  String get importStatusDuplicate => 'Déjà présente';

  @override
  String get importStatusPossible => 'Doublon possible';

  @override
  String get importPossibleHelp =>
      'Un doublon possible a la même date et le même montant qu\'une opération déjà présente, avec un libellé différent. Cochez ceux à importer quand même.';

  @override
  String importConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importer $count opérations',
      one: 'Importer 1 opération',
      zero: 'Rien à importer',
    );
    return '$_temp0';
  }

  @override
  String importDone(int added, int classified) {
    String _temp0 = intl.Intl.pluralLogic(
      added,
      locale: localeName,
      other: '$added opérations ajoutées, dont $classified classées.',
      one: '1 opération ajoutée, $classified classée.',
      zero: 'Aucune opération ajoutée.',
    );
    return '$_temp0';
  }

  @override
  String get importHistory => 'Imports précédents';

  @override
  String get importHistoryEmpty => 'Aucun import pour ce compte.';

  @override
  String importHistoryLine(String date, int added, int duplicates) {
    return '$date · $added ajoutées, $duplicates déjà présentes';
  }

  @override
  String get importCancelled => 'Annulé';

  @override
  String get importCancel => 'Annuler cet import';

  @override
  String importCancelConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Les $count opérations ajoutées par cet import seront mises à la corbeille.',
      one: 'L\'opération ajoutée par cet import sera mise à la corbeille.',
    );
    return '$_temp0 Vos corrections sur ces opérations seront perdues.';
  }

  @override
  String get importCancelDone => 'Import annulé.';

  @override
  String get csvTitle => 'Colonnes du fichier CSV';

  @override
  String get csvHelp =>
      'OwnCoffer ne reconnaît pas l\'en-tête de ce fichier. Indiquez ce que contient chaque colonne.';

  @override
  String get csvChangeColumns => 'Modifier les colonnes';

  @override
  String get csvDelimiter => 'Séparateur';

  @override
  String get csvTab => 'Tabulation';

  @override
  String get csvHeaderRow => 'Ligne d\'en-tête';

  @override
  String get csvNoHeader => 'Aucune';

  @override
  String get csvDate => 'Date';

  @override
  String get csvLabel => 'Libellé';

  @override
  String get csvMemo => 'Détail (facultatif)';

  @override
  String get csvAmountMode => 'Montants';

  @override
  String get csvOneColumn => 'Une colonne signée';

  @override
  String get csvDebitCredit => 'Débit et crédit séparés';

  @override
  String get csvAmount => 'Montant';

  @override
  String get csvDebit => 'Débit';

  @override
  String get csvCredit => 'Crédit';

  @override
  String get csvNone => 'Aucune';

  @override
  String csvColumn(int number, String sample) {
    return 'Colonne $number : $sample';
  }

  @override
  String get csvMonthFirst => 'Dates au format mois/jour/année (américain)';

  @override
  String get csvIncomplete =>
      'Choisissez au moins la date, le libellé et un montant.';

  @override
  String get validate => 'Valider';

  @override
  String csvRowSample(int number, String sample) {
    return 'Ligne $number : $sample';
  }

  @override
  String get forecastTitle => 'Solde prévu';

  @override
  String get forecastUnavailable => 'Prévision indisponible pour l\'instant.';

  @override
  String horizonDays(int count) {
    return '$count j';
  }

  @override
  String get horizonYear => '1 an';

  @override
  String forecastCurrent(String amount) {
    return 'Solde actuel : $amount';
  }

  @override
  String forecastEnd(String date, String amount) {
    return 'Le $date : $amount';
  }

  @override
  String forecastThresholdLine(String amount) {
    return 'Seuil d\'alerte : $amount';
  }

  @override
  String get forecastChartLabel => 'Courbe du solde prévu jour par jour';

  @override
  String get forecastLowestMark => 'Point bas';

  @override
  String get forecastProposals => 'À confirmer';

  @override
  String forecastProposalText(
    String operation,
    String date,
    String planned,
    String due,
  ) {
    return '$operation du $date réalise-t-elle « $planned » prévue le $due ?';
  }

  @override
  String get confirm => 'Confirmer';

  @override
  String get forecastMatched => 'Rapprochement confirmé.';

  @override
  String get forecastMissed => 'Non arrivées';

  @override
  String forecastMissedText(String date) {
    return 'Prévue le $date, toujours pas sur le compte.';
  }

  @override
  String get forecastSkip => 'Ne plus l\'attendre';

  @override
  String get forecastSkipped => 'Échéance ignorée.';

  @override
  String forecastAutoReconciled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count opérations reliées automatiquement à leur échéance prévue.',
      one: '1 opération reliée automatiquement à son échéance prévue.',
    );
    return '$_temp0';
  }

  @override
  String get forecastUpcoming => 'À venir';

  @override
  String get forecastNoUpcoming => 'Aucune opération prévue sur cette période.';

  @override
  String forecastLate(String date) {
    return 'en retard, prévue le $date';
  }

  @override
  String forecastBalanceAfter(String amount) {
    return 'solde : $amount';
  }

  @override
  String get scheduledTitle => 'Opérations prévues';

  @override
  String get scheduledEmpty =>
      'Aucune opération prévue. Ajoutez votre loyer, votre salaire, vos abonnements…';

  @override
  String get scheduledAdd => 'Ajouter une opération prévue';

  @override
  String get scheduledEdit => 'Modifier l\'opération prévue';

  @override
  String get scheduledDelete => 'Supprimer';

  @override
  String scheduledDeleteConfirm(String label) {
    return 'Supprimer « $label » ? Les prévisions ne la compteront plus.';
  }

  @override
  String get frequencyLabel => 'Fréquence';

  @override
  String get frequencyOnce => 'Une fois';

  @override
  String get frequencyWeekly => 'Toutes les semaines';

  @override
  String get frequencyMonthly => 'Tous les mois';

  @override
  String get frequencyYearly => 'Tous les ans';

  @override
  String everyWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Toutes les $count semaines',
      one: 'Chaque semaine',
    );
    return '$_temp0';
  }

  @override
  String everyMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tous les $count mois',
      one: 'Chaque mois',
    );
    return '$_temp0';
  }

  @override
  String everyYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tous les $count ans',
      one: 'Chaque année',
    );
    return '$_temp0';
  }

  @override
  String get intervalLabel => 'Intervalle';

  @override
  String get intervalHelp => '2 = toutes les deux semaines, deux mois…';

  @override
  String get startDateLabel => 'Première échéance';

  @override
  String get endDateLabel => 'Dernière échéance (facultatif)';

  @override
  String get noEndDate => 'Sans fin';

  @override
  String onceOn(String date) {
    return 'Le $date';
  }

  @override
  String fromDate(String date) {
    return 'à partir du $date';
  }

  @override
  String untilDate(String date) {
    return 'jusqu\'au $date';
  }

  @override
  String get matchPatternLabel => 'Libellé bancaire à reconnaître (facultatif)';

  @override
  String get matchPatternHelp =>
      'Ex. : LOYER. Sert à relier l\'opération réelle à l\'échéance prévue.';

  @override
  String get dateToleranceLabel => 'Tolérance de date (jours)';

  @override
  String get amountToleranceLabel => 'Tolérance de montant (%)';

  @override
  String get toleranceInvalid => 'Nombre entier attendu.';

  @override
  String get scheduledLockedHelp =>
      'La fréquence et la première échéance ne se modifient pas : supprimez et recréez l\'opération prévue.';

  @override
  String get categoriesTab => 'Catégories';

  @override
  String get rulesTab => 'Règles';

  @override
  String get categoryAdd => 'Ajouter une catégorie';

  @override
  String get categoryEdit => 'Modifier la catégorie';

  @override
  String get categoryName => 'Nom';

  @override
  String get categoryParent => 'Catégorie parente';

  @override
  String get categoryNoParent => 'Aucune (catégorie principale)';

  @override
  String get categoryKindLabel => 'Type';

  @override
  String get kindIncome => 'Revenu';

  @override
  String get kindExpense => 'Dépense';

  @override
  String get kindTransfer => 'Virement interne';

  @override
  String categoryStandardName(String name) {
    return 'Nom standard : $name';
  }

  @override
  String get categoryResetName => 'Revenir au nom standard';

  @override
  String get categoryStandardHelp =>
      'Reliée au catalogue standard : les règles communautaires continuent de la remplir, même renommée.';

  @override
  String get categoryArchive => 'Archiver';

  @override
  String categoryArchiveConfirm(String name) {
    return 'Archiver « $name » ? Elle ne sera plus proposée ; les opérations déjà classées la gardent.';
  }

  @override
  String get ruleAdd => 'Ajouter une règle';

  @override
  String get ruleEdit => 'Modifier la règle';

  @override
  String get rulesEmpty =>
      'Aucune règle du groupe. Créez-en une ici ou avec « Toujours classer ainsi » sur une opération.';

  @override
  String get rulePattern => 'Texte recherché dans le libellé';

  @override
  String get ruleMatchType => 'Correspondance';

  @override
  String get matchContains => 'contient';

  @override
  String get matchStartsWith => 'commence par';

  @override
  String get matchEquals => 'est exactement';

  @override
  String get ruleDirection => 'Sens';

  @override
  String get directionAny => 'Débit ou crédit';

  @override
  String get directionDebit => 'Débit seulement';

  @override
  String get directionCredit => 'Crédit seulement';

  @override
  String get ruleMinAmount => 'Montant minimum (facultatif)';

  @override
  String get ruleMaxAmount => 'Montant maximum (facultatif)';

  @override
  String get rulePriority => 'Priorité';

  @override
  String get rulePriorityHelp => 'La plus petite passe en premier.';

  @override
  String get ruleEnabled => 'Active';

  @override
  String get ruleDelete => 'Supprimer';

  @override
  String ruleSummary(String match, String pattern, String category) {
    return 'Libellé $match « $pattern » → $category';
  }

  @override
  String ruleAmounts(String min, String max) {
    return 'entre $min et $max';
  }

  @override
  String ruleAmountFrom(String min) {
    return 'à partir de $min';
  }

  @override
  String ruleAmountUpTo(String max) {
    return 'jusqu\'à $max';
  }

  @override
  String get testerTitle => 'Tester un libellé';

  @override
  String get testerHelp =>
      'Collez un libellé de votre relevé : OwnCoffer montre comment il le nettoie et le classe, sans rien enregistrer.';

  @override
  String get testerRun => 'Tester';

  @override
  String testerCleaned(String label) {
    return 'Libellé court : $label';
  }

  @override
  String testerResult(String category, String source) {
    return 'Catégorie : $category ($source)';
  }

  @override
  String get testerNone =>
      'Aucune règle ne s\'applique : l\'opération serait « À classer ».';

  @override
  String get testerRuleOpen => 'Voir la règle';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'Aucune notification.';

  @override
  String get notificationsMarkAll => 'Tout marquer comme lu';

  @override
  String notificationsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notifications : $count non lues',
      one: 'Notifications : 1 non lue',
      zero: 'Notifications',
    );
    return '$_temp0';
  }

  @override
  String notifOverdraftTitle(String account, String date) {
    return '$account : découvert prévu le $date';
  }

  @override
  String notifOverdraftBody(String balance, String threshold) {
    return 'Solde prévu ce jour-là au moment de l\'alerte : $balance (seuil $threshold).';
  }

  @override
  String get notifUnknown => 'Notification';

  @override
  String get notifOpenForecast => 'Voir les prévisions';

  @override
  String get importAccountRecognised => 'Compte reconnu d\'après le fichier.';

  @override
  String importOtherAccountMatch(String account) {
    return 'Ce fichier correspond au compte « $account ».';
  }

  @override
  String importSwitchAccount(String account) {
    return 'Importer dans « $account »';
  }

  @override
  String importWrongBankAccount(String account) {
    return 'Ce fichier vient d\'un autre compte bancaire que « $account ». Vérifiez le compte choisi.';
  }

  @override
  String get groupCreateTitle => 'Créer votre foyer';

  @override
  String get navBudget => 'Budget';

  @override
  String get navLoans => 'Crédits';

  @override
  String get navMore => 'Plus';

  @override
  String get allAccounts => 'Tous les comptes';

  @override
  String get moreActions => 'Plus d\'actions';

  @override
  String get optional => 'Facultatif';

  @override
  String get fieldRequired => 'Champ obligatoire.';

  @override
  String get filterCategory => 'Catégorie';

  @override
  String get periodWeek => 'Semaine';

  @override
  String get periodMonth => 'Mois';

  @override
  String get periodYear => 'Année';

  @override
  String get periodPrevious => 'Période précédente';

  @override
  String get periodNext => 'Période suivante';

  @override
  String get budgetIncome => 'Revenus';

  @override
  String get budgetExpenses => 'Dépenses';

  @override
  String get budgetSavings => 'Épargne';

  @override
  String get budgetNet => 'Reste';

  @override
  String budgetDeltaPrevious(String percent) {
    return '$percent % par rapport à la période précédente';
  }

  @override
  String get budgetHistoryTitle => 'Revenus et dépenses';

  @override
  String get budgetHistorySemantic =>
      'Revenus et dépenses des dernières périodes';

  @override
  String get rankingExpenses => 'Classement des dépenses';

  @override
  String get rankingIncome => 'Classement des revenus';

  @override
  String get rankingEmpty => 'Rien sur cette période.';

  @override
  String rankingShare(int percent) {
    return '$percent % du total';
  }

  @override
  String rankingPrevious(String amount) {
    return 'avant : $amount';
  }

  @override
  String rankingAverage(String amount) {
    return 'moyenne : $amount';
  }

  @override
  String get rankingOperations => 'Voir les opérations';

  @override
  String get goalAdd => 'Objectif';

  @override
  String get goalSet => 'Fixer un objectif';

  @override
  String get goalEdit => 'Modifier l\'objectif';

  @override
  String get goalRemove => 'Supprimer l\'objectif';

  @override
  String goalTitle(String category) {
    return 'Objectif : $category';
  }

  @override
  String get goalHelp =>
      'Montant maximum à dépenser chaque mois dans cette catégorie, sous-catégories comprises.';

  @override
  String get goalAmountLabel => 'Montant par mois';

  @override
  String goalSuggestion(String amount, String average) {
    return 'Suggestion : $amount (moyenne des 3 mois précédents : $average)';
  }

  @override
  String get goalOk => 'Dans l\'objectif';

  @override
  String get goalWarning => 'Bientôt atteint';

  @override
  String get goalOver => 'Dépassé';

  @override
  String goalProgress(int percent, String goal) {
    return '$percent % de $goal';
  }

  @override
  String goalLeft(String amount) {
    return 'reste $amount';
  }

  @override
  String goalExceeded(String amount) {
    return '$amount de trop';
  }

  @override
  String goalProjection(String amount) {
    return 'À ce rythme : $amount en fin de mois';
  }

  @override
  String goalProjectionOver(String amount, String date) {
    return 'À ce rythme : $amount de trop, dépassement vers le $date';
  }

  @override
  String get monthStartTitle => 'Début du mois';

  @override
  String get monthStartHelp =>
      'Le jour où commence votre mois de budget, par exemple le jour de la paie. Le budget, le classement des dépenses et les objectifs l\'utilisent pour tout le foyer.';

  @override
  String get monthStartLabel => 'Le mois commence';

  @override
  String get monthStartFirst => 'Le 1er (mois du calendrier)';

  @override
  String monthStartDay(int day) {
    return 'Le $day';
  }

  @override
  String get subscriptionsTitle => 'Abonnements';

  @override
  String get subscriptionsMonthly => 'Par mois';

  @override
  String get subscriptionsYearly => 'Par an';

  @override
  String get subscriptionsHelp =>
      'Les opérations prévues marquées comme abonnements, sur les comptes que vous voyez. Les montants annuels et hebdomadaires sont ramenés au mois.';

  @override
  String get subscriptionsEmpty =>
      'Aucun abonnement. Dans la fiche d\'une opération, « C\'est un abonnement » l\'ajoute ici.';

  @override
  String subscriptionNext(String date) {
    return 'prochain : $date';
  }

  @override
  String subscriptionPerMonth(String amount) {
    return '$amount / mois';
  }

  @override
  String get subscriptionUnmark => 'Ne plus compter comme abonnement';

  @override
  String get subscriptionUnmarkHelp =>
      'Reste une opération prévue dans les prévisions.';

  @override
  String get subscriptionStop => 'Abonnement résilié';

  @override
  String get subscriptionStopHelp =>
      'Supprime l\'opération prévue : elle ne compte plus dans les prévisions.';

  @override
  String get subscriptionSwitch => 'Abonnement';

  @override
  String get subscriptionSwitchHelp =>
      'Apparaît dans la liste des abonnements.';

  @override
  String get subscriptionFromOperation => 'C\'est un abonnement';

  @override
  String get subscriptionMarkPlanned => 'Marquer comme abonnement';

  @override
  String get filterSubscriptions => 'Abonnements';

  @override
  String get subscriptionsOpen => 'Liste des abonnements';

  @override
  String get subscriptionBadge => 'Abonnement';

  @override
  String subscriptionOfOperation(String label) {
    return 'Abonnement « $label »';
  }

  @override
  String subscriptionCreated(String label, String date) {
    return 'Abonnement « $label » ajouté, prochain prélèvement le $date.';
  }

  @override
  String get loansRemaining => 'Reste à rembourser';

  @override
  String get loansMonthly => 'Mensualités';

  @override
  String get loansDebtRatio => 'Taux d\'endettement';

  @override
  String get loansDebtRatioUnknown =>
      'Pas de revenus classés sur les 3 derniers mois.';

  @override
  String get loansDebtRatioOk => 'Sous les 35 % conseillés';

  @override
  String get loansDebtRatioHigh => 'Au-dessus des 35 % conseillés';

  @override
  String loansDebtRatioBasis(String amount) {
    return 'revenus moyens : $amount / mois';
  }

  @override
  String get loansEmpty =>
      'Aucun crédit. Ajoutez-en un pour suivre ce qu\'il reste à rembourser.';

  @override
  String get loansDisclaimer =>
      'Calculs indicatifs à taux fixe et mensualités constantes : en cas d\'écart, le tableau d\'amortissement de la banque fait foi.';

  @override
  String get loanAdd => 'Ajouter un crédit';

  @override
  String get loanEdit => 'Modifier le crédit';

  @override
  String get loanDelete => 'Supprimer le crédit';

  @override
  String get loanDeleteConfirm =>
      'Supprimer ce crédit ? Ses échéances prévues sont retirées des prévisions.';

  @override
  String get loanKind => 'Type de crédit';

  @override
  String get loanKindMortgage => 'Immobilier';

  @override
  String get loanKindCar => 'Auto';

  @override
  String get loanKindConsumer => 'Consommation';

  @override
  String get loanKindStudent => 'Étudiant';

  @override
  String get loanKindPersonal => 'Prêt entre particuliers';

  @override
  String get loanKindOther => 'Autre';

  @override
  String get loanLender => 'Organisme';

  @override
  String get loanLabel => 'Nom';

  @override
  String get loanLabelHint => 'Maison, voiture…';

  @override
  String get loanPrincipal => 'Capital emprunté';

  @override
  String get loanRate => 'Taux nominal';

  @override
  String get loanRateHelp => 'Par an, par exemple 3,45';

  @override
  String get loanRateInvalid =>
      'Taux entre 0 et 50 %, trois décimales au plus.';

  @override
  String get loanApr => 'TAEG';

  @override
  String get loanDuration => 'Durée';

  @override
  String get loanDurationMonths => 'Durée en mois';

  @override
  String get loanDurationHelp => '240 mois = 20 ans';

  @override
  String get loanDurationInvalid => 'Entre 1 et 600 mois.';

  @override
  String loanMonths(int count) {
    return '$count mois';
  }

  @override
  String get loanFirstDue => 'Date de la première échéance';

  @override
  String get loanInsurance => 'Assurance par mois';

  @override
  String get loanInsuranceMonthly => 'Assurance par mois';

  @override
  String get loanFees => 'Frais de dossier';

  @override
  String get loanAccount => 'Compte de prélèvement';

  @override
  String get loanAccountHelp =>
      'Les échéances deviennent des opérations prévues sur ce compte : elles comptent dans le solde prévu et sont rapprochées des prélèvements réels.';

  @override
  String get loanNoAccount => 'Aucun';

  @override
  String get loanPayment => 'Mensualité (hors assurance)';

  @override
  String loanPreview(String payment, String total) {
    return 'Mensualité : $payment hors assurance, $total avec.';
  }

  @override
  String get loanPreviewEmpty =>
      'Saisissez le capital, le taux et la durée pour voir la mensualité.';

  @override
  String get loanRemainingShort => 'restant dû';

  @override
  String loanRepaid(int percent) {
    return '$percent % remboursé';
  }

  @override
  String loanInstallments(int paid, int total) {
    return '$paid / $total échéances';
  }

  @override
  String loanNext(String date, String amount) {
    return 'prochaine le $date : $amount';
  }

  @override
  String get loanFinished => 'remboursé';

  @override
  String loanEnd(String date) {
    return 'fin le $date';
  }

  @override
  String get loanInterestPaid => 'Intérêts déjà payés';

  @override
  String get loanInterestLeft => 'Intérêts restant à payer';

  @override
  String get loanCost => 'Coût total (intérêts, assurance, frais)';

  @override
  String get loanSimulationTitle => 'Remboursement anticipé';

  @override
  String get loanSimulationHelp =>
      'Si je rembourse ce montant maintenant, en gardant la même mensualité.';

  @override
  String get loanSimulationAmount => 'Montant';

  @override
  String get loanSimulate => 'Simuler';

  @override
  String get loanSimulationSaved => 'Intérêts économisés';

  @override
  String get loanSimulationEnd => 'Nouvelle date de fin';

  @override
  String get loanSimulationRepaid => 'Crédit soldé';

  @override
  String get loanSimulationLeft => 'Échéances restantes';

  @override
  String get loanScheduleTitle => 'Tableau d\'amortissement';

  @override
  String loanYearSummary(String principal, String interest, String remaining) {
    return 'Capital $principal · intérêts $interest · restant dû $remaining';
  }

  @override
  String get loanColNumber => 'N°';

  @override
  String get loanColDate => 'Date';

  @override
  String get loanColPayment => 'Mensualité';

  @override
  String get loanColPrincipal => 'Capital';

  @override
  String get loanColInterest => 'Intérêts';

  @override
  String get loanColInsurance => 'Assurance';

  @override
  String get loanColRemaining => 'Restant dû';

  @override
  String get error_goal_expense_only =>
      'Un objectif se fixe sur une catégorie de dépenses.';

  @override
  String get error_loan_access_denied =>
      'Ce crédit n\'existe pas ou vous n\'y avez pas accès.';

  @override
  String get error_loan_terms_invalid =>
      'Conditions du crédit impossibles : vérifiez le capital, le taux et la durée.';

  @override
  String get error_invalid_month_start_day =>
      'Le mois doit commencer entre le 1er et le 28.';

  @override
  String get loanFromOperation => 'C\'est une échéance de crédit';

  @override
  String get loanFromOperationTitle => 'Déclarer le crédit';

  @override
  String loanFromOperationIntro(String label) {
    return 'Les prochains prélèvements « $label » seront reconnus comme les échéances de ce crédit et classés automatiquement.';
  }

  @override
  String loanObservedInstalment(String amount) {
    return 'Prélèvement constaté : $amount (assurance comprise)';
  }

  @override
  String get loanDeducePrincipal =>
      'Calculer le capital à partir de ce prélèvement';

  @override
  String get loanDeduceNeedsTerms => 'Indiquez d\'abord le taux et la durée.';

  @override
  String loanInstalmentMismatch(String amount) {
    return 'La mensualité calculée ($amount) s\'écarte de plus de 5 % du prélèvement : vérifiez le capital, le taux, la durée et l\'assurance.';
  }

  @override
  String get loanFirstDueFromOperationHelp =>
      'Date de la toute première échéance. Si vous ne la connaissez pas, gardez celle de ce prélèvement et indiquez la durée restante : le capital calculé sera alors le capital restant dû.';

  @override
  String get loanCategoryDefaultHelp =>
      'Sans choix, la catégorie du type de crédit est utilisée (par exemple Crédit immobilier).';

  @override
  String loanFromOperationDone(int linked, int others) {
    return 'Crédit créé : $linked échéances rattachées, $others autres opérations classées.';
  }

  @override
  String get error_loan_needs_debit =>
      'Un crédit se déclare depuis un prélèvement.';

  @override
  String get sameProvider => 'Autres paiements de ce prestataire';

  @override
  String sameProviderFilter(String label) {
    return 'Prestataire : $label';
  }

  @override
  String sameProviderSummary(int count, String total, String average) {
    return '$count opérations · total $total · moyenne $average';
  }

  @override
  String get undoDone => 'Action annulée.';

  @override
  String get categoryChanged => 'Catégorie modifiée.';

  @override
  String get clearedChanged => 'Pointage modifié.';

  @override
  String get goalSaved => 'Objectif enregistré.';

  @override
  String get goalRemoved => 'Objectif supprimé.';

  @override
  String get splitTitle => 'Ventiler l\'opération';

  @override
  String get splitAction => 'Ventiler entre plusieurs catégories';

  @override
  String get splitAddPart => 'Ajouter une part';

  @override
  String splitRemaining(String amount) {
    return 'Reste à répartir : $amount';
  }

  @override
  String get splitBalanced => 'Le total correspond au montant de l\'opération.';

  @override
  String get splitRemove => 'Ne plus ventiler';

  @override
  String get splitSaved => 'Opération ventilée.';

  @override
  String splitPartLabel(int number) {
    return 'Part $number';
  }

  @override
  String splitPartsSummary(int count) {
    return 'Ventilée en $count parts';
  }

  @override
  String get splitNoteLabel => 'Précision';

  @override
  String get splitRemovePart => 'Retirer cette part';

  @override
  String get leftToLiveTitle => 'Reste à vivre';

  @override
  String leftToLiveBody(String perDay, int days, String date) {
    return 'soit $perDay par jour pendant $days jours, jusqu\'au $date';
  }

  @override
  String leftToLiveDetail(String balance, String debits, String credits) {
    return 'Solde $balance · prélèvements prévus $debits · rentrées prévues $credits';
  }

  @override
  String get leftToLiveHelp =>
      'Comptes courants seulement, opérations prévues comprises, jusqu\'à la fin du mois de budget (veille de la prochaine paie).';

  @override
  String get calendarTitle => 'Calendrier des échéances';

  @override
  String get calendarEmpty => 'Aucune échéance prévue sur cette période.';

  @override
  String calendarUpcoming(String debits, String credits) {
    return 'Encore à venir : $debits de prélèvements, $credits de rentrées';
  }

  @override
  String get statusPaid => 'Passé';

  @override
  String get statusLate => 'En retard';

  @override
  String get statusSkipped => 'Sauté';

  @override
  String get statusUpcoming => 'À venir';

  @override
  String statusPaidOther(String amount) {
    return 'Passé : $amount';
  }

  @override
  String get calendarLoan => 'Crédit';

  @override
  String get calendarSubscription => 'Abonnement';

  @override
  String get reviewTitle => 'Revue du mois';

  @override
  String reviewNet(String net, String previous) {
    return 'Reste du mois : $net (mois précédent : $previous)';
  }

  @override
  String get reviewRises => 'En hausse';

  @override
  String get reviewDrops => 'En baisse';

  @override
  String reviewChange(String amount, String average) {
    return '$amount au lieu de $average en moyenne';
  }

  @override
  String get reviewGoalsOver => 'Objectifs dépassés';

  @override
  String reviewGoalOver(String amount, String goal) {
    return '$amount pour un objectif de $goal';
  }

  @override
  String get reviewFees => 'Frais bancaires';

  @override
  String reviewFeesTotal(String amount) {
    return '$amount de frais bancaires ce mois-ci';
  }

  @override
  String get reviewNoFees => 'Aucun frais bancaire ce mois-ci.';

  @override
  String get reviewBiggest => 'Plus grosses dépenses';

  @override
  String get reviewSubscriptions => 'Abonnements';

  @override
  String reviewSubscriptionChange(String label, String actual, String planned) {
    return '$label : $actual au lieu de $planned';
  }

  @override
  String reviewNewSubscription(String label, String amount) {
    return 'Nouvel abonnement : $label ($amount)';
  }

  @override
  String reviewUnclassified(int count) {
    return '$count opérations restent à classer sur ce mois.';
  }

  @override
  String get reviewNothing => 'Rien de notable.';

  @override
  String get balanceCheckAction => 'Contrôler le solde';

  @override
  String get balanceCheckHelp =>
      'Saisissez le solde affiché par votre banque en fin de journée à une date : OwnCoffer le compare avec le solde calculé à partir des opérations.';

  @override
  String get balanceCheckDate => 'Date du solde';

  @override
  String get balanceCheckAmount => 'Solde affiché par la banque';

  @override
  String get balanceCheckOk => 'Le solde correspond.';

  @override
  String balanceCheckGap(String amount, String computed) {
    return 'Écart de $amount : le solde calculé est de $computed.';
  }

  @override
  String balanceCheckUncleared(String amount) {
    return 'Dont $amount d\'opérations saisies à la main et non pointées, peut-être pas encore passées à la banque.';
  }

  @override
  String balanceCheckLastImport(String date) {
    return 'Dernière opération importée : $date. Un relevé manque peut-être.';
  }

  @override
  String get balanceCheckHistory => 'Derniers contrôles';

  @override
  String balanceCheckRow(String date, String bank, String gap) {
    return '$date : banque $bank, écart $gap';
  }

  @override
  String notifGoalWarningTitle(String category) {
    return 'Objectif « $category » bientôt atteint';
  }

  @override
  String notifGoalOverTitle(String category) {
    return 'Objectif « $category » dépassé';
  }

  @override
  String notifGoalBody(String spent, String goal) {
    return '$spent dépensés pour un objectif de $goal ce mois-ci.';
  }

  @override
  String notifGoalForecastTitle(String category, String date) {
    return 'Objectif « $category » : dépassement prévu vers le $date';
  }

  @override
  String notifGoalForecastBody(String spent, String goal, String projected) {
    return '$spent dépensés pour un objectif de $goal ; à ce rythme, $projected en fin de mois.';
  }

  @override
  String get loanKindInstallments => 'Paiement en plusieurs fois';

  @override
  String get loanInstallmentsCount => 'Nombre d\'échéances';

  @override
  String get loanInstallmentsTotal => 'Montant total de l\'achat';

  @override
  String get loanInstallmentsHelp =>
      'Paiement en 3 ou 4 fois (Alma, Oney, carte bancaire…), généralement sans frais : le taux reste à 0 %.';

  @override
  String get loanSectionInstallments => 'Paiements en plusieurs fois';

  @override
  String get error_split_invalid =>
      'La ventilation doit compter au moins deux parts du même signe que l\'opération, dont le total est égal à son montant.';

  @override
  String get goalsTitle => 'Objectifs du mois';

  @override
  String get goalsEmpty =>
      'Aucun objectif. Fixez un plafond mensuel sur une catégorie de dépenses pour voir où vous en êtes au fil du mois.';

  @override
  String goalsSummary(int ok, int warning, int over) {
    return '$ok dans l\'objectif · $warning bientôt atteint · $over dépassé';
  }

  @override
  String get goalPaceHelp =>
      'Le trait vertical marque où vous devriez en être aujourd\'hui pour tenir l\'objectif jusqu\'à la fin du mois.';

  @override
  String goalSpentOf(String spent, String goal) {
    return '$spent sur $goal';
  }

  @override
  String rankingShowAll(int count) {
    return 'Voir les $count catégories';
  }

  @override
  String get rankingShowLess => 'Réduire';

  @override
  String rankingTotal(String amount) {
    return 'Total : $amount';
  }

  @override
  String rankingVsAverage(String percent, String amount) {
    return '$percent % par rapport à la moyenne ($amount)';
  }

  @override
  String get budgetBalanceTitle => 'Bilan de la période';

  @override
  String budgetOverspent(String amount) {
    return 'Vous avez dépensé $amount de plus que vos revenus';
  }

  @override
  String budgetLeftOver(String amount) {
    return 'Il vous reste $amount';
  }

  @override
  String budgetBarsSemantic(String income, String out) {
    return 'Revenus $income, dépenses et épargne $out';
  }

  @override
  String get budgetExpensesAndSavings => 'Dépenses et épargne';

  @override
  String get budgetSavingsPart => 'dont épargne';

  @override
  String budgetVsPrevious(String delta) {
    return '$delta par rapport à la période précédente';
  }

  @override
  String unclassifiedBanner(int count, String amount) {
    return '$count opérations à classer ($amount)';
  }

  @override
  String get unclassifiedBannerHelp =>
      'Elles comptent dans les totaux mais pas dans les classements ni les objectifs.';

  @override
  String get classifyNow => 'Classer';

  @override
  String get loanAttachTitle => 'Échéance de quel crédit ?';

  @override
  String get loanAttachHelp =>
      'Choisissez un crédit déjà saisi : ce prélèvement y sera rattaché et les suivants seront classés automatiquement.';

  @override
  String get loanAttachNew => 'Déclarer un nouveau crédit';

  @override
  String loanAttachDone(int linked, int others) {
    return 'Prélèvement rattaché au crédit : $linked échéances rattachées, $others autres opérations classées.';
  }

  @override
  String get error_loan_other_account =>
      'Ce crédit est prélevé sur un autre compte.';

  @override
  String get loanOperationsTitle => 'Opérations du crédit';

  @override
  String loanOperationsSummary(int count, String total) {
    return '$count prélèvements · $total payés';
  }

  @override
  String get loanOperationsEmpty =>
      'Aucun prélèvement rattaché pour l\'instant. Depuis la fiche d\'un prélèvement, « C\'est une échéance de crédit » le rattache à ce crédit.';

  @override
  String loanOperationsMore(int count) {
    return 'Voir les $count prélèvements';
  }

  @override
  String get loanActualPayment => 'Mensualité prélevée (assurance comprise)';

  @override
  String get loanActualPaymentHelp =>
      'Le montant réellement prélevé chaque mois : c\'est la seule valeur certaine. Le capital restant, les intérêts et la date de fin en sont déduits.';

  @override
  String loanActualPreview(String amount, int months) {
    return 'Avec $amount prélevés par mois, le crédit serait remboursé en $months mois.';
  }

  @override
  String get loanPaymentActual => 'Mensualité (prélevée)';

  @override
  String get loanPaymentComputed => 'Mensualité (calculée)';

  @override
  String get loanEstimatedDuration => 'Durée estimée';

  @override
  String get loanEstimatesNote =>
      'La mensualité prélevée est la seule valeur certaine : le capital restant, les intérêts et la date de fin sont des estimations calculées à partir d\'elle. Le tableau d\'amortissement de votre banque fait foi.';

  @override
  String get loanEstimatesNoteComputed =>
      'Mensualité calculée à partir du capital, du taux et de la durée : indiquez la mensualité prélevée pour des estimations plus justes. Le tableau d\'amortissement de votre banque fait foi.';

  @override
  String get loanDocumentsTitle => 'Documents du crédit';

  @override
  String get loanDocumentsHelp =>
      'Tableau d\'amortissement, offre de prêt, captures d\'écran… Ils restent sur votre serveur (PDF, image, CSV, tableur ; 10 Mo au plus).';

  @override
  String get loanDocumentsEmpty => 'Aucun document.';

  @override
  String get loanDocumentAdd => 'Ajouter un document';

  @override
  String get loanDocumentAdded => 'Document ajouté.';

  @override
  String get loanDocumentDelete => 'Supprimer le document';

  @override
  String loanDocumentDeleteConfirm(String name) {
    return 'Supprimer « $name » du serveur ? Cette action est définitive.';
  }

  @override
  String loanDocumentInfo(String size, String date) {
    return '$size · ajouté le $date';
  }

  @override
  String get error_document_too_large =>
      'Le document est vide ou dépasse 10 Mo.';

  @override
  String get error_document_type =>
      'Type de document non accepté : PDF, image (PNG, JPEG, WebP), CSV, texte ou tableur (XLSX, ODS).';

  @override
  String get error_document_limit =>
      'Ce crédit a déjà 30 documents : supprimez-en avant d\'en ajouter.';

  @override
  String sizeMb(String value) {
    return '$value Mo';
  }

  @override
  String sizeKb(String value) {
    return '$value ko';
  }

  @override
  String get variableToggle => 'Dépenses variables';

  @override
  String get variableToggleHelp =>
      'Compter les courses, le carburant, les sorties… estimés d\'après les mois précédents';

  @override
  String variableIncluded(String amount) {
    return 'Dont $amount de dépenses variables estimées';
  }

  @override
  String variableMonthly(String amount) {
    return 'Habituellement $amount par mois · voir le calcul';
  }

  @override
  String variableHow(String months) {
    return 'D\'après $months : pour chaque catégorie, la médiane des mois (un mois exceptionnel ne compte pas). Les opérations prévues, les virements entre vos comptes et les revenus ne sont pas comptés.';
  }

  @override
  String variableThisMonth(String spent, String left) {
    return 'Ce mois-ci : $spent déjà dépensés, $left encore attendus, répartis jour par jour.';
  }

  @override
  String get variableNoHistory =>
      'Dépenses variables : pas encore assez d\'historique (il faut au moins un mois complet d\'opérations).';

  @override
  String get variableNone =>
      'Dépenses variables : aucune sur les derniers mois.';

  @override
  String get purchaseTitle => 'Simuler un achat';

  @override
  String purchaseHelp(String account) {
    return 'Sur le compte « $account » : le solde à la date choisie, le point bas et le risque de découvert, selon la façon de payer. Rien n\'est enregistré tant que vous ne choisissez pas.';
  }

  @override
  String get purchaseAmount => 'Montant de l\'achat';

  @override
  String get purchaseAmountInvalid =>
      'Montant positif, par exemple 600 ou 599,90';

  @override
  String get purchaseLabel => 'Libellé';

  @override
  String get purchaseDefaultLabel => 'Achat';

  @override
  String purchaseDate(String date) {
    return 'Achat le $date';
  }

  @override
  String purchaseTarget(String date) {
    return 'Solde au $date';
  }

  @override
  String get purchaseCategoryHelp =>
      'Facultatif : prévient si l\'objectif du mois serait dépassé';

  @override
  String get purchaseSimulate => 'Comparer';

  @override
  String get purchaseNone => 'Sans l\'achat';

  @override
  String get purchaseNoneHelp => 'Pour comparer';

  @override
  String get purchaseCash => 'Comptant';

  @override
  String purchaseTimes(int count) {
    return 'En $count fois';
  }

  @override
  String get purchaseNextMonth => 'Le mois suivant';

  @override
  String purchaseBalanceOn(String date) {
    return 'Solde au $date';
  }

  @override
  String purchaseLowest(String amount, String date) {
    return 'Point bas : $amount le $date';
  }

  @override
  String purchaseGoal(String spent, String goal) {
    return 'Objectif de la catégorie : $spent dépensés sur $goal ce mois-ci.';
  }

  @override
  String purchaseGoalOver(String amount) {
    return 'Objectif du mois dépassé de $amount';
  }

  @override
  String get purchaseChoose => 'Choisir et enregistrer';

  @override
  String get purchaseSaved => 'Achat enregistré dans les opérations prévues.';

  @override
  String get purchaseHowVariable =>
      'Calculé par le moteur de prévision : opérations prévues et dépenses variables estimées. En plusieurs fois : mensualités arrondies au centime supérieur, la dernière ajuste ; sans frais.';

  @override
  String get purchaseHowPlanned =>
      'Calculé par le moteur de prévision : opérations prévues seulement. En plusieurs fois : mensualités arrondies au centime supérieur, la dernière ajuste ; sans frais.';

  @override
  String get adminTitle => 'Administration du serveur';

  @override
  String get adminRefresh => 'Actualiser';

  @override
  String get adminTabHealth => 'Santé et chiffres';

  @override
  String get adminTabUsers => 'Utilisateurs';

  @override
  String get adminTabSecurity => 'IP bloquées';

  @override
  String get adminTabAudit => 'Journal';

  @override
  String get adminHealth => 'État du serveur';

  @override
  String get adminVersion => 'Version installée';

  @override
  String get adminUptime => 'En marche depuis';

  @override
  String adminUptimeDays(int days, int hours) {
    return '$days j $hours h';
  }

  @override
  String adminUptimeHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String adminUptimeMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get adminDatabase => 'Base de données';

  @override
  String get adminUnreachable => 'injoignable';

  @override
  String get adminOk => 'OK';

  @override
  String get adminFailed => 'en échec';

  @override
  String get adminNotYet => 'pas encore';

  @override
  String get adminDocuments => 'Documents et factures stockés';

  @override
  String get adminAlertsJob => 'Dernière vérification des alertes';

  @override
  String get adminClock => 'Horloge du serveur';

  @override
  String adminClockDrift(int seconds) {
    return 'écart de $seconds s avec cet appareil';
  }

  @override
  String get adminEmail => 'Envoi des courriels';

  @override
  String get adminEmailSmtp => 'serveur SMTP configuré';

  @override
  String get adminEmailLog =>
      'non configuré : écrits dans le journal du serveur';

  @override
  String get adminTestEmail => 'Envoyer un courriel de test';

  @override
  String adminTestEmailSent(String email) {
    return 'Courriel de test envoyé à $email.';
  }

  @override
  String get adminTestEmailLogged =>
      'SMTP non configuré : le courriel de test est écrit dans le journal du serveur.';

  @override
  String get adminPublicUrl => 'Adresse publique';

  @override
  String get adminStats => 'Chiffres du serveur (aucun montant)';

  @override
  String get adminStatUsers => 'Comptes utilisateurs';

  @override
  String adminStatUsersValue(int count, int twoFactor, int blocked) {
    return '$count · double authentification : $twoFactor · bloqués : $blocked';
  }

  @override
  String get adminStatGroups => 'Groupes (foyers)';

  @override
  String get adminStatAccounts => 'Comptes bancaires';

  @override
  String get adminStatOperations => 'Opérations';

  @override
  String adminStatOperationsValue(int count, int recent) {
    return '$count · $recent ajoutées en 30 jours';
  }

  @override
  String get adminStatImports => 'Imports en 30 jours';

  @override
  String get adminStatRules => 'Règles des groupes';

  @override
  String get adminStatInvitations => 'Invitations en attente';

  @override
  String get adminStatAuto => 'Classement automatique (90 jours)';

  @override
  String adminStatAutoHelp(int auto, int manual, int none) {
    return 'Opérations importées : $auto classées automatiquement, $manual à la main, $none à classer. Objectif de l\'alpha : 70 % (décision 0014).';
  }

  @override
  String get adminUsersHelp =>
      'Tous les comptes du serveur. Un compte bloqué est déconnecté partout et ne peut plus se connecter ; ses données restent intactes.';

  @override
  String get adminServerAdmin => 'administrateur du serveur';

  @override
  String get adminTwoFactorOn => 'double authentification';

  @override
  String get adminTwoFactorOff => 'sans double authentification';

  @override
  String adminCreated(String date) {
    return 'créé le $date';
  }

  @override
  String adminLastActive(String date) {
    return 'actif le $date';
  }

  @override
  String get adminNeverActive => 'jamais connecté';

  @override
  String get adminBlocked => 'bloqué';

  @override
  String get adminBlock => 'Bloquer';

  @override
  String get adminUnblock => 'Débloquer';

  @override
  String adminBlockTitle(String email) {
    return 'Bloquer $email ?';
  }

  @override
  String get adminBlockHelp =>
      'Le compte sera déconnecté dans les minutes qui viennent et ne pourra plus se connecter. Rien n\'est supprimé ; vous pourrez le débloquer.';

  @override
  String get adminUserBlocked => 'Compte bloqué.';

  @override
  String get adminUserUnblocked => 'Compte débloqué.';

  @override
  String get adminBansHelp =>
      'Adresses IP bloquées après trop d\'échecs de connexion. La durée double à chaque récidive.';

  @override
  String get adminBansEmpty => 'Aucune adresse bloquée.';

  @override
  String adminBanUntil(String date, int count) {
    return 'jusqu\'au $date · $countᵉ blocage';
  }

  @override
  String get adminUnban => 'Débloquer';

  @override
  String get adminUnbanned => 'Adresse débloquée.';

  @override
  String get adminAuditHelp =>
      'Les 100 dernières actions sensibles : qui, quoi, quand. Le contenu des changements n\'est pas montré (il peut contenir les données d\'un foyer).';

  @override
  String get adminAuditEmpty => 'Rien pour l\'instant.';

  @override
  String adminAuditGroup(int id) {
    return 'groupe n° $id';
  }

  @override
  String get adminSystem => 'serveur';

  @override
  String get menuAdmin => 'Administration du serveur';

  @override
  String get error_cannot_block_self =>
      'Vous ne pouvez pas bloquer votre propre compte.';

  @override
  String get error_user_not_found => 'Compte introuvable.';

  @override
  String get error_mail_failed =>
      'L\'envoi du courriel a échoué : vérifiez les réglages SMTP dans docker/.env et le journal du serveur.';

  @override
  String get adminTabBackups => 'Sauvegardes';

  @override
  String get adminBackupsUnavailable =>
      'Le dossier d\'échange avec le serveur hôte (docker/state) n\'est pas monté. Il est installé tout seul par la prochaine mise à jour automatique, ou tout de suite avec cette commande lancée en root dans le dossier d\'OwnCoffer :';

  @override
  String get adminBackupNoNightly =>
      'Aucune sauvegarde de nuit pour l\'instant.';

  @override
  String adminBackupNightlyOk(String date) {
    return 'Dernière sauvegarde de nuit : $date';
  }

  @override
  String adminBackupNightlyLate(String date) {
    return 'Pas de sauvegarde de nuit depuis le $date : vérifiez owncoffer-backup.timer.';
  }

  @override
  String adminBackupLastFailed(String date, String message) {
    return 'La dernière sauvegarde a échoué ($date) : $message';
  }

  @override
  String get adminBackupNow => 'Sauvegarder maintenant';

  @override
  String get adminBackupPending => 'Demandée, en cours sur le serveur…';

  @override
  String get adminBackupRequested =>
      'Sauvegarde demandée : elle apparaît ici dans quelques secondes (une toutes les 10 minutes au plus).';

  @override
  String get adminBackupsHelp =>
      'Gardées sur le même serveur, dans docker/backups/ : 30 de nuit, 10 manuelles, 10 avant mise à jour. Copiez-les régulièrement ailleurs (disque, autre machine).';

  @override
  String get adminBackupsEmpty => 'Aucune sauvegarde.';

  @override
  String get adminBackupDaily => 'De nuit';

  @override
  String get adminBackupManual => 'Manuelle';

  @override
  String adminBackupBefore(String version) {
    return 'Avant la mise à jour $version';
  }

  @override
  String get adminRestoreTitle => 'Restaurer une sauvegarde';

  @override
  String get adminRestoreHelp =>
      'Sur le serveur seulement, dans le dossier d\'OwnCoffer : restaurer remplace toutes les données actuelles. Faites d\'abord une sauvegarde.';

  @override
  String get error_host_bridge_missing =>
      'Le dossier d\'échange avec le serveur hôte (docker/state) n\'est pas accessible.';

  @override
  String get adminTabInvitations => 'Invitations';

  @override
  String get adminInvitationsHelp =>
      'Les invitations en attente de tous les groupes. En tant qu\'administrateur du serveur, vous pouvez inviter dans n\'importe quel groupe ; la personne reçoit un lien par courriel, valable 7 jours.';

  @override
  String get adminGroups => 'Groupes du serveur';

  @override
  String adminGroupSize(int members, int accounts) {
    return '$members membre(s) · $accounts compte(s) bancaire(s)';
  }

  @override
  String get adminInvitationsPending => 'Invitations en attente';

  @override
  String get adminInvitationsEmpty => 'Aucune invitation en attente.';

  @override
  String adminInvitedBy(String email) {
    return 'envoyée par $email';
  }

  @override
  String adminInvitationExpires(String date) {
    return 'valable jusqu\'au $date';
  }

  @override
  String get adminInvitationRevoked =>
      'Invitation révoquée : le lien ne marche plus.';

  @override
  String get error_invitation_not_pending =>
      'Cette invitation n\'est plus en attente.';

  @override
  String get adminTabUpdates => 'Mises à jour';

  @override
  String adminVersionRunning(String version) {
    return 'Version en service : $version';
  }

  @override
  String get adminUpdatesUnavailable =>
      'Le serveur hôte n\'a pas encore donné l\'état des mises à jour (dossier docker/state absent, ou script de mise à jour pas encore passé). Il passe toutes les 15 minutes ; pour l\'installer tout de suite, lancez en root dans le dossier d\'OwnCoffer :';

  @override
  String get adminUpToDate => 'OwnCoffer est à jour.';

  @override
  String adminUpdateAvailable(String version) {
    return 'Nouvelle version disponible : $version';
  }

  @override
  String adminUpdateChecked(String date) {
    return 'Dernière vérification : $date';
  }

  @override
  String adminUpdateFailedVersion(String version) {
    return 'La version $version n\'a pas démarré : le serveur est revenu à la version précédente avec la sauvegarde. Elle n\'est plus réessayée automatiquement ; vous pouvez la réinstaller à la main.';
  }

  @override
  String adminInstallNow(String version) {
    return 'Installer $version';
  }

  @override
  String get adminInstall => 'Installer';

  @override
  String adminInstallTitle(String version) {
    return 'Installer $version maintenant ?';
  }

  @override
  String get adminInstallHelp =>
      'Le serveur fait d\'abord une sauvegarde, installe la version, puis vérifie qu\'elle répond ; sinon il revient à la version actuelle avec la sauvegarde. L\'application est indisponible environ une minute ; rechargez la page ensuite.';

  @override
  String get adminCheckNow => 'Vérifier maintenant';

  @override
  String get adminUpdatePending => 'Demandé, en cours sur le serveur…';

  @override
  String get adminAutoUpdate => 'Mises à jour automatiques';

  @override
  String get adminAutoUpdateOn =>
      'Chaque version publiée est installée dans les 15 minutes, après une sauvegarde.';

  @override
  String get adminAutoUpdateOff =>
      'Désactivées : les nouvelles versions sont signalées ici et attendent que vous les installiez.';

  @override
  String get adminAutoUpdateSavedOn => 'Mises à jour automatiques activées.';

  @override
  String get adminAutoUpdateSavedOff =>
      'Mises à jour automatiques désactivées.';

  @override
  String get adminCheckRequested =>
      'Vérification demandée : le résultat apparaît dans quelques secondes.';

  @override
  String adminInstallRequested(String version) {
    return 'Installation de $version demandée : l\'application redémarre dans quelques minutes.';
  }

  @override
  String get adminReleasesUpcoming => 'À venir';

  @override
  String get adminReleasesInstalled => 'Notes des versions installées';

  @override
  String get adminUpdateHistory => 'Historique';

  @override
  String get adminUpdateInstalled => 'installée';

  @override
  String get adminUpdateRollback => 'retour à la version précédente';

  @override
  String get adminUpdateRollbackFailed => 'retour en arrière en échec';

  @override
  String get adminUpdateRefused => 'refusée';

  @override
  String get error_invalid_version =>
      'Version invalide : seule une version publiée plus récente que celle installée peut être installée.';

  @override
  String get navInvoices => 'Factures';

  @override
  String get invoicesTitle => 'Factures';

  @override
  String get invoicesIntro =>
      'Les factures et tickets, nommés d\'après leur opération (date, libellé, montant). Ajoutez-en depuis une opération (page Opérations), ou ici même si l\'opération n\'est pas encore là : elle sera proposée dès qu\'elle arrivera.';

  @override
  String get invoicesSearch => 'Rechercher (nom, libellé, compte)';

  @override
  String get invoicesAllYears => 'Toutes les années';

  @override
  String get invoicesWarrantyFilter => 'Garantie en cours';

  @override
  String get invoicesExport => 'Exporter en ZIP';

  @override
  String invoicesExporting(int done, int total) {
    return 'Export… $done/$total';
  }

  @override
  String get invoicesZipName => 'Factures.zip';

  @override
  String invoicesZipNameYear(String year) {
    return 'Factures $year.zip';
  }

  @override
  String get invoicesEmpty => 'Aucune facture pour l\'instant.';

  @override
  String invoicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count factures',
      one: '1 facture',
    );
    return '$_temp0';
  }

  @override
  String get invoicesOfOperation => 'Factures';

  @override
  String get invoicesNone => 'Aucune facture jointe.';

  @override
  String get invoiceAttach => 'Joindre une facture';

  @override
  String get invoiceTakePhoto => 'Prendre en photo';

  @override
  String invoiceAdded(String name) {
    return 'Facture ajoutée : $name';
  }

  @override
  String get invoiceBadge => 'Facture jointe';

  @override
  String get invoiceUnattached => 'Sans opération';

  @override
  String get invoiceActions => 'Actions';

  @override
  String get invoiceOpen => 'Ouvrir';

  @override
  String get invoiceEdit => 'Description et garantie';

  @override
  String get invoiceSend => 'Envoyer par courriel';

  @override
  String get invoiceDelete => 'Supprimer';

  @override
  String invoiceDeleteConfirm(String name) {
    return 'Supprimer la facture « $name » ?';
  }

  @override
  String get invoiceLabel => 'Description';

  @override
  String get invoiceLabelHint => 'Lave-linge, réparation voiture…';

  @override
  String get invoiceLabelHelp => 'Ajoutée au nom de la facture.';

  @override
  String get invoiceWarranty => 'Fin de garantie';

  @override
  String get invoiceWarrantyNone => 'Pas de garantie suivie.';

  @override
  String invoiceWarrantyUntil(String date) {
    return 'Garantie jusqu\'au $date';
  }

  @override
  String invoiceWarrantyOver(String date) {
    return 'Garantie terminée le $date';
  }

  @override
  String invoiceWarrantyYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ans',
      one: '1 an',
    );
    return '$_temp0';
  }

  @override
  String get invoiceWarrantyPick => 'Choisir une date';

  @override
  String get invoiceWarrantyClear => 'Aucune';

  @override
  String get invoiceWarrantyHelp =>
      'Comptée à partir de la date de l\'opération. Un rappel arrive dans les notifications et par courriel un mois avant la fin.';

  @override
  String get invoiceSendTo => 'Adresse du destinataire';

  @override
  String get invoiceSendMessage => 'Message (facultatif)';

  @override
  String get invoiceSendHelp =>
      'La facture part en pièce jointe, depuis l\'adresse du serveur OwnCoffer.';

  @override
  String get invoiceSendAction => 'Envoyer';

  @override
  String get invoiceSent => 'Facture envoyée.';

  @override
  String notifWarrantyTitle(String name, String date) {
    return 'Garantie de « $name » : fin le $date';
  }

  @override
  String get notifWarrantyBody => 'La facture est dans la page Factures.';

  @override
  String get error_invoice_access_denied =>
      'Facture introuvable ou non accessible.';

  @override
  String get error_mail_not_configured =>
      'L\'envoi de courriels n\'est pas configuré sur ce serveur (réglages SMTP de docker/.env).';

  @override
  String get error_send_limit =>
      'Limite atteinte : 20 envois par jour. Réessayez demain.';

  @override
  String get adminTabMembers => 'Membres du groupe';

  @override
  String get adminTabMySecurity => 'Ma sécurité';

  @override
  String adminMembersOf(String group) {
    return 'Membres de « $group »';
  }

  @override
  String get invoiceAddWaiting => 'Ajouter une facture';

  @override
  String get invoicesWaitingFilter => 'À rattacher';

  @override
  String get invoiceAttachTo => 'Rattacher à une opération';

  @override
  String get invoiceHints => 'Ce que dit la facture';

  @override
  String get invoiceHintsHelp =>
      'Tout est facultatif : le montant, la date et le commerçant servent à proposer la bonne opération, maintenant ou après le prochain import. En attendant, tous les membres du groupe voient la facture.';

  @override
  String get invoiceHintAmount => 'Montant payé';

  @override
  String get invoiceHintAmountInvalid =>
      'Montant illisible (exemple : 499,00).';

  @override
  String get invoiceHintMerchant => 'Commerçant';

  @override
  String get invoiceHintMerchantHint => 'Darty, garage Martin…';

  @override
  String get invoiceHintNoDate => 'Date inconnue';

  @override
  String invoiceHintDate(String date) {
    return 'Date : $date';
  }

  @override
  String get invoiceProposalsSearch => 'Chercher une opération par son libellé';

  @override
  String get invoiceProposalsNone =>
      'Aucune opération ne correspond pour l\'instant. La facture reste « à rattacher » : elle vous sera proposée dans l\'opération quand elle sera importée.';

  @override
  String get invoiceProposalsNoneSearch =>
      'Aucune opération ne contient ce texte.';

  @override
  String invoiceMatchScore(int score) {
    return 'correspondance $score %';
  }

  @override
  String get invoiceAttachLater => 'Plus tard';

  @override
  String invoiceAttached(String name) {
    return 'Facture rattachée : $name';
  }

  @override
  String get invoicesWaitingForThis =>
      'Factures en attente qui pourraient être celle-ci';

  @override
  String get invoiceAttachHere => 'Rattacher ici';

  @override
  String get scanTitle => 'Recadrer la facture';

  @override
  String get scanHelp =>
      'Faites glisser les 4 coins sur ceux de la facture : seule la facture est gardée, redressée comme par un scanner. Tout se fait sur cet appareil.';

  @override
  String get scanLoading => 'Lecture de la photo…';

  @override
  String get scanUnreadable =>
      'Cette image ne peut pas être lue ici pour la recadrer.';

  @override
  String get scanFailed =>
      'Le recadrage a échoué. Gardez la photo telle quelle, ou réessayez avec d\'autres coins.';

  @override
  String get scanKeepAsIs => 'Garder telle quelle';

  @override
  String get scanEnhance => 'Améliorer la lisibilité (fond blanc, texte foncé)';

  @override
  String get scanWholePhoto => 'Toute la photo';

  @override
  String get scanDetectAgain => 'Coins trouvés';

  @override
  String get scanApply => 'Recadrer';

  @override
  String get periodQuarter => 'Trimestre';

  @override
  String periodQuarterName(int quarter, String year) {
    return 'T$quarter $year';
  }

  @override
  String get spendingView => 'Affichage';

  @override
  String get spendingViewLines => 'Lignes';

  @override
  String get spendingViewTable => 'Tableau';

  @override
  String get spendingViewPie => 'Camembert';

  @override
  String get spendingViewChart => 'Graphique';

  @override
  String spendingPeriods(int count) {
    return 'Sur $count périodes';
  }

  @override
  String get spendingPeriodsHelp =>
      'Nombre de périodes montrées par les graphiques dans le temps';

  @override
  String sharePercent(int percent) {
    return '$percent %';
  }

  @override
  String get tableCategory => 'Catégorie';

  @override
  String get tableAmount => 'Montant';

  @override
  String get tableShare => 'Part';

  @override
  String get tablePrevious => 'Période précédente';

  @override
  String get tableAverage => 'Moyenne des 3 précédentes';

  @override
  String get tableCount => 'Opérations';

  @override
  String get pieOthers => 'Autres';

  @override
  String pieDirect(String category) {
    return '$category (sans sous-catégorie)';
  }

  @override
  String get pieTotal => 'Total';

  @override
  String get pieAllCategories => 'Toutes les catégories';

  @override
  String get pieSemantic => 'Répartition par catégorie';

  @override
  String get pieHelp =>
      'Touchez une catégorie pour voir sa répartition ou ses opérations ; « Autres » ouvre le tableau complet.';

  @override
  String get pieHelpSub =>
      'Touchez une sous-catégorie pour voir ses opérations.';

  @override
  String get chartSemantic => 'Évolution des principales catégories';

  @override
  String chartHelp(int count) {
    return 'Les $count catégories les plus importantes sur ces périodes. Touchez le graphique pour lire les montants, ou une catégorie pour voir ses opérations de la période en cours.';
  }

  @override
  String get budgetOperationsHint =>
      'Touchez une opération pour la gérer : catégorie, ventilation, facture, note, abonnement…';

  @override
  String get loanFoundTitle => 'Repérés dans vos opérations';

  @override
  String get loanFoundHelp =>
      'Paiements en plusieurs fois et petits crédits prélevés ces derniers mois, pas encore dans vos crédits. Ajoutez-les pour suivre ce qu\'il reste à payer ; vous réglez le nombre de mensualités.';

  @override
  String loanFoundPaid(int count, String amount, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prélèvements, le dernier de $amount, depuis le $date',
      one: '1 prélèvement de $amount le $date',
    );
    return '$_temp0';
  }

  @override
  String loanFoundStated(int count) {
    return 'en $count fois d\'après le libellé';
  }

  @override
  String get loanFoundAdd => 'Ajouter';

  @override
  String get loanInstallmentsCountHelp =>
      'Touchez − ou + pour régler le nombre de mensualités, celles déjà prélevées comprises.';

  @override
  String get loanInstallmentsLess => 'Une mensualité de moins';

  @override
  String get loanInstallmentsMore => 'Une mensualité de plus';

  @override
  String get loanInstallmentsTotalHelp =>
      'Calculé : mensualité × nombre de mensualités. Modifiable si l\'achat coûtait autre chose.';

  @override
  String get compareTitle => 'Comparer';

  @override
  String get compareIntro =>
      'Mettez côte à côte des catégories dans le temps, plusieurs périodes ou plusieurs comptes. La première période (ou le premier compte) sert de référence pour les écarts.';

  @override
  String get compareCategories => 'Catégories';

  @override
  String get comparePeriods => 'Périodes';

  @override
  String get compareAccounts => 'Comptes';

  @override
  String get compareAddCategory => 'Ajouter une catégorie';

  @override
  String get compareAddPeriod => 'Ajouter une période';

  @override
  String get compareAddPeriodHelp => 'Un jour de la période à ajouter';

  @override
  String get compareNothing => 'Choisissez au moins une catégorie à comparer.';

  @override
  String get compareOverTime => 'Évolution';

  @override
  String get compareColumnPeriod => 'Période';

  @override
  String get compareTotal => 'Total';

  @override
  String get compareAverage => 'Moyenne par période';

  @override
  String compareReference(String name) {
    return '$name (référence)';
  }

  @override
  String get compareByCategory => 'Par catégorie';

  @override
  String get compareGapHelp =>
      'Écarts par rapport à la référence, en euros et en pourcentage.';

  @override
  String get compareSame => 'identique';

  @override
  String get sameProviderTitle => 'Opérations passées au même libellé';

  @override
  String sameProviderHistory(
    int count,
    String since,
    String total,
    String average,
  ) {
    return '$count opérations depuis le $since · total $total · moyenne $average';
  }

  @override
  String sameProviderMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'et $count plus anciennes',
      one: 'et 1 plus ancienne',
    );
    return '$_temp0';
  }

  @override
  String get sectionProvider => 'Fournisseur';

  @override
  String get sectionClassification => 'Classement';

  @override
  String get sectionFollowUp => 'Suivi';

  @override
  String get sectionInvoices => 'Factures et tickets';

  @override
  String get adminDisk => 'Disque du serveur';

  @override
  String adminDiskFree(String free, String total, int percent) {
    return '$free libres sur $total ($percent %)';
  }

  @override
  String get adminDiskUnknown =>
      'Inconnu (relevé toutes les 15 minutes par le serveur)';

  @override
  String get adminDiskLow =>
      'Moins de 10 % libres : la base de données et les sauvegardes risquent d\'échouer. Libérez de la place sur le serveur (anciennes images Docker, journaux…).';

  @override
  String updateProgressTitle(String version) {
    return 'Mise à jour vers $version';
  }

  @override
  String get updateProgressHelp =>
      'Restez sur cette page : OwnCoffer va redémarrer et sera indisponible une à deux minutes. Vos données sont sauvegardées avant tout changement.';

  @override
  String get updateProgressRestarting =>
      'Redémarrage d\'OwnCoffer… (le serveur ne répond pas, c\'est normal)';

  @override
  String updateProgressDone(String version) {
    return 'OwnCoffer $version est installé. Rechargez la page pour utiliser la nouvelle version.';
  }

  @override
  String get updateProgressReload => 'Recharger la page';

  @override
  String get updateProgressFailed =>
      'La mise à jour n\'a pas abouti : OwnCoffer est revenu à la version précédente, avec les données d\'avant la mise à jour. Le détail est dans l\'historique des mises à jour.';

  @override
  String get updateProgressWaiting =>
      'La nouvelle version n\'est pas encore prête au téléchargement (elle est publiée quelques minutes après son annonce). Le serveur réessaiera tout seul d\'ici 15 minutes.';

  @override
  String get updateProgressSlow =>
      'Cela prend plus de temps que prévu. Vous pouvez quitter cette page : la mise à jour continue sur le serveur, et son résultat sera dans l\'historique.';

  @override
  String get updateProgressClose => 'Fermer';

  @override
  String get updateStepRequested => 'Demande transmise au serveur';

  @override
  String get updateStepPull => 'Téléchargement de la nouvelle version';

  @override
  String get updateStepBackup => 'Sauvegarde de vos données';

  @override
  String get updateStepStart => 'Redémarrage d\'OwnCoffer';

  @override
  String get updateStepCheck => 'Vérification que tout répond';

  @override
  String get updateStepRollback => 'Retour à la version précédente…';

  @override
  String get updateStepDone => 'Mise à jour terminée';

  @override
  String get menuAccount => 'Mon compte';

  @override
  String get compareSimulation => 'Simulation';

  @override
  String get simIntro =>
      'Et si je changeais de contrat ? Comparez ce que coûte un abonnement gardé tel quel, et une autre offre, sur plusieurs années. C\'est une simulation : rien n\'est modifié.';

  @override
  String get simContract => 'Le contrat actuel';

  @override
  String get simFrom => 'Partir de';

  @override
  String get simFreeAmount => 'Un montant libre';

  @override
  String get simCurrentMonthly => 'Prix actuel par mois';

  @override
  String get simCurrentRise => 'Hausse par an du contrat actuel';

  @override
  String get simRiseHelp =>
      'Facultatif : de combien le prix augmente chaque année (exemple : 3).';

  @override
  String get simOffer => 'La nouvelle offre';

  @override
  String get simNewMonthly => 'Nouveau prix par mois';

  @override
  String get simSwitchCost => 'Coût du changement';

  @override
  String get simSwitchCostHelp =>
      'Facultatif : frais de résiliation, d\'installation ou de dossier, payés une fois.';

  @override
  String get simNewRise => 'Hausse par an de la nouvelle offre';

  @override
  String get simOver => 'Sur';

  @override
  String simYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ans',
      one: '1 an',
    );
    return '$_temp0';
  }

  @override
  String get simFillIn =>
      'Indiquez le prix actuel et le nouveau prix pour voir la comparaison.';

  @override
  String simSaves(String amount, String period) {
    return 'Vous économiseriez $amount sur $period.';
  }

  @override
  String simCostsMore(String amount, String period) {
    return 'Ce changement coûterait $amount de plus sur $period.';
  }

  @override
  String get simPerMonth => 'par mois en moyenne';

  @override
  String get simPerYear => 'par an en moyenne';

  @override
  String get simNeverPaysOff =>
      'Le changement n\'est jamais rentabilisé sur cette durée.';

  @override
  String get simPaysOffNow => 'Rentable dès le premier mois.';

  @override
  String simPaysOffAfter(int months) {
    return 'Rentabilisé au bout de $months mois.';
  }

  @override
  String simMonthLabel(int month) {
    return 'mois $month';
  }

  @override
  String get simKeep => 'En gardant le contrat';

  @override
  String get simSwitch => 'En changeant';

  @override
  String get simChart => 'Total payé, mois après mois';

  @override
  String get simHow =>
      'Calcul : total payé chaque mois, coût du changement compté au départ, prix relevés chaque année de leur hausse, arrondis au centime.';

  @override
  String get checkOne => 'Pointer';

  @override
  String get uncheckOne => 'Dépointer';

  @override
  String get checkedOne => 'Opération pointée.';

  @override
  String get uncheckedOne => 'Opération dépointée.';

  @override
  String checkedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations pointées.',
      one: '1 opération pointée.',
    );
    return '$_temp0';
  }

  @override
  String uncheckedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations dépointées.',
      one: '1 opération dépointée.',
    );
    return '$_temp0';
  }

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnées',
      one: '1 sélectionnée',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get checkSelected => 'Pointer';

  @override
  String get uncheckSelected => 'Dépointer';

  @override
  String get selectionStop => 'Arrêter la sélection';

  @override
  String get operationsSelectHint =>
      'Touchez le rond d\'une opération pour la pointer ; appui long pour en sélectionner plusieurs.';

  @override
  String get error_too_many => 'Trop d\'opérations à la fois : 500 au plus.';

  @override
  String get navHome => 'Accueil';

  @override
  String get dashboardAdvisor =>
      'Mon conseiller : ce qu\'OwnCoffer vous propose';

  @override
  String dashboardBalance(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sur vos $count comptes',
      one: 'Sur votre compte',
      zero: 'Aucun compte en euros',
    );
    return '$_temp0';
  }

  @override
  String dashboardLowest(String account, String amount, String date) {
    return 'Point bas des 30 prochains jours : $amount sur $account, le $date';
  }

  @override
  String get dashboardUpcoming => 'Cette semaine';

  @override
  String get dashboardUpcomingNone => 'Aucune échéance prévue d\'ici 7 jours.';

  @override
  String get dashboardSeeForecast => 'Voir les prévisions';

  @override
  String get dashboardMonthSpending => 'Ce mois-ci';

  @override
  String dashboardMonthTotals(String expense, String income) {
    return '$expense dépensés, $income reçus';
  }

  @override
  String dashboardToClassify(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations à classer',
      one: '1 opération à classer',
    );
    return '$_temp0';
  }

  @override
  String get dashboardSeeBudget => 'Voir le budget';

  @override
  String get dashboardWatch => 'À surveiller';

  @override
  String get dashboardAllGood =>
      'Rien à signaler : aucun compte ne passe sous son seuil d\'alerte dans les 30 jours.';

  @override
  String dashboardBelow(String account, String date) {
    return '$account passe sous son seuil d\'alerte le $date';
  }

  @override
  String dashboardUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notifications non lues',
      one: '1 notification non lue',
    );
    return '$_temp0';
  }

  @override
  String get advisorTitle => 'Mon conseiller';

  @override
  String get advisorIntro =>
      'Ce qu\'OwnCoffer vous propose, d\'après les comptes que vous voyez. Chaque proposition montre ses chiffres et son calcul ; rien ne change tant que vous ne l\'acceptez pas, et tout changement accepté peut être annulé.';

  @override
  String get advisorNothing => 'Rien à proposer pour l\'instant';

  @override
  String get advisorNothingHelp =>
      'Les propositions viennent de vos trois derniers mois complets : objectifs à fixer, à relever ou à baisser. Revenez après le prochain import.';

  @override
  String get advisorPast => 'Décidées ces 30 derniers jours';

  @override
  String advisorSuggestGoal(String category, String amount) {
    return 'Fixer un objectif « $category » : $amount par mois';
  }

  @override
  String advisorRaiseGoal(String category, String from, String to) {
    return 'Relever l\'objectif « $category » : $from → $to';
  }

  @override
  String advisorLowerGoal(String category, String from, String to) {
    return 'Baisser l\'objectif « $category » : $from → $to';
  }

  @override
  String get advisorOther => 'Proposition';

  @override
  String advisorGoalWhy(String months, String amount) {
    return 'Dépenses des trois derniers mois : $months. Leur moyenne, arrondie à la dizaine d\'euros supérieure, donne $amount.';
  }

  @override
  String get advisorSuggestWhy =>
      'Cette catégorie a des dépenses chaque mois et pas encore d\'objectif : un objectif réaliste vous préviendra à 80 % et à 100 %.';

  @override
  String get advisorRaiseWhy =>
      'L\'objectif a été dépassé au moins deux mois sur trois : un objectif réaliste reste utile au lieu d\'alerter tous les mois.';

  @override
  String get advisorLowerWhy =>
      'Les dépenses sont restées sous la moitié de l\'objectif trois mois de suite : un objectif plus serré garde la marge que vous avez prise.';

  @override
  String get advisorByEngine => 'Calculé par OwnCoffer, sans IA.';

  @override
  String advisorByAi(String provider, String model) {
    return 'Proposé par l\'IA ($provider, $model) : vérifiez avant d\'accepter.';
  }

  @override
  String advisorAiCategory(String label, String category) {
    return 'Classer « $label » dans « $category »';
  }

  @override
  String advisorAiCategoryWhy(String date, String amount, String why) {
    return 'Opération du $date, $amount. $why';
  }

  @override
  String advisorAiLoan(String lender, String principal, int months) {
    return 'Créer le crédit « $lender » : $principal sur $months mois';
  }

  @override
  String advisorAiLoanWhy(String rate, String payment, String date) {
    return 'Lu dans le document : taux $rate, mensualité $payment, première échéance le $date. Vous pourrez tout corriger ensuite dans l\'onglet Crédits.';
  }

  @override
  String advisorAiRule(String match, String pattern, String category) {
    return 'Créer la règle : libellé $match « $pattern » → « $category »';
  }

  @override
  String advisorAiRuleWhy(int count, String label, String why) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opérations déjà importées seront classées',
      one: '1 opération déjà importée sera classée',
      zero: 'Aucune opération déjà importée n\'est concernée',
    );
    return 'Repérée sur « $label ». $_temp0 (compté par OwnCoffer, sans toucher à vos choix faits à la main), puis les suivantes à chaque import. $why';
  }

  @override
  String get advisorAiRuleUndo =>
      'Vous pourrez annuler : la règle sera supprimée et ses opérations classées à nouveau sans elle.';

  @override
  String get advisorAccept => 'Accepter';

  @override
  String get advisorRefuse => 'Refuser';

  @override
  String get advisorAccepted => 'Proposition appliquée.';

  @override
  String get advisorRefused => 'Proposition refusée.';

  @override
  String get advisorUndone => 'Changement annulé.';

  @override
  String get advisorReaderHelp =>
      'En lecture seule : un membre peut accepter cette proposition.';

  @override
  String get advisorStatusExecuted => 'Appliquée';

  @override
  String get advisorStatusRefused => 'Refusée';

  @override
  String get advisorStatusExpired => 'Retirée : les données ont changé';

  @override
  String get advisorStatusUndone => 'Annulée';

  @override
  String get error_proposal_stale =>
      'Les données ont changé depuis cette proposition : elle a été retirée, sans rien modifier.';

  @override
  String get error_proposal_closed => 'Cette proposition a déjà été traitée.';

  @override
  String get error_proposal_access_denied =>
      'Cette proposition n\'existe pas ou n\'est pas à vous.';

  @override
  String get error_proposal_unknown =>
      'Cette proposition ne peut pas être appliquée : elle est incomplète.';

  @override
  String get adminTabAi => 'IA';

  @override
  String get adminAiIntro =>
      'Les fournisseurs d\'IA que les utilisateurs peuvent choisir. L\'IA reste désactivée pour chacun tant qu\'il ne l\'active pas. Elle ne lit que les comptes que l\'utilisateur voit, par les fonctions du moteur, et ne fait que proposer : rien ne change sans validation.';

  @override
  String get adminAiAdd => 'Ajouter un fournisseur';

  @override
  String get adminAiEdit => 'Modifier le fournisseur';

  @override
  String get adminAiNone =>
      'Aucun fournisseur : l\'IA n\'est pas disponible sur ce serveur.';

  @override
  String get adminAiKeySet => 'clé enregistrée';

  @override
  String get adminAiDisabled => 'désactivé';

  @override
  String adminAiCapValue(int count) {
    return '$count demandes par mois et par utilisateur';
  }

  @override
  String get adminAiTest => 'Tester la connexion';

  @override
  String adminAiTestOk(int count, String models) {
    return 'Connexion réussie : $count modèles ($models)';
  }

  @override
  String get adminAiDelete => 'Supprimer';

  @override
  String adminAiDeleteTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get adminAiDeleteHelp =>
      'Les utilisateurs qui l\'avaient choisi n\'auront plus d\'IA tant qu\'ils n\'en choisissent pas un autre.';

  @override
  String get adminAiLocal => 'Local (Ollama)';

  @override
  String get adminAiExternal => 'Externe (compatible OpenAI)';

  @override
  String get adminAiLocalHelp =>
      'Un modèle qui tourne sur ce serveur ou votre réseau : les données ne sortent pas de chez vous. Adresse du type http://192.168.1.10:11434/v1.';

  @override
  String get adminAiExternalHelp =>
      'Un fournisseur en ligne (Mistral, OpenAI, OpenRouter…) : les questions et les chiffres utiles lui sont envoyés, ce que l\'application dit à l\'utilisateur.';

  @override
  String get adminAiPreset => 'Fournisseur';

  @override
  String get adminAiGeminiHelp =>
      'Collez une clé d\'API Google AI Studio (aistudio.google.com, « Get API key »). La liste des modèles est demandée à Google à l\'enregistrement si vous la laissez vide.';

  @override
  String get adminAiChatGptHelp =>
      'Collez une clé d\'API OpenAI (platform.openai.com, « API keys ») : elle est facturée à l\'usage, à part de l\'abonnement ChatGPT. La liste des modèles est demandée à OpenAI à l\'enregistrement si vous la laissez vide.';

  @override
  String get adminAiClaudeHelp =>
      'Collez une clé d\'API Anthropic (platform.claude.com, « API keys ») : elle est facturée à l\'usage, à part de l\'abonnement Claude. OwnCoffer utilise l\'API Claude elle-même, sans passer par une compatibilité OpenAI.';

  @override
  String get adminAiSentOutside =>
      'Fournisseur en ligne : les questions et les chiffres utiles lui sont envoyés, ce que l\'application rappelle à chaque utilisateur.';

  @override
  String get adminAiName => 'Nom affiché';

  @override
  String get adminAiUrl => 'Adresse de l\'API';

  @override
  String get adminAiKey => 'Clé d\'API';

  @override
  String get adminAiKeyHelp =>
      'Facultative pour Ollama. Chiffrée sur le serveur, jamais réaffichée.';

  @override
  String get adminAiKeyKeep =>
      'Une clé est enregistrée : laisser vide pour la garder.';

  @override
  String get adminAiModels => 'Modèles proposés';

  @override
  String get adminAiModelsHelp =>
      'Séparés par des virgules, par exemple : llama3.1, mistral-small. Laissez vide pour demander la liste au fournisseur.';

  @override
  String get adminAiCap => 'Plafond mensuel par utilisateur';

  @override
  String get adminAiCapHelp => 'Nombre de demandes ; 0 pour aucun plafond.';

  @override
  String get adminAiTools => 'Appel des fonctions du moteur';

  @override
  String get adminAiToolsHelp =>
      'Le modèle sait appeler des fonctions : il lit vos chiffres et fait des propositions.';

  @override
  String get adminAiVision => 'Lecture d\'images';

  @override
  String get adminAiVisionHelp =>
      'Le modèle lit des images (tableau d\'amortissement, ticket…).';

  @override
  String get adminAiEnabled => 'Proposé aux utilisateurs';

  @override
  String get assistantTitle => 'Assistant';

  @override
  String get assistantNotSetUp => 'L\'IA n\'est pas configurée';

  @override
  String get assistantSetUpAdmin =>
      'Ajoutez un fournisseur dans Administration > IA (un modèle local avec Ollama, ou un fournisseur en ligne).';

  @override
  String get assistantSetUpAsk =>
      'L\'administrateur du serveur peut ajouter un fournisseur d\'IA. OwnCoffer fonctionne entièrement sans.';

  @override
  String get assistantChoice => 'Votre IA';

  @override
  String get assistantIntro =>
      'L\'assistant lit vos chiffres par les fonctions d\'OwnCoffer (comptes que vous voyez seulement), explique, et peut proposer des changements : catégories, crédit lu dans un document. Rien ne change tant que vous n\'acceptez pas dans Mon conseiller.';

  @override
  String get assistantProvider => 'Fournisseur';

  @override
  String get assistantModel => 'Modèle';

  @override
  String get assistantLocal => 'local';

  @override
  String get assistantExternal => 'externe';

  @override
  String get assistantEnabled => 'Activer l\'assistant';

  @override
  String assistantUsage(int count) {
    return '$count demandes ce mois-ci';
  }

  @override
  String assistantUsageCap(int count, int cap) {
    return '$count demandes sur $cap ce mois-ci';
  }

  @override
  String assistantExternalWarning(String provider) {
    return 'Fournisseur externe : votre question, la conversation, les images jointes et les résultats des fonctions appelées (opérations, montants, catégories) sont envoyés à $provider.';
  }

  @override
  String get assistantImageSent => 'Image jointe';

  @override
  String get assistantThinking => 'Réflexion…';

  @override
  String get assistantNoAnswer => 'Pas de réponse du modèle.';

  @override
  String assistantUsedTools(String tools) {
    return 'A consulté : $tools';
  }

  @override
  String assistantSentTo(String provider, String model) {
    return 'Envoyé à $provider ($model).';
  }

  @override
  String assistantProposals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count propositions à valider',
      one: '1 proposition à valider',
    );
    return '$_temp0';
  }

  @override
  String get assistantAttach =>
      'Joindre une image (tableau d\'amortissement, ticket…)';

  @override
  String assistantImageReady(String name) {
    return 'Image prête : $name';
  }

  @override
  String get assistantHint =>
      'Posez une question, ou « classe mes opérations »…';

  @override
  String get assistantClassifyChip => 'Classer les opérations à classer';

  @override
  String get assistantClassifyPrompt =>
      'Propose une catégorie pour mes opérations à classer, et une règle quand le même commerçant reviendra.';

  @override
  String get assistantSend => 'Envoyer';

  @override
  String get error_ai_off =>
      'L\'assistant est désactivé : activez-le et choisissez un modèle.';

  @override
  String get error_ai_provider_unavailable =>
      'Ce fournisseur ou ce modèle n\'est pas disponible.';

  @override
  String get error_ai_cap_reached => 'Plafond mensuel de demandes atteint.';

  @override
  String get error_ai_unavailable =>
      'Le fournisseur d\'IA ne répond pas. Aucun autre n\'a été utilisé à sa place.';

  @override
  String error_ai_reason(String reason) {
    return 'Réponse du fournisseur : $reason';
  }

  @override
  String get error_ai_no_models =>
      'Le fournisseur n\'a proposé aucun modèle de conversation : indiquez-en un.';

  @override
  String get error_ai_no_vision => 'Ce modèle ne lit pas les images.';

  @override
  String get error_ai_message_too_long =>
      'Message trop long (4 000 caractères au plus).';

  @override
  String get error_ai_invalid_url =>
      'Adresse invalide : http:// ou https://, sans identifiant dedans.';

  @override
  String get error_ai_invalid_kind => 'Type de fournisseur inconnu.';

  @override
  String get mcpTitle => 'Depuis un autre assistant (MCP)';

  @override
  String get mcpIntro =>
      'Un assistant que vous utilisez déjà (Claude Desktop ou tout client MCP) peut lire vos chiffres et faire des propositions, avec les mêmes fonctions et les mêmes limites que l\'assistant intégré : les comptes que vous voyez, rien ne change sans votre accord. Les données qu\'il lit partent vers le modèle de cet assistant.';

  @override
  String get mcpCreate => 'Créer un jeton';

  @override
  String get mcpCreateHelp =>
      'Le jeton donne accès à ce foyer, avec vos droits. Vous pourrez le révoquer à tout moment.';

  @override
  String get mcpName => 'Nom (pour le reconnaître)';

  @override
  String get mcpCreated => 'Jeton créé';

  @override
  String get mcpCreatedHelp =>
      'Copiez-le maintenant : il ne sera plus affiché. Dans votre assistant, ajoutez un serveur MCP « HTTP » avec cette adresse et l\'en-tête Authorization: Bearer suivi du jeton.';

  @override
  String get mcpAddress => 'Adresse';

  @override
  String get mcpSecret => 'Jeton';

  @override
  String get mcpCopy => 'Copier le jeton';

  @override
  String get mcpDone => 'C\'est noté';

  @override
  String mcpNeverUsed(String prefix) {
    return '$prefix · jamais utilisé';
  }

  @override
  String mcpLastUsed(String prefix, String date) {
    return '$prefix · utilisé le $date';
  }

  @override
  String get mcpRevoke => 'Révoquer';

  @override
  String get error_mcp_token_access_denied =>
      'Ce jeton n\'existe pas ou n\'est pas à vous.';

  @override
  String get demoBanner => 'Démonstration : toutes les données sont fictives.';

  @override
  String get adminDemoFill => 'Remplir avec le foyer de démonstration';

  @override
  String get adminDemoHelp =>
      'Instance de démonstration : remplit le foyer actuel (vide) avec trois comptes, douze mois d\'opérations fictives, des abonnements, des objectifs et un crédit.';

  @override
  String get adminDemoDone => 'Foyer de démonstration rempli.';

  @override
  String get error_demo_only =>
      'Possible seulement sur une instance de démonstration.';

  @override
  String get error_demo_group_not_empty =>
      'Le foyer doit être vide (aucun compte) pour y charger la démonstration.';

  @override
  String get groupAuditTitle => 'Journal du foyer';

  @override
  String get groupAuditHelp =>
      'Qui a fait quoi dans ce foyer, et quand. Le contenu des changements n\'est pas montré. Réservé aux administrateurs du foyer.';

  @override
  String get groupAuditFormer => 'ancien membre ou administrateur du serveur';

  @override
  String get groupAuditMore => 'Voir les plus anciennes';

  @override
  String auditLine(String what, String did) {
    return '$what : $did';
  }

  @override
  String get auditEntityTransaction => 'Opération';

  @override
  String get auditEntityAccount => 'Compte';

  @override
  String get auditEntityImport => 'Import';

  @override
  String get auditEntityRule => 'Règle';

  @override
  String get auditEntityCategory => 'Catégorie';

  @override
  String get auditEntityLoan => 'Crédit';

  @override
  String get auditEntityInvoice => 'Facture';

  @override
  String get auditEntityGoal => 'Objectif';

  @override
  String get auditEntityScheduled => 'Opération prévue';

  @override
  String get auditEntityGroup => 'Foyer';

  @override
  String get auditEntityMember => 'Membre';

  @override
  String get auditEntityInvitation => 'Invitation';

  @override
  String get auditEntityProposal => 'Proposition';

  @override
  String get auditEntityAi => 'Assistant IA';

  @override
  String get auditEntityMcp => 'Assistant externe (MCP)';

  @override
  String get auditEntityNotifications => 'Réglages des notifications';

  @override
  String get auditActionCreate => 'créé';

  @override
  String get auditActionUpdate => 'modifié';

  @override
  String get auditActionDelete => 'supprimé';

  @override
  String get auditActionTrash => 'mis à la corbeille';

  @override
  String get auditActionRestore => 'restauré';

  @override
  String get auditActionCategory => 'catégorie changée';

  @override
  String get auditActionSplit => 'ventilation changée';

  @override
  String get auditActionCleared => 'pointage changé';

  @override
  String get auditActionImport => 'relevé importé';

  @override
  String get auditActionCancelImport => 'import annulé';

  @override
  String get auditActionUndo => 'action annulée';

  @override
  String get auditActionArchive => 'archivé';

  @override
  String get auditActionInvite => 'invitation envoyée';

  @override
  String get auditActionRevoke => 'révoqué';

  @override
  String get auditActionRole => 'rôle changé';

  @override
  String get auditActionRemove => 'retiré du foyer';

  @override
  String get auditActionPropose => 'proposée';

  @override
  String get auditActionAccept => 'acceptée et appliquée';

  @override
  String get auditActionRefuse => 'refusée';

  @override
  String get auditActionExpire => 'retirée (données changées)';

  @override
  String get auditActionAsk => 'question posée';

  @override
  String get auditActionReadDocument => 'document lu';

  @override
  String get auditActionAttach => 'document joint';

  @override
  String get notifSettingsTitle => 'Réglages des notifications';

  @override
  String get notifSettingsIntro =>
      'Choisissez ce qu\'OwnCoffer vous signale. Ces réglages ne valent que pour vous ; les autres membres du foyer ont les leurs.';

  @override
  String get notifSettingsOverdraft => 'Découvert prévu';

  @override
  String get notifSettingsOverdraftHelp =>
      'Quand le solde prévu d\'un compte passera sous son seuil d\'alerte.';

  @override
  String get notifSettingsInApp => 'Dans l\'application';

  @override
  String get notifSettingsByEmail => 'Aussi par courriel';

  @override
  String get notifSettingsGoals => 'Objectifs du mois';

  @override
  String get notifSettingsGoalWarning => 'À 80 % de l\'objectif';

  @override
  String get notifSettingsGoalOver => 'Objectif dépassé';

  @override
  String get notifSettingsGoalForecast => 'Dépassement annoncé';

  @override
  String get notifSettingsGoalForecastHelp =>
      'Dès que la projection de fin de mois annonce un dépassement.';

  @override
  String get notifSettingsWarranty => 'Fin de garantie';

  @override
  String get notifSettingsWarrantyHelp =>
      'Un mois avant la fin de la garantie d\'une facture.';

  @override
  String get notifSettingsEmailNote =>
      'Les courriels ne partent que si l\'administrateur du serveur a réglé leur envoi. Une alerte coupée n\'est pas créée du tout, et n\'est donc pas envoyée par courriel.';

  @override
  String get loanKindRevolving => 'Crédit renouvelable';

  @override
  String get loanRevolvingHelp =>
      'Une réserve d\'argent qu\'on rembourse par mensualités : indiquez le montant utilisé aujourd\'hui, la mensualité prélevée et le taux. La durée en découle. Les nouvelles utilisations s\'ajoutent ensuite dans « Changements ».';

  @override
  String get loanRevolvingPaymentRequired =>
      'La mensualité est nécessaire pour un crédit renouvelable.';

  @override
  String get loanRevolvingUsed => 'Montant utilisé (à rembourser)';

  @override
  String get loanCreditLimit => 'Plafond de la réserve';

  @override
  String get loanCreditAvailable => 'Encore disponible';

  @override
  String get loanEventsTitle => 'Changements';

  @override
  String get loanEventsEmpty =>
      'Aucun changement depuis le début : taux et mensualité d\'origine.';

  @override
  String get loanEventsHelp =>
      'Le tableau, le capital restant, les échéances prévues et la prévision du solde en tiennent compte.';

  @override
  String get loanEventAdd => 'Ajouter un changement';

  @override
  String get loanEventAddRevolving => 'Nouvelle utilisation ou changement';

  @override
  String get loanEventRemove => 'Retirer ce changement';

  @override
  String get loanEventKind => 'Changement';

  @override
  String get loanEventKindRate => 'Nouveau taux (taux variable)';

  @override
  String get loanEventKindRenegotiation => 'Renégociation';

  @override
  String get loanEventKindDraw => 'Nouvelle utilisation (renouvelable)';

  @override
  String get loanEventKindRepayment => 'Remboursement anticipé';

  @override
  String get loanEventRateHelp =>
      'À partir de cette date, le nouveau taux s\'applique. La date de fin est gardée et la mensualité recalculée, sauf si la mensualité prélevée est connue : elle est alors gardée et la date de fin bouge.';

  @override
  String get loanEventRenegotiationHelp =>
      'Indiquez ce que la banque vous a accordé : nouveau taux, et nouvelle mensualité ou nouvelle durée restante. Laissez vide ce qui ne change pas.';

  @override
  String get loanEventDrawHelp =>
      'De l\'argent utilisé sur la réserve : il s\'ajoute à ce qui reste à rembourser, avec la même mensualité.';

  @override
  String get loanEventRepaymentHelp =>
      'Une somme remboursée en plus des mensualités : la mensualité est gardée, le crédit finit plus tôt.';

  @override
  String get loanEventDate => 'À partir du';

  @override
  String get loanEventNewRate => 'Nouveau taux nominal';

  @override
  String get loanEventNewPayment => 'Nouvelle mensualité (hors assurance)';

  @override
  String get loanEventNewMonths => 'Nouvelle durée restante (mois)';

  @override
  String get loanEventNewMonthsHelp =>
      'Ignorée si une nouvelle mensualité est indiquée.';

  @override
  String get loanEventAmount => 'Montant';

  @override
  String get loanEventNote => 'Note';

  @override
  String get loanEventInvalid =>
      'Indiquez au moins un nouveau taux, une nouvelle mensualité ou une nouvelle durée.';

  @override
  String loanEventRate(String rate) {
    return 'taux à $rate';
  }

  @override
  String loanEventPayment(String amount) {
    return 'mensualité de $amount';
  }

  @override
  String loanEventMonths(String months) {
    return 'encore $months';
  }

  @override
  String loanEventDraw(String amount) {
    return '$amount utilisés';
  }

  @override
  String loanEventRepaid(String amount) {
    return '$amount remboursés en plus';
  }

  @override
  String get error_loan_event_invalid =>
      'Ce changement n\'est pas possible pour ce crédit (date avant la première échéance, ou valeurs hors limites).';

  @override
  String get error_loan_event_unpaid =>
      'Avec ce changement, le crédit ne serait jamais remboursé : la mensualité ne couvre pas les intérêts.';

  @override
  String get error_loan_over_limit =>
      'Ce montant dépasse le plafond de la réserve.';

  @override
  String get aiReadReceipt => 'Lire le ticket avec l\'IA';

  @override
  String get aiReadInvoice => 'Lire la facture avec l\'IA';

  @override
  String get aiReadLoan => 'Lire ce document avec l\'IA';

  @override
  String get aiReadTitle => 'Lire avec l\'IA';

  @override
  String aiReadExternal(String provider, String model) {
    return 'Le document sera envoyé à $provider ($model), un fournisseur en ligne, pour être lu. L\'IA ne fait que relever ce qui est écrit : OwnCoffer vérifie, fait les calculs et vous propose les changements dans Mon conseiller.';
  }

  @override
  String aiReadLocal(String provider, String model) {
    return 'Le document sera lu par $provider ($model), sur votre réseau. L\'IA ne fait que relever ce qui est écrit : OwnCoffer vérifie, fait les calculs et vous propose les changements dans Mon conseiller.';
  }

  @override
  String get aiReadGo => 'Lire';

  @override
  String get aiReadRunning => 'Lecture en cours…';

  @override
  String aiReadDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count propositions vous attendent dans Mon conseiller.',
      one: 'Une proposition vous attend dans Mon conseiller.',
    );
    return '$_temp0';
  }

  @override
  String get aiReadNothingNew => 'Rien de nouveau dans ce document.';

  @override
  String get aiReadNotReady =>
      'Pour lire un document, activez l\'assistant (icône ✨) avec un modèle qui lit les images.';

  @override
  String get aiReadNoPdf =>
      'Ce modèle ne lit que les images : joignez une photo ou une capture du document. (Claude lit aussi les PDF.)';

  @override
  String advisorAiSplit(String label) {
    return 'Ventiler « $label » d\'après le ticket';
  }

  @override
  String advisorAiSplitWhy(String amount, String date) {
    return 'Opération de $amount du $date, répartie ainsi :';
  }

  @override
  String advisorAiSplitRest(String amount) {
    return 'Dont $amount que les lignes du ticket n\'expliquent pas (remise, arrondi, ligne illisible), à classer : calculé par OwnCoffer.';
  }

  @override
  String advisorAiInvoiceHints(String name) {
    return 'Compléter la facture « $name »';
  }

  @override
  String advisorAiLoanTerms(String lender) {
    return 'Mettre à jour le crédit « $lender » d\'après son document';
  }

  @override
  String advisorReadIn(String name) {
    return 'Lu dans « $name ».';
  }

  @override
  String get error_receipt_mismatch =>
      'Les lignes lues sur le ticket dépassent le montant de l\'opération : ce n\'est sans doute pas son ticket.';

  @override
  String get error_document_nothing_read =>
      'L\'IA n\'a rien pu lire d\'utile dans ce document.';

  @override
  String get error_ai_document_not_image =>
      'Ce modèle ne lit que les images : joignez une photo ou une capture du document.';

  @override
  String get error_ai_document_too_large =>
      'Document trop lourd pour être lu (8 Mo au plus).';
}
