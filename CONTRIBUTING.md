# Contribuer à OwnCoffer

Merci de votre intérêt ! Le projet est en phase de conception : les retours sur le [cahier des charges](docs/CAHIER_DES_CHARGES.md) et le [roadbook](docs/ROADBOOK.md) sont aussi précieux que le code.

## Proposer une idée ou signaler un bug

Ouvrez une issue avec le modèle adapté (« Bug » ou « Idée »). Une issue = un sujet.

**Ne joignez jamais de vrai relevé bancaire, de capture d'écran avec vos montants, ni de numéro de compte.** Anonymisez d'abord (montants, libellés de personnes, références, IBAN).

## Contribuer au code

1. Choisissez une issue du milestone en cours (voir le roadbook), ou ouvrez-en une avant un changement important.
2. Créez une branche depuis `main` : `feature/<sujet>`, `fix/<sujet>` ou `docs/<sujet>`.
3. Faites des commits courts, au format *Conventional Commits* : `feat: …`, `fix: …`, `docs: …`, `test: …`, `chore: …`.
4. **Signez chaque commit** avec le certificat d'origine (DCO) : `git commit -s`.
5. Ajoutez ou mettez à jour les tests : tout code de lecture de fichiers bancaires, de calcul de montant ou de permission doit être testé.
6. Ouvrez une pull request vers `main` avec le modèle fourni. La fusion se fait quand les vérifications sont au vert et après relecture.

## Certificat d'origine (DCO)

En signant un commit (`Signed-off-by: Votre Nom <email>`), vous certifiez avoir le droit de soumettre ce code sous la licence du projet (AGPL-3.0), selon le [Developer Certificate of Origin 1.1](https://developercertificate.org/).

## Conventions

- Code, noms de variables et commentaires techniques en **anglais** ; documentation et interface en **français et anglais**.
- Montants toujours en **centimes** (entiers), jamais en nombres à virgule.
- Aucun texte d'interface écrit en dur : tout passe par les fichiers de traduction.
- Aucun secret (clé API, mot de passe) dans le code : utiliser `.env` (jamais commité).
- Les décisions d'architecture sont écrites dans [docs/decisions/](docs/decisions/).

## Code de conduite

Ce projet suit un [code de conduite](CODE_OF_CONDUCT.md). En participant, vous acceptez de le respecter.
