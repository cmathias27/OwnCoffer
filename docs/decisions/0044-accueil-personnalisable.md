# 0044 — Accueil personnalisable

**Statut** : Décidé (13 novembre 2026), mis en œuvre en 1.29.0.

## Contexte

L'Accueil (décision 0041, point 6) montre toujours les mêmes cartes, dans le même ordre : Pépite, la phrase « tout va bien ? », Premiers pas, À surveiller, Conseils du moment, Total des comptes, Reste à vivre, Bilan du mois, Cette semaine, Ce mois-ci. Chacun ne regarde pas les mêmes choses : l'un veut voir d'abord le reste à vivre, l'autre n'a que faire de Pépite. L'utilisateur a demandé de pouvoir choisir ce qui apparaît sur l'Accueil.

## Décision

1. **Un bouton « Personnaliser l'accueil »**, en bas de l'Accueil, ouvre un éditeur. Chaque carte y a une case pour l'afficher ou la masquer, et une poignée pour la faire glisser à sa place. « Rétablir » revient à l'Accueil d'origine ; rien n'est gardé avant « Enregistrer ».
2. **Les cartes restent celles du moteur.** L'éditeur ne choisit que l'ordre et la présence des cartes existantes ; chacune garde son calcul, ses « Pourquoi ce chiffre ? » et la page où elle mène. Une carte sans données (pas de conseiller, pas de mois à montrer) reste absente même si elle est cochée. « Conseils du moment » n'est proposée que là où Mon conseiller existe.
3. **Mise en page.** Pépite et la phrase de synthèse tiennent toute la largeur ; les autres cartes se partagent deux colonnes sur un grand écran, dans l'ordre choisi. Si toutes les cartes sont masquées, l'Accueil le dit et garde le bouton.
4. **Gardé sur l'appareil**, avec les autres choix d'affichage (décision 0041, `UiPrefs`, clé `home`), sous la forme `nom,-nom,…` : un `-` masque la carte. Aucune donnée bancaire, rien n'est envoyé au serveur ; un autre appareil garde son propre Accueil, comme pour le mode simple ou la taille du texte.
5. **Compatibilité.** Un nom inconnu est ignoré. Une carte ajoutée par une version suivante, absente du choix gardé, vient en dernier et s'affiche. Sans choix gardé, l'Accueil est celui d'avant (en mode simple, « Ce mois-ci » reste masqué).
6. **Premiers pas** garde son propre réglage (« Masquer » sur la carte) : l'éditeur le montre et le change, et la recocher fait revenir la carte.

## Conséquences

- Aucun changement du serveur ni de la base ; pas de migration.
- Les tests (`app/test/home_layout_test.dart`) couvrent la lecture et l'écriture du choix, les noms inconnus, une carte nouvelle, Premiers pas, et l'éditeur (masquer, annuler, rétablir, déplacer).
- Une synchronisation de l'Accueil entre appareils pourra venir plus tard, par une nouvelle décision, si l'usage le demande.
