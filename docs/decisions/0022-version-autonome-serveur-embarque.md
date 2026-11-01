# 0022 — Version autonome : le serveur OwnCoffer embarqué dans l'application, sur SQLite

**Statut** : Décidé (1er novembre 2026), précise le cahier des charges (« Version autonome ») et la décision 0020

## Contexte

Le cahier des charges prévoit des applications Windows et Android qui fonctionnent **seules**, sans serveur ni Docker, pour une personne sur un seul appareil, avec une base SQLite et le même modèle de données que le serveur ; et un passage ensuite au mode serveur sans rien perdre.

Il imaginait pour cela « une couche d'accès aux données commune, avec une version locale et une version serveur ». Or toute la logique est dans le serveur : environ 200 fonctions de points d'accès, les droits, le classement, les prévisions, les crédits, l'IA. Les réécrire en local, c'était des mois de travail et deux versions à maintenir.

Serverpod 4 sait faire tourner un serveur sur **SQLite** au lieu de PostgreSQL (un seul type de base par projet), et le serveur Dart démarre dans une application Flutter sur Windows et Android.

## Décision

1. **La version autonome est le vrai serveur OwnCoffer, embarqué dans l'application**, sur un fichier SQLite du dossier privé de l'application (`server/lib/embedded.dart`). Mêmes points d'accès, même moteur, mêmes tests : rien n'est réécrit.
2. **Au premier lancement**, l'application propose « Utiliser seul sur cet appareil » ou « Se connecter à un serveur ». En mode autonome :
   - le serveur démarre dans l'application, sur un port local choisi au hasard ; **toute requête qui ne vient pas de l'appareil lui-même est refusée** (Serverpod écoute sur toutes les interfaces, sans option pour se limiter à l'appareil) ;
   - ses secrets sont créés au premier lancement, dans le dossier privé de l'application, et n'en sortent jamais ;
   - **un compte local** est créé, sans mot de passe ni courriel puisque personne d'autre ne peut joindre ce serveur. Il est administrateur de ses données, comme le propriétaire d'un serveur Docker. L'application lui ouvre une session à chaque démarrage et crée son premier groupe, « Mes comptes ».
3. **Un seul schéma, deux bases** : `tool/standalone.sh migrations` génère les migrations SQLite (`server/standalone/migrations`) à partir des mêmes modèles, ainsi que leur copie embarquée dans l'application. La CI vérifie qu'elles sont à jour, puis **exécute tous les tests du serveur aussi sur SQLite**. Le peu de SQL écrit à la main est compatible avec les deux bases (`portable_sql.dart`).
4. **Passer au mode serveur**, puis éventuellement revenir : par l'export JSON complet (phase 5), importé dans un nouveau groupe du serveur cible, factures et documents compris. C'est la prochaine étape.
5. **Sauvegardes du mode autonome** : un export chiffré automatique vers un dossier, l'étape d'après.

## Conséquences

- L'APK passe d'environ 28 à 37 Mo et le zip Windows de 14 à 17 Mo. La version web ne contient pas le serveur (import conditionnel).
- Les fonctions propres à un serveur partagé restent visibles mais ont peu d'usage en mode autonome : invitations, sauvegardes et mises à jour de l'hôte. « Donner un avis » ouvre une issue GitHub, puisque l'administrateur, c'est soi-même. « Changer de mode » remplace « Se déconnecter » ; les données restent sur l'appareil.
- Après toute modification d'un modèle de table : `serverpod create-migration` **et** `./tool/standalone.sh migrations`.
- **Point ouvert : le chiffrement du fichier SQLite.** Serverpod ouvre la base lui-même, sans moyen de lui passer une clé (SQLCipher ou SQLite3MultipleCiphers). En attendant, la base est protégée par le dossier privé de l'application (Android le chiffre avec l'appareil ; sous Windows, il est dans le profil de l'utilisateur, à protéger par BitLocker). Les sauvegardes qui quittent l'appareil seront chiffrées.
