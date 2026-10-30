# 0004 — Licence AGPL-3.0, gratuit, financé par les dons

**Statut** : Décidé (30 octobre 2026)

## Contexte

OwnCoffer est un projet auto-hébergé destiné à être partagé. Options étudiées : freemium, abonnement à une offre hébergée, gratuit avec dons.

## Décision

- Code sous licence **GNU AGPL-3.0** (fichier `LICENSE`).
- Application **gratuite**, sans publicité, sans abonnement ni fonction payante ; soutien par les **dons** (plateforme à choisir).
- **Auto-hébergement uniquement** : aucune donnée chez le développeur, aucune télémétrie.

## Conséquences

- Toute version modifiée accessible par le réseau doit publier son code source.
- Chaque dépendance doit être compatible avec l'AGPL : vérification automatique des licences dans la CI (voir aussi la décision 0001).
- Les contributions sont signées avec le certificat d'origine DCO (`git commit -s`).
