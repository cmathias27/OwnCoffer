# 0021 — Publication signée et liste des composants (SBOM)

**Statut** : Décidé (1er novembre 2026)

## Contexte

Les serveurs se mettent à jour seuls (`docker/auto-update.sh`) avec l'image publiée sur `ghcr.io`. Il faut pouvoir prouver qu'une image ou un fichier vient bien de ce dépôt et de sa CI, et savoir quels composants (et quelles licences, décision 0004) il contient.

## Décision

Pour chaque version `vX.Y.Z`, la CI (GitHub Actions) :

1. construit l'image avec son **attestation de provenance** (SLSA, `provenance: mode=max`) et sa **liste de composants** attachées à l'image ;
2. **signe l'image** avec **cosign** en mode *keyless* (Sigstore) : la signature est liée à l'identité du workflow GitHub de ce dépôt, enregistrée dans le journal public Rekor ; aucune clé privée à garder ni à perdre ;
3. crée la **version GitHub** avec les notes tirées de `CHANGELOG.md`, et y joint : l'application Android, l'application Windows, les **SBOM** (SPDX JSON) du code source et de l'image (générés par Syft), le fichier `SHA256SUMS`, et pour chaque fichier sa **signature Sigstore** (`.sigstore.json`).

Signature *keyless* plutôt qu'une clé GPG : rien à protéger sur un poste, vérification possible par n'importe qui avec `cosign verify`, identité du signataire = le workflow de ce dépôt.

## Conséquences

- `docs/PUBLICATION.md` donne les commandes de vérification et la façon de publier une version.
- La vérification de la signature par `docker/auto-update.sh` avant d'installer une image n'est pas encore faite (cosign n'est pas installé sur les serveurs) : à ajouter, en option, après la 1.0.
