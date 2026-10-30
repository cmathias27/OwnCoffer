# OwnCoffer — Roadbook serveur et application web

Le serveur et l'application web (installable sur téléphone) passent en premier ; l'alpha est volontairement minimale, puis l'IA arrive en phase 4 — en option : chaque utilisateur décide de la connecter ou non, et l'application est aussi complète sans elle (décision 0006) ; les applications Windows et Android viendront ensuite, sur le même serveur.

- **Six phases jusqu'à la 1.0**, chacune terminée par une validation concrète avant de passer à la suivante.
- **Une version utilisable tôt** : dès la fin de la phase 3, on importe ses vrais relevés Caisse d'Épargne et on voit son solde prévu (version alpha 0.1).
- **Suivi** : chaque phase a son *milestone* GitHub ; les tâches des phases 0 et 1 sont des *issues*. Les cases ci-dessous se cochent au fil de l'avancement.
- **Référence fonctionnelle** : [CAHIER_DES_CHARGES.md](CAHIER_DES_CHARGES.md). **Décisions** : [decisions/](decisions/).

Aucune date n'est fixée : une phase se termine quand sa validation est atteinte.

```mermaid
flowchart TD
  P0["Phase 0 · Préparation et décisions (en cours)"] -->|Décisions écrites, dépôt prêt| P1
  P1["Phase 1 · Fondations techniques"] -->|Le serveur démarre en une commande| P2
  P2["Phase 2 · Utilisateurs et sécurité"] -->|Aucun accès possible d'un groupe à l'autre| P3
  P3["Phase 3 · Alpha : import, classement, solde prévu"] -->|"Alpha 0.1 : utilisée un mois"| P4
  P4["Phase 4 · Prévoir, piloter et IA"] -->|"Bêta 0.5 : un mois géré par quelques testeurs"| P5
  P5["Phase 5 · Exploitation"] -->|"Version 1.0 serveur + web"| P6
  P6["Phase 6 · Applications Windows et Android"]
```

## Décisions déjà prises

| # | Décision | Statut |
| --- | --- | --- |
| [0001](decisions/0001-framework-serveur-serverpod.md) | Framework du serveur : **Serverpod** | Décidé |
| [0002](decisions/0002-hebergement-serveur-docker-existant.md) | Serveur Docker existant, **accessible depuis l'extérieur** | Décidé, précisé par 0012 |
| [0003](decisions/0003-une-seule-banque-au-depart.md) | **Une seule banque** au départ : **Caisse d'Épargne** | Décidé |
| [0004](decisions/0004-licence-agpl.md) | Licence **AGPL-3.0**, gratuit, financé par les dons | Décidé |
| [0005](decisions/0005-interface-flutter-web.md) | Interface web en **Flutter web** | Décidé |
| [0006](decisions/0006-ia-optionnelle.md) | **IA optionnelle** : l'application est aussi complète sans elle | Décidé |
| [0007](decisions/0007-espace-mon-conseiller.md) | Espace **Mon conseiller** : analyses et recommandations suivies | Décidé |
| [0008](decisions/0008-ia-hybride-passerelle.md) | **IA hybride** (locale ou externe) derrière une **passerelle IA** | Décidé |
| [0009](decisions/0009-actions-proposees-validees.md) | **Modifications proposées**, validées par l'utilisateur, exécutées par le moteur | Décidé |
| [0010](decisions/0010-perimetre-alpha.md) | **Alpha minimale** : import, classement, solde prévu, alerte de découvert | Décidé |
| [0011](decisions/0011-application-web-installable-pwa.md) | Application web **installable sur téléphone** (PWA) | Décidé |
| [0012](decisions/0012-exposition-cloudflare-reseau-hote.md) | Exposition par **Cloudflare**, conteneur sur le **réseau de l'hôte**, **un seul port** | Décidé |
| [0013](decisions/0013-licence-regles-communautaires-cc0.md) | Licence **CC0** pour les règles communautaires | Décidé |
| [0014](decisions/0014-cible-classement-automatique-alpha.md) | Cible de classement automatique de l'alpha : **70 %** | Décidé |
| [0015](decisions/0015-reseau-docker-isole-proxy.md) | **Réseau Docker isolé**, proxy Caddy sur le port unique (remplace la partie réseau de 0012) | Décidé |

