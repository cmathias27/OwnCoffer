# 0037 — Hors-ligne : consultation sans réseau dans les applications connectées à un serveur

**Statut** : Décidé (11 novembre 2026), première étape mise en œuvre en 1.22.0

## Contexte

Le cahier des charges demande, sur Windows et Android, de « consulter et saisir sans réseau, puis tout synchroniser au retour de la connexion », sans qu'aucun conflit ne soit perdu en silence. La version autonome (0022) travaille déjà sur l'appareil. Restent les applications connectées à un serveur : sans réseau, ou quand le serveur de la maison est éteint, elles n'affichent qu'une erreur. L'application web ne garde aucune donnée financière (0011) et n'est pas concernée.

## Décision

1. **Consultation (cette étape).** Le client Serverpod des applications Windows et Android connectées à un serveur passe par une couche HTTP (`OfflineHttpClient`) :
   - la dernière réponse de chaque **lecture** d'une liste fermée (`offlineReads` : comptes, opérations, catégories, règles, objectifs, prévisions, échéancier, abonnements, analyses et récapitulatif, factures sans leur contenu, crédits, notifications, Pépite…) est gardée sur l'appareil, par appel et par arguments ;
   - quand le serveur est injoignable (pas de réseau, refus de connexion, délai de 10 s dépassé, ou proxy qui répond 502, 503, 504, 520 à 530), la réponse gardée est rendue à la place, et un bandeau au-dessus de toutes les pages dit « Serveur injoignable : données du …, en lecture seule » ;
   - une réponse gardée depuis plus de 30 jours n'est plus montrée et s'efface à l'ouverture ;
   - une **écriture** n'est jamais gardée ni rejouée : sans serveur elle échoue comme avant, avec le message d'erreur réseau. Aucune réponse de refus (403, 400…) ne remplace la copie.
2. **Stockage.** Un fichier SQLite à part dans le dossier privé de l'application, comme la base autonome (0033) : chiffré par SQLite3 Multiple Ciphers sous Windows avec une clé gardée par le système pour ce compte Windows ; sous Android, dossier privé déjà chiffré et fermé aux autres applications. `secure_delete` activé. Ce n'est qu'une copie : clé perdue ou fichier abîmé, il repart vide sans gêner l'application.
3. **Effacement.** Toute la copie s'efface à la déconnexion (ou session expirée) et au changement de serveur : rien de ce qu'un compte a lu ne reste pour le suivant.
4. **Saisie hors ligne (étape suivante).** Seules des créations (opération à la main, ticket) seront permises sans réseau, dans une file locale avec un identifiant créé sur l'appareil, envoyée dans l'ordre au retour du réseau ; le serveur ignorera un identifiant déjà reçu. Un envoi refusé restera visible (« À synchroniser » : Réessayer, Abandonner). Modifications et suppressions resteront impossibles hors ligne, pour qu'aucun conflit ne puisse naître entre deux appareils.

## Conséquences

- Dépendance directe `sqlite3` (MIT), déjà embarquée avec le serveur autonome : rien de nouveau dans l'application.
- Aucun appel réseau supplémentaire, aucune télémétrie ; l'application web inchangée.
- La session n'est pas perdue hors ligne : un renouvellement du jeton qui échoue faute de réseau ne déconnecte pas (comportement de Serverpod).
- Tests : copie rendue hors ligne et après une panne du proxy, écritures jamais gardées, refus sans effet sur la copie, expiration à 30 jours, lecture de la copie par le vrai client Serverpod, fichier chiffré, clé perdue, effacement.
