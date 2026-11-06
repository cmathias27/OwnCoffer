# 0025 — Verrouillage automatique de l'application

**Statut** : Décidé (5 novembre 2026), mis en œuvre en 1.5.0

## Contexte

Une session OwnCoffer reste ouverte tant que le jeton de rafraîchissement est valable : un téléphone posé, un ordinateur laissé allumé ou un onglet oublié montrent les comptes à qui passe. L'utilisateur demande qu'après une absence l'application se verrouille, avec l'empreinte sur Android et Windows Hello sur Windows quand ils sont disponibles.

Contraintes : rien ne doit casser ce qui est en cours (un import, une lecture de document), la version autonome (décision 0022) n'a pas de mot de passe, et aucun secret de déverrouillage ne doit être gardé sur l'appareil.

## Décision

1. **Verrou local, pas déconnexion.** Après un délai sans toucher, clic ni touche, un écran de verrouillage couvre toutes les pages (y compris la bulle de l'assistant) ; elles restent en mémoire, cachées et sans focus, et ce qui tournait continue. Le temps passé hors de l'application compte comme inactivité.
2. **Désactivé par défaut**, activé par l'utilisateur dans Sécurité. Délai de **15 minutes** par défaut, au choix 5, 15, 30 ou 60 minutes, sans « jamais ». Les réglages appartiennent à l'appareil (stockage sécurisé), pas au compte.
3. **Déverrouillage par le mot de passe du compte**, vérifié par le serveur (`AppLockEndpoint.verifyPassword`) : aucun code local à retenir ni à protéger. La vérification ne crée pas de nouveau jeton (la double authentification reste acquise) et compte dans la limite d'essais de l'adresse e-mail et dans le blocage des adresses IP.
4. **Déverrouillage par l'appareil** (`local_auth`, BSD-3-Clause) : empreinte, visage ou code du téléphone sur Android, Windows Hello (y compris le code PIN Windows) sur Windows. Proposé une fois, après le premier déverrouillage par mot de passe ; désactivable dans Sécurité. Rien sur le web.
5. **Déconnexion complète** (`signOutDevice`) après **5 mots de passe erronés** ou **8 heures** derrière le verrou ; il faut alors se reconnecter avec mot de passe et double authentification. Les échecs et l'heure du verrouillage sont gardés sur l'appareil : recharger la page web ou relancer l'application ne lève pas le verrou.
6. **Version autonome** : pas de mot de passe, donc le verrou de l'appareil est obligatoire pour activer le verrouillage ; ni déconnexion forcée (elle n'apporterait rien, la session est recréée à chaque démarrage). Si l'appareil perd son verrouillage d'écran, le verrouillage de l'application se désactive plutôt que d'enfermer son propriétaire dehors.
7. **Masquage de l'écran en option**, désactivé par défaut (pour garder les captures d'écran) : `FLAG_SECURE` sur Android (aperçu des applications ouvertes et captures), flou sur Windows et le web quand la fenêtre n'est plus active.
8. **Sessions côté serveur** : le jeton de rafraîchissement expire après **30 jours sans utilisation** (au lieu de 14 jours, valeur par défaut de Serverpod) ; le verrou rend cette durée acceptable.

Plus tard : un délai maximum imposé par l'administrateur.

## Conséquences

- Android : `MainActivity` hérite de `FlutterFragmentActivity` et les thèmes d'`AppCompat` (exigés par l'invite d'empreinte) ; le choix du dossier de sauvegarde (`onActivityResult`) est à revérifier sur un vrai téléphone.
- Une page web rechargée hors ligne pendant le verrou reste verrouillée ; sans réseau, le mot de passe ne peut pas être vérifié (message d'erreur, pas un échec compté).
- Le verrou protège contre un passant, pas contre quelqu'un qui a les droits de l'appareil : les jetons restent dans le stockage sécurisé du système.
