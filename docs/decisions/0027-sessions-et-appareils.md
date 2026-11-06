# 0027 — Sessions et appareils : où et depuis quand chacun est connecté

**Statut** : Décidé (6 novembre 2026)

## Contexte

L'utilisateur veut deux choses :

- **Inciter à installer les applications** Android et Windows (décision 0020) : il faut savoir qui n'utilise que le navigateur, pour le lui proposer et pour mesurer l'effet.
- **Un niveau de sécurité** : savoir **où** chaque session est ouverte et **depuis quand**, pouvoir la fermer, et être prévenu d'une connexion inattendue.

Serverpod tient déjà une ligne par session : le jeton de renouvellement (`serverpod_auth_core_jwt_refresh_token`, `createdAt`, `lastUpdatedAt`, durée de vie 30 jours), dont l'identifiant est repris dans chaque jeton d'accès (`authId`). Il ne dit ni l'appareil ni le lieu. L'IP réelle du client est déjà connue côté serveur (`clientIp`, décision 0015).

Contraintes : aucune télémétrie ni appel réseau sortant non demandé, le moins de données personnelles possible (RGPD), la version autonome (décision 0022) n'a qu'un appareil.

## Décision

1. **Une fiche par session** (table `session_device`, sur le serveur seulement), rattachée au jeton de renouvellement : utilisateur, plateforme (`web`, `android`, `windows`), version de l'application, nom d'appareil facultatif et renommable, IP, ville et pays approximatifs, première et dernière activité. On ne garde **pas** le user-agent complet.
2. **L'application se signale** (`presence.ping(plateforme, version)`) au démarrage et au retour au premier plan. La plateforme vient de `kIsWeb` / `defaultTargetPlatform`. La dernière activité, l'IP et le lieu sont mis à jour au plus une fois par heure. « Connecté depuis » = création du jeton de renouvellement.
3. **Lieu par une base GeoIP locale** : DB-IP Lite City (format MMDB, licence CC-BY 4.0, citée dans « À propos »), placée dans l'image Docker au moment de sa construction, donc rafraîchie à chaque version publiée. La recherche se fait dans le serveur, **jamais par un service extérieur**. Sans base, le lieu est « inconnu » et rien n'est bloqué. Le lecteur MMDB doit avoir une licence compatible AGPL-3.0 ; à défaut, un petit lecteur du format ouvert est écrit dans le dépôt.
4. **« Mes sessions »** (Compte → Sécurité) : chaque session avec son icône d'appareil, sa version, sa ville, « connecté depuis », « actif il y a », et « Cette session » signalée. **Déconnecter** une session, ou **toutes les autres**. La personne voit ses IP en entier.
5. **Révocation vérifiée à chaque appel authentifié** : une session fermée est refusée même si son jeton d'accès n'a pas encore expiré. Pour éviter une requête par appel, la liste des sessions fermées est gardée en mémoire (au plus 30 secondes), vidée tout de suite quand la fermeture vient du même serveur (message de révocation de Serverpod). Une session fermée ailleurs est donc refusée en 30 secondes au plus.
6. **L'administrateur voit et ferme** les sessions d'un membre (Administration → Utilisateurs) : plateforme, version, ville, dates, **IP masquée** (`82.64.x.x`). « Déconnecter » et « Tout déconnecter » sont journalisés (`audit_log`), et la personne reçoit une notification dans l'application. L'écran Statistiques montre l'adoption des applications (personnes sur Android, sur Windows, sur le web seulement), calculée depuis la même table.
7. **Alertes** dans l'application, envoyées aux autres sessions de la personne :
   - **nouvel appareil** : première session d'une plateforme et d'une ville jamais vues pour elle ;
   - **pays inhabituel** : pays jamais vu pour elle, alerte mise en évidence.

   « C'est toi ? » → **Oui** (rien de plus) ou **Non, déconnecter** (ferme la session et propose de changer de mot de passe). Les IP bannies (`ip_guard`) sont signalées.
8. **Incitation à installer les applications** par Pépite (décision 0026), seulement pour qui n'a aucune session Android ni Windows : carte d'accueil au plus une fois par semaine, phrase de fin du rituel, page « Applications » illustrée (rappel du rituel, empreinte ou Windows Hello, mode autonome), bandeau sur un navigateur de téléphone (détecté sur place, rien n'est envoyé). « Plus tard » repousse d'une semaine, « Ne plus proposer » arrête pour de bon ; rien de tout cela quand un compte est à découvert. **Badge « Pépite nomade »** (+5 graines) à la première session sur une application.
9. **Conservation** : la fiche vit avec la session, puis **30 jours** après sa fin (expiration ou déconnexion), puis est effacée par la tâche de nettoyage. Elle fait partie de l'export de la personne et disparaît avec son compte.
10. **Version autonome** : pas de fiche, pas de base GeoIP, pas d'alerte (un seul appareil, aucune IP utile). « Mes sessions » n'y est pas affiché.

## Conséquences

- Une table de plus (PostgreSQL et SQLite), une migration, un point d'accès `presence` ; la vérification de révocation touche tous les points d'accès authentifiés : à tester (session fermée refusée, cache vidé) et à mesurer (`performance_test.dart`).
- L'image Docker grossit d'environ 130 Mo ; la CI télécharge la base au moment de la construction (appel réseau de la CI, pas du serveur de l'utilisateur).
- La ville est indicative : derrière un opérateur mobile ou un VPN, elle est souvent fausse ; les messages le disent (« environ »).
- Derrière un proxy mal réglé, toutes les sessions auraient la même IP ; les alertes « nouvel appareil » reposent alors sur la plateforme seule.
- Tests d'isolation : une personne ne voit ni ne ferme les sessions d'une autre ; seul un administrateur du serveur voit celles des membres, IP masquée.
- Le badge « Pépite nomade » s'ajoute aux badges de la décision 0026.