## Phase 0 — Préparation et décisions *(en cours)*

Objectif : tout décider et tout organiser avant la première ligne de code.

**Décisions**

- [x] Framework du serveur : Serverpod
- [x] Machine de test : serveur Docker existant, accessible depuis l'extérieur
- [x] Périmètre de départ : une seule banque, la Caisse d'Épargne (décision 0003)
- [x] Contenu de l'alpha (décision 0010) et application installable PWA (décision 0011)
- [x] Licence Serverpod : accepter le risque pour l'usage personnel, trancher avant d'ouvrir à d'autres (décision 0001)
- [x] Interface web : Flutter web (décision 0005)
- [x] Accès extérieur : redirection Cloudflare, réseau de l'hôte, un seul port (décision 0012)
- [x] Licence de la base de règles communautaires : CC0 (décision 0013)
- [x] Cible de classement automatique pour l'alpha : 70 % des opérations classées sans intervention (décision 0014)

**Dépôt GitHub**

- [x] `LICENSE` (AGPL-3.0), `README.md`, `CONTRIBUTING.md` (avec DCO), `SECURITY.md`, `CODE_OF_CONDUCT.md`
- [x] Modèles d'issues (bug, idée) et de pull request
- [x] Dossier `docs/` : cahier des charges, roadbook, décisions
- [x] `CLAUDE.md` : consignes pour le développement avec Claude Code
- [x] Milestones par phase, étiquettes, issues des phases 0 et 1
- [x] Protéger la branche `main` (fusion par pull request ; vérifications au vert à ajouter avec la CI)
- [ ] Tableau de suivi GitHub Projects (optionnel, les milestones suffisent au départ)

**Données et maquettes**

- [ ] Exports anonymisés Caisse d'Épargne (QIF, OFX et CSV si disponibles), sur un à trois mois, noms de fichiers neutres
- [x] Maquettes web : connexion, assistant de premier lancement, opérations, import, catégories et règles, réglages IA, administration ([MAQUETTES.md](MAQUETTES.md))
- [x] Catalogue des catégories standard : 17 catégories, 73 sous-catégories, FR et EN ([CATEGORIES_STANDARD.md](CATEGORIES_STANDARD.md))
- [ ] Avis recueillis grâce à la présentation du projet, cahier des charges ajusté

**Validation** : toutes les décisions prises et écrites, dépôt prêt, relevés de test disponibles.

## Phase 1 — Fondations techniques

Objectif : un serveur vide mais complet, qui se lance en une commande et se teste automatiquement à chaque modification.

