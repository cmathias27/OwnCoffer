# OwnCoffer

**Vos comptes bancaires, chez vous.** Application libre et gratuite de gestion de comptes bancaires, auto-hébergée, pour une personne, un couple ou une famille.

> **Statut : en conception.** Aucun code n'est encore publié. Le projet avance phase par phase, voir le [roadbook](docs/ROADBOOK.md).

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

1. **Serveur + application web** — en premier.
2. **Applications Windows et Android** — ensuite, sur le même serveur, puis en version autonome.

## Documentation

| Document | Contenu |
| --- | --- |
| [Roadbook](docs/ROADBOOK.md) | Les phases du projet, étape par étape |
| [Cahier des charges](docs/CAHIER_DES_CHARGES.md) | Toutes les fonctionnalités, l'architecture, le modèle de données |
| [Décisions](docs/decisions/) | Les choix d'architecture et leurs raisons |
| [Catégories standard](docs/CATEGORIES_STANDARD.md) | Le catalogue commun de catégories (FR / EN) |
| [Maquettes](docs/MAQUETTES.md) | Les écrans dessinés et le style retenu |

## Technologies prévues

Serveur [Serverpod](https://serverpod.dev) (Dart) · PostgreSQL · interface Flutter · Docker · GitHub Actions.

## Contribuer

Les idées et retours sont bienvenus dès maintenant : ouvrez une [issue](../../issues/new/choose). Pour contribuer au code, lisez [CONTRIBUTING.md](CONTRIBUTING.md). Pour signaler une faille de sécurité, suivez [SECURITY.md](SECURITY.md).

---

### English

OwnCoffer is a free, open-source, self-hosted personal finance app: import bank statements (QIF, OFX, CSV), automatic categorisation with community rules, cash-flow forecasts, budget goals and alerts, loans tracking, and optional AI document reading with the provider of your choice. Server + web app first, then Windows and Android. The project is in its design phase; documentation is in French for now, and the app will ship in French and English. Licensed under AGPL-3.0.
