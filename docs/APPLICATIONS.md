# Applications Windows et Android

## Deux façons de les utiliser

- **Seul sur cet appareil** (décision 0022) : pour une personne, sans serveur. Le serveur OwnCoffer tourne dans l'application ; vos données restent dans son dossier privé, et seul cet appareil peut y accéder. Rien d'autre à installer.
- **Avec un serveur** : pour un foyer ou plusieurs appareils, connecté à votre serveur OwnCoffer (Docker), comme la version web.

Le choix se fait au premier lancement ; « Changer de mode » (menu du compte) y revient sans rien effacer.

**Passer du mode autonome à un serveur** : page « Exporter mes données » → **« Migrer vers un serveur »**. Saisissez l'adresse du serveur et connectez-vous avec son compte d'administrateur ; tout est envoyé, factures et documents compris, dans un nouveau groupe dont vous devenez l'administrateur. Ensuite, « Utiliser maintenant le serveur ». Les données restent aussi sur l'appareil.

**Sauvegardes du mode autonome** : page « Exporter mes données » → **« Sauvegardes de l'appareil »**. Choisissez une phrase de passe (12 caractères au moins, à noter dans un gestionnaire de mots de passe) et, sous Windows, un dossier : un dossier Nextcloud ou OneDrive en garde une copie hors de l'appareil. Une sauvegarde chiffrée y est écrite chaque jour, et les 10 dernières sont gardées. Sous Android, elles vont dans `Android/data/org.owncoffer.app/files/backups` ; « Partager la dernière sauvegarde » en envoie une copie où vous voulez. **« Restaurer une sauvegarde »** remet tout, sur cet appareil ou un nouveau, en mode autonome.

**Revenir d'un serveur vers l'appareil** : sur le serveur, « Exporter mes données » (JSON complet) ; sur l'appareil en mode autonome, « Importer un export ». Les fichiers des factures ne font pas partie de l'export JSON.

Les applications Windows et Android sont la même application que la version web, connectée à **votre** serveur OwnCoffer (décision 0020). Avec un serveur, elles ne gardent sur l'appareil que l'adresse du serveur et votre session : vos opérations restent sur le serveur.

Le plus simple : dans l'application web, menu du compte → **« Applications »**. La page propose les deux fichiers dans la version de votre serveur. Ils sont aussi joints à chaque version, sur la page **Releases** du dépôt GitHub :

| Fichier | Pour |
| --- | --- |
| `owncoffer-X.Y.Z-windows-x64.zip` | Windows 10 et 11, 64 bits |
| `owncoffer-X.Y.Z-android.apk` | Android 7 ou plus récent |

Elles ne sont **pas encore signées par un éditeur** ni publiées sur le Microsoft Store ou le Play Store. Téléchargez-les uniquement depuis la page des versions du dépôt, et vérifiez-les si vous le pouvez (voir plus bas).

## Windows

1. Téléchargez `owncoffer-X.Y.Z-windows-x64.zip` et **décompressez-le** dans un dossier (par exemple `Documents\OwnCoffer`).
2. Lancez `owncoffer.exe`.
3. Windows SmartScreen affiche « Windows a protégé votre ordinateur » : c'est parce que l'application n'a pas de certificat d'éditeur. Cliquez sur **Informations complémentaires**, puis **Exécuter quand même**.
4. Choisissez « Utiliser seul sur cet appareil », ou saisissez l'adresse de votre serveur (celle que vous ouvrez dans le navigateur).

Mettre à jour (décision 0032) : quand le serveur passe à une nouvelle version, une bannière le signale ; **« Installer »** télécharge le zip depuis GitHub, le vérifie avec `SHA256SUMS`, le décompresse à côté du dossier de l'application, puis, après « Fermer et mettre à jour », OwnCoffer se ferme, remplace son dossier (l'ancien est gardé en `.previous` jusqu'au lancement suivant) et se relance. Pour cela, **gardez l'application dans un dossier à elle** (par exemple `Documents\OwnCoffer`) : un dossier qui contient d'autres fichiers, ou un dossier protégé comme `Program Files`, n'est pas remplacé, et il faut alors remplacer le dossier à la main. Votre session et vos données sont conservées.

