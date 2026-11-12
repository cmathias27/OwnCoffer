# 0038 — Hors-ligne : saisie sans réseau et envoi au retour du serveur

**Statut** : Décidé (12 novembre 2026), mis en œuvre en 1.23.0. Complète la décision 0037 (point 4).

## Contexte

Depuis la 1.22.0 (0037), les applications Windows et Android connectées à un serveur restent consultables sans réseau, mais en lecture seule. Le cahier des charges demande aussi de **saisir** sans réseau puis de tout synchroniser au retour, sans qu'aucun conflit ne soit perdu en silence. Le besoin courant : noter une dépense en espèces ou un chèque au moment où il est fait, même quand le serveur de la maison est injoignable.

## Décision

1. **Seules les créations d'opérations à la main** sont permises sans réseau. Modifications, suppressions, catégories, pointage, imports restent impossibles hors ligne (ils échouent avec le message réseau ; le bandeau le dit). Aucune donnée existante n'étant changée hors ligne, **aucun conflit ne peut naître** entre deux appareils : pas besoin de versions ni de fusion.
2. **File locale.** Quand le serveur ne peut pas être joint (pas de réseau, délai dépassé, proxy qui répond 502–504 ou 520–530), ou si le bandeau hors ligne est déjà affiché, l'opération saisie va dans une table `outbox` du même fichier que la copie de consultation (chiffré sous Windows, dossier privé sous Android, 0037). Elle porte le compte, son nom (pour l'afficher sans serveur), la date, le montant en centimes, le libellé, le compte utilisateur et un **identifiant créé sur l'appareil** (32 chiffres hexadécimaux aléatoires). Message : « Opération gardée sur l'appareil : elle sera envoyée dès que le serveur répondra. »
3. **Envoi.** Les opérations en attente partent dans l'ordre de saisie : à la connexion, dès qu'une lecture réussit à nouveau (le bandeau disparaît), toutes les 30 secondes tant qu'il en reste, ou à la demande (« Envoyer maintenant »). L'envoi s'arrête à la première qui ne joint pas le serveur ; deux envois simultanés n'en font qu'un.
4. **Idempotence côté serveur.** `transaction.create` accepte un `clientRef` facultatif (16 à 64 caractères `[0-9A-Za-z-]`, sinon refusé). Une colonne `clientRef` et un index unique `(accountId, clientRef)` (migration PostgreSQL et SQLite) font qu'un même identifiant sur le même compte **renvoie l'opération déjà créée** au lieu d'en créer une deuxième, même si la réponse s'est perdue en route ou si deux envois arrivent ensemble. Le contrôle d'accès (`Access.requireAccount`, écriture) passe avant : un autre groupe ne peut ni écrire ni retrouver une opération par son identifiant.
5. **Refus visibles.** Une opération que le serveur refuse (compte supprimé, droits retirés, montant invalide…) n'est pas perdue : elle reste dans la page **« À synchroniser »** avec la raison du refus, jusqu'à ce que l'utilisateur la **renvoie** ou l'**abandonne** (après confirmation). Les suivantes partent quand même. Une ligne sous le bandeau, sur toutes les pages, compte les opérations à envoyer et refusées et ouvre cette page.
6. **Effacement.**
   - Déconnexion choisie ou changement de serveur : si des opérations n'ont pas été envoyées, l'application les nomme et demande avant de les perdre.
   - Session expirée : la copie de consultation s'efface comme avant, mais les opérations en attente restent pour la prochaine connexion **du même compte** ; à la connexion d'un autre compte, celles du précédent sont effacées (elles ne peuvent pas être envoyées sous un autre compte).
   - Clé perdue ou fichier abîmé (0037) : le fichier repart vide, ce qu'il contenait n'est plus lisible.
7. **Pas encore** : les tickets photographiés hors ligne (fichier à envoyer, lecture déjà locale) et le pré-affichage des opérations en attente dans la liste du compte. Ils viendront si l'usage le demande.

## Conséquences

- Aucune dépendance nouvelle, aucun appel réseau supplémentaire hors des envois de l'utilisateur, aucune télémétrie ; l'application web et la version autonome ne sont pas concernées (pas de file : la saisie y marche ou échoue comme avant).
- Pépite et les alertes réagissent à l'opération au moment où le serveur la reçoit.
- `tool/standalone.sh migrations` transmet ses options à `serverpod create-migration` (ici `--force`, l'avertissement portant sur l'index unique d'une colonne nouvelle, vide).
- Tests : serveur (même identifiant non doublé, autre compte, identifiant invalide refusé, isolation entre groupes, lecteur refusé, sur PostgreSQL et SQLite) ; application (envoi unique avec l'identifiant, ordre, arrêt sans réseau, refus gardé puis renvoyé ou abandonné, envoi au retour du serveur, autre compte, fichier chiffré conservé après redémarrage, bandeau, page « À synchroniser », confirmation avant de perdre, saisie réelle depuis Opérations sans réseau).
