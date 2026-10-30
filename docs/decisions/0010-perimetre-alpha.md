# 0010 — Alpha minimale

**Statut** : Décidé (30 octobre 2026)

## Contexte

Le cahier des charges compte plus de 70 fonctionnalités. Le principal risque du projet est de s'épuiser avant d'avoir une version qui sert au quotidien.

## Décision

L'alpha 0.1 (fin de phase 3) contient **uniquement** :

1. l'import des relevés **Caisse d'Épargne** (sans doublons) ;
2. la liste des opérations (recherche, filtres, saisie manuelle, pointage) ;
3. le classement par règles (règles du groupe, règles communautaires v0, historique) ;
4. les opérations prévues récurrentes et le **solde prévu** à 30 jours ;
5. une **alerte de découvert prévu** (dans l'app et par email).

Elle est utilisée **un mois** par son auteur avant d'ajouter quoi que ce soit. Les autres fonctionnalités du cahier des charges sont un réservoir d'idées, priorisé ensuite selon l'usage réel.

## Conséquences

- L'IA, Mon conseiller, les simulations, les crédits et les graphiques détaillés passent en phase 4.
- La sécurité (phase 2) n'est pas allégée : le serveur est exposé sur Internet dès l'alpha.
