# 0040 — Crédit rapproché des prélèvements réels

**Statut** : Décidé (12 novembre 2026), mis en œuvre en 1.25.0.

## Contexte

Un crédit lié à un compte a une opération prévue pour ses échéances. Les prélèvements reconnus y sont rattachés, et une règle classe ceux qui suivent. Mais rien ne dit si chaque échéance a bien été payée : une mensualité oubliée par la banque, prélevée deux fois ou d'un montant inattendu (assurance changée, frais) passe inaperçue. Le ROADBOOK demande que le moteur le signale, sans IA.

## Décision

1. **Comparaison faite par le moteur** (`checkLoan`, `shared/lib/src/loans/loan_check.dart`), en Dart pur et testée. Elle compare l'échéancier calculé (`amortize`, avec les événements du crédit) aux prélèvements du crédit : ceux rattachés à son opération prévue ou classés par sa règle (les mêmes que la carte « Opérations du crédit »).
2. **Chaque prélèvement va à une seule échéance** :
   - celle à laquelle il a été rattaché, même loin de sa date (l'utilisateur l'a dit) ;
   - sinon la plus proche, à 15 jours au plus (la plus ancienne en cas d'égalité) ;
   - au-delà, il est « loin de toute échéance ».
3. **Résultat par échéance** :
   - **payée** : un prélèvement, du bon montant ;
   - **sans prélèvement** : aucun ;
   - **prélevée deux fois** : deux prélèvements ou plus ;
   - **autre montant** : un prélèvement dont l'écart dépasse 1 €, montré avec les deux montants.
   Le montant est bon avec ou sans l'assurance, qui est parfois prélevée à part.
4. **Seule la période importée est vérifiée** : du plus ancien au plus récent relevé du compte. Une échéance n'est déclarée sans prélèvement que si elle tombe dans cette période et au moins 5 jours avant sa fin, car la banque prélève parfois avec quelques jours de retard. Une échéance d'avant le premier relevé n'est donc pas comptée comme manquante.
5. **Affichage** : en tête de la carte « Opérations du crédit ». Il montre « Les N échéances … ont bien été prélevées » ou les points à vérifier, ainsi que la période et la méthode, suivant la décision 0007. Le tableau de la banque fait foi.
6. **Lecture seule** : rien n'est rattaché ni modifié. Point d'accès `loan.check`, avec les mêmes droits que la lecture du crédit. Il ne montre que les comptes visibles par l'utilisateur, et rien si le compte du crédit lui est caché.

## Conséquences

- Pas de nouvelle table, donc pas de migration.
- Une échéance remboursée par anticipation ou changée suit l'échéancier recalculé avec les événements du crédit.
- Tests : `shared/test/loan_check_test.dart` (à l'heure, en retard, manquante, hors période, en double, autre montant, centime d'arrondi, assurance à part, loin de toute échéance, rattachement manuel, prélèvement entre deux échéances) ; `server/test/integration/loan_from_operation_test.dart` (cas réel et isolation) ; `app/test/loan_check_test.dart`.
