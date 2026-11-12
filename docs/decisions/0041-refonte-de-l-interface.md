# 0041 — Refonte de l'interface : rubriques, recherche globale, Mon conseiller en avant

**Statut** : Décidé (12 novembre 2026). Réalisé dans une seule pull request, à la demande de l'utilisateur.

## Contexte

L'application a grandi rubrique par rubrique. Elle compte aujourd'hui :
- 9 rubriques au même niveau ;
- sur téléphone, seulement 4 onglets visibles, le reste caché sous « Plus » ;
- un menu d'une dizaine d'entrées en haut ;
- une fiche crédit d'une dizaine de cartes empilées ;
- une recherche limitée aux opérations d'un seul compte.

« Mon conseiller » n'est accessible que par des liens secondaires. L'utilisateur trouve l'application difficile à lire, à comprendre et à parcourir.

## Décision

### Navigation

1. **Cinq rubriques**, identiques sur tous les écrans (barre du bas sur téléphone, rail sur écran large) :
   - **Accueil** ;
   - **Argent** : comptes et opérations ;
   - **Prévoir** : solde prévu, budget, crédits ;
   - **Papiers** : factures et import ;
   - **Conseiller** : Mon conseiller.

   Chaque rubrique à plusieurs écrans les présente en onglets. Les touches `1` à `5` ouvrent les rubriques sous Windows et sur le web.
2. **Réglages** regroupe les écrans rares : catégories et règles, export, membres, sécurité, applications, administration, Pépite, aide et avis. Le menu du haut ne garde que le foyer, la cloche des notifications, la recherche et Réglages.
3. **Fil d'Ariane** sous la barre du haut, par exemple « Prévoir › Crédits › Maison ». Le retour ramène toujours à l'écran parent.
4. **Bouton « + »** toujours visible, pour saisir une opération, scanner un ticket ou importer un relevé. La touche `N` ouvre une nouvelle opération.

### Recherche globale

5. **Recherche globale** en haut de chaque écran (touche `/`). Elle cherche à la fois :
   - **dans le serveur** (point d'accès `search.global`) : opérations de tous les comptes visibles par l'utilisateur, crédits (prêteur, libellé), factures (fournisseur, nom) et catégories. Au plus 8 résultats par type. Mêmes règles d'accès que chaque écran, avec un test d'isolation. Aucune donnée enregistrée, rien de journalisé ;
   - **dans l'application** : ses fonctions, à partir de leurs libellés traduits et de mots-clés (« exporter », « mot de passe », « membres »…). Ouvrir un résultat ouvre l'écran correspondant.

   Hors ligne, seules les fonctions sont proposées.

### Lisibilité

6. **Accueil « tout va bien ? »** :
   - une phrase de synthèse en haut ;
   - une carte par point à traiter, triée par urgence (solde bas prévu, opérations à classer, échéance de crédit en défaut, hausse d'abonnement, conseil nouveau) ;
   - ce qui va bien est replié ;
   - une carte « Conseils du moment » avec les 3 premiers conseils et « Voir tout ».
7. **Mon conseiller en avant** : une rubrique à part entière, avec un compteur des conseils nouveaux depuis la dernière visite. La date de cette visite est gardée sur l'appareil.
8. **Barre de période commune** (ce mois, mois précédent, 12 mois) et **compte choisi gardé** d'un écran à l'autre. Les deux sont mémorisés sur l'appareil, sans donnée financière.
9. **Fiche crédit en onglets** : Résumé, Échéancier, Opérations, Documents, Simuler. **Budget** : la vue du mois d'abord, l'analyse derrière « Voir le détail ».
10. **Hiérarchie visuelle constante** :
    - un chiffre clé en grand par carte, les explications en petit et en gris ;
    - palette réduite (vert, rouge, gris) ;
    - montants alignés en chiffres tabulaires ;
    - plus d'espace entre les cartes ;
    - mode sombre vérifié écran par écran.
11. **« Pourquoi ce chiffre ? »** : un appui sur un chiffre clé (solde prévu, reste à vivre, total du budget) ouvre le détail du calcul du moteur, comme le fait déjà le conseiller (décision 0007).

### Compréhension

12. **Libellés simples** : par exemple « Solde prévu » plutôt que « Prévisions ». Toujours dans les fichiers FR et EN, jamais en dur.
13. **États vides utiles** : chaque écran vide dit quoi faire, avec le bouton correspondant.
14. **Aide « ? »** sur chaque carte principale, qui ouvre le passage de l'aide correspondant.
15. **Premier lancement guidé** en trois étapes (compte, import, catégories). Le guide disparaît une fois les étapes faites.
16. **Notifications regroupées** dans une cloche unique, avec des filtres : alertes, conseils, système.

### Confort

17. **Mode « simple »** dans les réglages. Il masque les fonctions avancées (règles, catégories communautaires, journal, administration) sans rien désactiver côté serveur.
18. **Grands caractères et contraste renforcé** dans les réglages, gardés sur l'appareil.
19. **Glisser sur une opération**, sur téléphone : vers la droite pour la classer, vers la gauche pour l'ouvrir.
20. **Raccourcis clavier** sous Windows et sur le web : `/` pour chercher, `N` pour une nouvelle opération, `1` à `5` pour les rubriques, `?` pour l'aide des raccourcis.

## Conséquences

- Les écrans existants sont gardés et réorganisés, pas réécrits. Les liens internes (notifications, Pépite, Mon conseiller) suivent les nouvelles rubriques.
- Seul ajout côté serveur : la recherche globale, en lecture seule, avec test d'isolation. Elle tourne sur PostgreSQL et SQLite, avec `LIKE` échappé comme la recherche des opérations, et passe le test de performance sur 100 000 opérations.
- Les préférences d'affichage (période, compte, mode simple, grands caractères, dernière visite du conseiller) restent sur l'appareil, sans donnée bancaire.
- Les tests d'interface existants sont adaptés aux nouvelles rubriques. De nouveaux tests couvrent la navigation, la recherche, l'Accueil et les raccourcis.
