# 0029 — Pépite remarque toute seule ce que l'on fait

**Statut** : Décidé (11 novembre 2026), mis en œuvre en 1.14.0

## Contexte

Dans la décision 0026, les étapes du rituel hebdomadaire se cochent à la main (« Ouvrir » ou la case) et la semaine n'est comptée qu'en appuyant sur « Fêter ça ». Les badges gagnés en ouvrant l'accueil ne sont annoncés nulle part. L'utilisateur fait ses comptes sans passer par le rituel et veut que Pépite **détecte elle-même** ce qu'il fait pour les récompenses.

## Décision

1. **Étapes vues dans les données, par le serveur** (`PepiteStatus.weekSteps`, depuis le lundi de la semaine) : `statements` quand l'utilisateur a importé un relevé non annulé ; `check` quand il a modifié une opération (journal d'audit, entité `transaction` : classement, pointage, modification…). Seulement ses propres actions, par des requêtes de comptage.
2. **Étapes vues sur l'appareil** : ouvrir les opérations (onglet ou compte) coche « vérifier » ; ouvrir la prévision coche « prévision » ; un import fait dans l'application coche « relevés ». La prévision ne laisse aucune trace sur le serveur, d'où ce relevé sur l'appareil, gardé pour la semaine comme avant.
3. **La semaine est comptée toute seule** dès que les trois étapes sont vues (union serveur et appareil) : l'application appelle `completeRitual` elle-même, une fois par semaine, et Pépite fête ça par la fenêtre habituelle, en disant ce qu'elle a vu. « Fêter ça » et les cases restent pour une semaine sans nouveau relevé.
4. **Badges annoncés en chemin** : chaque coup d'œil de Pépite (changement de page, au plus toutes les 20 secondes ; tout de suite après un import) peut donner des badges ; ils sont annoncés par un court message.
5. **Pépite masquée** (« Afficher Pépite » désactivé) : rien n'est compté ni annoncé par elle-même.

Inchangé : 10 graines par semaine, une seule fois ; 5 par badge ; aucun calcul par une IA ; rien ne sort de l'appareil en version autonome.

## Conséquences

- Champ facultatif `weekSteps` dans `PepiteStatus` (pas de table, pas de migration).
- Deux requêtes de comptage de plus à chaque coup d'œil (imports et journal d'audit de l'utilisateur).
- Remplace, pour ce qui précède, le point 2 de la décision 0026 (« les étapes cochées »).
