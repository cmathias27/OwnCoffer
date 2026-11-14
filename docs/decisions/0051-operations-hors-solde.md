# 0051 — Opérations et catégories hors solde (débit différé)

**Statut** : Décidé (14 novembre 2026), mis en œuvre en 1.36.0. Complète les décisions 0001 (Serverpod), 0016 (isolation des groupes), 0022 (version autonome SQLite) et 0050 (clôture des mois).

## Contexte

Dans les banques proposant une carte bancaire à débit différé, les dépenses par carte apparaissent au fil du mois, puis un prélèvement global (« Débit différé de carte ») est débité en fin de mois pour régler l'ensemble des paiements carte.

Jusqu'alors dans OwnCoffer, la catégorie standard `transfers.card_settlement` (« Débit différé de carte ») était exclue du calcul de budget pour éviter les doublons avec les dépenses par carte classées individuellement, mais elle était comptée dans le solde du compte. Conséquence : les paiements par carte réduisaient le solde, et le débit différé mensuel réduisait à nouveau le solde, faussant le solde réel, le solde pointé et la courbe prévisionnelle.

L'utilisateur a exprimé le besoin de pouvoir décider si une dépense (ou toute une catégorie) doit être déduite du compte ou pas, en ciblant le total mensuel du débit différé pour le retirer du solde, tout en permettant un réglage au niveau de la catégorie avec dérogation facultative par opération.

## Décision

1. **Niveau Catégorie (`Category.excludedFromBalance: bool`, défaut `false`)** :
   - Toute catégorie peut être configurée pour exclure ses opérations du solde des comptes.
   - La catégorie catalogue standard `transfers.card_settlement` (« Débit différé de carte ») a désormais `excludedFromBalance = true` par défaut.
   - Les groupes existants voient cette catégorie mise à jour lors de la migration et au démarrage du serveur (`updateAllStandardCategories`).
   - L'écran des catégories permet d'activer ou désactiver ce comportement via le point d'accès `client.category.setExcludedFromBalance`.

2. **Niveau Opération (`BankTransaction.balanceOverride: bool?`, défaut `null`)** :
   - `null` : l'opération suit le statut de sa catégorie (`isEffectiveInBalance`).
   - `true` : l'opération est forcée dans le solde, même si sa catégorie est hors solde.
   - `false` : l'opération est exclue du solde, même si sa catégorie est normale.
   - Modifiable depuis la fiche détail d'une opération (`showOperationSheet`), sous la section Suivi, via `client.transaction.setBalanceOverride`.
   - Respecte l'isolation des groupes (`Access.requireMember`) et le verrouillage de clôture de mois (`Closing.check`).

3. **Moteur financier partagé et requêtes SQL** :
   - `core.isEffectiveInBalance({bool? balanceOverride, bool categoryExcludedFromBalance = false})` dans `shared/lib/src/categories.dart`.
   - `core.computeBalances` et `core.computeForecast` intègrent `inBalance: bool` sur `BalanceInput` et `RealOperation`.
   - `ForecastService.balancesOf` utilise une requête SQL standard portable (PostgreSQL et SQLite) joignant `categories` :
     `(t."balanceOverride" = TRUE OR (t."balanceOverride" IS NULL AND (c."excludedFromBalance" IS NULL OR c."excludedFromBalance" = FALSE)))`.
   - `AccountEndpoint.checkBalance` et `ImportService._balanceAfterImport` ignorent les opérations hors solde pour le calcul du solde pointé et réel.

4. **Interface utilisateur** :
   - Badge « Hors solde » affiché sur les lignes d'opérations exclues du solde (`OperationTile`).
   - Sélecteur « Prise en compte dans le solde » avec option « Comme la catégorie (incluse / hors solde) », « Déduite du compte (incluse) », « Hors solde (non déduite) ».
   - Badge « Hors solde » et interrupteur dans l'écran des catégories.

## Conséquences

- Nouvelles colonnes `excludedFromBalance` sur `categories` et `balanceOverride` sur `transactions`. Migrations PostgreSQL et SQLite générées et testées.
- Les totaux de soldes n'intègrent plus le débit différé mensuel par défaut, évitant le doublon avec les cartes bancaires.
- Aucun impact sur le budget, qui continue de suivre les règles de `StandardCategoryDef.kind` et `BudgetService`.