## Android

1. Sur le téléphone, téléchargez `owncoffer-X.Y.Z-android.apk`.
2. Ouvrez-le. Android demande d'autoriser l'installation depuis cette source (le navigateur ou l'application Fichiers) : autorisez-la pour cette installation, puis vous pouvez la retirer.
3. Play Protect peut avertir d'une application inconnue : choisissez **Installer quand même**.
4. Choisissez « Utiliser seul sur cet appareil », ou saisissez l'adresse de votre serveur.

Mettre à jour (décision 0032) : quand le serveur passe à une nouvelle version, une bannière le signale ; **« Installer »** télécharge l'APK depuis GitHub, le vérifie (`SHA256SUMS`, version attendue, même clé de signature que l'application installée) et ouvre l'installateur d'Android, qui demande de confirmer. La première fois, Android demande d'autoriser OwnCoffer à installer des applications : autorisez, revenez, puis « Installer » à nouveau. En mode autonome, page Applications → « Rechercher une nouvelle version ». À la main, installez le nouvel APK par-dessus. Si Android refuse (« conflit avec un paquet existant »), c'est que les deux versions n'ont pas été signées avec la même clé : désinstallez l'ancienne, puis installez la nouvelle. Vous n'y perdez que la session : vos données sont sur le serveur.

> Pour le mainteneur : pour que chaque APK remplace le précédent, créez une fois une clé (`keytool -genkeypair -v -keystore owncoffer.jks -keyalg RSA -keysize 4096 -validity 10000 -alias owncoffer`) et ajoutez dans les secrets GitHub du dépôt `ANDROID_KEYSTORE_BASE64` (`base64 -w0 owncoffer.jks`), `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` et `ANDROID_KEY_PASSWORD`. Gardez la clé précieusement : une autre clé obligera tout le monde à désinstaller.

## Adresse du serveur

- Saisissez l'adresse de votre OwnCoffer, par exemple `comptes.exemple.fr` : l'application ajoute `https://` et `/api/` toute seule, puis vérifie qu'un serveur OwnCoffer répond.
- **HTTPS obligatoire**. Seule exception : un serveur d'essai sur votre réseau local (`http://192.168.x.x:port`, `http://nas.local`), et encore seulement sur Windows (Android refuse le HTTP).
- « **Changer de serveur** », sur la page de connexion, vous déconnecte et redemande l'adresse.

## Vérifier un fichier

Chaque version fournit `SHA256SUMS` et, pour chaque fichier, sa signature `.sigstore.json` (décision 0021) :

```sh
sha256sum -c SHA256SUMS --ignore-missing
cosign verify-blob owncoffer-X.Y.Z-android.apk \
  --bundle owncoffer-X.Y.Z-android.apk.sigstore.json \
  --certificate-identity-regexp '^https://github.com/cmathias27/OwnCoffer/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

Sous Windows, l'empreinte se calcule avec `Get-FileHash owncoffer-X.Y.Z-windows-x64.zip` dans PowerShell.

## Tester avant une version

Chaque pull request compile les deux applications : elles sont téléchargeables 30 jours dans l'onglet **Actions** de GitHub (artefacts `owncoffer-android` et `owncoffer-windows`).

Compiler soi-même (Flutter installé) :

```sh
cd app
flutter build apk --release        # build/app/outputs/flutter-apk/app-release.apk
flutter build windows --release    # build\windows\x64\runner\Release\ (sous Windows)
```

`--dart-define=SERVER_URL=https://comptes.exemple.fr/api/` fixe l'adresse du serveur dans l'application : elle n'est alors plus demandée.

## Pas encore

Hors-ligne et synchronisation, installation automatique des mises à jour des applications, magasins d'applications : phase 6 du [roadbook](ROADBOOK.md).
