# 0035 — Récapitulatif mensuel sur une page

**Statut** : Décidé (11 novembre 2026), mis en œuvre en 1.20.0

## Contexte

Les informations utiles pour le mois à venir étaient dispersées : la prévision par compte dans l'onglet Prévisions, les alertes dans les notifications, les propositions dans Mon conseiller et les hausses d'abonnement annoncées (décision 0034) dans Opérations. La feuille de route (phase 6) demande un récapitulatif sur une page, calculé par le moteur, avec une explication facultative par l'IA.

## Décision

1. **Un point d'accès en lecture seule.** `analysis.summary(groupId, today)` renvoie un `MonthSummary` (modèle sans table, donc pas de migration) :
   - pour chaque compte courant visible, la prévision à 30 jours calculée par `ForecastService.compute` avec les dépenses courantes estimées (même moteur que l'onglet Prévisions) : solde du jour, solde à 30 jours, point bas et sa date, premier passage sous le seuil d'alerte, total des sorties et des entrées prévues, nombre d'échéances en retard ;
   - les notifications non lues de l'utilisateur pour ce groupe (20 au plus, les plus récentes), en écartant celles qui concernent sa propre session ;
   - ses propositions en attente dans ce groupe (50 au plus), après rafraîchissement des conseils du moteur (`ProposalService.refreshAdvice`) ;
   - les hausses d'abonnement annoncées entre 7 jours avant aujourd'hui et la fin de la période, sur les comptes visibles.
2. **Contrôles.** Les comptes passent par `Access.visibleAccounts` (membre du groupe exigé) ; alertes et propositions sont filtrées par utilisateur. La date envoyée par l'application doit être à un jour près celle du serveur (`invalid_date` sinon). Tests d'isolation dans `budget_tools_test.dart` (membre d'un autre groupe refusé, lecteur, administrateur, compte privé d'un autre membre), sur PostgreSQL et SQLite.
3. **Page.** « Récapitulatif : les 30 prochains jours » depuis la carte « À surveiller » de l'accueil. Chaque section mène à sa page (prévision du compte, notifications, Mon conseiller). Les textes des alertes et des propositions sont ceux de leurs pages, partagés et non recopiés.
4. **IA facultative.** Le bouton « Demander une explication à l'IA » n'apparaît que si une IA est configurée. Il ouvre la conversation avec une question qui demande d'expliquer les prévisions et conseils du moteur sans refaire les calculs (décisions 0006 et 0007). La page fonctionne entièrement sans IA.

## Conséquences

- Aucune dépendance, aucune table, aucun appel réseau sortant.
- Aucune écriture : la page ne fait que lire ; les décisions se prennent dans Mon conseiller.
- Textes en français et en anglais.
