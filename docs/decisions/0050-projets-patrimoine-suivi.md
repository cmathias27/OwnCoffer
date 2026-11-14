# 0050 — Projets, patrimoine, dépenses à plusieurs et suivi

**Statut** : Décidé (14 novembre 2026), mis en œuvre en 1.35.0. Complète les décisions 0006 (IA optionnelle), 0016 (isolation des groupes), 0034 (abonnements), 0045 et 0046 (Accueil en widgets).

## Contexte

OwnCoffer suit bien le présent (comptes, budget, prévisions, crédits) mais aide peu à préparer l'avenir et à partager. Les idées d'amélioration retenues le 14 novembre 2026 touchent toutes la planification et le suivi : mettre de côté pour un projet, lisser les grosses dépenses de l'année, connaître son patrimoine net et la santé de ses finances, préparer la déclaration de revenus, ne plus oublier un remboursement attendu, un préavis de résiliation ou un rappel, partager les dépenses du foyer, et figer les mois déjà vérifiés.

## Décision

Quatre nouvelles pages et quelques ajouts aux pages existantes. **Tous les montants sont calculés par le moteur déterministe**, en centimes entiers (cœur `shared/lib/src/plan/`, testé) ; l'IA n'y a aucun rôle. Chaque point d'accès vérifie le groupe et le rôle (`Access`) et a son test d'isolation.

1. **Projets** (rubrique Prévoir) :
   - **projets d'épargne** : nom, somme à atteindre, déjà de côté, date et compte facultatifs ; avec une date, la mensualité nécessaire, et la date dépassée signalée ; archivage ;
   - **dépenses lissées** : les opérations prévues qui reviennent moins d'une fois par mois sont ramenées à une mensualité, avec ce qui devrait déjà être de côté avant la prochaine échéance.
2. **Patrimoine** (rubrique Prévoir) :
   - **patrimoine net** : comptes visibles + biens déclarés (valeur et date d'estimation) − capital restant dû des crédits visibles ;
   - **livrets réglementés** (Livret A, LDDS, LEP, Livret jeune) : taux et plafond réglés par un administrateur, intérêts estimés par la règle des quinzaines ;
   - **santé financière** : note sur 100, moyenne des indicateurs connus (épargne de précaution, taux d'épargne, endettement, régularité) sur les derniers mois complets ; un indicateur sans données est « inconnu » et ne compte pas ;
   - **bilan de l'année** : revenus, dépenses, épargne, intérêts estimés, plus grosses catégories, et les montants des catégories marquées « utiles aux impôts ». OwnCoffer ne calcule pas l'impôt.
3. **À plusieurs** (rubrique Argent) : dépenses partagées (qui a payé, pour qui), soldes entre membres et le moins de remboursements possible pour être quittes ; **pot commun** réparti au prorata des revenus déclarés (à parts égales tant qu'aucun revenu n'est connu).
4. **Suivi** (rubrique Papiers) :
   - **remboursements attendus**, marqués reçus automatiquement à l'arrivée d'un crédit du même montant, notification après la date limite ;
   - **contrats** : date de renouvellement et préavis rattachés à une opération prévue, dernier jour pour résilier calculé, notification dans le mois qui précède ;
   - **événements** (mariage, vacances, déménagement) regroupant des opérations de plusieurs comptes, avec un budget facultatif ;
   - **rappels** personnels datés, notifiés le jour venu, visibles seulement par leur auteur.
5. **Clôture des mois** (Budget, administrateur) : « mois vérifiés jusqu'au » ; une opération datée jusqu'à cette date ne peut plus être créée, modifiée, classée, ventilée, supprimée ou restaurée, ni reclassée par une règle. Les imports bancaires ne sont pas bloqués.
6. **Vues enregistrées** dans Opérations : recherche et filtres nommés, gardés sur l'appareil (au plus 12).
7. **Trois widgets d'Accueil**, ajoutés à la fin de la liste et demandés au serveur seulement s'ils sont posés : **Projets** (à mettre de côté par mois, avancement des projets en grand), **Patrimoine** (patrimoine net, ses parties en moyen et en grand), **Santé financière** (la note, l'indicateur le plus faible en moyen, les indicateurs en grand).

## Conséquences

- Nouvelles tables `savings_projects`, `assets`, `expected_refunds`, `life_events`, `event_operations`, `shared_expenses`, `pot_shares`, `reminders` ; nouvelles colonnes sur les groupes (clôture, pot commun), les opérations prévues (renouvellement, préavis), les comptes (livret, taux, plafond) et les catégories (utile aux impôts). Migrations PostgreSQL et SQLite.
- L'export et le transfert de données reprennent les nouvelles tables.
- Le travail horaire ajoute trois notifications : remboursement en retard, préavis de contrat, rappel du jour.
- Recherche globale, aide et textes en français et en anglais pour les quatre pages ; `HomeTileKind.projects`, `netWorth` et `health` en fin d'énumération.
