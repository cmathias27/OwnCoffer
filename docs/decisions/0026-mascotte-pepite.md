# 0026 — Pépite, la mascotte des comptes de la semaine

**Statut** : Décidé (5 novembre 2026), mis en œuvre en 1.6.0

## Contexte

L'utilisateur veut une mascotte « comme Duolingo » : un hamster, très présent, dont le but est de **motiver et de rappeler de faire ses comptes**, en restant vraiment bienveillant. Les comptes ne se font pas tous les jours : le rythme naturel est la semaine (nouveau relevé, vérification, coup d'œil sur la prévision).

Contraintes : aucune télémétrie ni appel réseau non demandé, aucun texte en dur (FR/EN), l'IA ne décide de rien (décision 0006), la version autonome (décision 0022) garde tout sur l'appareil.

## Décision

1. **Pépite, un hamster** dessiné en SVG (quatre poses : content, bravo, salut, sieste), affiché avec `flutter_svg` (MIT). Présent sur la page d'accueil, dans sa page « Pépite et ma réserve » (menu du compte), et en sieste sur l'écran de verrouillage (décision 0025).
2. **Rituel hebdomadaire en 4 étapes**, avec le temps estimé (une dizaine de minutes) : importer les relevés, vérifier les opérations, regarder la prévision, fêter ça. « Ouvrir » mène à la page de l'étape ; une case permet de la cocher sans y aller (pas de nouveau relevé). Les étapes cochées sont gardées sur l'appareil pour la semaine. « Fêter ça » demande au serveur de compter la semaine.
3. **Réserve de graines et badges, sur le serveur** (`PepiteEndpoint`, tables `pepite_progress` et `pepite_badges`, propres à chaque utilisateur, jamais à un groupe) : 10 graines par semaine faite, une seule fois par semaine (lundi à dimanche, date de l'appareil sauf si elle est à plus de 36 h de celle du serveur), 5 par badge (premier relevé, première semaine, 4, 12, 26 et 52 semaines, un an ensemble). La réserve ne se vide jamais.
4. **Des semaines, pas une série de jours** : une semaine manquée n'efface rien ; au retour, Pépite dit simplement qu'il est content de revoir l'utilisateur.
5. **Messages déterministes**, jamais écrits par une IA : choisis d'après les faits (semaine faite ou non, première fois, retour après trois semaines, compte qui passe sous zéro), variés d'une semaine à l'autre et identiques toute la semaine. Tutoiement, toujours encourageants, jamais un reproche ; **ton sobre** quand un compte passe sous zéro (ni bravo ni confettis).
6. **Rappel hebdomadaire** : sur la page d'accueil par défaut, « Plus tard » le masque jusqu'au lendemain sans commentaire. **Notification de l'appareil en option** (désactivée par défaut), jour et heure au choix (dimanche 18 h par défaut), sur Android et Windows seulement (`flutter_local_notifications`, BSD-3-Clause ; `timezone`, BSD-2-Clause) : notifications locales planifiées quatre semaines à l'avance (Windows ne sait pas les répéter), replanifiées à chaque ouverture, la semaine déjà faite sautée. Rien dans le navigateur.
7. **Désactivable** (« Afficher Pépite », réglage de l'appareil) ; la réserve est gardée.
8. **Version autonome** : le même point d'accès tourne dans le serveur embarqué, donc la réserve reste sur l'appareil ; « Migrer vers un serveur » l'emporte (`adopt`), seulement dans un compte qui n'en a pas encore, les graines plafonnées à ce que les semaines et badges ont pu donner.

## Conséquences

- Android : désucrage de la bibliothèque Java (`desugar_jdk_libs`, GPL-2.0 avec l'exception Classpath, comme le JDK), permissions `POST_NOTIFICATIONS` et `RECEIVE_BOOT_COMPLETED`, récepteurs des notifications planifiées ; demande d'autorisation au moment où l'utilisateur active la notification. Notifications « inexactes » (quelques minutes de retard possibles) pour ne pas demander l'autorisation des alarmes exactes.
- Windows : notifications d'une application non empaquetée, à vérifier sur un vrai poste.
- Les heures de notification suivent l'heure de l'appareil au moment de la planification ; un changement d'heure est rattrapé à l'ouverture suivante.
- Les graines ne valent rien et ne s'échangent contre rien : c'est un encouragement, pas une monnaie.
