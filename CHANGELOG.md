# Nouveautés

Les versions suivent le [versionnage sémantique](https://semver.org/lang/fr/). L'image Docker de chaque version est `ghcr.io/cmathias27/owncoffer:<version>` ; l'installation et la mise à jour sont décrites dans [docs/INSTALLATION.md](docs/INSTALLATION.md).

## 0.2.0 (31 octobre 2026)

Ajouts demandés pendant le mois d'essai de l'alpha.

### Budget et classement des dépenses

- Nouvelle page **Budget** : revenus, dépenses, épargne et reste sur une **semaine**, un **mois** ou une **année**, avec l'écart par rapport à la période précédente.
- **Classement des dépenses** et **des revenus** par catégorie, du plus gros au plus petit : part du total, montant de la période précédente, moyenne des trois périodes précédentes ; un clic déplie les sous-catégories ou ouvre les opérations correspondantes. Les opérations à classer ont leur propre ligne.
- Graphique **revenus et dépenses** des six dernières périodes, avec le détail au survol ou au toucher.
- Les virements entre ses comptes et les catégories « Mouvements internes » ne sont jamais comptés, pour ne rien compter deux fois.
- **Début du mois réglable** (administrateur du groupe) : le mois de budget peut commencer le jour de la paie, du 1er au 28 (par exemple du 27 au 26).
- Opérations : filtre par **catégorie**, sous-catégories comprises.

### Objectifs par catégorie

- Un **objectif mensuel** par catégorie de dépenses (sous-catégories comprises), avec une jauge verte, orange à partir de 80 %, rouge au-delà, et ce qu'il reste à dépenser.
- **Objectif suggéré** d'après la moyenne des trois mois précédents, arrondie aux 10 € supérieurs.

### Abonnements

- Dans la fiche d'une dépense : **« C'est un abonnement »** crée l'opération prévue mensuelle correspondante (même montant, libellé et catégorie, 10 % de tolérance pour les hausses de prix) ; l'opération elle-même en est la première échéance.
- Liste des **abonnements** (depuis la page Budget) avec leur coût par mois et par an ; les abonnements annuels ou hebdomadaires sont ramenés au mois.
- Interrupteur « Abonnement » dans la fenêtre des opérations prévues.

### Crédits

- Nouvelle page **Crédits** : reste à rembourser, total des mensualités et **taux d'endettement** indicatif (mensualités / revenus moyens des trois derniers mois, repère à 35 %).
- Saisie d'un crédit à taux fixe : organisme, type, capital, taux nominal, TAEG, durée, première échéance, assurance mensuelle, frais, compte de prélèvement, catégorie ; la mensualité s'affiche pendant la saisie.
- **Tableau d'amortissement** calculé, année par année ; capital restant dû, intérêts payés et à payer, coût total, pourcentage remboursé, date de fin.
- Avec un compte de prélèvement, les échéances deviennent une **opération prévue** : elles entrent dans le solde prévu et sont rapprochées des prélèvements réels.
- **Simulation de remboursement anticipé** : intérêts économisés et nouvelle date de fin, en gardant la mensualité.
- Calculs indicatifs ; le tableau de la banque fait foi.

## 0.1.2 (31 octobre 2026)

- Fiche d'une opération : elle tient toujours dans l'écran, même petit, son contenu défile, et on l'agrandit ou la réduit en la faisant glisser.
- Choix d'une catégorie : un champ de recherche filtre la liste dès qu'on tape (accents et majuscules ignorés, Entrée choisit la seule catégorie trouvée). Il remplace les longues listes déroulantes dans la fiche d'une opération, les opérations prévues et les règles.
- Nouvelle catégorie **Animaux** : alimentation animale, vétérinaire, assurance, toilettage, garde et pension, accessoires et jouets, autres dépenses. Elle remplace la sous-catégorie « Animaux » d'« Enfants et famille » : dans les foyers existants, celle-ci est déplacée dans « Animaux › Autres dépenses animaux » au démarrage du serveur, avec ses opérations, ses règles et son nom s'il avait été personnalisé. Six règles communautaires en plus (animaleries en ligne, vétérinaires, assurances animaux).
- Fiche d'une opération : « Rechercher ce libellé sur Google » ouvre un nouvel onglet avec le libellé nettoyé, pour identifier un prélèvement inconnu ; le libellé complet de la banque n'est jamais envoyé.
- Classement d'une opération : « Créer la catégorie… » en bas de la recherche ajoute une catégorie (nom, type, catégorie parente) sans quitter la fiche, et l'opération y est classée aussitôt.

## 0.1.1 (31 octobre 2026)

- Correction : après la création du compte administrateur, l'étape de création du groupe était sautée et l'application indiquait « vous ne faites partie d'aucun groupe ». L'accueil propose désormais de créer son foyer quand on n'a aucun groupe.

## 0.1.0 — alpha (31 octobre 2026)

Première version utilisable, pour un usage personnel (décision 0010). À utiliser un mois avant d'ajouter quoi que ce soit (#20).

### Comptes et opérations

- Comptes bancaires : solde initial, seuil d'alerte (découvert autorisé), compte restreint à certains membres.
- Solde actuel, solde pointé et point bas à 30 jours sur chaque compte.
- Opérations : recherche, filtres « À classer » et « Non pointées », pointage, note personnelle, corbeille avec annulation, saisie manuelle.
- Montants en centimes entiers de bout en bout ; un montant ambigu est refusé plutôt que deviné.

### Import des relevés

- Caisse d'Épargne en QIF, OFX et CSV (et tout CSV dont on choisit les colonnes) ; accents, virgule décimale et dates françaises gérés.
- Aperçu avant import : nouvelles opérations, doublons écartés par empreinte (même entre QIF et OFX), doublons possibles à cocher.
- Solde de la banque (OFX) comparé au solde qu'aura OwnCoffer après l'import.
- Compte reconnu d'après le numéro du fichier OFX, sans stocker ce numéro.
- Historique des imports, avec annulation.

### Classement

- 90 catégories standard, renommables, et 154 règles communautaires pour les grandes enseignes.
- Libellés nettoyés : « PRLV SEPA EDF SA REF… » devient « EDF ».
- Ordre : règles du groupe, puis règles communautaires, puis vos choix passés ; l'origine de chaque catégorie est affichée.
- « Toujours classer ainsi » crée une règle et reclasse les opérations concernées ; écran des règles avec testeur de libellé.
- Sur le relevé de démonstration, 70 % des opérations sont classées sans intervention.

### Solde prévu et alertes

- Opérations prévues (loyer, salaire, abonnements), courbe du solde jour par jour sur 30 jours, 90 jours ou 1 an.
- Rapprochement des opérations réelles avec les échéances prévues ; échéances en retard signalées.
- Alerte de découvert prévu dans l'application et par email, vérifiée dès qu'une opération change.

### Sécurité

- Inscription sur invitation seulement ; double authentification (TOTP et codes de secours).
- Blocage automatique des adresses IP après des échecs répétés ; limite de requêtes.
- Chaque point d'accès vérifie groupe, rôle et visibilité du compte, et a son test d'isolation (décision 0016).
- Un seul port publié, derrière Cloudflare ; aucune télémétrie.

### Installation

- Mise à jour automatique des versions publiées : sauvegarde avant, contrôle après, retour à la version précédente et à la sauvegarde en cas d'échec.
- Sauvegarde de la base chaque nuit (30 dernières gardées) et à la demande (`docker/backup.sh`).

### Limites connues

- Une seule banque testée : la Caisse d'Épargne.
- Sauvegardes sur le même serveur seulement : copiez `docker/backups/` ailleurs (chiffré).
- Pas d'IA ni d'objectifs : ils viennent en phase 4.
