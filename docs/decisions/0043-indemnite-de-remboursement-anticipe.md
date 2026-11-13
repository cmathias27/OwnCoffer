# 0043 — Indemnité de remboursement anticipé

**Statut** : Décidé (13 novembre 2026), mis en œuvre en 1.28.0.

## Contexte

La simulation d'un remboursement anticipé montrait les intérêts économisés et la nouvelle date de fin. Elle ne montrait pas l'indemnité que la banque peut demander. Cette indemnité peut annuler une bonne partie de l'économie, surtout quand le remboursement a lieu en fin de crédit. L'offre de prêt en fixe la clause, mais la loi la plafonne. Le ROADBOOK demande que l'indemnité soit lue dans l'offre et calculée par le moteur.

## Décision

1. **La clause de l'offre est gardée dans le crédit.** Deux colonnes facultatives sont ajoutées à `loans` :
   - `prepaymentInterestMonths` : des mois d'intérêts sur la somme remboursée, de 0 à 12 ;
   - `prepaymentPercentMilli` : un pourcentage de la somme remboursée, en millièmes de pour cent, de 0 à 10 %.

   Si l'offre donne les deux, le plus bas s'applique. Une valeur 0 veut dire qu'il n'y a pas d'indemnité. Les deux colonnes vides veulent dire que la clause est inconnue. Un crédit renouvelable ou un paiement en plusieurs fois ne garde pas de clause.
2. **Calcul par le moteur** (`prepaymentPenalty`, `shared/lib/src/loans/prepayment.dart`, en Dart pur). Le plafond légal français (Code de la consommation) dépend du type de crédit :
   - **prêt immobilier** (L313-47, R313-25) : 6 mois d'intérêts sur la somme remboursée, au taux en vigueur à ce moment-là, et au plus 3 % du capital dû avant le remboursement ;
   - **crédit à la consommation** (L312-34) : 1 % de la somme remboursée, ou 0,5 % s'il reste au plus 12 échéances. L'indemnité ne dépasse jamais les intérêts économisés. Elle est nulle tant que les remboursements anticipés des 12 derniers mois, celui-ci compris, ne dépassent pas 10 000 €. Les autres types de crédit (auto, perso, études, autre) suivent cette règle ;
   - **crédit renouvelable et paiement en plusieurs fois** : pas d'indemnité.

   Si la clause est connue, l'indemnité est celle de la clause, sans jamais dépasser le plafond légal. Sinon, c'est le plafond légal qui est montré, en le disant.
3. **La simulation** (`loan.simulate`) renvoie l'indemnité, le plafond légal, la base du calcul (`offer`, `legalMax` ou `none`) et l'économie nette. L'outil `simulate_early_repayment` de l'IA renvoie les mêmes chiffres. Ces champs restent facultatifs, si bien que les anciens clients continuent de marcher.
4. **Lecture de l'offre par l'IA** (décisions 0008 et 0009). L'IA recopie la clause telle qu'elle est écrite. Elle est proposée dans la même proposition `update_loan`, avec la valeur d'avant pour pouvoir l'annuler. Les deux clés n'entrent dans la version des données du crédit que lorsqu'elles sont connues. Ainsi, les propositions faites avant la 1.28.0 restent valables.
5. **Exonérations non calculées.** Un prêt immobilier n'a pas d'indemnité après une vente liée à une mutation professionnelle, au décès ou à la perte d'emploi subie de l'emprunteur. OwnCoffer ne peut pas le savoir : l'aide et l'outil de l'IA le signalent.

## Conséquences

- Il y a une migration PostgreSQL et SQLite : deux colonnes, qui peuvent rester vides.
- Les montants sont en centimes entiers et arrondis au centime le plus proche. Ils restent dans les bornes des entiers, même au plafond du prêt.
- Tests :
  - `shared/test/prepayment_test.dart` : les deux plafonds, la clause plus basse ou plus haute que la loi, l'absence d'indemnité, la dernière année, les intérêts économisés, le seuil de 10 000 €, les bornes, le taux à une date ;
  - `server/test/integration/loans_test.dart` : maximum légal, clause de l'offre, valeurs refusées, isolation, crédit renouvelable ;
  - `server/test/integration/documents_ai_test.dart` : clause lue, acceptée puis annulée ;
  - `app/test/loans_form_test.dart`.
