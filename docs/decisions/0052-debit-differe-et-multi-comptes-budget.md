# 0052 — Carte à débit différé (période et en-cours) et sélection multi-comptes dans le budget

**Statut** : Décidé (16 novembre 2026), prévu en 1.39.0. Complète les décisions 0001 (Serverpod), 0016 (isolation des groupes), 0022 (version autonome SQLite), 0041 (refonte de l'interface), 0050 (projets et patrimoine) et 0051 (opérations hors solde).

## Contexte

Dans les banques françaises (notamment la Caisse d'Épargne), une carte bancaire à débit différé fonctionne sur un cycle mensuel précis :
- Les dépenses par carte sont arrêtées à une date fixe (ex. le 28 du mois).
- Le montant total accumulé (« en-cours ») est prélevé en une seule fois sur le compte courant à une date de règlement convenue (ex. le 4 du mois suivant).

Jusqu'à présent :
1. Si l'utilisateur importait ses opérations de carte sur son compte courant, le solde baissait immédiatement au fil de l'eau, créant un décalage permanent avec le solde réel de la banque pendant tout le mois et rendant le pointage impossible.
2. Si un compte dédié `AccountKind.deferredCard` était créé, il ne disposait pas de la notion de cycle/période de facturation : son solde cumulait l'historique sans distinction du cycle actif ou en cours de prélèvement.
3. Dans la vue Budget et analyse (« Reste à vivre », répartition, comparaison), le sélecteur de compte n'autorisait que deux choix : soit un seul compte, soit tous les comptes réunis. L'utilisateur disposant d'un compte courant et d'une carte à débit différé ne pouvait donc pas analyser son budget sur ces deux comptes quotidiens sans y inclure l'ensemble de ses livrets d'épargne.

## Décision

### 1. Cycle et en-cours de carte à débit différé (`AccountKind.deferredCard`)

1. **Paramètres sur le compte** (`Account`):
   - `statementCutoffDay: int?` (1 à 31, ex. 28) : jour d'arrêté mensuel du relevé de carte.
   - `statementDebitDay: int?` (1 à 31, ex. 4) : jour de débit/prélèvement du montant total sur le compte courant.
   - `linkedAccountId: int?` (optionnel) : compte courant sur lequel le prélèvement est débité.
   - Configurables lors de la création ou modification d'un compte de type `deferredCard`.

2. **Moteur partagé (`shared/lib/src/deferred_card/`)** :
   - Fonction pure déterministe `deferredCardCycle(today, {required cutoffDay, required debitDay})` retournant :
     - `activePeriod` : bornes inclusives du cycle actif en cours (ex. du 29 octobre au 28 novembre).
     - `activeDebitDate` : date d'échéance de prélèvement du cycle actif (ex. 4 décembre).
     - `pendingDebitPeriod` et `pendingDebitDate` : cycle précédent clos en attente de débit si la date du jour se situe entre l'arrêté et le jour de prélèvement (ex. entre le 29 novembre et le 4 décembre).

3. **Calcul de solde de la carte** :
   - Pour un compte `deferredCard` ayant un jour d'arrêté configuré, `ForecastService.balancesOf` calcule le solde restreint aux opérations du cycle actif (`date >= activePeriod.start AND date <= activePeriod.end`).
   - Le solde affiché correspond strictement à l'**en-cours carte de la période active**.
   - Si un cycle précédent est en attente de débit, `ForecastResult` expose `deferredPendingDebitCents` et `deferredPendingDebitDate` pour afficher la mention « À prélever le 4 déc. : -X,XX € ».

4. **Interface** :
   - Fiche compte et carte d'accueil : affichage « En-cours carte : -X,XX € » avec les dates du cycle actif.
   - Badge d'information si un prélèvement antérieur est en attente.

### 2. Sélection multi-comptes dans le budget et l'analyse

1. **Points d'accès serveur (`AnalysisEndpoint`)** :
   - `report`, `leftToLive`, `operations` et `review` acceptent un paramètre `List<int>? accountIds`.
   - `SpendingService.accounts` valide que tous les comptes demandés appartiennent au groupe et sont visibles par l'utilisateur connecté (`Access.visibleAccounts`).
   - Rétro-compatibilité : `accountId` unique reste accepté si `accountIds` est omis.

2. **Interface Flutter (`BudgetScreen`, `CompareScreen`)** :
   - Le sélecteur de compte permet la sélection multiple : « Tous les comptes », un compte unique, ou une sélection personnalisée (ex. [x] Compte Courant, [x] Carte Débit Différé).
   - Le calcul de budget, les graphiques de dépenses, les opérations listées et le reste à vivre s'ajustent à l'ensemble des comptes choisis.

## Conséquences

- Nouvelles colonnes `statementCutoffDay`, `statementDebitDay` et `linkedAccountId` sur la table `accounts`.
- Migrations PostgreSQL et SQLite générées et testées.
- Cohérence bancaire parfaite : le compte courant reste fidèle à la banque au centime près, la carte reflète son en-cours exact, et le budget peut agréger les deux comptes de paiement du foyer.
