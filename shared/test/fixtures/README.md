# Fichiers de test

Relevés **entièrement inventés** : aucun montant, libellé, nom ou numéro ne provient d'un vrai compte. Les numéros de compte sont factices (`00000000000`).

- `sample_*` : écrits à la main d'après les formats publics QIF, OFX et CSV.
- `ce_export.qif` et `ce_export.ofx` : les mêmes 20 opérations inventées dans les deux formats, avec la **structure observée sur de vrais exports Caisse d'Épargne** :
  - fins de ligne CRLF, opérations de la plus récente à la plus ancienne ;
  - QIF : `T+18.65` (point décimal, signe `+` explicite), `P` = libellé d'opération (`CB … FACT jjmmaa`, `PRLV …`, `VIR SEPA …`, `ECH PRET …`), `M` = nom court donné par la banque ;
  - OFX 1.02 SGML : les mêmes textes **inversés** (`MEMO` = libellé d'opération, `NAME` = nom court tronqué à 32 caractères), une référence ajoutée au `MEMO` des prélèvements, un `CHECKNUM` sur chaque opération, balises tantôt fermées tantôt non.

Aucun vrai relevé n'est conservé, ni dans le dépôt ni sur le serveur.
