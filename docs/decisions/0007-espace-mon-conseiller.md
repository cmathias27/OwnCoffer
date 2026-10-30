# 0007 — Espace « Mon conseiller » : journal d'analyses et de recommandations

**Statut** : Décidé (30 octobre 2026)

## Contexte

Un assistant limité à une fenêtre de discussion repart de zéro à chaque échange et ne suit pas les décisions prises. La décision 0006 impose par ailleurs que l'application soit aussi complète sans IA.

## Décision

Créer un espace **Mon conseiller** : un fil d'analyses et de recommandations (bonne nouvelle, point de vigilance, recommandation), produites par le **moteur financier**, chacune acceptée, refusée ou ignorée par l'utilisateur, puis suivie dans le temps.

- Quatre responsabilités : **surveiller**, **anticiper**, **conseiller**, **accompagner**.
- Fonctionne **sans IA** (cartes calculées, textes fixes traduits) ; **avec IA**, rédaction en langage clair, discussion, adaptation des conseils.
- **Trois niveaux de données** : données financières ; connaissances du conseiller (objectifs, habitudes, préférences) ; historique du conseiller (analyses, recommandations, décisions, contestations, résultats).
- **Droits** : uniquement les comptes visibles par l'utilisateur, uniquement via les fonctions du moteur.
- **Règle de justification** : chaque carte montre ses données et son calcul ; une information inconnue est signalée, jamais inventée.

## Conséquences

- Tables à prévoir : `advisor_preferences`, `advisor_insights` (type, niveau, données sources, calcul, statut, date), `advisor_followups` (décision, objectif lié, mesure du résultat), `advisor_disputes`.
- Le moteur d'analyse est testé comme le reste du moteur financier (IA désactivée).
- Détaillé dans le cahier des charges, section « IA optionnelle et espace Mon conseiller ».
