# 0024 — Licence : AGPL-3.0 avec une exception pour Serverpod

**Statut** : Décidé (5 novembre 2026) — complète la décision 0001 ; confirmation de l'équipe Serverpod demandée

## Contexte

La décision 0001 a choisi Serverpod en notant un point de vigilance : tous ses paquets sont sous BSD-3, sauf le paquet principal `serverpod`, sous **SSPL** (Server Side Public License, version 1). Le risque avait été accepté pour l'usage personnel, à trancher avant d'ouvrir OwnCoffer à d'autres personnes.

Depuis, OwnCoffer **distribue** ce paquet : dans l'image Docker, et depuis la 1.1.0 dans les applications Windows et Android (serveur embarqué, décision 0022). Or l'AGPL-3.0 et la SSPL demandent chacune que l'ensemble distribué soit sous ses propres conditions, et l'AGPL interdit d'y ajouter des restrictions (son article 10), ce que fait l'article 13 de la SSPL. Sans précaution, distribuer les deux ensemble n'est pas clairement permis.

L'équipe Serverpod écrit que l'on peut héberger un serveur Serverpod sans limite, tant qu'on ne propose pas Serverpod comme service cloud à des tiers. Son intention ne vise donc pas un usage comme celui d'OwnCoffer.

Options étudiées :

| Option | Pour | Contre |
|---|---|---|
| **A. AGPL-3.0 + permission supplémentaire (article 7) pour Serverpod** | OwnCoffer reste libre (licence reconnue par l'OSI) et protégé par l'AGPL ; rien ne change pour les utilisateurs | Ne règle que notre côté : la lecture de la SSPL par Serverpod reste à confirmer |
| B. OwnCoffer sous SSPL | Cohérent avec le paquet | OwnCoffer n'est plus un logiciel libre au sens de l'OSI ; un hébergeur devrait publier toute son infrastructure |
| C. Licence permissive (MIT, Apache-2.0) | Combinaison plus simple | N'importe qui peut fermer et revendre OwnCoffer |
| D. Quitter le paquet SSPL (Dart Frog, ou une version BSD figée) | Plus aucune question de licence | Réécrire serveur, client généré, authentification et mode autonome ; ou ne plus recevoir de correctifs de sécurité |

## Décision

**Option A.** OwnCoffer reste sous AGPL-3.0, avec une permission supplémentaire, selon l'article 7 de l'AGPL, qui autorise à distribuer OwnCoffer combiné avec le paquet `serverpod` (texte dans [LICENSE-EXCEPTION.md](../../LICENSE-EXCEPTION.md)). Le titulaire des droits d'OwnCoffer est aujourd'hui son seul auteur, qui peut donc l'accorder seul ; chaque contribution est faite sous la même licence et la même permission (CONTRIBUTING.md, signature DCO).

En parallèle, une confirmation écrite est demandée à l'équipe Serverpod : qu'une application AGPL-3.0 auto-hébergée peut distribuer le paquet `serverpod` (image Docker, applications), sans que l'article 5 c) de la SSPL n'exige de placer le code d'OwnCoffer sous SSPL.

## Conséquences

- Licence affichée : « AGPL-3.0 avec une exception pour Serverpod » (README, CONTRIBUTING, aide) ; le fichier `LICENSE-EXCEPTION.md` est joint à l'image Docker et à l'archive Windows avec `LICENSE`.
- Rien ne change pour qui installe OwnCoffer chez soi, pour sa famille ou une association.
- **Ne pas proposer OwnCoffer comme service hébergé pour des tiers** tant que la réponse de Serverpod n'est pas reçue (inchangé depuis 0001).
- Si Serverpod refuse ou ne répond pas avant l'ouverture de la bêta : nouvelle décision vers l'option D (Dart Frog), la logique métier étant déjà dans `shared/` et les services du serveur.
- La case « Licence Serverpod clarifiée » du roadbook est cochée à la réception de la réponse.
