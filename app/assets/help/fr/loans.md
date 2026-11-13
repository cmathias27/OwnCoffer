# Crédits

Vos crédits et paiements en plusieurs fois, ce qu'il reste à rembourser et votre taux d'endettement.

## Trois familles

La page range vos crédits en **Crédits** (immobilier, auto, études…), **Crédits à la consommation** (dont le renouvelable) et **Paiements en plusieurs fois**, chacune avec sa mensualité totale et ce qu'il reste à rembourser. Les puces en haut choisissent les familles affichées ; le menu de tri les classe par reste à rembourser, mensualité, date de fin ou organisme. Les crédits terminés passent en dernier.

## Ajouter un crédit

- Depuis un prélèvement, c'est le plus simple : dans la fiche de l'opération, **« C'est une échéance de crédit »**. Le formulaire est prérempli, les échéances passées sont retrouvées et une règle classera les suivantes.
- Ou à la main : organisme, type, capital, taux, durée, première échéance, assurance, compte de prélèvement.
- **« Repérés dans vos opérations »** liste les paiements en plusieurs fois (Oney, Alma, Klarna…) et petits crédits prélevés récemment qui ne sont pas encore déclarés.

La **mensualité prélevée** fait foi : le tableau, le capital restant et la date de fin en partent.

## Ce que montre un crédit

La fiche d'un crédit est rangée en onglets : **Résumé**, **Échéancier**, **Opérations**, **Documents** et, tant qu'il reste des échéances, **Simuler**.

- **Tableau d'amortissement**, capital restant dû, intérêts payés et à payer, coût total, date de fin.
- Les **prélèvements** déjà rattachés et le total payé.
- **Échéances vérifiées** : avec un compte de prélèvement, chaque échéance des relevés importés est comparée aux prélèvements réels ; une échéance sans prélèvement, prélevée deux fois ou d'un autre montant, et un prélèvement loin de toute échéance sont signalés avec leurs montants.
- **Remboursement anticipé simulé** : intérêts économisés, nouvelle date de fin, **indemnité** et économie nette. L'indemnité suit la clause de l'offre de prêt (à saisir dans la fiche, ou lue par l'IA dans l'offre), sans jamais dépasser le maximum légal : pour un prêt immobilier, 6 mois d'intérêts sur la somme remboursée et au plus 3 % du capital dû ; pour un crédit à la consommation, 1 % (0,5 % la dernière année), jamais plus que les intérêts économisés, et rien jusqu'à 10 000 € remboursés sur 12 mois. Sans la clause, c'est ce maximum qui est montré. Pas d'indemnité sur un crédit renouvelable ni un paiement en plusieurs fois. Un prêt immobilier n'en a pas non plus après une vente liée à une mutation, un décès ou une perte d'emploi subie : OwnCoffer ne le sait pas, c'est à vous de le vérifier.
- **Documents** : tableau d'amortissement, offre de prêt, captures, gardés sur votre serveur.

Avec un compte de prélèvement, les échéances entrent dans le **solde prévu**.

## Renégocier ou changer de taux

La carte **« Renégocier ou changer de taux »** de la fiche d'un crédit simule l'offre de votre banque : nouveau taux, nouvelle mensualité ou nouvelle durée, et les **frais** du changement. OwnCoffer compare **aujourd'hui et après** : mensualité, intérêts restants, échéances, date de fin, puis l'**économie nette** des frais et le **mois où c'est rentabilisé**. **« Enregistrer ce changement »** l'ajoute aux changements du crédit.

## Changements : taux variable, renégociation, pause

Dans la fiche d'un crédit, **« Ajouter un changement »** :

- **Nouveau taux** (taux variable) : à partir d'une date. La date de fin est gardée et la mensualité recalculée ; si la mensualité prélevée est connue, elle est gardée et c'est la date de fin qui bouge.
- **Renégociation** : nouveau taux, et nouvelle mensualité ou nouvelle durée restante.
- **Report d'échéances (pause)** : la banque suspend les mensualités quelques mois. **Intérêts payés** (report partiel) : seuls les intérêts et l'assurance sont prélevés. **Rien payé** (report total) : seule l'assurance est prélevée, les intérêts s'ajoutent à ce qui reste à rembourser. Le crédit finit d'autant plus tard ; dans l'échéancier, ces mois sont marqués « (pause) ».
- **Remboursement anticipé** : une somme remboursée en plus ; la mensualité est gardée, le crédit finit plus tôt.

Le tableau, le capital restant, les échéances prévues et la prévision du solde suivent. Un changement se retire d'un geste. Un changement qui ne permettrait jamais de rembourser le crédit est refusé.

## Crédit renouvelable

Choisissez le type **« Crédit renouvelable »** : indiquez le **montant utilisé** aujourd'hui, la **mensualité** prélevée, le taux et, si vous le voulez, le **plafond** de la réserve. La durée en découle. Chaque **nouvelle utilisation** s'ajoute dans « Changements » ; la fiche montre ce qui reste **disponible**. Une utilisation au-delà du plafond est refusée.

## Lire un document avec l'IA

Avec l'assistant activé et un modèle qui lit les images, le bouton ✨ d'un document du crédit le fait lire : les conditions qu'il indique (taux, durée, mensualité, assurance…) sont **proposées** dans Mon conseiller, avec l'avant et l'après. Rien ne change sans votre accord.

Pour un **tableau d'amortissement**, l'IA recopie chaque ligne (jusqu'à 12 pages) ; c'est le moteur d'OwnCoffer, sans IA, qui compare chaque échéance à son calcul et **en déduit les changements** : nouveau taux, nouvelle mensualité, pause, remboursement anticipé, avec leur date. Ils sont proposés comme les « Changements » du crédit, et ceux que vous aviez saisis avant la première ligne lue sont gardés. Une ligne que rien n'explique (chiffre mal lu, par exemple) est **signalée**, jamais devinée.

## Taux d'endettement

Mensualités divisées par les revenus moyens des trois derniers mois, avec un repère à 35 %. Il est indicatif : le calcul de votre banque fait foi.
