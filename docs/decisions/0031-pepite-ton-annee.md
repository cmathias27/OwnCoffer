# 0031 — Pépite : « Ton année »

**Statut** : Décidé (11 novembre 2026), mis en œuvre en 1.16.0

## Contexte

La décision 0028 (point 7) prévoit **« Ton année avec Pépite »** : en janvier, sur l'année précédente, les semaines faites, les badges gagnés, la catégorie la mieux tenue, les abonnements résiliés et leur économie, les objectifs avancés en %. Calculé par le moteur déterministe, sans classement, sans comparaison avec d'autres personnes, sans jugement ; disponible tout janvier puis rangé dans la page de Pépite.

## Décision

1. **Calculé à la demande** par `PepiteEndpoint.year(année, aujourd'hui)` (`server/lib/src/pepite/pepite_year.dart`), rien n'est stocké en plus, sauf la trace des semaines (point 2). Seulement les actions de la personne et les comptes qu'elle voit.
2. **Semaines** : chaque semaine du rituel comptée est désormais notée (`pepite_marks`, code `week_AAAA`, clé = son lundi). Les semaines comptées avant la 1.16.0 n'ont pas de date : elles sont rangées dans l'année de la première semaine (`firstRitualAt`), ce que la page dit. Pépite étant née en 2026, c'est exact pour toutes les semaines d'avant.
3. **Badges, défis, graines** : badges gagnés dans l'année (`earnedAt`), défis du mois réussis (`doneAt`), graines gagnées = semaines × 10 + badges × 5 + défis × 10 (sans les achats : on parle de ce qui a été gagné).
4. **Objectifs** : pour chaque objectif des groupes de la personne, chaque **mois de budget terminé** de l'année (jour de début du groupe), compté s'il a été posé avant le début du mois ; tenu si la dépense de la catégorie, sur les comptes visibles, n'a pas dépassé l'objectif. Affiché en % (mois tenus / mois suivis) avec les deux nombres. Les montants actuels des objectifs servent pour toute l'année (l'historique de leurs montants n'est pas gardé).
5. **Catégorie la mieux tenue** : celle dont l'objectif a été tenu le plus de mois (à égalité, la meilleure proportion). Aucune sans objectif.
6. **Abonnements arrêtés** : opérations prévues marquées « abonnement » que la personne a supprimées ou dont elle a fixé la fin dans l'année (journal d'audit), une fois chacune ; leur coût mensuel (`monthlyEquivalentCents` de l'état d'avant) et sur un an. C'est le seul montant affiché, et c'est le sien.
7. **Quand** : l'année passée se voit dès le 1er janvier, et reste ensuite dans **Pépite et ma réserve** (une ligne par année depuis 2026). L'année en cours s'y ajoute **dès le 1er décembre** (bilan de fin d'année). En janvier, la carte de Pépite sur l'accueil propose « Ton année ». Le serveur refuse une année pas encore commencée à être close (`pepite_year_invalid` : future, ou en cours avant décembre).
8. **Ton** : aucune comparaison, aucun reproche ; une année vide est dite sans jugement.

## Conséquences

- Nouveau modèle `PepiteYear` (sans table) ; marque `week_AAAA` à chaque semaine comptée (au plus 100 par code, une année en a 53).
- Une lecture d'une année d'opérations par groupe à l'ouverture de la page, pas au démarrage.
- Pas de « catégorie la mieux tenue » sans objectif : l'information n'existe pas, elle n'est pas inventée.
