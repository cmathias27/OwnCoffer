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
