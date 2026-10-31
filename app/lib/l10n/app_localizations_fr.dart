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
      'Revenus et dépenses des six dernières périodes';

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
}
