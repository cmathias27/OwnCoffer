# Installer OwnCoffer sur un serveur Docker

Prérequis : un serveur avec Docker et `docker compose`, et un accès extérieur par Cloudflare (décisions 0012 et 0015).

```sh
git clone --branch v0.1.0 https://github.com/cmathias27/OwnCoffer.git
cd OwnCoffer
./docker/generate-env.sh        # crée docker/.env avec des secrets aléatoires
nano docker/.env                # régler OWNCOFFER_PUBLIC_URL, le port, la version
docker compose -f docker/compose.yaml up -d
```

L'application répond sur `http://127.0.0.1:8080` (port et adresse réglables dans `docker/.env`). Si le port 8080 est déjà pris sur votre serveur, changez `OWNCOFFER_PORT`. Faites pointer le connecteur Cloudflare vers cette adresse : Cloudflare gère le HTTPS.

**Version** : `OWNCOFFER_TAG` choisit l'image. `0.1.0` (par défaut) est la version publiée ; `edge` suit la branche `main`, pour tester ce qui vient d'être fusionné. Les versions et leurs nouveautés sont listées dans [CHANGELOG.md](../CHANGELOG.md).

## Premier lancement

1. Récupérez le **code d'installation** à 8 chiffres affiché par le serveur :
   ```sh
   docker compose -f docker/compose.yaml logs owncoffer | grep "setup code"
   ```
2. Ouvrez l'application, saisissez ce code et votre email : vous devenez **administrateur du serveur**. Le code de vérification de l'email arrive par email si le SMTP est réglé dans `docker/.env`, sinon il s'affiche dans ces mêmes journaux.
3. Créez votre groupe (foyer), puis invitez les autres membres : **personne ne peut s'inscrire sans invitation**.

Ce code n'est valable que tant qu'aucun compte n'existe. Il change après 5 essais faux et à chaque redémarrage, ce qui empêche un inconnu de prendre la main sur un serveur fraîchement installé.

## Ce qui tourne

| Conteneur | Rôle | Visible depuis l'hôte |
| --- | --- | --- |
| `proxy` (Caddy) | Port unique : `/api/…` vers l'API, le reste vers l'application web | Oui, uniquement ce port |
| `owncoffer` | Serveur Serverpod et application web | Non |
| `postgres` | Base de données (volume `owncoffer_db`) | Non |

Les migrations de la base s'appliquent automatiquement au démarrage.

## Sécurité de l'accès

- **Vraie adresse IP** : le proxy ne croit l'en-tête `CF-Connecting-IP` que si la requête vient de Cloudflare ou du connecteur Cloudflare local (`OWNCOFFER_TRUSTED_LOCAL`). Si vous passez `OWNCOFFER_BIND=0.0.0.0`, retirez de cette liste les plages de votre réseau local.
- **Blocage automatique** : 5 échecs (mot de passe, code de vérification, code d'installation, lien d'invitation) en 15 minutes bloquent l'adresse IP 1 heure ; la durée double à chaque récidive. Votre réseau domestique peut être exclu avec `OWNCOFFER_IP_ALLOWLIST`.
- **Limite de requêtes** : 600 requêtes par minute et par IP sur l'API (`OWNCOFFER_RATE_LIMIT_PER_MINUTE`).
- **fail2ban ou CrowdSec** (optionnel) : chaque échec est écrit dans les journaux sous la forme `[auth-failure] ip=… kind=…`, et chaque blocage sous la forme `[ip-banned] ip=…`.

## Sauvegarder

Faites une sauvegarde avant chaque mise à jour, et régulièrement (les sauvegardes automatiques arrivent en phase 5) :

```sh
docker compose -f docker/compose.yaml exec -T postgres \
  pg_dump -U owncoffer -d owncoffer --format=custom > owncoffer-$(date +%F).dump
```

Le fichier contient vos opérations bancaires : rangez-le dans un endroit chiffré, jamais dans le dépôt. Gardez aussi une copie de `docker/.env`, sans laquelle la double authentification ne se déchiffre plus.

Restaurer sur une installation vide :

```sh
docker compose -f docker/compose.yaml exec -T postgres \
  pg_restore -U owncoffer -d owncoffer --clean --if-exists < owncoffer-AAAA-MM-JJ.dump
```

## Mettre à jour

1. Sauvegardez (ci-dessus).
2. Lisez les nouveautés de la version dans [CHANGELOG.md](../CHANGELOG.md).
3. Récupérez les fichiers de la nouvelle version et changez `OWNCOFFER_TAG` dans `docker/.env` :
   ```sh
   git fetch --tags && git checkout v0.1.0      # la nouvelle version
   nano docker/.env                             # OWNCOFFER_TAG=0.1.0
   docker compose -f docker/compose.yaml pull
   docker compose -f docker/compose.yaml up -d
   ```

Les migrations de la base s'appliquent au démarrage.

## Image privée

Si `docker compose pull` répond `denied` ou `unauthorized`, l'image `ghcr.io/cmathias27/owncoffer` n'est pas publique : rendez le paquet public dans GitHub (Packages, owncoffer, Package settings), ou connectez-vous avec `docker login ghcr.io` et un jeton ayant le droit `read:packages`.

## Points d'attention

- `docker/.env` contient les secrets : ne jamais le commiter ni le partager. Le perdre rend les sessions invalides, et le mot de passe de la base reste celui de la première installation.
- Laissez `OWNCOFFER_BIND=127.0.0.1` si le connecteur Cloudflare tourne sur la même machine.
- Les sauvegardes automatiques arrivent en phase 5 : en attendant, suivez « Sauvegarder » ci-dessus.
