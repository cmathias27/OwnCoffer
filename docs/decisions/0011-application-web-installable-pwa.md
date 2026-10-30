# 0011 — Application web installable sur téléphone (PWA)

**Statut** : Décidé (30 octobre 2026)

## Contexte

Les applications Windows et Android natives sont prévues en phase 6. En attendant, l'application doit être utilisable confortablement sur téléphone.

## Décision

L'application web Flutter est une **PWA** : installable sur l'écran d'accueil d'Android (et des autres plateformes qui le permettent), interface adaptée aux petits écrans.

## Conséquences

- Phase 1 : manifeste, icônes, nom, couleurs ; mise en page qui s'adapte du téléphone à l'ordinateur.
- **Aucune donnée financière mise en cache sur l'appareil** par la PWA : seul le code de l'application est mis en cache ; les données restent sur le serveur (pas de mode hors-ligne avant la phase 6).
- Les applications natives de la phase 6 deviennent un confort (hors-ligne, notifications système, widgets), plus une nécessité.
