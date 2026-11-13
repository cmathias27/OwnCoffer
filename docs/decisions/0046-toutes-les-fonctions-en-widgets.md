# 0046 — Toutes les fonctions de l'application en widgets

**Statut**: Décidé (13 novembre 2026), mis en œuvre en 1.31.0. Complète la décision 0045.

## Contexte

La décision 0045 a fait de l'Accueil une grille de widgets: les cartes d'avant et un widget par page. L'utilisateur demande ensuite que **toutes les fonctions de l'application** puissent être mises en widget, pas seulement les pages: saisir une opération, scanner un ticket, les catégories, les règles, le budget, le récapitulatif, la recherche, les réglages, l'aide, etc.

## Décision

1. **Chaque fonction a son widget.** Toutes les fonctions que la recherche globale connaît (décision 0041, point 5) peuvent être posées sur l'Accueil:
   - celles qui avaient déjà un widget le gardent: Comptes, Opérations, À classer, Prévision, Abonnements, Crédits, Factures, Imports, Notifications, Pépite; Mon conseiller est le widget « Conseils du moment », Bien démarrer le widget « Premiers pas »; l'Accueil lui-même n'en a pas;
   - deux nouveaux widgets **vivants**: **Objectifs du budget** (ce qui reste sur les objectifs de dépense du mois, dépensé sur prévu, objectifs dépassés, et en grand les catégories les plus proches de leur limite) et **Récapitulatif** (les 30 prochains jours en bref: point bas, notifications non lues, et en grand les conseils en attente, les hausses d'abonnement et la courbe). Ils mènent au budget et au récapitulatif;
   - des **raccourcis** pour les autres: Rechercher, Saisir une opération, Scanner un ticket, Catégories (avec leur nombre), Règles, Membres, Exporter mes données, Sécurité, Assistant (réglages), Applications, Affichage, Aide, Raccourcis clavier, Donner un avis, Administration du serveur. Un raccourci est petit ou moyen; il montre son icône et ce qu'il fait, et ouvre la fonction d'un toucher, exactement comme la recherche.
2. **Les mêmes droits que la recherche.** Un widget de fonction n'est proposé que si la recherche propose cette fonction à cet utilisateur: l'administration au seul administrateur du serveur, la saisie et le scan à qui peut écrire, les règles hors du mode simple, etc. Un widget gardé sur l'appareil pour une fonction devenue indisponible ne s'affiche pas (seule sa place se voit en mode modification).
3. **Toujours le moteur.** Les chiffres des deux nouveaux widgets viennent des mêmes calculs que leur page (rapport du mois, prévision); les catégories ne sont demandées au serveur que si un widget qui les montre est sur l'Accueil.
4. **Le catalogue en deux parties.** « Ajouter un widget » montre d'abord les **résumés des pages**, puis les **raccourcis vers les fonctions**.
5. **Compatibilité.** Les nouveaux types s'ajoutent à la fin de la liste; les dispositions enregistrées en 1.30.0 restent lues telles quelles (clés `home.2` et `home.4`, décision 0045). L'Accueil d'origine ne change pas.

## Conséquences

- Aucun changement du serveur ni de la base; pas de migration.
- `HomeTileKind` gagne les nouveaux types; `DashboardScreen` reçoit les fonctions permises et de quoi les ouvrir depuis l'écran principal, qui réutilise l'ouverture de la recherche.
- Les tests (`app/test/home_board_test.dart`) couvrent chaque widget à chaque taille, l'ouverture d'une fonction et de la recherche, l'absence d'un widget de fonction non permise, et les chiffres du widget des objectifs du budget.
