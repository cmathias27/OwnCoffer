# 0006 — L'IA est optionnelle : l'application est complète sans elle

**Statut** : Décidé (30 octobre 2026)

## Contexte

OwnCoffer propose une IA (lecture de documents, analyses, conseils, simulations en langage naturel). Certains utilisateurs ne voudront pas envoyer leurs données à un fournisseur d'IA, ou n'auront pas de modèle local.

## Décision

1. **Chaque utilisateur décide** s'il connecte une IA, laquelle (fournisseur externe ou modèle local), et peut la déconnecter à tout moment. Un admin de groupe peut l'interdire pour son groupe.
2. **Parité sans IA** : chaque fonction de l'application a une version complète sans IA. L'IA rend les choses plus rapides ou plus naturelles, elle n'ouvre aucune fonction indispensable.
3. **Architecture en trois couches** :
   - **Données** : comptes, opérations, crédits, revenus, objectifs ;
   - **Moteur financier** déterministe et testé : tous les calculs, prévisions, simulations et détections ;
   - **IA** (optionnelle) : interroge le moteur par des fonctions dédiées, interprète et explique ses résultats, propose des pistes.
4. **L'IA ne calcule jamais un solde ni un montant** et **ne modifie jamais les données** : elle propose, l'utilisateur valide.

## Sans IA / avec IA

| Fonction | Sans IA | Avec IA, en plus |
| --- | --- | --- |
| Classement | Règles du groupe, règles communautaires, historique | Suggestion pour les opérations restantes, avec la règle correspondante |
| Ticket de caisse | Saisie assistée ; montant et date lus sur l'appareil (reconnaissance de texte locale) | Ventilation automatique ligne par ligne |
| Offre de prêt | Formulaire de crédit, tableau d'amortissement calculé | Champs remplis depuis le document |
| Analyse des dépenses | Graphiques, comparaisons, hausses et anomalies détectées par calcul, avec l'écart chiffré | Explication en langage clair, réponses aux questions |
| Simulations | Simulateur avec scénarios comparés côte à côte | Scénarios posés en langage naturel (« et si je réduisais mes loisirs de 100 € ? »), recalculés par le moteur |
| Objectifs | Montants suggérés d'après la moyenne des 3 à 6 derniers mois | Justification et ajustements discutés |
| Alertes | Dépassements, découverts prévus, anomalies | Message expliquant la cause et les pistes possibles |

## Conséquences

- Les tests de chaque fonction s'exécutent **IA désactivée** ; l'IA est testée à part.
- La fiabilité des prévisions (fourchette, indice de confiance) est calculée par le moteur et affichée à tous, avec ou sans IA.
- Avec l'IA : mémoire des objectifs et préférences, historique des conseils, sources de chaque conseil, possibilité de contester une analyse ; données minimisées avant envoi et option entièrement locale.
