# 0042 — Tableau d'amortissement lu en entier

**Statut** : Décidé (12 novembre 2026), mis en œuvre en 1.27.0.

## Contexte

Avec l'IA, la lecture d'un document de crédit (0.3.31) proposait les conditions de l'offre : taux, durée, mensualité, assurance. Elle comparait aussi au calcul les premières lignes du tableau d'amortissement. En revanche, un crédit qui a changé en cours de route restait faux. C'est le cas d'un taux variable révisé, d'une renégociation, d'un report d'échéances ou d'un remboursement anticipé. Il fallait alors saisir chaque changement à la main, en le lisant soi-même dans le tableau. De plus, le moteur ne savait pas représenter une pause des mensualités.

## Décision

1. **Pause d'échéances dans le moteur** (`LoanChange.pauseMonths`, `pauseCapitalized`, `shared/lib/src/loans/amortization.dart`). Pendant `pauseMonths` mois à partir de la date du changement :
   - **report partiel** : seuls les intérêts (et l'assurance) sont dus, le capital ne baisse pas ;
   - **report total** : rien n'est payé sauf l'assurance, et les intérêts s'ajoutent au capital restant dû ;
   - le crédit finit d'autant plus tard ;
   - la mensualité est recalculée après la pause sur la durée restante, sauf si la mensualité prélevée est connue ;
   - la pause dure de 1 à 120 mois ;
   - ce qui est dû reste borné (5 fois le plafond d'un prêt) pour rester dans les entiers.

   Les échéances en pause sont marquées (`paused`). Celles sans aucun montant à prélever ne sont pas attendues par le rapprochement des prélèvements (décision 0040).
2. **L'IA recopie, le moteur déduit.** Le modèle recopie chaque ligne du tableau (numéro, mensualité, intérêts, capital restant dû), sans rien calculer, sur 12 pages au plus (5 auparavant). C'est `readLoanTable` (`shared/lib/src/loans/loan_table.dart`), en Dart pur et sans IA, qui cherche les changements. Il calcule l'échéancier et s'arrête sur la première ligne qu'il n'explique pas. Il essaie alors les changements que cette ligne suggère :
   - une pause (capital inchangé, ou qui augmente), sur autant de lignes qui se suivent ;
   - un nouveau taux, déduit des intérêts et du capital dû avant la ligne, seul ou avec une nouvelle mensualité ;
   - une nouvelle mensualité ;
   - une somme remboursée (ou utilisée), avant ou après la ligne.

   Un changement n'est gardé que s'il explique cette ligne **et la suivante**. Une seule ligne mal lue n'invente donc jamais de changement : elle est signalée comme un écart. L'écart toléré est de 1 € par chiffre, et de 0,05 % en plus sur le capital restant (les arrondis de la banque). La recherche reste bornée : 40 changements au plus, et elle s'arrête après 24 lignes inexpliquées.
3. **La ligne 1** donne les intérêts de la première échéance (période intercalaire) quand le crédit ne les a pas.
4. **Proposition** (décision 0009) :
   - les changements trouvés sont proposés comme la liste `events` du crédit, dans la même proposition `update_loan` que les conditions ;
   - les changements déjà enregistrés avant la première ligne lue, ou après la dernière, sont gardés ;
   - la proposition n'est faite que si le résultat diffère de l'existant et si l'échéancier obtenu est valable ;
   - elle s'annule comme les autres ;
   - Mon conseiller montre les changements ajoutés et retirés, les échéances lues (de … à …), le nombre de changements trouvés et les écarts restants.
5. **Saisie à la main** : un nouveau type de changement, « Report d'échéances (pause) », avec le nombre de mois et le choix entre intérêts payés et rien payé. L'échéancier marque les mois en pause. L'outil `simulate_loan_change` de l'IA accepte aussi la pause.

## Conséquences

- Les événements d'un crédit sont gardés dans le crédit lui-même. Il n'y a pas de nouvelle table, donc pas de migration.
- Les propositions faites avant la 1.27.0 n'ont pas de clé `events` et restent valables.
- Tests :
  - `shared/test/loan_table_test.dart` : pauses partielle, totale, d'emblée, aux limites ; taux révisé chaque année ; renégociation et remboursement ; tableau arrondi par la banque ; ligne mal lue ; ligne 1 intercalaire ; tableau partiel ou désordonné ; 600 lignes incohérentes en moins de 5 s ;
  - `server/test/integration/documents_ai_test.dart` : tableau complet proposé, accepté, relu sans nouvelle proposition, puis annulé ; pause saisie, hors limites et isolation ;
  - `app/test/loans_form_test.dart`.
