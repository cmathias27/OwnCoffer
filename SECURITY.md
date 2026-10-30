# Politique de sécurité

OwnCoffer manipule des données bancaires : la sécurité est une priorité.

## Signaler une faille

**N'ouvrez pas d'issue publique pour une faille de sécurité.** Utilisez le signalement privé de GitHub : onglet **Security** du dépôt, puis **Report a vulnerability**.

Indiquez si possible :

- la version ou le commit concerné ;
- les étapes pour reproduire ;
- l'impact estimé (accès à des données d'un autre groupe, contournement de la connexion, etc.).

Nous accusons réception sous 7 jours et vous tenons informé jusqu'à la correction. Merci de laisser le temps de publier un correctif avant toute divulgation.

## Versions prises en charge

Le projet est en conception : aucune version n'est encore publiée. À partir de la 1.0, seule la dernière version stable recevra des correctifs de sécurité.

## Principes appliqués

- Permissions vérifiées dans le serveur puis dans PostgreSQL (Row Level Security).
- Mots de passe hachés avec Argon2, double authentification, blocage automatique des IP après plusieurs échecs.
- HTTPS obligatoire pour l'accès extérieur ; base de données jamais exposée.
- Aucune télémétrie ; clés API chiffrées et jamais journalisées.
- Analyse automatique du code et des dépendances (CodeQL, Dependabot).
