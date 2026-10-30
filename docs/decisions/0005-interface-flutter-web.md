# 0005 — Interface web en Flutter web

**Statut** : Proposé — à confirmer

## Contexte

L'application web est la première interface livrée ; les apps Windows et Android suivront. Deux options : Flutter web, ou un framework web classique (par exemple React) avec Flutter seulement pour les apps.

## Proposition

Écrire l'interface web en **Flutter web**.

## Conséquences

- Un seul code d'interface pour le web, Windows et Android ; les apps de la phase 6 réutilisent l'essentiel du travail.
- Client Serverpod généré utilisable directement.
- Contreparties : premier chargement plus lourd qu'un site classique et ergonomie web (sélection de texte, raccourcis) à soigner ; acceptables pour une application de gestion utilisée au quotidien.
