# Installer OwnCoffer sur un serveur Docker

Prérequis : un serveur avec Docker et `docker compose`, et un accès extérieur par Cloudflare (décisions 0012 et 0015).

```sh
git clone https://github.com/cmathias27/OwnCoffer.git
cd OwnCoffer
./docker/generate-env.sh        # crée docker/.env avec des secrets aléatoires
nano docker/.env                # régler OWNCOFFER_PUBLIC_URL, et le port si besoin
docker compose -f docker/compose.yaml up -d
```

L'application répond sur `http://127.0.0.1:8080` (port et adresse réglables dans `docker/.env`). Faites pointer le connecteur Cloudflare vers cette adresse : Cloudflare gère le HTTPS.

## Ce qui tourne

| Conteneur | Rôle | Visible depuis l'hôte |
| --- | --- | --- |
| `proxy` (Caddy) | Port unique : `/api/…` vers l'API, le reste vers l'application web | Oui, uniquement ce port |
| `owncoffer` | Serveur Serverpod et application web | Non |
| `postgres` | Base de données (volume `owncoffer_db`) | Non |

Les migrations de la base s'appliquent automatiquement au démarrage.

## Mettre à jour

```sh
docker compose -f docker/compose.yaml pull
docker compose -f docker/compose.yaml up -d
```

## Points d'attention

- `docker/.env` contient les secrets : ne jamais le commiter ni le partager. Le perdre rend les sessions invalides, et le mot de passe de la base reste celui de la première installation.
- Laissez `OWNCOFFER_BIND=127.0.0.1` si le connecteur Cloudflare tourne sur la même machine.
- Les sauvegardes automatiques arrivent en phase 5 : en attendant, sauvegardez le volume `owncoffer_db` (par exemple avec `pg_dump`).
