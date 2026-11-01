# Import des relevés

OwnCoffer ne se connecte pas à votre banque : vous téléchargez vous-même le relevé sur son site, puis vous le donnez à OwnCoffer.

## Formats

- **OFX** (conseillé) : contient le solde de la banque, que l'on peut comparer, et reconnaît le compte tout seul.
- **QIF** et **CSV** : le CSV de la Caisse d'Épargne est reconnu ; pour un autre CSV, vous choisissez les colonnes (date, libellé, montant).

## Importer

1. Choisissez le fichier, puis le compte s'il n'est pas reconnu.
2. Lisez l'**aperçu** : les nouvelles opérations, les **doublons écartés** (déjà importées, même depuis un autre format), et les **doublons possibles** à cocher si ce sont bien des opérations différentes.
3. Enregistrez. Les opérations sont classées aussitôt par vos règles, les règles communes et votre historique.

Vous pouvez importer un relevé qui recouvre le précédent : ce qui est déjà là est reconnu et n'est pas compté deux fois.

## Plusieurs fichiers d'un coup

**« Plusieurs fichiers »** : choisissez plusieurs relevés (plusieurs mois, plusieurs comptes). Chacun est lu d'abord ; le compte est reconnu quand le fichier le dit (OFX), sinon c'est celui choisi, modifiable fichier par fichier. Les doublons possibles sont laissés de côté : pour les vérifier un par un, importez le fichier seul. Un CSV dont les colonnes ne sont pas reconnues s'importe seul.

## Annuler un import

**« Imports précédents »** liste les fichiers importés pour un compte ; **« Annuler cet import »** met à la corbeille les opérations qu'il avait ajoutées. Vos corrections sur ces opérations sont alors perdues.

## Confidentialité

Le numéro de compte présent dans un fichier OFX sert à reconnaître le compte ; il n'est pas enregistré.
