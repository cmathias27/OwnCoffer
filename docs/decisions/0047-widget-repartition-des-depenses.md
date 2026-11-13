# 0047 — Le widget « Répartition des dépenses »

**Statut**: Décidé (13 novembre 2026), mis en œuvre en 1.32.0. Complète les décisions 0045 et 0046.

## Contexte

Après la 1.31.0 (décision 0046), l'utilisateur relève qu'il manque toujours le widget du budget qu'il attendait: **la répartition en camembert**, la vue « Camembert » de la page Budget.

## Décision

1. **Un widget « Répartition des dépenses ».** Il montre les dépenses du mois par catégorie principale, avec les mêmes parts que le camembert de la page Budget: les plus grosses catégories, les plus petites regroupées dans « Autres » (même fonction du moteur, `sharesWithOthers`, mêmes couleurs).
   - **petit**: l'anneau seul;
   - **moyen**: l'anneau avec le total au centre, et la légende des trois premières parts avec leur pourcentage;
   - **grand**: l'anneau plus grand, et la légende avec montant et pourcentage.
   L'anneau est décrit aux lecteurs d'écran (chaque part et sa part en pourcentage). Toucher le widget ouvre la page Budget.
2. **Les données.** Les catégories ne sont demandées au serveur que si le widget est sur l'Accueil, comme pour « Ce mois-ci » (décision 0045, point 3). Sans dépense classée dans le mois, le widget le dit.
3. **Correction.** Les montants des catégories du rapport sont positifs (argent dépensé); « Ce mois-ci » en grand les cherchait négatifs et n'affichait donc jamais ses catégories. Il prend désormais, comme la répartition, les catégories de dépense principales, sans compter deux fois les sous-catégories.
4. **Compatibilité.** Le nouveau type s'ajoute à la fin de la liste: les dispositions enregistrées restent lues telles quelles.

## Conséquences

- Aucun changement du serveur ni de la base.
- `MiniDonut` (`app/lib/widgets/budget_charts.dart`) dessine l'anneau du camembert de Budget à toute taille.
- Les tests (`app/test/home_board_test.dart`) couvrent le widget à chaque taille et ses pourcentages, et les catégories de « Ce mois-ci ».
