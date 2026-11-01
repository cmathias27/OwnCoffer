# Publication des versions

Chaque version `vX.Y.Z` est construite par la CI de ce dépôt (GitHub Actions), signée sans clé avec Sigstore, et accompagnée de la liste de ses composants (décision 0021).

## Ce que contient une version

Sur la page **Releases** du dépôt :

| Fichier | Contenu |
| --- | --- |
| notes de version | la section de [CHANGELOG.md](../CHANGELOG.md) |
| `owncoffer-X.Y.Z-android.apk` | application Android ([APPLICATIONS.md](APPLICATIONS.md)) |
| `owncoffer-X.Y.Z-windows-x64.zip` | application Windows |
| `owncoffer-vX.Y.Z-source.spdx.json` | **SBOM** du code : toutes les dépendances Dart et Flutter avec leur version, au format SPDX |
| `owncoffer-vX.Y.Z-image.spdx.json` | **SBOM** de l'image Docker : paquets du système et du serveur |
| `SHA256SUMS` | empreintes de tous ces fichiers |
| `*.sigstore.json` | signature Sigstore de chaque fichier |

L'image `ghcr.io/cmathias27/owncoffer:X.Y.Z` est signée, et porte son attestation de provenance (SLSA) et sa propre SBOM.

## Vérifier l'image

Avec [cosign](https://docs.sigstore.dev/cosign/system_config/installation/) :

```sh
cosign verify ghcr.io/cmathias27/owncoffer:X.Y.Z \
  --certificate-identity-regexp '^https://github.com/cmathias27/OwnCoffer/\.github/workflows/ci\.yml@refs/tags/v' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

La commande réussit seulement si l'image a été signée par le workflow `ci.yml` de ce dépôt, pour une étiquette de version. La provenance et la SBOM de l'image se lisent avec :

```sh
docker buildx imagetools inspect ghcr.io/cmathias27/owncoffer:X.Y.Z --format '{{ json .Provenance }}'
docker buildx imagetools inspect ghcr.io/cmathias27/owncoffer:X.Y.Z --format '{{ json .SBOM }}'
```

## Vérifier un fichier

```sh
sha256sum -c SHA256SUMS --ignore-missing
cosign verify-blob owncoffer-vX.Y.Z-source.spdx.json \
  --bundle owncoffer-vX.Y.Z-source.spdx.json.sigstore.json \
  --certificate-identity-regexp '^https://github.com/cmathias27/OwnCoffer/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

## Publier une version (mainteneur)

1. Sur une branche : mettre à jour `CHANGELOG.md` (titre `## X.Y.Z (date)`), `version:` de `app/pubspec.yaml` (et son numéro de build `+N`, augmenté de 1) et `OWNCOFFER_TAG` de `docker/.env.example`. Pull request, CI au vert, fusion.
2. Étiqueter `main` : `git tag vX.Y.Z && git push origin vX.Y.Z`.
3. La CI construit, signe et publie l'image `:X.Y.Z`, compile les applications, produit les SBOM, signe chaque fichier et crée la version GitHub avec ses notes. Les serveurs en mises à jour automatiques l'installent dans le quart d'heure qui suit la publication de l'image.

Optionnel, une fois : les secrets `ANDROID_KEYSTORE_*` pour une clé Android stable ([APPLICATIONS.md](APPLICATIONS.md)).
