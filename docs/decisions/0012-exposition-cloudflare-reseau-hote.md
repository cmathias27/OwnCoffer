# 0012 — Exposition par Cloudflare, conteneur sur le réseau de l'hôte, un seul port

**Statut** : Décidé (30 octobre 2026) — précise la décision 0002 ; partie réseau remplacée par la décision [0015](0015-reseau-docker-isole-proxy.md)

## Contexte

Le serveur Docker existant sera accessible depuis l'extérieur par une **redirection Cloudflare**, déjà gérée par l'utilisateur. Le HTTPS et le nom de domaine sont pris en charge par Cloudflare.

## Décision

- Le conteneur OwnCoffer utilise le **réseau de l'hôte** (`network_mode: host`).
- Il expose **un seul port**, configurable dans `.env` (par exemple `OWNCOFFER_PORT=8080`), qui sert à la fois l'application web et l'API. Si Serverpod utilise plusieurs ports internes, ils sont regroupés derrière ce port unique ; les ports internes et l'outil de supervision Serverpod n'écoutent que sur `127.0.0.1`.
- **PostgreSQL** n'écoute que sur `127.0.0.1` (jamais sur une interface publique), sur un port configurable.
- OwnCoffer ne gère pas de certificat : il fait confiance au HTTPS de Cloudflare.

## Conséquences

- **Vraie adresse IP** : avec Cloudflare, l'adresse vue par le serveur est celle de Cloudflare ou du connecteur local. Le blocage des IP lit l'en-tête `CF-Connecting-IP`, mais **uniquement** si la requête provient de Cloudflare ou du connecteur local ; sinon l'en-tête est ignoré, pour qu'un attaquant ne puisse pas se faire passer pour une autre adresse.
- Option recommandée : **Cloudflare Access** en protection supplémentaire devant l'application.
- Le port choisi ne doit pas entrer en conflit avec les autres services de l'hôte ; il est vérifié au démarrage avec un message clair.
- Le guide d'installation décrit cette configuration ; le reverse proxy Caddy et le VPN restent des alternatives documentées pour les autres utilisateurs.
