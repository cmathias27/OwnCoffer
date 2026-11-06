# 0028 — Pépite : conseils, nouveaux badges, graines à dépenser, année et défi du mois

**Statut** : Décidé (6 novembre 2026). Complète la décision 0026 et en modifie un point (les graines se dépensent).

## Contexte

Pépite (décision 0026) n'a que des badges de régularité (premier relevé, semaines 1, 4, 12, 26, 52, un an). L'utilisateur veut davantage de raisons de revenir et de découvrir OwnCoffer : des badges pour les autres fonctions et les bons réflexes, un usage des graines, un bilan annuel et un petit défi chaque mois. Il veut aussi que Pépite **donne des conseils sur l'application**, sa configuration et son fonctionnement.

Les règles de la décision 0026 restent : bienveillant, tutoiement, jamais de reproche, des semaines et pas des séries de jours, messages déterministes jamais écrits par une IA, ton sobre quand un compte passe sous zéro, désactivable, propre à chaque utilisateur.

## Décision

1. **Nouveaux badges**, 5 graines chacun, comme les autres. Tous se calculent à partir de données qui existent déjà ; quand une action n'en laisse pas de trace (revue du mois), sa date est enregistrée.
   - **Découverte** : *Bien rangé* (10 règles de classement), *Voyant* (première échéance prévue saisie), *Archiviste* (10 factures rattachées à une opération), *Maître des prêts* (un prêt avec son tableau d'amortissement), *Chasseur d'abonnements* (tous les abonnements repérés confirmés ou écartés).
   - **Sécurité** : *Coffre-fort* (double authentification), *Pattes de velours* (empreinte ou Windows Hello, décision 0025), *Prévoyant* (première sauvegarde réussie), *Pépite nomade* (première session sur une application, décision 0027), *Vigilant* (réponse à une alerte de connexion, décision 0027).
   - **Rapprochement** : *Au centime près* (solde rapproché avec le relevé), *Bilan du mois* (revue du mois faite trois mois, consécutifs ou non).
   - **Objectifs** : *Premier objectif*, *À mi-chemin* (50 %) et *Objectif atteint* (100 %), mesurés **en pourcentage de l'objectif, jamais en euros** ; *Coup de ciseaux* (un abonnement résilié, Pépite montre l'économie sur un an).
   - **Foyer** : *En équipe* (un membre invité dans son groupe). C'est le badge de la personne qui invite, pas du groupe.
