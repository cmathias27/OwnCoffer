# 0019 — Sauvegardes chiffrées et restauration testée chaque nuit

**Statut** : Décidé (1er novembre 2026)

## Contexte

Les sauvegardes (`docker/backup.sh`) étaient des copies `pg_dump` en clair, dans `docker/backups/`, lisibles par root seulement. On recommande de les copier ailleurs (disque USB, autre machine, stockage en ligne) : en clair, chaque copie expose toutes les opérations bancaires. Et rien ne vérifiait qu'une sauvegarde se restaure vraiment : on ne le découvre souvent que le jour où on en a besoin.

## Décision

1. **Chiffrement** de chaque sauvegarde avec **gpg**, chiffrement symétrique **AES-256**, intégrité vérifiée à la lecture (une sauvegarde modifiée ou tronquée est refusée). Le fichier devient `owncoffer-<date>-<type>.dump.gpg`.
2. **La clé** est une phrase de passe aléatoire de 48 octets, créée à la première sauvegarde dans `docker/backup.key` (lisible par root seulement, jamais dans git). Elle ne quitte pas le serveur : l'administrateur doit en garder une copie ailleurs (gestionnaire de mots de passe), sans laquelle aucune sauvegarde ne peut être relue. La page d'administration le rappelle.
3. **Jamais de sauvegarde manquée** : si gpg est absent, la sauvegarde est faite en clair et la page d'administration le signale. Une sauvegarde avant mise à jour ne doit jamais être sautée. `OWNCOFFER_BACKUP_ENCRYPT=false` désactive le chiffrement.
4. **Restauration testée automatiquement** chaque nuit après la sauvegarde (`docker/restore-test.sh`) : la dernière sauvegarde est déchiffrée et restaurée dans un conteneur PostgreSQL **jetable, sans réseau**, jamais dans la base réelle ; on compte les tables et les opérations, puis le conteneur est supprimé. Le résultat (un nom de fichier et des nombres, aucune donnée bancaire) s'affiche dans la page d'administration, qui peut aussi demander un test tout de suite.
5. **En intégration continue**, `tool/test_backup_restore.sh` fait tout le parcours sur des données fictives : sauvegarde chiffrée, test de restauration, fichier modifié refusé, mauvaise clé refusée, restauration réelle comme lors d'un retour arrière de mise à jour, sauvegarde sans chiffrement.

gpg plutôt qu'`age` ou `openssl enc` : il est déjà installé sur presque tous les serveurs Debian et Ubuntu, son format est stable depuis des années et vérifie l'intégrité ; `openssl enc` ne le fait pas.

## Conséquences

- Les anciennes sauvegardes `.dump` restent listées, gardées et restaurables ; le retour arrière d'une mise à jour sait lire les deux formats.
- `docker/backup-cat.sh` donne le contenu en clair d'une sauvegarde pour la restaurer à la main (avec `OWNCOFFER_BACKUP_KEY` pour une clé gardée ailleurs, sur une nouvelle machine).
- Les installations existantes reçoivent le test de nuit à la première mise à jour automatique (les unités systemd sont réécrites).
- Perdre `docker/backup.key` rend les sauvegardes illisibles : c'est voulu, et documenté dans `docs/INSTALLATION.md` et la FAQ.
