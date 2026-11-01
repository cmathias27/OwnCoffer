# Applications Windows et Android

Les applications Windows et Android sont la même application que la version web, connectée à **votre** serveur OwnCoffer (décision 0020). Elles ne gardent sur l'appareil que l'adresse du serveur et votre session : vos opérations restent sur le serveur.

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
4. Saisissez l'adresse de votre serveur (celle que vous ouvrez dans le navigateur).

Mettre à jour : quand le serveur passe à une nouvelle version, une bannière le signale dans l'application ; « Télécharger » ouvre la page Applications. Remplacez le dossier par celui de la nouvelle version : votre session est conservée.

## Android

1. Sur le téléphone, téléchargez `owncoffer-X.Y.Z-android.apk`.
2. Ouvrez-le. Android demande d'autoriser l'installation depuis cette source (le navigateur ou l'application Fichiers) : autorisez-la pour cette installation, puis vous pouvez la retirer.
3. Play Protect peut avertir d'une application inconnue : choisissez **Installer quand même**.
4. Saisissez l'adresse de votre serveur.

Mettre à jour : quand le serveur passe à une nouvelle version, une bannière le signale ; « Télécharger » ouvre la page Applications. Installez le nouvel APK par-dessus. Si Android refuse (« conflit avec un paquet existant »), c'est que les deux versions n'ont pas été signées avec la même clé : désinstallez l'ancienne, puis installez la nouvelle. Vous n'y perdez que la session : vos données sont sur le serveur.

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

Hors-ligne et synchronisation, installation automatique des mises à jour des applications, version autonome sans serveur, magasins d'applications : phase 6 du [roadbook](ROADBOOK.md).
