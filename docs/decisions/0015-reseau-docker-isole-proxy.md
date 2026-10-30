# 0015 — Réseau Docker isolé et proxy sur le port unique

**Statut** : Décidé (30 octobre 2026) — remplace la partie « réseau de l'hôte » de la décision 0012

## Contexte

La décision 0012 prévoyait un conteneur sur le réseau de l'hôte (`network_mode: host`), avec les ports internes de Serverpod limités à `127.0.0.1`. Or Serverpod 4 ouvre ses serveurs internes (API, site web, supervision) sur **toutes les interfaces**, sans réglage possible. Sur le réseau de l'hôte, ils seraient joignables depuis le réseau local.

## Décision

- Les conteneurs (OwnCoffer, PostgreSQL, proxy) sont sur un **réseau Docker privé**.
- Seul un petit proxy **Caddy** publie le **port unique** (`OWNCOFFER_PORT`) sur l'hôte, par défaut sur `127.0.0.1` (`OWNCOFFER_BIND`) pour le connecteur Cloudflare local. On peut le passer sur `0.0.0.0` si Cloudflare joint directement le serveur.
- Le proxy envoie `/api/…` au serveur d'API et le reste à l'application web. L'application appelle l'API sur la même origine (`/api/`).
- PostgreSQL et les ports internes de Serverpod ne sont **jamais publiés** sur l'hôte.

## Conséquences

- Ce qui reste valable dans la décision 0012 : HTTPS géré par Cloudflare, un seul port configurable, option Cloudflare Access, vérification de `CF-Connecting-IP`.
- **Vraie adresse IP** (issue #18) : le serveur ne fait confiance qu'au proxy Caddy du réseau privé ; Caddy ne transmet `CF-Connecting-IP` que si la requête vient de Cloudflare ou du connecteur local.
- Caddy (Apache-2.0) est compatible avec l'AGPL-3.0.
