# 0003 — Une seule banque prise en charge au départ

**Statut** : Décidé (30 octobre 2026)

## Contexte

Chaque banque produit des exports QIF, OFX et CSV avec ses propres particularités (encodage, format de date, libellés). Les prendre toutes en charge dès le départ ralentirait la première version utilisable.

## Décision

L'import est d'abord développé et testé pour **une seule banque : la Caisse d'Épargne** (export « Money » QIF d'abord, puis OFX et CSV si proposés).

## Conséquences

- Les relevés de test anonymisés proviennent de la Caisse d'Épargne uniquement.
- Le code de lecture des fichiers reste générique (QIF, OFX, CSV standards) ; les particularités de la banque sont isolées dans un module dédié, pour que d'autres banques s'ajoutent ensuite sous forme d'« importeurs communautaires ».
- Les règles communautaires v0 visent les libellés tels qu'ils apparaissent dans cette banque.
