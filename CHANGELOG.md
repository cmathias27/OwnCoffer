# Nouveautés

Les versions suivent le [versionnage sémantique](https://semver.org/lang/fr/). L'image Docker de chaque version est `ghcr.io/cmathias27/owncoffer:<version>` ; l'installation et la mise à jour sont décrites dans [docs/INSTALLATION.md](docs/INSTALLATION.md).

## 0.3.33 (1er novembre 2026)

### Analyses, sans IA

- Nouvelle page **Analyses** (depuis le Budget) :
  - **fiabilité des prévisions** : combien d'opérations prévues sont arrivées comme prévu ces trois derniers mois, et les dépenses variables estimées du dernier mois face à ce qui a été réellement dépensé ;
  - **opérations inhabituelles** : un prélèvement bien plus élevé que d'habitude pour son libellé (avec le montant habituel et sur combien d'opérations il est calculé), ou le même prélevé deux fois à quelques jours d'écart ;
  - **frais bancaires des 12 derniers mois** : mois par mois et par libellé. Ils sont repérés par leur catégorie ou par leur libellé (frais, commission, agios, cotisation de carte…), et les remboursements de frais sont déduits.
- Les **objectifs suggérés** se calculent maintenant sur les 3 à 6 derniers mois, sans compter les mois vides du début.

### Mon conseiller : des cartes à surveiller

- À côté des propositions : **découvert à venir** sur un compte, **opération inhabituelle** ou **prélevée deux fois**, **frais bancaires** de l'année. Chaque carte donne ses chiffres. Elle se marque « Compris » ou « Ignorer », ne change rien et ne revient pas.

### Import de plusieurs fichiers, corbeille

- **« Plusieurs fichiers »** dans la page Import : plusieurs relevés d'un coup, chacun lu d'abord, sur le compte reconnu (OFX) ou choisi ; les doublons possibles sont laissés de côté.
- **Corbeille** (page Opérations) : les opérations mises à la corbeille, à **restaurer** ou à **supprimer définitivement** ; « Vider » pour tout supprimer.

### Assistant : mémoire et historique

- **« Ce que l'assistant doit savoir »** dans les réglages : quelques phrases envoyées avec chaque question, visibles par vous seul.
- **Historique** dans la bulle : vos 30 dernières conversations, gardées sur votre serveur, à reprendre ou à supprimer.

### Donner un avis

- **« Donner un avis »** (menu du compte, ou icône en haut sur grand écran) : un problème, une idée, une question, envoyés à l'administrateur du serveur avec la page et la version. L'administrateur les lit dans l'onglet **Retours** et les marque traités ; l'auteur voit où en est son message.

## 0.3.32 (1er novembre 2026)

### Assistant : une bulle de discussion

- La conversation avec l'assistant s'ouvre maintenant dans une **bulle en bas à droite**, comme une messagerie : elle **reste ouverte d'une page à l'autre**, signale une réponse arrivée pendant qu'elle était réduite, et prend tout l'écran sur téléphone.
- La page **Assistant : réglages** ne garde que la configuration : fournisseur, modèle, activation, jetons MCP. L'icône ✨ ouvre la conversation quand l'assistant est activé, ses réglages sinon.

### Fournisseurs d'IA

- **« Tester la connexion »** essaie maintenant une vraie petite conversation avec le premier modèle, et affiche **la réponse exacte du fournisseur** en cas d'erreur (clé refusée, modèle inconnu, quota…).
- Seuls les **modèles courants** sont proposés quand la liste est demandée au fournisseur : sans versions d'essai (« preview », « exp »), sans versions datées, sans variantes spécialisées, les plus récents d'abord, 12 au plus.
- La **température n'est plus imposée** : les modèles récents (modèles de raisonnement d'OpenAI, Gemini 3) refusent ou déconseillent toute autre valeur que la leur.

## 0.3.31 (1er novembre 2026)

### Lire les tickets, factures et documents de crédit avec l'IA

