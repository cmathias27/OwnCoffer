# Développer OwnCoffer

## Organisation du dépôt

| Dossier | Contenu |
| --- | --- |
| `shared/` | Cœur en Dart pur : montants, lecture des fichiers bancaires, classement, prévisions. Aucune entrée-sortie, entièrement testé. |
| `server/` | Serveur Serverpod : API, base PostgreSQL, migrations. |
| `client/` | Client Dart **généré** par Serverpod (`serverpod generate`) — ne pas modifier à la main. |
| `app/` | Interface Flutter (web pour l'instant). |
| `docker/` | Fichiers Docker : bases de développement, et plus tard déploiement. |
| `tool/` | Scripts de développement. |

Les quatre paquets forment un *workspace* Dart : un seul `flutter pub get` à la racine suffit.

## Prérequis

- Flutter (canal stable), qui fournit Dart
- Serverpod CLI : `dart pub global activate serverpod_cli`
- Docker et `docker compose`

## Premier lancement

```sh
flutter pub get
./tool/setup_dev.sh          # crée server/config/passwords.yaml et lance les bases de dev et de test
cd server
serverpod generate           # après chaque modification des modèles .spy.yaml
dart bin/main.dart --apply-migrations
```

Les bases de développement écoutent uniquement sur `127.0.0.1` (ports 8090 et 9090) et ne servent qu'au développement.

## Tests

```sh
cd shared && dart test       # cœur : montants, import, classement, prévisions
cd server && dart test       # serveur, avec la base de test
```

Avant de pousser, `./tool/check.sh` refait toutes les vérifications de la CI (code généré à jour, formatage, analyse, tests).

D'autres vérifications tournent dans la CI :

```sh
./tool/test_backup_restore.sh   # sauvegarde chiffrée et restauration (Docker, données fictives)
```

`server/test/integration/performance_test.dart` insère 100 000 opérations fictives et affiche le temps des pages principales (`[perf] …`) ; il échoue si l'une devient trop lente.

## Applications Windows et Android

Même code que l'application web (décision 0020). Ce qui dépend du navigateur passe par `app/lib/util/`, avec une version `_web` et une version `_io` (Windows, Android) choisies à la compilation.

```sh
cd app
flutter run -d windows                                   # sous Windows
flutter build apk --release                              # Android (SDK Android requis)
flutter run --dart-define=SERVER_URL=http://10.0.2.2:8080/api/   # émulateur Android, serveur local (HTTP en débogage seulement)
```

La CI compile les deux à chaque pull request (artefacts `owncoffer-android` et `owncoffer-windows`) : voir [APPLICATIONS.md](APPLICATIONS.md).

## Version autonome (serveur sur SQLite)

Les applications Windows et Android embarquent le serveur sur SQLite (décision 0022). Serverpod n'accepte qu'un type de base par projet : `tool/standalone.sh` remplace le temps d'une commande les configurations et les migrations par celles de SQLite, puis remet tout en place.

```sh
./tool/standalone.sh migrations   # après un changement de modèle de table
./tool/standalone.sh test         # tous les tests du serveur, sur SQLite
```

