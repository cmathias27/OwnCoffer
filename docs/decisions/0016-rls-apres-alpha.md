# 0016 — Row Level Security repoussée après l'alpha

**Statut** : Décidé (30 octobre 2026)

## Contexte

Le cahier des charges prévoit des permissions à deux niveaux : le serveur vérifie groupe, rôle et visibilité du compte, puis PostgreSQL le revérifie avec la *Row Level Security* (RLS).

Serverpod partage un même pool de connexions entre toutes les requêtes. Pour que PostgreSQL connaisse l'utilisateur de chaque requête, il faudrait :

- un second rôle PostgreSQL, non propriétaire des tables, pour l'exécution (le propriétaire contourne la RLS) ;
- que **chaque** accès à la base passe par une transaction qui déclare d'abord l'utilisateur (`SET LOCAL`) ;
- une voie d'exception pour les tâches internes : migrations, nettoyage, bannissements d'IP.

C'est une refonte de tous les accès à la base, avec un risque de régression réel, alors que la protection est déjà assurée par ailleurs.

## Décision

La RLS n'est **pas** mise en place pour l'alpha. Elle est réévaluée **avant d'ouvrir la bêta à d'autres personnes** (phase 4), en même temps que la question de licence de Serverpod (décision 0001).

En attendant, la protection repose sur :

1. les contrôles du serveur (`Access`), seuls habilités à décider d'un accès, jamais le client ;
2. un **test d'isolation obligatoire** pour chaque point d'accès qui lit ou modifie des données d'un groupe : un membre d'un autre groupe doit recevoir un refus et les données doivent rester intactes ;
3. une base jamais exposée hors du réseau Docker privé (décision 0015).

## Conséquences

- L'issue #38 passe au milestone de la phase 4.
- `CLAUDE.md` impose le test d'isolation pour tout nouveau point d'accès.
- Le roadbook (phase 2) indique que la seconde barrière est repoussée.
