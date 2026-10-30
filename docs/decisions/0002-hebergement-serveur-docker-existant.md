# 0002 — Hébergement : serveur Docker existant, accessible depuis l'extérieur

**Statut** : Décidé (30 octobre 2026)

## Contexte

Le développement et les premiers tests ont besoin d'une machine qui fait tourner le serveur OwnCoffer et sa base PostgreSQL.

## Décision

Le serveur de test est **un serveur Docker déjà en place**, qui sera **accessible depuis l'extérieur** (téléphone hors de la maison, testeurs).

## Conséquences

- OwnCoffer est livré sous forme de `docker-compose.yml` + `.env`, compatible avec ce serveur.
- L'accès extérieur impose **HTTPS** dès la phase 2 : reverse proxy (Caddy, Traefik ou celui déjà en place) et certificat Let's Encrypt, nom de domaine à choisir.
- Exposé sur Internet dès les premiers tests : le blocage des IP, la double authentification et les permissions par groupe (phase 2) passent avant les fonctions bancaires.
- PostgreSQL n'est jamais exposé à l'extérieur : seul le serveur OwnCoffer y accède.
- À noter dans l'issue dédiée : architecture du serveur (Intel/AMD ou ARM), reverse proxy existant, nom de domaine.
