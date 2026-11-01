# OwnCoffer

**Vos comptes bancaires, chez vous.** Application libre et gratuite de gestion de comptes bancaires, auto-hébergée, pour une personne, un couple ou une famille.

> **Statut : version 1.0** du serveur et de l'application web, premières applications Windows et Android. Installation : [docs/INSTALLATION.md](docs/INSTALLATION.md) ; utilisation : [docs/UTILISATION.md](docs/UTILISATION.md) ; questions : [docs/FAQ.md](docs/FAQ.md) ; nouveautés : [CHANGELOG.md](CHANGELOG.md) ; suite : [roadbook](docs/ROADBOOK.md).

## Ce que fera OwnCoffer

- **Importer** les relevés téléchargés sur le site de sa banque (QIF, OFX, CSV), sans doublons.
- **Classer** les opérations automatiquement grâce à vos règles et à une base de règles partagée par la communauté.
- **Prévoir** le solde à venir, le reste à vivre jusqu'à la prochaine paie, et simuler un achat avant de le faire.
- **Piloter** avec des objectifs par catégorie, des alertes avant dépassement et des graphiques clairs.
- **Suivre** ses crédits (tableau d'amortissement) et ses paiements en plusieurs fois.
- **Lire des documents avec l'IA de votre choix** (en option) : un ticket devient une opération ventilée, une offre de prêt devient un crédit avec son échéancier.
- **Partager** avec son foyer : groupes, rôles, comptes communs ou privés.

## Principes

- **Vos données restent chez vous** : serveur auto-hébergé avec Docker, aucune télémétrie, aucune connexion à votre banque.
- **Libre et gratuit** : licence [AGPL-3.0](LICENSE), sans publicité ni abonnement, soutenu par les dons.
- **Sécurité d'abord** : HTTPS, double authentification, blocage automatique des tentatives d'intrusion, permissions vérifiées jusque dans la base de données.
- **Français et anglais** dès la première version.

## Plateformes

1. **Serveur + application web** — version 1.0.
2. **Applications Windows et Android** — premières versions, sur le même serveur ([docs/APPLICATIONS.md](docs/APPLICATIONS.md)) ; hors-ligne et version autonome ensuite.

## Documentation

| Document | Contenu |
| --- | --- |
| [Roadbook](docs/ROADBOOK.md) | Les phases du projet, étape par étape |
| [Cahier des charges](docs/CAHIER_DES_CHARGES.md) | Toutes les fonctionnalités, l'architecture, le modèle de données |
| [Décisions](docs/decisions/) | Les choix d'architecture et leurs raisons |
| [Catégories standard](docs/CATEGORIES_STANDARD.md) | Le catalogue commun de catégories (FR / EN) |
| [Maquettes](docs/MAQUETTES.md) | Les écrans dessinés et le style retenu |
| [Installation](docs/INSTALLATION.md) | Installer, sauvegarder, mettre à jour le serveur |
| [Utilisation](docs/UTILISATION.md) et [FAQ](docs/FAQ.md) | Se servir de l'application, questions fréquentes |
| [Applications](docs/APPLICATIONS.md) | Installer les applications Windows et Android |
| [Publication](docs/PUBLICATION.md) | Vérifier une version signée, ses composants (SBOM) |
| [Audit de sécurité](docs/AUDIT_SECURITE.md) | Périmètre, revue interne, points ouverts |
| [Aide de l'application](app/assets/help/fr/start.md) | Les pages d'aide affichées dans l'app, une par écran (aussi [en anglais](app/assets/help/en/start.md)) |

## Technologies prévues

Serveur [Serverpod](https://serverpod.dev) (Dart) · PostgreSQL · interface Flutter · Docker · GitHub Actions.

## Contribuer

Les idées et retours sont bienvenus dès maintenant : ouvrez une [issue](../../issues/new/choose). Pour contribuer au code, lisez [CONTRIBUTING.md](CONTRIBUTING.md). Pour signaler une faille de sécurité, suivez [SECURITY.md](SECURITY.md).

---

### English

OwnCoffer is a free, open-source, self-hosted personal finance app: import bank statements (QIF, OFX, CSV), automatic categorisation with community rules, cash-flow forecasts, budget goals and alerts, loans tracking, and optional AI document reading with the provider of your choice. Server + web app at version 1.0, with first Windows and Android apps. Documentation is in French for now; the app is in French and English. Licensed under AGPL-3.0.
