# Décisions d'architecture

Une page par décision importante : le contexte, le choix fait et ses conséquences. Une décision n'est jamais effacée ; si elle change, une nouvelle page la remplace et l'ancienne passe au statut « Remplacée ».

| # | Décision | Statut |
| --- | --- | --- |
| [0001](0001-framework-serveur-serverpod.md) | Framework du serveur : Serverpod | Décidé |
| [0002](0002-hebergement-serveur-docker-existant.md) | Serveur Docker existant, accessible depuis l'extérieur | Décidé |
| [0003](0003-une-seule-banque-au-depart.md) | Une seule banque au départ : Caisse d'Épargne | Décidé |
| [0004](0004-licence-agpl.md) | Licence AGPL-3.0, gratuit, financé par les dons | Décidé |
| [0005](0005-interface-flutter-web.md) | Interface web en Flutter web | Décidé |
| [0006](0006-ia-optionnelle.md) | L'IA est optionnelle : l'application est complète sans elle | Décidé |
| [0007](0007-espace-mon-conseiller.md) | Espace « Mon conseiller » : journal d'analyses et de recommandations | Décidé |
| [0008](0008-ia-hybride-passerelle.md) | IA hybride (locale ou externe) derrière une passerelle IA unique | Décidé |
| [0009](0009-actions-proposees-validees.md) | Modifications proposées, validées par l'utilisateur, exécutées par le moteur | Décidé |
| [0010](0010-perimetre-alpha.md) | Alpha minimale : import, classement, solde prévu, alerte de découvert | Décidé |
| [0011](0011-application-web-installable-pwa.md) | Application web installable sur téléphone (PWA) | Décidé |
| [0012](0012-exposition-cloudflare-reseau-hote.md) | Exposition par Cloudflare, réseau de l'hôte, un seul port | Décidé, réseau remplacé par 0015 |
| [0013](0013-licence-regles-communautaires-cc0.md) | Licence CC0 pour la base de règles communautaires | Décidé |
| [0014](0014-cible-classement-automatique-alpha.md) | Cible de classement automatique pour l'alpha : 70 % | Décidé |
| [0015](0015-reseau-docker-isole-proxy.md) | Réseau Docker isolé, proxy Caddy sur le port unique | Décidé |
| [0016](0016-rls-apres-alpha.md) | Row Level Security repoussée après l'alpha ; test d'isolation obligatoire | Décidé |

Modèle pour une nouvelle décision : copier une page existante, garder les rubriques Statut, Contexte, Décision, Conséquences.