- [x] Organisation du code en un seul dépôt : `server/` (Serverpod), `app/` (Flutter, web pour l'instant), `shared/` (modèles et lecture des fichiers bancaires), `docker/`, `docs/`
- [x] `docker/compose.yaml` : réseau Docker privé, **un seul port** configurable publié par un proxy Caddy (app web et API sous `/api/`), PostgreSQL et ports internes jamais publiés ; volume de données ; `.env.example` commenté et générateur de secrets ; démarrage par `docker compose up -d` (décisions 0012 et 0015)
- [x] Base de données v1 avec migrations : utilisateurs, sessions, groupes, membres, comptes, opérations, catégories, catégories standard, règles, imports, journal d'audit
- [x] Montants en centimes (entiers) partout, dates d'opération sans fuseau
- [ ] Intégration continue GitHub Actions : analyse, formatage, tests, image Docker `ghcr.io/cmathias27/owncoffer:edge`
- [ ] Sécurité automatique : Dependabot, CodeQL, vérification des licences des dépendances
- [ ] Page d'état minimale : version, connexion à la base, espace disque
- [x] Bilingue dès le départ : textes de l'interface dans des fichiers de traduction FR et EN
- [x] Application web installable (PWA) : manifeste, icônes, écran d'accueil Android ; aucune donnée financière mise en cache sur l'appareil (décision 0011)

**Validation** : sur le serveur, `docker compose up -d` affiche la page d'accueil web et une page d'état au vert ; la CI est verte sur `main`.

## Phase 2 — Utilisateurs et sécurité

Objectif : se connecter en sécurité, créer des groupes, inviter des membres ; personne ne voit les données d'un autre groupe.

- [x] Assistant de premier lancement : compte administrateur du serveur et premier groupe (côté serveur ; écrans à venir)
- [ ] Connexion email et mot de passe (Argon2), sessions, déconnexion de tous les appareils
- [x] Double authentification TOTP, avec codes de secours (côté serveur ; écrans à venir)
- [x] Blocage automatique des IP (5 échecs en 15 minutes, durée doublée à chaque récidive) et limite de requêtes
- [x] Groupes, rôles (admin, user, lecteur) et invitations par lien expirant (côté serveur ; écrans à venir)
- [ ] Permissions à deux niveaux : serveur (fait, testé) puis PostgreSQL (RLS)
- [x] Journal d'audit des actions sensibles (écriture ; consultation à venir)
- [x] Accès extérieur par Cloudflare (HTTPS géré par Cloudflare) : vraie adresse IP lue dans `CF-Connecting-IP` uniquement si la requête vient de Cloudflare ou du connecteur local, pour que le blocage des IP fonctionne ; option Cloudflare Access en protection supplémentaire (décision 0012)

**Validation** : des tests automatiques prouvent qu'un utilisateur ne peut jamais lire ni modifier les données d'un autre groupe ; une tentative de force brute est bloquée.

## Phase 3 — Alpha : import, classement et solde prévu

Objectif : la plus petite version utile, pour votre usage personnel (décision 0010). Fin de phase = **alpha 0.1**, utilisée un mois avant d'ajouter quoi que ce soit.

- [ ] Comptes bancaires : création, solde initial, visibilité
- [ ] Lecture des exports **Caisse d'Épargne** (format « Money » QIF d'abord, puis OFX et CSV si proposés) dans un module dédié de `shared/`, testée sur les relevés anonymisés et sur des fichiers mal formés (accents, virgule décimale, dates françaises)
- [ ] Écran d'import : aperçu, compte reconnu, doublons écartés par empreinte, historique, annulation
- [ ] Liste des opérations : recherche, filtres, saisie manuelle, pointage
- [ ] Libellés nettoyés (« PRLV SEPA EDF SA REF… » devient « EDF »)
- [ ] Classement : catégories reliées au catalogue standard, règles du groupe, historique, source de la catégorie affichée
- [ ] Règles communautaires v0 : dépôt séparé `owncoffer-rules`, premières règles pour les libellés Caisse d'Épargne des grandes enseignes
- [ ] Opérations prévues récurrentes (loyer, salaire, abonnements) et **solde prévu** à 30 jours
- [ ] **Alerte de découvert prévu**, dans l'app et par email

**Validation** : trois mois de relevés Caisse d'Épargne importés sans doublon ni erreur de montant ; la cible de classement automatique est atteinte ; l'alpha est utilisée un mois.

## Phase 4 — Prévoir, piloter et IA

Objectif : voir l'avenir de ses comptes, être prévenu à temps, et brancher l'IA en option. Fin de phase = **bêta 0.5**.

**Compléments du cœur**

