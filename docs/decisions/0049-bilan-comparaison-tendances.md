# 0049 — Widgets Mois écoulé, Comparaison et Tendances

**Statut** : Décidé (14 novembre 2026), mis en œuvre en 1.34.0. Complète les décisions 0045, 0046 et 0047.

## Contexte

L'Accueil en widgets (décision 0045) résume le mois en cours (Bilan du mois, Ce mois-ci, Répartition des dépenses, Objectifs du budget). Trois questions restent sans widget, alors que le moteur y répond déjà dans Budget : comment s'est fini le mois dernier, qu'est-ce qui change ce mois-ci par rapport aux précédents, et quelle est la tendance sur plusieurs mois.

## Décision

Trois nouveaux widgets, ajoutés à la fin de la liste (les dispositions déjà gardées restent lisibles), en petit, moyen ou grand :

1. **Mois écoulé** : le bilan du dernier mois budgétaire terminé, tel que le calcule le moteur (`analysis.review`, la page Bilan du mois).
   - Petit : le solde du mois (revenus moins dépenses et épargne), en couleur.
   - Moyen : en plus, le solde du mois d'avant et une alerte (objectifs dépassés, frais bancaires).
   - Grand : en plus, les plus fortes hausses par catégorie et la plus grosse dépense.
   - Un toucher ouvre le Bilan du mois sur ce mois-là. Les chiffres ne sont demandés au serveur que si le widget est sur l'Accueil.
2. **Comparaison** : le mois en cours face à la moyenne des trois mois précédents, catégorie par catégorie, avec les hausses et les baisses que le moteur relève déjà dans le Bilan du mois.
   - Petit : la plus forte hausse ; moyen : la plus forte hausse et la plus forte baisse ; grand : jusqu'à trois hausses et deux baisses, chacune avec sa moyenne.
   - Rien de notable : le widget le dit.
   - Un toucher ouvre le Bilan du mois en cours.
3. **Tendances** : les revenus et les dépenses des six derniers mois (l'historique du rapport de Budget, déjà chargé par l'Accueil).
   - Petit : la dépense moyenne des mois terminés.
   - Moyen : les barres des dépenses mois par mois, le mois en cours plus clair puisqu'il n'est pas fini.
   - Grand : les barres des revenus et des dépenses, avec les moyennes des mois terminés.
   - Un toucher ouvre Budget.

Les montants viennent du moteur (rapport et bilan) ; l'application ne fait que les afficher, et calcule seulement la moyenne des mois terminés, en centimes entiers.

## Conséquences

- `HomeTileKind.review`, `comparison` et `trends`, ajoutés en fin d'énumération.
- Le bilan du mois écoulé est demandé seulement quand le widget Mois écoulé est posé ; le bilan du mois en cours et le rapport de Budget sont déjà chargés par l'Accueil.
- Ouvrir le bilan d'un mois compte pour le badge « Bilan du mois » de Pépite, comme depuis Budget.
- Textes en français et en anglais ; tests des trois widgets à chaque taille.
