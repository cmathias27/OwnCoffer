# CLAUDE.md — consignes pour Claude Code

## Le projet

OwnCoffer est une application libre (AGPL-3.0) et auto-hébergée de gestion de comptes bancaires : import de relevés (QIF, OFX, CSV), classement par règles (personnelles et communautaires), prévisions de solde, objectifs et alertes, crédits, IA optionnelle au choix de l'utilisateur.

- Ordre de réalisation et tâches : `docs/ROADBOOK.md` (phases 0 à 6, chacune avec un milestone GitHub).
- Fonctionnalités détaillées : `docs/CAHIER_DES_CHARGES.md`.
- Décisions d'architecture : `docs/decisions/` — à respecter ; pour en changer une, écrire une nouvelle décision.

**Phase actuelle : 1 (fondations techniques)**, démarrée à la demande de l'utilisateur le 30 octobre 2026. Le cœur financier (`shared/` : import, doublons, classement, solde prévu) est développé en avance car prioritaire : il doit être fiable avant tout le reste.

**Objectif prioritaire : l'alpha minimale (décision 0010)** — import Caisse d'Épargne, opérations, classement par règles, solde prévu, alerte de découvert. Ne rien ajouter au-delà avant que l'alpha soit utilisée un mois.

## Pile technique décidée

- Serveur : **Serverpod** (Dart) — décision 0001. Voir son point de vigilance licence.
- Base : **PostgreSQL**, migrations Serverpod, Row Level Security en seconde barrière.
- Interface : **Flutter web**, installable sur téléphone (PWA, sans cache de données financières) ; Windows et Android natifs en phase 6 — décisions 0005 et 0011.
- Déploiement : `docker compose` sur un serveur Docker existant, exposé par une redirection **Cloudflare** (HTTPS géré par Cloudflare) ; réseau Docker privé, seul un proxy Caddy publie **un seul port** configurable (app web et API sous `/api/`), PostgreSQL et ports internes jamais publiés ; IP réelle via `CF-Connecting-IP` seulement si la requête vient de Cloudflare ou du connecteur local — décisions 0002, 0012 et 0015.
- CI : GitHub Actions ; image `ghcr.io/cmathias27/owncoffer`.

## Organisation prévue du dépôt (phase 1)

```
server/   API Serverpod
app/      interface Flutter (web pour l'instant)
shared/   modèles de données, lecture des fichiers bancaires (Dart pur, testé)
docker/   docker-compose, .env.example
docs/     cahier des charges, roadbook, décisions
```

## Règles impératives

- **Aucune vraie donnée bancaire** dans le dépôt, les tests, les issues ou les logs. Fixtures uniquement anonymisées, noms de fichiers neutres (jamais de numéro de compte).
- **Montants en centimes** (`int`), jamais en `double`. Dates d'opération sans fuseau.
- **Sécurité** : toute requête vérifie groupe, rôle et visibilité du compte côté serveur ; tester qu'un utilisateur ne peut pas accéder aux données d'un autre groupe. Aucun secret dans le code ; `.env` jamais commité ; clés IA chiffrées, jamais journalisées.
- **Aucune télémétrie**, aucun appel réseau sortant non demandé par l'utilisateur.
- **Bilingue** : aucun texte d'interface en dur, tout passe par les fichiers de traduction FR et EN.
- **Classement** : règles du groupe → règles communautaires → historique → IA (optionnelle, en dernier). L'IA propose, l'utilisateur valide.
- **IA optionnelle** (décision 0006) : chaque fonction doit marcher complètement sans IA ; tous les calculs, prévisions et simulations sont faits par le moteur financier déterministe ; l'IA ne fait qu'appeler ce moteur et expliquer, ne calcule jamais un montant et ne modifie jamais les données. Tests exécutés IA désactivée.
- **Mon conseiller** (décision 0007) : chaque analyse ou recommandation affiche ses données et son calcul ; une information inconnue est signalée, jamais inventée ; l'IA n'accède qu'aux comptes visibles par l'utilisateur, via les fonctions du moteur.
- **Passerelle IA** (décision 0008) : tout appel à une IA passe par la passerelle ; jamais d'appel direct à un fournisseur, jamais de basculement automatique vers un modèle externe ; l'IA lit les données uniquement via les fonctions de contexte en lecture seule.
- **Modifications** (décision 0009) : l'IA et le conseiller produisent des propositions structurées ; seul le service de commandes financières écrit, après validation explicite revérifiée côté serveur, de façon idempotente, en refusant toute proposition dont les données ont changé ; tout est journalisé. Jamais d'opération bancaire réelle.
- **Licences** : toute dépendance ajoutée doit être compatible AGPL-3.0.
- Une seule banque au départ : **Caisse d'Épargne** (décision 0003) ; isoler ses particularités dans un module dédié.

## Façon de travailler

- Une issue = une branche (`feature/…`, `fix/…`, `docs/…`) = une pull request vers `main`.
- Commits *Conventional Commits*, signés DCO (`git commit -s`).
- Code et commentaires techniques en anglais ; documentation et messages à l'utilisateur en français.
- Tests obligatoires pour : lecture des fichiers bancaires, calculs de montants et de prévisions, permissions.
- Après chaque tâche terminée, cocher la case correspondante dans `docs/ROADBOOK.md` et fermer l'issue liée.
