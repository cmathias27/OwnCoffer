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
| [0017](0017-configuration-ia-par-administrateur.md) | Fournisseurs d'IA configurés par l'administrateur du serveur | Décidé |
| [0018](0018-serveur-mcp-jeton-personnel.md) | OwnCoffer comme serveur MCP, par jeton personnel | Décidé |
| [0019](0019-sauvegardes-chiffrees.md) | Sauvegardes chiffrées, restauration testée chaque nuit | Décidé |
| [0020](0020-applications-windows-android.md) | Applications Windows et Android, client du serveur, hors magasins | Décidé |
| [0021](0021-publication-signee-sbom.md) | Publication signée (Sigstore) et liste des composants (SBOM) | Décidé |
| [0022](0022-version-autonome-serveur-embarque.md) | Version autonome : le serveur embarqué dans l'application, sur SQLite | Décidé |
| [0023](0023-lecture-du-texte-sur-l-appareil.md) | Lecture du texte des tickets sur l'appareil, un moteur par plateforme | Décidé |
| [0024](0024-licence-exception-serverpod.md) | Licence AGPL-3.0 avec une exception pour Serverpod | Décidé, confirmation de Serverpod attendue |
| [0025](0025-verrouillage-automatique.md) | Verrouillage automatique, déverrouillage par mot de passe ou par l'appareil | Décidé |
| [0026](0026-mascotte-pepite.md) | Pépite, la mascotte des comptes de la semaine : rituel, graines, badges, rappel | Décidé |
| [0027](0027-sessions-et-appareils.md) | Sessions et appareils : lieu, durée, révocation, alertes, incitation aux applications | Décidé |
| [0028](0028-pepite-badges-graines-defis.md) | Pépite : conseils sur l'application, nouveaux badges, graines à dépenser, année et défi du mois | Décidé |
| [0029](0029-pepite-autonome.md) | Pépite remarque toute seule les étapes de la semaine et annonce les badges | Décidé |
| [0030](0030-pepite-defi-du-mois.md) | Pépite : le défi du mois, mesuré tout seul | Décidé |
| [0031](0031-pepite-ton-annee.md) | Pépite : « Ton année » | Décidé |
| [0032](0032-mises-a-jour-des-applications.md) | Mises à jour des applications installées depuis l'application | Décidé |
| [0033](0033-chiffrement-base-autonome.md) | Chiffrement du fichier de base de données en mode autonome | Décidé |
| [0034](0034-abonnements-operations-hausses-de-prix.md) | Abonnements mis en évidence dans Opérations et hausses de prix | Décidé |
| [0035](0035-recapitulatif-mensuel.md) | Récapitulatif mensuel sur une page | Décidé |
| [0036](0036-scan-tickets-preremplissage-operation.md) | Scan des tickets : pré-remplissage et opération créée depuis le ticket | Décidé |
| [0037](0037-hors-ligne-consultation.md) | Hors-ligne : consultation sans réseau dans les applications connectées | Décidé |
| [0038](0038-hors-ligne-saisie.md) | Hors-ligne : saisie sans réseau et envoi au retour du serveur | Décidé |
| [0039](0039-recadrage-automatique-des-tickets.md) | Recadrage automatique des tickets, sur l'appareil | Décidé |
| [0040](0040-credit-rapproche-des-prelevements.md) | Crédit rapproché des prélèvements réels | Décidé |
| [0041](0041-refonte-de-l-interface.md) | Refonte de l'interface : rubriques, recherche globale, Mon conseiller en avant | Décidé |
| [0042](0042-tableau-d-amortissement-complet.md) | Tableau d'amortissement lu en entier : le moteur déduit les changements, pause d'échéances | Décidé |
| [0043](0043-indemnite-de-remboursement-anticipe.md) | Indemnité de remboursement anticipé : clause de l'offre plafonnée au maximum légal | Décidé |

Modèle pour une nouvelle décision : copier une page existante, garder les rubriques Statut, Contexte, Décision, Conséquences.
