# 0045 — L'Accueil en widgets placés librement

**Statut** : Décidé (13 novembre 2026), mis en œuvre en 1.30.0. Remplace la décision 0044.

## Contexte

La décision 0044 a permis de masquer et de réordonner les cartes de l'Accueil dans une liste. Ce n'était pas la demande : l'utilisateur voulait que **chaque élément de l'application devienne une tuile, façon widget**, posée et rangée où il le souhaite sur l'Accueil. Précisé avec lui :

- trois tailles : petit, moyen, grand ;
- une grille libre : chaque widget va sur la case choisie, des trous sont permis ;
- la modification se fait directement sur l'Accueil ;
- chaque widget montre un résumé vivant de sa page et y mène.

## Décision

1. **Une grille de widgets.** L'Accueil est une grille de 2 colonnes sur un téléphone, de 4 colonnes à partir de 600 points de large. Un widget **petit** prend 1 × 1 case, **moyen** 2 × 1, **grand** 2 × 2. Chaque widget a sa colonne et sa ligne ; les cases vides restent vides.
2. **Les widgets.** Ils reprennent les cartes de 0044 (Pépite, Tout va bien ?, Premiers pas, À surveiller, Conseils du moment, Total des comptes, Reste à vivre, Bilan du mois, Cette semaine, Ce mois-ci) et y ajoutent un widget par page : Comptes, Prévision (courbe des 30 jours et point bas), Opérations (les dernières), À classer, Abonnements (total et hausses), Crédits (reste dû, mensualités, prochaine échéance), Factures (sans opération), Imports (dernier relevé), Notifications. Chacun n'accepte que les tailles où il reste lisible ; son contenu grandit avec sa taille (un chiffre, puis une ligne, puis une liste ou une courbe).
3. **Toujours le moteur.** Chaque chiffre vient des mêmes fonctions déterministes que sa page ; « Pourquoi ce chiffre ? » et l'aide (?) restent sur les widgets assez grands. Toucher un widget ouvre sa page. Les données propres à un widget (opérations récentes, factures, imports, catégories, Premiers pas) ne sont demandées au serveur que s'il est sur l'Accueil.
4. **Modifier sur place.** « Modifier l'accueil », en haut de l'Accueil, ou un appui long sur un widget, passe en mode modification : la grille se dessine, chaque widget a une poignée pour le glisser vers n'importe quelle case, un bouton de taille, un menu (monter, descendre, gauche, droite, taille — pour le clavier et les lecteurs d'écran) et une croix pour le retirer. « Ajouter un widget » ouvre le catalogue des widgets absents, avec leur aide et le choix de la taille. « Rétablir » propose l'Accueil d'origine ; « Annuler » oublie les changements ; « Terminé » les garde.
5. **Collisions.** Un widget posé ou agrandi sur d'autres les pousse vers le bas ; aucun widget n'en chevauche un autre. Un widget ajouté prend la première place libre, dans l'ordre de lecture.
6. **Gardé sur l'appareil**, comme en 0044 (`UiPrefs`), une disposition par grille : clés `home.2` et `home.4`, sous la forme `type:taille:colonne:ligne,…` (taille `s`, `m` ou `l`). Un grand écran sans disposition reprend celle du téléphone dans l'ordre de lecture, et inversement. Aucune donnée bancaire, rien n'est envoyé au serveur.
7. **Compatibilité.** Le choix de 0044 (clé `home`) est lu une fois : les cartes affichées deviennent des widgets dans leur ordre (Pépite, Premiers pas, Cette semaine et Ce mois-ci en grand, les autres en moyen), les cartes masquées sont absentes. « Premiers pas » masqué avant le reste. Un type inconnu est ignoré, une taille non permise devient la taille habituelle, un widget hors de la grille y est ramené. Un Accueil vidé reste vide et le dit.

## Conséquences

- Aucun changement du serveur ni de la base ; pas de migration.
- `app/lib/state/home_board.dart` (modèle), `app/lib/widgets/home_board_view.dart` (grille et mode modification) ; `home_layout.dart` et l'éditeur de 0044 sont retirés.
- Les tests (`app/test/home_board_test.dart`) couvrent la lecture et l'écriture, la reprise du choix de 0044, le passage d'une grille à l'autre, déplacer, agrandir, ajouter, retirer, glisser, rétablir, annuler, l'Accueil vide, et chaque widget à chaque taille sur un téléphone et un grand écran.
- Une synchronisation de l'Accueil entre appareils pourra venir plus tard, par une nouvelle décision, si l'usage le demande.
