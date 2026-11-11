# 0034 — Abonnements mis en évidence dans Opérations et hausses de prix

**Statut** : Décidé (11 novembre 2026), mis en œuvre en 1.19.0

## Contexte

Les abonnements sont des opérations planifiées marquées comme telles (`ScheduledTransaction.subscription`). Leur page dédiée donnait déjà le coût par mois et par an, mais dans Opérations un abonnement n'était signalé que par une icône : rien ne montrait le total, ni qu'un prélèvement avait augmenté, ni qu'une hausse était annoncée (fin d'offre promotionnelle, nouveau tarif communiqué par le fournisseur).

## Décision

1. **Total dans Opérations.** Le filtre « Abonnements » affiche en tête de liste le total mensuel des abonnements actifs (fin non passée) et leur nombre, avec un lien vers la page Abonnements. Le total utilise `monthlyEquivalentCents` du moteur partagé (`owncoffer_shared`), comme la page Abonnements : aucun calcul de montant ailleurs.
2. **Hausse constatée.** Quand une opération rattachée à un abonnement coûte plus que le montant prévu (comparaison des valeurs absolues, les dépenses étant négatives), la ligne porte un badge « Hausse +X » et sa fiche propose, en un geste, de mettre l'abonnement au nouveau montant (`scheduled.update`, déjà contrôlé et journalisé). Rien n'est modifié sans ce geste.
3. **Hausse annoncée.** Deux champs facultatifs sur `ScheduledTransaction` : `priceRiseDate` et `priceRiseAmountCents` (migrations PostgreSQL et SQLite).
   - `scheduled.setPriceRise(id, date:, amountCents:)` enregistre ou efface le rappel ; l'utilisateur saisit un montant positif, le serveur lui donne le signe de l'abonnement.
   - `scheduled.applyPriceRise(id)` reporte le nouveau montant sur l'abonnement et efface le rappel ; erreur `no_price_rise_scheduled` s'il n'y en a pas.
   - Les deux passent par `_find` (groupe, rôle d'écriture, visibilité du compte), recalculent les alertes et sont journalisés ; tests d'isolation (membre d'un autre groupe, lecteur) dans `budget_test.dart`.
4. **Rappel visible.** Une hausse prévue (jusqu'à 7 jours après sa date) s'affiche dans la carte du filtre Abonnements, dans la page Abonnements et dans la fiche de l'opération ; « Appliquer » apparaît dès que la date est atteinte. Pas de notification ni d'application automatique : l'utilisateur garde la main.
5. **Prévisions.** Le montant prévu d'un abonnement reste `amountCents` tant que la hausse n'est pas appliquée ; la prise en compte automatique de la hausse dans les prévisions est laissée pour plus tard.

## Conséquences

- Aucune dépendance ajoutée, aucun appel réseau, aucune IA.
- Les anciennes sauvegardes restent lisibles (colonnes nullables).
- Textes en français et en anglais.
