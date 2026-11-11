# 0033 — Chiffrement du fichier de base de données en mode autonome

**Statut** : Décidé (11 novembre 2026), mis en œuvre en 1.18.0

## Contexte

Le mode autonome (décision [0022](0022-version-autonome-serveur-embarque.md)) fait tourner le serveur OwnCoffer directement sur SQLite dans les applications Windows et Android. Le cahier des charges exige une base SQLite chiffrée sur l'appareil.

La décision 0022 laissait ce point ouvert : Serverpod ouvre la base lui-même sans API pour lui transmettre une clé de chiffrement (SQLCipher ou SQLite3 Multiple Ciphers). La sécurité de repos reposait jusqu'ici sur le dossier privé de l'application (chiffré par Android avec l'appareil ; sous Windows dans le profil utilisateur, dépendant de BitLocker).

## Décision

1. **Moteur : SQLite3 Multiple Ciphers (sqlite3mc).**
   Le paquet `package:sqlite3` (3.8.0) permet de remplacer le binaire SQLite précompilé par SQLite3 Multiple Ciphers (version 2.6.1, licence MIT) via le hook `pubspec.yaml` :
   ```yaml
   hooks:
     user_defines:
       sqlite3:
         source: sqlite3mc
   ```
   Ce hook télécharge et intègre les binaires précompilés officiels de package:sqlite3 pour chaque plateforme cible, vérifiés par leurs sommes SHA-256 publiées.
2. **Partage du pool de connexions avec Serverpod.**
   Serverpod ouvre la base via `SqlitePoolManager` de `serverpod_database`, qui s'appuie sur `sqlite_async` et `sqlite3_connection_pool`. Ce dernier maintient un pool unique par chemin de fichier et par processus.
   Avant que Serverpod ne démarre, le serveur embarqué ouvre un pool avec une fabrique personnalisée (`NativeSqliteOpenFactory`) qui injecte `PRAGMA hexkey = '<clé>'` sur chaque connexion avant toute lecture. Lorsque Serverpod appelle ensuite `SqliteDatabase(path: ...)`, il reçoit les connexions déjà authentifiées.
3. **Clé de chiffrement.**
   - 32 octets aléatoires sécurisés (`Random.secure()`), encodés en 64 caractères hexadécimaux minuscules.
   - **Sous Windows** : la clé est stockée dans le magasin d'identifiants sécurisé du système d'exploitation via `flutter_secure_storage` (Credential Manager / DPAPI). Elle n'est jamais écrite dans un fichier du profil utilisateur.
   - **Sous Android** : le dossier privé de l'application est déjà chiffré matériellement au repos par le système de fichiers chiffré d'Android (File-Based Encryption) lié au verrouillage de l'appareil. Aucune clé logicielle supplémentaire n'y est requise, évitant tout risque de désynchronisation de clé lors des sauvegardes ou restaurations système.
4. **Chiffrement transparent d'une base existante.**
   Au démarrage, l'état du fichier est inspecté :
   - Fichier absent ou vide : initialisation normale avec la clé.
   - Fichier débutant par `'SQLite format 3\u0000'` (base d'une version antérieure ou issue d'une restauration) : le fichier est chiffré sur place avant de lancer Serverpod (`PRAGMA journal_mode = DELETE` pour résorber le journal WAL, puis `PRAGMA hexrekey = '<clé>'`).
   - Fichier déjà chiffré : ouverture directe avec la clé.
5. **Sauvegardes et portabilité.**
   Lors d'une sauvegarde locale ou vers un dossier (`backupTo`) :
   - Une copie cohérente est produite par `VACUUM INTO '<copie>'` (cette copie est temporairement chiffrée avec la même clé).
   - Le fichier copié est immédiatement déchiffré (`PRAGMA journal_mode = DELETE` puis `PRAGMA rekey = ''`).
   - Le fichier SQLite standard en clair obtenu est ensuite scellé et chiffré par la phrase secrète de l'utilisateur (décisions 0019 et 0022).
   Les sauvegardes restent ainsi strictement portables (restaurables sur un autre PC, un téléphone ou importables vers un serveur PostgreSQL). Lors de la restauration, la base restaurée en clair est chiffrée avec la clé locale de la machine cible dès le prochain démarrage.
6. **Perte de clé (clé introuvable ou invalide).**
   Si la base est chiffrée mais que la clé est introuvable (réinitialisation des identifiants Windows, copie manuelle du dossier de données sur un autre PC) :
   - L'application ne touche jamais au fichier et lève `DatabaseKeyLostException`.
   - L'écran d'erreur explique la situation et propose l'action **« Repartir de zéro »**.
   - Cette action renomme `owncoffer.db` (et ses fichiers associés `-wal` et `-shm`) en `owncoffer-locked-<timestamp>.db*` sans jamais rien supprimer, puis relance le démarrage sur une base neuve prête pour une restauration.
7. **Licence et mention légale.**
   SQLite3 Multiple Ciphers est sous licence MIT (Copyright (c) 2019-2026 Ulrich Telle), enregistrée dans `LicenseRegistry` de l'application, compatible avec la licence AGPL-3.0 d'OwnCoffer.

## Conséquences

- Les données financières sur disque en mode autonome sous Windows sont chiffrées (AES-256) et protégées même en cas de vol du disque sans mot de passe Windows.
- La chaîne Docker et le serveur PostgreSQL restent inchangés (ils n'utilisent pas SQLite3MC).
- La migration depuis une version précédente se fait sans action requise de l'utilisateur.