- Avec l'assistant activé et un modèle qui lit les images, **« Lire avec l'IA »** apparaît dans le menu d'une facture et sur chaque document d'un crédit (✨) :
  - **ticket joint à une opération** : ses lignes sont regroupées par catégorie et la **ventilation** de l'opération est proposée. Ce que les lignes n'expliquent pas (remise, arrondi, ligne illisible) devient une part à classer, **calculée par OwnCoffer** ;
  - **facture en attente** : son **montant**, sa **date** et son **commerçant** sont proposés ;
  - **document de crédit** (tableau d'amortissement, offre) : les **conditions** qu'il indique sont proposées pour le crédit, avec l'avant et l'après.
- L'IA ne fait que **relever ce qui est écrit** ; OwnCoffer vérifie (un ticket qui dépasse le montant de l'opération est refusé, un taux hors limites n'est pas retenu), fait les sommes, et tout arrive dans **Mon conseiller** : rien ne change sans votre accord, et tout s'annule.
- Avec un fournisseur en ligne, OwnCoffer demande d'abord votre accord pour envoyer le document. Seul le document part, rien d'autre. Les images sont lues par tous les modèles qui lisent les images ; les PDF, par Claude.

### Crédits : taux variable, renégociation, crédit renouvelable

- **« Ajouter un changement »** dans la fiche d'un crédit : **nouveau taux** (taux variable), **renégociation** (nouveau taux, nouvelle mensualité ou nouvelle durée), **remboursement anticipé**. Le tableau, le capital restant, les échéances prévues et la prévision du solde suivent ; un changement se retire d'un geste. Un changement qui ne permettrait jamais de rembourser est refusé.
- Nouveau type **« Crédit renouvelable »** : montant utilisé, mensualité, taux et **plafond**. Chaque **nouvelle utilisation** s'ajoute ; la fiche montre ce qui reste **disponible**, et une utilisation au-delà du plafond est refusée.
- Calculs faits par le moteur commun et testés (capital remboursé au centime près, date de fin gardée ou mensualité gardée selon le cas).

### Réglages des notifications

- Page Notifications, bouton **réglages** : pour chaque alerte (découvert prévu, objectif à 80 %, dépassé, dépassement annoncé, fin de garantie), **dans l'application** et **aussi par courriel** quand elle peut l'être. Chacun règle les siennes.

### Journal du foyer

- Les **administrateurs d'un foyer** ont maintenant leur **journal**, depuis la page Membres : qui a fait quoi dans le foyer, et quand, sans le contenu des changements (#37).

### Aide

- Les pages d'aide Crédits, Factures, Notifications, Membres, Mon conseiller, Assistant et Vos données sont à jour.

## 0.3.30 (1er novembre 2026)

### Aide dans l'application

- Un bouton **?** en haut de chaque page ouvre **l'aide de cette page** : à quoi elle sert, comment s'en servir, ce qu'il faut savoir. Sur téléphone, l'aide est dans le menu « Mon compte ».
- **« Toute l'aide »** réunit les 17 pages : premiers pas, accueil, comptes, opérations, import, catégories et règles, budget, prévisions, crédits, factures, Mon conseiller, assistant IA, notifications, membres, sécurité, administration du serveur, et vos données.
- En français et en anglais, selon la langue de l'application. Les textes sont livrés avec l'application : l'aide marche sans connexion et n'appelle rien à l'extérieur.
- Les pages sont aussi lisibles sur GitHub, dans `app/assets/help/`.

## 0.3.29 (1er novembre 2026)

### IA : Gemini, ChatGPT et Claude prêts à l'emploi

- **Administration > IA > Ajouter un fournisseur** propose maintenant **Google Gemini**, **OpenAI ChatGPT** et **Anthropic Claude** déjà réglés : il suffit de **coller la clé d'API**. L'aide indique où obtenir chaque clé (guide : `docs/INSTALLATION.md`, « Brancher une IA »).
- Laissée vide, la **liste des modèles est demandée au fournisseur** à l'enregistrement, ce qui vérifie aussi la clé : une clé refusée n'est pas enregistrée.
- Les erreurs disent maintenant **ce que répond le fournisseur** (« API key not valid », quota dépassé…), jamais la clé.
- **Claude** est appelé par l'API d'Anthropic elle-même (ses blocs de réponse renvoyés tels quels entre deux appels de fonctions), sans basculement automatique vers un autre modèle.

### Correction

- **Gemini** refusait les demandes de l'assistant : la description des fonctions sans paramètre ne lui convenait pas, et ses modèles étaient listés sous la forme `models/gemini-…`. C'est corrigé.

## 0.3.28 (1er novembre 2026)

### Assistant IA : une règle avec la catégorie

- Quand l'assistant propose une catégorie pour une opération dont le commerçant reviendra, il peut aussi **proposer la règle** qui classera les suivantes (« libellé commence par « BOULANGERIE » → Alimentation »).
- C'est **OwnCoffer qui vérifie** la règle avant de la proposer : elle doit correspondre au libellé de l'opération, ne pas exister déjà, et avoir un texte d'au moins trois caractères ; sinon elle n'est pas proposée.
- La carte de **Mon conseiller** dit **combien d'opérations déjà importées seront classées** (compté par le moteur, sur les comptes que vous voyez, sans toucher à vos choix faits à la main), avec quelques exemples. La règle et la catégorie s'acceptent séparément.
- Rien ne change avant votre accord ; une fois acceptée, la règle s'applique aussitôt et **peut être annulée** : elle est supprimée et ses opérations sont classées à nouveau sans elle. Si la même règle a été créée entre-temps, la proposition est retirée sans rien modifier.
- Dans l'écran **Assistant**, un raccourci **« Classer les opérations à classer »** pose la question pour vous.
- Fonctionne aussi depuis un autre assistant (MCP).

## 0.3.27 (1er novembre 2026)

### Instance de démonstration

- Pour montrer OwnCoffer **sans aucune vraie donnée** : une instance à part, lancée avec `OWNCOFFER_DEMO=true` dans son propre projet Docker (guide : `docs/DEMO.md`).
- Sur une telle instance, **Administration > Santé > « Remplir avec le foyer de démonstration »** charge dans le foyer (vide) un **foyer fictif** : trois comptes, douze mois d'opérations (salaires, loyer, courses, carburant, restaurants, abonnements…), quelques opérations à classer, des échéances et abonnements, trois objectifs, un crédit auto et un paiement en 4 fois en cours. Toujours les mêmes données, datées par rapport au jour du remplissage.
- Un **bandeau « Démonstration : toutes les données sont fictives »** s'affiche sur chaque page.
- Sur une instance normale, le remplissage est impossible (vérifié par un test).

### Correction

- **Administration** : les onglets « IA » et « Sauvegardes » affichaient chacun le contenu de l'autre (depuis la 0.3.25). C'est corrigé.

## 0.3.26 (1er novembre 2026)

### OwnCoffer depuis un autre assistant (MCP)

- OwnCoffer est maintenant aussi un **serveur MCP** (*Model Context Protocol*), à l'adresse `/mcp` de votre instance : un assistant que vous utilisez déjà (Claude Desktop ou tout client MCP) peut **lire vos chiffres et faire des propositions**, avec exactement les mêmes fonctions et les mêmes limites que l'assistant intégré.
- Dans l'écran **Assistant**, section « Depuis un autre assistant (MCP) » : **créer un jeton personnel** pour le foyer (affiché une seule fois, avec l'adresse à donner à l'assistant), voir sa dernière utilisation, le **révoquer** à tout moment.
- Le jeton agit **avec vos droits, sur les comptes que vous voyez** ; il cesse de fonctionner si vous quittez le foyer ou si votre compte est bloqué. Seule son empreinte est gardée sur le serveur.
- **Rien ne s'écrit directement** : les propositions (catégorie, crédit lu dans un document) arrivent dans Mon conseiller, comme celles de l'assistant intégré. Chaque appel est noté au journal.
- Avec MCP, les données lues partent vers le modèle de l'assistant que vous avez choisi : c'est rappelé à la création du jeton (décision 0018).
- Fonctionne même sans fournisseur d'IA configuré sur le serveur.

## 0.3.25 (1er novembre 2026)

### Assistant IA (facultatif) et passerelle IA

- **L'IA est facultative** : OwnCoffer fonctionne entièrement sans, et elle est **désactivée par défaut** pour chacun.
- **Administration > IA** (administrateur du serveur seulement, décision 0017) : ajouter des fournisseurs — un **modèle local avec Ollama** (les données restent chez vous) ou un **fournisseur en ligne compatible OpenAI** (Mistral, OpenAI, OpenRouter…). Adresse, clé d'API (chiffrée, jamais réaffichée ni écrite au journal), modèles proposés, capacités (appel des fonctions, lecture d'images), plafond mensuel de demandes par utilisateur, bouton « Tester la connexion ».
- **Assistant** (icône ✨ en haut) : chacun choisit un fournisseur et un modèle, active l'assistant, et pose ses questions.
  - L'IA lit vos chiffres **uniquement par les fonctions d'OwnCoffer** (aperçu des comptes, opérations, budget, échéances, prévisions, objectifs, catégories), **sur les comptes que vous voyez** ; elle ne lit jamais la base et ne calcule aucun montant elle-même.
  - Elle **ne modifie rien** : elle peut **proposer** une catégorie pour une opération, ou **un crédit lu dans un document** (joignez une photo ou une capture d'un tableau d'amortissement à un modèle qui lit les images). Les propositions arrivent dans **Mon conseiller**, marquées « proposé par l'IA (fournisseur, modèle) », et ne s'appliquent qu'après votre accord.
  - Chaque réponse dit quelles fonctions ont été consultées et, pour un fournisseur externe, ce qui lui a été envoyé ; un avertissement le rappelle avant d'écrire.
  - Un fournisseur qui ne répond pas est signalé : **jamais de bascule** vers un autre.

