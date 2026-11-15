# OwnCoffer

**Vos comptes bancaires, chez vous.** Application libre et gratuite de gestion de comptes bancaires, auto-hébergée, pour une personne, un couple ou une famille.

> **Statut : version 1.37** — serveur et application web stables depuis la 1.0, applications Windows et Android connectées au serveur ou **autonomes** (sans serveur). Installation : [docs/INSTALLATION.md](docs/INSTALLATION.md) ; applications : [docs/APPLICATIONS.md](docs/APPLICATIONS.md) ; utilisation : [docs/UTILISATION.md](docs/UTILISATION.md) ; questions : [docs/FAQ.md](docs/FAQ.md) ; nouveautés : [CHANGELOG.md](CHANGELOG.md) ; suite : [roadbook](docs/ROADBOOK.md).

## Ce que fait OwnCoffer

- **Importer** les relevés téléchargés sur le site de sa banque (QIF, OFX, CSV), sans doublons, avec aperçu et annulation.
- **Classer** les opérations automatiquement : vos règles, puis une base de règles partagée par la communauté, puis l'historique ; l'IA (en option) ne vient qu'en dernier et propose, vous validez.
- **Prévoir** le solde à venir, le reste à vivre jusqu'à la prochaine paie, et simuler un achat avant de le faire ; récapitulatif mensuel et clôture des mois.
- **Piloter** avec des objectifs par catégorie, des alertes avant dépassement ou découvert, des graphiques (répartition, comparaison, tendances) et un **accueil en widgets** placés librement.
- **Suivre** ses crédits (tableau d'amortissement lu en entier, pause d'échéances, remboursement anticipé avec indemnité), ses paiements en plusieurs fois, ses abonnements et leurs hausses de prix, et les cartes à débit différé.
- **Épargner et voir loin** : projets d'épargne, dépenses lissées, patrimoine net, livrets réglementés, bilan de l'année.
- **Garder ses justificatifs** : tickets scannés et lus sur l'appareil (sans IA), recadrés automatiquement, transformés en opération ; factures et documents de crédit lus par l'IA de votre choix si vous l'activez.
- **Partager** avec son foyer : groupes, rôles, comptes communs ou privés, dépenses à plusieurs et pot commun au prorata des revenus.
- **Être accompagné** par Pépite, la mascotte (badges, défis du mois), et par Mon conseiller, dont chaque analyse montre ses données et son calcul.

## Principes

- **Vos données restent chez vous** : serveur auto-hébergé avec Docker, ou application autonome sur votre appareil ; aucune télémétrie, aucune connexion à votre banque.
- **L'IA est optionnelle** : tout fonctionne sans elle ; tous les montants sont calculés par un moteur déterministe ; l'IA de votre choix (Claude, OpenAI, Gemini, Ollama ou compatible) explique et propose, sans jamais modifier vos données sans validation.
- **Libre et gratuit** : licence [AGPL-3.0](LICENSE) avec une [exception pour Serverpod](LICENSE-EXCEPTION.md), sans publicité ni abonnement, soutenu par les dons.
- **Sécurité d'abord** : HTTPS, double authentification, verrouillage par empreinte sur téléphone, blocage automatique des tentatives d'intrusion, permissions vérifiées côté serveur et testées pour chaque point d'accès, sauvegardes chiffrées, versions signées.
- **Français et anglais**, accessibilité (texte agrandi à 200 %, lecteurs d'écran).

## Plateformes

| Plateforme | État |
| --- | --- |
| **Serveur + application web** (Docker, installable sur téléphone) | Stable depuis la 1.0, mises à jour automatiques avec retour arrière |
| **Windows et Android, connectés au serveur** | Disponibles, consultation et saisie hors ligne |
| **Windows et Android, autonomes** | Disponibles : serveur embarqué, base chiffrée, sauvegarde chiffrée vers un dossier |

Chaque version publie l'image Docker signée, l'application Windows (zip) et l'APK Android : voir [Publication](docs/PUBLICATION.md).

## Documentation

| Document | Contenu |
| --- | --- |
| [Installation](docs/INSTALLATION.md) | Installer, sauvegarder, mettre à jour le serveur |
| [Applications](docs/APPLICATIONS.md) | Installer les applications Windows et Android, mode autonome |
| [Utilisation](docs/UTILISATION.md) et [FAQ](docs/FAQ.md) | Se servir de l'application, questions fréquentes |
| [Aide de l'application](app/assets/help/fr/start.md) | Les pages d'aide affichées dans l'app, une par écran (aussi [en anglais](app/assets/help/en/start.md)) |
| [Démo](docs/DEMO.md) | Essayer OwnCoffer avec des données fictives |
| [Roadbook](docs/ROADBOOK.md) | Les phases du projet, ce qui est fait et ce qui reste |
| [Cahier des charges](docs/CAHIER_DES_CHARGES.md) | Toutes les fonctionnalités, l'architecture, le modèle de données |
| [Décisions](docs/decisions/) | Les choix d'architecture et leurs raisons |
| [Catégories standard](docs/CATEGORIES_STANDARD.md) | Le catalogue commun de catégories (FR / EN) |
| [Publication](docs/PUBLICATION.md) | Vérifier une version signée, ses composants (SBOM) |
| [Audit de sécurité](docs/AUDIT_SECURITE.md) | Périmètre, revue interne, points ouverts |
| [Développement](docs/DEVELOPPEMENT.md) | Préparer son poste, lancer les tests |

## Technologies

Serveur [Serverpod](https://serverpod.dev) (Dart) · PostgreSQL (SQLite chiffrée en mode autonome) · interface Flutter (web, Windows, Android) · Docker et Caddy · GitHub Actions, Sigstore.

## Contribuer

Les idées et retours sont bienvenus : ouvrez une [issue](../../issues/new/choose). Pour contribuer au code, lisez [CONTRIBUTING.md](CONTRIBUTING.md). Pour signaler une faille de sécurité, suivez [SECURITY.md](SECURITY.md).

---

### English

OwnCoffer is a free, open-source, self-hosted personal finance app: import bank statements (QIF, OFX, CSV), automatic categorisation with community rules, cash-flow forecasts, budget goals and alerts, a free-form widget home screen, loans (full amortisation schedules, early repayment), subscriptions, savings projects and net worth, shared household expenses, on-device receipt scanning, and optional AI document reading with the provider of your choice — every amount is computed by a deterministic engine, never by the AI. Runs as a Docker server with a web app, or as Windows and Android apps connected to the server or fully standalone (embedded server, encrypted database). Documentation is in French for now; the app is in French and English. Licensed under AGPL-3.0 with an [additional permission for Serverpod](LICENSE-EXCEPTION.md).
