# 0001 — Framework du serveur : Serverpod

**Statut** : Décidé (30 octobre 2026)

## Contexte

L'application cliente est écrite en Flutter (web d'abord, puis Windows et Android). Le serveur doit gérer PostgreSQL, les migrations, l'authentification, le temps réel et se déployer avec Docker. Options étudiées : Serverpod, Dart Frog, un autre langage (Python, Node).

## Décision

Le serveur est écrit en Dart avec **Serverpod**.

## Conséquences

- Un seul langage (Dart) pour le serveur et l'application ; code client généré automatiquement.
- ORM, migrations, authentification, flux temps réel et base locale côté client fournis par le framework.
- Déploiement Docker auto-hébergé, sans dépendance à un service cloud.
- **Point de vigilance licence** : les paquets Serverpod sont sous BSD-3, sauf le paquet principal `serverpod` sous SSPL. Avant la première publication, vérifier que distribuer OwnCoffer (AGPL-3.0) avec ce paquet ne pose pas de problème ; en cas de doute, prévoir l'option Dart Frog. Ne pas proposer OwnCoffer comme service cloud hébergé tant que ce point n'est pas éclairci.
- **Choix retenu (30 octobre 2026)** : le risque est accepté pour l'usage personnel ; la question est posée à l'équipe Serverpod en parallèle et doit être tranchée **avant d'ouvrir la bêta à d'autres personnes** (phase 4).
