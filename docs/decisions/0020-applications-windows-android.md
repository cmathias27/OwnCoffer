# 0020 — Applications Windows et Android : client du serveur, distribuées hors magasins

**Statut** : Décidé (1er novembre 2026), précise la phase 6 et la décision 0011

## Contexte

L'application web installable (PWA, décision 0011) couvre déjà le téléphone. Une vraie application Windows et Android est demandée, sans attendre le mode hors-ligne : d'abord le même code Flutter, connecté au serveur de l'utilisateur. Pas encore de Play Store ni de certificat de signature de code Windows (payant).

## Décision

1. **Même code que l'application web**, compilé pour Windows (x64) et Android. Ce qui n'existait que dans le navigateur a son équivalent natif : choix de fichiers (`file_selector`), enregistrement (« Enregistrer sous » sur Windows, partage sur Android, `share_plus`), liens (`url_launcher`), lecture des photos (`dart:ui`). Toutes ces bibliothèques sont sous licence BSD-3-Clause.
2. **Adresse du serveur** demandée au premier lancement, vérifiée (le serveur doit répondre comme un serveur OwnCoffer), gardée dans le stockage sécurisé de l'appareil. **HTTPS obligatoire**, sauf sur l'appareil lui-même et le réseau local (serveur d'essai à la maison) ; Android refuse de toute façon le trafic en clair. « Changer de serveur » sur la page de connexion.
3. **Aucune donnée financière gardée sur l'appareil** pour l'instant : comme la PWA, l'application lit tout sur le serveur. Seuls la session et l'adresse du serveur sont stockées, exclues des sauvegardes Android dans le nuage.
4. **Distribution hors magasins** : la CI compile à chaque pull request et attache à chaque version publiée :
   - `owncoffer-X.Y.Z-windows-x64.zip` : dossier à décompresser, `owncoffer.exe`, **non signé** (Windows SmartScreen avertit au premier lancement) ;
   - `owncoffer-X.Y.Z-android.apk` : à installer en autorisant « sources inconnues ». Android exige une signature : l'APK est signé avec la clé du projet si les secrets `ANDROID_KEYSTORE_*` sont configurés dans GitHub, sinon avec une clé de débogage (une nouvelle version ne pourra alors remplacer l'ancienne qu'après désinstallation).
   Leur intégrité se vérifie avec `SHA256SUMS` et les signatures Sigstore de la version (décision 0021).

## Conséquences

- `docs/APPLICATIONS.md` explique l'installation et les avertissements de Windows et d'Android.
- Pas de mise à jour automatique des applications pour l'instant : on télécharge la nouvelle version. Les applications restent compatibles avec un serveur plus récent tant que l'API ne casse pas.
- Restent pour la phase 6 : hors-ligne et synchronisation, page « Télécharger » dans l'application web, mises à jour automatiques, version autonome sans serveur, éventuellement F-Droid ou le Play Store et un certificat Windows.