- [ ] Import groupé, ventilation, corbeille, testeur de règles
- [ ] Solde de contrôle et détection des frais bancaires
- [ ] Rapprochement automatique des opérations prévues, reste à vivre, dépenses variables, calendrier des échéances
- [ ] Moteur de simulation (sans IA) : simulateur d'achat (solde à une date choisie, point bas, comptant / en plusieurs fois / plus tard) et scénarios comparés côte à côte
- [ ] Analyses calculées (sans IA) : évolutions par catégorie, hausses et anomalies chiffrées, objectifs suggérés d'après les 3 à 6 derniers mois, fiabilité des prévisions affichée
- [ ] Objectifs par catégorie, alertes à 80 %, 100 % et anticipée ; réglages des notifications
- [ ] Tableau de bord et graphiques
- [ ] Crédits avec tableau d'amortissement, paiements en plusieurs fois
- [ ] Revue de fin de mois et détection d'anomalies
- [ ] Onglet Feedback

**Conseiller et IA**

- [ ] Circuit des modifications proposées (décision 0009) : service de propositions, service de validation, service de commandes financières ; idempotence, refus des propositions périmées, journal d'audit, annulation possible
- [ ] Espace **Mon conseiller** (sans IA) : cartes surveiller / anticiper / conseiller / accompagner calculées par le moteur, acceptées, refusées ou ignorées, suivies et justifiées
- [ ] Passerelle IA (décision 0008) : interface commune, choix du fournisseur et du modèle par utilisateur, capacités par modèle, aucun basculement automatique vers l'externe, affichage de ce qui quitte le serveur ; clé chiffrée, plafond mensuel
- [ ] Premiers connecteurs : un externe (compatible API OpenAI) et un local (Ollama)
- [ ] Fonctions de contexte financier en lecture seule (`get_account_overview`, `get_transactions`, `get_budget_status`, `get_upcoming_expenses`, `get_cashflow_forecast`, `get_financial_goals`), limitées aux comptes visibles
- [ ] Catégorisation d'appoint par l'IA, avec la règle suggérée
- [ ] Lecture de documents : tickets (sans IA : saisie assistée ; avec IA : ventilation ligne par ligne), offres de prêt et confirmations de paiement fractionné (avec IA)
- [ ] Assistant IA (en option) : interroge le moteur, explique, pose les scénarios en langage naturel ; mémoire des préférences, historique des conseils, sources affichées, analyse contestable
- [ ] Licence Serverpod clarifiée avant d'ouvrir la bêta à d'autres personnes (décision 0001)

**Validation** : un mois complet géré dans OwnCoffer par deux ou trois testeurs, dont au moins un **sans IA** ; les prévisions à 30 jours restent proches du solde réel.

## Phase 5 — Exploitation et version 1.0

Objectif : un serveur qu'on installe, sauvegarde et met à jour sans y penser. Fin de phase = **1.0 serveur + web**.

- [ ] Sauvegardes chiffrées chaque nuit et avant chaque mise à jour, restauration testée automatiquement
- [ ] Service de mise à jour (Stable et Bêta), notification à l'admin, retour arrière en cas d'échec
- [ ] Console d'administration : utilisateurs, sessions, IP bloquées, retours, état du serveur
- [ ] Mode démo et export complet des données (JSON, CSV)
- [ ] Traductions FR et EN complètes, accessibilité, rapidité avec 100 000 opérations
- [ ] Documentation : installation, utilisation, FAQ
- [ ] Publication signée, notes de version, liste des composants (SBOM)
- [ ] Audit de sécurité externe si possible

**Validation** : une personne extérieure installe OwnCoffer seule en moins de 30 minutes ; une mise à jour et une restauration réussissent sans intervention.

## Ensuite

**Phase 6 — Applications Windows et Android natives** (Android est déjà couvert entre-temps par l'application web installable) : même code Flutter connecté au serveur, hors-ligne et synchronisation, page « Télécharger », mises à jour automatiques, puis version autonome sans serveur.

Les autres fonctionnalités du cahier des charges marquées « Après 1.0 » s'ajouteront une par une, selon les avis des utilisateurs.