### Budget

- Le Budget s'ouvre maintenant sur le **camembert**.

## 0.3.24 (1er novembre 2026)

### Mon conseiller (sans IA) et circuit des propositions

- Nouvel écran **Mon conseiller** (bouton dans le Budget, lien depuis l'Accueil) : ce qu'OwnCoffer vous propose, calculé par le moteur, **sans IA**.
  - **Fixer un objectif** pour une catégorie dépensée chaque mois qui n'en a pas ;
  - **le relever** quand il a été dépassé au moins deux mois sur trois ;
  - **le baisser** quand les dépenses sont restées sous la moitié trois mois de suite.
- Chaque proposition montre **ses chiffres et son calcul** (dépenses des trois derniers mois complets, moyenne arrondie à la dizaine d'euros supérieure) et dit qu'elle est calculée sans IA.
- **Rien ne change sans votre accord** : « Accepter » applique, « Refuser » écarte. Tout ce qui est accepté **peut être annulé** depuis l'historique des 30 derniers jours.
- Les propositions sont faites **pour vous seul**, d'après les comptes que vous voyez : leurs chiffres ne révèlent jamais un compte restreint à un autre membre.
- Garanties (décision 0009), vérifiées par des tests : les droits sont revérifiés au moment d'accepter ; une proposition dont les données ont changé est **retirée sans rien modifier** ; un double clic ne l'applique **qu'une fois** ; tout est noté au journal ; un lecteur peut consulter mais pas accepter.
- Le circuit sait aussi **créer un crédit** à partir de champs lus dans un document : il servira à l'assistant IA (tableau d'amortissement → crédit dans l'onglet Crédits, après votre validation).

## 0.3.23 (1er novembre 2026)

### Accueil

- Nouvel onglet **Accueil**, ouvert en premier : où en est l'argent aujourd'hui et ce qui arrive, sur les comptes que vous voyez.
  - **Total des comptes** en grand, avec le **point bas des 30 prochains jours** (compte, montant, date) et le solde de chaque compte ;
  - le **reste à vivre** jusqu'à la fin du mois budgétaire ;
  - le **bilan du mois** (revenus, dépenses, épargne) ;
  - **cette semaine** : les échéances des 7 prochains jours (abonnements, crédits, opérations prévues) ;
  - **ce mois-ci** : dépensé, reçu, et les opérations à classer ;
  - **à surveiller** : comptes qui passeront sous leur seuil d'alerte, notifications non lues.
- Chaque carte mène à sa page (Comptes, Budget, Prévisions, Notifications). Une colonne sur téléphone, deux sur grand écran.
- Sur téléphone, la barre du bas devient : Accueil, Comptes, Opérations, Budget et « Plus ».

## 0.3.22 (1er novembre 2026)

### Comparer avec une simulation : et si je changeais de contrat ?

- Nouveau choix **« Simulation »** dans l'écran Comparer (page Budget) :
  - partir d'un de vos **abonnements** (son prix mensuel est repris) ou d'un **montant libre** ;
  - indiquer le **nouveau prix**, l'éventuel **coût du changement** (frais de résiliation, d'installation, de dossier) et, si besoin, la **hausse annuelle** de chaque offre ;
  - sur **1, 3, 5 ou 10 ans** : l'économie (ou le surcoût) sur la durée, par mois et par an en moyenne, le **mois où le changement est rentabilisé**, et les deux courbes du total payé, en gardant le contrat ou en changeant.
- Le calcul est fait par le moteur commun et testé (coût du changement compté au départ, prix relevés chaque année, arrondis au centime). C'est une simulation : rien n'est modifié.
- Les modes de comparaison sont maintenant des puces qui passent à la ligne sur téléphone.

### Opérations : pointer une ou plusieurs opérations

- **Toucher le rond** à gauche d'une opération la pointe (ou la dépointe) directement, sans ouvrir sa fiche ; « Annuler » est proposé.
- **Appui long** sur une opération : mode sélection. On coche une ou plusieurs opérations (ou « Tout sélectionner »), puis **« Pointer »** ou **« Dépointer »** en une fois ; « Annuler » remet chacune comme elle était.
- Le serveur vérifie les droits sur chaque compte et applique tout ou rien.

### Budget : les opérations affichées comme dans la page Opérations

- La liste des opérations d'une catégorie utilise les mêmes lignes que la page Opérations (pointage, catégorie, montant en couleur, compte quand il y en a plusieurs).

## 0.3.21 (1er novembre 2026)

### Affichage adapté au téléphone et à la tablette

- **Tablette** (600 à 1 200 px de large) : menu compact sur le côté, au lieu de la barre du bas du téléphone. **Grand écran** (1 200 px et plus) : menu latéral déplié, avec les noms. Le menu défile quand la fenêtre est basse (téléphone tenu en paysage).
- **Téléphone** : la barre du haut ne garde que le foyer et les notifications ; membres ou administration, sécurité et déconnexion passent dans le menu **« Mon compte »**. La barre du bas garde ses 4 onglets et « Plus ».
- Les listes déroulantes des formulaires ne débordent plus sur un petit écran (le type de crédit dépassait de 120 px à 360 px de large).
- Les écrans principaux sont vérifiés automatiquement à 360, 768 et 1 200 px de large.

### Le style doux partout

- La fenêtre flottante et arrondie de la fiche d'opération est utilisée par les autres fenêtres du bas : opérations d'une catégorie du budget, menu « Plus », actions d'un abonnement.
- Dans toute l'application : cartes plus arrondies et sans ombre dure, dialogues arrondis, champs de saisie remplis aux coins arrondis, puces en pilule, lignes arrondies au toucher, messages flottants.
- Sections en cartes et tuiles icône + texte réutilisables par les autres écrans (`widgets/soft.dart`).

## 0.3.20 (1er novembre 2026)

### Administration : mise à jour suivie pas à pas, espace disque

- **« Installer » une mise à jour fige maintenant la page** sur son avancement, jusqu'au bout :
  - demande transmise, téléchargement, sauvegarde de vos données, redémarrage, vérification, terminé ;
  - chaque étape est cochée quand le serveur l'a faite ;
  - pendant le redémarrage, la page explique que le silence du serveur est normal ;
  - à la fin, **« Recharger la page »** pour utiliser la nouvelle version.
  - Si la mise à jour échoue, la page dit qu'OwnCoffer est revenu à la version précédente avec vos données. Si la nouvelle version n'est pas encore téléchargeable, elle dit que le serveur réessaiera tout seul.
  - Au-delà de 15 minutes, on peut quitter la page : la mise à jour continue sur le serveur.
- **Espace disque du serveur** dans la Santé : place libre sur la place totale, relevée toutes les 15 minutes. La ligne passe en rouge, avec une explication, sous 10 % libres (la base de données et les sauvegardes risqueraient d'échouer).

## 0.3.19 (1er novembre 2026)

### Fiche d'opération : opérations passées et nouvelle allure

- La fiche montre les **opérations passées au même libellé** (même fournisseur), sur tous les comptes que vous voyez : combien, depuis quand, le total et la moyenne, puis les 10 plus récentes avec leur date, leur catégorie et leur montant. Pratique pour vérifier qu'un prélèvement n'a pas changé.
- **Nouvelle allure, plus douce** :
  - la fiche flotte au-dessus de la page, arrondie de tous les côtés, au lieu de finir droit en bas de l'écran ;
  - un en-tête teinté, avec des formes rondes, donne le libellé, le montant en grand et la date ;
  - le reste est rangé en cartes arrondies : Fournisseur, Classement, Suivi, Opérations passées, Factures et tickets ;
  - les actions (ventiler, toujours classer ainsi, abonnement, crédit, autres paiements, recherche sur le web) deviennent des **tuiles avec une icône et leur nom**, plus faciles à repérer et à toucher sur téléphone ;
  - le bouton « Mettre à la corbeille » est centré, en forme de pilule.

## 0.3.18 (1er novembre 2026)

### Budget : comparer

- Nouveau bouton **« Comparer »** dans la page Budget, avec trois façons de comparer :
  - **Catégories** : 1 à 4 catégories (ou sous-catégories), une courbe chacune sur les 6, 12 ou 24 dernières périodes, et un tableau période par période avec le total et la moyenne ;
  - **Périodes** : par défaut cette période, la précédente et la même un an plus tôt ; on en ajoute ou en retire, jusqu'à 4. Une barre par période, d'abord pour le total, puis catégorie par catégorie, avec l'écart en euros et en pourcentage par rapport à la première ;
  - **Comptes** : 2 à 4 comptes sur la même période, présentés de la même façon.
- Semaine, mois, trimestre ou année ; dépenses ou revenus ; tous les comptes ou un seul.
- Les chiffres viennent du même calcul que le budget, sur les seuls comptes que vous voyez.

## 0.3.17 (1er novembre 2026)

### Correction

- **Fiche d'opération grise** (depuis la 0.3.16) : toucher une opération, dans la page Opérations comme dans le Budget, ouvrait une fenêtre grise au lieu de sa fiche. C'est corrigé, et un test vérifie maintenant que la fiche s'affiche dans les deux cas.

### Crédits : micro-crédits et paiements en plusieurs fois repérés

- L'onglet Crédits montre **« Repérés dans vos opérations »** : les paiements en plusieurs fois (Oney, Alma, Klarna, 4x CB…) et petits crédits (Cofidis, Floa…) prélevés ces derniers mois, qui ne sont pas encore dans vos crédits. Pour chacun : nombre de prélèvements, dernier montant, date du premier, et le nombre d'échéances quand le libellé le donne (« 4X », « 2/4 », « en 3 fois »).
- **« Ajouter »** ouvre la fiche du crédit déjà remplie à partir du premier prélèvement : organisme, mensualité, taux à 0 % pour un paiement en plusieurs fois, et nombre de mensualités proposé.
- **Nombre de mensualités réglable** avec les boutons − et + : le montant total suit (mensualité × nombre), et reste modifiable à la main. Les prélèvements passés sont rattachés au crédit, et les suivants sont prévus.
- Un paiement terminé (toutes les échéances prélevées) ou sans prélèvement depuis plus de deux mois n'est plus proposé. Un paiement déjà dans vos crédits non plus.
- Seules les opérations classées dans « Paiements en plusieurs fois » ou « Crédits à la consommation » sont examinées, et seulement sur les comptes que vous voyez.

## 0.3.16 (1er novembre 2026)

### Budget : plusieurs vues des dépenses et des revenus

- Page Budget, nouveau choix **« Affichage »** pour les classements des dépenses et des revenus :
  - **Lignes** : le classement habituel ;
  - **Tableau** : montant, part du total, période précédente, moyenne des 3 précédentes et nombre d'opérations, côte à côte ; on trie en touchant un en-tête, et une catégorie s'ouvre sur ses sous-catégories ;
  - **Camembert** : les 7 plus grosses catégories et « Autres » ; toucher une catégorie montre la répartition de ses sous-catégories, puis leurs opérations ;
  - **Graphique** : l'évolution des 5 principales catégories, une courbe chacune, avec les montants de chaque période au toucher.
- Nouvelle période **Trimestre**, en plus de la semaine, du mois et de l'année. Elle suit le jour de début du mois budgétaire.
- **Sur 6, 12 ou 24 périodes** : le graphique d'évolution et l'historique des revenus et dépenses peuvent couvrir 2 ans de mois, 6 ans de trimestres, etc.

### Budget : gérer une opération sans changer de page

- Dans la liste des opérations d'une catégorie, **toucher une opération ouvre sa fiche**, la même que dans la page Opérations : catégorie, ventilation, règle, abonnement, crédit, pointage, note, factures, corbeille.
- Une fois la fiche fermée, la liste et le budget sont recalculés. Une opération changée de catégorie quitte donc la liste.

## 0.3.15 (31 octobre 2026)

### Factures : photo recadrée comme par un scanner

- Quand on joint une photo (appareil photo ou image), un écran **« Recadrer la facture »** s'ouvre :
  - la feuille est repérée sur la photo ;
  - on fait glisser ses **4 coins** si besoin ;
  - la facture est **redressée** (perspective corrigée) et le reste de la photo est retiré.
- **« Améliorer la lisibilité »** (activé par défaut) : fond blanc, texte foncé.
- Boutons « Toute la photo », « Coins trouvés » et « Garder telle quelle ».
- La facture recadrée est enregistrée en JPEG de 2 000 pixels au plus sur son grand côté : lisible et légère (quelques centaines de Ko au lieu de plusieurs Mo).
- Tout se fait **sur l'appareil**, dans le navigateur : la photo d'origine n'est envoyée nulle part. Les calculs (repérage, redressement, contraste) sont dans le cœur commun et serviront aussi en version autonome.

Les factures sont complètes : jointes, page Factures, noms automatiques, export ZIP, garantie et rappel, envoi par courriel, factures à rattacher et photo recadrée.

## 0.3.14 (31 octobre 2026)

### Factures à rattacher

- Page Factures, **« Ajouter une facture »** (ou « Prendre en photo ») pour une facture dont l'opération n'est pas encore là : pas encore sur le relevé, ou pas encore importée. On peut indiquer le **montant**, la **date** et le **commerçant** ; tout est facultatif.
- OwnCoffer **propose les opérations qui correspondent**, les plus probables en premier : même montant, date proche, commerçant dans le libellé. On peut aussi chercher une opération par son libellé. Rien n'est rattaché sans votre choix.
- Filtre **« À rattacher »** dans la page Factures.
- Dans le détail d'une opération, les **factures en attente qui pourraient être celle-ci** sont proposées, avec un bouton « Rattacher ici » : après un import, on retrouve la facture au bon endroit.
- Tant qu'elle attend, une facture est visible par tous les membres du groupe. Une fois rattachée, elle ne l'est plus que par ceux qui voient le compte de l'opération.
- Le calcul des propositions est fait dans le cœur commun (`shared/`) : il servira aussi en version autonome.

## 0.3.13 (31 octobre 2026)

### Administration du serveur

- Les pages **Membres** et **Sécurité** sont maintenant des onglets de la page d'administration : « Membres du groupe » (membres du groupe ouvert, invitations) et « Ma sécurité » (double authentification). Pour l'administrateur du serveur, les deux boutons de la barre du haut disparaissent.
- Les autres utilisateurs, qui n'ont pas accès à l'administration, gardent ces deux boutons pour gérer leur propre sécurité.
- Santé du serveur : la taille des documents stockés compte maintenant aussi les factures.

## 0.3.12 (31 octobre 2026)

### Corrections

- Administration du serveur : la **durée de fonctionnement** restait toujours proche de zéro, car l'heure de démarrage était relevée au premier affichage de la page et non au démarrage du serveur. Elle est maintenant juste, et s'affiche en heures et minutes pendant le premier jour.

## 0.3.11 (31 octobre 2026)

### Factures

- **Joindre une facture à une opération** : dans le détail d'une opération, « Joindre une facture » (PDF ou image, 10 Mo au plus) ou « Prendre en photo » (sur téléphone, l'appareil photo s'ouvre directement). Les opérations qui ont une facture sont marquées d'un trombone dans la liste.
- **Noms automatiques** tirés de l'opération : `2026-10-31 - DARTY - Lave-linge - 499,00 EUR.pdf`. Une description facultative (« Lave-linge ») s'ajoute au nom.
- **Nouvelle page « Factures »** : recherche, année, filtre « Garantie en cours », ouverture, et **export ZIP** des factures affichées, sous leurs noms.
- **Fin de garantie** : 1, 2, 3 ou 5 ans après l'achat, ou une date au choix. Un **rappel** arrive dans les notifications et par courriel un mois avant la fin.
- **Envoi par courriel** d'une facture en pièce jointe (comptable, service après-vente…), avec un message facultatif. Il faut que le SMTP soit réglé dans `docker/.env` ; 20 envois par jour et par personne au plus.
- Confidentialité : une facture n'est visible que par ceux qui voient le compte de son opération. Elle est cachée tant que l'opération est dans la corbeille, et supprimée si l'opération l'est définitivement. Les factures sont dans la base de données, donc dans les sauvegardes.

À venir : factures « à rattacher » (enregistrées sans opération, avec propositions), puis photo recadrée sur la facture seulement.

## 0.3.10 (31 octobre 2026)

### Administration du serveur : mises à jour

- Nouvel onglet **Mises à jour** :
  - version en service, dernière version publiée et date de la dernière vérification ;
  - interrupteur **« Mises à jour automatiques »**. Désactivées, les nouvelles versions sont signalées et attendent qu'on les installe ;
  - bouton **« Installer vX.Y.Z »**, après confirmation. Le serveur sauvegarde d'abord, installe, vérifie que l'application répond, et sinon revient à la version précédente avec la sauvegarde. Bouton **« Vérifier maintenant »** ;
  - **notes des versions** à venir (dépliées) et installées, tirées du CHANGELOG de la dernière version ;
  - **historique** : installée, retour en arrière, refusée ;
  - une version qui n'a pas démarré est signalée. Elle n'est plus réessayée automatiquement, mais peut être réinstallée à la main.
- Sur le serveur, `docker/auto-update.sh` accepte `--check` et `--install vX.Y.Z`. Il ne tourne qu'en un exemplaire à la fois et s'exécute depuis une copie de lui-même.

L'administration du serveur est complète : santé et chiffres, mises à jour, sauvegardes, utilisateurs, invitations, IP bloquées et journal.

## 0.3.9 (31 octobre 2026)

### Administration du serveur : invitations

- Nouvel onglet **Invitations**, à côté de l'onglet Utilisateurs :
  - toutes les invitations en attente, **de tous les groupes** : adresse, groupe et rôle, qui l'a envoyée, date de fin de validité ;
  - bouton **« Révoquer »** : le lien cesse de marcher ;
  - bouton **« Inviter »** : l'administrateur du serveur peut inviter dans n'importe quel groupe, même un groupe dont il n'est pas membre. La personne reçoit le lien par courriel, valable 7 jours ;
  - liste des groupes du serveur avec leur nombre de membres et de comptes bancaires.
- Les administrateurs de groupe continuent d'inviter depuis la page Membres de leur groupe.

## 0.3.8 (31 octobre 2026)

### Administration du serveur : sauvegardes

- Nouvel onglet **Sauvegardes** :
  - date de la dernière sauvegarde de nuit, en rouge si elle a plus de 36 heures ou si la dernière sauvegarde a échoué (avec la raison) ;
  - bouton **« Sauvegarder maintenant »**, une sauvegarde toutes les 10 minutes au plus ;
  - liste des sauvegardes (de nuit, manuelles, avant mise à jour) avec leur date et leur taille ;
  - comment restaurer : sur le serveur seulement, la commande est donnée.
- Les sauvegardes ne sont ni téléchargeables ni restaurables depuis le web : elles contiennent toutes les données bancaires.
- Sont gardées les 30 dernières de nuit, les 10 dernières manuelles et les 10 dernières d'avant mise à jour, pour que des sauvegardes manuelles ne fassent jamais disparaître celles de nuit.
- **Sur le serveur**, un dossier d'échange `docker/state/` relie l'application aux scripts de l'hôte, sans jamais contenir de données bancaires. Une unité systemd `owncoffer-request.path` exécute aussitôt les demandes de la page. Avec les mises à jour automatiques, l'ensemble s'installe tout seul à la mise à jour suivante ; sinon, relancez `sudo ./docker/install-auto-update.sh`.
- L'utilisateur de l'image a désormais un identifiant fixe (10001), à qui le dossier d'échange appartient.

## 0.3.7 (31 octobre 2026)

### Administration du serveur

- Nouveau bouton **« Administration du serveur »** dans la barre du haut, visible seulement par l'administrateur du serveur.
- **Santé et chiffres** :
  - version installée, durée de fonctionnement, base de données (joignable, taille), place des documents ;
  - dernière vérification des alertes, écart d'horloge, envoi des courriels (SMTP ou journal), avec un bouton « Envoyer un courriel de test ».
  - Chiffres du serveur, sans aucun montant : comptes utilisateurs (double authentification, bloqués), groupes, comptes bancaires, opérations, imports, règles, invitations en attente, et **taux de classement automatique** des 90 derniers jours par rapport à la cible de 70 %.
- **Utilisateurs** : tous les comptes avec leurs groupes et rôles, double authentification, date de création et dernière activité. On peut **bloquer** un compte (il est déconnecté dans les minutes qui suivent et ne peut plus se connecter, rien n'est supprimé) ou le débloquer.
- **IP bloquées** après trop d'échecs de connexion, avec un bouton pour les débloquer.
- **Journal** des 100 dernières actions sensibles : qui, quoi, quand. Le contenu des changements n'est pas montré.
- À venir : les sauvegardes et les mises à jour (automatiques ou non, à la demande, notes de version).

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
