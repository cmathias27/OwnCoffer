# 0030 — Pépite : le défi du mois

**Statut** : Décidé (11 novembre 2026), mis en œuvre en 1.15.0

## Contexte

La décision 0028 (point 8) prévoit un **défi du mois** facultatif, choisi dans une liste fixe, mesurable avec les données, qui rapporte 10 graines ; rien n'est perdu en cas d'échec ou d'abandon ; pas de défi sur les dépenses quand un compte est à découvert. Le point 10 le rend désactivable. L'utilisateur veut que Pépite **remarque toute seule** ce qu'il fait (décision 0029) : le défi avance donc sans rien cocher.

## Décision

1. **Liste fixe** (`shared/lib/src/pepite/pepite_challenges.dart`) : ranger 20 opérations à la main (`classify_20`), rattacher 5 factures (`invoices_5`), créer 3 règles de classement (`rules_3`), déclarer 2 abonnements (`subscriptions_2`), se fixer un objectif (`goal_1`). **Aucun ne porte sur un montant ni sur les dépenses** : tous restent proposés quand un compte est à découvert, et aucun ne peut pousser à dépenser ou à cacher une dépense.
2. **Un défi par personne et par mois** (table `pepite_challenges`, clé unique utilisateur + mois `AAAA-MM`, mois du jour de l'appareil comme pour la semaine du rituel). Choisi par `PepiteEndpoint.chooseChallenge`, abandonné par `dropChallenge`. Changer de défi remet le compte à zéro.
3. **Mesuré par le serveur**, par des requêtes de comptage sur les actions de la personne **depuis le choix** : journal d'audit (`set_category` sur une opération ; facture déposée sur une opération ou rattachée ; opération prévue devenue abonnement ; objectif créé) et règles qu'elle a créées. Jamais les actions d'un autre membre du groupe.
4. **Réussi** dès que le compte est atteint, à n'importe quel coup d'œil de Pépite : **10 graines**, une seule fois ; le défi ne peut plus être changé ni abandonné ce mois-là. Pépite l'annonce (court message, ou dans la fenêtre de la semaine).
5. **Désactivable sur l'appareil** : « Proposer un défi chaque mois », dans Pépite et ma réserve, masque la carte et l'annonce. Un défi déjà choisi peut encore réussir côté serveur (les graines ne sont pas refusées).
6. **Version autonome** : la migration vers un serveur emporte les graines des défis réussis (`challengesDone` dans le plafond de `adopt`), pas l'historique des défis.

## Conséquences

- Nouvelle table `pepite_challenges` (migrations PostgreSQL et SQLite) ; champs facultatifs `challenge` et `challengesDone` dans `PepiteStatus`.
- Quelques requêtes de comptage de plus à chaque coup d'œil, seulement quand un défi non réussi est en cours.
- Codes d'erreur `pepite_challenge_unknown` et `pepite_challenge_done`.
- Exemples de 0028 non retenus : « une semaine sans livraison de repas » porterait sur les dépenses et demanderait de lire les montants ; il pourra revenir dans une décision ultérieure.
