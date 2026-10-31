# Nouveautés

Les versions suivent le [versionnage sémantique](https://semver.org/lang/fr/). L'image Docker de chaque version est `ghcr.io/cmathias27/owncoffer:<version>` ; l'installation et la mise à jour sont décrites dans [docs/INSTALLATION.md](docs/INSTALLATION.md).

## 0.3.6 (31 octobre 2026)

### Simulateur d'achat

- Dans la page Prévisions, **« Simuler un achat »** : on saisit un montant, la date de l'achat et la date à laquelle on veut connaître son solde (par défaut le 25 du mois suivant), et éventuellement une catégorie.
- Cinq cartes côte à côte : **sans l'achat** (pour comparer), **comptant**, **en 3 fois**, **en 4 fois** et **le mois suivant**. Chacune donne ses prélèvements, le solde à la date choisie, le point bas et sa date, et prévient en cas de découvert prévu ou d'objectif du mois dépassé.
- Le calcul passe par le moteur de prévision, avec les opérations prévues et, au choix, les dépenses variables estimées. Rien n'est enregistré tant qu'on ne choisit pas.
- **« Choisir et enregistrer »** : le choix comptant ou le mois suivant devient une opération prévue ; en 3 ou 4 fois, il devient un paiement en plusieurs fois dans la page Crédits. Les échéances sont arrondies au centime supérieur, la dernière ajuste, sans frais.

## 0.3.5 (31 octobre 2026)

### Prévisions

- **Dépenses variables estimées dans la courbe du solde** : courses, carburant, sorties… Pour chaque catégorie, l'estimation reprend la **médiane des trois derniers mois complets**, si bien qu'un mois exceptionnel ne la gonfle pas. Les opérations prévues, les virements entre vos comptes et les revenus ne sont pas comptés. Les débits non classés forment une catégorie à part.
- Ce mois-ci, seul le reste est compté (le montant habituel moins ce qui est déjà dépensé), réparti jour par jour jusqu'à la fin du mois. Les mois suivants comptent le montant habituel.
- Sous la courbe : « Dont … de dépenses variables estimées ». Un clic montre le calcul : les mois utilisés, chaque catégorie avec ses montants et sa médiane, ce qui est déjà dépensé ce mois-ci et ce qui reste attendu.
- Un filtre **« Dépenses variables »** permet de les retirer pour ne voir que les opérations prévues.
- Les mois antérieurs à la première opération du compte ne sont pas utilisés. Sans au moins un mois complet d'historique, l'application le signale.
- L'alerte de découvert et le reste à vivre ne changent pas : ils restent calculés sur les seules opérations prévues.

## 0.3.4 (31 octobre 2026)

### Objectifs

- **Projection en fin de mois** sous chaque jauge d'objectif de la page Budget : « À ce rythme : 380 € en fin de mois », ou, si l'objectif risque d'être dépassé, « À ce rythme : 120 € de trop, dépassement vers le 26 » en rouge.
- Le calcul additionne ce qui est déjà dépensé, les opérations prévues de la catégorie encore attendues ce mois-ci, et le rythme des autres dépenses de la catégorie (dépensé depuis le début du mois ÷ jours écoulés, pour chaque jour restant). Le rythme n'est compté qu'après 7 jours, pour qu'un gros achat en début de mois ne soit pas multiplié.
- **Alerte anticipée** : une notification « dépassement prévu vers le … » arrive dès que la projection annonce un dépassement, une seule fois par objectif et par mois, en plus des alertes à 80 % et 100 %.

## 0.3.3 (31 octobre 2026)

### Opérations

- **Les abonnements sont mis en évidence** : chaque opération rattachée à un abonnement porte une icône ↻ et la mention « Abonnement ».
- Nouveau filtre **« Abonnements »** pour ne voir que leurs prélèvements, et bouton **« Liste des abonnements »** pour ouvrir la page des abonnements.
- La fiche d'une opération d'abonnement indique son abonnement, avec un lien vers la liste, au lieu de proposer « Marquer comme abonnement ».

## 0.3.2 (31 octobre 2026)

### Corrigé

- Le bandeau « Annuler » qui apparaît après une action ne restait plus à l'écran indéfiniment en cachant les boutons du bas : il flotte au-dessus de la page et disparaît seul au bout de dix secondes.

## 0.3.1 (31 octobre 2026)

### Crédits

- **La mensualité prélevée fait foi** : un nouveau champ « Mensualité prélevée (assurance comprise) » est rempli tout seul quand le crédit est déclaré ou rattaché depuis un prélèvement. Le tableau d'amortissement, le capital restant, les intérêts, la date de fin et les échéances prévues partent de ce montant. La durée qui en découle est affichée comme une estimation. Sans ce montant, la mensualité est calculée comme avant et présentée comme telle.
- La fiche du crédit indique si la mensualité est prélevée ou calculée, et rappelle que le reste est estimé et que le tableau de la banque fait foi.
- **Documents du crédit** : tableau d'amortissement, offre de prêt, captures d'écran (PDF, image, CSV, texte ou tableur, 10 Mo au plus, 30 par crédit) sont gardés sur le serveur. On les ouvre ou les télécharge depuis la fiche du crédit quand on veut. Ils sont stockés dans la base de données, donc compris dans les sauvegardes, et ne sont envoyés nulle part ailleurs.
- Plus tard (phase 4, avec l'IA en option) : lire ces documents pour proposer les conditions du crédit à valider.

## 0.3.0 (31 octobre 2026)

Suite des ajouts demandés pendant le mois d'essai : on peut annuler une action, et la page Budget s'enrichit.

### Annuler

- Après chaque action dans la fiche d'une opération, un bouton **« Annuler »** remet les choses comme avant. C'est le cas pour un changement de catégorie, une ventilation, le pointage, « Toujours classer ainsi », « C'est un abonnement », « C'est une échéance de crédit » et la mise à la corbeille. Annuler une règle ou un crédit classe à nouveau, sans eux, les opérations qu'ils avaient classées.
- Même chose pour fixer, modifier ou supprimer un objectif.

### Budget

- **Page Budget réorganisée** pour se lire de haut en bas :
  - **bilan de la période** en tête : « Il vous reste… » ou « Vous avez dépensé … de plus que vos revenus », avec deux barres sur la même échelle (revenus en bleu, dépenses et épargne en orange) et l'évolution par rapport à la période précédente ;
  - **reste à vivre** à côté du bilan (ou dessous sur téléphone) ;
  - bandeau des **opérations à classer** avec un bouton « Classer » ;
  - carte **Objectifs du mois** qui réunit tous les objectifs, du plus entamé au moins entamé. Chaque jauge porte un trait qui marque où on devrait en être aujourd'hui pour tenir l'objectif jusqu'à la fin du mois ;
  - **classements** des dépenses et des revenus avec leur total. Les six premières catégories sont affichées et « Voir les … catégories » montre les autres. L'écart avec la moyenne est indiqué par une flèche de couleur, et un drapeau signale les catégories qui ont un objectif ;
  - Revue du mois, Calendrier, Abonnements et réglage du début du mois en raccourcis sous la période.
- **Catégories parentes et sous-catégories mieux distinguées** dans les classements, la page Catégories et le choix d'une catégorie. La catégorie parente est en gras, sur un fond teinté et avec son icône. La sous-catégorie est décalée le long d'un trait, en plus clair et avec une barre plus fine. Pendant une recherche, une sous-catégorie affiche le nom de sa catégorie parente.
- **Reste à vivre** jusqu'à la prochaine paie : solde des comptes courants, moins les prélèvements prévus d'ici la fin du mois de budget, plus les rentrées prévues. Il est aussi ramené à un montant par jour.
- **Alertes d'objectif** : une notification quand une catégorie atteint 80 % puis 100 % de son objectif du mois, une seule fois par seuil. Le calcul se fait sur les comptes que chaque membre peut voir.
- **Calendrier des échéances** : toutes les opérations prévues du mois (loyer, abonnements, échéances de crédit), avec leur état : passée, en retard, sautée ou à venir.
- **Revue du mois** :
  - reste du mois comparé au mois précédent ;
  - catégories en hausse ou en baisse par rapport à la moyenne des trois mois précédents ;
  - objectifs dépassés ;
  - frais bancaires du mois ;
  - plus grosses dépenses ;
  - abonnements prélevés pour un autre montant que prévu, et nouveaux abonnements.

### Opérations et comptes

- **Ventilation** : une opération (un ticket de supermarché, par exemple) se répartit entre plusieurs catégories. Les parts comptent dans le budget, les objectifs et le filtre par catégorie.
- **Solde de contrôle** : saisir le solde affiché par la banque à une date pour le comparer au solde calculé. En cas d'écart, OwnCoffer montre ce qui peut l'expliquer : opérations saisies à la main et non pointées, ou relevé manquant.

### Crédits

- **Rattacher un prélèvement passé à un crédit déjà saisi** : « C'est une échéance de crédit » propose de choisir un crédit existant ou d'en déclarer un nouveau.
  - Le prélèvement est relié à l'échéance la plus proche, même décalée de quelques jours, et classé dans la catégorie du crédit.
  - Un crédit sans compte prend celui du prélèvement. Un crédit sans libellé reconnu prend celui du prélèvement, avec une règle qui classera les prochains automatiquement.
  - Les autres échéances passées retrouvées sur le compte sont rattachées aussi.
  - Le bouton « Annuler » fonctionne comme pour les autres actions.
- **Opérations du crédit** dans la fiche d'un crédit : les prélèvements du compte qui le concernent (rattachés à ses échéances ou classés par sa règle), du plus récent au plus ancien, avec le total payé. Modifier un crédit ne fait plus perdre le rattachement des prélèvements déjà reliés.
- **Paiements en plusieurs fois** (3 ou 4 fois, Alma, Oney…) : un nouveau type dans la page Crédits, sans taux, rangé à part. Il peut être déclaré depuis le premier prélèvement : le montant total est alors calculé à partir du prélèvement.

## 0.2.1 (31 octobre 2026)

### Crédits déclarés depuis une opération

- Dans la fiche d'un prélèvement : **« C'est une échéance de crédit »** ouvre le formulaire du crédit prérempli (organisme, compte, date, catégorie).
- **Capital calculé à partir du prélèvement** : avec le taux, la durée et l'assurance, le capital est déduit de la mensualité constatée. Avec la date de ce prélèvement et la durée restante, on obtient le capital restant dû sans connaître le contrat d'origine. Un avertissement s'affiche si la mensualité calculée s'écarte de plus de 5 % du prélèvement.
- Les prélèvements sont reconnus à leur libellé : une **règle de classement** est créée dans la catégorie du crédit (par défaut celle de son type, par exemple Crédit immobilier), avec une fourchette de ±20 % sur le montant pour ne pas prendre les autres prélèvements du même organisme. Les opérations déjà importées sont classées tout de suite, sauf celles classées à la main.
- Les **échéances passées** retrouvées sur le compte sont rattachées au crédit, et les prochaines le seront à l'import. Une opération prévue créée auparavant pour ces prélèvements est remplacée par celle du crédit.
- Changer la catégorie du crédit change celle de sa règle. Supprimer le crédit supprime sa règle, et les opérations gardent leur catégorie.

### Opérations

- Dans la fiche d'une opération : **« Autres paiements de ce prestataire »** liste les opérations du compte qui ont le même libellé nettoyé, avec leur nombre, leur total et leur moyenne. Le filtre se retire d'un clic.

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