2. **Aucun badge ne dépend du montant** d'un solde, d'un revenu ou d'une épargne.
3. **Les badges à gagner sont visibles en silhouette** dans la page de Pépite, avec un indice (« Rattache des factures… ») : ils font découvrir les fonctions.
4. **Les graines se dépensent** (remplace « la réserve ne se vide jamais » de 0026) : deux compteurs, le **total gagné**, qui ne baisse jamais (affiché, utilisé pour « Ton année » et pour le plafond de `adopt`), et le **solde à dépenser**. Avec ce solde : **accessoires de Pépite** (écharpe, lunettes, bonnet de saison…) et **décor du terrier** (roue, cabane, tournesol…). Catalogue fixe dans l'application (SVG produits comme ceux de Pépite), prix en graines ; l'achat est fait et vérifié par le serveur (solde suffisant, objet existant, pas deux fois). Les graines ne valent toujours rien et ne s'échangent contre rien d'autre.
5. **Quelques objets se gagnent seulement dans l'application** Android ou Windows (« Pépite part en voyage avec toi ») ; une fois acquis, ils se voient partout.
6. **Saisons** : Pépite change de tenue selon la saison et quelques fêtes, gratuitement.
7. **« Ton année avec Pépite »**, en janvier, sur l'année précédente : semaines faites, badges gagnés, catégorie la mieux tenue, abonnements résiliés et leur économie, objectifs avancés (en %). Calculé par le moteur déterministe, sans classement ni comparaison avec d'autres personnes ni jugement. Disponible tout le mois de janvier, puis rangé dans la page de Pépite.
8. **Défi du mois**, facultatif : la personne en choisit un dans une liste fixe (par exemple « Ranger 20 opérations », « Rattacher 5 factures », « Une semaine sans livraison de repas »), mesurable avec ses données. Réussi : **10 graines**. Échoué ou abandonné : rien n'est perdu, aucun message de reproche. Quand un compte est à découvert, seuls les défis qui ne portent pas sur les dépenses sont proposés.
9. **Petites victoires** à l'étape « fêter » du rituel : seulement des progrès réels (« tes courses sont 8 % sous ta moyenne »), calculés par le moteur ; sans progrès, Pépite félicite pour la régularité. Rien de tout cela quand un compte est à découvert.
10. **Désactivable** : les défis et les petites victoires ont chacun leur réglage, en plus de « Afficher Pépite ».
11. **Version autonome** : tout marche de la même façon dans le serveur embarqué ; « Migrer vers un serveur » emporte aussi les objets acquis et le solde à dépenser (plafonné par le total gagné).
12. **Pépite conseille sur l'application** (sa configuration et son fonctionnement, jamais sur l'argent, qui reste à « Mon conseiller », décision 0007). Conseils déterministes, jamais écrits par une IA, textes FR/EN dans `assets/tips/<langue>/` comme l'aide :
    - **« Bien démarrer »** : liste de configuration avec progression (« 6 étapes sur 10 »), chaque étape cochée d'après les données et menant à son écran par « Ouvrir » : premier compte et relevé, règles, échéances prévues, objectif, double authentification, empreinte ou Windows Hello, sauvegarde, application installée, rappel du rituel, membres invités. **Liste à part pour l'administrateur du serveur** : sauvegardes, test de restauration, mises à jour automatiques, invitations, IA facultative, proxy et vraie IP.
    - **« Le savais-tu ? »** : une astuce à la première visite d'un écran, « Compris » ou « En savoir plus » (page d'aide de l'écran). Au plus une par jour ; astuces vues gardées sur le serveur, pour ne pas les revoir sur un autre appareil.
    - **Conseils selon la situation**, un seul à la fois : beaucoup d'opérations à vérifier, même libellé classé trois fois à la main, opération mensuelle sans échéance prévue, compte sans relevé depuis 30 jours, double authentification absente, nouvel appareil (décision 0027) ; pour l'administrateur, aucune sauvegarde réussie depuis 2 jours, nouvelle version. **Action en un geste** quand c'est possible (« Créer la règle », « Ajouter à la prévision ») : Pépite montre ce qui sera créé, l'utilisateur valide, le serveur revérifie et écrit par le service de commandes (décision 0009), annulable.
    - **Astuce de la semaine** à l'étape « fêter ça », choisie parmi les fonctions pas encore utilisées.
    - **« Quoi de neuf ? »** après une mise à jour : les nouveautés de la version (notes de version existantes) en deux ou trois bulles, chacune menant à sa fonction.
    - **« Demande à Pépite »** : recherche par mots dans les pages d'aide intégrées, sans IA ni réseau, avec lien vers l'écran concerné ; marche en version autonome.
    - Réglage **« Afficher les astuces »** séparé de « Afficher Pépite » ; « Pas maintenant » sans relance ni reproche ; aucun montant montré ni jugé ; quand un compte est à découvert, seuls les conseils pratiques restent, sur un ton sobre.
13. **Badges collectifs d'un foyer** (par exemple « toute la famille a fait son rituel ») : **pas décidé**, hors de cette décision. La règle « propre à chaque utilisateur, jamais à un groupe » de 0026 reste valable.

## Conséquences

- Nouvelles tables : objets acquis, défis du mois, dates de revue du mois si besoin ; colonne « solde à dépenser » dans `pepite_progress`. Migrations PostgreSQL et SQLite.
- Le calcul des badges lit plusieurs domaines (règles, factures, prêts, abonnements, objectifs, sécurité, sessions) : le faire en requêtes de comptage, jamais en chargeant l'historique (`performance_test.dart`).
- Les badges *Pépite nomade* et *Vigilant* attendent la mise en œuvre de la décision 0027.
- Des dizaines de nouveaux textes FR/EN et de nouveaux SVG (accessoires, terrier, saisons).
- Nouvelle table pour les astuces vues et les conseils écartés (par utilisateur) ; les conditions des conseils sont des requêtes de comptage, comme les badges.
- Les actions en un geste passent par le service de commandes (décision 0009) : proposition structurée, validation, revérification côté serveur, journal.
- À livrer en plusieurs PR : conseils et « Bien démarrer », nouveaux badges, boutique de graines, puis « Ton année » et défi du mois.
