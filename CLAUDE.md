# CLAUDE.md — consignes pour Claude Code

## Le projet

OwnCoffer est une application libre (AGPL-3.0) et auto-hébergée de gestion de comptes bancaires : import de relevés (QIF, OFX, CSV), classement par règles (personnelles et communautaires), prévisions de solde, objectifs et alertes, crédits, IA optionnelle au choix de l'utilisateur.

- Ordre de réalisation et tâches : `docs/ROADBOOK.md` (phases 0 à 6, chacune avec un milestone GitHub).
- Fonctionnalités détaillées : `docs/CAHIER_DES_CHARGES.md`.
- Décisions d'architecture : `docs/decisions/` — à respecter ; pour en changer une, écrire une nouvelle décision.

**Phase actuelle : phase 5 terminée (version 1.0 préparée, audit externe à trouver), phase 6 commencée** — applications Windows et Android connectées au serveur, décision 0020 ; version autonome commencée (décision 0022 : serveur embarqué sur SQLite) ; restent sa migration vers un serveur et sa sauvegarde chiffrée, le hors-ligne, l'installation automatique des mises à jour des applications. Continuer à corriger en priorité ce que l'utilisateur remonte de son usage réel (#20).

## Pile technique décidée

- Serveur : **Serverpod** (Dart) — décision 0001. Voir son point de vigilance licence.
- Base : **PostgreSQL**, migrations Serverpod, Row Level Security en seconde barrière.
- Interface : **Flutter web**, installable sur téléphone (PWA, sans cache de données financières) ; applications Windows et Android du même code, connectées au serveur — décisions 0005, 0011 et 0020. Tout code propre au navigateur passe par `app/lib/util/` (versions `_web` et `_io`).
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
- **Sécurité** : toute requête vérifie groupe, rôle et visibilité du compte côté serveur (`Access`) ; **chaque point d'accès qui lit ou modifie des données d'un groupe a un test d'isolation** (un membre d'un autre groupe est refusé, les données restent intactes) — décision 0016, la RLS PostgreSQL étant repoussée avant la bêta. Aucun secret dans le code ; `.env` jamais commité ; clés IA chiffrées, jamais journalisées.
- **Aucune télémétrie**, aucun appel réseau sortant non demandé par l'utilisateur.
- **Bilingue** : aucun texte d'interface en dur, tout passe par les fichiers de traduction FR et EN.
- **Classement** : règles du groupe → règles communautaires → historique → IA (optionnelle, en dernier). L'IA propose, l'utilisateur valide.
- **IA optionnelle** (décision 0006) : chaque fonction doit marcher complètement sans IA ; tous les calculs, prévisions et simulations sont faits par le moteur financier déterministe ; l'IA ne fait qu'appeler ce moteur et expliquer, ne calcule jamais un montant et ne modifie jamais les données. Tests exécutés IA désactivée.
- **Mon conseiller** (décision 0007) : chaque analyse ou recommandation affiche ses données et son calcul ; une information inconnue est signalée, jamais inventée ; l'IA n'accède qu'aux comptes visibles par l'utilisateur, via les fonctions du moteur.
- **Passerelle IA** (décision 0008) : tout appel à une IA passe par la passerelle ; jamais d'appel direct à un fournisseur, jamais de basculement automatique vers un modèle externe ; l'IA lit les données uniquement via les fonctions de contexte en lecture seule.
- **Modifications** (décision 0009) : l'IA et le conseiller produisent des propositions structurées ; seul le service de commandes financières écrit, après validation explicite revérifiée côté serveur, de façon idempotente, en refusant toute proposition dont les données ont changé ; tout est journalisé. Jamais d'opération bancaire réelle.
- **Licences** : toute dépendance ajoutée doit être compatible AGPL-3.0.
- Une seule banque au départ : **Caisse d'Épargne** (décision 0003) ; isoler ses particularités dans un module dédié.

## Instance de l'utilisateur (ne jamais y toucher)

- L'instance réelle tourne dans `/opt/docker/owncoffer` (projet Docker `owncoffer`, port 8095) avec les vraies données bancaires. **Ne jamais** y lancer de commande (`down`, `exec`, `psql`, `restart`, édition de fichiers) ni lire ses données ou ses sauvegardes. Seule la tâche systemd `owncoffer-update` la met à jour, avec les versions publiées.
- Les essais locaux utilisent **toujours** un autre projet : `docker compose -p owncoffer-test --env-file docker/.env.test …` (port 18080) et une image locale `:dev-local`, jamais `docker compose -f docker/compose.yaml` seul (son nom de projet est `owncoffer`).

## Pièges connus (Serverpod 4)

- Un paramètre nommé **avec valeur par défaut** dans un point d'accès devient **obligatoire** côté client : utiliser un type nullable sans valeur par défaut (`bool? x`) et appliquer la valeur par défaut dans le corps.
- Après toute modification de `server/lib` (points d'accès, modèles `.spy.yaml`) : `serverpod generate`, puis `serverpod create-migration` si un modèle de table a changé.
- Version autonome (décision 0022) : le même serveur tourne sur SQLite dans les applications. Après un changement de modèle de table, aussi `./tool/standalone.sh migrations` (la CI le vérifie et lance tous les tests sur SQLite : `./tool/standalone.sh test`). Le SQL écrit à la main doit marcher sur PostgreSQL et SQLite (`server/lib/src/core/portable_sql.dart`).
- `inSet` attend un `Set<T>` explicitement typé (`final Set<int> ids = {...}`).
- Avant chaque push : `./tool/check.sh` (mêmes vérifications que la CI).
- Publier une version : mettre à jour `CHANGELOG.md`, `app/pubspec.yaml` et `OWNCOFFER_TAG` de `docker/.env.example`, puis l'étiquette `vX.Y.Z` sur `main` (la CI publie l'image signée `:X.Y.Z`, les applications, les SBOM et la version GitHub — `docs/PUBLICATION.md`).
- Sauvegardes : ne jamais casser la lecture des anciens formats (`.dump`) ni le retour arrière de `docker/auto-update.sh` ; `tool/test_backup_restore.sh` (Docker requis) les teste de bout en bout.
- Le test `server/test/integration/performance_test.dart` mesure les pages principales sur 100 000 opérations : ne pas charger tout l'historique d'un compte quand une somme SQL suffit.

## Façon de travailler

- Une issue = une branche (`feature/…`, `fix/…`, `docs/…`) = une pull request vers `main`.
- Commits *Conventional Commits*, signés DCO (`git commit -s`).
- Code et commentaires techniques en anglais ; documentation et messages à l'utilisateur en français.
- Tests obligatoires pour : lecture des fichiers bancaires, calculs de montants et de prévisions, permissions.
- Après chaque tâche terminée, cocher la case correspondante dans `docs/ROADBOOK.md` et fermer l'issue liée.
